Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7G8W5l9228362 for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 03:32:06 -0500
Received: from emh07.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AED514BF1DC
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 01:32:32 -0700 (PDT)
Received: from emh07.mail.saunalahti.fi (emh07.mail.saunalahti.fi
	[62.142.5.117]) by cuda.sgi.com with ESMTP id CZaDkFHO9r6V26QF
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 01:32:32 -0700 (PDT)
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id A6B5818D480
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 11:32:31 +0300 (EEST)
Received: from ryoko (ryoko.zyrain.org [217.152.200.219])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 95B292BD4B
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 11:32:30 +0300 (EEST)
From: Arto Jantunen <viiru@debian.org>
Subject: Kernel BUG when running xfs_fsr with 2.6.35.1
Date: Mon, 16 Aug 2010 11:32:29 +0300
Message-ID: <878w47yn36.fsf@viiru.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--=-=-=


Hi List,

I had a kernel BUG yesterday when running xfs_fsr on my Debian Unstable
laptop. The kernel is upstream 2.6.35.1. I'm attaching the backtrace
below. I haven't tried reproducing the problem yet and don't know if it is
reproducible. I can try that, and test patches etc. if it is useful. Let me
know if there is any other information I can provide to help with debugging.

Please CC me on any replies, I'm not subscribed to the list.

-- 
Arto Jantunen


--=-=-=
Content-Disposition: inline; filename=backtrace
Content-Description: Backtrace

[18695.285232] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[18695.285245] IP: [<ffffffffa017f4f0>] xfs_trans_find_item+0x0/0x5 [xfs]
[18695.285290] PGD 24285067 PUD 2f6f0067 PMD 0 
[18695.285300] Oops: 0000 [#1] PREEMPT SMP 
[18695.285309] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input8/name
[18695.285316] CPU 1 
[18695.285319] Modules linked in: usbhid hid cryptd aes_x86_64 aes_generic ppdev lp sco acpi_cpufreq mperf cpufreq_userspace cpufreq_stats bnep cpufreq_powersave cpufreq_conservative rfcomm l2cap crc16 bluetooth uinput fuse loop snd_hda_codec_realtek arc4 ecb pcmcia snd_hda_intel i915 snd_hda_codec snd_hwdep drm_kms_helper iwl3945 drm iwlcore i2c_algo_bit tifm_7xx1 joydev tifm_core snd_pcm_oss snd_mixer_oss yenta_socket snd_pcm pcmcia_rsrc pcmcia_core snd_timer mac80211 snd i2c_i801 rng_core cfg80211 psmouse parport_pc parport i2c_core intel_agp tpm_tis tpm tpm_bios soundcore evdev serio_raw rfkill snd_page_alloc irda crc_ccitt container battery processor video output wmi ac button xfs exportfs sd_mod crc_t10dif ata_generic ata_piix libata firewire_ohci tg3 firewire_core uhci_hcd libphy crc_itu_t scsi_mod ehci_hcd thermal thermal_sys [last unloaded: scsi_wait_scan]
[18695.285464] 
[18695.285470] Pid: 4050, comm: xfs_fsr Not tainted 2.6.35.1 #1 Ness2           /TravelMate 3040 
[18695.285476] RIP: 0010:[<ffffffffa017f4f0>]  [<ffffffffa017f4f0>] xfs_trans_find_item+0x0/0x5 [xfs]
[18695.285512] RSP: 0018:ffff880035055c40  EFLAGS: 00010206
[18695.285517] RAX: 0000000000000000 RBX: ffff88003cda68d0 RCX: 0000000000000005
[18695.285522] RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff88003cda68d0
[18695.285528] RBP: ffff88000462f400 R08: ffff88003e6db300 R09: ffff880035055d18
[18695.285533] R10: 0000000000000000 R11: ffff88003d081800 R12: 0000000000000005
[18695.285539] R13: ffff88000462f438 R14: 0000000000000000 R15: 0000000000000000
[18695.285546] FS:  00007f232413d700(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
[18695.285552] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18695.285557] CR2: 0000000000000018 CR3: 000000000fc7d000 CR4: 00000000000006e0
[18695.285563] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18695.285569] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18695.285575] Process xfs_fsr (pid: 4050, threadinfo ffff880035054000, task ffff88002f562c10)
[18695.285580] Stack:
[18695.285583]  ffffffffa017f421 ffff88000462f400 0000000000000000 0000000000000000
[18695.285591] <0> ffffffffa0152a4a ffff880035055d58 0000000000000000 ffff880000000000
[18695.285601] <0> 0000000000000000 ffff880035055cf8 ffff880035055d18 ffff880000000000
[18695.285612] Call Trace:
[18695.285646]  [<ffffffffa017f421>] ? xfs_trans_log_inode+0x19/0x42 [xfs]
[18695.285679]  [<ffffffffa0152a4a>] ? xfs_bunmapi+0xb2a/0xb9e [xfs]
[18695.285693]  [<ffffffff8103497f>] ? get_parent_ip+0x9/0x1b
[18695.285730]  [<ffffffffa016b57a>] ? xfs_itruncate_finish+0x1b8/0x329 [xfs]
[18695.285764]  [<ffffffffa01821c5>] ? xfs_inactive+0x1e1/0x402 [xfs]
[18695.285772]  [<ffffffff8103497f>] ? get_parent_ip+0x9/0x1b
[18695.285785]  [<ffffffff810eaf9f>] ? clear_inode+0x58/0xaf
[18695.285792]  [<ffffffff810eb4f3>] ? generic_delete_inode+0xa4/0x110
[18695.285801]  [<ffffffff810e7b25>] ? d_kill+0x42/0x61
[18695.285808]  [<ffffffff810e8295>] ? dput+0x149/0x156
[18695.285815]  [<ffffffff810da2a9>] ? fput+0x17b/0x1a4
[18695.285824]  [<ffffffff810d7941>] ? filp_close+0x5f/0x6a
[18695.285831]  [<ffffffff810d79ee>] ? sys_close+0xa2/0xdb
[18695.285840]  [<ffffffff81002a82>] ? system_call_fastpath+0x16/0x1b
[18695.285845] Code: 9d fe ff 85 c0 75 1b 48 85 ed 74 16 89 44 24 08 44 89 e2 48 8b 33 48 89 ef e8 67 ff ff ff 8b 44 24 08 5a 59 5b 5d 41 5c c3 90 90 <48> 8b 46 18 c3 44 8a 46 0b bf 01 00 00 00 41 0f b6 c0 45 0f b6 
[18695.285930] RIP  [<ffffffffa017f4f0>] xfs_trans_find_item+0x0/0x5 [xfs]
[18695.285963]  RSP <ffff880035055c40>
[18695.285966] CR2: 0000000000000018
[18695.285973] ---[ end trace 95a1de083b2b773e ]---
[18696.225289] ------------[ cut here ]------------
[18696.225300] kernel BUG at fs/xfs/xfs_iget.c:301!
[18696.225306] invalid opcode: 0000 [#2] PREEMPT SMP 
[18696.225315] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input8/name
[18696.225320] CPU 1 
[18696.225323] Modules linked in: usbhid hid cryptd aes_x86_64 aes_generic ppdev lp sco acpi_cpufreq mperf cpufreq_userspace cpufreq_stats bnep cpufreq_powersave cpufreq_conservative rfcomm l2cap crc16 bluetooth uinput fuse loop snd_hda_codec_realtek arc4 ecb pcmcia snd_hda_intel i915 snd_hda_codec snd_hwdep drm_kms_helper iwl3945 drm iwlcore i2c_algo_bit tifm_7xx1 joydev tifm_core snd_pcm_oss snd_mixer_oss yenta_socket snd_pcm pcmcia_rsrc pcmcia_core snd_timer mac80211 snd i2c_i801 rng_core cfg80211 psmouse parport_pc parport i2c_core intel_agp tpm_tis tpm tpm_bios soundcore evdev serio_raw rfkill snd_page_alloc irda crc_ccitt container battery processor video output wmi ac button xfs exportfs sd_mod crc_t10dif ata_generic ata_piix libata firewire_ohci tg3 firewire_core uhci_hcd libphy crc_itu_t scsi_mod ehci_hcd thermal thermal_sys [last unloaded: scsi_wait_scan]
[18696.225469] 
[18696.225476] Pid: 2284, comm: plasma-desktop Tainted: G      D     2.6.35.1 #1 Ness2           /TravelMate 3040 
[18696.225482] RIP: 0010:[<ffffffffa016962c>]  [<ffffffffa016962c>] xfs_iget+0x3e3/0x593 [xfs]
[18696.225527] RSP: 0018:ffff88003069b9f8  EFLAGS: 00010246
[18696.225532] RAX: 0000000000000000 RBX: ffff88003d081800 RCX: ffffc900102ae8d0
[18696.225537] RDX: ffffffff00000001 RSI: 0000000000000004 RDI: ffff88000462f4e0
[18696.225543] RBP: 0000000000000004 R08: ffffc900102ae8e0 R09: 0000000000000000
[18696.225549] R10: ffff88003d081800 R11: 0000000000000250 R12: ffff88000462f458
[18696.225554] R13: ffff88003d67af0c R14: ffff88003d67aec0 R15: 00000000000140c0
[18696.225561] FS:  00007f2005eac780(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
[18696.225567] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18696.225573] CR2: 00007f2002dbd300 CR3: 00000000307a1000 CR4: 00000000000006e0
[18696.225578] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18696.225584] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18696.225590] Process plasma-desktop (pid: 2284, threadinfo ffff88003069a000, task ffff8800305d71e0)
[18696.225595] Stack:
[18696.225599]  ffff880000000000 0000000000000002 ffff88002437cb19 000000000424fe22
[18696.225608] <0> 0000001900000000 ffff88003d67af10 0424fe2200000002 0000000100000001
[18696.225619] <0> ffff88003069a000 ffff88002437cb30 ffff88003069bb18 000000000024fe22
[18696.225631] Call Trace:
[18696.225668]  [<ffffffffa017f4c8>] ? xfs_trans_iget+0x16/0x3e [xfs]
[18696.225707]  [<ffffffffa016b953>] ? xfs_ialloc+0xaf/0x53f [xfs]
[18696.225742]  [<ffffffffa0183e34>] ? kmem_zone_alloc+0x58/0x9c [xfs]
[18696.225777]  [<ffffffffa017fcd1>] ? xfs_dir_ialloc+0xa0/0x273 [xfs]
[18696.225814]  [<ffffffffa017dd7e>] ? xfs_trans_reserve+0xc9/0x195 [xfs]
[18696.225849]  [<ffffffffa018164e>] ? xfs_create+0x2f9/0x572 [xfs]
[18696.225882]  [<ffffffffa018c02f>] ? xfs_vn_mknod+0xcc/0x168 [xfs]
[18696.225895]  [<ffffffff810e1b86>] ? vfs_create+0x66/0x88
[18696.225906]  [<ffffffff81035b1a>] ? sub_preempt_count+0x83/0x94
[18696.225914]  [<ffffffff810e278e>] ? do_last+0x290/0x55f
[18696.225923]  [<ffffffff810e4285>] ? do_filp_open+0x1ee/0x5c8
[18696.225933]  [<ffffffff8103497f>] ? get_parent_ip+0x9/0x1b
[18696.225942]  [<ffffffff812f538b>] ? _raw_spin_unlock+0x25/0x33
[18696.225952]  [<ffffffff810ecb05>] ? alloc_fd+0x110/0x122
[18696.225962]  [<ffffffff810d7a7d>] ? do_sys_open+0x56/0xf9
[18696.225972]  [<ffffffff81002a82>] ? system_call_fastpath+0x16/0x1b
[18696.225978] Code: 00 0f 84 28 01 00 00 bf d0 00 00 00 e8 d0 f1 00 e1 85 c0 0f 85 11 01 00 00 85 ed 74 12 89 ee 4c 89 e7 e8 2c f7 ff ff 85 c0 75 04 <0f> 0b eb fe 4c 89 ef e8 61 ba 18 e1 8a 4c 24 10 be 01 00 00 00 
[18696.226060] RIP  [<ffffffffa016962c>] xfs_iget+0x3e3/0x593 [xfs]
[18696.226095]  RSP <ffff88003069b9f8>
[18696.226101] ---[ end trace 95a1de083b2b773f ]---
[18696.226109] note: plasma-desktop[2284] exited with preempt_count 1

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--
