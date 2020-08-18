Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E78DC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA4420738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:45:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cR+rpDko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHRXpF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:45:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgHRXpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 19:45:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07INgwFp067932;
        Tue, 18 Aug 2020 23:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=c9Vpgl8QF7AkOV+Vd+fA5cKbYVKqGclz2rcEGBfwa8k=;
 b=cR+rpDkoZ6DUdO6k6RvlzbGYNxRK7RH6O0EcwuzGqUsKOeXQEm9FPnq4htHz7Xfv1k53
 240kvY9yetAn6xiZpRahaPs1w8kyUGnY8wiVR152Kx2G8dcQQ4i9NcdmrxpG3ZTBSCvK
 PS0lrvfJ5JZxO9C44ulhecd2Kc3TK8j953gdFzDV/HxS4PL7uzeC0B6XWOaUoZ2YdFfs
 xl67mtbSogK4VqGf7df4u9Po1WD8zAkskJjPkro0QH/LqkavlSSWOP5VKB8rbKG7liQ4
 +JUA3pJutjy0Poz9oqJ7ChUEeAIOx9VsCQrfkW5CkEYOYWa/6wGXs4S+O6RSLUguA25r 5A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32x74r7tj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 23:45:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07INiF72054691;
        Tue, 18 Aug 2020 23:45:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32xs9nh8fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 23:45:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07INixWc009687;
        Tue, 18 Aug 2020 23:44:59 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 16:44:59 -0700
Date:   Tue, 18 Aug 2020 16:44:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] xfs: xfs_iflock is no longer a completion
Message-ID: <20200818234457.GP6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-2-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=5 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=5 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:44PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the recent rework of the inode cluster flushing, we no longer
> ever wait on the the inode flush "lock". It was never a lock in the
> first place, just a completion to allow callers to wait for inode IO
> to complete. We now never wait for flush completion as all inode
> flushing is non-blocking. Hence we can get rid of all the iflock
> infrastructure and instead just set and check a state flag.
> 
> Rename the XFS_IFLOCK flag to XFS_IFLUSHING, convert all the
> xfs_iflock_nowait() test-and-set operations on that flag, and
> replace all the xfs_ifunlock() calls to clear operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Hm.  I /think/ this looks fairly straightforward, at least once I
realized that nobody calls xfs_iflock anymore.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c     | 17 ++++------
>  fs/xfs/xfs_inode.c      | 73 +++++++++++++++--------------------------
>  fs/xfs/xfs_inode.h      | 33 +------------------
>  fs/xfs/xfs_inode_item.c | 15 ++++-----
>  fs/xfs/xfs_inode_item.h |  4 +--
>  fs/xfs/xfs_mount.c      | 11 ++++---
>  fs/xfs/xfs_super.c      | 10 +++---
>  7 files changed, 55 insertions(+), 108 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 101028ebb571..aa6aad258670 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -52,7 +52,6 @@ xfs_inode_alloc(
>  
>  	XFS_STATS_INC(mp, vn_active);
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> -	ASSERT(!xfs_isiflocked(ip));
>  	ASSERT(ip->i_ino == 0);
>  
>  	/* initialise the xfs inode */
> @@ -123,7 +122,7 @@ void
>  xfs_inode_free(
>  	struct xfs_inode	*ip)
>  {
> -	ASSERT(!xfs_isiflocked(ip));
> +	ASSERT(!xfs_iflags_test(ip, XFS_IFLUSHING));
>  
>  	/*
>  	 * Because we use RCU freeing we need to ensure the inode always
> @@ -1035,23 +1034,21 @@ xfs_reclaim_inode(
>  
>  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  		goto out;
> -	if (!xfs_iflock_nowait(ip))
> +	if (xfs_iflags_test_and_set(ip, XFS_IFLUSHING))
>  		goto out_iunlock;
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);
> -		/* xfs_iflush_abort() drops the flush lock */
>  		xfs_iflush_abort(ip);
>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip))
> -		goto out_ifunlock;
> +		goto out_clear_flush;
>  	if (!xfs_inode_clean(ip))
> -		goto out_ifunlock;
> +		goto out_clear_flush;
>  
> -	xfs_ifunlock(ip);
> +	xfs_iflags_clear(ip, XFS_IFLUSHING);
>  reclaim:
> -	ASSERT(!xfs_isiflocked(ip));
>  
>  	/*
>  	 * Because we use RCU freeing we need to ensure the inode always appears
> @@ -1101,8 +1098,8 @@ xfs_reclaim_inode(
>  	__xfs_inode_free(ip);
>  	return;
>  
> -out_ifunlock:
> -	xfs_ifunlock(ip);
> +out_clear_flush:
> +	xfs_iflags_clear(ip, XFS_IFLUSHING);
>  out_iunlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out:
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c06129cffba9..2072bd25989a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -598,22 +598,6 @@ xfs_lock_two_inodes(
>  	}
>  }
>  
> -void
> -__xfs_iflock(
> -	struct xfs_inode	*ip)
> -{
> -	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IFLOCK_BIT);
> -	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IFLOCK_BIT);
> -
> -	do {
> -		prepare_to_wait_exclusive(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
> -		if (xfs_isiflocked(ip))
> -			io_schedule();
> -	} while (!xfs_iflock_nowait(ip));
> -
> -	finish_wait(wq, &wait.wq_entry);
> -}
> -
>  STATIC uint
>  _xfs_dic2xflags(
>  	uint16_t		di_flags,
> @@ -2531,11 +2515,8 @@ xfs_ifree_mark_inode_stale(
>  	 * valid, the wrong inode or stale.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> -	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE)) {
> -		spin_unlock(&ip->i_flags_lock);
> -		rcu_read_unlock();
> -		return;
> -	}
> +	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE))
> +		goto out_iflags_unlock;
>  
>  	/*
>  	 * Don't try to lock/unlock the current inode, but we _cannot_ skip the
> @@ -2552,16 +2533,14 @@ xfs_ifree_mark_inode_stale(
>  		}
>  	}
>  	ip->i_flags |= XFS_ISTALE;
> -	spin_unlock(&ip->i_flags_lock);
> -	rcu_read_unlock();
>  
>  	/*
> -	 * If we can't get the flush lock, the inode is already attached.  All
> +	 * If the inode is flushing, it is already attached to the buffer.  All
>  	 * we needed to do here is mark the inode stale so buffer IO completion
>  	 * will remove it from the AIL.
>  	 */
>  	iip = ip->i_itemp;
> -	if (!xfs_iflock_nowait(ip)) {
> +	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
>  		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
>  		ASSERT(iip->ili_last_fields);
>  		goto out_iunlock;
> @@ -2573,10 +2552,12 @@ xfs_ifree_mark_inode_stale(
>  	 * commit as the flock synchronises removal of the inode from the
>  	 * cluster buffer against inode reclaim.
>  	 */
> -	if (!iip || list_empty(&iip->ili_item.li_bio_list)) {
> -		xfs_ifunlock(ip);
> +	if (!iip || list_empty(&iip->ili_item.li_bio_list))
>  		goto out_iunlock;
> -	}
> +
> +	__xfs_iflags_set(ip, XFS_IFLUSHING);
> +	spin_unlock(&ip->i_flags_lock);
> +	rcu_read_unlock();
>  
>  	/* we have a dirty inode in memory that has not yet been flushed. */
>  	spin_lock(&iip->ili_lock);
> @@ -2586,9 +2567,16 @@ xfs_ifree_mark_inode_stale(
>  	spin_unlock(&iip->ili_lock);
>  	ASSERT(iip->ili_last_fields);
>  
> +	if (ip != free_ip)
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return;
> +
>  out_iunlock:
>  	if (ip != free_ip)
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +out_iflags_unlock:
> +	spin_unlock(&ip->i_flags_lock);
> +	rcu_read_unlock();
>  }
>  
>  /*
> @@ -2631,8 +2619,9 @@ xfs_ifree_cluster(
>  
>  		/*
>  		 * We obtain and lock the backing buffer first in the process
> -		 * here, as we have to ensure that any dirty inode that we
> -		 * can't get the flush lock on is attached to the buffer.
> +		 * here to ensure dirty inodes attached to the buffer remain in
> +		 * the flushing state while we mark them stale.
> +		 *
>  		 * If we scan the in-memory inodes first, then buffer IO can
>  		 * complete before we get a lock on it, and hence we may fail
>  		 * to mark all the active inodes on the buffer stale.
> @@ -3443,7 +3432,7 @@ xfs_iflush(
>  	int			error;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> -	ASSERT(xfs_isiflocked(ip));
> +	ASSERT(xfs_iflags_test(ip, XFS_IFLUSHING));
>  	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
>  	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>  	ASSERT(iip->ili_item.li_buf == bp);
> @@ -3613,7 +3602,7 @@ xfs_iflush_cluster(
>  		/*
>  		 * Quick and dirty check to avoid locks if possible.
>  		 */
> -		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
> +		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLUSHING))
>  			continue;
>  		if (xfs_ipincount(ip))
>  			continue;
> @@ -3627,7 +3616,7 @@ xfs_iflush_cluster(
>  		 */
>  		spin_lock(&ip->i_flags_lock);
>  		ASSERT(!__xfs_iflags_test(ip, XFS_ISTALE));
> -		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK)) {
> +		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLUSHING)) {
>  			spin_unlock(&ip->i_flags_lock);
>  			continue;
>  		}
> @@ -3635,23 +3624,16 @@ xfs_iflush_cluster(
>  		/*
>  		 * ILOCK will pin the inode against reclaim and prevent
>  		 * concurrent transactions modifying the inode while we are
> -		 * flushing the inode.
> +		 * flushing the inode. If we get the lock, set the flushing
> +		 * state before we drop the i_flags_lock.
>  		 */
>  		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
>  			spin_unlock(&ip->i_flags_lock);
>  			continue;
>  		}
> +		__xfs_iflags_set(ip, XFS_IFLUSHING);
>  		spin_unlock(&ip->i_flags_lock);
>  
> -		/*
> -		 * Skip inodes that are already flush locked as they have
> -		 * already been written to the buffer.
> -		 */
> -		if (!xfs_iflock_nowait(ip)) {
> -			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -			continue;
> -		}
> -
>  		/*
>  		 * Abort flushing this inode if we are shut down because the
>  		 * inode may not currently be in the AIL. This can occur when
> @@ -3661,7 +3643,6 @@ xfs_iflush_cluster(
>  		 */
>  		if (XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_iunpin_wait(ip);
> -			/* xfs_iflush_abort() drops the flush lock */
>  			xfs_iflush_abort(ip);
>  			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  			error = -EIO;
> @@ -3670,7 +3651,7 @@ xfs_iflush_cluster(
>  
>  		/* don't block waiting on a log force to unpin dirty inodes */
>  		if (xfs_ipincount(ip)) {
> -			xfs_ifunlock(ip);
> +			xfs_iflags_clear(ip, XFS_IFLUSHING);
>  			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  			continue;
>  		}
> @@ -3678,7 +3659,7 @@ xfs_iflush_cluster(
>  		if (!xfs_inode_clean(ip))
>  			error = xfs_iflush(ip, bp);
>  		else
> -			xfs_ifunlock(ip);
> +			xfs_iflags_clear(ip, XFS_IFLUSHING);
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  		if (error)
>  			break;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e9a8bb184d1f..5ea962c6cf98 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -211,8 +211,7 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
>  #define XFS_INEW		(1 << __XFS_INEW_BIT)
>  #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
>  #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
> -#define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
> -#define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)
> +#define XFS_IFLUSHING		(1 << 7) /* inode is being flushed */
>  #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
>  #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
>  #define XFS_IEOFBLOCKS		(1 << 9) /* has the preallocblocks tag set */
> @@ -233,36 +232,6 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
>  	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
>  	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
>  
> -/*
> - * Synchronize processes attempting to flush the in-core inode back to disk.
> - */
> -
> -static inline int xfs_isiflocked(struct xfs_inode *ip)
> -{
> -	return xfs_iflags_test(ip, XFS_IFLOCK);
> -}
> -
> -extern void __xfs_iflock(struct xfs_inode *ip);
> -
> -static inline int xfs_iflock_nowait(struct xfs_inode *ip)
> -{
> -	return !xfs_iflags_test_and_set(ip, XFS_IFLOCK);
> -}
> -
> -static inline void xfs_iflock(struct xfs_inode *ip)
> -{
> -	if (!xfs_iflock_nowait(ip))
> -		__xfs_iflock(ip);
> -}
> -
> -static inline void xfs_ifunlock(struct xfs_inode *ip)
> -{
> -	ASSERT(xfs_isiflocked(ip));
> -	xfs_iflags_clear(ip, XFS_IFLOCK);
> -	smp_mb();
> -	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
> -}
> -
>  /*
>   * Flags for inode locking.
>   * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 6c65938cee1c..099ae8ee7908 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -491,8 +491,7 @@ xfs_inode_item_push(
>  	    (ip->i_flags & XFS_ISTALE))
>  		return XFS_ITEM_PINNED;
>  
> -	/* If the inode is already flush locked, we're already flushing. */
> -	if (xfs_isiflocked(ip))
> +	if (xfs_iflags_test(ip, XFS_IFLUSHING))
>  		return XFS_ITEM_FLUSHING;
>  
>  	if (!xfs_buf_trylock(bp))
> @@ -703,7 +702,7 @@ xfs_iflush_finish(
>  		iip->ili_last_fields = 0;
>  		iip->ili_flush_lsn = 0;
>  		spin_unlock(&iip->ili_lock);
> -		xfs_ifunlock(iip->ili_inode);
> +		xfs_iflags_clear(iip->ili_inode, XFS_IFLUSHING);
>  		if (drop_buffer)
>  			xfs_buf_rele(bp);
>  	}
> @@ -711,8 +710,8 @@ xfs_iflush_finish(
>  
>  /*
>   * Inode buffer IO completion routine.  It is responsible for removing inodes
> - * attached to the buffer from the AIL if they have not been re-logged, as well
> - * as completing the flush and unlocking the inode.
> + * attached to the buffer from the AIL if they have not been re-logged and
> + * completing the inode flush.
>   */
>  void
>  xfs_iflush_done(
> @@ -755,10 +754,10 @@ xfs_iflush_done(
>  }
>  
>  /*
> - * This is the inode flushing abort routine.  It is called from xfs_iflush when
> + * This is the inode flushing abort routine.  It is called when
>   * the filesystem is shutting down to clean up the inode state.  It is
>   * responsible for removing the inode item from the AIL if it has not been
> - * re-logged, and unlocking the inode's flush lock.
> + * re-logged and clearing the inode's flush state.
>   */
>  void
>  xfs_iflush_abort(
> @@ -790,7 +789,7 @@ xfs_iflush_abort(
>  		list_del_init(&iip->ili_item.li_bio_list);
>  		spin_unlock(&iip->ili_lock);
>  	}
> -	xfs_ifunlock(ip);
> +	xfs_iflags_clear(ip, XFS_IFLUSHING);
>  	if (bp)
>  		xfs_buf_rele(bp);
>  }
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 048b5e7dee90..23a7b4928727 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -25,8 +25,8 @@ struct xfs_inode_log_item {
>  	 *
>  	 * We need atomic changes between inode dirtying, inode flushing and
>  	 * inode completion, but these all hold different combinations of
> -	 * ILOCK and iflock and hence we need some other method of serialising
> -	 * updates to the flush state.
> +	 * ILOCK and IFLUSHING and hence we need some other method of
> +	 * serialising updates to the flush state.
>  	 */
>  	spinlock_t		ili_lock;	   /* flush state lock */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c8ae49a1e99c..bbfd1d5b1c04 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1059,11 +1059,12 @@ xfs_unmountfs(
>  	 * We can potentially deadlock here if we have an inode cluster
>  	 * that has been freed has its buffer still pinned in memory because
>  	 * the transaction is still sitting in a iclog. The stale inodes
> -	 * on that buffer will have their flush locks held until the
> -	 * transaction hits the disk and the callbacks run. the inode
> -	 * flush takes the flush lock unconditionally and with nothing to
> -	 * push out the iclog we will never get that unlocked. hence we
> -	 * need to force the log first.
> +	 * on that buffer will be pinned to the buffer until the
> +	 * transaction hits the disk and the callbacks run. Pushing the AIL will
> +	 * skip the stale inodes and may never see the pinned buffer, so
> +	 * nothing will push out the iclog and unpin the buffer. Hence we
> +	 * need to force the log here to ensure all items are flushed into the
> +	 * AIL before we go any further.
>  	 */
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 71ac6c1cdc36..68ec8db12cc7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -654,11 +654,11 @@ xfs_fs_destroy_inode(
>  	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
>  
>  	/*
> -	 * We always use background reclaim here because even if the
> -	 * inode is clean, it still may be under IO and hence we have
> -	 * to take the flush lock. The background reclaim path handles
> -	 * this more efficiently than we can here, so simply let background
> -	 * reclaim tear down all inodes.
> +	 * We always use background reclaim here because even if the inode is
> +	 * clean, it still may be under IO and hence we have wait for IO
> +	 * completion to occur before we can reclaim the inode. The background
> +	 * reclaim path handles this more efficiently than we can here, so
> +	 * simply let background reclaim tear down all inodes.
>  	 */
>  	xfs_inode_set_reclaim_tag(ip);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 
