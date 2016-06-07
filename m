Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4508B7CA0
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 12:04:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88F39AC004
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 10:04:18 -0700 (PDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com
	[74.125.82.68]) by cuda.sgi.com with ESMTP id eVLG9ytF7goVeaXZ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Jun 2016 10:04:13 -0700 (PDT)
Received: by mail-wm0-f68.google.com with SMTP id n184so25782547wmn.1
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2016 10:04:13 -0700 (PDT)
Received: from [192.168.2.44] (p57ACAF14.dip0.t-ipconnect.de. [87.172.175.20])
	by smtp.googlemail.com with ESMTPSA id
	zg2sm11447776wjb.1.2016.06.07.10.04.10 for <xfs@oss.sgi.com>
	(version=TLSv1/SSLv3 cipher=OTHER);
	Tue, 07 Jun 2016 10:04:11 -0700 (PDT)
From: Marian Beermann <public@enkore.de>
Subject: BUG null-pointer dereference on recovery of corrupted FS
Message-ID: <e302996f-89cf-1b43-bf37-bb8cd1214b6a@enkore.de>
Date: Tue, 7 Jun 2016 19:04:09 +0200
MIME-Version: 1.0
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

Hi everyone,

on a failing drive containing an XFS the following tracebacks occur when
XFS tries to recover. I'm afraid I can't provide more detailed
information, since the drive completely failed shortly thereafter and is
already disposed.

Linux 4.5.6 on x64.

Cheers,
Marian


[20947.408809] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ
0-10 PQ: 0 ANSI: 5
[20947.420009] sd 0:0:0:0: [sde] 976771055 512-byte logical blocks: (500
GB/466 GiB)
[20947.420185] sd 0:0:0:0: [sde] Write Protect is off
[20947.420190] sd 0:0:0:0: [sde] Mode Sense: 00 3a 00 00
[20947.420204] sd 0:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[20947.465053]  sde: sde1 sde2 sde3
[20947.465984] sd 0:0:0:0: [sde] Attached SCSI removable disk
[21043.651589] XFS (sde2): Mounting V5 Filesystem
[21043.746426] XFS (sde2): Starting recovery (logdev: internal)
[21061.815869] XFS (sde2): _xfs_buf_find: Block out of range: block
0x8031bfdf8, EOFS 0xc6ff800
[21061.815875] ------------[ cut here ]------------
[21061.815902] WARNING: CPU: 5 PID: 4731 at fs/xfs/xfs_buf.c:472
_xfs_buf_find+0x2cb/0x340 [xfs]()
[21061.815904] Modules linked in: joydev mousedev input_leds hid_generic
usbhid hid it87 hwmon_vid fuse eeepc_wmi asus_wmi sparse_keymap
led_class rfkill video evdev mxm_wmi mac_hid amdkfd amd_iommu_v2 kvm_amd
kvm radeon psmouse snd_hda_codec_hdmi serio_raw irqbypass pcspkr
k10temp snd_hda_intel e1000e edac_mce_amd snd_hda_codec ttm edac_core
ptp pps_core snd_ctxfi snd_hda_core drm_kms_helper sp5100_tco snd_hwdep
snd_pcm drm i2c_piix4 syscopyarea sysfillrect snd_timer snd sysimgblt
fb_sys_fops acpi_cpufreq soundcore i2c_algo_bit tpm_tis tpm fjes shpchp
wmi processor button sch_fq_codel vboxnetflt(O) vboxnetadp(O) pci_stub
vboxpci(O) vboxdrv(O) nfs lockd grace sunrpc fscache ip_tables x_tables
xfs crc32c_generic libcrc32c sd_mod atkbd libps2 ahci libahci ohci_pci
xhci_pci ohci_hcd ehci_pci libata xhci_hcd
[21061.815960]  ehci_hcd scsi_mod usbcore usb_common i8042 serio
[21061.815967] CPU: 5 PID: 4731 Comm: mount Tainted: G           O
4.5.6-1-ck #1
[21061.815969] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./M5A99X EVO, BIOS 1604 10/16/2012
[21061.815972]  0000000000000286 00000000cc91327e ffff880352eaf8f0
ffffffff812e4b22
[21061.815975]  0000000000000000 ffffffffa02a53d7 ffff880352eaf928
ffffffff8107e5a2
[21061.815979]  ffff880414f40240 0000000000000008 ffff880414f40240
ffff880352eafa18
[21061.815982] Call Trace:
[21061.815988]  [<ffffffff812e4b22>] dump_stack+0x63/0x81
[21061.815993]  [<ffffffff8107e5a2>] warn_slowpath_common+0x82/0xc0
[21061.815997]  [<ffffffff8107e6fa>] warn_slowpath_null+0x1a/0x20
[21061.816014]  [<ffffffffa0260f4b>] _xfs_buf_find+0x2cb/0x340 [xfs]
[21061.816031]  [<ffffffffa026112a>] xfs_buf_get_map+0x2a/0x1e0 [xfs]
[21061.816044]  [<ffffffffa021bbab>] ? xfs_free_ag_extent+0x28b/0x7c0 [xfs]
[21061.816058]  [<ffffffffa0291f81>] xfs_trans_get_buf_map+0x101/0x180 [xfs]
[21061.816073]  [<ffffffffa023609e>] xfs_btree_get_bufs+0x5e/0x80 [xfs]
[21061.816086]  [<ffffffffa021e158>] xfs_alloc_fix_freelist+0x238/0x400
[xfs]
[21061.816102]  [<ffffffffa0261281>] ? xfs_buf_get_map+0x181/0x1e0 [xfs]
[21061.816118]  [<ffffffffa02608a0>] ? xfs_buf_rele+0x40/0x1a0 [xfs]
[21061.816122]  [<ffffffff811c2b5c>] ? kmem_cache_alloc+0x1bc/0x1e0
[21061.816137]  [<ffffffffa0281138>] ? kmem_zone_alloc+0x78/0x120 [xfs]
[21061.816153]  [<ffffffffa0254531>] ? xfs_perag_get+0x51/0xe0 [xfs]
[21061.816166]  [<ffffffffa021eb96>] xfs_free_extent+0x96/0x140 [xfs]
[21061.816181]  [<ffffffffa0292c06>] xfs_trans_free_extent+0x26/0x60 [xfs]
[21061.816195]  [<ffffffffa028b0ee>]
xlog_recover_process_efi+0x14e/0x1a0 [xfs]
[21061.816210]  [<ffffffffa028d93b>]
xlog_recover_process_efis.isra.19+0x7b/0xe0 [xfs]
[21061.816224]  [<ffffffffa0290963>] xlog_recover_finish+0x23/0xc0 [xfs]
[21061.816237]  [<ffffffffa029cb23>] ? xfs_rtmount_inodes+0x63/0x120 [xfs]
[21061.816252]  [<ffffffffa02836e9>] xfs_log_mount_finish+0x29/0x60 [xfs]
[21061.816268]  [<ffffffffa027a014>] xfs_mountfs+0x594/0x860 [xfs]
[21061.816284]  [<ffffffffa027d7ef>] xfs_fs_fill_super+0x3af/0x4e0 [xfs]
[21061.816288]  [<ffffffff811e93bb>] mount_bdev+0x17b/0x1c0
[21061.816303]  [<ffffffffa027d440>] ? xfs_parseargs+0xa60/0xa60 [xfs]
[21061.816319]  [<ffffffffa027b715>] xfs_fs_mount+0x15/0x20 [xfs]
[21061.816322]  [<ffffffff811ea138>] mount_fs+0x38/0x160
[21061.816325]  [<ffffffff8120601a>] ? alloc_vfsmnt+0x19a/0x240
[21061.816329]  [<ffffffff81206120>] vfs_kern_mount+0x60/0x120
[21061.816332]  [<ffffffff81208a8e>] do_mount+0x24e/0xe20
[21061.816335]  [<ffffffff81206b64>] ? mntput+0x24/0x40
[21061.816338]  [<ffffffff811e7cdd>] ? __fput+0x13d/0x1e0
[21061.816341]  [<ffffffff811c57d1>] ? __kmalloc_track_caller+0x31/0x240
[21061.816344]  [<ffffffff8117dd42>] ? memdup_user+0x42/0x80
[21061.816348]  [<ffffffff81209998>] SyS_mount+0x98/0x100
[21061.816352]  [<ffffffff815d506e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[21061.816355] ---[ end trace b716ae71022f5e61 ]---
[21061.816359] XFS (sde2): _xfs_buf_find: Block out of range: block
0x8031bfdf8, EOFS 0xc6ff800
[21061.816361] ------------[ cut here ]------------
[21061.816378] WARNING: CPU: 5 PID: 4731 at fs/xfs/xfs_buf.c:472
_xfs_buf_find+0x2cb/0x340 [xfs]()
[21061.816380] Modules linked in: joydev mousedev input_leds hid_generic
usbhid hid it87 hwmon_vid fuse eeepc_wmi asus_wmi sparse_keymap
led_class rfkill video evdev mxm_wmi mac_hid amdkfd amd_iommu_v2 kvm_amd
kvm radeon psmouse snd_hda_codec_hdmi serio_raw irqbypass pcspkr
k10temp snd_hda_intel e1000e edac_mce_amd snd_hda_codec ttm edac_core
ptp pps_core snd_ctxfi snd_hda_core drm_kms_helper sp5100_tco snd_hwdep
snd_pcm drm i2c_piix4 syscopyarea sysfillrect snd_timer snd sysimgblt
fb_sys_fops acpi_cpufreq soundcore i2c_algo_bit tpm_tis tpm fjes shpchp
wmi processor button sch_fq_codel vboxnetflt(O) vboxnetadp(O) pci_stub
vboxpci(O) vboxdrv(O) nfs lockd grace sunrpc fscache ip_tables x_tables
xfs crc32c_generic libcrc32c sd_mod atkbd libps2 ahci libahci ohci_pci
xhci_pci ohci_hcd ehci_pci libata xhci_hcd
[21061.816421]  ehci_hcd scsi_mod usbcore usb_common i8042 serio
[21061.816425] CPU: 5 PID: 4731 Comm: mount Tainted: G        W  O
4.5.6-1-ck #1
[21061.816427] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./M5A99X EVO, BIOS 1604 10/16/2012
[21061.816429]  0000000000000286 00000000cc91327e ffff880352eaf8f0
ffffffff812e4b22
[21061.816432]  0000000000000000 ffffffffa02a53d7 ffff880352eaf928
ffffffff8107e5a2
[21061.816435]  ffff880414f40240 0000000000000008 ffff880414f40240
ffff880352eafa18
[21061.816437] Call Trace:
[21061.816440]  [<ffffffff812e4b22>] dump_stack+0x63/0x81
[21061.816444]  [<ffffffff8107e5a2>] warn_slowpath_common+0x82/0xc0
[21061.816447]  [<ffffffff8107e6fa>] warn_slowpath_null+0x1a/0x20
[21061.816464]  [<ffffffffa0260f4b>] _xfs_buf_find+0x2cb/0x340 [xfs]
[21061.816480]  [<ffffffffa0261254>] xfs_buf_get_map+0x154/0x1e0 [xfs]
[21061.816494]  [<ffffffffa0291f81>] xfs_trans_get_buf_map+0x101/0x180 [xfs]
[21061.816509]  [<ffffffffa023609e>] xfs_btree_get_bufs+0x5e/0x80 [xfs]
[21061.816522]  [<ffffffffa021e158>] xfs_alloc_fix_freelist+0x238/0x400
[xfs]
[21061.816538]  [<ffffffffa0261281>] ? xfs_buf_get_map+0x181/0x1e0 [xfs]
[21061.816554]  [<ffffffffa02608a0>] ? xfs_buf_rele+0x40/0x1a0 [xfs]
[21061.816557]  [<ffffffff811c2b5c>] ? kmem_cache_alloc+0x1bc/0x1e0
[21061.816572]  [<ffffffffa0281138>] ? kmem_zone_alloc+0x78/0x120 [xfs]
[21061.816588]  [<ffffffffa0254531>] ? xfs_perag_get+0x51/0xe0 [xfs]
[21061.816601]  [<ffffffffa021eb96>] xfs_free_extent+0x96/0x140 [xfs]
[21061.816616]  [<ffffffffa0292c06>] xfs_trans_free_extent+0x26/0x60 [xfs]
[21061.816630]  [<ffffffffa028b0ee>]
xlog_recover_process_efi+0x14e/0x1a0 [xfs]
[21061.816645]  [<ffffffffa028d93b>]
xlog_recover_process_efis.isra.19+0x7b/0xe0 [xfs]
[21061.816659]  [<ffffffffa0290963>] xlog_recover_finish+0x23/0xc0 [xfs]
[21061.816672]  [<ffffffffa029cb23>] ? xfs_rtmount_inodes+0x63/0x120 [xfs]
[21061.816687]  [<ffffffffa02836e9>] xfs_log_mount_finish+0x29/0x60 [xfs]
[21061.816703]  [<ffffffffa027a014>] xfs_mountfs+0x594/0x860 [xfs]
[21061.816719]  [<ffffffffa027d7ef>] xfs_fs_fill_super+0x3af/0x4e0 [xfs]
[21061.816722]  [<ffffffff811e93bb>] mount_bdev+0x17b/0x1c0
[21061.816737]  [<ffffffffa027d440>] ? xfs_parseargs+0xa60/0xa60 [xfs]
[21061.816753]  [<ffffffffa027b715>] xfs_fs_mount+0x15/0x20 [xfs]
[21061.816756]  [<ffffffff811ea138>] mount_fs+0x38/0x160
[21061.816759]  [<ffffffff8120601a>] ? alloc_vfsmnt+0x19a/0x240
[21061.816763]  [<ffffffff81206120>] vfs_kern_mount+0x60/0x120
[21061.816766]  [<ffffffff81208a8e>] do_mount+0x24e/0xe20
[21061.816769]  [<ffffffff81206b64>] ? mntput+0x24/0x40
[21061.816771]  [<ffffffff811e7cdd>] ? __fput+0x13d/0x1e0
[21061.816774]  [<ffffffff811c57d1>] ? __kmalloc_track_caller+0x31/0x240
[21061.816777]  [<ffffffff8117dd42>] ? memdup_user+0x42/0x80
[21061.816780]  [<ffffffff81209998>] SyS_mount+0x98/0x100
[21061.816783]  [<ffffffff815d506e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[21061.816824] ---[ end trace b716ae71022f5e62 ]---
[21061.816870] BUG: unable to handle kernel NULL pointer dereference at
00000000000000f8
[21061.817005] IP: [<ffffffffa02927f6>] xfs_trans_binval+0x16/0x120 [xfs]
[21061.817144] PGD 34426a067 PUD 32caab067 PMD 0
[21061.817227] Oops: 0000 [#1] PREEMPT SMP
[21061.817296] Modules linked in: joydev mousedev input_leds hid_generic
usbhid hid it87 hwmon_vid fuse eeepc_wmi asus_wmi sparse_keymap
led_class rfkill video evdev mxm_wmi mac_hid amdkfd amd_iommu_v2 kvm_amd
kvm radeon psmouse snd_hda_codec_hdmi serio_raw irqbypass pcspkr
k10temp snd_hda_intel e1000e edac_mce_amd snd_hda_codec ttm edac_core
ptp pps_core snd_ctxfi snd_hda_core drm_kms_helper sp5100_tco snd_hwdep
snd_pcm drm i2c_piix4 syscopyarea sysfillrect snd_timer snd sysimgblt
fb_sys_fops acpi_cpufreq soundcore i2c_algo_bit tpm_tis tpm fjes shpchp
wmi processor button sch_fq_codel vboxnetflt(O) vboxnetadp(O) pci_stub
vboxpci(O) vboxdrv(O) nfs lockd grace sunrpc fscache ip_tables x_tables
xfs crc32c_generic libcrc32c sd_mod atkbd libps2 ahci libahci ohci_pci
xhci_pci ohci_hcd ehci_pci libata xhci_hcd
[21061.818682]  ehci_hcd scsi_mod usbcore usb_common i8042 serio
[21061.818772] CPU: 0 PID: 4731 Comm: mount Tainted: G        W  O
4.5.6-1-ck #1
[21061.818880] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./M5A99X EVO, BIOS 1604 10/16/2012
[21061.819017] task: ffff8803e342e900 ti: ffff880352eac000 task.ti:
ffff880352eac000
[21061.819124] RIP: 0010:[<ffffffffa02927f6>]  [<ffffffffa02927f6>]
xfs_trans_binval+0x16/0x120 [xfs]
[21061.819283] RSP: 0018:ffff880352eafa10  EFLAGS: 00010246
[21061.819362] RAX: 0000000000000000 RBX: ffff8800c0bf6000 RCX:
0000000180150014
[21061.819496] RDX: 0000000180150015 RSI: 0000000000000000 RDI:
ffff8800c0bf6000
[21061.819598] RBP: ffff880352eafa30 R08: 0000000000000001 R09:
0000000000000000
[21061.819700] R10: ffff8803e116db00 R11: 0000000000000000 R12:
ffff8800c0bf6000
[21061.819802] R13: 0000000000000006 R14: 0000000000000000 R15:
ffff88041648d000
[21061.819906] FS:  00007fe6397a0780(0000) GS:ffff88042fc00000(0000)
knlGS:0000000000000000
[21061.820021] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[21061.820106] CR2: 00000000000000f8 CR3: 000000032e72f000 CR4:
00000000000006f0
[21061.820208] Stack:
[21061.820240]  ffff880352eafb28 ffff8800c0bf6000 0000000000000006
ffff8803e13bc9c0
[21061.820359]  ffff880352eafb10 ffffffffa021e163 ffff8802d913a480
0000000200000000
[21061.820508]  ffffffff00020001 ffff8802d913a480 0000000000000000
ffff880352eafaa8
[21061.820627] Call Trace:
[21061.820689]  [<ffffffffa021e163>] xfs_alloc_fix_freelist+0x243/0x400
[xfs]
[21061.820817]  [<ffffffffa0261281>] ? xfs_buf_get_map+0x181/0x1e0 [xfs]
[21061.820937]  [<ffffffffa02608a0>] ? xfs_buf_rele+0x40/0x1a0 [xfs]
[21061.821028]  [<ffffffff811c2b5c>] ? kmem_cache_alloc+0x1bc/0x1e0
[21061.821140]  [<ffffffffa0281138>] ? kmem_zone_alloc+0x78/0x120 [xfs]
[21061.821258]  [<ffffffffa0254531>] ? xfs_perag_get+0x51/0xe0 [xfs]
[21061.821369]  [<ffffffffa021eb96>] xfs_free_extent+0x96/0x140 [xfs]
[21061.821482]  [<ffffffffa0292c06>] xfs_trans_free_extent+0x26/0x60 [xfs]
[21061.821620]  [<ffffffffa028b0ee>]
xlog_recover_process_efi+0x14e/0x1a0 [xfs]
[21061.821746]  [<ffffffffa028d93b>]
xlog_recover_process_efis.isra.19+0x7b/0xe0 [xfs]
[21061.821879]  [<ffffffffa0290963>] xlog_recover_finish+0x23/0xc0 [xfs]
[21061.821994]  [<ffffffffa029cb23>] ? xfs_rtmount_inodes+0x63/0x120 [xfs]
[21061.822114]  [<ffffffffa02836e9>] xfs_log_mount_finish+0x29/0x60 [xfs]
[21061.822234]  [<ffffffffa027a014>] xfs_mountfs+0x594/0x860 [xfs]
[21061.822350]  [<ffffffffa027d7ef>] xfs_fs_fill_super+0x3af/0x4e0 [xfs]
[21061.822446]  [<ffffffff811e93bb>] mount_bdev+0x17b/0x1c0
[21061.822549]  [<ffffffffa027d440>] ? xfs_parseargs+0xa60/0xa60 [xfs]
[21061.822670]  [<ffffffffa027b715>] xfs_fs_mount+0x15/0x20 [xfs]
[21061.822758]  [<ffffffff811ea138>] mount_fs+0x38/0x160
[21061.822833]  [<ffffffff8120601a>] ? alloc_vfsmnt+0x19a/0x240
[21061.822919]  [<ffffffff81206120>] vfs_kern_mount+0x60/0x120
[21061.823003]  [<ffffffff81208a8e>] do_mount+0x24e/0xe20
[21061.823079]  [<ffffffff81206b64>] ? mntput+0x24/0x40
[21061.823153]  [<ffffffff811e7cdd>] ? __fput+0x13d/0x1e0
[21061.823229]  [<ffffffff811c57d1>] ? __kmalloc_track_caller+0x31/0x240
[21061.823325]  [<ffffffff8117dd42>] ? memdup_user+0x42/0x80
[21061.823407]  [<ffffffff81209998>] SyS_mount+0x98/0x100
[21061.823485]  [<ffffffff815d506e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[21061.823611] Code: e8 44 08 d7 e0 e9 50 ff ff ff 90 66 2e 0f 1f 84 00
00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 56 41 55 49 89 f6 41 54 53
48 89 fb <4c> 8b ae f8 00 00 00 0f 1f 44 00 00 41 f6 45 78 04 74 5d 5b 41
[21061.824122] RIP  [<ffffffffa02927f6>] xfs_trans_binval+0x16/0x120 [xfs]
[21061.824245]  RSP <ffff880352eafa10>
[21061.824296] CR2: 00000000000000f8
[21061.891732] ---[ end trace b716ae71022f5e63 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
