Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7071C001DB
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jul 2023 23:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjGEXhi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 19:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjGEXhi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 19:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A591995
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 16:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E37561852
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 23:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE38C433C7;
        Wed,  5 Jul 2023 23:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688600255;
        bh=MAEPgaR64JUfY/mVhGNzDCyhXdQ2OLr/KLKfEAcmrlU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gy14gjwXKc6EN3SWR9OlZqtEJVAdKFhe9bpGLkW6tLFuXaX4T615o3dW7198Aa4Rr
         6SloqLhzK686Jin3PYJz5vAtompRa5ViH95hiaKXU2nzB88bnd9W6RyaLO3T+ooS3X
         kzIKhJJJhiat2Gk4Ss2XXk61lPBWVpwoC18/k3xFg6+vINL+1bwG4v/BU414WW+mtg
         REXUTpZQ04o9ht5fyHcT6Axom7lmINWth9sCKPfWZJH+PyE5NHrjt8nCMATQjfICSe
         7Ic0t8pwXpAsS2ncrXqMgTYFJYnTWXqwGSHzlGlJrr5+9hNdyVynqy9Iz4WhHu7rTa
         wC4mv46inkgkg==
Date:   Wed, 5 Jul 2023 16:37:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <20230705233735.GU11441@frogsfrogsfrogs>
References: <168506056054.3728458.14583795170430652277.stgit@frogsfrogsfrogs>
 <168506056076.3728458.7329874829310609452.stgit@frogsfrogsfrogs>
 <ZJJa7Cnni0mb/9sN@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJJa7Cnni0mb/9sN@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 21, 2023 at 12:05:32PM +1000, Dave Chinner wrote:
> On Thu, May 25, 2023 at 05:45:35PM -0700, Darrick J. Wong wrote:
> > @@ -2112,6 +2112,37 @@ xfs_buf_delwri_queue(
> >  	return true;
> >  }
> >  
> > +/*
> > + * Queue a buffer to this delwri list as part of a data integrity operation.
> > + * If the buffer is on any other delwri list, we'll wait for that to clear
> > + * so that the caller can submit the buffer for IO and wait for the result.
> > + * Callers must ensure the buffer is not already on the list.
> > + */
> > +void
> > +xfs_buf_delwri_queue_here(
> 
> This is more of an "exclusive" queuing semantic. i.e. queue this
> buffer exclusively on the list provided, rather than just ensuring
> it is queued on some delwri list....
> 
> > +	struct xfs_buf		*bp,
> > +	struct list_head	*buffer_list)
> > +{
> > +	/*
> > +	 * We need this buffer to end up on the /caller's/ delwri list, not any
> > +	 * old list.  This can happen if the buffer is marked stale (which
> > +	 * clears DELWRI_Q) after the AIL queues the buffer to its list but
> > +	 * before the AIL has a chance to submit the list.
> > +	 */
> > +	while (!list_empty(&bp->b_list)) {
> > +		xfs_buf_unlock(bp);
> > +		delay(1);
> > +		xfs_buf_lock(bp);
> > +	}
> 
> Not a big fan of this as it the buffer can be on the AIL buffer list
> for some time (e.g. AIL might have a hundred thousand buffers to
> push).
> 
> This seems more like a case for:
> 
> 	while (!list_empty(&bp->b_list)) {
> 		xfs_buf_unlock(bp);
> 		wait_event_var(bp->b_flags, !(bp->b_flags & _XBF_DELWRI_Q));
> 		xfs_buf_lock(bp);
> 	}
> 
> And a wrapper:
> 
> void xfs_buf_remove_delwri(
> 	struct xfs_buf	*bp)
> {
> 	list_del(&bp->b_list);
> 	bp->b_flags &= ~_XBF_DELWRI_Q;
> 	wake_up_var(bp->b_flags);
> }
> 
> And we replace all the places where the buffer is taken off the
> delwri list with calls to xfs_buf_remove_delwri()...
> 
> This will greatly reduce the number of context switches during a
> wait cycle, and reduce the latency of waiting for buffers that are
> queued for delwri...

The thing is, we're really waiting for the buffer to clear /all/
delwri-related lists.  This could be the actual buffer list, but it
could also be the xfs_buf_delwri_submit's wait_list.  It's not
sufficient for repair to allow some other (probably the AIL) thread to
write the new structure's buffer because that caller could see an
EIO/ENOSPC error, and repair needs to return the specific condition to
the caller.

That said, I suppose we could spring a wait_var_event on bp->b_list.next
to look for list_empty(&bp->b_list).  I'll try that out tonight.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
