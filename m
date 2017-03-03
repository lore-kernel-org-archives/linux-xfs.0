Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33390 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdCCPT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 10:19:56 -0500
Received: by mail-io0-f171.google.com with SMTP id f84so75401506ioj.0
        for <linux-xfs@vger.kernel.org>; Fri, 03 Mar 2017 07:19:55 -0800 (PST)
Subject: Re: XFS failure in 4.10+
References: <b1cfa7e4-34e0-ce7b-c65e-cfff6c6c3a3a@kernel.dk>
 <20170303130012.GB21245@bfoster.bfoster>
 <ffedba33-31d4-ee99-e385-72a0fcff8a77@kernel.dk>
 <a21b36b3-7a81-3bb4-175a-3164a169d831@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dee29cf4-6de9-1240-49fd-e2f624c21fe6@kernel.dk>
Date: Fri, 3 Mar 2017 08:19:53 -0700
MIME-Version: 1.0
In-Reply-To: <a21b36b3-7a81-3bb4-175a-3164a169d831@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On 03/03/2017 08:13 AM, Jens Axboe wrote:
>>> Also, is this reproducible or a one-off? Do you hit it only with nvme
>>> devices? Thanks.
>>
>> Just ran it twice, manually, and it didn't reproduce. I'm going to
>> enable free poisoning and lockdep and re-run, see if that catches
>> anything. I haven't run it on non-flash.
> 
> First run after doing that, and we hit someone that fiddles a bit in
> memory that has been freed - spot the 0x6a below. This is definitely a
> regression in this merge window.

To answer your other question, I just ran it on the same box, but on
two rotating drives:

[  558.071426] XFS (sdf1): Mounting V4 Filesystem
[  558.131620] XFS (sdf1): Starting recovery (logdev: internal)
[  558.185987] =============================================================================
[  558.195688] BUG xfs_efi_item (Tainted: G    B          ): Poison overwritten
[  558.203882] -----------------------------------------------------------------------------
[  558.203882] 
[  558.215540] INFO: 0xffff883feb116920-0xffff883feb116920. First byte 0x6a instead of 0x6b
[  558.225238] INFO: Allocated in kmem_zone_alloc+0x7c/0x110 [xfs] age=337 cpu=25 pid=8867
[  558.234741] 	___slab_alloc+0x3a5/0x3d0
[  558.239238] 	__slab_alloc.isra.83+0x4f/0x80
[  558.244222] 	kmem_cache_alloc+0x1c0/0x250
[  558.249067] 	kmem_zone_alloc+0x7c/0x110 [xfs]
[  558.254301] 	xfs_efi_init+0x25/0x80 [xfs]
[  558.259147] 	xfs_extent_free_create_intent+0x13/0x30 [xfs]
[  558.265633] 	xfs_defer_intake_work+0x2d/0x1f0 [xfs]
[  558.271433] 	xfs_defer_finish+0x75/0x7b0 [xfs]
[  558.276763] 	xfs_itruncate_extents+0x128/0x470 [xfs]
[  558.282674] 	xfs_inactive_truncate+0x78/0xb0 [xfs]
[  558.288392] 	xfs_inactive+0x8e/0xe0 [xfs]
[  558.293236] 	xfs_fs_destroy_inode+0xb6/0x2e0 [xfs]
[  558.298905] 	destroy_inode+0x36/0x60
[  558.303206] 	evict+0x134/0x1c0
[  558.306926] 	iput+0x233/0x300
[  558.310552] 	do_unlinkat+0x112/0x2e0
[  558.315004] INFO: Freed in xfs_efi_item_free+0x29/0x40 [xfs] age=377 cpu=25 pid=8867
[  558.324209] 	__slab_free+0x1e8/0x370
[  558.329211] 	kmem_cache_free+0x212/0x2a0
[  558.333962] 	xfs_efi_item_free+0x29/0x40 [xfs]
[  558.339284] 	xfs_efi_item_unlock+0x10/0x20 [xfs]
[  558.344809] 	xfs_trans_free_items+0x6b/0xa0 [xfs]
[  558.350431] 	__xfs_trans_commit+0xa2/0x220 [xfs]
[  558.355955] 	__xfs_trans_roll+0x58/0xc0 [xfs]
[  558.361186] 	xfs_trans_roll+0x11/0x20 [xfs]
[  558.366211] 	xfs_defer_trans_roll+0x74/0x320 [xfs]
[  558.371956] 	xfs_defer_finish+0x84/0x7b0 [xfs]
[  558.377287] 	xfs_itruncate_extents+0x128/0x470 [xfs]
[  558.383198] 	xfs_inactive_truncate+0x78/0xb0 [xfs]
[  558.388914] 	xfs_inactive+0x8e/0xe0 [xfs]
[  558.393758] 	xfs_fs_destroy_inode+0xb6/0x2e0 [xfs]
[  558.399427] 	destroy_inode+0x36/0x60
[  558.403725] 	evict+0x134/0x1c0
[  558.407452] INFO: Slab 0xffffea00ffac4400 objects=44 used=44 fp=0x          (null) flags=0x6000
[  558.418898] INFO: Object 0xffff883feb1168a8 @offset=26792 fp=0xffff883feb110ba8
[  558.418898] 
[  558.429492] Redzone ffff883feb1168a0: bb bb bb bb bb bb bb bb                          ........
[  558.439768] Object ffff883feb1168a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.450724] Object ffff883feb1168b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.461682] Object ffff883feb1168c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.472634] Object ffff883feb1168d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.483592] Object ffff883feb1168e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.494551] Object ffff883feb1168f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.505507] Object ffff883feb116908: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.516461] Object ffff883feb116918: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.527416] Object ffff883feb116928: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.538369] Object ffff883feb116938: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.549326] Object ffff883feb116948: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.560280] Object ffff883feb116958: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.571329] Object ffff883feb116968: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.582287] Object ffff883feb116978: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.593245] Object ffff883feb116988: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.604203] Object ffff883feb116998: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.615160] Object ffff883feb1169a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.626116] Object ffff883feb1169b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.637075] Object ffff883feb1169c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.648033] Object ffff883feb1169d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.658992] Object ffff883feb1169e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.669949] Object ffff883feb1169f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.680907] Object ffff883feb116a08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.691862] Object ffff883feb116a18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.702818] Object ffff883feb116a28: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkk
[  558.713854] Object ffff883feb116a38: 6b 6b 6b 6b 6b 6b 6b a5                          kkkkkkk.
[  558.724034] Redzone ffff883feb116a40: bb bb bb bb bb bb bb bb                          ........
[  558.734313] Padding ffff883feb116b80: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[  558.744593] CPU: 31 PID: 8884 Comm: mount Tainted: G    B           4.10.0+ #243
[  558.753411] Hardware name: Dell Inc. PowerEdge T630/0NT78X, BIOS 2.3.4 11/09/2016
[  558.762323] Call Trace:
[  558.765372]  dump_stack+0x68/0x93
[  558.769390]  print_trailer+0x160/0x250
[  558.773893]  check_bytes_and_report+0xbc/0x100
[  558.779177]  check_object+0x23c/0x280
[  558.783634]  ? kmem_zone_alloc+0x7c/0x110 [xfs]
[  558.789017]  alloc_debug_processing+0x10e/0x1b0
[  558.794397]  ___slab_alloc+0x3a5/0x3d0
[  558.799037]  ? kmem_zone_alloc+0x7c/0x110 [xfs]
[  558.804417]  __slab_alloc.isra.83+0x4f/0x80
[  558.809451]  ? kmem_zone_alloc+0x7c/0x110 [xfs]
[  558.814878]  ? kmem_zone_alloc+0x7c/0x110 [xfs]
[  558.820257]  kmem_cache_alloc+0x1c0/0x250
[  558.825095]  ? xfs_buf_rele+0x91/0x710 [xfs]
[  558.830865]  kmem_zone_alloc+0x7c/0x110 [xfs]
[  558.836076]  xfs_efi_init+0x25/0x80 [xfs]
[  558.840888]  xlog_recover_efi_pass2.isra.28+0x29/0xa0 [xfs]
[  558.847470]  xlog_recover_commit_pass2+0x12f/0x2a0 [xfs]
[  558.853747]  xlog_recover_items_pass2+0x3c/0x60 [xfs]
[  558.859730]  xlog_recover_commit_trans+0x23b/0x290 [xfs]
[  558.866005]  xlog_recovery_process_trans+0x7c/0xb0 [xfs]
[  558.872284]  xlog_recover_process_ophdr+0x89/0x120 [xfs]
[  558.878559]  xlog_recover_process_data+0xdb/0x240 [xfs]
[  558.884730]  xlog_recover_process+0xa2/0xf0 [xfs]
[  558.895825]  xlog_do_recovery_pass+0x45f/0x640 [xfs]
[  558.901708]  xlog_do_log_recovery+0x7f/0xb0 [xfs]
[  558.907300]  xlog_do_recover+0x16/0x110 [xfs]
[  558.912500]  xlog_recover+0xa6/0x130 [xfs]
[  558.917410]  xfs_log_mount+0xd9/0x2a0 [xfs]
[  558.922421]  xfs_mountfs+0x51a/0x9d0 [xfs]
[  558.927327]  ? xfs_mru_cache_create+0x168/0x1c0 [xfs]
[  558.933310]  xfs_fs_fill_super+0x447/0x5d0 [xfs]
[  558.938774]  mount_bdev+0x17b/0x1b0
[  558.943002]  ? xfs_test_remount_options.isra.14+0x60/0x60 [xfs]
[  558.949954]  xfs_fs_mount+0x10/0x20 [xfs]
[  558.954739]  mount_fs+0x33/0x160
[  558.958645]  ? alloc_vfsmnt+0x199/0x220
[  558.963237]  vfs_kern_mount+0x66/0x170
[  558.967728]  do_mount+0x1ba/0xcf0
[  558.971737]  ? _copy_from_user+0x7a/0xb0
[  558.976425]  ? memdup_user+0x4e/0x80
[  558.980720]  SyS_mount+0x7e/0xd0
[  558.984626]  entry_SYSCALL_64_fastpath+0x18/0xad
[  558.990089] RIP: 0033:0x7f02a7c59d8a
[  558.994388] RSP: 002b:00007ffcf6094cf8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  559.003385] RAX: ffffffffffffffda RBX: 00007f02a8177749 RCX: 00007f02a7c59d8a
[  559.011667] RDX: 00000000019372d0 RSI: 0000000001937310 RDI: 00000000019372f0
[  559.019951] RBP: 0000000001937120 R08: 0000000000000000 R09: 00007f02a7bbc99a
[  559.028234] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00007f02a8386f18
[  559.036512] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
[  559.044794] FIX xfs_efi_item: Restoring 0xffff883feb116920-0xffff883feb116920=0x6b
[  559.044794] 
[  559.055746] FIX xfs_efi_item: Marking all objects used
[  559.215138] XFS (sdf1): Ending recovery (logdev: internal)
[  559.397029] XFS (sdf1): Unmounting Filesystem

-- 
Jens Axboe

