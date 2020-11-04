Return-Path: <SRS0=bjGU=EK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358BFC2D0A3
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 00:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E75223C7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 00:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tRy6ZL5L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgKDAxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:53:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51218 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729610AbgKDAxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 19:53:52 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A40rnkt049398;
        Wed, 4 Nov 2020 00:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Yh9Qne8i5KhmVV7Or34YWc06FvFWa+f59ZPkYoSxoII=;
 b=tRy6ZL5Lhw4n0h8q3IU+Lh6nnITBkQiDe6JcntGO6JirdzY5h1Fjj5dC0JpcxCPmtHrR
 OEPOLVqlvrqjtJP/gm/KdeRuhW1L0cB+KEBLD9FHplubMwH08GyP9BHhTfVJVu6ZrMfK
 EgIBa7vouqD2vBUpT047QSHQFXTQJXB40sLnOI7649r+wGAPJ89FRAI8RjHYK9iLf9Z6
 EhC/V2XhMubHDVbvCcT47O7AZh8e574ylt06OzC1ZWNv044IrxaQIkdIi59ubOs1nDyD
 viaBNrd5b8NDjbFvCfBzyXqa8oXwULkcUcnTAKW9HApcG14XhW+W90hyitGjgYqwZxgk 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34hhb24a9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 00:53:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A40oUOw033275;
        Wed, 4 Nov 2020 00:53:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34hw0hsxgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 00:53:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A40rkAK029640;
        Wed, 4 Nov 2020 00:53:47 GMT
Received: from localhost (/10.159.234.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 16:53:46 -0800
Date:   Tue, 3 Nov 2020 16:53:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201104005345.GC7115@magnolia>
References: <20201102194135.174806-1-preichl@redhat.com>
 <20201102194135.174806-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102194135.174806-5-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=2 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=2
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 02, 2020 at 08:41:35PM +0100, Pavel Reichl wrote:
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
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> ---
>  fs/xfs/libxfs/xfs_btree.c | 16 ++++++++
>  fs/xfs/mrlock.h           | 78 ---------------------------------------
>  fs/xfs/xfs_inode.c        | 52 ++++++++++++++------------
>  fs/xfs/xfs_inode.h        |  4 +-
>  fs/xfs/xfs_iops.c         |  4 +-
>  fs/xfs/xfs_linux.h        |  2 +-
>  fs/xfs/xfs_super.c        |  6 +--
>  7 files changed, 51 insertions(+), 111 deletions(-)
>  delete mode 100644 fs/xfs/mrlock.h
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2d25bab68764..181d5797c97b 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2816,6 +2816,10 @@ xfs_btree_split_worker(
w  	unsigned long		pflags;
>  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
>  
> +	/*
> +	 * Tranfer lock ownership to workqueue task.
> +	 */
> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
>  	/*
>  	 * we are in a transaction context here, but may also be doing work
>  	 * in kswapd context, and hence we may need to inherit that state
> @@ -2829,6 +2833,7 @@ xfs_btree_split_worker(
>  
>  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>  					 args->key, args->curp, args->stat);
> +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>  	complete(args->done);
>  
>  	current_restore_flags_nested(&pflags, new_pflags);
> @@ -2863,8 +2868,19 @@ xfs_btree_split(
>  	args.done = &done;
>  	args.kswapd = current_is_kswapd();
>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
> +	/*
> +	 * Update lockdep's ownership information to reflect transfer of the
> +	 * ilock from the current task to the worker. Otherwise assertions that
> +	 * the lock is held (such as when logging the inode) might fail due to
> +	 * incorrect task owner state.
> +	 */
> +	rwsem_release(&cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>  	queue_work(xfs_alloc_wq, &args.work);
>  	wait_for_completion(&done);
> +	/*
> +	 * Tranfer lock ownership back to the thread.
> +	 */
> +	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);

So I ran all this through fstests.  On generic/324 on a fstests run with
reasonable recent xfsprogs and all the features turned on (rmap in
particular) I see the following lockdep report:

============================================
WARNING: possible recursive locking detected
5.10.0-rc1-djw #rc1 Not tainted
--------------------------------------------
xfs_fsr/5438 is trying to acquire lock:
ffff88801826b028 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_btree_make_block_unfull+0x19a/0x200 [xfs]

but task is already holding lock:
ffff88807fbc58a8 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_lock_two_inodes+0x116/0x3e0 [xfs]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&xfs_nondir_ilock_class);
  lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

7 locks held by xfs_fsr/5438:
 #0: ffff88804166a430 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write_file+0x23/0x70
 #1: ffff88801826b2d0 (&sb->s_type->i_mutex_key#13){++++}-{3:3}, at: lock_two_nondirectories+0x68/0x70
 #2: ffff88807fbc5b50 (&sb->s_type->i_mutex_key#13/4){+.+.}-{3:3}, at: xfs_swap_extents+0x4e/0x8e0 [xfs]
 #3: ffff88807fbc5940 (&ip->i_mmaplock){+.+.}-{3:3}, at: xfs_ilock+0xfa/0x270 [xfs]
 #4: ffff88801826b0c0 (&ip->i_mmaplock){+.+.}-{3:3}, at: xfs_ilock_nowait+0x17f/0x310 [xfs]
 #5: ffff88804166a620 (sb_internal){.+.+}-{0:0}, at: xfs_trans_alloc+0x1b0/0x2a0 [xfs]
 #6: ffff88807fbc58a8 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_lock_two_inodes+0x116/0x3e0 [xfs]

stack backtrace:
CPU: 1 PID: 5438 Comm: xfs_fsr Not tainted 5.10.0-rc1-djw #rc1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0x7b/0x9b
 __lock_acquire.cold+0x208/0x2b9
 lock_acquire+0xcd/0x430
 ? xfs_btree_make_block_unfull+0x19a/0x200 [xfs]
 ? mark_held_locks+0x49/0x70
 xfs_btree_split+0x1a2/0x1c0 [xfs]
 ? xfs_btree_make_block_unfull+0x19a/0x200 [xfs]
 ? xfs_btree_split+0x1c0/0x1c0 [xfs]
 xfs_btree_make_block_unfull+0x19a/0x200 [xfs]
 xfs_btree_insrec+0x448/0x9a0 [xfs]
 ? xfs_btree_lookup_get_block+0xee/0x1a0 [xfs]
 xfs_btree_insert+0xa0/0x1f0 [xfs]
 xfs_bmap_add_extent_hole_real+0x272/0xae0 [xfs]
 xfs_bmapi_remap+0x1d5/0x400 [xfs]
 xfs_bmap_finish_one+0x1ac/0x2a0 [xfs]
 xfs_bmap_update_finish_item+0x53/0xd0 [xfs]
 xfs_defer_finish_noroll+0x271/0xa90 [xfs]
 xfs_defer_finish+0x15/0xa0 [xfs]
 xfs_swap_extent_rmap+0x27c/0x810 [xfs]
 xfs_swap_extents+0x7d8/0x8e0 [xfs]
 xfs_ioc_swapext+0x131/0x150 [xfs]
 xfs_file_ioctl+0x291/0xca0 [xfs]
 __x64_sys_ioctl+0x87/0xa0
 do_syscall_64+0x31/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f73472ea50b
Code: 0f 1e fa 48 8b 05 85 39 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 55 39 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc7f707778 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffc7f7078e0 RCX: 00007f73472ea50b
RDX: 00007ffc7f707780 RSI: 00000000c0c0586d RDI: 0000000000000005
RBP: 00007ffc7f7097c0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000022 R11: 0000000000000246 R12: 00007ffc7f7097c0
R13: 00005567684f90c0 R14: 00000000000000f9 R15: 00000000000000f9

I think it's significant that xfs_lock_two_inodes figures in the lockdep
report above.  I suspect what's going on here is: xfs_swap_extents takes
the ILOCK of the two inodes it's operating on.  The first ILOCK gets
tagged with subclass 0 and the second file's ILOCK gets subclass 1.

While swapping extents, we decide that the second file requires a bmbt
split and that we have to do this via workqueue.  We tell lockdep to
drop the current thread (pid 5438) from the lockdep map and kick off the
worker.  When the worker returns, however, we don't feed the subclass
information to rwsem_acquire (the second parameter).  Therefore, lockdep
sees that pid 5438 currently holds one subclass 0 ILOCK (the first
inode, which we didn't unlock) and complains that we're asking it to
grab another subclass 0 ILOCK (the second inode).

Unfortunately, I don't think you can solve this problem solely by
passing the ILOCK subclass information to rwsem_acquire, either.
generic/558 produces the following splat:

======================================================
WARNING: possible circular locking dependency detected
5.10.0-rc1-djw #rc1 Not tainted
------------------------------------------------------
rm/25035 is trying to acquire lock:
ffff888009f5c970 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_btree_make_block_unfull+0x19a/0x200 [xfs]

but task is already holding lock:
ffff88800af0c230 (&xfs_nondir_ilock_class/1){+.+.}-{3:3}, at: xfs_remove+0x180/0x510 [xfs]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_nondir_ilock_class/1){+.+.}-{3:3}:
       down_write_nested+0x48/0x120
       xfs_remove+0x180/0x510 [xfs]
       xfs_vn_unlink+0x57/0xa0 [xfs]
       vfs_unlink+0xf2/0x1e0
       do_unlinkat+0x1a5/0x2e0
       do_syscall_64+0x31/0x40
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #0 (&xfs_dir_ilock_class){++++}-{3:3}:
       __lock_acquire+0x1223/0x2200
       lock_acquire+0xcd/0x430
       xfs_btree_split+0x1a5/0x1c0 [xfs]
       xfs_btree_make_block_unfull+0x19a/0x200 [xfs]
       xfs_btree_insrec+0x448/0x9a0 [xfs]
       xfs_btree_insert+0xa0/0x1f0 [xfs]
       xfs_bmap_del_extent_real+0x6fc/0xc60 [xfs]
       __xfs_bunmapi+0x8ba/0x10b0 [xfs]
       xfs_bunmapi+0x19/0x30 [xfs]
       xfs_dir2_shrink_inode+0x94/0x2d0 [xfs]
       xfs_dir2_node_removename+0x87f/0x9e0 [xfs]
       xfs_dir_removename+0x1eb/0x2b0 [xfs]
       xfs_remove+0x426/0x510 [xfs]
       xfs_vn_unlink+0x57/0xa0 [xfs]
       vfs_unlink+0xf2/0x1e0
       do_unlinkat+0x1a5/0x2e0
       do_syscall_64+0x31/0x40
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

other info that might help us debug this:

 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&xfs_nondir_ilock_class/1);
                               lock(&xfs_dir_ilock_class);
                               lock(&xfs_nondir_ilock_class/1);
  lock(&xfs_dir_ilock_class);

 *** DEADLOCK ***

5 locks held by rm/25035:
 #0: ffff88803b9f8468 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x1f/0x50
 #1: ffff888009f5cc48 (&inode->i_sb->s_type->i_mutex_dir_key/1){+.+.}-{3:3}, at: do_unlinkat+0x13c/0x2e0
 #2: ffff88800af0c508 (&sb->s_type->i_mutex_key#13){++++}-{3:3}, at: vfs_unlink+0x4c/0x1e0
 #3: ffff88803b9f8688 (sb_internal){.+.+}-{0:0}, at: xfs_trans_alloc+0x1b0/0x2a0 [xfs]
 #4: ffff88800af0c230 (&xfs_nondir_ilock_class/1){+.+.}-{3:3}, at: xfs_remove+0x180/0x510 [xfs]

stack backtrace:
CPU: 1 PID: 25035 Comm: rm Not tainted 5.10.0-rc1-djw #rc1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0x7b/0x9b
 check_noncircular+0xf3/0x110
 __lock_acquire+0x1223/0x2200
 lock_acquire+0xcd/0x430
 ? xfs_btree_make_block_unfull+0x19a/0x200 [xfs]
 ? mark_held_locks+0x45/0x70
 xfs_btree_split+0x1a5/0x1c0 [xfs]
 ? xfs_btree_make_block_unfull+0x19a/0x200 [xfs]
 ? wait_for_completion+0xba/0x110
 ? xfs_btree_split+0x1c0/0x1c0 [xfs]
 xfs_btree_make_block_unfull+0x19a/0x200 [xfs]
 xfs_btree_insrec+0x448/0x9a0 [xfs]
 xfs_btree_insert+0xa0/0x1f0 [xfs]
 ? xfs_btree_increment+0x95/0x590 [xfs]
 xfs_bmap_del_extent_real+0x6fc/0xc60 [xfs]
 __xfs_bunmapi+0x8ba/0x10b0 [xfs]
 xfs_bunmapi+0x19/0x30 [xfs]
 xfs_dir2_shrink_inode+0x94/0x2d0 [xfs]
 xfs_dir2_node_removename+0x87f/0x9e0 [xfs]
 xfs_dir_removename+0x1eb/0x2b0 [xfs]
 ? xfs_iunlink+0x169/0x310 [xfs]
 xfs_remove+0x426/0x510 [xfs]
 xfs_vn_unlink+0x57/0xa0 [xfs]
 vfs_unlink+0xf2/0x1e0
 do_unlinkat+0x1a5/0x2e0
 do_syscall_64+0x31/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f892cca4e6b

Just like in the first scenario, we hold two ILOCKs -- a directory, and
a file that we're removing from the directory.  The removal triggers the
same bmbt split worker because we're shrinking the directory, and upon
its completion we call rwsem_acquire to reset the lockdep maps.

Unfortunately, in this case, we actually /are/ feeding the correct
subclass information to rwsem_acquire.  This time it's pointing out what
it thinks is an inconsistency in our locking order: the first time we
locked the directory and then the regular file inode, but now we hold
the regular file inode and we're asking it for the directory ILOCK.

(Note that we don't actually deadlock here because pid 25035 has
maintained ownership of the directory ILOCK rwsem this whole time, but
lockdep doesn't know that.)

A crappy way to bypass this problem is the following garbage patch
which disables lockdep chain checking since we never actually dropped
any of the ILOCKs that are being complained about.  Messing with low
level lockdep internals seems sketchy to me, but so it goes.

The patch also has the major flaw that it doesn't recapture the subclass
information, but doing that is left as an exercise to the reader. ;)

--D

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 9756a63e78f4..3146932de7fe 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2820,7 +2820,7 @@ xfs_btree_split_worker(
 	/*
 	 * Tranfer lock ownership to workqueue task.
 	 */
-	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
+	lock_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, 0, 0, NULL, _RET_IP_);
 	/*
 	 * we are in a transaction context here, but may also be doing work
 	 * in kswapd context, and hence we may need to inherit that state
@@ -2882,7 +2882,7 @@ xfs_btree_split(
 	/*
 	 * Tranfer lock ownership back to the thread.
 	 */
-	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
+	lock_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, 0, 0, NULL, _RET_IP_);
 	destroy_work_on_stack(&args.work);
 	return args.result;
 }
