Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E192BC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE30D20679
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:59:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfJ0SbQ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFCO7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 10:59:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40139 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725954AbgFCO7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 10:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591196342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RGmqERNzExZuqyKtIabRZPgwriIV5VoitdBd5PGr+q4=;
        b=CfJ0SbQ5swcmkm1Y44j5Cgq2Hs3KQcx8QR7y4Lle8/S27XQoZvlmK41zGOBXrDDGWGapDI
        cYgtwqA0GNDHI6yV5WMGR4nPP3tDdRdcy00664qBQUdQ7vRdudN/wkxszLbrAD/N01IU4t
        DzqY13HNviQ4sy5WOdcOBOMKxGRPZDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377--jtS-1WKOimO1lR6O6oHNw-1; Wed, 03 Jun 2020 10:58:57 -0400
X-MC-Unique: -jtS-1WKOimO1lR6O6oHNw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68AB5801503;
        Wed,  3 Jun 2020 14:58:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E9AE9323;
        Wed,  3 Jun 2020 14:58:55 +0000 (UTC)
Date:   Wed, 3 Jun 2020 10:58:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/30] xfs: get rid of log item callbacks
Message-ID: <20200603145854.GF12332@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-13-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:33AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> They are not used anymore, so remove them from the log item and the
> buffer iodone attachment interfaces.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c | 17 -----------------
>  fs/xfs/xfs_buf_item.h |  3 ---
>  fs/xfs/xfs_dquot.c    |  6 +++---
>  fs/xfs/xfs_inode.c    |  5 +++--
>  fs/xfs/xfs_trans.h    |  4 ----
>  5 files changed, 6 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 0ece5de9dd711..09bfe9c52dbdb 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -955,23 +955,6 @@ xfs_buf_item_relse(
>  	xfs_buf_item_free(bip);
>  }
>  
> -
> -/*
> - * Add the given log item with its callback to the list of callbacks
> - * to be called when the buffer's I/O completes.
> - */
> -void
> -xfs_buf_attach_iodone(
> -	struct xfs_buf		*bp,
> -	void			(*cb)(struct xfs_buf *, struct xfs_log_item *),
> -	struct xfs_log_item	*lip)
> -{
> -	ASSERT(xfs_buf_islocked(bp));
> -
> -	lip->li_cb = cb;
> -	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
> -}
> -
>  /*
>   * Invoke the error state callback for each log item affected by the failed I/O.
>   *
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 7c0bd2a210aff..23507cbb4c413 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -54,9 +54,6 @@ void	xfs_buf_item_relse(struct xfs_buf *);
>  bool	xfs_buf_item_put(struct xfs_buf_log_item *);
>  void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
> -void	xfs_buf_attach_iodone(struct xfs_buf *,
> -			      void(*)(struct xfs_buf *, struct xfs_log_item *),
> -			      struct xfs_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
>  void	xfs_buf_dquot_iodone(struct xfs_buf *);
>  void	xfs_buf_iodone(struct xfs_buf *);
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 403bc4e9f21ff..d5984a926d1d0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1187,11 +1187,11 @@ xfs_qm_dqflush(
>  	}
>  
>  	/*
> -	 * Attach an iodone routine so that we can remove this dquot from the
> -	 * AIL and release the flush lock once the dquot is synced to disk.
> +	 * Attach the dquot to the buffer so that we can remove this dquot from
> +	 * the AIL and release the flush lock once the dquot is synced to disk.
>  	 */
>  	bp->b_flags |= _XBF_DQUOTS;
> -	xfs_buf_attach_iodone(bp, NULL, &dqp->q_logitem.qli_item);
> +	list_add_tail(&dqp->q_logitem.qli_item.li_bio_list, &bp->b_li_list);
>  
>  	/*
>  	 * If the buffer is pinned then push on the log so we won't
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1b4e8e0bb0cf0..272b54cf97000 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2709,7 +2709,8 @@ xfs_ifree_cluster(
>  			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  						&iip->ili_item.li_lsn);
>  
> -			xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
> +			list_add_tail(&iip->ili_item.li_bio_list,
> +						&bp->b_li_list);
>  
>  			if (ip != free_ip)
>  				xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -3859,7 +3860,7 @@ xfs_iflush_int(
>  	 * the flush lock.
>  	 */
>  	bp->b_flags |= _XBF_INODES;
> -	xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
> +	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
>  
>  	/* generate the checksum. */
>  	xfs_dinode_calc_crc(mp, dip);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 8308bf6d7e404..99a9ab9cab25b 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -37,10 +37,6 @@ struct xfs_log_item {
>  	unsigned long			li_flags;	/* misc flags */
>  	struct xfs_buf			*li_buf;	/* real buffer pointer */
>  	struct list_head		li_bio_list;	/* buffer item list */
> -	void				(*li_cb)(struct xfs_buf *,
> -						 struct xfs_log_item *);
> -							/* buffer item iodone */
> -							/* callback func */
>  	const struct xfs_item_ops	*li_ops;	/* function list */
>  
>  	/* delayed logging */
> -- 
> 2.26.2.761.g0e0b3e54be
> 

