Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0139.outbound.protection.outlook.com ([104.47.38.139]:26656
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934733AbeFLXWx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 19:22:53 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: slab-out-of-bounds in xfs_bmbt_to_bmdr() when mounting a crafted xfs
 image
Date: Tue, 12 Jun 2018 23:22:51 +0000
Message-ID: <8D95CC4B-9E22-47DF-8E8F-CD66514CAADC@gatech.edu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <39577E1B3B51B04FA1E8E7AD8D0431C9@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

- Overview
slab-out-of-bounds in xfs_bmbt_to_bmdr() when mounting a crafted xfs image

- Reproduce (xfs/for-next)
# mkdir mnt
# mount -t xfs 38.img mnt

- Kernel message
[  527.192624] XFS (loop0): Mounting V4 Filesystem
[  527.224500] XFS (loop0): Starting recovery (logdev: internal)
[  527.231127] ==================================================================
[  527.232723] BUG: KASAN: slab-out-of-bounds in xfs_bmbt_to_bmdr+0xaa/0x100
[  527.234090] Read of size 872 at addr ffff8801ee017c18 by task mount/1436

[  527.235756] CPU: 1 PID: 1436 Comm: mount Not tainted 4.17.0-rc4-kasan #2
[  527.235763] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  527.235773] Call Trace:
[  527.235790]  dump_stack+0x7b/0xb5
[  527.235805]  print_address_description+0x70/0x290
[  527.235810]  kasan_report+0x291/0x390
[  527.235815]  ? xfs_bmbt_to_bmdr+0xaa/0x100
[  527.235820]  check_memory_region+0x139/0x190
[  527.235824]  memcpy+0x23/0x50
[  527.235828]  xfs_bmbt_to_bmdr+0xaa/0x100
[  527.235841]  xlog_recover_inode_pass2+0xe7e/0x1040
[  527.235849]  ? xlog_recover_process_iunlinks.isra.42+0x170/0x170
[  527.235855]  xlog_recover_commit_pass2+0x15c/0x2e0
[  527.235860]  xlog_recover_items_pass2+0x52/0x70
[  527.235865]  xlog_recover_commit_trans+0x48b/0x4b0
[  527.235871]  ? xlog_recover_items_pass2+0x70/0x70
[  527.235877]  ? kmem_alloc+0x91/0x120
[  527.235881]  ? memcpy+0x45/0x50
[  527.235886]  ? xlog_recover_add_to_trans+0x199/0x380
[  527.235891]  xlog_recovery_process_trans+0x96/0xd0
[  527.235896]  xlog_recover_process_ophdr+0xf6/0x1c0
[  527.235901]  xlog_recover_process_data+0xd5/0x1a0
[  527.235907]  xlog_recover_process+0xdd/0x160
[  527.235912]  xlog_do_recovery_pass+0x685/0x900
[  527.235917]  ? kasan_check_write+0x14/0x20
[  527.235930]  ? finish_task_switch+0xec/0x330
[  527.235936]  ? xlog_recover_process+0x160/0x160
[  527.235943]  ? kmem_alloc+0x91/0x120
[  527.235948]  xlog_do_log_recovery+0xb3/0xf0
[  527.235953]  xlog_do_recover+0x3d/0x220
[  527.235958]  xlog_recover+0x16e/0x2a0
[  527.235963]  ? xlog_find_tail+0x540/0x540
[  527.235969]  ? wake_up_process+0x15/0x20
[  527.235978]  xfs_log_mount+0x191/0x3b0
[  527.235987]  xfs_mountfs+0x98a/0x1140
[  527.235993]  ? xfs_default_resblks+0x40/0x40
[  527.236000]  ? call_function_single_interrupt+0xa/0x20
[  527.236005]  ? xfs_filestream_put_ag+0x30/0x30
[  527.236016]  ? init_timer_key+0x51/0xc0
[  527.236021]  ? __asan_store4+0x1/0x80
[  527.236025]  ? xfs_mru_cache_create+0x209/0x260
[  527.236030]  xfs_fs_fill_super+0x6ec/0x970
[  527.236039]  mount_bdev+0x1c5/0x210
[  527.236043]  ? xfs_test_remount_options+0x70/0x70
[  527.236047]  xfs_fs_mount+0x15/0x20
[  527.236051]  mount_fs+0x60/0x1a0
[  527.236057]  ? alloc_vfsmnt+0x309/0x360
[  527.236061]  vfs_kern_mount+0x6b/0x1a0
[  527.236066]  do_mount+0x34a/0x18a0
[  527.236079]  ? lockref_put_or_lock+0xcf/0x160
[  527.236085]  ? copy_mount_string+0x20/0x20
[  527.236090]  ? memcg_kmem_put_cache+0x1b/0xa0
[  527.236094]  ? kasan_check_write+0x14/0x20
[  527.236100]  ? _copy_from_user+0x6a/0x90
[  527.236111]  ? memdup_user+0x42/0x60
[  527.236116]  ksys_mount+0x83/0xd0
[  527.236121]  __x64_sys_mount+0x67/0x80
[  527.236129]  do_syscall_64+0x78/0x170
[  527.236134]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  527.236143] RIP: 0033:0x7f6606ae6b9a
[  527.236146] RSP: 002b:00007fff27fd4a48 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[  527.236156] RAX: ffffffffffffffda RBX: 0000000002532030 RCX: 00007f6606ae6b9a
[  527.236159] RDX: 0000000002532210 RSI: 0000000002533f30 RDI: 000000000253aec0
[  527.236161] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
[  527.236164] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 000000000253aec0
[  527.236166] R13: 0000000002532210 R14: 0000000000000000 R15: 0000000000000003

[  527.236503] Allocated by task 1436:
[  527.237218]  save_stack+0x46/0xd0
[  527.237223]  kasan_kmalloc+0xad/0xe0
[  527.237227]  __kmalloc+0x11f/0x240
[  527.237230]  kmem_alloc+0x91/0x120
[  527.237234]  xlog_recover_add_to_trans+0x5f/0x380
[  527.237238]  xlog_recovery_process_trans+0x9d/0xd0
[  527.237243]  xlog_recover_process_ophdr+0xf6/0x1c0
[  527.237247]  xlog_recover_process_data+0xd5/0x1a0
[  527.237250]  xlog_recover_process+0xdd/0x160
[  527.237254]  xlog_do_recovery_pass+0x685/0x900
[  527.237258]  xlog_do_log_recovery+0xb3/0xf0
[  527.237262]  xlog_do_recover+0x3d/0x220
[  527.237265]  xlog_recover+0x16e/0x2a0
[  527.237269]  xfs_log_mount+0x191/0x3b0
[  527.237273]  xfs_mountfs+0x98a/0x1140
[  527.237276]  xfs_fs_fill_super+0x6ec/0x970
[  527.237280]  mount_bdev+0x1c5/0x210
[  527.237283]  xfs_fs_mount+0x15/0x20
[  527.237287]  mount_fs+0x60/0x1a0
[  527.237290]  vfs_kern_mount+0x6b/0x1a0
[  527.237293]  do_mount+0x34a/0x18a0
[  527.237296]  ksys_mount+0x83/0xd0
[  527.237300]  __x64_sys_mount+0x67/0x80
[  527.237304]  do_syscall_64+0x78/0x170
[  527.237307]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[  527.237626] Freed by task 992:
[  527.238247]  save_stack+0x46/0xd0
[  527.238251]  __kasan_slab_free+0x13c/0x1a0
[  527.238255]  kasan_slab_free+0xe/0x10
[  527.238258]  kfree+0x8c/0x1c0
[  527.238263]  kzfree+0x2d/0x40
[  527.238270]  apparmor_file_free_security+0x4a/0x60
[  527.238282]  security_file_free+0x30/0x50
[  527.238287]  __fput+0x182/0x380
[  527.238290]  ____fput+0xe/0x10
[  527.238296]  task_work_run+0xc8/0xf0
[  527.238303]  do_exit+0x4a4/0x1390
[  527.238307]  do_group_exit+0x86/0x130
[  527.238311]  __x64_sys_exit_group+0x2c/0x30
[  527.238315]  do_syscall_64+0x78/0x170
[  527.238318]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[  527.238638] The buggy address belongs to the object at ffff8801ee017c00
                which belongs to the cache kmalloc-32 of size 32
[  527.241058] The buggy address is located 24 bytes inside of
                32-byte region [ffff8801ee017c00, ffff8801ee017c20)
[  527.243323] The buggy address belongs to the page:
[  527.244281] page:ffffea0007b805c0 count:1 mapcount:0 mapping:0000000000000000 index:0x0
[  527.245864] flags: 0x2ffff0000000100(slab)
[  527.246688] raw: 02ffff0000000100 0000000000000000 0000000000000000 0000000180550055
[  527.248213] raw: ffffea0007b43340 0000000d0000000d ffff8801f3c03880 0000000000000000
[  527.249727] page dumped because: kasan: bad access detected

[  527.251185] Memory state around the buggy address:
[  527.252131]  ffff8801ee017b00: fc fc 00 00 00 fc fc fc 00 00 00 fc fc fc 00 00
[  527.253534]  ffff8801ee017b80: 00 fc fc fc 00 00 00 00 fc fc 00 00 00 fc fc fc
[  527.254953] >ffff8801ee017c00: 00 00 00 04 fc fc 00 00 00 fc fc fc 00 00 00 00
[  527.256363]                             ^
[  527.257159]  ffff8801ee017c80: fc fc 00 00 00 00 fc fc fb fb fb fb fc fc fb fb
[  527.258599]  ffff8801ee017d00: fb fb fc fc fb fb fb fb fc fc fb fb fb fb fc fc
[  527.260020] ==================================================================
[  527.261423] Disabling lock debugging due to kernel taint
[  527.261528] BUG: unable to handle kernel paging request at ffffc90022c54300
[  527.262916] PGD 1f3d76067 P4D 1f3d76067 PUD 1f3d77067 PMD 0
[  527.264031] Oops: 0000 [#1] SMP KASAN PTI
[  527.264847] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd i2c_piix4 mac_hid soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 drm crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
[  527.274690] CPU: 1 PID: 1436 Comm: mount Tainted: G    B             4.17.0-rc4-kasan #2
[  527.276342] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  527.278192] RIP: 0010:xlog_recover_inode_pass2+0x31b/0x1040
[  527.284844] RSP: 0018:ffff8801ef6672d0 EFLAGS: 00010246
[  527.285896] RAX: 0000000000000000 RBX: ffff8801ecd9cde0 RCX: ffffffffa46cf50b
[  527.287310] RDX: dffffc0000000000 RSI: 0000000000000001 RDI: ffffc90022c54300
[  527.288709] RBP: ffff8801ef6673b8 R08: ffffed003dcaa0ad R09: ffffed003dcaa0ad
[  527.290103] R10: 0000000000000001 R11: ffffed003dcaa0ac R12: ffffc90022c54300
[  527.291512] R13: ffff8801ee550540 R14: 0000000000000000 R15: ffff8801dc38fa80
[  527.292903] FS:  00007f6607206840(0000) GS:ffff8801f4100000(0000) knlGS:0000000000000000
[  527.294477] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  527.295623] CR2: ffffc90022c54300 CR3: 00000001ef316000 CR4: 00000000000006e0
[  527.297036] Call Trace:
[  527.297575]  ? xlog_recover_process_iunlinks.isra.42+0x170/0x170
[  527.298768]  xlog_recover_commit_pass2+0x15c/0x2e0
[  527.299728]  xlog_recover_items_pass2+0x52/0x70
[  527.300624]  xlog_recover_commit_trans+0x48b/0x4b0
[  527.301571]  ? xlog_recover_items_pass2+0x70/0x70
[  527.302500]  ? kmem_alloc+0x91/0x120
[  527.303232]  ? memcpy+0x45/0x50
[  527.303871]  ? xlog_recover_add_to_trans+0x199/0x380
[  527.304851]  xlog_recovery_process_trans+0x96/0xd0
[  527.305796]  xlog_recover_process_ophdr+0xf6/0x1c0
[  527.306743]  xlog_recover_process_data+0xd5/0x1a0
[  527.307696]  xlog_recover_process+0xdd/0x160
[  527.308548]  xlog_do_recovery_pass+0x685/0x900
[  527.309431]  ? kasan_check_write+0x14/0x20
[  527.310259]  ? finish_task_switch+0xec/0x330
[  527.311119]  ? xlog_recover_process+0x160/0x160
[  527.312019]  ? kmem_alloc+0x91/0x120
[  527.312733]  xlog_do_log_recovery+0xb3/0xf0
[  527.313564]  xlog_do_recover+0x3d/0x220
[  527.314330]  xlog_recover+0x16e/0x2a0
[  527.315075]  ? xlog_find_tail+0x540/0x540
[  527.315878]  ? wake_up_process+0x15/0x20
[  527.316656]  xfs_log_mount+0x191/0x3b0
[  527.317401]  xfs_mountfs+0x98a/0x1140
[  527.318133]  ? xfs_default_resblks+0x40/0x40
[  527.319005]  ? call_function_single_interrupt+0xa/0x20
[  527.320022]  ? xfs_filestream_put_ag+0x30/0x30
[  527.320933]  ? init_timer_key+0x51/0xc0
[  527.321713]  ? __asan_store4+0x1/0x80
[  527.322452]  ? xfs_mru_cache_create+0x209/0x260
[  527.323379]  xfs_fs_fill_super+0x6ec/0x970
[  527.324199]  mount_bdev+0x1c5/0x210
[  527.324903]  ? xfs_test_remount_options+0x70/0x70
[  527.325836]  xfs_fs_mount+0x15/0x20
[  527.326537]  mount_fs+0x60/0x1a0
[  527.327200]  ? alloc_vfsmnt+0x309/0x360
[  527.327970]  vfs_kern_mount+0x6b/0x1a0
[  527.328724]  do_mount+0x34a/0x18a0
[  527.329417]  ? lockref_put_or_lock+0xcf/0x160
[  527.330291]  ? copy_mount_string+0x20/0x20
[  527.331127]  ? memcg_kmem_put_cache+0x1b/0xa0
[  527.331996]  ? kasan_check_write+0x14/0x20
[  527.332814]  ? _copy_from_user+0x6a/0x90
[  527.333604]  ? memdup_user+0x42/0x60
[  527.334322]  ksys_mount+0x83/0xd0
[  527.334999]  __x64_sys_mount+0x67/0x80
[  527.335747]  do_syscall_64+0x78/0x170
[  527.336483]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  527.337484] RIP: 0033:0x7f6606ae6b9a
[  527.338196] RSP: 002b:00007fff27fd4a48 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[  527.339691] RAX: ffffffffffffffda RBX: 0000000002532030 RCX: 00007f6606ae6b9a
[  527.341085] RDX: 0000000002532210 RSI: 0000000002533f30 RDI: 000000000253aec0
[  527.342475] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
[  527.343876] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 000000000253aec0
[  527.345271] R13: 0000000002532210 R14: 0000000000000000 R15: 0000000000000003
[  527.346666] Code: cc 01 00 00 48 8d 7b 34 e8 f3 3b cc ff 48 63 73 34 4c 89 ef e8 f7 b8 fa ff 49 89 c4 48 89 c7 48 89 85 48 ff ff ff e8 d5 3a cc ff <66> 41 81 3c 24 49 4e 0f 85 15 06 00 00 48 8b bd 58 ff ff ff e8
[  527.350395] RIP: xlog_recover_inode_pass2+0x31b/0x1040 RSP: ffff8801ef6672d0
[  527.351787] CR2: ffffc90022c54300
[  527.352463] ---[ end trace d56531d091900bff ]---

- Reason
https://elixir.bootlin.com/linux/latest/source/fs/xfs/libxfs/xfs_bmap_btree.c#L173
  dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
  fkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
  tkp = XFS_BMDR_KEY_ADDR(dblock, 1);
  fpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
  tpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
  dmxr = be16_to_cpu(dblock->bb_numrecs);
  memcpy(tkp, fkp, sizeof(*fkp) * dmxr); <-------
  memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
The out-of-bounds happen when memcpy(), I guess there is missing checks on dmxr.

Reported by Wen Xu (wen.xu@gatech.edu) from SSLab at Gatech.

Files:
38.img.zip: https://bugzilla.kernel.org/attachment.cgi?id=276507

Thanks,
Wen