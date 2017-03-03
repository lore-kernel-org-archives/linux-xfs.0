Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35868 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbdCCPXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 10:23:12 -0500
Received: by mail-io0-f176.google.com with SMTP id l7so76678678ioe.3
        for <linux-xfs@vger.kernel.org>; Fri, 03 Mar 2017 07:22:55 -0800 (PST)
Subject: Re: XFS failure in 4.10+
References: <b1cfa7e4-34e0-ce7b-c65e-cfff6c6c3a3a@kernel.dk>
 <20170303130012.GB21245@bfoster.bfoster>
 <ffedba33-31d4-ee99-e385-72a0fcff8a77@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a21b36b3-7a81-3bb4-175a-3164a169d831@kernel.dk>
Date: Fri, 3 Mar 2017 08:13:43 -0700
MIME-Version: 1.0
In-Reply-To: <ffedba33-31d4-ee99-e385-72a0fcff8a77@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On 03/03/2017 08:04 AM, Jens Axboe wrote:
> On 03/03/2017 06:00 AM, Brian Foster wrote:
>> On Thu, Mar 02, 2017 at 07:38:10PM -0700, Jens Axboe wrote:
>>> Hi,
>>>
>>> Wanted to run some stability testing before sending in a pull
>>> request, and I get the below failure running generic/388 in
>>> the xfstest suite.
>>>
>>> I'm on top of git as of earlier today, 821fd6f6cb65.
>>>
>>> My local.config contains:
>>>
>>> export TEST_DEV=/dev/nvme2n1p1
>>> export TEST_DIR=/mnt/test
>>> export SCRATCH_DEV=/dev/nvme4n1p1
>>> export SCRATCH_MNT=/mnt/scratch
>>>
>>> dmesg output:
>>>
>>> [ 8064.504559] run fstests generic/388 at 2017-03-02 18:07:40
>>> [ 8069.448841] XFS (nvme4n1p1): Mounting V4 Filesystem
>>> [ 8069.499344] XFS (nvme4n1p1): Ending clean mount
>>> [ 8069.521916] XFS (nvme4n1p1): Unmounting Filesystem
>>> [ 8073.306973] XFS (nvme4n1p1): Mounting V4 Filesystem
>>> [ 8073.316757] XFS (nvme4n1p1): Ending clean mount
>>> [ 8075.650699] XFS (nvme4n1p1): Unmounting Filesystem
>>> [ 8075.683976] XFS (nvme4n1p1): Mounting V4 Filesystem
>>> [ 8075.714329] XFS (nvme4n1p1): Starting recovery (logdev: internal)
>>> [ 8077.271261] XFS (nvme4n1p1): Ending recovery (logdev: internal)
>>> [ 8077.287136] XFS (nvme4n1p1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
>>> [ 8077.483879] XFS (nvme4n1p1): Unmounting Filesystem
>>> [ 8077.513120] XFS (nvme4n1p1): Mounting V4 Filesystem
>>> [ 8077.531542] XFS (nvme4n1p1): Starting recovery (logdev: internal)
>>> [ 8077.548649] XFS (nvme4n1p1): Ending recovery (logdev: internal)
>>> [ 8079.704869] XFS (nvme4n1p1): Unmounting Filesystem
>>> [ 8079.736950] XFS (nvme4n1p1): Mounting V4 Filesystem
>>> [ 8079.786530] XFS (nvme4n1p1): Starting recovery (logdev: internal)
>>> [ 8081.394221] XFS (nvme4n1p1): Ending recovery (logdev: internal)
>>> [ 8083.411129] XFS (nvme4n1p1): xfs_do_force_shutdown(0x1) called from line 236 of file fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa02313a1
>>> [ 8083.426496] buffer_io_error: 67587 callbacks suppressed
>>> [ 8083.432580] Buffer I/O error on dev nvme4n1p1, logical block 30554374, lost async page write
>>> [ 8083.442495] Buffer I/O error on dev nvme4n1p1, logical block 30554375, lost async page write
>>> [ 8083.452401] Buffer I/O error on dev nvme4n1p1, logical block 30554376, lost async page write
>>> [ 8083.462300] Buffer I/O error on dev nvme4n1p1, logical block 30554377, lost async page write
>>> [ 8083.472221] Buffer I/O error on dev nvme4n1p1, logical block 30554378, lost async page write
>>> [ 8083.482118] Buffer I/O error on dev nvme4n1p1, logical block 30554379, lost async page write
>>> [ 8083.492019] Buffer I/O error on dev nvme4n1p1, logical block 30554380, lost async page write
>>> [ 8083.502548] Buffer I/O error on dev nvme4n1p1, logical block 30554381, lost async page write
>>> [ 8083.512457] Buffer I/O error on dev nvme4n1p1, logical block 30554382, lost async page write
>>> [ 8083.522364] Buffer I/O error on dev nvme4n1p1, logical block 30554383, lost async page write
>>> [ 8083.558611] BUG: spinlock bad magic on CPU#27, kworker/27:25/31042
>>> [ 8083.565857] general protection fault: 0000 [#1] PREEMPT SMP
>>> [ 8083.572322] Modules linked in: loop dm_mod xfs libcrc32c x86_pkg_temp_thermal btrfs xor zlib_deflate raid6_pq sr_mod cdrom sd_mod igb ahci i2c_algo_bit libahci dca nvme libata nvme_core
>>> [ 8083.591520] CPU: 27 PID: 31042 Comm: kworker/27:25 Tainted: G        W       4.10.0+ #242
>>> [ 8083.601134] Hardware name: Dell Inc. PowerEdge T630/0NT78X, BIOS 2.3.4 11/09/2016
>>> [ 8083.610052] Workqueue: xfs-cil/nvme4n1p1 xlog_cil_push_work [xfs]
>>> [ 8083.617106] task: ffff883feb9d0f40 task.stack: ffff883ef3428000
>>> [ 8083.623968] RIP: 0010:spin_dump+0x4c/0xd0
>>> [ 8083.628681] RSP: 0018:ffff883ef342ba78 EFLAGS: 00010002
>>> [ 8083.634760] RAX: 0000000000000036 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000002
>>> [ 8083.642969] RDX: 0000000080000002 RSI: ffffffff81a0b368 RDI: 00000000ffffffff
>>> [ 8083.651270] RBP: ffff883ef342ba88 R08: 0000000000000000 R09: 000000006b6b6b6b
>>> [ 8083.659484] R10: ffffffff81c07a80 R11: 00000000ffffffff R12: ffff883fed44c160
>>> [ 8083.667691] R13: 0000000000000004 R14: 0000000000000001 R15: ffff883e9c763848
>>> [ 8083.675903] FS:  0000000000000000(0000) GS:ffff883fff140000(0000) knlGS:0000000000000000
>>> [ 8083.685405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 8083.692048] CR2: 00007f95d83533a8 CR3: 0000001fd08d6000 CR4: 00000000003406e0
>>> [ 8083.700257] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [ 8083.708451] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> [ 8083.716659] Call Trace:
>>> [ 8083.719623]  do_raw_spin_lock+0x6d/0xb0
>>> [ 8083.724140]  _raw_spin_lock_irqsave+0x1f/0x30
>>> [ 8083.729242]  up+0x11/0x50
>>> [ 8083.732435]  xfs_buf_unlock+0x15/0x80 [xfs]
>>> [ 8083.737367]  xfs_buf_item_unpin+0x15f/0x220 [xfs]
>>> [ 8083.742895]  xfs_trans_committed_bulk+0x16a/0x260 [xfs]
>>> [ 8083.748970]  ? __save_stack_trace+0x6e/0xd0
>>> [ 8083.753911]  ? xfs_log_ticket_put+0x1a/0x20 [xfs]
>>> [ 8083.759406]  ? debug_smp_processor_id+0x17/0x20
>>> [ 8083.764688]  ? set_track+0x84/0x100
>>> [ 8083.768815]  ? _raw_spin_unlock_irqrestore+0x19/0x30
>>> [ 8083.774594]  ? free_debug_processing+0x294/0x3e0
>>> [ 8083.779979]  ? preempt_count_add+0xa3/0xc0
>>> [ 8083.784785]  ? _raw_spin_unlock_irqrestore+0x19/0x30
>>> [ 8083.790562]  ? __slab_free+0x1cf/0x2f0
>>> [ 8083.795016]  xlog_cil_committed+0x3a/0x300 [xfs]
>>
>> So we're pushing the cil and calling the committed handler from the push
>> context, which probably means abort due to filesystem shutdown. This
>> test actually repeatedly induces filesystem shutdowns to test out log
>> recovery.
>>
>> We eventually get to xfs_buf_unlock() and for some reason crash on the
>> internal spinlock for the semaphore. My first guess would be a use after
>> free or some such due to broken reference counting on a buffer in the
>> shutdown path. Could you send your kernel config file?
> 
> Attached.
> 
>> Also, is this reproducible or a one-off? Do you hit it only with nvme
>> devices? Thanks.
> 
> Just ran it twice, manually, and it didn't reproduce. I'm going to
> enable free poisoning and lockdep and re-run, see if that catches
> anything. I haven't run it on non-flash.

First run after doing that, and we hit someone that fiddles a bit in
memory that has been freed - spot the 0x6a below. This is definitely a
regression in this merge window.

[ ... ]
[  133.380444] Buffer I/O error on dev nvme4n1p1, logical block 30632630, lost async page write
[  133.380453] Buffer I/O error on dev nvme4n1p1, logical block 30632631, lost async page write
[  133.574397] XFS (nvme4n1p1): Unmounting Filesystem
[  133.613243] XFS (nvme4n1p1): Mounting V4 Filesystem
[  133.693438] XFS (nvme4n1p1): Starting recovery (logdev: internal)
[  133.763226] =============================================================================
[  133.772944] BUG xfs_efi_item (Not tainted): Poison overwritten
[  133.779786] -----------------------------------------------------------------------------
[  133.779786] 
[  133.791373] Disabling lock debugging due to kernel taint
[  133.798306] INFO: 0xffff883feb281aa8-0xffff883feb281aa8. First byte 0x6a instead of 0x6b
[  133.807990] INFO: Allocated in kmem_zone_alloc+0x7c/0x110 [xfs] age=428 cpu=19 pid=4756
[  133.817513] 	___slab_alloc+0x3a5/0x3d0
[  133.822016] 	__slab_alloc.isra.83+0x4f/0x80
[  133.827007] 	kmem_cache_alloc+0x1c0/0x250
[  133.831844] 	kmem_zone_alloc+0x7c/0x110 [xfs]
[  133.837078] 	xfs_efi_init+0x25/0x80 [xfs]
[  133.841929] 	xfs_extent_free_create_intent+0x13/0x30 [xfs]
[  133.848416] 	xfs_defer_intake_work+0x2d/0x1f0 [xfs]
[  133.854267] 	xfs_defer_finish+0x75/0x7b0 [xfs]
[  133.859596] 	xfs_itruncate_extents+0x128/0x470 [xfs]
[  133.865509] 	xfs_inactive_truncate+0x78/0xb0 [xfs]
[  133.871231] 	xfs_inactive+0x8e/0xe0 [xfs]
[  133.876079] 	xfs_fs_destroy_inode+0xb6/0x2e0 [xfs]
[  133.881749] 	destroy_inode+0x36/0x60
[  133.886059] 	evict+0x134/0x1c0
[  133.889784] 	iput+0x233/0x300
[  133.893408] 	dentry_unlink_inode+0xbe/0x160
[  133.898450] INFO: Freed in xfs_efi_item_free+0x29/0x40 [xfs] age=497 cpu=19 pid=4756
[  133.907649] 	__slab_free+0x1e8/0x370
[  133.911956] 	kmem_cache_free+0x212/0x2a0
[  133.916708] 	xfs_efi_item_free+0x29/0x40 [xfs]
[  133.922046] 	xfs_efi_item_unlock+0x10/0x20 [xfs]
[  133.927578] 	xfs_trans_free_items+0x6b/0xa0 [xfs]
[  133.933206] 	__xfs_trans_commit+0xa2/0x220 [xfs]
[  133.938739] 	__xfs_trans_roll+0x58/0xc0 [xfs]
[  133.943977] 	xfs_trans_roll+0x11/0x20 [xfs]
[  133.949004] 	xfs_defer_trans_roll+0x74/0x320 [xfs]
[  133.954711] 	xfs_defer_finish+0x84/0x7b0 [xfs]
[  133.960045] 	xfs_itruncate_extents+0x128/0x470 [xfs]
[  133.965964] 	xfs_inactive_truncate+0x78/0xb0 [xfs]
[  133.971689] 	xfs_inactive+0x8e/0xe0 [xfs]
[  133.976539] 	xfs_fs_destroy_inode+0xb6/0x2e0 [xfs]
[  133.982303] 	destroy_inode+0x36/0x60
[  133.986610] 	evict+0x134/0x1c0
[  133.990336] INFO: Slab 0xffffea00ffaca000 objects=44 used=44 fp=0x          (null) flags=0x6000
[  134.001778] INFO: Object 0xffff883feb281a30 @offset=6704 fp=0xffff883feb287160
[  134.001778] 
[  134.012287] Redzone ffff883feb281a28: bb bb bb bb bb bb bb bb                          ........
[  134.022565] Object ffff883feb281a30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.033523] Object ffff883feb281a40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.044484] Object ffff883feb281a50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.055441] Object ffff883feb281a60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.066401] Object ffff883feb281a70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.077363] Object ffff883feb281a80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.088317] Object ffff883feb281a90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.099282] Object ffff883feb281aa0: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.110332] Object ffff883feb281ab0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.121282] Object ffff883feb281ac0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.132241] Object ffff883feb281ad0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.143197] Object ffff883feb281ae0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.154150] Object ffff883feb281af0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.165108] Object ffff883feb281b00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.176065] Object ffff883feb281b10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.187020] Object ffff883feb281b20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.197976] Object ffff883feb281b30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.208934] Object ffff883feb281b40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.219895] Object ffff883feb281b50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.230851] Object ffff883feb281b60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.241810] Object ffff883feb281b70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.252856] Object ffff883feb281b80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.263811] Object ffff883feb281b90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.274771] Object ffff883feb281ba0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.285729] Object ffff883feb281bb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  134.296687] Object ffff883feb281bc0: 6b 6b 6b 6b 6b 6b 6b a5                          kkkkkkk.
[  134.307503] Redzone ffff883feb281bc8: bb bb bb bb bb bb bb bb                          ........
[  134.317785] Padding ffff883feb281d08: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[  134.328063] CPU: 5 PID: 4770 Comm: mount Tainted: G    B           4.10.0+ #243
[  134.336770] Hardware name: Dell Inc. PowerEdge T630/0NT78X, BIOS 2.3.4 11/09/2016
[  134.345666] Call Trace:
[  134.348704]  dump_stack+0x68/0x93
[  134.352705]  print_trailer+0x160/0x250
[  134.357196]  check_bytes_and_report+0xbc/0x100
[  134.362462]  check_object+0x23c/0x280
[  134.366886]  ? kmem_zone_alloc+0x7c/0x110 [xfs]
[  134.372252]  alloc_debug_processing+0x10e/0x1b0
[  134.377620]  ___slab_alloc+0x3a5/0x3d0
[  134.382143]  ? xfs_buf_get_map+0x25/0x4c0 [xfs]
[  134.387535]  ? kmem_zone_alloc+0x7c/0x110 [xfs]
[  134.392905]  __slab_alloc.isra.83+0x4f/0x80
[  134.397914]  ? kmem_zone_alloc+0x7c/0x110 [xfs]
[  134.403315]  ? kmem_zone_alloc+0x7c/0x110 [xfs]
[  134.408680]  kmem_cache_alloc+0x1c0/0x250
[  134.413460]  ? _raw_spin_unlock+0x2c/0x50
[  134.418277]  kmem_zone_alloc+0x7c/0x110 [xfs]
[  134.423573]  xfs_efi_init+0x25/0x80 [xfs]
[  134.428389]  xlog_recover_efi_pass2.isra.28+0x29/0xa0 [xfs]
[  134.434955]  xlog_recover_commit_pass2+0x12f/0x2a0 [xfs]
[  134.441227]  xlog_recover_items_pass2+0x3c/0x60 [xfs]
[  134.447205]  xlog_recover_commit_trans+0x23b/0x290 [xfs]
[  134.453482]  xlog_recovery_process_trans+0x7c/0xb0 [xfs]
[  134.459759]  xlog_recover_process_ophdr+0x89/0x120 [xfs]
[  134.466020]  xlog_recover_process_data+0xdb/0x240 [xfs]
[  134.472200]  xlog_recover_process+0xa2/0xf0 [xfs]
[  134.477793]  xlog_do_recovery_pass+0x45f/0x640 [xfs]
[  134.483645]  ? trace_hardirqs_on_caller+0xed/0x1b0
[  134.489336]  xlog_do_log_recovery+0x7f/0xb0 [xfs]
[  134.494937]  xlog_do_recover+0x16/0x110 [xfs]
[  134.500146]  xlog_recover+0xa6/0x130 [xfs]
[  134.505059]  xfs_log_mount+0xd9/0x2a0 [xfs]
[  134.510064]  xfs_mountfs+0x51a/0x9d0 [xfs]
[  134.514974]  ? xfs_mru_cache_create+0x168/0x1c0 [xfs]
[  134.520956]  xfs_fs_fill_super+0x447/0x5d0 [xfs]
[  134.526422]  mount_bdev+0x17b/0x1b0
[  134.530653]  ? xfs_test_remount_options.isra.14+0x60/0x60 [xfs]
[  134.537654]  xfs_fs_mount+0x10/0x20 [xfs]
[  134.542441]  mount_fs+0x33/0x160
[  134.546353]  ? alloc_vfsmnt+0x199/0x220
[  134.556468]  vfs_kern_mount+0x66/0x170
[  134.560949]  do_mount+0x1ba/0xcf0
[  134.564957]  ? _copy_from_user+0x7a/0xb0
[  134.569647]  ? memdup_user+0x4e/0x80
[  134.573944]  SyS_mount+0x7e/0xd0
[  134.577852]  entry_SYSCALL_64_fastpath+0x18/0xad
[  134.583318] RIP: 0033:0x7fb7cbf03d8a
[  134.587618] RSP: 002b:00007fff6b0dc388 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[  134.596612] RAX: ffffffffffffffda RBX: 00007fb7cc421749 RCX: 00007fb7cbf03d8a
[  134.604896] RDX: 00000000020de2d0 RSI: 00000000020de310 RDI: 00000000020de2f0
[  134.613177] RBP: 00000000020de120 R08: 0000000000000000 R09: 00007fb7cbe6699a
[  134.621461] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00007fb7cc630f18
[  134.629744] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
[  134.638024] FIX xfs_efi_item: Restoring 0xffff883feb281aa8-0xffff883feb281aa8=0x6b
[  134.638024] 
[  134.648899] FIX xfs_efi_item: Marking all objects used


-- 
Jens Axboe

