Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121D4C3F2CD
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 14:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA9E20838
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 14:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X8m+LSfz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgCCOOx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 09:14:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48170 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726536AbgCCOOx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 09:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583244892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R0n8IgnP93yA10HqFmuA2ziM4zOme8UuuJQ1XWqGXbg=;
        b=X8m+LSfzP/hMwZ+/Un4DhRkzkdaLKL6TLdty6l4AVSEI1v65E/QiCRsa1mgB0uBDGHga9a
        psyM9a+gNsPAssVJlU0/IMF9lyoUCq0kNQWgz5f3gw+UsbBQ5gsb7bYcznxwFkbZG2qkEr
        3st/z240+OSQpWmyTF97+2u6QqNkPqo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-0q_qIxrhPj6DrIQk--AQLw-1; Tue, 03 Mar 2020 09:14:50 -0500
X-MC-Unique: 0q_qIxrhPj6DrIQk--AQLw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A9A18FE867;
        Tue,  3 Mar 2020 14:14:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 969405D9C9;
        Tue,  3 Mar 2020 14:14:49 +0000 (UTC)
Date:   Tue, 3 Mar 2020 09:14:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 7/9] xfs: buffer relogging support prototype
Message-ID: <20200303141447.GC15955@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-8-bfoster@redhat.com>
 <20200302074728.GM10776@dread.disaster.area>
 <20200302190034.GE10946@bfoster>
 <20200303000909.GP10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303000909.GP10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 11:09:09AM +1100, Dave Chinner wrote:
> On Mon, Mar 02, 2020 at 02:00:34PM -0500, Brian Foster wrote:
> > On Mon, Mar 02, 2020 at 06:47:28PM +1100, Dave Chinner wrote:
> > > On Thu, Feb 27, 2020 at 08:43:19AM -0500, Brian Foster wrote:
> > > > Add a quick and dirty implementation of buffer relogging support.
> > > > There is currently no use case for buffer relogging. This is for
> > > > experimental use only and serves as an example to demonstrate the
> > > > ability to relog arbitrary items in the future, if necessary.
> > > > 
> > > > Add a hook to enable relogging a buffer in a transaction, update the
> > > > buffer log item handlers to support relogged BLIs and update the
> > > > relog handler to join the relogged buffer to the relog transaction.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > .....
> > > >  /*
> > > > @@ -187,9 +188,21 @@ xfs_ail_relog(
> > > >  			xfs_log_ticket_put(ailp->ail_relog_tic);
> > > >  		spin_unlock(&ailp->ail_lock);
> > > >  
> > > > -		xfs_trans_add_item(tp, lip);
> > > > -		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > > > -		tp->t_flags |= XFS_TRANS_DIRTY;
> > > > +		/*
> > > > +		 * TODO: Ideally, relog transaction management would be pushed
> > > > +		 * down into the ->iop_push() callbacks rather than playing
> > > > +		 * games with ->li_trans and looking at log item types here.
> > > > +		 */
> > > > +		if (lip->li_type == XFS_LI_BUF) {
> > > > +			struct xfs_buf_log_item	*bli = (struct xfs_buf_log_item *) lip;
> > > > +			xfs_buf_hold(bli->bli_buf);
> > > 
> > > What is this for? The bli already has a reference to the buffer.
> > > 
> > 
> > The buffer reference is for the transaction. It is analogous to the
> > reference acquired in xfs_buf_find() via xfs_trans_[get|read]_buf(), for
> > example.
> 
> Ah. Comment please :P
> 

Sure.

> > > > +			xfs_trans_bjoin(tp, bli->bli_buf);
> > > > +			xfs_trans_dirty_buf(tp, bli->bli_buf);
> > > > +		} else {
> > > > +			xfs_trans_add_item(tp, lip);
> > > > +			set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > > > +			tp->t_flags |= XFS_TRANS_DIRTY;
> > > > +		}
> > > 
> > > Really, this should be a xfs_item_ops callout. i.e.
> > > 
> > > 		lip->li_ops->iop_relog(lip);
> > > 
> > 
> > Yeah, I've already done pretty much this in my local tree. The callback
> > also takes the transaction because that's the code that knows how to add
> > a particular type of item to a transaction. I didn't require a callback
> > for the else case above where no special handling is required
> > (quotaoff), so the callback is optional, but I'm not opposed to
> > reworking things such that ->iop_relog() is always required if that is
> > preferred.
> 
> I think I'd prefer to keep things simple right now. Making it an
> unconditional callout keeps this code simple, and if there's a
> common implementation, add a generic function for it that the items
> use.
> 

Fine by me, will fix.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

