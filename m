Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F328C433E1
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 647782077D
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JBPRMXqQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgFEQ04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:26:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58427 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728361AbgFEQ0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 12:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591374412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=us7ILJvFS3GG4CWjmQiD1bU0ych9RsS1zywkRCVtP2A=;
        b=JBPRMXqQpQn8UDIpz1qJQj+fdOtJDEKVE4HHUAG7io/eNjLps7EvjlRwiYG/6Q3qiXN8UU
        HnjjF0rwULIHjAnLraOE/bgof5Hf4RI3rEmkIVeuzFxlWmQT+c8iqL2RbtDcOsDapUeo5T
        0jId9WP6r2ACjosd9oGDuStWCUUjhxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-pSlXkLerNryvL2dkI6mTCw-1; Fri, 05 Jun 2020 12:26:50 -0400
X-MC-Unique: pSlXkLerNryvL2dkI6mTCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92D9A464;
        Fri,  5 Jun 2020 16:26:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2503B5C578;
        Fri,  5 Jun 2020 16:26:49 +0000 (UTC)
Date:   Fri, 5 Jun 2020 12:26:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/30] xfs: clean up inode reclaim comments
Message-ID: <20200605162647.GG23747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-24-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-24-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:45:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode reclaim is quite different now to the way described in various
> comments, so update all the comments explaining what it does and how
> it works.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

