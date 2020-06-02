Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5991C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 23:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A9DF20663
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 23:03:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Aolan2G4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgFBXDN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:03:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32928 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbgFBXDM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 19:03:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MubLQ066180;
        Tue, 2 Jun 2020 23:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xCA+dZZZdhf3AtJaNCrTW1CqRUX2r4hS/zha4HThT0k=;
 b=Aolan2G4tWiZafk2YmiD/Qze/uVtgnrOFBcEQLWGQwHhLNABYJ98TvDKjTo6KId38Xfw
 LwN6ECkFLiENB2EM4X5iA+uEXhNwBUIC9U7la/Fl9SU3O8mPP8MEc9zneJ1xT1hkp2ru
 tgwfBV6QVmgXMKMU5W4iAjYA5ygGjSpUgLW2gsLwgmwQltuvpwHIKMQpqcrceXjYy6MJ
 GmFIAQm6h+kW+3hJbFZMbbgj/YkKjz69XbN9Cj/4HqU19oPXKvBmb28Yh/xcPba5hK5L
 mm5/yg9zVbL36l9KHTf3UU2zrv2KeoQb1UIySHq2jS5jftmI4Oy97jqnobx23Pj50qcJ GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem6c2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 23:03:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Ms0Yt144210;
        Tue, 2 Jun 2020 23:03:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31dju28f8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 23:03:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052N397D027761;
        Tue, 2 Jun 2020 23:03:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 16:03:08 -0700
Date:   Tue, 2 Jun 2020 16:03:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/30] xfs: attach inodes to the cluster buffer when
 dirtied
Message-ID: <20200602230308.GR8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-26-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-26-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=5
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than attach inodes to the cluster buffer just when we are
> doing IO, attach the inodes to the cluster buffer when they are
> dirtied. The means the buffer always carries a list of dirty inodes
> that reference it, and we can use that list to make more fundamental
> changes to inode writeback that aren't otherwise possible.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks straightforward.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_trans_inode.c |  9 ++++++---
>  fs/xfs/xfs_buf_item.c           |  1 +
>  fs/xfs/xfs_icache.c             |  1 +
>  fs/xfs/xfs_inode.c              | 24 +++++-------------------
>  fs/xfs/xfs_inode_item.c         | 14 ++++++++------
>  5 files changed, 21 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 1e7147b90725e..5e7634c13ce78 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -164,13 +164,16 @@ xfs_trans_log_inode(
>  		/*
>  		 * We need an explicit buffer reference for the log item but
>  		 * don't want the buffer to remain attached to the transaction.
> -		 * Hold the buffer but release the transaction reference.
> +		 * Hold the buffer but release the transaction reference once
> +		 * we've attached the inode log item to the buffer log item
> +		 * list.
>  		 */
>  		xfs_buf_hold(bp);
> -		xfs_trans_brelse(tp, bp);
> -
>  		spin_lock(&iip->ili_lock);
>  		iip->ili_item.li_buf = bp;
> +		bp->b_flags |= _XBF_INODES;
> +		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
> +		xfs_trans_brelse(tp, bp);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 9739d64a46443..6e7a2d460a675 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -465,6 +465,7 @@ xfs_buf_item_unpin(
>  		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
>  			xfs_buf_item_done(bp);
>  			xfs_iflush_done(bp);
> +			ASSERT(list_empty(&bp->b_li_list));
>  		} else {
>  			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
>  			xfs_buf_item_relse(bp);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 4fe6f250e8448..ed386bc930977 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -115,6 +115,7 @@ __xfs_inode_free(
>  {
>  	/* asserts to verify all state is correct here */
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> +	ASSERT(!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list));
>  	XFS_STATS_DEC(ip->i_mount, vn_active);
>  
>  	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index fb4c614c64fda..af65acd24ec4e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2584,27 +2584,24 @@ xfs_ifree_mark_inode_stale(
>  		ASSERT(iip->ili_last_fields);
>  		goto out_iunlock;
>  	}
> -	ASSERT(!iip || list_empty(&iip->ili_item.li_bio_list));
>  
>  	/*
> -	 * Clean inodes can be released immediately.  Everything else has to go
> -	 * through xfs_iflush_abort() on journal commit as the flock
> -	 * synchronises removal of the inode from the cluster buffer against
> -	 * inode reclaim.
> +	 * Inodes not attached to the buffer can be released immediately.
> +	 * Everything else has to go through xfs_iflush_abort() on journal
> +	 * commit as the flock synchronises removal of the inode from the
> +	 * cluster buffer against inode reclaim.
>  	 */
> -	if (xfs_inode_clean(ip)) {
> +	if (!iip || list_empty(&iip->ili_item.li_bio_list)) {
>  		xfs_ifunlock(ip);
>  		goto out_iunlock;
>  	}
>  
>  	/* we have a dirty inode in memory that has not yet been flushed. */
> -	ASSERT(iip->ili_fields);
>  	spin_lock(&iip->ili_lock);
>  	iip->ili_last_fields = iip->ili_fields;
>  	iip->ili_fields = 0;
>  	iip->ili_fsync_fields = 0;
>  	spin_unlock(&iip->ili_lock);
> -	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
>  	ASSERT(iip->ili_last_fields);
>  
>  out_iunlock:
> @@ -3819,19 +3816,8 @@ xfs_iflush_int(
>  	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  				&iip->ili_item.li_lsn);
>  
> -	/*
> -	 * Attach the inode item callback to the buffer whether the flush
> -	 * succeeded or not. If not, the caller will shut down and fail I/O
> -	 * completion on the buffer to remove the inode from the AIL and release
> -	 * the flush lock.
> -	 */
> -	bp->b_flags |= _XBF_INODES;
> -	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
> -
>  	/* generate the checksum. */
>  	xfs_dinode_calc_crc(mp, dip);
> -
> -	ASSERT(!list_empty(&bp->b_li_list));
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 0a7720b7a821a..66675b75de3ec 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -665,10 +665,7 @@ xfs_inode_item_destroy(
>   *
>   * Note: Now that we attach the log item to the buffer when we first log the
>   * inode in memory, we can have unflushed inodes on the buffer list here. These
> - * inodes will have a zero ili_last_fields, so skip over them here. We do
> - * this check -after- we've checked for stale inodes, because we're guaranteed
> - * to have XFS_ISTALE set in the case that dirty inodes are in the CIL and have
> - * not yet had their dirtying transactions committed to disk.
> + * inodes will have a zero ili_last_fields, so skip over them here.
>   */
>  void
>  xfs_iflush_done(
> @@ -686,8 +683,8 @@ xfs_iflush_done(
>  	 */
>  	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
>  		iip = INODE_ITEM(lip);
> +
>  		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> -			list_del_init(&lip->li_bio_list);
>  			xfs_iflush_abort(iip->ili_inode);
>  			continue;
>  		}
> @@ -740,12 +737,16 @@ xfs_iflush_done(
>  		/*
>  		 * Remove the reference to the cluster buffer if the inode is
>  		 * clean in memory. Drop the buffer reference once we've dropped
> -		 * the locks we hold.
> +		 * the locks we hold. If the inode is dirty in memory, we need
> +		 * to put the inode item back on the buffer list for another
> +		 * pass through the flush machinery.
>  		 */
>  		ASSERT(iip->ili_item.li_buf == bp);
>  		if (!iip->ili_fields) {
>  			iip->ili_item.li_buf = NULL;
>  			drop_buffer = true;
> +		} else {
> +			list_add(&lip->li_bio_list, &bp->b_li_list);
>  		}
>  		iip->ili_last_fields = 0;
>  		iip->ili_flush_lsn = 0;
> @@ -789,6 +790,7 @@ xfs_iflush_abort(
>  		iip->ili_flush_lsn = 0;
>  		bp = iip->ili_item.li_buf;
>  		iip->ili_item.li_buf = NULL;
> +		list_del_init(&iip->ili_item.li_bio_list);
>  		spin_unlock(&iip->ili_lock);
>  	}
>  	xfs_ifunlock(ip);
> -- 
> 2.26.2.761.g0e0b3e54be
> 
