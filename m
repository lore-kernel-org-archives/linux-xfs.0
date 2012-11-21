Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALDG5Hx046708 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 07:16:05 -0600
Received: from mout.web.de (mout.web.de [212.227.17.12]) by cuda.sgi.com with
	ESMTP id Vl3vx1dPsaIrQOfU for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 05:18:15 -0800 (PST)
Received: from ilfaris ([193.170.62.226]) by smtp.web.de (mrweb003) with
	ESMTPSA (Nemesis) id 0MYevq-1Torau1ceo-00VLwZ for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 14:18:14 +0100
Date: Wed, 21 Nov 2012 14:18:11 +0100
From: Julian Wollrath <jwollrath@web.de>
Subject: Oops with to traces on v3.7-rc6
Message-ID: <20121121141811.665a1074@ilfaris>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

while doing a xfs_fsr or shortly after it I got the following to traces:
[12859.936850] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[12859.936952] IP: [<ffffffff811f2008>] xfs_trans_log_inode+0x8/0x30
[12859.937020] PGD 101efd067 PUD 1020ac067 PMD 0 
[12859.937075] Oops: 0000 [#1] SMP 
[12859.937113] Modules linked in: deflate zlib_deflate des_generic ecb sha512_generic sha1_generic hmac af_key xfrm_algo acpi_cpufreq mperf loop fuse snd_hda_codec_conexant snd_hda_codec_hdmi btusb bluetooth crc16 arc4 rtl8192ce rtlwifi rtl8192c_common snd_hda_intel snd_hda_codec rts_pstor(C) snd_hwdep thinkpad_acpi mac80211 snd_pcm uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core radeon snd_page_alloc videodev psmouse cfg80211 evdev nvram pcspkr snd_timer i2c_piix4 i2c_algo_bit drm_kms_helper serio_raw ttm drm agpgart k10temp snd i2c_core rfkill soundcore video ac processor wmi battery button sha256_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod sd_mod crc_t10dif microcode ohci_hcd thermal thermal_sys ahci libahci ehci_hcd atl1c usbcore libata scsi_mod usb_common
[12859.938008] CPU 0 
[12859.938035] Pid: 2977, comm: xfs_fsr Tainted: G         C   3.7.0-rc6-wl+ #1 LENOVO 30515YG/30515YG
[12859.938117] RIP: 0010:[<ffffffff811f2008>]  [<ffffffff811f2008>] xfs_trans_log_inode+0x8/0x30
[12859.938198] RSP: 0018:ffff88010667dc70  EFLAGS: 00010202
[12859.938248] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
[12859.938310] RDX: 0000000000000005 RSI: ffff8800c1df75c0 RDI: ffff88008427d298
[12859.938372] RBP: 0000000000000000 R08: ffffffff00000001 R09: 0000000000000000
[12859.938434] R10: ffffffff00000001 R11: ffff88008c075af8 R12: ffff8800c1df75c0
[12859.938496] R13: ffff880118b55800 R14: 0000000000000000 R15: 0000000000000000
[12859.938560] FS:  00007f171a0be700(0000) GS:ffff88011ec00000(0000) knlGS:0000000000000000
[12859.938632] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12859.938683] CR2: 0000000000000018 CR3: 00000001015cd000 CR4: 00000000000007f0
[12859.938745] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12859.938807] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12859.938870] Process xfs_fsr (pid: 2977, threadinfo ffff88010667c000, task ffff88008c09acd0)
[12859.938942] Stack:
[12859.938963]  ffffffff811c4ad1 ffff88010667dccc 0000000000000000 ffff88008427d298
[12859.939042]  0000000000000000 ffff8800c1df75f8 00000000000004f7 ffff88008427d298
[12859.939120]  0000000000000002 ffff88008477a4c0 0000000000000000 0000000500000005
[12859.939198] Call Trace:
[12859.939228]  [<ffffffff811c4ad1>] ? xfs_bunmapi+0x7e1/0xb70
[12859.939285]  [<ffffffff811dc943>] ? xfs_itruncate_extents+0xe3/0x2a0
[12859.939347]  [<ffffffff811adf60>] ? xfs_inactive+0x320/0x450
[12859.939404]  [<ffffffff811a94ca>] ? xfs_fs_evict_inode+0x2a/0xb0
[12859.939462]  [<ffffffff81136f62>] ? evict+0xa2/0x190
[12859.939513]  [<ffffffff81133550>] ? d_kill+0xe0/0x130
[12859.939563]  [<ffffffff81133bf9>] ? dput+0xd9/0x1b0
[12859.939611]  [<ffffffff81120a94>] ? __fput+0x154/0x230
[12859.939664]  [<ffffffff810569cf>] ? task_work_run+0x8f/0xd0
[12859.939719]  [<ffffffff814064da>] ? int_signal+0x12/0x17
[12859.939768] Code: 38 c3 90 48 3b 93 b0 01 00 00 75 cd eb e5 0f 1f 44 00 00 48 3b 93 a0 01 00 00 75 95 eb ad 0f 1f 44 00 00 83 4f 68 01 48 8b 46 78 <48> 8b 40 18 80 48 18 01 48 8b 4e 78 8b 81 90 00 00 00 0b 81 8c 
[12859.940124] RIP  [<ffffffff811f2008>] xfs_trans_log_inode+0x8/0x30
[12859.940189]  RSP <ffff88010667dc70>
[12859.940221] CR2: 0000000000000018
[12859.952669] ---[ end trace 57468864be84634a ]---
[12859.957347] ------------[ cut here ]------------
[12859.957416] kernel BUG at fs/xfs/xfs_iget.c:319!
[12859.957461] invalid opcode: 0000 [#2] SMP 
[12859.957507] Modules linked in: deflate zlib_deflate des_generic ecb sha512_generic sha1_generic hmac af_key xfrm_algo acpi_cpufreq mperf loop fuse snd_hda_codec_conexant snd_hda_codec_hdmi btusb bluetooth crc16 arc4 rtl8192ce rtlwifi rtl8192c_common snd_hda_intel snd_hda_codec rts_pstor(C) snd_hwdep thinkpad_acpi mac80211 snd_pcm uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core radeon snd_page_alloc videodev psmouse cfg80211 evdev nvram pcspkr snd_timer i2c_piix4 i2c_algo_bit drm_kms_helper serio_raw ttm drm agpgart k10temp snd i2c_core rfkill soundcore video ac processor wmi battery button sha256_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod sd_mod crc_t10dif microcode ohci_hcd thermal thermal_sys ahci libahci ehci_hcd atl1c usbcore libata scsi_mod usb_common
[12859.971640] CPU 0 
[12859.971667] Pid: 2980, comm: xfs_fsr Tainted: G      D  C   3.7.0-rc6-wl+ #1 LENOVO 30515YG/30515YG
[12859.977147] RIP: 0010:[<ffffffff811a22de>]  [<ffffffff811a22de>] xfs_iget+0x6ae/0x6b0
[12859.979841] RSP: 0018:ffff8801020c1c48  EFLAGS: 00010246
[12859.982461] RAX: 0000000000000000 RBX: ffff8800c1df7618 RCX: 0000000000000014
[12859.985008] RDX: ffffffff00000001 RSI: 0000000000000004 RDI: ffff8800c1df7698
[12859.987554] RBP: ffff88008427d6f8 R08: 0000000000000000 R09: ffff88004d24e5f0
[12859.990058] R10: 0000000000000004 R11: 0000000000004dc0 R12: 0000000000044dc0
[12859.992525] R13: ffff8801193f31d0 R14: 0000000000000011 R15: 0000000000000000
[12859.994981] FS:  00007f171a0be700(0000) GS:ffff88011ec00000(0000) knlGS:0000000000000000
[12859.997478] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12859.999973] CR2: 00007f1719992ab0 CR3: 00000001015cd000 CR4: 00000000000007f0
[12860.002491] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12860.005014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12860.007489] Process xfs_fsr (pid: 2980, threadinfo ffff8801020c0000, task ffff880068baa050)
[12860.009978] Stack:
[12860.012447]  ffff880119121000 0000000100020092 ffff88008427d6f8 ffff8801020c1d10
[12860.014991]  0000000000004dc0 ffffffff811dac33 000000000000f820 ffff880119121000
[12860.017570]  ffff8801193f3180 000000000000f820 00044dc000000004 000000000000f820
[12860.020134] Call Trace:
[12860.022684]  [<ffffffff811dac33>] ? xfs_dialloc+0x53/0x310
[12860.025211]  [<ffffffff811dc2ff>] ? xfs_ialloc+0xcf/0x630
[12860.027725]  [<ffffffff811e9215>] ? xfs_trans_add_item+0x25/0x70
[12860.030280]  [<ffffffff811f13e9>] ? _xfs_trans_bjoin+0x49/0x70
[12860.032784]  [<ffffffff811acca0>] ? xfs_dir_ialloc+0x230/0x2f0
[12860.035274]  [<ffffffff811ae400>] ? xfs_create+0x260/0x520
[12860.037771]  [<ffffffff811286e2>] ? __lookup_hash+0x32/0x50
[12860.040254]  [<ffffffff811a6276>] ? xfs_vn_mknod+0xa6/0x1a0
[12860.042733]  [<ffffffff8112c4ef>] ? vfs_mkdir+0x7f/0x100
[12860.045210]  [<ffffffff8112dfbe>] ? sys_mkdirat+0x3e/0x70
[12860.047696]  [<ffffffff81406252>] ? system_call_fastpath+0x16/0x1b
[12860.050222] Code: 08 49 83 c6 10 48 89 de ff d2 49 8b 16 48 85 d2 75 eb e9 6e ff ff ff 8b 74 24 50 48 89 df e8 1a f7 ff ff 85 c0 0f 85 a0 fe ff ff <0f> 0b 48 83 ec 28 40 f6 c6 04 48 89 6c 24 10 4c 89 64 24 18 89 
[12860.055685] RIP  [<ffffffff811a22de>] xfs_iget+0x6ae/0x6b0
[12860.058355]  RSP <ffff8801020c1c48>
[12860.061007] ---[ end trace 57468864be84634b ]---

I did a second xfs_fsr but the traces did not accure again, so maybe
the xfs_fsr was not their cause. Hopefully the traces are useful
nevertheless.

If you need further information, please feel free to ask.


With best regards,
Julian Wollrath

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
