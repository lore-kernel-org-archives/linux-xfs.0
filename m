Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1DAAD7F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 00:30:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF7D7304048
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 22:30:01 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id tHIEjiKOOVJZzIiN for
	<xfs@oss.sgi.com>; Tue, 27 May 2014 22:29:55 -0700 (PDT)
Message-ID: <538571D4.70904@cn.fujitsu.com>
Date: Wed, 28 May 2014 13:19:16 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: xfs: possible deadlock warning
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>

Hi all,
When running the latest Linus' tree, the following possible deadlock warning occurs.

[  140.949000] ======================================================
[  140.949000] [ INFO: possible circular locking dependency detected ]
[  140.949000] 3.15.0-rc7+ #93 Not tainted
[  140.949000] -------------------------------------------------------
[  140.949000] qemu-kvm/5056 is trying to acquire lock:
[  140.949000]  (&isec->lock){+.+.+.}, at: [<ffffffff8128c835>] inode_doinit_with_dentry+0xa5/0x640
[  140.949000] 
[  140.949000] but task is already holding lock:
[  140.949000]  (&mm->mmap_sem){++++++}, at: [<ffffffff81182bcf>] vm_mmap_pgoff+0x6f/0xc0
[  140.949000] 
[  140.949000] which lock already depends on the new lock.
[  140.949000] 
[  140.949000] 
[  140.949000] the existing dependency chain (in reverse order) is:
[  140.949000] 
[  140.949000] -> #2 (&mm->mmap_sem){++++++}:
[  140.949000]        [<ffffffff810c214c>] __lock_acquire+0xadc/0x12f0
[  140.949000]        [<ffffffff810c3152>] lock_acquire+0xa2/0x130
[  140.949000]        [<ffffffff8118dbdc>] might_fault+0x8c/0xb0
[  140.949000]        [<ffffffff811f1371>] filldir+0x91/0x120
[  140.949000]        [<ffffffffa01ff788>] xfs_dir2_block_getdents+0x1e8/0x250 [xfs]
[  140.949000]        [<ffffffffa01ff92a>] xfs_readdir+0xda/0x120 [xfs]
[  140.949000]        [<ffffffffa02017db>] xfs_file_readdir+0x2b/0x40 [xfs]
[  140.949000]        [<ffffffff811f11b8>] iterate_dir+0xa8/0xe0
[  140.949000]        [<ffffffff811f165a>] SyS_getdents+0x8a/0x120
[  140.949000]        [<ffffffff8164b269>] system_call_fastpath+0x16/0x1b
[  140.949000] 
[  140.949000] -> #1 (&xfs_dir_ilock_class){++++.+}:
[  140.949000]        [<ffffffff810c214c>] __lock_acquire+0xadc/0x12f0
[  140.949000]        [<ffffffff810c3152>] lock_acquire+0xa2/0x130
[  140.949000]        [<ffffffff810bc547>] down_read_nested+0x57/0xa0
[  140.949000]        [<ffffffffa0247602>] xfs_ilock+0xf2/0x120 [xfs]
[  140.949000]        [<ffffffffa02476a4>] xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
[  140.949000]        [<ffffffffa021d229>] xfs_attr_get+0x79/0xb0 [xfs]
[  140.949000]        [<ffffffffa02162f7>] xfs_xattr_get+0x37/0x50 [xfs]
[  140.949000]        [<ffffffff812034cf>] generic_getxattr+0x4f/0x70
[  140.949000]        [<ffffffff8128c8e0>] inode_doinit_with_dentry+0x150/0x640
[  140.949000]        [<ffffffff8128cea8>] sb_finish_set_opts+0xd8/0x270
[  140.949000]        [<ffffffff8128d2cf>] selinux_set_mnt_opts+0x28f/0x5e0
[  140.949000]        [<ffffffff8128d688>] superblock_doinit+0x68/0xd0
[  140.949000]        [<ffffffff8128d700>] delayed_superblock_init+0x10/0x20
[  140.949000]        [<ffffffff811e0a82>] iterate_supers+0xb2/0x110
[  140.949000]        [<ffffffff8128ef33>] selinux_complete_init+0x33/0x40
[  140.949000]        [<ffffffff8129d6b4>] security_load_policy+0xf4/0x600
[  140.949000]        [<ffffffff812908bc>] sel_write_load+0xac/0x750
[  140.949000]        [<ffffffff811dd0ad>] vfs_write+0xbd/0x1f0
[  140.949000]        [<ffffffff811ddc29>] SyS_write+0x49/0xb0
[  140.949000]        [<ffffffff8164b269>] system_call_fastpath+0x16/0x1b
[  140.949000] 
[  140.949000] -> #0 (&isec->lock){+.+.+.}:
[  140.949000]        [<ffffffff810c0c51>] check_prevs_add+0x951/0x970
[  140.949000]        [<ffffffff810c214c>] __lock_acquire+0xadc/0x12f0
[  140.949000]        [<ffffffff810c3152>] lock_acquire+0xa2/0x130
[  140.949000]        [<ffffffff8163e038>] mutex_lock_nested+0x78/0x4f0
[  140.949000]        [<ffffffff8128c835>] inode_doinit_with_dentry+0xa5/0x640
[  140.949000]        [<ffffffff8128d97c>] selinux_d_instantiate+0x1c/0x20
[  140.949000]        [<ffffffff81283a1b>] security_d_instantiate+0x1b/0x30
[  140.949000]        [<ffffffff811f4fb0>] d_instantiate+0x50/0x70
[  140.950000]        [<ffffffff8117eb10>] __shmem_file_setup+0xe0/0x1d0
[  140.950000]        [<ffffffff81181488>] shmem_zero_setup+0x28/0x70
[  140.950000]        [<ffffffff811999f3>] mmap_region+0x543/0x5a0
[  140.950000]        [<ffffffff81199d51>] do_mmap_pgoff+0x301/0x3d0
[  140.950000]        [<ffffffff81182bf0>] vm_mmap_pgoff+0x90/0xc0
[  140.950000]        [<ffffffff81182c4d>] vm_mmap+0x2d/0x40
[  140.950000]        [<ffffffffa0765177>] kvm_arch_prepare_memory_region+0x47/0x60 [kvm]
[  140.950000]        [<ffffffffa074ed6f>] __kvm_set_memory_region+0x1ff/0x770 [kvm]
[  140.950000]        [<ffffffffa074f30d>] kvm_set_memory_region+0x2d/0x50 [kvm]
[  140.950000]        [<ffffffffa0b2e0da>] vmx_set_tss_addr+0x4a/0x190 [kvm_intel]
[  140.950000]        [<ffffffffa0760bc0>] kvm_arch_vm_ioctl+0x9c0/0xb80 [kvm]
[  140.950000]        [<ffffffffa074f3be>] kvm_vm_ioctl+0x8e/0x730 [kvm]
[  140.950000]        [<ffffffff811f0e50>] do_vfs_ioctl+0x300/0x520
[  140.950000]        [<ffffffff811f10f1>] SyS_ioctl+0x81/0xa0
[  140.950000]        [<ffffffff8164b269>] system_call_fastpath+0x16/0x1b
[  140.950000] 
[  140.950000] other info that might help us debug this:
[  140.950000] 
[  140.950000] Chain exists of:
[  140.950000]   &isec->lock --> &xfs_dir_ilock_class --> &mm->mmap_sem
[  140.950000] 
[  140.950000]  Possible unsafe locking scenario:
[  140.950000] 
[  140.950000]        CPU0                    CPU1
[  140.950000]        ----                    ----
[  140.950000]   lock(&mm->mmap_sem);
[  140.950000]                                lock(&xfs_dir_ilock_class);
[  140.950000]                                lock(&mm->mmap_sem);
[  140.950000]   lock(&isec->lock);
[  140.950000] 
[  140.950000]  *** DEADLOCK ***
[  140.950000] 
[  140.950000] 2 locks held by qemu-kvm/5056:
[  140.950000]  #0:  (&kvm->slots_lock){+.+.+.}, at: [<ffffffffa074f302>] kvm_set_memory_region+0x22/0x50 [kvm]
[  140.950000]  #1:  (&mm->mmap_sem){++++++}, at: [<ffffffff81182bcf>] vm_mmap_pgoff+0x6f/0xc0
[  140.950000] 
[  140.950000] stack backtrace:
[  140.950000] CPU: 76 PID: 5056 Comm: qemu-kvm Not tainted 3.15.0-rc7+ #93
[  140.950000] Hardware name: FUJITSU PRIMEQUEST2800E/SB, BIOS PRIMEQUEST 2000 Series BIOS Version 01.48 05/07/2014
[  140.950000]  ffffffff823925a0 ffff880830ba7750 ffffffff81638c00 ffffffff82321bc0
[  140.950000]  ffff880830ba7790 ffffffff81632d63 ffff880830ba77c0 0000000000000001
[  140.950000]  ffff8808359540d8 ffff8808359540d8 ffff880835953480 0000000000000002
[  140.950000] Call Trace:
[  140.950000]  [<ffffffff81638c00>] dump_stack+0x4d/0x66
[  140.950000]  [<ffffffff81632d63>] print_circular_bug+0x1f9/0x207
[  140.950000]  [<ffffffff810c0c51>] check_prevs_add+0x951/0x970
[  140.950000]  [<ffffffff810c214c>] __lock_acquire+0xadc/0x12f0
[  140.950000]  [<ffffffff810c3152>] lock_acquire+0xa2/0x130
[  140.950000]  [<ffffffff8128c835>] ? inode_doinit_with_dentry+0xa5/0x640
[  140.950000]  [<ffffffff8163e038>] mutex_lock_nested+0x78/0x4f0
[  140.950000]  [<ffffffff8128c835>] ? inode_doinit_with_dentry+0xa5/0x640
[  140.950000]  [<ffffffff8128c835>] ? inode_doinit_with_dentry+0xa5/0x640
[  140.950000]  [<ffffffff8101cd69>] ? sched_clock+0x9/0x10
[  140.950000]  [<ffffffff810a6545>] ? local_clock+0x25/0x30
[  140.950000]  [<ffffffff8128c835>] inode_doinit_with_dentry+0xa5/0x640
[  140.950000]  [<ffffffff8128d97c>] selinux_d_instantiate+0x1c/0x20
[  140.950000]  [<ffffffff81283a1b>] security_d_instantiate+0x1b/0x30
[  140.950000]  [<ffffffff811f4fb0>] d_instantiate+0x50/0x70
[  140.950000]  [<ffffffff8117eb10>] __shmem_file_setup+0xe0/0x1d0
[  140.950000]  [<ffffffff81181488>] shmem_zero_setup+0x28/0x70
[  140.950000]  [<ffffffff811999f3>] mmap_region+0x543/0x5a0
[  140.950000]  [<ffffffff81199d51>] do_mmap_pgoff+0x301/0x3d0
[  140.950000]  [<ffffffff81182bf0>] vm_mmap_pgoff+0x90/0xc0
[  140.950000]  [<ffffffff81182c4d>] vm_mmap+0x2d/0x40
[  140.950000]  [<ffffffffa0765177>] kvm_arch_prepare_memory_region+0x47/0x60 [kvm]
[  140.950000]  [<ffffffffa074ed6f>] __kvm_set_memory_region+0x1ff/0x770 [kvm]
[  140.950000]  [<ffffffff810c1085>] ? mark_held_locks+0x75/0xa0
[  140.950000]  [<ffffffffa074f30d>] kvm_set_memory_region+0x2d/0x50 [kvm]
[  140.950000]  [<ffffffffa0b2e0da>] vmx_set_tss_addr+0x4a/0x190 [kvm_intel]
[  140.950000]  [<ffffffffa0760bc0>] kvm_arch_vm_ioctl+0x9c0/0xb80 [kvm]
[  140.950000]  [<ffffffff810c1920>] ? __lock_acquire+0x2b0/0x12f0
[  140.950000]  [<ffffffff810c34e8>] ? lock_release_non_nested+0x308/0x350
[  140.950000]  [<ffffffff8101cd69>] ? sched_clock+0x9/0x10
[  140.950000]  [<ffffffff810a6545>] ? local_clock+0x25/0x30
[  140.950000]  [<ffffffff810bde3f>] ? lock_release_holdtime.part.28+0xf/0x190
[  140.950000]  [<ffffffffa074f3be>] kvm_vm_ioctl+0x8e/0x730 [kvm]
[  140.950000]  [<ffffffff811f0e50>] do_vfs_ioctl+0x300/0x520
[  140.950000]  [<ffffffff81287e86>] ? file_has_perm+0x86/0xa0
[  140.950000]  [<ffffffff811f10f1>] SyS_ioctl+0x81/0xa0
[  140.950000]  [<ffffffff8111383c>] ? __audit_syscall_entry+0x9c/0xf0
[  140.950000]  [<ffffffff8164b269>] system_call_fastpath+0x16/0x1b

Thanks,
Gu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
