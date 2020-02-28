Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE63EC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A403B2051A
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g+m0voa7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgB1OEu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 09:04:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35437 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725892AbgB1OEu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 09:04:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582898688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tzg5Co8reKLADuR67CpcF/QGLsZxJfRIR3q8hBYs/jk=;
        b=g+m0voa7xDYHkvhQvkE7pcLxX30WeMb9qEo+elyXdBXxqa96gxupGpTy8DQ095k5jNPlnN
        AcIr8F7HTwKQcheba0VkqJzDJ/HNbM4n4ZfeL/HD6gTSjgrldpIjAAcszWp3RpITvHPXpI
        gPacRIsZI8x65ZSZopRTDYLV/aiofhQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-GeBMxJ4rOtqDFvC33MprXw-1; Fri, 28 Feb 2020 09:04:45 -0500
X-MC-Unique: GeBMxJ4rOtqDFvC33MprXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B479DB60;
        Fri, 28 Feb 2020 14:04:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F51A60C18;
        Fri, 28 Feb 2020 14:04:43 +0000 (UTC)
Date:   Fri, 28 Feb 2020 09:04:41 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 7/9] xfs: buffer relogging support prototype
Message-ID: <20200228140441.GG2751@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-8-bfoster@redhat.com>
 <12e69f70-13e6-830c-83ef-9ad5b222301e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12e69f70-13e6-830c-83ef-9ad5b222301e@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 04:33:26PM -0700, Allison Collins wrote:
> On 2/27/20 6:43 AM, Brian Foster wrote:
> > Add a quick and dirty implementation of buffer relogging support.
> > There is currently no use case for buffer relogging. This is for
> > experimental use only and serves as an example to demonstrate the
> > ability to relog arbitrary items in the future, if necessary.
> > 
> > Add a hook to enable relogging a buffer in a transaction, update the
> > buffer log item handlers to support relogged BLIs and update the
> > relog handler to join the relogged buffer to the relog transaction.
> > 
> Alrighty, thanks for the example!  It sounds like it's meant more to be a
> demo than to really be applied though?
> 

Yeah, I just wanted to include something that demonstrates how this can
be used for something other than intents, because that concern was
raised on previous versions...

Brian

> Allison
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >   fs/xfs/xfs_buf_item.c  |  5 +++++
> >   fs/xfs/xfs_trans.h     |  1 +
> >   fs/xfs/xfs_trans_ail.c | 19 ++++++++++++++++---
> >   fs/xfs/xfs_trans_buf.c | 22 ++++++++++++++++++++++
> >   4 files changed, 44 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 663810e6cd59..4ef2725fa8ce 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -463,6 +463,7 @@ xfs_buf_item_unpin(
> >   			list_del_init(&bp->b_li_list);
> >   			bp->b_iodone = NULL;
> >   		} else {
> > +			xfs_trans_relog_item_cancel(lip, false);
> >   			spin_lock(&ailp->ail_lock);
> >   			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
> >   			xfs_buf_item_relse(bp);
> > @@ -528,6 +529,9 @@ xfs_buf_item_push(
> >   		return XFS_ITEM_LOCKED;
> >   	}
> > +	if (test_bit(XFS_LI_RELOG, &lip->li_flags))
> > +		return XFS_ITEM_RELOG;
> > +
> >   	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
> >   	trace_xfs_buf_item_push(bip);
> > @@ -956,6 +960,7 @@ STATIC void
> >   xfs_buf_item_free(
> >   	struct xfs_buf_log_item	*bip)
> >   {
> > +	ASSERT(!test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags));
> >   	xfs_buf_item_free_format(bip);
> >   	kmem_free(bip->bli_item.li_lv_shadow);
> >   	kmem_cache_free(xfs_buf_item_zone, bip);
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 1637df32c64c..81cb42f552d9 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -226,6 +226,7 @@ void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
> >   void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
> >   bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
> >   void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
> > +bool		xfs_trans_relog_buf(struct xfs_trans *, struct xfs_buf *);
> >   void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
> >   void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
> >   void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 71a47faeaae8..103ab62e61be 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -18,6 +18,7 @@
> >   #include "xfs_error.h"
> >   #include "xfs_log.h"
> >   #include "xfs_log_priv.h"
> > +#include "xfs_buf_item.h"
> >   #ifdef DEBUG
> >   /*
> > @@ -187,9 +188,21 @@ xfs_ail_relog(
> >   			xfs_log_ticket_put(ailp->ail_relog_tic);
> >   		spin_unlock(&ailp->ail_lock);
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
> > +			xfs_trans_bjoin(tp, bli->bli_buf);
> > +			xfs_trans_dirty_buf(tp, bli->bli_buf);
> > +		} else {
> > +			xfs_trans_add_item(tp, lip);
> > +			set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > +			tp->t_flags |= XFS_TRANS_DIRTY;
> > +		}
> >   		/* XXX: include ticket owner task fix */
> >   		error = xfs_trans_roll(&tp);
> >   		ASSERT(!error);
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index 08174ffa2118..e17715ac23fc 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -787,3 +787,25 @@ xfs_trans_dquot_buf(
> >   	xfs_trans_buf_set_type(tp, bp, type);
> >   }
> > +
> > +/*
> > + * Enable automatic relogging on a buffer. This essentially pins a dirty buffer
> > + * in-core until relogging is disabled. Note that the buffer must not already be
> > + * queued for writeback.
> > + */
> > +bool
> > +xfs_trans_relog_buf(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> > +
> > +	ASSERT(tp->t_flags & XFS_TRANS_RELOG);
> > +	ASSERT(xfs_buf_islocked(bp));
> > +
> > +	if (bp->b_flags & _XBF_DELWRI_Q)
> > +		return false;
> > +
> > +	xfs_trans_relog_item(&bip->bli_item);
> > +	return true;
> > +}
> > 
> 

