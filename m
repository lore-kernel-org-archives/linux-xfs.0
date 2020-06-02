Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7D4C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 22:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3434220823
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 22:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NQeKHl0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgFBWiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 18:38:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46522 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBWiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 18:38:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MWiLY024105;
        Tue, 2 Jun 2020 22:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jsJugC/3R9nqfofUqUqNeBg1gU63lO+2qpbF9gj+AOg=;
 b=NQeKHl0a2hjdTIjo7TpdyxFq94OfZlMScfigeZy3g5AKfcxkAqn4G+cf97mMgFBE7QgM
 +KKSPgOwRrPQ9u2uUXsHSU2muBISErgxvzKQXd/UDF2fjLzXn0HC3eWNB3r7VRUjZzJn
 3iB0MCq9L9MWQ0d0m0SbqWY/lPfF5lr2KJCRu3KQGVytBwpfxWoCctd/Q7lllLz+x2Kr
 vDthxwyOWABVAZqlc36hwN4WTDACFACQdIARZASShNb+cB2ze5pZKjYXAwWLyo0UYzS4
 48zZ7VHRTW1B2ootelK/tBv7Tx5d8b4VD5qQaFaNHroXQTueS0gk/biYMDeQpUV7o8PQ Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31bfem6a4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 22:38:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MXQe8175944;
        Tue, 2 Jun 2020 22:36:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12pxah4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 22:36:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052MaFwY024963;
        Tue, 2 Jun 2020 22:36:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 15:36:15 -0700
Date:   Tue, 2 Jun 2020 15:36:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/30] xfs: remove IO submission from xfs_reclaim_inode()
Message-ID: <20200602223614.GN8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-19-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-19-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=5 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=5
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:39AM +1000, Dave Chinner wrote:
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

Looks good this time around,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c | 117 ++++++++++++--------------------------------
>  1 file changed, 31 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a6780942034fc..74032316ce5cc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1111,24 +1111,17 @@ xfs_reclaim_inode_grab(
>   *	dirty, async	=> requeue
>   *	dirty, sync	=> flush, wait and reclaim
>   */
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
> @@ -1136,52 +1129,12 @@ xfs_reclaim_inode(
>  		xfs_iflush_abort(ip);
>  		goto reclaim;
>  	}
> -	if (xfs_ipincount(ip)) {
> -		if (!(sync_mode & SYNC_WAIT))
> -			goto out_ifunlock;
> -		xfs_iunpin_wait(ip);
> -	}
> -	if (xfs_inode_clean(ip)) {
> -		xfs_ifunlock(ip);
> -		goto reclaim;
> -	}
> -
> -	/*
> -	 * Never flush out dirty data during non-blocking reclaim, as it would
> -	 * just contend with AIL pushing trying to do the same job.
> -	 */
> -	if (!(sync_mode & SYNC_WAIT))
> +	if (xfs_ipincount(ip))
> +		goto out_ifunlock;
> +	if (!xfs_inode_clean(ip))
>  		goto out_ifunlock;
>  
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
> -
> +	xfs_ifunlock(ip);
>  reclaim:
>  	ASSERT(!xfs_isiflocked(ip));
>  
> @@ -1231,21 +1184,14 @@ xfs_reclaim_inode(
>  	ASSERT(xfs_inode_clean(ip));
>  
>  	__xfs_inode_free(ip);
> -	return error;
> +	return true;
>  
>  out_ifunlock:
>  	xfs_ifunlock(ip);
>  out:
> -	xfs_iflags_clear(ip, XFS_IRECLAIM);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	/*
> -	 * We could return -EAGAIN here to make reclaim rescan the inode tree in
> -	 * a short while. However, this just burns CPU time scanning the tree
> -	 * waiting for IO to complete and the reclaim work never goes back to
> -	 * the idle state. Instead, return 0 to let the next scheduled
> -	 * background reclaim attempt to reclaim the inode again.
> -	 */
> -	return 0;
> +	xfs_iflags_clear(ip, XFS_IRECLAIM);
> +	return false;
>  }
>  
>  /*
> @@ -1253,21 +1199,22 @@ xfs_reclaim_inode(
>   * corrupted, we still want to try to reclaim all the inodes. If we don't,
>   * then a shut down during filesystem unmount reclaim walk leak all the
>   * unreclaimed inodes.
> + *
> + * Returns non-zero if any AGs or inodes were skipped in the reclaim pass
> + * so that callers that want to block until all dirty inodes are written back
> + * and reclaimed can sanely loop.
>   */
> -STATIC int
> +static int
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
> @@ -1341,9 +1288,8 @@ xfs_reclaim_inodes_ag(
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
> @@ -1359,19 +1305,7 @@ xfs_reclaim_inodes_ag(
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
> @@ -1380,8 +1314,18 @@ xfs_reclaim_inodes(
>  	int		mode)
>  {
>  	int		nr_to_scan = INT_MAX;
> +	int		skipped;
>  
> -	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	if (!(mode & SYNC_WAIT))
> +		return 0;
> +
> +	do {
> +		xfs_ail_push_all_sync(mp->m_ail);
> +		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	} while (skipped > 0);
> +
> +	return 0;
>  }
>  
>  /*
> @@ -1402,7 +1346,8 @@ xfs_reclaim_inodes_nr(
>  	xfs_reclaim_work_queue(mp);
>  	xfs_ail_push_all(mp->m_ail);
>  
> -	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 
