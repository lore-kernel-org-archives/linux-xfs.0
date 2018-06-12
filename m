Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr700104.outbound.protection.outlook.com ([40.107.70.104]:42720
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934354AbeFLXVK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 19:21:10 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Integer overflow due to missing sanitary check in
 _xfs_buf_map_pages() when mounting a crafted xfs image
Date: Tue, 12 Jun 2018 23:21:08 +0000
Message-ID: <7B412B22-15C2-4067-B544-7B0FE7D87682@gatech.edu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4626FD715735264DB55B24088890B1C0@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

- Overview
Integer overflow due to missing sanitary check in _xfs_buf_map_pages() when mounting a crafted xfs image

- Reproduce
# mkdir mnt
# mount -t xfs 32.img mnt

- Kernel message
[  564.425787] XFS (loop0): Mounting V4 Filesystem
[  564.461358] XFS (loop0): Starting recovery (logdev: internal)
[  564.468047] WARNING: CPU: 0 PID: 1480 at mm/vmalloc.c:987 vm_map_ram+0x309/0x510
[  564.468053] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd i2c_piix4 mac_hid soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 drm crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
[  564.468434] CPU: 0 PID: 1480 Comm: mount Not tainted 4.17.0-rc4-kasan #2
[  564.468441] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  564.468446] RIP: 0010:vm_map_ram+0x309/0x510
[  564.468449] RSP: 0018:ffff8801e0bc7120 EFLAGS: 00010246
[  564.468458] RAX: 0000000000000000 RBX: ffff8801ef1da380 RCX: 8000000000000063
[  564.468461] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffff8801ef1da490
[  564.468463] RBP: ffff8801e0bc7178 R08: ffffed003de91cc9 R09: ffffed003de91cc9
[  564.468466] R10: ffff8801ef1da380 R11: ffffed003de91cc8 R12: 0000000000000000
[  564.468469] R13: 8000000000000163 R14: 0000000000000000 R15: 8000000000000063
[  564.468473] FS:  00007fdf1c924840(0000) GS:ffff8801f4000000(0000) knlGS:0000000000000000
[  564.468475] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  564.468478] CR2: 00005653c73d17f0 CR3: 00000001eee00000 CR4: 00000000000006f0
[  564.468492] Call Trace:
[  564.468517]  _xfs_buf_map_pages+0xd9/0x230
[  564.468523]  xfs_buf_get_map+0x397/0x460
[  564.468528]  ? xfs_buf_incore+0xf0/0xf0
[  564.468535]  ? kasan_check_read+0x11/0x20
[  564.468539]  ? xfs_buf_rele+0x38a/0x5c0
[  564.468553]  ? _raw_spin_lock_irqsave+0x2a/0x60
[  564.468558]  xfs_buf_read_map+0x30/0x260
[  564.468567]  xfs_buf_readahead_map+0x95/0xd0
[  564.468587]  xlog_recover_inode_ra_pass2.isra.27+0x197/0x1c0
[  564.468593]  ? xlog_recover_dquot_ra_pass2.isra.26+0x1c0/0x1c0
[  564.468599]  ? xlog_recover_buffer_ra_pass2.isra.25+0x12f/0x140
[  564.468603]  ? xlog_recover_buffer_pass1.isra.24+0x300/0x300
[  564.468609]  xlog_recover_ra_pass2+0x64/0xa0
[  564.468615]  xlog_recover_commit_trans+0x1a1/0x4b0
[  564.468621]  ? xlog_recover_items_pass2+0x70/0x70
[  564.468627]  ? kmem_alloc+0x91/0x120
[  564.468631]  ? memcpy+0x45/0x50
[  564.468636]  ? xlog_recover_add_to_trans+0x199/0x380
[  564.468641]  xlog_recovery_process_trans+0x96/0xd0
[  564.468646]  xlog_recover_process_ophdr+0xf6/0x1c0
[  564.468652]  xlog_recover_process_data+0xd5/0x1a0
[  564.468657]  xlog_recover_process+0xdd/0x160
[  564.468662]  xlog_do_recovery_pass+0x685/0x900
[  564.468675]  ? vprintk_emit+0x373/0x450
[  564.468681]  ? xlog_recover_process+0x160/0x160
[  564.468686]  ? kmem_alloc+0x91/0x120
[  564.468692]  ? kmem_alloc+0x91/0x120
[  564.468697]  xlog_do_log_recovery+0xb3/0xf0
[  564.468702]  xlog_do_recover+0x3d/0x220
[  564.468706]  xlog_recover+0x16e/0x2a0
[  564.468711]  ? xlog_find_tail+0x540/0x540
[  564.468718]  ? wake_up_process+0x15/0x20
[  564.468723]  xfs_log_mount+0x191/0x3b0
[  564.468730]  xfs_mountfs+0x98a/0x1140
[  564.468736]  ? xfs_default_resblks+0x40/0x40
[  564.468740]  ? kmem_alloc+0x91/0x120
[  564.468745]  ? kmem_alloc+0x91/0x120
[  564.468755]  ? init_timer_key+0x51/0xc0
[  564.468760]  ? xfs_filestream_put_ag+0x30/0x30
[  564.468764]  ? xfs_mru_cache_create+0x209/0x260
[  564.468769]  xfs_fs_fill_super+0x6ec/0x970
[  564.468777]  mount_bdev+0x1c5/0x210
[  564.468781]  ? xfs_test_remount_options+0x70/0x70
[  564.468785]  xfs_fs_mount+0x15/0x20
[  564.468789]  mount_fs+0x60/0x1a0
[  564.468795]  ? alloc_vfsmnt+0x309/0x360
[  564.468799]  vfs_kern_mount+0x6b/0x1a0
[  564.468805]  do_mount+0x34a/0x18a0
[  564.468818]  ? lockref_put_or_lock+0xcf/0x160
[  564.468823]  ? copy_mount_string+0x20/0x20
[  564.468829]  ? memcg_kmem_put_cache+0x1b/0xa0
[  564.468833]  ? kasan_check_write+0x14/0x20
[  564.468838]  ? _copy_from_user+0x6a/0x90
[  564.468850]  ? memdup_user+0x42/0x60
[  564.468855]  ksys_mount+0x83/0xd0
[  564.468860]  __x64_sys_mount+0x67/0x80
[  564.468867]  do_syscall_64+0x78/0x170
[  564.468872]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  564.468885] RIP: 0033:0x7fdf1c204b9a
[  564.468888] RSP: 002b:00007ffea24bd0a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  564.468892] RAX: ffffffffffffffda RBX: 00000000008a3030 RCX: 00007fdf1c204b9a
[  564.468895] RDX: 00000000008a3210 RSI: 00000000008a4f30 RDI: 00000000008abec0
[  564.468897] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
[  564.468899] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00000000008abec0
[  564.468902] R13: 00000000008a3210 R14: 0000000000000000 R15: 0000000000000003
[  564.468905] Code: 00 00 40 00 bf 00 00 40 00 48 01 d1 e8 31 e7 ff ff 48 3d 00 f0 ff ff 48 89 c3 76 1d 4c 89 ef e8 5e 3b 03 00 31 c0 e9 96 fe ff ff <0f> 0b 45 31 ff 31 ff e9 6e fe ff ff 0f 0b bf c0 00 40 01 e8 1f
[  564.468960] ---[ end trace d56531d091900bff ]---
[  564.469136] ------------[ cut here ]------------
[  564.469139] kernel BUG at mm/vmalloc.c:226!
[  564.476873] invalid opcode: 0000 [#1] SMP KASAN PTI
[  564.477905] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd i2c_piix4 mac_hid soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 drm crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
[  564.487550] CPU: 0 PID: 1480 Comm: mount Tainted: G        W         4.17.0-rc4-kasan #2
[  564.489177] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  564.491078] RIP: 0010:vmap_page_range_noflush+0x42b/0x430
[  564.492162] RSP: 0018:ffff8801e0bc7078 EFLAGS: 00010246
[  564.493212] RAX: 0000000000000000 RBX: ffff8801ef1da380 RCX: ffff8801ef1da490
[  564.494625] RDX: 8000000000000063 RSI: 0000000000000000 RDI: 0000000000000000
[  564.496058] RBP: ffff8801e0bc7110 R08: ffffed003de91cc9 R09: ffffed003de91cc9
[  564.497472] R10: ffff8801ef1da380 R11: ffffed003de91cc8 R12: 0000000000000000
[  564.498897] R13: 8000000000000163 R14: 0000000000000000 R15: 0000000000000000
[  564.500314] FS:  00007fdf1c924840(0000) GS:ffff8801f4000000(0000) knlGS:0000000000000000
[  564.501910] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  564.503060] CR2: 00005653c73d17f0 CR3: 00000001eee00000 CR4: 00000000000006f0
[  564.504477] Call Trace:
[  564.504990]  vm_map_ram+0x194/0x510
[  564.505702]  _xfs_buf_map_pages+0xd9/0x230
[  564.506532]  xfs_buf_get_map+0x397/0x460
[  564.507339]  ? xfs_buf_incore+0xf0/0xf0
[  564.508119]  ? kasan_check_read+0x11/0x20
[  564.508930]  ? xfs_buf_rele+0x38a/0x5c0
[  564.509709]  ? _raw_spin_lock_irqsave+0x2a/0x60
[  564.510623]  xfs_buf_read_map+0x30/0x260
[  564.511434]  xfs_buf_readahead_map+0x95/0xd0
[  564.512301]  xlog_recover_inode_ra_pass2.isra.27+0x197/0x1c0
[  564.513438]  ? xlog_recover_dquot_ra_pass2.isra.26+0x1c0/0x1c0
[  564.514601]  ? xlog_recover_buffer_ra_pass2.isra.25+0x12f/0x140
[  564.515797]  ? xlog_recover_buffer_pass1.isra.24+0x300/0x300
[  564.516928]  xlog_recover_ra_pass2+0x64/0xa0
[  564.517790]  xlog_recover_commit_trans+0x1a1/0x4b0
[  564.518762]  ? xlog_recover_items_pass2+0x70/0x70
[  564.519715]  ? kmem_alloc+0x91/0x120
[  564.520440]  ? memcpy+0x45/0x50
[  564.521083]  ? xlog_recover_add_to_trans+0x199/0x380
[  564.522080]  xlog_recovery_process_trans+0x96/0xd0
[  564.523055]  xlog_recover_process_ophdr+0xf6/0x1c0
[  564.524015]  xlog_recover_process_data+0xd5/0x1a0
[  564.524961]  xlog_recover_process+0xdd/0x160
[  564.525822]  xlog_do_recovery_pass+0x685/0x900
[  564.526717]  ? vprintk_emit+0x373/0x450
[  564.527509]  ? xlog_recover_process+0x160/0x160
[  564.528423]  ? kmem_alloc+0x91/0x120
[  564.529152]  ? kmem_alloc+0x91/0x120
[  564.529878]  xlog_do_log_recovery+0xb3/0xf0
[  564.530725]  xlog_do_recover+0x3d/0x220
[  564.531513]  xlog_recover+0x16e/0x2a0
[  564.532260]  ? xlog_find_tail+0x540/0x540
[  564.533075]  ? wake_up_process+0x15/0x20
[  564.533871]  xfs_log_mount+0x191/0x3b0
[  564.534632]  xfs_mountfs+0x98a/0x1140
[  564.535393]  ? xfs_default_resblks+0x40/0x40
[  564.536253]  ? kmem_alloc+0x91/0x120
[  564.536979]  ? kmem_alloc+0x91/0x120
[  564.537707]  ? init_timer_key+0x51/0xc0
[  564.538484]  ? xfs_filestream_put_ag+0x30/0x30
[  564.539392]  ? xfs_mru_cache_create+0x209/0x260
[  564.540308]  xfs_fs_fill_super+0x6ec/0x970
[  564.541139]  mount_bdev+0x1c5/0x210
[  564.541848]  ? xfs_test_remount_options+0x70/0x70
[  564.542805]  xfs_fs_mount+0x15/0x20
[  564.543516]  mount_fs+0x60/0x1a0
[  564.544177]  ? alloc_vfsmnt+0x309/0x360
[  564.544954]  vfs_kern_mount+0x6b/0x1a0
[  564.545714]  do_mount+0x34a/0x18a0
[  564.546408]  ? lockref_put_or_lock+0xcf/0x160
[  564.547296]  ? copy_mount_string+0x20/0x20
[  564.548122]  ? memcg_kmem_put_cache+0x1b/0xa0
[  564.548995]  ? kasan_check_write+0x14/0x20
[  564.549815]  ? _copy_from_user+0x6a/0x90
[  564.550602]  ? memdup_user+0x42/0x60
[  564.551333]  ksys_mount+0x83/0xd0
[  564.552002]  __x64_sys_mount+0x67/0x80
[  564.552758]  do_syscall_64+0x78/0x170
[  564.553492]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  564.554494] RIP: 0033:0x7fdf1c204b9a
[  564.555222] RSP: 002b:00007ffea24bd0a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  564.556714] RAX: ffffffffffffffda RBX: 00000000008a3030 RCX: 00007fdf1c204b9a
[  564.558120] RDX: 00000000008a3210 RSI: 00000000008a4f30 RDI: 00000000008abec0
[  564.559554] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
[  564.560970] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00000000008abec0
[  564.562371] R13: 00000000008a3210 R14: 0000000000000000 R15: 0000000000000003
[  564.563786] Code: ff 4c 89 ea 48 c7 c7 20 0e f9 a5 48 89 de e8 8d 1e fe ff 85 c0 0f 85 7a ff ff ff 48 89 df e8 4d 80 03 00 48 8b 3b e9 b7 fc ff ff <0f> 0b 0f 1f 00 66 66 66 66 90 55 48 89 e5 41 57 41 56 41 55 41
[  564.567504] RIP: vmap_page_range_noflush+0x42b/0x430 RSP: ffff8801e0bc7078
[  564.568913] ---[ end trace d56531d091900c00 ]---
[  564.569942] ==================================================================
[  564.571429] BUG: KASAN: stack-out-of-bounds in arch_tlb_gather_mmu+0x21/0x170
[  564.572841] Write of size 8 at addr ffff8801e0bc7bc8 by task mount/1480

[  564.574478] CPU: 1 PID: 1480 Comm: mount Tainted: G      D W         4.17.0-rc4-kasan #2
[  564.576079] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  564.577919] Call Trace:
[  564.578423]  dump_stack+0x7b/0xb5
[  564.579104]  print_address_description+0x70/0x290
[  564.580037]  kasan_report+0x291/0x390
[  564.580769]  ? arch_tlb_gather_mmu+0x21/0x170
[  564.581640]  __asan_store8+0x57/0x90
[  564.582359]  arch_tlb_gather_mmu+0x21/0x170
[  564.583204]  tlb_gather_mmu+0x12/0x40
[  564.583944]  free_ldt_pgtables.part.2+0x90/0x110
[  564.584859]  ? map_ldt_struct+0x430/0x430
[  564.585660]  ? finish_task_switch+0x94/0x330
[  564.586508]  ? finish_task_switch+0xab/0x330
[  564.587374]  ? put_prev_task_fair+0x3a/0x50
[  564.588214]  ? __schedule+0x6dc/0xd80
[  564.588948]  free_ldt_pgtables+0x13/0x20
[  564.589730]  ldt_arch_exit_mmap+0xe/0x10
[  564.590510]  exit_mmap+0xcd/0x280
[  564.591194]  ? __ia32_sys_munmap+0x50/0x50
[  564.592010]  ? alloc_vfsmnt+0x309/0x360
[  564.592780]  ? exit_aio+0x98/0x230
[  564.593463]  ? __x32_compat_sys_io_submit+0x100/0x100
[  564.594466]  ? taskstats_exit+0x1f4/0x640
[  564.595279]  ? kasan_check_read+0x11/0x20
[  564.596074]  ? mm_update_next_owner+0x322/0x380
[  564.596970]  mmput+0x8b/0x1d0
[  564.597569]  do_exit+0x43a/0x1390
[  564.598236]  ? mm_update_next_owner+0x380/0x380
[  564.599147]  ? memdup_user+0x42/0x60
[  564.599860]  ? ksys_mount+0x83/0xd0
[  564.600559]  ? __x64_sys_mount+0x67/0x80
[  564.601341]  rewind_stack_do_exit+0x17/0x20
[  564.602172] RIP: 0033:0x7fdf1c204b9a
[  564.602896] RSP: 002b:00007ffea24bd0a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  564.604375] RAX: ffffffffffffffda RBX: 00000000008a3030 RCX: 00007fdf1c204b9a
[  564.605772] RDX: 00000000008a3210 RSI: 00000000008a4f30 RDI: 00000000008abec0
[  564.607178] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
[  564.608568] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00000000008abec0
[  564.609961] R13: 00000000008a3210 R14: 0000000000000000 R15: 0000000000000003

[  564.611678] The buggy address belongs to the page:
[  564.612633] page:ffffea000782f1c0 count:0 mapcount:0 mapping:0000000000000000 index:0x0
[  564.614197] flags: 0x2ffff0000000000()
[  564.614962] raw: 02ffff0000000000 0000000000000000 0000000000000000 00000000ffffffff
[  564.616477] raw: 0000000000000000 ffffea000782f2a0 ffff8801f3d9c000 0000000000000000
[  564.617986] page dumped because: kasan: bad access detected

[  564.619406] Memory state around the buggy address:
[  564.620355]  ffff8801e0bc7a80: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 04 f4 f4 f4
[  564.621773]  ffff8801e0bc7b00: f2 f2 f2 f2 04 f4 f4 f4 f2 f2 f2 f2 00 f4 f4 f4
[  564.623199] >ffff8801e0bc7b80: f2 f2 f2 f2 00 f1 f1 f1 f1 f3 f3 00 00 00 00 00
[  564.624611]                                               ^
[  564.625708]  ffff8801e0bc7c00: 00 00 00 00 00 00 00 00 00 00 f4 f4 f4 f3 f3 f3
[  564.627131]  ffff8801e0bc7c80: f3 00 00 00 00 00 00 00 f1 f1 f1 f1 00 00 00 00
[  564.628540] ==================================================================

- Reason
https://elixir.bootlin.com/linux/latest/source/fs/xfs/xfs_buf.c#L475
      bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
            -1, PAGE_KERNEL);

https://elixir.bootlin.com/linux/latest/source/mm/vmalloc.c#L1194
  if (vmap_page_range(addr, addr + size, prot, pages) < 0) {
    vm_unmap_ram(mem, count);
    return NULL;
  }

I think there are missing checks on bp->b_page_count, which makes addr + size smaller than addr, that leads to BUG().

Reported by Wen Xu (wen.xu@gatech.edu) from SSLab at Gatech.

Thanks,
Wen

Files:
32.img.zip: https://bugzilla.kernel.org/attachment.cgi?id=276503