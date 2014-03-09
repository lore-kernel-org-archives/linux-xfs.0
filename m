Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D11667F50
	for <xfs@oss.sgi.com>; Sat,  8 Mar 2014 20:58:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA0C28F8037
	for <xfs@oss.sgi.com>; Sat,  8 Mar 2014 18:58:08 -0800 (PST)
Received: from mail-qg0-f45.google.com (mail-qg0-f45.google.com
	[209.85.192.45]) by cuda.sgi.com with ESMTP id egZyGRflWwrwFshc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 08 Mar 2014 18:58:03 -0800 (PST)
Received: by mail-qg0-f45.google.com with SMTP id j5so16530105qga.4
	for <xfs@oss.sgi.com>; Sat, 08 Mar 2014 18:58:03 -0800 (PST)
Received: from [192.168.0.129] (rrcs-97-79-21-178.se.biz.rr.com.
	[97.79.21.178]) by mx.google.com with ESMTPSA id
	q10sm44591138qaj.13.2014.03.08.18.58.02 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Sat, 08 Mar 2014 18:58:02 -0800 (PST)
Message-ID: <531BD8B9.1090400@gmail.com>
Date: Sat, 08 Mar 2014 21:58:01 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Multi-CPU harmless lockdep on x86 while copying data
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
To: xfs-oss <xfs@oss.sgi.com>

Hi!  I was playing a shell game with some precious backup data.  It 
went like this:

open a 36-GB source partition (DM linear, partitions from 2 drives, 
   v5-superblock XFS)

open a 32-GB aes-xts crypt (v4-superblock XFS)

`cp -av` from holding partition to crypt

It was during the cp operation that I got this multi-CPU version of 
the harmless lockdep:

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.14.0-rc5+ #6 Not tainted
---------------------------------------------------------
kswapd0/25 just changed the state of lock:
 (&xfs_dir_ilock_class){++++-.}, at: [<791c09fa>] xfs_ilock+0xff/0x16c
but this lock took another, RECLAIM_FS-unsafe lock in the past:
 (&mm->mmap_sem){++++++}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&mm->mmap_sem);
                               local_irq_disable();
                               lock(&xfs_dir_ilock_class);
                               lock(&mm->mmap_sem);
  <Interrupt>
    lock(&xfs_dir_ilock_class);

 *** DEADLOCK ***

3 locks held by kswapd0/25:
 #0:  (shrinker_rwsem){++++..}, at: [<790c04b7>] shrink_slab+0x2a/0xda
 #1:  (&type->s_umount_key#20){++++.+}, at: [<790e55c3>] grab_super_passive+0x3b/0x75
 #2:  (&pag->pag_ici_reclaim_lock){+.+...}, at: [<7917809a>] xfs_reclaim_inodes_ag+0xb4/0x3a7

the shortest dependencies between 2nd lock and 1st lock:
 -> (&mm->mmap_sem){++++++} ops: 146382 {
    HARDIRQ-ON-W at:
                      [<79064553>] __lock_acquire+0x58a/0xa6c
                      [<7906510f>] lock_acquire+0x8b/0x101
                      [<792f6409>] down_write+0x4c/0xa3
                      [<790e96e5>] do_execve_common+0x2bf/0x5bf
                      [<790e99f2>] do_execve+0xd/0xf
                      [<79000341>] run_init_process+0x21/0x23
                      [<79000357>] try_to_run_init_process+0x14/0x4d
                      [<792ec5cf>] kernel_init+0x90/0xce
                      [<792f8537>] ret_from_kernel_thread+0x1b/0x28
    HARDIRQ-ON-R at:
                      [<79064477>] __lock_acquire+0x4ae/0xa6c
                      [<7906510f>] lock_acquire+0x8b/0x101
                      [<790d1718>] might_fault+0x81/0xa9
                      [<7922fc80>] clear_user+0x13/0x46
                      [<79123c80>] padzero+0x22/0x2e
                      [<7912552b>] load_elf_binary+0x500/0xd35
                      [<790e93ec>] search_binary_handler+0x72/0xac
                      [<790e98c1>] do_execve_common+0x49b/0x5bf
                      [<790e99f2>] do_execve+0xd/0xf
                      [<79000341>] run_init_process+0x21/0x23
                      [<79000357>] try_to_run_init_process+0x14/0x4d
                      [<792ec5cf>] kernel_init+0x90/0xce
                      [<792f8537>] ret_from_kernel_thread+0x1b/0x28
    SOFTIRQ-ON-W at:
                      [<79064579>] __lock_acquire+0x5b0/0xa6c
                      [<7906510f>] lock_acquire+0x8b/0x101
                      [<792f6409>] down_write+0x4c/0xa3
                      [<790e96e5>] do_execve_common+0x2bf/0x5bf
                      [<790e99f2>] do_execve+0xd/0xf
                      [<79000341>] run_init_process+0x21/0x23
                      [<79000357>] try_to_run_init_process+0x14/0x4d
                      [<792ec5cf>] kernel_init+0x90/0xce
                      [<792f8537>] ret_from_kernel_thread+0x1b/0x28
    SOFTIRQ-ON-R at:
                      [<79064579>] __lock_acquire+0x5b0/0xa6c
                      [<7906510f>] lock_acquire+0x8b/0x101
                      [<790d1718>] might_fault+0x81/0xa9
                      [<7922fc80>] clear_user+0x13/0x46
                      [<79123c80>] padzero+0x22/0x2e
                      [<7912552b>] load_elf_binary+0x500/0xd35
                      [<790e93ec>] search_binary_handler+0x72/0xac
                      [<790e98c1>] do_execve_common+0x49b/0x5bf
                      [<790e99f2>] do_execve+0xd/0xf
                      [<79000341>] run_init_process+0x21/0x23
                      [<79000357>] try_to_run_init_process+0x14/0x4d
                      [<792ec5cf>] kernel_init+0x90/0xce
                      [<792f8537>] ret_from_kernel_thread+0x1b/0x28
    RECLAIM_FS-ON-W at:
                         [<790620d7>] mark_held_locks+0x81/0xe7
                         [<79062aac>] lockdep_trace_alloc+0xa5/0xe6
                         [<790b97a5>] __alloc_pages_nodemask+0x6f/0x6be
                         [<790dfb14>] new_slab+0x5f/0x21c
                         [<792f1a88>] __slab_alloc.isra.59.constprop.67+0x25f/0x43d
                         [<790e0974>] kmem_cache_alloc+0x91/0xf9
                         [<790d35ed>] __split_vma.isra.34+0x28/0x141
                         [<790d4523>] do_munmap+0x234/0x2b0
                         [<790d5115>] vm_munmap+0x37/0x4a
                         [<790d513b>] SyS_munmap+0x13/0x15
                         [<792f85b8>] sysenter_do_call+0x12/0x36
    RECLAIM_FS-ON-R at:
                         [<790620d7>] mark_held_locks+0x81/0xe7
                         [<79062aac>] lockdep_trace_alloc+0xa5/0xe6
                         [<790b97a5>] __alloc_pages_nodemask+0x6f/0x6be
                         [<790269fa>] pte_alloc_one+0x24/0x3c
                         [<790cead5>] __pte_alloc+0x1a/0x85
                         [<790d0d0c>] handle_mm_fault+0x5d8/0x604
                         [<79023d1f>] __do_page_fault+0x110/0x3bc
                         [<790240d3>] do_page_fault+0xd/0xf
                         [<792f832b>] error_code+0x5f/0x64
                         [<79123c80>] padzero+0x22/0x2e
                         [<7912552b>] load_elf_binary+0x500/0xd35
                         [<790e93ec>] search_binary_handler+0x72/0xac
                         [<790e98c1>] do_execve_common+0x49b/0x5bf
                         [<790e99f2>] do_execve+0xd/0xf
                         [<79000341>] run_init_process+0x21/0x23
                         [<79000357>] try_to_run_init_process+0x14/0x4d
                         [<792ec5cf>] kernel_init+0x90/0xce
                         [<792f8537>] ret_from_kernel_thread+0x1b/0x28
    INITIAL USE at:
                     [<79064276>] __lock_acquire+0x2ad/0xa6c
                     [<7906510f>] lock_acquire+0x8b/0x101
                     [<792f6409>] down_write+0x4c/0xa3
                     [<790e96e5>] do_execve_common+0x2bf/0x5bf
                     [<790e99f2>] do_execve+0xd/0xf
                     [<79000341>] run_init_process+0x21/0x23
                     [<79000357>] try_to_run_init_process+0x14/0x4d
                     [<792ec5cf>] kernel_init+0x90/0xce
                     [<792f8537>] ret_from_kernel_thread+0x1b/0x28
  }
  ... key      at: [<795f1eec>] __key.44037+0x0/0x8
  ... acquired at:
   [<79064360>] __lock_acquire+0x397/0xa6c
   [<7906510f>] lock_acquire+0x8b/0x101
   [<790d1718>] might_fault+0x81/0xa9
   [<790f379a>] filldir64+0x92/0xe2
   [<7916f079>] xfs_dir2_sf_getdents+0x1a0/0x44c
   [<7917009e>] xfs_readdir+0xc4/0x126
   [<79171b8b>] xfs_file_readdir+0x25/0x3e
   [<790f385a>] iterate_dir+0x70/0x9b
   [<790f3a31>] SyS_getdents64+0x6d/0xcc
   [<792f85b8>] sysenter_do_call+0x12/0x36

-> (&xfs_dir_ilock_class){++++-.} ops: 11354 {
   HARDIRQ-ON-W at:
                    [<79064553>] __lock_acquire+0x58a/0xa6c
                    [<7906510f>] lock_acquire+0x8b/0x101
                    [<7905e559>] down_write_nested+0x4f/0x9f
                    [<791c09fa>] xfs_ilock+0xff/0x16c
                    [<7917db25>] xfs_vn_update_time+0x6c/0x150
                    [<790f9302>] update_time+0x1e/0x9e
                    [<790faed8>] touch_atime+0xcd/0x101
                    [<790f3879>] iterate_dir+0x8f/0x9b
                    [<790f3a31>] SyS_getdents64+0x6d/0xcc
                    [<792f85b8>] sysenter_do_call+0x12/0x36
   HARDIRQ-ON-R at:
                    [<79064477>] __lock_acquire+0x4ae/0xa6c
                    [<7906510f>] lock_acquire+0x8b/0x101
                    [<7905e409>] down_read_nested+0x4f/0x8a
                    [<791c09b4>] xfs_ilock+0xb9/0x16c
                    [<791c0a85>] xfs_ilock_data_map_shared+0x1e/0x3a
                    [<79172550>] xfs_dir_open+0x2e/0x64
                    [<790e1d86>] do_dentry_open.isra.26+0x115/0x221
                    [<790e2f06>] finish_open+0x1b/0x27
                    [<790ef0e6>] do_last.isra.60+0x89c/0xe6b
                    [<790ef75e>] path_openat+0xa9/0x4fe
                    [<790efbe4>] do_filp_open+0x31/0x72
                    [<790e339a>] do_sys_open+0x112/0x181
                    [<790e344d>] SyS_openat+0x20/0x22
                    [<792f85b8>] sysenter_do_call+0x12/0x36
   SOFTIRQ-ON-W at:
                    [<79064579>] __lock_acquire+0x5b0/0xa6c
                    [<7906510f>] lock_acquire+0x8b/0x101
                    [<7905e559>] down_write_nested+0x4f/0x9f
                    [<791c09fa>] xfs_ilock+0xff/0x16c
                    [<7917db25>] xfs_vn_update_time+0x6c/0x150
                    [<790f9302>] update_time+0x1e/0x9e
                    [<790faed8>] touch_atime+0xcd/0x101
                    [<790f3879>] iterate_dir+0x8f/0x9b
                    [<790f3a31>] SyS_getdents64+0x6d/0xcc
                    [<792f85b8>] sysenter_do_call+0x12/0x36
   SOFTIRQ-ON-R at:
                    [<79064579>] __lock_acquire+0x5b0/0xa6c
                    [<7906510f>] lock_acquire+0x8b/0x101
                    [<7905e409>] down_read_nested+0x4f/0x8a
                    [<791c09b4>] xfs_ilock+0xb9/0x16c
                    [<791c0a85>] xfs_ilock_data_map_shared+0x1e/0x3a
                    [<79172550>] xfs_dir_open+0x2e/0x64
                    [<790e1d86>] do_dentry_open.isra.26+0x115/0x221
                    [<790e2f06>] finish_open+0x1b/0x27
                    [<790ef0e6>] do_last.isra.60+0x89c/0xe6b
                    [<790ef75e>] path_openat+0xa9/0x4fe
                    [<790efbe4>] do_filp_open+0x31/0x72
                    [<790e339a>] do_sys_open+0x112/0x181
                    [<790e344d>] SyS_openat+0x20/0x22
                    [<792f85b8>] sysenter_do_call+0x12/0x36
   IN-RECLAIM_FS-W at:
                       [<79064676>] __lock_acquire+0x6ad/0xa6c
                       [<7906510f>] lock_acquire+0x8b/0x101
                       [<7905e559>] down_write_nested+0x4f/0x9f
                       [<791c09fa>] xfs_ilock+0xff/0x16c
                       [<79177db4>] xfs_reclaim_inode+0xdb/0x30d
                       [<79178260>] xfs_reclaim_inodes_ag+0x27a/0x3a7
                       [<7917840b>] xfs_reclaim_inodes_nr+0x2d/0x33
                       [<791837d1>] xfs_fs_free_cached_objects+0x13/0x15
                       [<790e57f8>] super_cache_scan+0x129/0x12d
                       [<790befdc>] shrink_slab_node+0x125/0x270
                       [<790c04f0>] shrink_slab+0x63/0xda
                       [<790c273e>] kswapd+0x31d/0x770
                       [<790458fa>] kthread+0xa1/0xb6
                       [<792f8537>] ret_from_kernel_thread+0x1b/0x28
   INITIAL USE at:
                   [<79064276>] __lock_acquire+0x2ad/0xa6c
                   [<7906510f>] lock_acquire+0x8b/0x101
                   [<7905e409>] down_read_nested+0x4f/0x8a
                   [<791c09b4>] xfs_ilock+0xb9/0x16c
                   [<791c0a85>] xfs_ilock_data_map_shared+0x1e/0x3a
                   [<79172550>] xfs_dir_open+0x2e/0x64
                   [<790e1d86>] do_dentry_open.isra.26+0x115/0x221
                   [<790e2f06>] finish_open+0x1b/0x27
                   [<790ef0e6>] do_last.isra.60+0x89c/0xe6b
                   [<790ef75e>] path_openat+0xa9/0x4fe
                   [<790efbe4>] do_filp_open+0x31/0x72
                   [<790e339a>] do_sys_open+0x112/0x181
                   [<790e344d>] SyS_openat+0x20/0x22
                   [<792f85b8>] sysenter_do_call+0x12/0x36
 }
 ... key      at: [<79bfe07c>] xfs_dir_ilock_class+0x0/0x8
 ... acquired at:
   [<79060873>] check_usage_forwards+0xf8/0xfa
   [<79061f62>] mark_lock+0x1b3/0x2a7
   [<79064676>] __lock_acquire+0x6ad/0xa6c
   [<7906510f>] lock_acquire+0x8b/0x101
   [<7905e559>] down_write_nested+0x4f/0x9f
   [<791c09fa>] xfs_ilock+0xff/0x16c
   [<79177db4>] xfs_reclaim_inode+0xdb/0x30d
   [<79178260>] xfs_reclaim_inodes_ag+0x27a/0x3a7
   [<7917840b>] xfs_reclaim_inodes_nr+0x2d/0x33
   [<791837d1>] xfs_fs_free_cached_objects+0x13/0x15
   [<790e57f8>] super_cache_scan+0x129/0x12d
   [<790befdc>] shrink_slab_node+0x125/0x270
   [<790c04f0>] shrink_slab+0x63/0xda
   [<790c273e>] kswapd+0x31d/0x770
   [<790458fa>] kthread+0xa1/0xb6
   [<792f8537>] ret_from_kernel_thread+0x1b/0x28


stack backtrace:
CPU: 0 PID: 25 Comm: kswapd0 Not tainted 3.14.0-rc5+ #6
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
 00000000 00000000 781b1b6c 792f2495 781b1bb0 781b1b90 792efde6 793b75f7
 793b7965 00000019 7819b1c0 00000000 7819b654 7819b1c0 781b1be0 79060873
 7819b654 00000001 793b7965 781b1bac 79a83100 79a83100 79834600 7819b654
Call Trace:
 [<792f2495>] dump_stack+0x48/0x60
 [<792efde6>] print_irq_inversion_bug.part.36+0x173/0x17b
 [<79060873>] check_usage_forwards+0xf8/0xfa
 [<7906077b>] ? check_usage_backwards+0xfc/0xfc
 [<79061f62>] mark_lock+0x1b3/0x2a7
 [<79053956>] ? sched_clock_local+0x42/0x12e
 [<7906077b>] ? check_usage_backwards+0xfc/0xfc
 [<79064676>] __lock_acquire+0x6ad/0xa6c
 [<7906510f>] lock_acquire+0x8b/0x101
 [<791c09fa>] ? xfs_ilock+0xff/0x16c
 [<7905e559>] down_write_nested+0x4f/0x9f
 [<791c09fa>] ? xfs_ilock+0xff/0x16c
 [<791c09fa>] xfs_ilock+0xff/0x16c
 [<79177db4>] xfs_reclaim_inode+0xdb/0x30d
 [<79178260>] xfs_reclaim_inodes_ag+0x27a/0x3a7
 [<791780cc>] ? xfs_reclaim_inodes_ag+0xe6/0x3a7
 [<7917840b>] xfs_reclaim_inodes_nr+0x2d/0x33
 [<791837d1>] xfs_fs_free_cached_objects+0x13/0x15
 [<790e57f8>] super_cache_scan+0x129/0x12d
 [<790befdc>] shrink_slab_node+0x125/0x270
 [<790c04b7>] ? shrink_slab+0x2a/0xda
 [<790c04f0>] shrink_slab+0x63/0xda
 [<790c273e>] kswapd+0x31d/0x770
 [<790c2421>] ? try_to_free_pages+0x373/0x373
 [<790458fa>] kthread+0xa1/0xb6
 [<790624ff>] ? trace_hardirqs_on+0xb/0xd
 [<792f8537>] ret_from_kernel_thread+0x1b/0x28
 [<79045859>] ? __kthread_parkme+0x57/0x57
[sched_delayed] sched: RT throttling activated
cp (149) used greatest stack depth: 5152 bytes left

I call it harmless because its single-CPU variant can be reproduced
as far back as I could bisect in earlier testing (way before
kernel 2.6.20).  However, such lockdep splats have never manifested
in a noticeable problem on production kernels on x86.  Either
down_write_nested or down_read_nested is in all of them, depending
on which kernel version is in use.  At least one reclaim-related
function is in there as well.  vm_map_ram used to be in there, but Dave 
took care of that (thanks!).

This particular splat has been showing up more often, though.  It's not
tied to one particular commit, event, or change; just something that
has crept in gradually since maybe kernel 3.11.  It's like watching
grass grow or watching paint dry.

Might somebody keep an eye on this?  With enough debug enabled, it
might show on a large cp or `tar -x` operation.  xfstests rarely
invokes such an issue.  It happens when there are enough inodes
and data flowing that RAM should be full.  In many cases, more than one
partition is in play.  crypt partitions are not required.

The test system is an i686 Pentium 4 with 1280 MB of RAM, running a 
stripped-down Slackware 14.1 with elfutils and test programs on top.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
