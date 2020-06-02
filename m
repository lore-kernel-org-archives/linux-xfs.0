Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816E1C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 22:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52B29206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 22:45:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NZ3gL+e5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgFBWpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 18:45:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgFBWpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 18:45:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MgknB043718;
        Tue, 2 Jun 2020 22:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Zc1dGBD80DOog7u+xGlg3LqEpbOeQJNd5GARInuvQyU=;
 b=NZ3gL+e54kOGQP6UukOKcA8T9OPCk1YCpiZ6aqWF/4GSaKIlZ7564Fo9p+x9zYTVGW32
 kjHO0LWYRgymNQCWCyX20/wp2mdHa+ybkMigLGvxucL65gvW2nU4ecoN7YNTFe630TLJ
 z9hlLauz4zvHovXkW3sE1HeD9SvcoN9Lu6JNs675c269GdBstpNgI4tHUwaJNZZRYmR5
 lctjcsYhxH3h7wdyBB8aP/6IZu7eSYbTMnoSQaFeLTeswg5L7vuM3fHxtzNJnFojlWG1
 aHv9EGZANlrJPzqJYxFWHx5sF76+iO+jgbLLm4SqNLyNop8vqQ579JOxtweW1PXMSbU1 +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem6aqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 22:45:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MhvbE092552;
        Tue, 2 Jun 2020 22:45:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31c25q7nd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 22:45:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052MjQD9020266;
        Tue, 2 Jun 2020 22:45:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 15:45:26 -0700
Date:   Tue, 2 Jun 2020 15:45:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/30] xfs: clean up inode reclaim comments
Message-ID: <20200602224525.GP8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-24-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-24-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=5 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=5
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:44AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode reclaim is quite different now to the way described in various
> comments, so update all the comments explaining what it does and how
> it works.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c | 128 ++++++++++++--------------------------------
>  1 file changed, 35 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a27470fc201ff..4fe6f250e8448 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -141,11 +141,8 @@ xfs_inode_free(
>  }
>  
>  /*
> - * Queue a new inode reclaim pass if there are reclaimable inodes and there
> - * isn't a reclaim pass already in progress. By default it runs every 5s based
> - * on the xfs periodic sync default of 30s. Perhaps this should have it's own
> - * tunable, but that can be done if this method proves to be ineffective or too
> - * aggressive.
> + * Queue background inode reclaim work if there are reclaimable inodes and there
> + * isn't reclaim work already scheduled or in progress.
>   */
>  static void
>  xfs_reclaim_work_queue(
> @@ -600,48 +597,31 @@ xfs_iget_cache_miss(
>  }
>  
>  /*
> - * Look up an inode by number in the given file system.
> - * The inode is looked up in the cache held in each AG.
> - * If the inode is found in the cache, initialise the vfs inode
> - * if necessary.
> + * Look up an inode by number in the given file system.  The inode is looked up
> + * in the cache held in each AG.  If the inode is found in the cache, initialise
> + * the vfs inode if necessary.
>   *
> - * If it is not in core, read it in from the file system's device,
> - * add it to the cache and initialise the vfs inode.
> + * If it is not in core, read it in from the file system's device, add it to the
> + * cache and initialise the vfs inode.
>   *
>   * The inode is locked according to the value of the lock_flags parameter.
> - * This flag parameter indicates how and if the inode's IO lock and inode lock
> - * should be taken.
> - *
> - * mp -- the mount point structure for the current file system.  It points
> - *       to the inode hash table.
> - * tp -- a pointer to the current transaction if there is one.  This is
> - *       simply passed through to the xfs_iread() call.
> - * ino -- the number of the inode desired.  This is the unique identifier
> - *        within the file system for the inode being requested.
> - * lock_flags -- flags indicating how to lock the inode.  See the comment
> - *		 for xfs_ilock() for a list of valid values.
> + * Inode lookup is only done during metadata operations and not as part of the
> + * data IO path. Hence we only allow locking of the XFS_ILOCK during lookup.
>   */
>  int
>  xfs_iget(
> -	xfs_mount_t	*mp,
> -	xfs_trans_t	*tp,
> -	xfs_ino_t	ino,
> -	uint		flags,
> -	uint		lock_flags,
> -	xfs_inode_t	**ipp)
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		ino,
> +	uint			flags,
> +	uint			lock_flags,
> +	struct xfs_inode	**ipp)
>  {
> -	xfs_inode_t	*ip;
> -	int		error;
> -	xfs_perag_t	*pag;
> -	xfs_agino_t	agino;
> +	struct xfs_inode	*ip;
> +	struct xfs_perag	*pag;
> +	xfs_agino_t		agino;
> +	int			error;
>  
> -	/*
> -	 * xfs_reclaim_inode() uses the ILOCK to ensure an inode
> -	 * doesn't get freed while it's being referenced during a
> -	 * radix tree traversal here.  It assumes this function
> -	 * aqcuires only the ILOCK (and therefore it has no need to
> -	 * involve the IOLOCK in this synchronization).
> -	 */
>  	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
>  
>  	/* reject inode numbers outside existing AGs */
> @@ -758,15 +738,7 @@ xfs_inode_walk_ag_grab(
>  
>  	ASSERT(rcu_read_lock_held());
>  
> -	/*
> -	 * check for stale RCU freed inode
> -	 *
> -	 * If the inode has been reallocated, it doesn't matter if it's not in
> -	 * the AG we are walking - we are walking for writeback, so if it
> -	 * passes all the "valid inode" checks and is dirty, then we'll write
> -	 * it back anyway.  If it has been reallocated and still being
> -	 * initialised, the XFS_INEW check below will catch it.
> -	 */
> +	/* Check for stale RCU freed inode */
>  	spin_lock(&ip->i_flags_lock);
>  	if (!ip->i_ino)
>  		goto out_unlock_noent;
> @@ -1052,43 +1024,16 @@ xfs_reclaim_inode_grab(
>  }
>  
>  /*
> - * Inodes in different states need to be treated differently. The following
> - * table lists the inode states and the reclaim actions necessary:
> - *
> - *	inode state	     iflush ret		required action
> - *      ---------------      ----------         ---------------
> - *	bad			-		reclaim
> - *	shutdown		EIO		unpin and reclaim
> - *	clean, unpinned		0		reclaim
> - *	stale, unpinned		0		reclaim
> - *	clean, pinned(*)	0		requeue
> - *	stale, pinned		EAGAIN		requeue
> - *	dirty, async		-		requeue
> - *	dirty, sync		0		reclaim
> + * Inode reclaim is non-blocking, so the default action if progress cannot be
> + * made is to "requeue" the inode for reclaim by unlocking it and clearing the
> + * XFS_IRECLAIM flag.  If we are in a shutdown state, we don't care about
> + * blocking anymore and hence we can wait for the inode to be able to reclaim
> + * it.
>   *
> - * (*) dgc: I don't think the clean, pinned state is possible but it gets
> - * handled anyway given the order of checks implemented.
> - *
> - * Also, because we get the flush lock first, we know that any inode that has
> - * been flushed delwri has had the flush completed by the time we check that
> - * the inode is clean.
> - *
> - * Note that because the inode is flushed delayed write by AIL pushing, the
> - * flush lock may already be held here and waiting on it can result in very
> - * long latencies.  Hence for sync reclaims, where we wait on the flush lock,
> - * the caller should push the AIL first before trying to reclaim inodes to
> - * minimise the amount of time spent waiting.  For background relaim, we only
> - * bother to reclaim clean inodes anyway.
> - *
> - * Hence the order of actions after gaining the locks should be:
> - *	bad		=> reclaim
> - *	shutdown	=> unpin and reclaim
> - *	pinned, async	=> requeue
> - *	pinned, sync	=> unpin
> - *	stale		=> reclaim
> - *	clean		=> reclaim
> - *	dirty, async	=> requeue
> - *	dirty, sync	=> flush, wait and reclaim
> + * We do no IO here - if callers require inodes to be cleaned they must push the
> + * AIL first to trigger writeback of dirty inodes.  This enables writeback to be
> + * done in the background in a non-blocking manner, and enables memory reclaim
> + * to make progress without blocking.
>   */
>  static bool
>  xfs_reclaim_inode(
> @@ -1294,13 +1239,11 @@ xfs_reclaim_inodes(
>  }
>  
>  /*
> - * Scan a certain number of inodes for reclaim.
> - *
> - * When called we make sure that there is a background (fast) inode reclaim in
> - * progress, while we will throttle the speed of reclaim via doing synchronous
> - * reclaim of inodes. That means if we come across dirty inodes, we wait for
> - * them to be cleaned, which we hope will not be very long due to the
> - * background walker having already kicked the IO off on those dirty inodes.
> + * The shrinker infrastructure determines how many inodes we should scan for
> + * reclaim. We want as many clean inodes ready to reclaim as possible, so we
> + * push the AIL here. We also want to proactively free up memory if we can to
> + * minimise the amount of work memory reclaim has to do so we kick the
> + * background reclaim if it isn't already scheduled.
>   */
>  long
>  xfs_reclaim_inodes_nr(
> @@ -1413,8 +1356,7 @@ xfs_inode_matches_eofb(
>   * This is a fast pass over the inode cache to try to get reclaim moving on as
>   * many inodes as possible in a short period of time. It kicks itself every few
>   * seconds, as well as being kicked by the inode cache shrinker when memory
> - * goes low. It scans as quickly as possible avoiding locked inodes or those
> - * already being flushed, and once done schedules a future pass.
> + * goes low.
>   */
>  void
>  xfs_reclaim_worker(
> -- 
> 2.26.2.761.g0e0b3e54be
> 
