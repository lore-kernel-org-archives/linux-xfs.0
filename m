Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9437C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DB70206B6
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ebG0sLRm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgEVXIt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 19:08:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731175AbgEVXIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 19:08:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMwpPR093731;
        Fri, 22 May 2020 23:08:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iy04WkII+Mc9pwKe5slRHR1plW1f2oxn34Hbxc8acqs=;
 b=ebG0sLRmZbgw9trJ9OMXCzWRHoZMxQ5GTV9LbkFBuhWU1Fsg+KYSJmInWF5uJVVBrtD6
 rKTV6QiMRDRTxXtM6lRH1l5vts58CVLvzc5HvUxw0ODcsckHzPAQYiNZhDJrxgKTjlLC
 aDsxJI6okHK0lrIyAkdyOV8ngdQkbMI1tavXD8ai9RCCrmbhOO97rpI2xH5TJkj0Az/W
 axPqK4wlkh5pyDzEvGvXeKCbtTqvmRqlMQsqYyltoD6WfkQqu7FcmVMHBTkeqU22nQOZ
 oKdpE9KVOQXEnF4KIZTo+nlLcoeV3ithHco8JyNhe+6tgIKSlIhSEG/ehFE0GdLt697q 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 316qrvr1p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:08:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMvIMw058829;
        Fri, 22 May 2020 23:06:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t3fy3rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:06:44 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MN6hre029487;
        Fri, 22 May 2020 23:06:43 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:06:43 -0700
Date:   Fri, 22 May 2020 16:06:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: remove IO submission from xfs_reclaim_inode()
Message-ID: <20200522230642.GR8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-15-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=5 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:19PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We no longer need to issue IO from shrinker based inode reclaim to
> prevent spurious OOM killer invocation. This leaves only the global
> filesystem management operations such as unmount needing to
> writeback dirty inodes and reclaim them.
> 
> Instead of using the reclaim pass to write dirty inodes before
> reclaiming them, use the AIL to push all the dirty inodes before we
> try to reclaim them. This allows us to remove all the conditional
> SYNC_WAIT locking and the writeback code from xfs_reclaim_inode()
> and greatly simplify the checks we need to do to reclaim an inode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 116 +++++++++++---------------------------------
>  1 file changed, 29 insertions(+), 87 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0f0f8fcd61b03..ee9bc82a0dfbe 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1130,24 +1130,17 @@ xfs_reclaim_inode_grab(
>   *	dirty, async	=> requeue
>   *	dirty, sync	=> flush, wait and reclaim
>   */

The function comment probably ought to describe what the two return
values mean.  true when the inode was freed and false if we need to try
again, right?

> -STATIC int
> +static bool
>  xfs_reclaim_inode(
>  	struct xfs_inode	*ip,
>  	struct xfs_perag	*pag,
>  	int			sync_mode)
>  {
> -	struct xfs_buf		*bp = NULL;
>  	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
> -	int			error;
>  
> -restart:
> -	error = 0;
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (!xfs_iflock_nowait(ip)) {
> -		if (!(sync_mode & SYNC_WAIT))
> -			goto out;
> -		xfs_iflock(ip);
> -	}
> +	if (!xfs_iflock_nowait(ip))
> +		goto out;
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);
> @@ -1155,51 +1148,19 @@ xfs_reclaim_inode(
>  		xfs_iflush_abort(ip);
>  		goto reclaim;
>  	}
> -	if (xfs_ipincount(ip)) {
> -		if (!(sync_mode & SYNC_WAIT))
> -			goto out_ifunlock;
> -		xfs_iunpin_wait(ip);
> -	}
> +	if (xfs_ipincount(ip))
> +		goto out_ifunlock;
>  	if (xfs_iflags_test(ip, XFS_ISTALE) || xfs_inode_clean(ip)) {
>  		xfs_ifunlock(ip);
>  		goto reclaim;
>  	}
>  
> -	/*
> -	 * Never flush out dirty data during non-blocking reclaim, as it would
> -	 * just contend with AIL pushing trying to do the same job.
> -	 */
> -	if (!(sync_mode & SYNC_WAIT))
> -		goto out_ifunlock;
> -
> -	/*
> -	 * Now we have an inode that needs flushing.
> -	 *
> -	 * Note that xfs_iflush will never block on the inode buffer lock, as
> -	 * xfs_ifree_cluster() can lock the inode buffer before it locks the
> -	 * ip->i_lock, and we are doing the exact opposite here.  As a result,
> -	 * doing a blocking xfs_imap_to_bp() to get the cluster buffer would
> -	 * result in an ABBA deadlock with xfs_ifree_cluster().
> -	 *
> -	 * As xfs_ifree_cluser() must gather all inodes that are active in the
> -	 * cache to mark them stale, if we hit this case we don't actually want
> -	 * to do IO here - we want the inode marked stale so we can simply
> -	 * reclaim it.  Hence if we get an EAGAIN error here,  just unlock the
> -	 * inode, back off and try again.  Hopefully the next pass through will
> -	 * see the stale flag set on the inode.
> -	 */
> -	error = xfs_iflush(ip, &bp);
> -	if (error == -EAGAIN) {
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		/* backoff longer than in xfs_ifree_cluster */
> -		delay(2);
> -		goto restart;
> -	}
> -
> -	if (!error) {
> -		error = xfs_bwrite(bp);
> -		xfs_buf_relse(bp);
> -	}
> +out_ifunlock:
> +	xfs_ifunlock(ip);
> +out:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iflags_clear(ip, XFS_IRECLAIM);
> +	return false;
>  
>  reclaim:
>  	ASSERT(!xfs_isiflocked(ip));
> @@ -1249,21 +1210,7 @@ xfs_reclaim_inode(
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	__xfs_inode_free(ip);
> -	return error;
> -
> -out_ifunlock:
> -	xfs_ifunlock(ip);
> -out:
> -	xfs_iflags_clear(ip, XFS_IRECLAIM);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	/*
> -	 * We could return -EAGAIN here to make reclaim rescan the inode tree in
> -	 * a short while. However, this just burns CPU time scanning the tree
> -	 * waiting for IO to complete and the reclaim work never goes back to
> -	 * the idle state. Instead, return 0 to let the next scheduled
> -	 * background reclaim attempt to reclaim the inode again.
> -	 */
> -	return 0;
> +	return true;
>  }
>  
>  /*
> @@ -1272,20 +1219,17 @@ xfs_reclaim_inode(
>   * then a shut down during filesystem unmount reclaim walk leak all the
>   * unreclaimed inodes.
>   */
> -STATIC int
> +static int

The function comment /really/ needs to note that the return value
here is number of inodes that were skipped, and not just some negative
error code.

>  xfs_reclaim_inodes_ag(
>  	struct xfs_mount	*mp,
>  	int			flags,
>  	int			*nr_to_scan)
>  {
>  	struct xfs_perag	*pag;
> -	int			error = 0;
> -	int			last_error = 0;
>  	xfs_agnumber_t		ag;
>  	int			trylock = flags & SYNC_TRYLOCK;
>  	int			skipped;
>  
> -restart:
>  	ag = 0;
>  	skipped = 0;
>  	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
> @@ -1359,9 +1303,8 @@ xfs_reclaim_inodes_ag(
>  			for (i = 0; i < nr_found; i++) {
>  				if (!batch[i])
>  					continue;
> -				error = xfs_reclaim_inode(batch[i], pag, flags);
> -				if (error && last_error != -EFSCORRUPTED)
> -					last_error = error;
> +				if (!xfs_reclaim_inode(batch[i], pag, flags))
> +					skipped++;
>  			}
>  
>  			*nr_to_scan -= XFS_LOOKUP_BATCH;
> @@ -1377,19 +1320,7 @@ xfs_reclaim_inodes_ag(
>  		mutex_unlock(&pag->pag_ici_reclaim_lock);
>  		xfs_perag_put(pag);
>  	}
> -
> -	/*
> -	 * if we skipped any AG, and we still have scan count remaining, do
> -	 * another pass this time using blocking reclaim semantics (i.e
> -	 * waiting on the reclaim locks and ignoring the reclaim cursors). This
> -	 * ensure that when we get more reclaimers than AGs we block rather
> -	 * than spin trying to execute reclaim.
> -	 */
> -	if (skipped && (flags & SYNC_WAIT) && *nr_to_scan > 0) {
> -		trylock = 0;
> -		goto restart;
> -	}
> -	return last_error;
> +	return skipped;
>  }
>  
>  int
> @@ -1398,8 +1329,18 @@ xfs_reclaim_inodes(
>  	int		mode)
>  {
>  	int		nr_to_scan = INT_MAX;
> +	int		skipped;
>  
> -	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	if (!(mode & SYNC_WAIT))
> +		return 0;
> +
> +	do {
> +		xfs_ail_push_all_sync(mp->m_ail);
> +		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	} while (skipped > 0);
> +
> +	return 0;

Might as well kill the return value here since none of the callers care.

>  }
>  
>  /*
> @@ -1420,7 +1361,8 @@ xfs_reclaim_inodes_nr(
>  	xfs_reclaim_work_queue(mp);
>  	xfs_ail_push_all(mp->m_ail);
>  
> -	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);

So the old code was returning negative error codes here?  Given that the
only caller is free_cached_objects which adds it to the 'freed' count...
wow.

> +	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> +	return 0;

Why do we return zero freed items here?  The VFS asked us to clear
shrink_control->nr_to_scan (passed in here as nr_to_scan) and we're
supposed to report what we did, right?

Or is there some odd subtlety here where we hate the shrinker and that's
why we return zero?

--D

>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 
