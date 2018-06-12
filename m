Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0097.outbound.protection.outlook.com ([104.47.41.97]:55467
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934733AbeFLXUN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 19:20:13 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Re: Bug report: slab-out-of-bounds in xlog_recover_do_reg_buffer()
 when mounting a crafted xfs image
Date: Tue, 12 Jun 2018 23:20:11 +0000
Message-ID: <3F1536B3-309D-483B-8557-329BAA9B54C9@gatech.edu>
References: <7E9135D5-F0CD-44B4-8F84-4252A64CAD52@gatech.edu>
In-Reply-To: <7E9135D5-F0CD-44B4-8F84-4252A64CAD52@gatech.edu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F430EB1213BF8145A0FCDA3F1D8D0D41@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Files:
1.img.zip: https://bugzilla.kernel.org/attachment.cgi?id=276501
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200047

Thanks,
Wen

> On Jun 12, 2018, at 7:18 PM, Xu, Wen <wen.xu@gatech.edu> wrote:
> 
> - Overview
> slab-out-of-bounds in xlog_recover_do_reg_buffer() when mounting a crafted xfs image
> 
> - Reproduce (xfs for-next branch)
> # mkdir mnt
> # mount -t 1.img mnt
> 
> - Kernel message
> [  580.101303] XFS (loop0): Mounting V4 Filesystem
> [  580.130327] XFS (loop0): Starting recovery (logdev: internal)
> [  580.137356] XFS (loop0): xfs_buf_find: daddr 0x4000000000009af0 out of range, EOFS 0x10000
> [  580.139262] WARNING: CPU: 1 PID: 1395 at fs/xfs/xfs_buf.c:589 xfs_buf_find.isra.25+0x8b4/0xb40
> [  580.139264] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd i2c_piix4 mac_hid soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 drm crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
> [  580.139346] CPU: 1 PID: 1395 Comm: mount Not tainted 4.17.0-rc4-kasan #2
> [  580.139350] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [  580.139357] RIP: 0010:xfs_buf_find.isra.25+0x8b4/0xb40
> [  580.139360] RSP: 0018:ffff8801f24d70b0 EFLAGS: 00010286
> [  580.139365] RAX: 0000000000000000 RBX: ffff8801f24d71a0 RCX: 0000000000000000
> [  580.139369] RDX: ffffed003e49addf RSI: 000000000000000a RDI: ffff8801f24d6e00
> [  580.139373] RBP: ffff8801f24d71c8 R08: ffffed003e824f21 R09: ffffed003e824f21
> [  580.139376] R10: 0000000000000001 R11: ffffed003e824f20 R12: 0000000000002000
> [  580.139380] R13: 4000000000009af0 R14: ffff8801deb75500 R15: 0000000000000003
> [  580.139385] FS:  00007f5e61d39840(0000) GS:ffff8801f4100000(0000) knlGS:0000000000000000
> [  580.139388] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  580.139392] CR2: 00005653c73b9f70 CR3: 00000001efd72000 CR4: 00000000000006e0
> [  580.139398] Call Trace:
> [  580.139407]  ? xfs_buf_lock+0x190/0x190
> [  580.139414]  ? xfs_buftarg_isolate+0xd0/0xd0
> [  580.139421]  xfs_buf_get_map+0x8e/0x460
> [  580.139427]  ? xfs_buf_incore+0xf0/0xf0
> [  580.139437]  ? kasan_check_read+0x11/0x20
> [  580.139442]  ? xfs_buf_rele+0x38a/0x5c0
> [  580.139451]  ? _raw_spin_lock_irqsave+0x2a/0x60
> [  580.139458]  xfs_buf_read_map+0x30/0x260
> [  580.139465]  xfs_buf_readahead_map+0x95/0xd0
> [  580.139475]  xlog_recover_inode_ra_pass2.isra.27+0x197/0x1c0
> [  580.139482]  ? xlog_recover_dquot_ra_pass2.isra.26+0x1c0/0x1c0
> [  580.139490]  ? xlog_recover_buffer_ra_pass2.isra.25+0x12f/0x140
> [  580.139497]  ? xlog_recover_buffer_pass1.isra.24+0x300/0x300
> [  580.139504]  xlog_recover_ra_pass2+0x64/0xa0
> [  580.139512]  xlog_recover_commit_trans+0x1a1/0x4b0
> [  580.139520]  ? xlog_recover_items_pass2+0x70/0x70
> [  580.139527]  ? kmem_alloc+0x91/0x120
> [  580.139533]  ? memcpy+0x45/0x50
> [  580.139539]  ? xlog_recover_add_to_trans+0x199/0x380
> [  580.139546]  xlog_recovery_process_trans+0x96/0xd0
> [  580.139553]  xlog_recover_process_ophdr+0xf6/0x1c0
> [  580.139561]  xlog_recover_process_data+0xd5/0x1a0
> [  580.139568]  xlog_recover_process+0xdd/0x160
> [  580.139575]  xlog_do_recovery_pass+0x685/0x900
> [  580.139583]  ? vprintk_emit+0x373/0x450
> [  580.139591]  ? xlog_recover_process+0x160/0x160
> [  580.139599]  ? kstrtoint+0x6c/0xd0
> [  580.139607]  ? kmem_alloc+0x91/0x120
> [  580.139614]  xlog_do_log_recovery+0xb3/0xf0
> [  580.139621]  xlog_do_recover+0x3d/0x220
> [  580.139627]  xlog_recover+0x16e/0x2a0
> [  580.139633]  ? xlog_find_tail+0x540/0x540
> [  580.139641]  ? wake_up_process+0x15/0x20
> [  580.139648]  xfs_log_mount+0x191/0x3b0
> [  580.139656]  xfs_mountfs+0x98a/0x1140
> [  580.139664]  ? xfs_default_resblks+0x40/0x40
> [  580.139671]  ? kmem_alloc+0x91/0x120
> [  580.139676]  ? kmem_alloc+0x91/0x120
> [  580.139684]  ? init_timer_key+0x51/0xc0
> [  580.139690]  ? xfs_filestream_put_ag+0x30/0x30
> [  580.139694]  ? xfs_mru_cache_create+0x209/0x260
> [  580.139701]  xfs_fs_fill_super+0x6ec/0x970
> [  580.139710]  mount_bdev+0x1c5/0x210
> [  580.139716]  ? xfs_test_remount_options+0x70/0x70
> [  580.139721]  xfs_fs_mount+0x15/0x20
> [  580.139727]  mount_fs+0x60/0x1a0
> [  580.139733]  ? alloc_vfsmnt+0x309/0x360
> [  580.139739]  vfs_kern_mount+0x6b/0x1a0
> [  580.139746]  do_mount+0x34a/0x18a0
> [  580.139753]  ? lockref_put_or_lock+0xcf/0x160
> [  580.139759]  ? copy_mount_string+0x20/0x20
> [  580.139766]  ? memcg_kmem_put_cache+0x1b/0xa0
> [  580.139772]  ? kasan_check_write+0x14/0x20
> [  580.139776]  ? _copy_from_user+0x6a/0x90
> [  580.139785]  ? memdup_user+0x42/0x60
> [  580.139791]  ksys_mount+0x83/0xd0
> [  580.139797]  __x64_sys_mount+0x67/0x80
> [  580.139806]  do_syscall_64+0x78/0x170
> [  580.139812]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  580.139817] RIP: 0033:0x7f5e61619b9a
> [  580.139819] RSP: 002b:00007ffe0311b6b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> [  580.139825] RAX: ffffffffffffffda RBX: 0000000000f30030 RCX: 00007f5e61619b9a
> [  580.139828] RDX: 0000000000f30210 RSI: 0000000000f31f30 RDI: 0000000000f38ec0
> [  580.139831] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
> [  580.139834] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 0000000000f38ec0
> [  580.139837] R13: 0000000000f30210 R14: 0000000000000000 R15: 0000000000000003
> [  580.139840] Code: 48 81 c4 f0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 4c 89 e9 48 c7 c2 c0 ab 77 a5 48 c7 c6 40 a8 77 a5 4c 89 f7 e8 ac 8b 02 00 <0f> 0b c7 85 20 ff ff ff 8b ff ff ff eb 87 65 8b 05 67 f1 99 5b
> [  580.139904] ---[ end trace d56531d091900bff ]---
> [  580.139964] ==================================================================
> [  580.141419] BUG: KASAN: slab-out-of-bounds in xlog_recover_do_reg_buffer.isra.29+0xec/0x290
> [  580.155661] Read of size 4 at addr ffff8801f12959e8 by task mount/1395
> 
> [  580.157251] CPU: 1 PID: 1395 Comm: mount Tainted: G        W         4.17.0-rc4-kasan #2
> [  580.157255] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [  580.157256] Call Trace:
> [  580.157267]  dump_stack+0x7b/0xb5
> [  580.157274]  print_address_description+0x70/0x290
> [  580.157281]  kasan_report+0x291/0x390
> [  580.157288]  ? xlog_recover_do_reg_buffer.isra.29+0xec/0x290
> [  580.157294]  __asan_load4+0x78/0x80
> [  580.157301]  xlog_recover_do_reg_buffer.isra.29+0xec/0x290
> [  580.157309]  xlog_recover_buffer_pass2+0x59c/0x830
> [  580.157317]  ? xlog_recover_do_dquot_buffer+0x150/0x150
> [  580.157324]  ? xlog_recover_buffer_ra_pass2.isra.25+0x12f/0x140
> [  580.157331]  xlog_recover_commit_pass2+0x17a/0x2e0
> [  580.157338]  xlog_recover_items_pass2+0x52/0x70
> [  580.157345]  xlog_recover_commit_trans+0x48b/0x4b0
> [  580.157352]  ? xlog_recover_items_pass2+0x70/0x70
> [  580.157358]  ? kmem_alloc+0x91/0x120
> [  580.157363]  ? memcpy+0x45/0x50
> [  580.157370]  ? xlog_recover_add_to_trans+0x199/0x380
> [  580.157377]  xlog_recovery_process_trans+0x96/0xd0
> [  580.157384]  xlog_recover_process_ophdr+0xf6/0x1c0
> [  580.157391]  xlog_recover_process_data+0xd5/0x1a0
> [  580.157399]  xlog_recover_process+0xdd/0x160
> [  580.157406]  xlog_do_recovery_pass+0x685/0x900
> [  580.157411]  ? vprintk_emit+0x373/0x450
> [  580.157419]  ? xlog_recover_process+0x160/0x160
> [  580.157425]  ? kstrtoint+0x6c/0xd0
> [  580.157433]  ? kmem_alloc+0x91/0x120
> [  580.157440]  xlog_do_log_recovery+0xb3/0xf0
> [  580.157446]  xlog_do_recover+0x3d/0x220
> [  580.157453]  xlog_recover+0x16e/0x2a0
> [  580.157459]  ? xlog_find_tail+0x540/0x540
> [  580.157465]  ? wake_up_process+0x15/0x20
> [  580.157471]  xfs_log_mount+0x191/0x3b0
> [  580.157478]  xfs_mountfs+0x98a/0x1140
> [  580.157486]  ? xfs_default_resblks+0x40/0x40
> [  580.157492]  ? kmem_alloc+0x91/0x120
> [  580.157498]  ? kmem_alloc+0x91/0x120
> [  580.157504]  ? init_timer_key+0x51/0xc0
> [  580.157509]  ? xfs_filestream_put_ag+0x30/0x30
> [  580.157514]  ? xfs_mru_cache_create+0x209/0x260
> [  580.157520]  xfs_fs_fill_super+0x6ec/0x970
> [  580.157527]  mount_bdev+0x1c5/0x210
> [  580.157532]  ? xfs_test_remount_options+0x70/0x70
> [  580.157537]  xfs_fs_mount+0x15/0x20
> [  580.157543]  mount_fs+0x60/0x1a0
> [  580.157548]  ? alloc_vfsmnt+0x309/0x360
> [  580.157553]  vfs_kern_mount+0x6b/0x1a0
> [  580.157559]  do_mount+0x34a/0x18a0
> [  580.157565]  ? lockref_put_or_lock+0xcf/0x160
> [  580.157571]  ? copy_mount_string+0x20/0x20
> [  580.157577]  ? memcg_kmem_put_cache+0x1b/0xa0
> [  580.157582]  ? kasan_check_write+0x14/0x20
> [  580.157587]  ? _copy_from_user+0x6a/0x90
> [  580.157593]  ? memdup_user+0x42/0x60
> [  580.157599]  ksys_mount+0x83/0xd0
> [  580.157605]  __x64_sys_mount+0x67/0x80
> [  580.157611]  do_syscall_64+0x78/0x170
> [  580.157617]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  580.157621] RIP: 0033:0x7f5e61619b9a
> [  580.157624] RSP: 002b:00007ffe0311b6b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> [  580.157629] RAX: ffffffffffffffda RBX: 0000000000f30030 RCX: 00007f5e61619b9a
> [  580.157632] RDX: 0000000000f30210 RSI: 0000000000f31f30 RDI: 0000000000f38ec0
> [  580.157635] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
> [  580.157638] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 0000000000f38ec0
> [  580.157641] R13: 0000000000f30210 R14: 0000000000000000 R15: 0000000000000003
> 
> [  580.157964] Allocated by task 1395:
> [  580.158664]  save_stack+0x46/0xd0
> [  580.158669]  kasan_kmalloc+0xad/0xe0
> [  580.158674]  __kmalloc+0x11f/0x240
> [  580.158679]  kmem_alloc+0x91/0x120
> [  580.158684]  xlog_recover_add_to_trans+0x121/0x380
> [  580.158690]  xlog_recovery_process_trans+0x9d/0xd0
> [  580.158696]  xlog_recover_process_ophdr+0xf6/0x1c0
> [  580.158701]  xlog_recover_process_data+0xd5/0x1a0
> [  580.158707]  xlog_recover_process+0xdd/0x160
> [  580.158712]  xlog_do_recovery_pass+0x685/0x900
> [  580.158718]  xlog_do_log_recovery+0xb3/0xf0
> [  580.158723]  xlog_do_recover+0x3d/0x220
> [  580.158728]  xlog_recover+0x16e/0x2a0
> [  580.158733]  xfs_log_mount+0x191/0x3b0
> [  580.158739]  xfs_mountfs+0x98a/0x1140
> [  580.158743]  xfs_fs_fill_super+0x6ec/0x970
> [  580.158748]  mount_bdev+0x1c5/0x210
> [  580.158752]  xfs_fs_mount+0x15/0x20
> [  580.158757]  mount_fs+0x60/0x1a0
> [  580.158762]  vfs_kern_mount+0x6b/0x1a0
> [  580.158766]  do_mount+0x34a/0x18a0
> [  580.158771]  ksys_mount+0x83/0xd0
> [  580.158776]  __x64_sys_mount+0x67/0x80
> [  580.158781]  do_syscall_64+0x78/0x170
> [  580.158786]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [  580.159116] Freed by task 1:
> [  580.159701]  save_stack+0x46/0xd0
> [  580.159707]  __kasan_slab_free+0x13c/0x1a0
> [  580.159712]  kasan_slab_free+0xe/0x10
> [  580.159716]  kfree+0x8c/0x1c0
> [  580.159723]  kzfree+0x2d/0x40
> [  580.159731]  apparmor_file_free_security+0x4a/0x60
> [  580.159740]  security_file_free+0x30/0x50
> [  580.159745]  put_filp+0x2d/0x70
> [  580.159752]  path_openat+0x564/0x1e80
> [  580.159758]  do_filp_open+0x12b/0x1d0
> [  580.159762]  do_sys_open+0x17c/0x2c0
> [  580.159766]  __x64_sys_open+0x4c/0x60
> [  580.159771]  do_syscall_64+0x78/0x170
> [  580.159776]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [  580.160094] The buggy address belongs to the object at ffff8801f12959c0
>                which belongs to the cache kmalloc-32 of size 32
> [  580.162489] The buggy address is located 8 bytes to the right of
>                32-byte region [ffff8801f12959c0, ffff8801f12959e0)
> [  580.164836] The buggy address belongs to the page:
> [  580.165789] page:ffffea0007c4a540 count:1 mapcount:0 mapping:0000000000000000 index:0x0
> [  580.167361] flags: 0x2ffff0000000100(slab)
> [  580.168179] raw: 02ffff0000000100 0000000000000000 0000000000000000 0000000180550055
> [  580.169692] raw: dead000000000100 dead000000000200 ffff8801f3c03880 0000000000000000
> [  580.171209] page dumped because: kasan: bad access detected
> 
> [  580.172611] Memory state around the buggy address:
> [  580.173557]  ffff8801f1295880: fb fb fc fc fb fb fb fb fc fc 00 00 00 fc fc fc
> [  580.174975]  ffff8801f1295900: fb fb fb fb fc fc 00 00 00 00 fc fc 00 00 00 00
> [  580.176387] >ffff8801f1295980: fc fc fb fb fb fb fc fc 00 00 00 00 fc fc 00 00
> [  580.177800]                                                           ^
> [  580.179106]  ffff8801f1295a00: 00 fc fc fc 00 00 00 00 fc fc fb fb fb fb fc fc
> [  580.180524]  ffff8801f1295a80: 00 00 00 00 fc fc fb fb fb fb fc fc 00 00 00 00
> [  580.181935] ==================================================================
> [  580.183359] Disabling lock debugging due to kernel taint
> [  580.183412] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> [  580.184967] PGD 80000001e52f4067 P4D 80000001e52f4067 PUD 1e52f2067 PMD 0
> [  580.186319] Oops: 0000 [#1] SMP KASAN PTI
> [  580.187128] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd i2c_piix4 mac_hid soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 drm crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
> [  580.196615] CPU: 1 PID: 1395 Comm: mount Tainted: G    B   W         4.17.0-rc4-kasan #2
> [  580.198184] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [  580.200037] RIP: 0010:__memcpy+0x12/0x20
> [  580.200815] RSP: 0018:ffff8801f24d7230 EFLAGS: 00010246
> [  580.201845] RAX: ffff8801e0bc1400 RBX: fffffffff3c56200 RCX: 1ffffffffe78ac40
> [  580.203245] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801e0bc1400
> [  580.204631] RBP: ffff8801f24d7250 R08: ffffed003c178401 R09: ffffed003a902ec0
> [  580.206017] R10: fffffffffe78ac40 R11: ffffed003a902ebf R12: ffff8801e0bc1400
> [  580.207417] R13: 0000000000000000 R14: 00000000f3c56220 R15: ffff8801f12958d0
> [  580.208805] FS:  00007f5e61d39840(0000) GS:ffff8801f4100000(0000) knlGS:0000000000000000
> [  580.210374] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  580.211507] CR2: 0000000000000000 CR3: 00000001efd72000 CR4: 00000000000006e0
> [  580.212895] Call Trace:
> [  580.213396]  ? memcpy+0x45/0x50
> [  580.214029]  xlog_recover_do_reg_buffer.isra.29+0x1b3/0x290
> [  580.215136]  xlog_recover_buffer_pass2+0x59c/0x830
> [  580.216085]  ? xlog_recover_do_dquot_buffer+0x150/0x150
> [  580.217118]  ? xlog_recover_buffer_ra_pass2.isra.25+0x12f/0x140
> [  580.218282]  xlog_recover_commit_pass2+0x17a/0x2e0
> [  580.219239]  xlog_recover_items_pass2+0x52/0x70
> [  580.220136]  xlog_recover_commit_trans+0x48b/0x4b0
> [  580.221082]  ? xlog_recover_items_pass2+0x70/0x70
> [  580.222010]  ? kmem_alloc+0x91/0x120
> [  580.222721]  ? memcpy+0x45/0x50
> [  580.223368]  ? xlog_recover_add_to_trans+0x199/0x380
> [  580.224350]  xlog_recovery_process_trans+0x96/0xd0
> [  580.225292]  xlog_recover_process_ophdr+0xf6/0x1c0
> [  580.226239]  xlog_recover_process_data+0xd5/0x1a0
> [  580.227177]  xlog_recover_process+0xdd/0x160
> [  580.228036]  xlog_do_recovery_pass+0x685/0x900
> [  580.228914]  ? vprintk_emit+0x373/0x450
> [  580.229678]  ? xlog_recover_process+0x160/0x160
> [  580.230569]  ? kstrtoint+0x6c/0xd0
> [  580.231263]  ? kmem_alloc+0x91/0x120
> [  580.231993]  xlog_do_log_recovery+0xb3/0xf0
> [  580.232827]  xlog_do_recover+0x3d/0x220
> [  580.233590]  xlog_recover+0x16e/0x2a0
> [  580.234322]  ? xlog_find_tail+0x540/0x540
> [  580.235146]  ? wake_up_process+0x15/0x20
> [  580.235935]  xfs_log_mount+0x191/0x3b0
> [  580.236685]  xfs_mountfs+0x98a/0x1140
> [  580.237422]  ? xfs_default_resblks+0x40/0x40
> [  580.238270]  ? kmem_alloc+0x91/0x120
> [  580.238999]  ? kmem_alloc+0x91/0x120
> [  580.239716]  ? init_timer_key+0x51/0xc0
> [  580.240479]  ? xfs_filestream_put_ag+0x30/0x30
> [  580.241360]  ? xfs_mru_cache_create+0x209/0x260
> [  580.242258]  xfs_fs_fill_super+0x6ec/0x970
> [  580.243088]  mount_bdev+0x1c5/0x210
> [  580.243787]  ? xfs_test_remount_options+0x70/0x70
> [  580.244713]  xfs_fs_mount+0x15/0x20
> [  580.245408]  mount_fs+0x60/0x1a0
> [  580.246056]  ? alloc_vfsmnt+0x309/0x360
> [  580.246821]  vfs_kern_mount+0x6b/0x1a0
> [  580.247583]  do_mount+0x34a/0x18a0
> [  580.248264]  ? lockref_put_or_lock+0xcf/0x160
> [  580.249129]  ? copy_mount_string+0x20/0x20
> [  580.249941]  ? memcg_kmem_put_cache+0x1b/0xa0
> [  580.250804]  ? kasan_check_write+0x14/0x20
> [  580.251630]  ? _copy_from_user+0x6a/0x90
> [  580.252412]  ? memdup_user+0x42/0x60
> [  580.253124]  ksys_mount+0x83/0xd0
> [  580.253789]  __x64_sys_mount+0x67/0x80
> [  580.254539]  do_syscall_64+0x78/0x170
> [  580.255284]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  580.256278] RIP: 0033:0x7f5e61619b9a
> [  580.256988] RSP: 002b:00007ffe0311b6b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> [  580.258467] RAX: ffffffffffffffda RBX: 0000000000f30030 RCX: 00007f5e61619b9a
> [  580.285047] RDX: 0000000000f30210 RSI: 0000000000f31f30 RDI: 0000000000f38ec0
> [  580.286441] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
> [  580.287859] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 0000000000f38ec0
> [  580.289259] R13: 0000000000f30210 R14: 0000000000000000 R15: 0000000000000003
> [  580.290657] Code: 4e 5b 41 5c 41 5d 5d c3 48 89 df e8 59 f6 ff ff eb c9 90 90 90 90 90 90 90 66 66 90 66 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 f3
> [  580.294393] RIP: __memcpy+0x12/0x20 RSP: ffff8801f24d7230
> [  580.295467] CR2: 0000000000000000
> [  580.296205] ---[ end trace d56531d091900c00 ]---
> 
> - Reason
> In function xlog_recover_do_reg_buffer(),
> https://elixir.bootlin.com/linux/latest/source/fs/xfs/xfs_log_recover.c#L2645
> item->ri_buf[i] is accessed, while i can be out of the boundary of item which leads to kernel crash.
> 
> I think this out-of-bound issues also can happen in function xlog_recover_do_inode_buffer() and xlog_recover_inode_pass2(). I can provide the images to trigger out-of-bounds access in these two functions if needed.
> 
> Reported by Wen Xu (wen.xu@gatech.edu) from SSLab at Gatech.
> 
> Thanks,
> Wen

