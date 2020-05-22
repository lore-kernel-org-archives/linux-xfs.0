Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907A1C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB762073B
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hBhJOCvs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgEVXyx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 19:54:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44428 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731183AbgEVXyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 19:54:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MNpPEu072578;
        Fri, 22 May 2020 23:54:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gvddBOh19cFsV7QjFDnsJc0vCggVsly+humnOExQzP8=;
 b=hBhJOCvscCM/nDqqn4jWq6sRF/B40NbCqXNki8Kp+K14U/72g8t/u+wAkS500TaqaMXE
 80sIWJLlinbJsCbCKbn5KBWaoAs1r7wU3gWpT7HC88qHG8jnewI1c33PIdgRb2FHNlCP
 zdu/Rwqcr6NRPzjhgUO/+7HfFMZsYGXsBIu/1m3l/IMNCztzExpf6jH8Xp/kzKGSrqDe
 5QHVHXPVEfKu9ys8vfizW3vEiljVsmzpd/PGZxhROyPig9dzSZqbunsKjtoWuJ6PIwx1
 HMekL2pjZb1B5q0cQKKl3HMkd6EKdj+CW4J+L5aIF0RUnr3CqGJjF854McmCYaZxqwa8 aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krr5wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:54:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MNrIDT187624;
        Fri, 22 May 2020 23:54:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3g300q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:54:49 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MNsmMq001513;
        Fri, 22 May 2020 23:54:48 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:54:48 -0700
Date:   Fri, 22 May 2020 16:54:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/24] xfs: xfs_iflush() is no longer necessary
Message-ID: <20200522235447.GX8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-21-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-21-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=5 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:25PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have a cached buffer on inode log items, we don't need
> to do buffer lookups when flushing inodes anymore - all we need
> to do is lock the buffer and we are ready to go.
> 
> This largely gets rid of the need for xfs_iflush(), which is
> essentially just a mechanism to look up the buffer and flush the
> inode to it. Instead, we can just call xfs_iflush_cluster() with a
> few modifications to ensure it also flushes the inode we already
> hold locked.
> 
> This allows the AIL inode item pushing to be almost entirely
> non-blocking in XFS - we won't block unless memory allocation
> for the cluster inode lookup blocks or the block device queues are
> full.
> 
> Writeback during inode reclaim becomes a little more complex because
> we now have to lock the buffer ourselves, but otherwise this change
> is largely a functional no-op that removes a whole lot of code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

/This/ looks pretty straightforward.  I always wondered about the fact
that the inode item push function would extract a buffer pointer but
then imap_to_bp would replace our pointer...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c      | 106 ++++++----------------------------------
>  fs/xfs/xfs_inode.h      |   2 +-
>  fs/xfs/xfs_inode_item.c |  51 +++++++------------
>  3 files changed, 32 insertions(+), 127 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 961eef2ce8c4a..a94528d26328b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3429,7 +3429,18 @@ xfs_rename(
>  	return error;
>  }
>  
> -STATIC int
> +/*
> + * Non-blocking flush of dirty inode metadata into the backing buffer.
> + *
> + * The caller must have a reference to the inode and hold the cluster buffer
> + * locked. The function will walk across all the inodes on the cluster buffer it
> + * can find and lock without blocking, and flush them to the cluster buffer.
> + *
> + * On success, the caller must write out the buffer returned in *bp and
> + * release it. On failure, the filesystem will be shut down, the buffer will
> + * have been unlocked and released, and EFSCORRUPTED will be returned.
> + */
> +int
>  xfs_iflush_cluster(
>  	struct xfs_inode	*ip,
>  	struct xfs_buf		*bp)
> @@ -3464,8 +3475,6 @@ xfs_iflush_cluster(
>  
>  	for (i = 0; i < nr_found; i++) {
>  		cip = cilist[i];
> -		if (cip == ip)
> -			continue;
>  
>  		/*
>  		 * because this is an RCU protected lookup, we could find a
> @@ -3556,99 +3565,11 @@ xfs_iflush_cluster(
>  	kmem_free(cilist);
>  out_put:
>  	xfs_perag_put(pag);
> -	return error;
> -}
> -
> -/*
> - * Flush dirty inode metadata into the backing buffer.
> - *
> - * The caller must have the inode lock and the inode flush lock held.  The
> - * inode lock will still be held upon return to the caller, and the inode
> - * flush lock will be released after the inode has reached the disk.
> - *
> - * The caller must write out the buffer returned in *bpp and release it.
> - */
> -int
> -xfs_iflush(
> -	struct xfs_inode	*ip,
> -	struct xfs_buf		**bpp)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_buf		*bp = NULL;
> -	struct xfs_dinode	*dip;
> -	int			error;
> -
> -	XFS_STATS_INC(mp, xs_iflush_count);
> -
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> -	ASSERT(xfs_isiflocked(ip));
> -	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
> -	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> -
> -	*bpp = NULL;
> -
> -	xfs_iunpin_wait(ip);
> -
> -	/*
> -	 * For stale inodes we cannot rely on the backing buffer remaining
> -	 * stale in cache for the remaining life of the stale inode and so
> -	 * xfs_imap_to_bp() below may give us a buffer that no longer contains
> -	 * inodes below. We have to check this after ensuring the inode is
> -	 * unpinned so that it is safe to reclaim the stale inode after the
> -	 * flush call.
> -	 */
> -	if (xfs_iflags_test(ip, XFS_ISTALE)) {
> -		xfs_ifunlock(ip);
> -		return 0;
> -	}
> -
> -	/*
> -	 * Get the buffer containing the on-disk inode. We are doing a try-lock
> -	 * operation here, so we may get an EAGAIN error. In that case, return
> -	 * leaving the inode dirty.
> -	 *
> -	 * If we get any other error, we effectively have a corruption situation
> -	 * and we cannot flush the inode. Abort the flush and shut down.
> -	 */
> -	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK);
> -	if (error == -EAGAIN) {
> -		xfs_ifunlock(ip);
> -		return error;
> -	}
> -	if (error)
> -		goto abort;
> -
> -	/*
> -	 * If the buffer is pinned then push on the log now so we won't
> -	 * get stuck waiting in the write for too long.
> -	 */
> -	if (xfs_buf_ispinned(bp))
> -		xfs_log_force(mp, 0);
> -
> -	/*
> -	 * Flush the provided inode then attempt to gather others from the
> -	 * cluster into the write.
> -	 *
> -	 * Note: Once we attempt to flush an inode, we must run buffer
> -	 * completion callbacks on any failure. If this fails, simulate an I/O
> -	 * failure on the buffer and shut down.
> -	 */
> -	error = xfs_iflush_int(ip, bp);
> -	if (!error)
> -		error = xfs_iflush_cluster(ip, bp);
>  	if (error) {
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
> -		goto shutdown;
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	}
> -
> -	*bpp = bp;
> -	return 0;
> -
> -abort:
> -	xfs_iflush_abort(ip);
> -shutdown:
> -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	return error;
>  }
>  
> @@ -3667,6 +3588,7 @@ xfs_iflush_int(
>  	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
>  	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>  	ASSERT(iip != NULL && iip->ili_fields != 0);
> +	ASSERT(iip->ili_item.li_buf == bp);
>  
>  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index dadcf19458960..d1109eb13ba2e 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -427,7 +427,7 @@ int		xfs_log_force_inode(struct xfs_inode *ip);
>  void		xfs_iunpin_wait(xfs_inode_t *);
>  #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
>  
> -int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
> +int		xfs_iflush_cluster(struct xfs_inode *, struct xfs_buf *);
>  void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
>  				struct xfs_inode *ip1, uint ip1_mode);
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 7718cfc39eec8..42b4b5fe1e2a9 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -504,53 +504,35 @@ xfs_inode_item_push(
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> -	if (xfs_ipincount(ip) > 0)
> -		return XFS_ITEM_PINNED;
> +	ASSERT(iip->ili_item.li_buf);
>  
> -	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
> -		return XFS_ITEM_LOCKED;
> +	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
> +	    (ip->i_flags & XFS_ISTALE))
> +		return XFS_ITEM_PINNED;
>  
> -	/*
> -	 * Re-check the pincount now that we stabilized the value by
> -	 * taking the ilock.
> -	 */
> -	if (xfs_ipincount(ip) > 0) {
> -		rval = XFS_ITEM_PINNED;
> -		goto out_unlock;
> -	}
> +	/* If the inode is already flush locked, we're already flushing. */
> +	if (xfs_isiflocked(ip))
> +		return XFS_ITEM_FLUSHING;
>  
> -	/*
> -	 * Stale inode items should force out the iclog.
> -	 */
> -	if (ip->i_flags & XFS_ISTALE) {
> -		rval = XFS_ITEM_PINNED;
> -		goto out_unlock;
> -	}
> +	if (!xfs_buf_trylock(bp))
> +		return XFS_ITEM_LOCKED;
>  
> -	/*
> -	 * Someone else is already flushing the inode.  Nothing we can do
> -	 * here but wait for the flush to finish and remove the item from
> -	 * the AIL.
> -	 */
> -	if (!xfs_iflock_nowait(ip)) {
> -		rval = XFS_ITEM_FLUSHING;
> -		goto out_unlock;
> +	if (bp->b_flags & _XBF_DELWRI_Q) {
> +		xfs_buf_unlock(bp);
> +		return XFS_ITEM_FLUSHING;
>  	}
> -
> -	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
>  	spin_unlock(&lip->li_ailp->ail_lock);
>  
> -	error = xfs_iflush(ip, &bp);
> +	error = xfs_iflush_cluster(ip, bp);
>  	if (!error) {
>  		if (!xfs_buf_delwri_queue(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
> -		xfs_buf_relse(bp);
> -	} else if (error == -EAGAIN)
> +		xfs_buf_unlock(bp);
> +	} else {
>  		rval = XFS_ITEM_LOCKED;
> +	}
>  
>  	spin_lock(&lip->li_ailp->ail_lock);
> -out_unlock:
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  	return rval;
>  }
>  
> @@ -567,6 +549,7 @@ xfs_inode_item_release(
>  
>  	ASSERT(ip->i_itemp != NULL);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(lip->li_buf || !test_bit(XFS_LI_DIRTY, &lip->li_flags));
>  
>  	lock_flags = iip->ili_lock_flags;
>  	iip->ili_lock_flags = 0;
> -- 
> 2.26.2.761.g0e0b3e54be
> 
