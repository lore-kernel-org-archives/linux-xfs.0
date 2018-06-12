Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0130.outbound.protection.outlook.com ([104.47.38.130]:48288
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933981AbeFLXV5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 19:21:57 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: NULL pointer dereference in xlog_recover_add_to_cont_trans() when
 mounting a crafted xfs image
Date: Tue, 12 Jun 2018 23:21:55 +0000
Message-ID: <94068C0A-9040-415A-B7D9-5710F25F1AD4@gatech.edu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A337EEA147C6E4CB9FF396625B136F5@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

- Overview
NULL pointer dereference in xlog_recover_add_to_cont_trans() when mounting a crafted xfs image

- Reproduce (xfs/for-next)
# mkdir mnt
# mount -t 33.img mnt

- Kernel message
[  529.053832] XFS (loop0): Mounting V4 Filesystem
[  529.088326] XFS (loop0): Starting recovery (logdev: internal)
[  529.090145] BUG: unable to handle kernel paging request at fffffffffffffff0
[  529.091677] PGD 226e12067 P4D 226e12067 PUD 226e14067 PMD 0
[  529.092849] Oops: 0000 [#1] SMP KASAN PTI
[  529.093680] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd i2c_piix4 mac_hid soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 drm crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
[  529.103395] CPU: 0 PID: 1436 Comm: mount Not tainted 4.17.0-rc4-kasan #2
[  529.104726] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  529.106631] RIP: 0010:xlog_recover_add_to_cont_trans+0x85/0x230
[  529.107818] RSP: 0018:ffff8801ee887500 EFLAGS: 00010246
[  529.108868] RAX: 0000000000000000 RBX: ffff8801efa93660 RCX: ffffffffa46ce6d5
[  529.110281] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI: fffffffffffffff0
[  529.111701] RBP: ffff8801ee887550 R08: 0000000000000008 R09: ffff8801efa93674
[  529.113104] R10: ffff8801efa93680 R11: ffffed003df526ac R12: ffff8801efa93540
[  529.114515] R13: 0000000000000018 R14: ffff8801dc3edf80 R15: fffffffffffffff0
[  529.115933] FS:  00007fce79ea6840(0000) GS:ffff8801f4000000(0000) knlGS:0000000000000000
[  529.117522] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  529.118658] CR2: fffffffffffffff0 CR3: 00000001efa9a000 CR4: 00000000000006f0
[  529.120091] Call Trace:
[  529.120607]  ? kmem_alloc+0x91/0x120
[  529.121330]  xlog_recovery_process_trans+0x7b/0xd0
[  529.122283]  xlog_recover_process_ophdr+0xf6/0x1c0
[  529.123256]  xlog_recover_process_data+0xd5/0x1a0
[  529.124200]  xlog_recover_process+0xdd/0x160
[  529.125062]  xlog_do_recovery_pass+0x685/0x900
[  529.125963]  ? kasan_check_write+0x14/0x20
[  529.126798]  ? finish_task_switch+0xec/0x330
[  529.127666]  ? xlog_recover_process+0x160/0x160
[  529.128571]  ? kmem_alloc+0x91/0x120
[  529.129294]  xlog_do_log_recovery+0x96/0xf0
[  529.130132]  xlog_do_recover+0x3d/0x220
[  529.130903]  xlog_recover+0x16e/0x2a0
[  529.131652]  ? xlog_find_tail+0x540/0x540
[  529.132465]  ? wake_up_process+0x15/0x20
[  529.133254]  xfs_log_mount+0x191/0x3b0
[  529.134014]  xfs_mountfs+0x98a/0x1140
[  529.134756]  ? xfs_default_resblks+0x40/0x40
[  529.135624]  ? kmem_alloc+0x91/0x120
[  529.136348]  ? kmem_alloc+0x91/0x120
[  529.137079]  ? init_timer_key+0x51/0xc0
[  529.137855]  ? xfs_filestream_put_ag+0x30/0x30
[  529.138746]  ? xfs_mru_cache_create+0x209/0x260
[  529.139667]  xfs_fs_fill_super+0x6ec/0x970
[  529.140497]  mount_bdev+0x1c5/0x210
[  529.141205]  ? xfs_test_remount_options+0x70/0x70
[  529.142144]  xfs_fs_mount+0x15/0x20
[  529.142848]  mount_fs+0x60/0x1a0
[  529.143514]  ? alloc_vfsmnt+0x309/0x360
[  529.144292]  vfs_kern_mount+0x6b/0x1a0
[  529.145049]  do_mount+0x34a/0x18a0
[  529.145750]  ? lockref_put_or_lock+0xcf/0x160
[  529.146632]  ? copy_mount_string+0x20/0x20
[  529.147466]  ? memcg_kmem_put_cache+0x1b/0xa0
[  529.148339]  ? kasan_check_write+0x14/0x20
[  529.149164]  ? _copy_from_user+0x6a/0x90
[  529.149961]  ? memdup_user+0x42/0x60
[  529.150687]  ksys_mount+0x83/0xd0
[  529.151369]  __x64_sys_mount+0x67/0x80
[  529.152129]  do_syscall_64+0x78/0x170
[  529.152879]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  529.153897] RIP: 0033:0x7fce79786b9a
[  529.154618] RSP: 002b:00007fff61eba3e8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[  529.156113] RAX: ffffffffffffffda RBX: 0000000000ee3030 RCX: 00007fce79786b9a
[  529.157522] RDX: 0000000000ee3210 RSI: 0000000000ee4f30 RDI: 0000000000eebec0
[  529.158931] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
[  529.165106] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 0000000000eebec0
[  529.166512] R13: 0000000000ee3210 R14: 0000000000000000 R15: 0000000000000003
[  529.167947] Code: cc ff 4c 8d 4b 14 4c 8b 7b 20 4c 89 cf 4c 89 4d b8 e8 20 4a cc ff 48 63 43 14 48 c1 e0 04 4d 8d 7c 07 f0 4c 89 ff e8 0b 4b cc ff <49> 8b 07 49 8d 7f 08 48 89 45 c8 e8 fb 49 cc ff 41 8b 4f 08 48
[  529.171702] RIP: xlog_recover_add_to_cont_trans+0x85/0x230 RSP: ffff8801ee887500
[  529.173156] CR2: fffffffffffffff0
[  529.173836] ---[ end trace d56531d091900bff ]---
[  529.174801] ==================================================================
[  529.176260] BUG: KASAN: stack-out-of-bounds in tick_sched_handle+0x30/0xa0
[  529.177611] Read of size 8 at addr ffff8801ee887dc0 by task mount/1436

[  529.179236] CPU: 0 PID: 1436 Comm: mount Tainted: G      D           4.17.0-rc4-kasan #2
[  529.180840] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  529.182696] Call Trace:
[  529.183209]  <IRQ>
[  529.183643]  dump_stack+0x7b/0xb5
[  529.184322]  print_address_description+0x70/0x290
[  529.185255]  kasan_report+0x291/0x390
[  529.185992]  ? tick_sched_handle+0x30/0xa0
[  529.186811]  ? tick_sched_do_timer+0x90/0x90
[  529.187683]  __asan_load8+0x54/0x90
[  529.188392]  tick_sched_handle+0x30/0xa0
[  529.189184]  tick_sched_timer+0x3c/0xa0
[  529.189958]  __hrtimer_run_queues+0x202/0x420
[  529.190836]  ? hrtimer_cancel+0x20/0x20
[  529.191631]  ? kvm_clock_get_cycles+0x1e/0x20
[  529.192507]  ? ktime_get_update_offsets_now+0xa6/0x160
[  529.193523]  hrtimer_interrupt+0x1b7/0x350
[  529.194348]  smp_apic_timer_interrupt+0x85/0x1b0
[  529.195284]  apic_timer_interrupt+0xf/0x20
[  529.196105]  </IRQ>
[  529.196554] RIP: 0010:__raw_spin_unlock_irq+0xf/0x20
[  529.197546] RSP: 0018:ffff8801ee887de8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[  529.199056] RAX: 0000000000000000 RBX: ffff8801e652b600 RCX: ffffffffa51ce80e
[  529.200483] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff8801e652bd24
[  529.201894] RBP: ffff8801ee887de8 R08: ffffed003cca57a5 R09: ffffed003cca57a5
[  529.203317] R10: 0000000000000001 R11: ffffed003cca57a4 R12: 0000000000000009
[  529.204737] R13: ffff8801e652bd24 R14: 0000000000000046 R15: 0000000000000000
[  529.206157]  ? _raw_spin_lock_irq+0x1e/0x3f
[  529.207001]  do_exit+0x188/0x1390
[  529.207690]  ? kasan_check_write+0x14/0x20
[  529.208522]  ? _copy_from_user+0x6a/0x90
[  529.209317]  ? mm_update_next_owner+0x380/0x380
[  529.210232]  ? memdup_user+0x42/0x60
[  529.210952]  ? ksys_mount+0x83/0xd0
[  529.211675]  ? __x64_sys_mount+0x67/0x80
[  529.212468]  rewind_stack_do_exit+0x17/0x20
[  529.213309] RIP: 0033:0x7fce79786b9a
[  529.214030] RSP: 002b:00007fff61eba3e8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[  529.215546] RAX: ffffffffffffffda RBX: 0000000000ee3030 RCX: 00007fce79786b9a
[  529.216961] RDX: 0000000000ee3210 RSI: 0000000000ee4f30 RDI: 0000000000eebec0
[  529.218374] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
[  529.219803] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 0000000000eebec0
[  529.221218] R13: 0000000000ee3210 R14: 0000000000000000 R15: 0000000000000003

[  529.222952] The buggy address belongs to the page:
[  529.223928] page:ffffea0007ba21c0 count:0 mapcount:0 mapping:0000000000000000 index:0x0
[  529.225520] flags: 0x2ffff0000000000()
[  529.226284] raw: 02ffff0000000000 0000000000000000 0000000000000000 00000000ffffffff
[  529.227836] raw: 0000000000000000 ffffea0007ba2260 ffff8801f3d9c000 0000000000000000
[  529.229371] page dumped because: kasan: bad access detected

[  529.230800] Memory state around the buggy address:
[  529.231768]  ffff8801ee887c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  529.233207]  ffff8801ee887d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  529.234643] >ffff8801ee887d80: 00 00 00 00 00 00 00 00 f1 00 00 f4 f4 f2 f2 f2
[  529.236087]                                            ^
[  529.237150]  ffff8801ee887e00: f2 00 00 f4 f4 f2 f2 f2 f1 f1 f1 f1 00 f4 f4 f4
[  529.238580]  ffff8801ee887e80: f2 f2 f2 f2 00 f4 f4 f4 f2 f2 f2 f2 00 00 f4 f4
[  529.240018] ==================================================================

- Reason
https://elixir.bootlin.com/linux/latest/source/fs/xfs/xfs_log_recover.c#L4277

old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
old_len = item->ri_buf[item->ri_cnt-1].i_len;

item->ri_buf can be NULL, which is not properly initialized I suspect.

Reported by Wen Xu (wen.xu@gatech.edu) from SSLab at Gatech.

Files:
33.img.zip: https://bugzilla.kernel.org/attachment.cgi?id=276505

Thanks,
Wen