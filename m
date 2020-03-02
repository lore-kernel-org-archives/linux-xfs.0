Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB24C3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 19:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A79922072A
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 19:00:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CsVioX7L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCBTAl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 14:00:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgCBTAl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 14:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583175639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QKnRCQGNr9KM+nn/BwW8pU5CYU/JG0VEx1WmPA+uueA=;
        b=CsVioX7LlgPzKzpCwWXRACVctRQXzLSBhE5seIXi9ox3GhrVHOGBrB+y9RwZ+AnMCL7lbn
        dogghbydI6sqDgS+RCwOR6MGi9HPh6/Ec+8aphY3lfXxzFEaRjujaJ3I+fE78PCKbRqNqt
        IczhP0jQcPStTUbKTPHvVxmXgHki1oQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-ryWmKSLMO1-SIJTxM3mpuA-1; Mon, 02 Mar 2020 14:00:37 -0500
X-MC-Unique: ryWmKSLMO1-SIJTxM3mpuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7B7F8017DF;
        Mon,  2 Mar 2020 19:00:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 77FC890CEE;
        Mon,  2 Mar 2020 19:00:36 +0000 (UTC)
Date:   Mon, 2 Mar 2020 14:00:34 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 7/9] xfs: buffer relogging support prototype
Message-ID: <20200302190034.GE10946@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-8-bfoster@redhat.com>
 <20200302074728.GM10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302074728.GM10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 06:47:28PM +1100, Dave Chinner wrote:
> On Thu, Feb 27, 2020 at 08:43:19AM -0500, Brian Foster wrote:
> > Add a quick and dirty implementation of buffer relogging support.
> > There is currently no use case for buffer relogging. This is for
> > experimental use only and serves as an example to demonstrate the
> > ability to relog arbitrary items in the future, if necessary.
> > 
> > Add a hook to enable relogging a buffer in a transaction, update the
> > buffer log item handlers to support relogged BLIs and update the
> > relog handler to join the relogged buffer to the relog transaction.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> .....
> >  /*
> > @@ -187,9 +188,21 @@ xfs_ail_relog(
> >  			xfs_log_ticket_put(ailp->ail_relog_tic);
> >  		spin_unlock(&ailp->ail_lock);
> >  
> > -		xfs_trans_add_item(tp, lip);
> > -		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > -		tp->t_flags |= XFS_TRANS_DIRTY;
> > +		/*
> > +		 * TODO: Ideally, relog transaction management would be pushed
> > +		 * down into the ->iop_push() callbacks rather than playing
> > +		 * games with ->li_trans and looking at log item types here.
> > +		 */
> > +		if (lip->li_type == XFS_LI_BUF) {
> > +			struct xfs_buf_log_item	*bli = (struct xfs_buf_log_item *) lip;
> > +			xfs_buf_hold(bli->bli_buf);
> 
> What is this for? The bli already has a reference to the buffer.
> 

The buffer reference is for the transaction. It is analogous to the
reference acquired in xfs_buf_find() via xfs_trans_[get|read]_buf(), for
example.

> > +			xfs_trans_bjoin(tp, bli->bli_buf);
> > +			xfs_trans_dirty_buf(tp, bli->bli_buf);
> > +		} else {
> > +			xfs_trans_add_item(tp, lip);
> > +			set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > +			tp->t_flags |= XFS_TRANS_DIRTY;
> > +		}
> 
> Really, this should be a xfs_item_ops callout. i.e.
> 
> 		lip->li_ops->iop_relog(lip);
> 

Yeah, I've already done pretty much this in my local tree. The callback
also takes the transaction because that's the code that knows how to add
a particular type of item to a transaction. I didn't require a callback
for the else case above where no special handling is required
(quotaoff), so the callback is optional, but I'm not opposed to
reworking things such that ->iop_relog() is always required if that is
preferred.

> And then a) it doesn't matter really where we call it from, and b)
> it becomes fully generic and we can implement the callout
> as future functionality requires.
> 

Yep.

Brian

> However, we have to make sure that the current transaction we are
> running has the correct space usage accounted to it, so I think this
> callout really does need to be done in a tight loop iterating and
> accounting all the relog items into the transaction without outside
> interference.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

