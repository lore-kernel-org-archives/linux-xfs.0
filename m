Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B56C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DECA320738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NBWy8mWI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgFBQdH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:33:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44504 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725969AbgFBQdH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 12:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591115584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=upiO+GrhQdzhF3R1qITNJxXkuHZRud4MbZY5QwjPhtE=;
        b=NBWy8mWIz7v5rZ4WUmJfRkbMgCVVizPNyty1lnw6diUo9B1B1oLVTWhgKJdm8KX76vF46d
        HpYQ45xzo4nA+igJg3GdZAd3ru/lkB1x4nHBPnoW0PgLlBFHWh0T4IZQaBo08IUbMxsroL
        wcdo63br2CdYFS59shWF4OMj6laXNaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-V31CKiJaMueaX1nZbCE2KQ-1; Tue, 02 Jun 2020 12:33:03 -0400
X-MC-Unique: V31CKiJaMueaX1nZbCE2KQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BC251883602;
        Tue,  2 Jun 2020 16:33:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B551A2C26C;
        Tue,  2 Jun 2020 16:33:01 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:32:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/30] xfs: remove logged flag from inode log item
Message-ID: <20200602163259.GB7967@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-3-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:23AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This was used to track if the item had logged fields being flushed
> to disk. We log everything in the inode these days, so this logic is
> no longer needed. Remove it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c      | 13 ++++---------
>  fs/xfs/xfs_inode_item.c | 35 ++++++++++-------------------------
>  fs/xfs/xfs_inode_item.h |  1 -
>  3 files changed, 14 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 53a1d64782c35..4fa12775ac146 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2677,7 +2677,6 @@ xfs_ifree_cluster(
>  		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
>  			if (lip->li_type == XFS_LI_INODE) {
>  				iip = (struct xfs_inode_log_item *)lip;
> -				ASSERT(iip->ili_logged == 1);
>  				lip->li_cb = xfs_istale_done;
>  				xfs_trans_ail_copy_lsn(mp->m_ail,
>  							&iip->ili_flush_lsn,
> @@ -2706,7 +2705,6 @@ xfs_ifree_cluster(
>  			iip->ili_last_fields = iip->ili_fields;
>  			iip->ili_fields = 0;
>  			iip->ili_fsync_fields = 0;
> -			iip->ili_logged = 1;
>  			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  						&iip->ili_item.li_lsn);
>  
> @@ -3838,19 +3836,16 @@ xfs_iflush_int(
>  	 *
>  	 * We can play with the ili_fields bits here, because the inode lock
>  	 * must be held exclusively in order to set bits there and the flush
> -	 * lock protects the ili_last_fields bits.  Set ili_logged so the flush
> -	 * done routine can tell whether or not to look in the AIL.  Also, store
> -	 * the current LSN of the inode so that we can tell whether the item has
> -	 * moved in the AIL from xfs_iflush_done().  In order to read the lsn we
> -	 * need the AIL lock, because it is a 64 bit value that cannot be read
> -	 * atomically.
> +	 * lock protects the ili_last_fields bits.  Store the current LSN of the
> +	 * inode so that we can tell whether the item has moved in the AIL from
> +	 * xfs_iflush_done().  In order to read the lsn we need the AIL lock,
> +	 * because it is a 64 bit value that cannot be read atomically.
>  	 */
>  	error = 0;
>  flush_out:
>  	iip->ili_last_fields = iip->ili_fields;
>  	iip->ili_fields = 0;
>  	iip->ili_fsync_fields = 0;
> -	iip->ili_logged = 1;
>  
>  	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  				&iip->ili_item.li_lsn);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index ba47bf65b772b..b17384aa8df40 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -528,8 +528,6 @@ xfs_inode_item_push(
>  	}
>  
>  	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> -	ASSERT(iip->ili_logged == 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> -
>  	spin_unlock(&lip->li_ailp->ail_lock);
>  
>  	error = xfs_iflush(ip, &bp);
> @@ -690,30 +688,24 @@ xfs_iflush_done(
>  			continue;
>  
>  		list_move_tail(&blip->li_bio_list, &tmp);
> -		/*
> -		 * while we have the item, do the unlocked check for needing
> -		 * the AIL lock.
> -		 */
> +
> +		/* Do an unlocked check for needing the AIL lock. */
>  		iip = INODE_ITEM(blip);
> -		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
> +		if (blip->li_lsn == iip->ili_flush_lsn ||
>  		    test_bit(XFS_LI_FAILED, &blip->li_flags))
>  			need_ail++;
>  	}
>  
>  	/* make sure we capture the state of the initial inode. */
>  	iip = INODE_ITEM(lip);
> -	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
> +	if (lip->li_lsn == iip->ili_flush_lsn ||
>  	    test_bit(XFS_LI_FAILED, &lip->li_flags))
>  		need_ail++;
>  
>  	/*
> -	 * We only want to pull the item from the AIL if it is
> -	 * actually there and its location in the log has not
> -	 * changed since we started the flush.  Thus, we only bother
> -	 * if the ili_logged flag is set and the inode's lsn has not
> -	 * changed.  First we check the lsn outside
> -	 * the lock since it's cheaper, and then we recheck while
> -	 * holding the lock before removing the inode from the AIL.
> +	 * We only want to pull the item from the AIL if it is actually there
> +	 * and its location in the log has not changed since we started the
> +	 * flush.  Thus, we only bother if the inode's lsn has not changed.
>  	 */
>  	if (need_ail) {
>  		xfs_lsn_t	tail_lsn = 0;
> @@ -721,8 +713,7 @@ xfs_iflush_done(
>  		/* this is an opencoded batch version of xfs_trans_ail_delete */
>  		spin_lock(&ailp->ail_lock);
>  		list_for_each_entry(blip, &tmp, li_bio_list) {
> -			if (INODE_ITEM(blip)->ili_logged &&
> -			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
> +			if (blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
>  				/*
>  				 * xfs_ail_update_finish() only cares about the
>  				 * lsn of the first tail item removed, any
> @@ -740,14 +731,13 @@ xfs_iflush_done(
>  	}
>  
>  	/*
> -	 * clean up and unlock the flush lock now we are done. We can clear the
> +	 * Clean up and unlock the flush lock now we are done. We can clear the
>  	 * ili_last_fields bits now that we know that the data corresponding to
>  	 * them is safely on disk.
>  	 */
>  	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
>  		list_del_init(&blip->li_bio_list);
>  		iip = INODE_ITEM(blip);
> -		iip->ili_logged = 0;
>  		iip->ili_last_fields = 0;
>  		xfs_ifunlock(iip->ili_inode);
>  	}
> @@ -768,16 +758,11 @@ xfs_iflush_abort(
>  
>  	if (iip) {
>  		xfs_trans_ail_delete(&iip->ili_item, 0);
> -		iip->ili_logged = 0;
> -		/*
> -		 * Clear the ili_last_fields bits now that we know that the
> -		 * data corresponding to them is safely on disk.
> -		 */
> -		iip->ili_last_fields = 0;
>  		/*
>  		 * Clear the inode logging fields so no more flushes are
>  		 * attempted.
>  		 */
> +		iip->ili_last_fields = 0;
>  		iip->ili_fields = 0;
>  		iip->ili_fsync_fields = 0;
>  	}
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 60b34bb66e8ed..4de5070e07655 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -19,7 +19,6 @@ struct xfs_inode_log_item {
>  	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
>  	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
>  	unsigned short		ili_lock_flags;	   /* lock flags */
> -	unsigned short		ili_logged;	   /* flushed logged data */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
>  	unsigned int		ili_fields;	   /* fields to be logged */
>  	unsigned int		ili_fsync_fields;  /* logged since last fsync */
> -- 
> 2.26.2.761.g0e0b3e54be
> 

