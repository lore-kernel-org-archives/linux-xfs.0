Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46502 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbeHQLqD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Aug 2018 07:46:03 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 127122B20A
        for <linux-xfs@vger.kernel.org>; Fri, 17 Aug 2018 08:43:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200835] XFS hangs in xfs_reclaim_inode()
Date: Fri, 17 Aug 2018 08:43:31 +0000
Message-ID: <bug-200835-201763-sPx2DFTjWk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200835-201763@https.bugzilla.kernel.org/>
References: <bug-200835-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200835

--- Comment #5 from Dave Chinner (david@fromorbit.com) ---
Ok, so the hung task warnings should up 3m30s after the delete script starts,
then there's a second, smaller set almost exactly 120s after the first which is
a repeat of some of the warnings from the first set that had not resolved
themselves. 

The thing I note is that the log push that is "hung" waiting for journal buffer
space is reported in the first set of warnings but not the second set, andthe
second set only contains 2 tasks, not the 7 that are in the first set. Further,
I note that kcryptd (i.e. dm-crypt) is one of the tasks that is hung, so
there's an encrypted filesystem configured - is it the XFS filesystem files are
being deleted from?

Finally, after the second set of warnings, there are no more warnings, so
whatever is occurred is temporary and the filesystem is not actually hung. i.e.
there's no direct evidence in that trace that there was a complete system hang.
However, there is evidence of a potential problem if your XFS filesystem is
hosted on dm-crypt volumes.

i.e. this:

Aug 16 02:33:30 hpmicroserver kernel: Workqueue: kcryptd kcryptd_crypt
[dm_crypt]
Aug 16 02:33:30 hpmicroserver kernel: Call Trace:
Aug 16 02:33:30 hpmicroserver kernel:  ? __schedule+0x284/0x860
Aug 16 02:33:30 hpmicroserver kernel:  schedule+0x28/0x80
Aug 16 02:33:30 hpmicroserver kernel:  schedule_timeout+0x292/0x370
Aug 16 02:33:30 hpmicroserver kernel:  ? check_preempt_curr+0x62/0x90
Aug 16 02:33:30 hpmicroserver kernel:  wait_for_completion+0xaf/0x140
Aug 16 02:33:30 hpmicroserver kernel:  ? wake_up_q+0x70/0x70
Aug 16 02:33:30 hpmicroserver kernel:  flush_work+0x116/0x1d0
Aug 16 02:33:30 hpmicroserver kernel:  ? worker_detach_from_pool+0xa0/0xa0
Aug 16 02:33:30 hpmicroserver kernel:  xlog_cil_force_lsn+0x78/0x210 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  _xfs_log_force_lsn+0x71/0x340 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  ? xfs_reclaim_inode+0xe3/0x340 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  __xfs_iunpin_wait+0xa7/0x160 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  ? bit_waitqueue+0x30/0x30
Aug 16 02:33:30 hpmicroserver kernel:  xfs_reclaim_inode+0xe3/0x340 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  xfs_reclaim_inodes_ag+0x1b1/0x300 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
Aug 16 02:33:30 hpmicroserver kernel:  super_cache_scan+0x152/0x1a0
Aug 16 02:33:30 hpmicroserver kernel:  shrink_slab.part.45+0x1e8/0x3c0
Aug 16 02:33:30 hpmicroserver kernel:  shrink_node+0x123/0x310
Aug 16 02:33:30 hpmicroserver kernel:  do_try_to_free_pages+0xc3/0x330
Aug 16 02:33:30 hpmicroserver kernel:  try_to_free_pages+0xf4/0x1b0
Aug 16 02:33:30 hpmicroserver kernel:  __alloc_pages_slowpath+0x3e4/0xd80
Aug 16 02:33:30 hpmicroserver kernel:  __alloc_pages_nodemask+0x226/0x240
Aug 16 02:33:30 hpmicroserver kernel:  new_slab+0x2f3/0x620
Aug 16 02:33:30 hpmicroserver kernel:  ___slab_alloc+0x322/0x4a0
Aug 16 02:33:30 hpmicroserver kernel:  ? __alloc_pages_slowpath+0xd4d/0xd80
Aug 16 02:33:30 hpmicroserver kernel:  ? init_crypt+0x7f/0xd0 [xts]
Aug 16 02:33:30 hpmicroserver kernel:  __slab_alloc+0x1c/0x30
Aug 16 02:33:30 hpmicroserver kernel:  __kmalloc+0x18e/0x1f0
Aug 16 02:33:30 hpmicroserver kernel:  init_crypt+0x7f/0xd0 [xts]
Aug 16 02:33:30 hpmicroserver kernel:  encrypt+0x15/0x20 [xts]
Aug 16 02:33:30 hpmicroserver kernel:  crypt_convert+0x954/0xec0 [dm_crypt]
Aug 16 02:33:30 hpmicroserver kernel:  ? bio_alloc_bioset+0x132/0x1e0
Aug 16 02:33:30 hpmicroserver kernel:  kcryptd_crypt+0x2b8/0x370 [dm_crypt]
Aug 16 02:33:30 hpmicroserver kernel:  process_one_work+0x1e9/0x3b0
Aug 16 02:33:30 hpmicroserver kernel:  worker_thread+0x2b/0x3f0
Aug 16 02:33:30 hpmicroserver kernel:  ? pwq_unbound_release_workfn+0xc0/0xc0
Aug 16 02:33:30 hpmicroserver kernel:  kthread+0x119/0x130
Aug 16 02:33:30 hpmicroserver kernel:  ? __kthread_parkme+0xa0/0xa0
Au

This appears to be a potential deadlock via incorrect memory allocation
contexts in dm-crypt. i.e. the crypto code it uses is doing GFP_KERNEL
allocations while setting up the encryption context which allows it to get
stuck in a filesystem that can't make progress until the encryption completes.
. i.e. the dm-crypt/crypto allocation context should probably be GFP_NOIO to
prevent memory reclaim recursion into contexts that might be already be
dependent on dm-crypt making progress (i.e. filesystems)....

This isn't really looking like an XFS issue at this point....

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
