Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9412DC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5698E206B6
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SLylDM5R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgEVXTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 19:19:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731223AbgEVXTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 19:19:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MNCBAa116119;
        Fri, 22 May 2020 23:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GL5d7hucXe28IorYLqT1/PJpsminJj6OV+rLmTMwzBs=;
 b=SLylDM5Rd82lOlA78fQM3UscY4K9Yvhks6ZJYnjpn1gPYS37Re6E8bEXDG0Ci0KTp8Zz
 JGFM3X6ZN4l9ncu6ayJT/rnfcyYO7HOa1J1oYh5W/lpOs2mbYp0B3ysCaNBoBSA/+/mz
 pgfO9ooPdkauUfgZ3NUozCGmW8JZlEc2KJgXclIzlMDD+QOHQBaN+mAGqmQff4uKg5Zj
 PBkO5Lhy+dI3gq7h/T1FOJYwL0SXsN2HSyAolpd4js6fWDUrGcuz6O4tOylidGgxgPNN
 QsH6nMuc2XGWm0SnaxaCzVL+CLUaoIqQ2Uq0cWJG2D2ZcNUH52kR1LMngMw2j9Prn3vQ tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 316qrvr2gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:19:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MNDLU4039558;
        Fri, 22 May 2020 23:17:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3150254wm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:17:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MNHmDB015979;
        Fri, 22 May 2020 23:17:49 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:17:48 -0700
Date:   Fri, 22 May 2020 16:17:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/24] xfs: clean up inode reclaim comments
Message-ID: <20200522231747.GV8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-19-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-19-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=5 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=5 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:23PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode reclaim is quite different now to the way described in various
> comments, so update all the comments explaining what it does and how
> it works.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 128 ++++++++++++--------------------------------
>  1 file changed, 35 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 8b366bc7b53c9..81c23384d3310 100644
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
> @@ -164,8 +161,7 @@ xfs_reclaim_work_queue(
>   * This is a fast pass over the inode cache to try to get reclaim moving on as
>   * many inodes as possible in a short period of time. It kicks itself every few
>   * seconds, as well as being kicked by the inode cache shrinker when memory
> - * goes low. It scans as quickly as possible avoiding locked inodes or those
> - * already being flushed, and once done schedules a future pass.
> + * goes low.
>   */
>  void
>  xfs_reclaim_worker(
> @@ -618,48 +614,31 @@ xfs_iget_cache_miss(
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
> @@ -771,15 +750,7 @@ xfs_inode_ag_walk_grab(
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
> @@ -1089,43 +1060,16 @@ xfs_reclaim_inode_grab(
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
> + * We do no IO here - if callers require indoes to be cleaned they must push the

"...require inodes to be cleaned..."

> + * AIL first to trigger writeback of dirty inodes. The enbales both the

"This enables writeback to be done in the background in a non-blocking
manner, and enables memory reclaim to make progress without blocking."

--D

> + * writeback to be done in the background in a non-blocking manner, as well as
> + * allowing reclaim to make progress without blocking.
>   */
>  static bool
>  xfs_reclaim_inode(
> @@ -1327,13 +1271,11 @@ xfs_reclaim_inodes(
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
> -- 
> 2.26.2.761.g0e0b3e54be
> 
