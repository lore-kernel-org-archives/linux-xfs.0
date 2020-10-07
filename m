Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B07C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 01:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D53C2087E
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 01:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a1TE8NSt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgJGBWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 21:22:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38410 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgJGBWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 21:22:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0971JvJO139087;
        Wed, 7 Oct 2020 01:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=o1h0mB3aNCUEEe88h0yngIe+RLHgzI9UZSFa3KqO5Ow=;
 b=a1TE8NStwBigs2yFeLTBqGK223ubKgT2aL5Q3Gp+1R5oz8orAnjrKNWZSn4ufBq+BqLs
 zRBGFS3QSGiISjcul9Kv2/2Uby22XAM6DB+gb+I+fRGvejLJa2izbIyZai6+/NpxRzHu
 igiZrl8RcEYS/zrMhXg/A7jlsQajnGg39pK42Y1qLnX0715/uiQRrfWxnBIbUYdb89Yn
 OFb0YRk9eXcpg/YEDEgsUh4weysk89ry5mKtpo7uAOqVofCg8m8VGM9Z4JSr4FMlWNmR
 dgnapLLRhpIOxSos2RK/p2GcqsGRXO7fZ+pZNT2RkNpzXGSUrfDuSArcWgNigtBmGTFh Eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxmy3y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 01:22:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0971LAA9123689;
        Wed, 7 Oct 2020 01:22:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33yyjgg0kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 01:22:01 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0971M0iX019113;
        Wed, 7 Oct 2020 01:22:00 GMT
Received: from localhost (/10.159.134.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 18:21:59 -0700
Date:   Tue, 6 Oct 2020 18:21:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201007012159.GA49547@magnolia>
References: <20201006191541.115364-1-preichl@redhat.com>
 <20201006191541.115364-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006191541.115364-5-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=2 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070006
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 06, 2020 at 09:15:41PM +0200, Pavel Reichl wrote:
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
>  fs/xfs/libxfs/xfs_btree.c | 14 +++++++
>  fs/xfs/mrlock.h           | 78 ---------------------------------------
>  fs/xfs/xfs_inode.c        | 36 ++++++++++--------
>  fs/xfs/xfs_inode.h        |  4 +-
>  fs/xfs/xfs_iops.c         |  4 +-
>  fs/xfs/xfs_linux.h        |  2 +-
>  fs/xfs/xfs_super.c        |  6 +--
>  7 files changed, 41 insertions(+), 103 deletions(-)
>  delete mode 100644 fs/xfs/mrlock.h
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2d25bab68764..1d1bb8423688 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2816,6 +2816,7 @@ xfs_btree_split_worker(
>  	unsigned long		pflags;
>  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
>  
> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);

These calls also need a comment explaining just what they're doing.

>  	/*
>  	 * we are in a transaction context here, but may also be doing work
>  	 * in kswapd context, and hence we may need to inherit that state
> @@ -2832,6 +2833,7 @@ xfs_btree_split_worker(
>  	complete(args->done);
>  
>  	current_restore_flags_nested(&pflags, new_pflags);
> +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);

Note that as soon as you call complete(), xfs_btree_split can wake up
and return, which means that *args could now point to reclaimed stack
space.  This leads to crashes and memory corruption in generic/562 on
a 1k block filesystem (though in principle this can happen anywhere):

[  227.611722] =====================================
[  227.612673] WARNING: bad unlock balance detected!
[  227.613539] 5.9.0-rc4-djw #rc4 Not tainted
[  227.614290] -------------------------------------
[  227.615141] kworker/1:25/12941 is trying to release lock (
[  227.615154] general protection fault, probably for non-canonical address 0x485fc44ba1158c55: 0000 [#1] PREEMPT SMP
[  227.617903] CPU: 1 PID: 12941 Comm: kworker/1:25 Not tainted 5.9.0-rc4-djw #rc4
[  227.619171] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
[  227.620731] Workqueue: xfsalloc xfs_btree_split_worker [xfs]
[  227.621749] RIP: 0010:print_unlock_imbalance_bug.cold+0x4e/0xb4
[  227.622800] Code: e8 d4 fb ff ff 48 c7 c7 78 7a e1 81 e8 0a d0 00 00 8b 95 d0 04 00 00 48 8d b5 e0 06 00 00 48 c7 c7 a8 7a e1 81 e8 f1 cf 00 00 <48> 8b 73 18 48 8b 3b e8 ba fd ff ff 48 c7 c7 6b 74 e1 81 e8 d9
 cf
[  227.625977] RSP: 0018:ffffc90001927dd0 EFLAGS: 00010046
[  227.626915] RAX: 000000000000002e RBX: 485fc44ba1158c55 RCX: 0000000000000000
[  227.628177] RDX: 0000000000000000 RSI: ffffffff810e7d5f RDI: 00000000ffffffff
[  227.629434] RBP: ffff8880304ac000 R08: 00000034feeb6ecf R09: 0000000000000001
[  227.630678] R10: 0000000000000046 R11: ffffffff83204b74 R12: ffffffffa037ff3b
[  227.631922] R13: ffffffffa037ff3b R14: 0000000000000246 R15: 0000000000000003
[  227.633181] FS:  0000000000000000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[  227.634595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  227.635615] CR2: 00007ff762201d90 CR3: 0000000077756001 CR4: 00000000001706a0
[  227.636869] Call Trace:
[  227.637360]  lock_release+0x169/0x3f0
[  227.638043]  process_one_work+0x23b/0x5a0
[  227.638782]  worker_thread+0x54/0x3a0
[  227.639468]  ? process_one_work+0x5a0/0x5a0
[  227.640193]  kthread+0x13c/0x180
[  227.640754]  ? kthread_park+0x90/0x90
[  227.641392]  ret_from_fork+0x1f/0x30
[  227.642005] Modules linked in: btrfs blake2b_generic xor zstd_compress lzo_compress lzo_decompress zlib_deflate raid6_pq dm_flakey xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_REDIRECT ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables iptable_filter bfq sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet [last unloaded: scsi_debug]
[  227.648071] Dumping ftrace buffer:
[  227.648590]    (ftrace buffer empty)
[  227.649135] ---[ end trace 91c58b635eaa3d46 ]---
[  227.649792] RIP: 0010:print_unlock_imbalance_bug.cold+0x4e/0xb4

Also, reverting just this patch leads to compilation errors.

--D

>  }
>  
>  /*
> @@ -2863,8 +2865,20 @@ xfs_btree_split(
>  	args.done = &done;
>  	args.kswapd = current_is_kswapd();
>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
> +	/*
> +	 * Update lockdep's ownership information to reflect that we
> +	 * will be transferring the ilock from this thread to the
> +	 * worker.
> +	 */
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
> diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
> deleted file mode 100644
> index 79155eec341b..000000000000
> --- a/fs/xfs/mrlock.h
> +++ /dev/null
> @@ -1,78 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - */
> -#ifndef __XFS_SUPPORT_MRLOCK_H__
> -#define __XFS_SUPPORT_MRLOCK_H__
> -
> -#include <linux/rwsem.h>
> -
> -typedef struct {
> -	struct rw_semaphore	mr_lock;
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	int			mr_writer;
> -#endif
> -} mrlock_t;
> -
> -#if defined(DEBUG) || defined(XFS_WARN)
> -#define mrinit(mrp, name)	\
> -	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
> -#else
> -#define mrinit(mrp, name)	\
> -	do { init_rwsem(&(mrp)->mr_lock); } while (0)
> -#endif
> -
> -#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
> -#define mrfree(mrp)		do { } while (0)
> -
> -static inline void mraccess_nested(mrlock_t *mrp, int subclass)
> -{
> -	down_read_nested(&mrp->mr_lock, subclass);
> -}
> -
> -static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
> -{
> -	down_write_nested(&mrp->mr_lock, subclass);
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	mrp->mr_writer = 1;
> -#endif
> -}
> -
> -static inline int mrtryaccess(mrlock_t *mrp)
> -{
> -	return down_read_trylock(&mrp->mr_lock);
> -}
> -
> -static inline int mrtryupdate(mrlock_t *mrp)
> -{
> -	if (!down_write_trylock(&mrp->mr_lock))
> -		return 0;
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	mrp->mr_writer = 1;
> -#endif
> -	return 1;
> -}
> -
> -static inline void mrunlock_excl(mrlock_t *mrp)
> -{
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	mrp->mr_writer = 0;
> -#endif
> -	up_write(&mrp->mr_lock);
> -}
> -
> -static inline void mrunlock_shared(mrlock_t *mrp)
> -{
> -	up_read(&mrp->mr_lock);
> -}
> -
> -static inline void mrdemote(mrlock_t *mrp)
> -{
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	mrp->mr_writer = 0;
> -#endif
> -	downgrade_write(&mrp->mr_lock);
> -}
> -
> -#endif /* __XFS_SUPPORT_MRLOCK_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 035925d406d5..213a4a947854 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -191,14 +191,15 @@ xfs_ilock(
>  	}
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrupdate_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
> +		down_write_nested(&ip->i_mmaplock,
> +				XFS_MMAPLOCK_DEP(lock_flags));
>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mraccess_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
> +		down_read_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
> +		down_write_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>  	else if (lock_flags & XFS_ILOCK_SHARED)
> -		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
> +		down_read_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>  }
>  
>  /*
> @@ -242,27 +243,27 @@ xfs_ilock_nowait(
>  	}
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL) {
> -		if (!mrtryupdate(&ip->i_mmaplock))
> +		if (!down_write_trylock(&ip->i_mmaplock))
>  			goto out_undo_iolock;
>  	} else if (lock_flags & XFS_MMAPLOCK_SHARED) {
> -		if (!mrtryaccess(&ip->i_mmaplock))
> +		if (!down_read_trylock(&ip->i_mmaplock))
>  			goto out_undo_iolock;
>  	}
>  
>  	if (lock_flags & XFS_ILOCK_EXCL) {
> -		if (!mrtryupdate(&ip->i_lock))
> +		if (!down_write_trylock(&ip->i_lock))
>  			goto out_undo_mmaplock;
>  	} else if (lock_flags & XFS_ILOCK_SHARED) {
> -		if (!mrtryaccess(&ip->i_lock))
> +		if (!down_read_trylock(&ip->i_lock))
>  			goto out_undo_mmaplock;
>  	}
>  	return 1;
>  
>  out_undo_mmaplock:
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrunlock_excl(&ip->i_mmaplock);
> +		up_write(&ip->i_mmaplock);
>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mrunlock_shared(&ip->i_mmaplock);
> +		up_read(&ip->i_mmaplock);
>  out_undo_iolock:
>  	if (lock_flags & XFS_IOLOCK_EXCL)
>  		up_write(&VFS_I(ip)->i_rwsem);
> @@ -309,14 +310,14 @@ xfs_iunlock(
>  		up_read(&VFS_I(ip)->i_rwsem);
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrunlock_excl(&ip->i_mmaplock);
> +		up_write(&ip->i_mmaplock);
>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mrunlock_shared(&ip->i_mmaplock);
> +		up_read(&ip->i_mmaplock);
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrunlock_excl(&ip->i_lock);
> +		up_write(&ip->i_lock);
>  	else if (lock_flags & XFS_ILOCK_SHARED)
> -		mrunlock_shared(&ip->i_lock);
> +		up_read(&ip->i_lock);
>  
>  	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
>  }
> @@ -335,9 +336,9 @@ xfs_ilock_demote(
>  		~(XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrdemote(&ip->i_lock);
> +		downgrade_write(&ip->i_lock);
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrdemote(&ip->i_mmaplock);
> +		downgrade_write(&ip->i_mmaplock);
>  	if (lock_flags & XFS_IOLOCK_EXCL)
>  		downgrade_write(&VFS_I(ip)->i_rwsem);
>  
> @@ -385,11 +386,14 @@ xfs_isilocked(
>  	uint			lock_flags)
>  {
>  	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
> +		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
>  		return __xfs_rwsem_islocked(&ip->i_lock,
>  				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
>  	}
>  
>  	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
> +		ASSERT(!(lock_flags &
> +			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
>  		return __xfs_rwsem_islocked(&ip->i_mmaplock,
>  				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
>  	}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 77d5655191ab..02c98ecfe4c5 100644
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
