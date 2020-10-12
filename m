Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309ACC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 16:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D389C2076C
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 16:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="URzNj4WY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390017AbgJLQEg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 12:04:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389068AbgJLQEg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 12:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602518674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XYsVI38yfCub0tA+5k8BvX3rosAwRSjNmfBrf9Mieks=;
        b=URzNj4WY7BuTKMr2cVLJnqK2d7WomRv51Qe/VoY2dZPKG4RoOTX/x5yhppwhNRYxowN0Q8
        KriQLohNJhZaly0SH01SmxO+yl8p2v8EopTEE/wtIufK6XQ4iCDzMIu+eb51VJq6UcdqoU
        lolc+bzfe5et3cKhCP8ilj1Qc24nNbg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-Q_AlY5N9PXOrRAOJp6h5Cw-1; Mon, 12 Oct 2020 12:04:20 -0400
X-MC-Unique: Q_AlY5N9PXOrRAOJp6h5Cw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDB2D801FD7
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 16:04:19 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F52919C78;
        Mon, 12 Oct 2020 16:04:19 +0000 (UTC)
Date:   Mon, 12 Oct 2020 12:04:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201012160412.GK917726@bfoster>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195515.82889-5-preichl@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 09:55:15PM +0200, Pavel Reichl wrote:
> Remove mrlock_t as it does not provide any extra value over
> rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
> replace mr*() functions with native rwsem calls.
> 
> Release the lock in xfs_btree_split() just before the work-queue
> executing xfs_btree_split_worker() is scheduled and make
> xfs_btree_split_worker() to acquire the lock as a first thing and
> release it just before returning from the function. This it done so the
> ownership of the lock is transfered between kernel threads and thus
> lockdep won't complain about lock being held by a different kernel
> thread.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c | 24 ++++++++++++
>  fs/xfs/mrlock.h           | 78 ---------------------------------------
>  fs/xfs/xfs_inode.c        | 50 +++++++++++++------------
>  fs/xfs/xfs_inode.h        |  4 +-
>  fs/xfs/xfs_iops.c         |  4 +-
>  fs/xfs/xfs_linux.h        |  2 +-
>  fs/xfs/xfs_super.c        |  6 +--
>  7 files changed, 57 insertions(+), 111 deletions(-)
>  delete mode 100644 fs/xfs/mrlock.h
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2d25bab68764..d1fdb180f7ae 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
...
> @@ -2863,8 +2875,20 @@ xfs_btree_split(
>  	args.done = &done;
>  	args.kswapd = current_is_kswapd();
>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
> +	/*
> +	 * Update lockdep's ownership information to reflect that we
> +	 * will be transferring the ilock from this thread to the
> +	 * worker.
> +	 */

Can we update this comment to explain why we need to do this? E.g., I'm
assuming there's a lockdep splat somewhere down in the split worker
without it, but it's not immediately clear where and so it might not be
obvious if we're ever able to remove this.

> +	rwsem_release(&cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>  	queue_work(xfs_alloc_wq, &args.work);
>  	wait_for_completion(&done);
> +	/*
> +	 * Update lockdep's lock ownership information to point to
> +	 * this thread as the lock owner now that the worker item is
> +	 * done.
> +	 */
> +	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
>  	destroy_work_on_stack(&args.work);
>  	return args.result;
>  }
...
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a3baec1c5bcf..213a4a947854 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
...
> @@ -384,16 +385,17 @@ xfs_isilocked(
>  	struct xfs_inode	*ip,
>  	uint			lock_flags)
>  {
> -	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> -		if (!(lock_flags & XFS_ILOCK_SHARED))
> -			return !!ip->i_lock.mr_writer;
> -		return rwsem_is_locked(&ip->i_lock.mr_lock);
> +	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
> +		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
> +		return __xfs_rwsem_islocked(&ip->i_lock,
> +				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
>  	}
>  
> -	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> -		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> -			return !!ip->i_mmaplock.mr_writer;
> -		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> +	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
> +		ASSERT(!(lock_flags &
> +			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
> +		return __xfs_rwsem_islocked(&ip->i_mmaplock,
> +				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
>  	}
>  
>  	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {

Can we add a similar assert for this case as we have for the others?
Otherwise the rest looks fairly straightforward to me.

Brian

> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 77776af75c77..896a088989f2 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -39,8 +39,8 @@ typedef struct xfs_inode {
>  
>  	/* Transaction and locking information. */
>  	struct xfs_inode_log_item *i_itemp;	/* logging information */
> -	mrlock_t		i_lock;		/* inode lock */
> -	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
> +	struct rw_semaphore	i_lock;		/* inode lock */
> +	struct rw_semaphore	i_mmaplock;	/* inode mmap IO lock */
>  	atomic_t		i_pincount;	/* inode pin count */
>  
>  	/*
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 80a13c8561d8..66cca3e599c7 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1336,9 +1336,9 @@ xfs_setup_inode(
>  		 */
>  		lockdep_set_class(&inode->i_rwsem,
>  				  &inode->i_sb->s_type->i_mutex_dir_key);
> -		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
> +		lockdep_set_class(&ip->i_lock, &xfs_dir_ilock_class);
>  	} else {
> -		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
> +		lockdep_set_class(&ip->i_lock, &xfs_nondir_ilock_class);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index ab737fed7b12..ba37217f86d2 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
>  #include "xfs_types.h"
>  
>  #include "kmem.h"
> -#include "mrlock.h"
>  
>  #include <linux/semaphore.h>
>  #include <linux/mm.h>
> @@ -61,6 +60,7 @@ typedef __u32			xfs_nlink_t;
>  #include <linux/ratelimit.h>
>  #include <linux/rhashtable.h>
>  #include <linux/xattr.h>
> +#include <linux/rwsem.h>
>  
>  #include <asm/page.h>
>  #include <asm/div64.h>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 71ac6c1cdc36..00be9cfa29fa 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -708,10 +708,8 @@ xfs_fs_inode_init_once(
>  	atomic_set(&ip->i_pincount, 0);
>  	spin_lock_init(&ip->i_flags_lock);
>  
> -	mrlock_init(&ip->i_mmaplock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
> -		     "xfsino", ip->i_ino);
> -	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
> -		     "xfsino", ip->i_ino);
> +	init_rwsem(&ip->i_mmaplock);
> +	init_rwsem(&ip->i_lock);
>  }
>  
>  /*
> -- 
> 2.26.2
> 

