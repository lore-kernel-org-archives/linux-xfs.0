Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B5887CBF
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 09:49:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 286A28F8066
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 07:49:05 -0700 (PDT)
Received: from mout.web.de (mout.web.de [212.227.15.3]) by cuda.sgi.com with
	ESMTP id gKpSVMKG8L35tB04 for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 07:49:03 -0700 (PDT)
Received: from ilfaris ([84.133.43.234]) by smtp.web.de (mrweb003) with
	ESMTPSA (Nemesis) id 0Le4PE-1UXGew3fXo-00qG1t for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 15:49:03 +0100
Date: Sun, 10 Mar 2013 15:49:00 +0100
From: Julian Wollrath <jwollrath@web.de>
Subject: Null pointer dereference and following traces on 3.9-rc1
Message-ID: <20130310154900.673deee0@ilfaris>
Mime-Version: 1.0
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

Hello,

after a xfs_fsr run I found the following in my syslog:
Mar 10 14:56:05 ilfaris kernel: [  472.865406] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
Mar 10 14:56:05 ilfaris kernel: [  472.865585] IP: [<ffffffff811edfb8>] xfs_trans_log_inode+0x8/0x30
Mar 10 14:56:05 ilfaris kernel: [  472.865711] PGD 11645b067 PUD 11a7cd067 PMD 0 
Mar 10 14:56:05 ilfaris kernel: [  472.865811] Oops: 0000 [#1] SMP 
Mar 10 14:56:05 ilfaris kernel: [  472.865880] Modules linked in: uvcvideo rtl8192ce rtlwifi mac80211 ohci_hcd ehci_pci ehci_hcd psmouse deflate zlib_deflate des_generic ecb sha512_generic sha1_generic hmac af_key xfrm_algo loop fuse btusb arc4 bluetooth crc16 snd_hda_codec_conexant radeon i2c_algo_bit drm_kms_helper snd_hda_codec_hdmi cfg80211 ttm snd_hda_intel drm videobuf2_vmalloc snd_hda_codec videobuf2_memops videobuf2_core snd_hwdep snd_pcm videodev snd_page_alloc agpgart thinkpad_acpi nvram acpi_cpufreq i2c_piix4 serio_raw rtl8192c_common snd_timer rfkill mperf pcspkr i2c_core k10temp evdev battery ac snd video wmi processor button soundcore sha256_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod sd_mod crc_t10dif rtsx_pci_sdmmc mmc_core microcode thermal thermal_sys ahci libahci rtsx_pci mfd_core usbcore usb_common libata scsi_mod [last unloaded: uvcvideo]
Mar 10 14:56:05 ilfaris kernel: [  472.867709] CPU 1 
Mar 10 14:56:05 ilfaris kernel: [  472.867755] Pid: 4694, comm: xfs_fsr Not tainted 3.9.0-rc1+ #1 LENOVO 30515YG/30515YG
Mar 10 14:56:05 ilfaris kernel: [  472.867898] RIP: 0010:[<ffffffff811edfb8>]  [<ffffffff811edfb8>] xfs_trans_log_inode+0x8/0x30
Mar 10 14:56:05 ilfaris kernel: [  472.868058] RSP: 0018:ffff880119c0bc80  EFLAGS: 00010202
Mar 10 14:56:05 ilfaris kernel: [  472.868154] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
Mar 10 14:56:05 ilfaris kernel: [  472.868280] RDX: 0000000000000005 RSI: ffff8800a5a367c0 RDI: ffff8800b33063b0
Mar 10 14:56:05 ilfaris kernel: [  472.868406] RBP: ffff8800a5a367c0 R08: ffffffff00000001 R09: ffff8800a5a36838
Mar 10 14:56:05 ilfaris kernel: [  472.868530] R10: 0000000000000005 R11: ffff8800aca17e78 R12: 0000000000000005
Mar 10 14:56:05 ilfaris kernel: [  472.868655] R13: 0000000000000000 R14: ffff8800a5a367f8 R15: 0000000000000000
Mar 10 14:56:05 ilfaris kernel: [  472.868782] FS:  00007f603b1e2700(0000) GS:ffff88011ed00000(0000) knlGS:0000000000000000
Mar 10 14:56:05 ilfaris kernel: [  472.868923] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 10 14:56:05 ilfaris kernel: [  472.869025] CR2: 0000000000000018 CR3: 000000010997e000 CR4: 00000000000007e0
Mar 10 14:56:05 ilfaris kernel: [  472.869149] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 10 14:56:05 ilfaris kernel: [  472.869274] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 10 14:56:05 ilfaris kernel: [  472.869400] Process xfs_fsr (pid: 4694, threadinfo ffff880119c0a000, task ffff8800a0240190)
Mar 10 14:56:05 ilfaris kernel: [  472.869543] Stack:
Mar 10 14:56:05 ilfaris kernel: [  472.869584]  ffffffff811bedc3 ffff880100000000 ffffffff811968aa ffff880000000000
Mar 10 14:56:05 ilfaris kernel: [  472.869733]  ffff8801196df000 0000000200000000 ffff8800b33063b0 ffff8800a5a367c0
Mar 10 14:56:05 ilfaris kernel: [  472.869881]  0000000000000000 0000000500000000 0000000000000000 0000000000000000
Mar 10 14:56:05 ilfaris kernel: [  472.870030] Call Trace:
Mar 10 14:56:05 ilfaris kernel: [  472.870086]  [<ffffffff811bedc3>] ? xfs_bunmapi+0x633/0x7f0
Mar 10 14:56:05 ilfaris kernel: [  472.870192]  [<ffffffff811968aa>] ? xfs_swapext+0x22a/0x800
Mar 10 14:56:05 ilfaris kernel: [  472.870297]  [<ffffffff811d7ca3>] ? xfs_itruncate_extents+0xe3/0x2a0
Mar 10 14:56:05 ilfaris kernel: [  472.870416]  [<ffffffff811a8336>] ? xfs_inactive+0x306/0x410
Mar 10 14:56:05 ilfaris kernel: [  472.870523]  [<ffffffff811a4b9a>] ? xfs_fs_evict_inode+0x2a/0xb0
Mar 10 14:56:05 ilfaris kernel: [  472.870634]  [<ffffffff81130952>] ? evict+0xa2/0x190
Mar 10 14:56:05 ilfaris kernel: [  472.870729]  [<ffffffff8112d0c0>] ? d_kill+0xe0/0x130
Mar 10 14:56:05 ilfaris kernel: [  472.870825]  [<ffffffff8112d769>] ? dput+0xd9/0x1a0
Mar 10 14:56:05 ilfaris kernel: [  472.870917]  [<ffffffff8111a28c>] ? __fput+0x15c/0x240
Mar 10 14:56:05 ilfaris kernel: [  472.871017]  [<ffffffff8105682f>] ? task_work_run+0x8f/0xd0
Mar 10 14:56:05 ilfaris kernel: [  472.871122]  [<ffffffff813fd9da>] ? int_signal+0x12/0x17
Mar 10 14:56:05 ilfaris kernel: [  472.871217] Code: 38 c3 90 48 3b 93 b0 01 00 00 75 cd eb e5 0f 1f 44 00 00 48 3b 93 a0 01 00 00 75 95 eb ad 0f 1f 44 00 00 83 4f 68 01 48 8b 46 78 <48> 8b 40 18 80 48 18 01 48 8b 4e 78 8b 81 90 00 00 00 0b 81 8c 
Mar 10 14:56:05 ilfaris kernel: [  472.871897] RIP  [<ffffffff811edfb8>] xfs_trans_log_inode+0x8/0x30
Mar 10 14:56:05 ilfaris kernel: [  472.872016]  RSP <ffff880119c0bc80>
Mar 10 14:56:05 ilfaris kernel: [  472.872081] CR2: 0000000000000018
Mar 10 14:56:05 ilfaris kernel: [  472.895316] ---[ end trace 5ee27f6cb3453334 ]---
Mar 10 14:56:05 ilfaris kernel: [  472.897470] ------------[ cut here ]------------
Mar 10 14:56:05 ilfaris kernel: [  472.897583] kernel BUG at fs/xfs/xfs_icache.c:323!
Mar 10 14:56:05 ilfaris kernel: [  472.902476] invalid opcode: 0000 [#2] SMP 
Mar 10 14:56:05 ilfaris kernel: [  472.907309] Modules linked in: uvcvideo rtl8192ce rtlwifi mac80211 ohci_hcd ehci_pci ehci_hcd psmouse deflate zlib_deflate des_generic ecb sha512_generic sha1_generic hmac af_key xfrm_algo loop fuse btusb arc4 bluetooth crc16 snd_hda_codec_conexant radeon i2c_algo_bit drm_kms_helper snd_hda_codec_hdmi cfg80211 ttm snd_hda_intel drm videobuf2_vmalloc snd_hda_codec videobuf2_memops videobuf2_core snd_hwdep snd_pcm videodev snd_page_alloc agpgart thinkpad_acpi nvram acpi_cpufreq i2c_piix4 serio_raw rtl8192c_common snd_timer rfkill mperf pcspkr i2c_core k10temp evdev battery ac snd video wmi processor button soundcore sha256_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod sd_mod crc_t10dif rtsx_pci_sdmmc mmc_core microcode thermal thermal_sys ahci libahci rtsx_pci mfd_core usbcore usb_common libata scsi_mod [last unloaded: uvcvideo]
Mar 10 14:56:05 ilfaris kernel: [  472.939548] CPU 1 
Mar 10 14:56:05 ilfaris kernel: [  472.939594] Pid: 4695, comm: xfs_fsr Tainted: G      D      3.9.0-rc1+ #1 LENOVO 30515YG/30515YG
Mar 10 14:56:05 ilfaris kernel: [  472.949484] RIP: 0010:[<ffffffff8119d38e>]  [<ffffffff8119d38e>] xfs_iget+0x6be/0x6c0
Mar 10 14:56:05 ilfaris kernel: [  472.954492] RSP: 0018:ffff880103db7c28  EFLAGS: 00010246
Mar 10 14:56:05 ilfaris kernel: [  472.959435] RAX: 0000000000000000 RBX: ffff8800a5a36818 RCX: 0000000000000002
Mar 10 14:56:05 ilfaris kernel: [  472.964384] RDX: ffffffff00000001 RSI: 0000000000000004 RDI: ffff8800a5a36898
Mar 10 14:56:05 ilfaris kernel: [  472.969302] RBP: ffff8800a0aae180 R08: 0000000000000000 R09: ffff8800a6218f90
Mar 10 14:56:05 ilfaris kernel: [  472.974185] R10: 0000000000000005 R11: 0000000000000004 R12: 00000000000675e0
Mar 10 14:56:05 ilfaris kernel: [  472.979059] R13: ffff880116576890 R14: 0000000000000011 R15: 0000000000000000
Mar 10 14:56:05 ilfaris kernel: [  472.983914] FS:  00007f603b1e2700(0000) GS:ffff88011ed00000(0000) knlGS:0000000000000000
Mar 10 14:56:05 ilfaris kernel: [  472.988815] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 10 14:56:05 ilfaris kernel: [  472.993748] CR2: 00007f603aa95de0 CR3: 000000010997e000 CR4: 00000000000007e0
Mar 10 14:56:05 ilfaris kernel: [  472.998700] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 10 14:56:05 ilfaris kernel: [  473.003605] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 10 14:56:05 ilfaris kernel: [  473.008458] Process xfs_fsr (pid: 4695, threadinfo ffff880103db6000, task ffff8800a0283210)
Mar 10 14:56:05 ilfaris kernel: [  473.013401] Stack:
Mar 10 14:56:05 ilfaris kernel: [  473.018335]  ffff880117159800 0000000100000080 ffff8800a0aae180 ffff880103db7cf0
Mar 10 14:56:05 ilfaris kernel: [  473.023363]  00000000000075e0 ffffffff811d5863 000000000000f3a0 ffff880117159800
Mar 10 14:56:05 ilfaris kernel: [  473.028363]  ffff880116576840 000000000000f3a0 000675e000000004 000000000000f3a0
Mar 10 14:56:05 ilfaris kernel: [  473.033349] Call Trace:
Mar 10 14:56:05 ilfaris kernel: [  473.038283]  [<ffffffff811d5863>] ? xfs_dialloc+0x53/0x320
Mar 10 14:56:05 ilfaris kernel: [  473.043258]  [<ffffffff811d765f>] ? xfs_ialloc+0xcf/0x630
Mar 10 14:56:05 ilfaris kernel: [  473.048171]  [<ffffffff811e4cd5>] ? xfs_trans_add_item+0x25/0x70
Mar 10 14:56:05 ilfaris kernel: [  473.053071]  [<ffffffff811ed349>] ? _xfs_trans_bjoin+0x49/0x70
Mar 10 14:56:05 ilfaris kernel: [  473.057988]  [<ffffffff811a73a0>] ? xfs_dir_ialloc+0x230/0x2f0
Mar 10 14:56:05 ilfaris kernel: [  473.062902]  [<ffffffff811a87ae>] ? xfs_create+0x25e/0x520
Mar 10 14:56:05 ilfaris kernel: [  473.067804]  [<ffffffff8112216d>] ? __lookup_hash+0x1d/0x50
Mar 10 14:56:05 ilfaris kernel: [  473.072710]  [<ffffffff811a1966>] ? xfs_vn_mknod+0xa6/0x1a0
Mar 10 14:56:05 ilfaris kernel: [  473.077613]  [<ffffffff81125e6f>] ? vfs_mkdir+0x7f/0x100
Mar 10 14:56:05 ilfaris kernel: [  473.082513]  [<ffffffff811279b6>] ? sys_mkdirat+0x56/0xd0
Mar 10 14:56:05 ilfaris kernel: [  473.087418]  [<ffffffff813fd752>] ? system_call_fastpath+0x16/0x1b
Mar 10 14:56:05 ilfaris kernel: [  473.092342] Code: 08 49 83 c6 10 48 89 de ff d2 49 8b 16 48 85 d2 75 eb e9 6e ff ff ff 8b 74 24 50 48 89 df e8 da 94 03 00 85 c0 0f 85 9a fe ff ff <0f> 0b 41 57 48 8d 87 93 01 00 00 49 89 f7 41 56 41 89 d6 41 55 
Mar 10 14:56:05 ilfaris kernel: [  473.103145] RIP  [<ffffffff8119d38e>] xfs_iget+0x6be/0x6c0
Mar 10 14:56:05 ilfaris kernel: [  473.108277]  RSP <ffff880103db7c28>
Mar 10 14:56:05 ilfaris kernel: [  473.113401] ---[ end trace 5ee27f6cb3453335 ]---
Mar 10 15:08:20 ilfaris kernel: [ 1207.707090] BUG: unable to handle kernel paging request at 0000000000026f80
Mar 10 15:08:20 ilfaris kernel: [ 1207.712172] IP: [<ffffffff811d9143>] xfs_iflush_cluster+0x153/0x3e0
Mar 10 15:08:20 ilfaris kernel: [ 1207.717214] PGD a0183067 PUD a6f67067 PMD 0 
Mar 10 15:08:20 ilfaris kernel: [ 1207.722272] Oops: 0000 [#3] SMP 
Mar 10 15:08:20 ilfaris kernel: [ 1207.727283] Modules linked in: uvcvideo rtl8192ce rtlwifi mac80211 ohci_hcd ehci_pci ehci_hcd psmouse deflate zlib_deflate des_generic ecb sha512_generic sha1_generic hmac af_key xfrm_algo loop fuse btusb arc4 bluetooth crc16 snd_hda_codec_conexant radeon i2c_algo_bit drm_kms_helper snd_hda_codec_hdmi cfg80211 ttm snd_hda_intel drm videobuf2_vmalloc snd_hda_codec videobuf2_memops videobuf2_core snd_hwdep snd_pcm videodev snd_page_alloc agpgart thinkpad_acpi nvram acpi_cpufreq i2c_piix4 serio_raw rtl8192c_common snd_timer rfkill mperf pcspkr i2c_core k10temp evdev battery ac snd video wmi processor button soundcore sha256_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod sd_mod crc_t10dif rtsx_pci_sdmmc mmc_core microcode thermal thermal_sys ahci libahci rtsx_pci mfd_core usbcore usb_common libata scsi_mod [last unloaded: uvcvideo]
Mar 10 15:08:20 ilfaris kernel: [ 1207.760676] CPU 1 
Mar 10 15:08:20 ilfaris kernel: [ 1207.760724] Pid: 288, comm: xfsaild/dm-1 Tainted: G      D      3.9.0-rc1+ #1 LENOVO 30515YG/30515YG
Mar 10 15:08:20 ilfaris kernel: [ 1207.771023] RIP: 0010:[<ffffffff811d9143>]  [<ffffffff811d9143>] xfs_iflush_cluster+0x153/0x3e0
Mar 10 15:08:20 ilfaris kernel: [ 1207.776251] RSP: 0018:ffff8801195f9ce8  EFLAGS: 00010206
Mar 10 15:08:20 ilfaris kernel: [ 1207.781419] RAX: 0000000000026ef0 RBX: ffff8800a88cd600 RCX: 000000000000001d
Mar 10 15:08:20 ilfaris kernel: [ 1207.786586] RDX: 000000000000000e RSI: ffff8801195f9ca8 RDI: ffff8800a88cd6c4
Mar 10 15:08:20 ilfaris kernel: [ 1207.791719] RBP: ffff8801156d7080 R08: ffff88003773db80 R09: 0000000000000000
Mar 10 15:08:20 ilfaris kernel: [ 1207.796839] R10: 00000000000004bf R11: 0000000000000210 R12: 0000000000000038
Mar 10 15:08:20 ilfaris kernel: [ 1207.801943] R13: ffff8801196df000 R14: ffff8800a88cd6c4 R15: ffff8800a5a367c0
Mar 10 15:08:20 ilfaris kernel: [ 1207.807084] FS:  00007f5850b83700(0000) GS:ffff88011ed00000(0000) knlGS:0000000000000000
Mar 10 15:08:20 ilfaris kernel: [ 1207.812287] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 10 15:08:20 ilfaris kernel: [ 1207.817501] CR2: 0000000000026f80 CR3: 00000000a610b000 CR4: 00000000000007e0
Mar 10 15:08:20 ilfaris kernel: [ 1207.822721] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 10 15:08:20 ilfaris kernel: [ 1207.827884] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 10 15:08:20 ilfaris kernel: [ 1207.832982] Process xfsaild/dm-1 (pid: 288, threadinfo ffff8801195f8000, task ffff880119504d90)
Mar 10 15:08:20 ilfaris kernel: [ 1207.838173] Stack:
Mar 10 15:08:20 ilfaris kernel: [ 1207.843341]  ffff8801195f9d90 0000000000000100 00000000000002c0 ffffffffffffffe0
Mar 10 15:08:20 ilfaris kernel: [ 1207.848611]  ffff88011988c180 0000000081622f80 ffff88011a4c0380 ffffffff811d8fab
Mar 10 15:08:20 ilfaris kernel: [ 1207.853821]  0000000009316960 ffff8800a88cd600 ffff8800a88cd6c4 ffff8801196df000
Mar 10 15:08:20 ilfaris kernel: [ 1207.859012] Call Trace:
Mar 10 15:08:20 ilfaris kernel: [ 1207.864128]  [<ffffffff811d8fab>] ? xfs_iflush_int+0x2fb/0x340
Mar 10 15:08:20 ilfaris kernel: [ 1207.869290]  [<ffffffff811d94e2>] ? xfs_iflush+0x112/0x200
Mar 10 15:08:20 ilfaris kernel: [ 1207.874381]  [<ffffffff8105e4eb>] ? down_trylock+0x2b/0x40
Mar 10 15:08:20 ilfaris kernel: [ 1207.879444]  [<ffffffff8105e66d>] ? up+0xd/0x40
Mar 10 15:08:20 ilfaris kernel: [ 1207.884497]  [<ffffffff811ebf0b>] ? xfs_inode_item_push+0xdb/0x130
Mar 10 15:08:20 ilfaris kernel: [ 1207.889586]  [<ffffffff811ec8b7>] ? xfsaild+0x2b7/0x5c0
Mar 10 15:08:20 ilfaris kernel: [ 1207.894657]  [<ffffffff8106baac>] ? dequeue_task_fair+0xcc/0xf0
Mar 10 15:08:20 ilfaris kernel: [ 1207.899749]  [<ffffffff811ec600>] ? xfs_trans_ail_cursor_first+0x90/0x90
Mar 10 15:08:20 ilfaris kernel: [ 1207.904874]  [<ffffffff810598a3>] ? kthread+0xb3/0xc0
Mar 10 15:08:20 ilfaris kernel: [ 1207.909994]  [<ffffffff810597f0>] ? kthread_create_on_node+0x110/0x110
Mar 10 15:08:20 ilfaris kernel: [ 1207.915144]  [<ffffffff813fd6ac>] ? ret_from_fork+0x7c/0xb0
Mar 10 15:08:20 ilfaris kernel: [ 1207.920292]  [<ffffffff810597f0>] ? kthread_create_on_node+0x110/0x110
Mar 10 15:08:20 ilfaris kernel: [ 1207.925483] Code: 93 01 00 00 b8 01 00 00 00 48 d3 e0 ff c8 41 23 47 18 48 23 44 24 18 48 3b 44 24 10 75 b2 41 80 06 01 49 8b 47 78 48 85 c0 74 0c <f7> 80 90 00 00 00 ff 41 00 00 75 0b 41 8b 87 c0 00 00 00 85 c0 
Mar 10 15:08:20 ilfaris kernel: [ 1207.936618] RIP  [<ffffffff811d9143>] xfs_iflush_cluster+0x153/0x3e0
Mar 10 15:08:20 ilfaris kernel: [ 1207.941852]  RSP <ffff8801195f9ce8>
Mar 10 15:08:20 ilfaris kernel: [ 1207.947024] CR2: 0000000000026f80
Mar 10 15:08:20 ilfaris kernel: [ 1207.952262] ---[ end trace 5ee27f6cb3453336 ]---

Similar traces were already seen with a 3.7 kernel [1]. If you need
further information please do not hestitate to ask.


With best regards,
Julian Wollrath

[1] http://article.gmane.org/gmane.comp.file-systems.xfs.general/48998

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
