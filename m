Return-Path: <SRS0=FhJw=5Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07CDC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 11:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFD3A206DB
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 11:47:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="It7+fPm4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbgCaLrA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Mar 2020 07:47:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22046 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730426AbgCaLrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Mar 2020 07:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585655218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=59KcD0+xU+cL5E7Iig01zIDDPR/sEsb3crhFZN9qybE=;
        b=It7+fPm4MfxzcIyWU8B3fdCkil++SAJa+8kZqnSjgJgf7Pmusetqea8i54K7tFk7LHEynB
        L6Rb77mmAZv5sQS6ZV0/xBJgtIRQ0Fcgg19tKGvDqLs/N2xs+36N6jqNsSK9bHGzIkF2Pa
        dsSukzxFKefZSMs9qM5+G4KAqoeLM48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-okSxoIAKOjuSmEuyIrjWFQ-1; Tue, 31 Mar 2020 07:46:56 -0400
X-MC-Unique: okSxoIAKOjuSmEuyIrjWFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BAEB8010EE;
        Tue, 31 Mar 2020 11:46:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0051D10027B8;
        Tue, 31 Mar 2020 11:46:54 +0000 (UTC)
Date:   Tue, 31 Mar 2020 07:46:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200331114653.GA53541@bfoster>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
 <20200329224602.GT10776@dread.disaster.area>
 <20200330121544.GA45961@bfoster>
 <20200331000409.GY10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331000409.GY10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 31, 2020 at 11:04:09AM +1100, Dave Chinner wrote:
> On Mon, Mar 30, 2020 at 08:15:44AM -0400, Brian Foster wrote:
> > On Mon, Mar 30, 2020 at 09:46:02AM +1100, Dave Chinner wrote:
> > > On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> > > > A dquot flush currently blocks on the buffer lock for the underlying
> > > > dquot buffer. In turn, this causes xfsaild to block rather than
> > > > continue processing other items in the meantime. Update
> > > > xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> > > > are handled, and return -EAGAIN if the lock fails. Fix up any
> > > > callers that don't currently handle the error properly.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_dquot.c      |  6 +++---
> > > >  fs/xfs/xfs_dquot_item.c |  3 ++-
> > > >  fs/xfs/xfs_qm.c         | 14 +++++++++-----
> > > >  3 files changed, 14 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > > index 711376ca269f..af2c8e5ceea0 100644
> > > > --- a/fs/xfs/xfs_dquot.c
> > > > +++ b/fs/xfs/xfs_dquot.c
> > > > @@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
> > > >  	 * Get the buffer containing the on-disk dquot
> > > >  	 */
> > > >  	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
> > > > -				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> > > > -				   &xfs_dquot_buf_ops);
> > > > +				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
> > > > +				   &bp, &xfs_dquot_buf_ops);
> > > >  	if (error)
> > > >  		goto out_unlock;
> > > >  
> > > > @@ -1177,7 +1177,7 @@ xfs_qm_dqflush(
> > > >  
> > > >  out_unlock:
> > > >  	xfs_dqfunlock(dqp);
> > > > -	return -EIO;
> > > > +	return error;
> > > >  }
> > > >  
> > > >  /*
> > > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > > index cf65e2e43c6e..baad1748d0d1 100644
> > > > --- a/fs/xfs/xfs_dquot_item.c
> > > > +++ b/fs/xfs/xfs_dquot_item.c
> > > > @@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
> > > >  		if (!xfs_buf_delwri_queue(bp, buffer_list))
> > > >  			rval = XFS_ITEM_FLUSHING;
> > > >  		xfs_buf_relse(bp);
> > > > -	}
> > > > +	} else if (error == -EAGAIN)
> > > > +		rval = XFS_ITEM_LOCKED;
> > > 
> > > Doesn't xfs_inode_item_push() also have this problem in that it
> > > doesn't handle -EAGAIN properly?
> > > 
> > > Also, we can get -EIO, -EFSCORRUPTED, etc here. They probably
> > > shouldn't return XFS_ITEM_SUCCESS, either....
> > > 
> > 
> > Good point. I'm actually not sure what we should return in that case
> > given the item return codes all seem to assume a valid state. We could
> > define an XFS_ITEM_ERROR return, but I'm not sure it's worth it for what
> > is currently stat/tracepoint logic in the caller.  Perhaps a broader
> > rework of error handling in this context is in order that would lift
> > generic (fatal) error handling into xfsaild.
> 
> Yeah, that's where my thoughts were heading as well.
> 
> > E.g., I see that
> > xfs_qm_dqflush() is inconsistent by itself in that the item is removed
> > from the AIL if we're already shut down, but not if that function
> > invokes the shutdown; we shutdown if the direct xfs_dqblk_verify() call
> > fails but not if the read verifier (which also looks like it calls
> > xfs_dqblk_verify() on every on-disk dquot) returns -EFSCORRUPTED, etc.
> > It might make some sense to let iop_push() return negative error codes
> > if that facilitates consistent error handling...
> 
> Yes, it's a bit of a mess. I suspect that what we should be doing
> here is pulling the failed buffer write retry code up into the main
> push loop. That is, we can set LI_FAILED on log items that fail to
> flush, either directly at submit time, or at IO completion for write
> errors.
> 
> Then we can have the main AIL loop set LI_FAILED on push failures,
> and also the main loop detect LI_FAILED directly and call a new
> ->iop_resubmit() function rather than having to handle that the
> resubmit cases as special cases in every ->iop_push() path.
> 

I'm not sure we want to use LI_FAILED in failure to flush (i.e. push
failure) situations because it's currently used specifically to indicate
that a particular item requires resubmit when it already has been
successfully flushed. This avoids the need for a post I/O error push to
retry an already locked flush lock (and flush attempt) and subsequently
cause the item to remain stuck on the AIL. It still might make sense to
refactor the existing LI_FAILED implementation into ->iop_resubmit()
callbacks for those items that use it, though.

That also doesn't preclude refactoring some sort of generic push failure
error handling into xfsaild for the sake of consistency. It's just not
immediately clear to me what it should look like. Perhaps I'll poke at
it a bit once I get the next rfc of the relog work settled and posted
(soon)..

Brian

> That seems like a much cleaner way of handling submission failure
> and retries for all log item types that need it compared to the way
> we currently handle it for buffers...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

