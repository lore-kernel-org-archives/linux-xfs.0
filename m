Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AB5C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 17:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B69120787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 17:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rk4n1XRF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgD3R23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 13:28:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3R22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 13:28:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UHMqeG192664;
        Thu, 30 Apr 2020 17:28:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bsJM76EB7CDXPyWZ/GAJkRnwUHiBIaoFK9ZIWxgBLz4=;
 b=Rk4n1XRF830UX1aAgLsKJcVN3aIabGxlud4gUqgNWay0w1Lbqd6sD8HtLnE7ie/XTBnF
 CG0X+UEOitV873Fco3zj9k17EbC9q2UrRrONG4B6yQ6q+PiCsxjYOetq71BgqtNqyD5O
 owcVvviKc6GVVZoIBrtp4apzoXP3dJMqh+tduqXm7FVq7Pq66nD5yNFJSrsDwiUbKIuy
 xJp+zz/vHmfix9j8V2OxGxX/aBM5wd/vS/gYPy2uybiQzAt46t0v5TwHO0U6eJLFzz38
 vHJPtsGkBbd3G6I/QJ5wg5u1FSz5Aw3itzORmJMGzH/s5jzXZzuAbj43hJFtDKBN188C kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucgcudp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 17:28:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UHMtTQ008382;
        Thu, 30 Apr 2020 17:26:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30qtf8031c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 17:26:24 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UHQNnP021681;
        Thu, 30 Apr 2020 17:26:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 10:26:22 -0700
Date:   Thu, 30 Apr 2020 10:26:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 01/17] xfs: refactor failed buffer resubmission into
 xfsaild
Message-ID: <20200430172620.GA6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=2 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:37PM -0400, Brian Foster wrote:
> Flush locked log items whose underlying buffers fail metadata
> writeback are tagged with a special flag to indicate that the flush
> lock is already held. This is currently implemented in the type
> specific ->iop_push() callback, but the processing required for such
> items is not type specific because we're only doing basic state
> management on the underlying buffer.
> 
> Factor the failed log item handling out of the inode and dquot
> ->iop_push() callbacks and open code the buffer resubmit helper into
> a single helper called from xfsaild_push_item(). This provides a
> generic mechanism for handling failed metadata buffer writeback with
> a bit less code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Nice little refactoring,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c   | 39 ---------------------------------------
>  fs/xfs/xfs_buf_item.h   |  2 --
>  fs/xfs/xfs_dquot_item.c | 15 ---------------
>  fs/xfs/xfs_inode_item.c | 15 ---------------
>  fs/xfs/xfs_trans_ail.c  | 41 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 41 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1545657c3ca0..8796adde2d12 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1248,42 +1248,3 @@ xfs_buf_iodone(
>  	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
>  	xfs_buf_item_free(BUF_ITEM(lip));
>  }
> -
> -/*
> - * Requeue a failed buffer for writeback.
> - *
> - * We clear the log item failed state here as well, but we have to be careful
> - * about reference counts because the only active reference counts on the buffer
> - * may be the failed log items. Hence if we clear the log item failed state
> - * before queuing the buffer for IO we can release all active references to
> - * the buffer and free it, leading to use after free problems in
> - * xfs_buf_delwri_queue. It makes no difference to the buffer or log items which
> - * order we process them in - the buffer is locked, and we own the buffer list
> - * so nothing on them is going to change while we are performing this action.
> - *
> - * Hence we can safely queue the buffer for IO before we clear the failed log
> - * item state, therefore  always having an active reference to the buffer and
> - * avoiding the transient zero-reference state that leads to use-after-free.
> - *
> - * Return true if the buffer was added to the buffer list, false if it was
> - * already on the buffer list.
> - */
> -bool
> -xfs_buf_resubmit_failed_buffers(
> -	struct xfs_buf		*bp,
> -	struct list_head	*buffer_list)
> -{
> -	struct xfs_log_item	*lip;
> -	bool			ret;
> -
> -	ret = xfs_buf_delwri_queue(bp, buffer_list);
> -
> -	/*
> -	 * XFS_LI_FAILED set/clear is protected by ail_lock, caller of this
> -	 * function already have it acquired
> -	 */
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> -		xfs_clear_li_failed(lip);
> -
> -	return ret;
> -}
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 30114b510332..c9c57e2da932 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -59,8 +59,6 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
>  			      struct xfs_log_item *);
>  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
>  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
> -bool	xfs_buf_resubmit_failed_buffers(struct xfs_buf *,
> -					struct list_head *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
>  extern kmem_zone_t	*xfs_buf_item_zone;
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index baad1748d0d1..5a7808299a32 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -145,21 +145,6 @@ xfs_qm_dquot_logitem_push(
>  	if (atomic_read(&dqp->q_pincount) > 0)
>  		return XFS_ITEM_PINNED;
>  
> -	/*
> -	 * The buffer containing this item failed to be written back
> -	 * previously. Resubmit the buffer for IO
> -	 */
> -	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		if (!xfs_buf_trylock(bp))
> -			return XFS_ITEM_LOCKED;
> -
> -		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
> -			rval = XFS_ITEM_FLUSHING;
> -
> -		xfs_buf_unlock(bp);
> -		return rval;
> -	}
> -
>  	if (!xfs_dqlock_nowait(dqp))
>  		return XFS_ITEM_LOCKED;
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f779cca2346f..1d4d256a2e96 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -497,21 +497,6 @@ xfs_inode_item_push(
>  	if (xfs_ipincount(ip) > 0)
>  		return XFS_ITEM_PINNED;
>  
> -	/*
> -	 * The buffer containing this item failed to be written back
> -	 * previously. Resubmit the buffer for IO.
> -	 */
> -	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		if (!xfs_buf_trylock(bp))
> -			return XFS_ITEM_LOCKED;
> -
> -		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
> -			rval = XFS_ITEM_FLUSHING;
> -
> -		xfs_buf_unlock(bp);
> -		return rval;
> -	}
> -
>  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
>  		return XFS_ITEM_LOCKED;
>  
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 564253550b75..2574d01e4a83 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -345,6 +345,45 @@ xfs_ail_delete(
>  	xfs_trans_ail_cursor_clear(ailp, lip);
>  }
>  
> +/*
> + * Requeue a failed buffer for writeback.
> + *
> + * We clear the log item failed state here as well, but we have to be careful
> + * about reference counts because the only active reference counts on the buffer
> + * may be the failed log items. Hence if we clear the log item failed state
> + * before queuing the buffer for IO we can release all active references to
> + * the buffer and free it, leading to use after free problems in
> + * xfs_buf_delwri_queue. It makes no difference to the buffer or log items which
> + * order we process them in - the buffer is locked, and we own the buffer list
> + * so nothing on them is going to change while we are performing this action.
> + *
> + * Hence we can safely queue the buffer for IO before we clear the failed log
> + * item state, therefore  always having an active reference to the buffer and
> + * avoiding the transient zero-reference state that leads to use-after-free.
> + */
> +static inline int
> +xfsaild_resubmit_item(
> +	struct xfs_log_item	*lip,
> +	struct list_head	*buffer_list)
> +{
> +	struct xfs_buf		*bp = lip->li_buf;
> +
> +	if (!xfs_buf_trylock(bp))
> +		return XFS_ITEM_LOCKED;
> +
> +	if (!xfs_buf_delwri_queue(bp, buffer_list)) {
> +		xfs_buf_unlock(bp);
> +		return XFS_ITEM_FLUSHING;
> +	}
> +
> +	/* protected by ail_lock */
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> +		xfs_clear_li_failed(lip);
> +
> +	xfs_buf_unlock(bp);
> +	return XFS_ITEM_SUCCESS;
> +}
> +
>  static inline uint
>  xfsaild_push_item(
>  	struct xfs_ail		*ailp,
> @@ -365,6 +404,8 @@ xfsaild_push_item(
>  	 */
>  	if (!lip->li_ops->iop_push)
>  		return XFS_ITEM_PINNED;
> +	if (test_bit(XFS_LI_FAILED, &lip->li_flags))
> +		return xfsaild_resubmit_item(lip, &ailp->ail_buf_list);
>  	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
>  }
>  
> -- 
> 2.21.1
> 
