Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6DVSZq017830 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 07:31:29 -0600
Received: from mail.octant.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2D561BF0F3E
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 05:31:26 -0800 (PST)
Received: from mail.octant.org (saturne.octant-fr.com [91.121.100.211]) by
	cuda.sgi.com with ESMTP id HYxj6ncqX4qkTqT5 for
	<xfs@oss.sgi.com>; Sat, 06 Dec 2008 05:31:26 -0800 (PST)
Message-ID: <493A7EAB.4010200@octant.org>
Date: Sat, 06 Dec 2008 14:31:23 +0100
From: Tobias Oed <tobias.oed@octant.org>
MIME-Version: 1.0
Subject: Does this come from xfs?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Tobias Oed <tobias.oed@octant.org>

Hi,
We have a few mandriva servers running kernel 2.6.22.12-server-1mdv on
dell poweredge 2800 that oops every now and then. Networking is still
alive, but the disk seems to become unavailable.
We are using XFS on regular partitions (no lvm etc.) on a single block
device sda, backed by hardware raid on PERC 4e (most machines have raid
1, one has raid 5). So far we have no repeatable way to crash the
machines. We are not sure what to blame, even after capturing this with
netconsole. Any help in parsing this is apreciated!
Thanks
Tobias Oed

Dec  4 12:36:59 master BUG: unable to handle kernel NULL pointer dereference
Dec  4 12:36:59 master  at virtual address 00000368
Dec  4 12:36:59 master  printing eip:
Dec  4 12:36:59 master f8e62a1e
Dec  4 12:36:59 master BUG: unable to handle kernel NULL pointer
dereference at virtual address 00000324
Dec  4 12:36:59 master  printing eip:
Dec  4 12:36:59 master f8e62c4e
Dec  4 12:36:59 master *pdpt =3D 000000001a842001
Dec  4 12:36:59 master *pde =3D 0000000000000000
Dec  4 12:36:59 master Oops: 0000 [#1]
Dec  4 12:36:59 master SMP
Dec  4 12:36:59 master Modules linked in: netconsole smbfs nls_iso8859_1
cifs tun af_packet ipv6 video thermal sbs processor fan container button
dock battery ac binfmt_misc loop nls_utf8 nls_cp437 vfat fat dm_mirror
dm_mod ide_cd piix usb_storage ide_core st aic7xxx scsi_transport_spi
tsdev usbmouse usbhid ff_memless floppy cpufreq_ondemand
cpufreq_conservative cpufreq_powersave p4_clockmod speedstep_lib
freq_table ehci_hcd iTCO_wdt iTCO_vendor_support e1000 e752x_edac
uhci_hcd edac_mc usbcore shpchp pci_hotplug evdev sg xfs scsi_wait_scan
sd_mod megaraid_mbox megaraid_mm scsi_mod
Dec  4 12:36:59 master CPU:    0
Dec  4 12:36:59 master EIP:    0060:[<f8e62c4e>]    Not tainted VLI
Dec  4 12:36:59 master EFLAGS: 00210246   (2.6.22.12-server-1mdv #1)
Dec  4 12:36:59 master EIP is at xfs_trans_dup+0x8e/0xb0 [xfs]
Dec  4 12:36:59 master eax: 00000000   ebx: e27502ac   ecx: 00000000
edx: 00000000
Dec  4 12:36:59 master esi: e27502ac   edi: e27502ac   ebp: dd35be48
esp: dd35be40
Dec  4 12:36:59 master ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Dec  4 12:36:59 master Process nmbd (pid: 15310, ti=3Ddd35a000
task=3De8622030 task.ti=3Ddd35a000)
Dec  4 12:36:59 master Stack: 00000000 e27502ac dd35bebc f8e4ce49
00000006 00000000 fffffffb 00000000
Dec  4 12:36:59 master        00000040 00000002 dd35bea0 dd35be94
00000000 dd35beac cbb34c80 dd35bf28
Dec  4 12:36:59 master        00000006 00000000 fffffffb 00000000
f785bc00 00000000 00000000 00000000
Dec  4 12:36:59 master Call Trace:
Dec  4 12:36:59 master  [<c010527a>] show_trace_log_lvl+0x1a/0x30
Dec  4 12:36:59 master  [<c010533b>] show_stack_log_lvl+0xab/0xd0
Dec  4 12:36:59 master  [<c0105531>] show_registers+0x1d1/0x2d0
Dec  4 12:36:59 master  [<c0105748>] die+0x118/0x240
Dec  4 12:36:59 master  [<c0121cb1>] do_page_fault+0x1e1/0x870
Dec  4 12:36:59 master  [<c031847a>] error_code+0x72/0x78
Dec  4 12:36:59 master  [<f8e4ce49>] xfs_itruncate_finish+0x129/0x3a0 [xfs]
Dec  4 12:36:59 master  [<f8e68c94>]
xfs_inactive_free_eofblocks+0x244/0x280 [xfs]
Dec  4 12:36:59 master  [<f8e6b930>] xfs_release+0x90/0x100 [xfs]
Dec  4 12:36:59 master  [<f8e74b56>] xfs_file_release+0x16/0x20 [xfs]
Dec  4 12:36:59 master  [<c01866a1>] __fput+0xa1/0x170
Dec  4 12:36:59 master  [<c01867d9>] fput+0x19/0x20
Dec  4 12:36:59 master  [<c0183c87>] filp_close+0x47/0x70
Dec  4 12:36:59 master  [<c0184ea3>] sys_close+0x63/0xb0
Dec  4 12:36:59 master  [<c01041a2>] sysenter_past_esp+0x6b/0xa1
Dec  4 12:36:59 master  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Dec  4 12:36:59 master Code: 89 43 2c 8b 46 1c 29 d0 89 43 1c 8b 46 24
89 56 1c 8b 56 28 29 d0 89 43 24 8b 86 74 02 00 00 89 56 24 89 83 74 02
00 00 8b 46 54 <8b> 88 24 03 00 00 85 c9 74 06 89 da 89 f0 ff 11 8b 46
54 05 68
Dec  4 12:36:59 master EIP: [<f8e62c4e>] xfs_trans_dup+0x8e/0xb0 [xfs]
SS:ESP 0068:dd35be40
Dec  4 12:36:59 master *pdpt =3D 000000000f518001
Dec  4 12:37:00 master *pde =3D 0000000000000000
Dec  4 12:37:00 master Oops: 0002 [#2]
Dec  4 12:37:00 master SMP
Dec  4 12:37:00 master Modules linked in:
Dec  4 12:37:00 master  netconsole smbfs nls_iso8859_1 cifs tun
af_packet ipv6 video thermal sbs processor fan container button dock
battery ac binfmt_misc loop nls_utf8 nls_cp437 vfat fat dm_mirror dm_mod
ide_cd piix usb_storage ide_core st aic7xxx scsi_transport_spi tsdev
usbmouse usbhid ff_memless floppy cpufreq_ondemand cpufreq_conservative
cpufreq_powersave p4_clockmod speedstep_lib freq_table ehci_hcd iTCO_wdt
iTCO_vendor_support e1000 e752x_edac uhci_hcd edac_mc usbcore shpchp
pci_hotplug evdev sg xfs scsi_wait_scan sd_mod megaraid_mbox megaraid_mm
scsi_mod
Dec  4 12:37:00 master CPU:    1
Dec  4 12:37:00 master EIP:    0060:[<f8e62a1e>]    Not tainted VLI
Dec  4 12:37:00 master EFLAGS: 00010202   (2.6.22.12-server-1mdv #1)
Dec  4 12:37:00 master EIP is at xfs_trans_free+0xe/0x40 [xfs]
Dec  4 12:37:00 master eax: 00000368   ebx: e27502ac   ecx: f8e8ec00
edx: e27502ac
Dec  4 12:37:00 master esi: 00000000   edi: 00000000   ebp: c21a5eb4
esp: c21a5eb0
Dec  4 12:37:00 master ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Dec  4 12:37:00 master Process xfslogd/1 (pid: 858, ti=3Dc21a4000
task=3Df7fc6a90 task.ti=3Dc21a4000)
Dec  4 12:37:00 master Stack: 00000000 c21a5ed0 f8e631ba 00000000
e27502ac e27502b0 c21fb4e8 00000024
Dec  4 12:37:00 master        c21a5f2c f8e55bdb 0000002d 0000002d
00000000 00000800 00000000 c22e9c60
Dec  4 12:37:00 master        c21fb4c0 00000000 c22e9bc0 c22e9bf4
c21fb4c0 c21fb740 00000000 0003c876
Dec  4 12:37:00 master Call Trace:
Dec  4 12:37:00 master  [<c010527a>] show_trace_log_lvl+0x1a/0x30
Dec  4 12:37:00 master  [<c010533b>] show_stack_log_lvl+0xab/0xd0
Dec  4 12:37:00 master  [<c0105531>] show_registers+0x1d1/0x2d0
Dec  4 12:37:00 master  [<c0105748>] die+0x118/0x240
Dec  4 12:37:00 master  [<c0121cb1>] do_page_fault+0x1e1/0x870
Dec  4 12:37:00 master  [<c031847a>] error_code+0x72/0x78
Dec  4 12:37:00 master  [<f8e631ba>] xfs_trans_committed+0xca/0xf0 [xfs]
Dec  4 12:37:00 master  [<f8e55bdb>] xlog_state_do_callback+0x1ab/0x280
[xfs]
Dec  4 12:37:00 master  [<f8e55d13>] xlog_state_done_syncing+0x63/0x80
[xfs]
Dec  4 12:37:00 master  [<f8e56505>] xlog_iodone+0x45/0xd0 [xfs]
Dec  4 12:37:00 master  [<f8e736a2>] xfs_buf_iodone_work+0x12/0x40 [xfs]
Dec  4 12:37:00 master  [<c013c2f2>] run_workqueue+0xd2/0x160
Dec  4 12:37:00 master  [<c013cdfc>] worker_thread+0x8c/0xf0
Dec  4 12:37:00 master  [<c013fc82>] kthread+0x42/0x70
Dec  4 12:37:00 master  [<c0104e53>] kernel_thread_helper+0x7/0x14
Dec  4 12:37:00 master  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Dec  4 12:37:00 master Code: 00 00 00 8b 83 d0 00 00 00 8b 93 d4 00 00
00 89 41 04 89 51 08 83 c1 0c eb b3 8d 76 00 55 89 e5 53 89 c3 8b 40 54
05 68 03 00 00 <f0> ff 08 8b 43 54 8b 90 24 03 00 00 85 d2 74 05 89 d8
ff 52 04
Dec  4 12:37:00 master EIP: [<f8e62a1e>] xfs_trans_free+0xe/0x40 [xfs]
SS:ESP 0068:c21a5eb0
Dec  4 12:56:26 master ------------[ cut here ]------------
Dec  4 12:56:26 master Kernel BUG at c0181cf7 [verbose debug info
unavailable]
Dec  4 12:56:26 master invalid opcode: 0000 [#3]
Dec  4 12:56:26 master SMP
Dec  4 12:56:26 master
Dec  4 12:56:26 master Modules linked in:
Dec  4 12:56:26 master  netconsole
Dec  4 12:56:26 master  smbfs
Dec  4 12:56:26 master  nls_iso8859_1
Dec  4 12:56:26 master  cifs
Dec  4 12:56:26 master  tun
Dec  4 12:56:26 master  af_packet
Dec  4 12:56:26 master  ipv6
Dec  4 12:56:26 master  video
Dec  4 12:56:26 master  thermal
Dec  4 12:56:26 master  sbs
Dec  4 12:56:26 master  processor
Dec  4 12:56:26 master  fan
Dec  4 12:56:26 master  container
Dec  4 12:56:26 master  button
Dec  4 12:56:26 master  dock
Dec  4 12:56:26 master  battery
Dec  4 12:56:26 master  ac
Dec  4 12:56:26 master  binfmt_misc
Dec  4 12:56:26 master  loop
Dec  4 12:56:26 master  nls_utf8
Dec  4 12:56:26 master  nls_cp437
Dec  4 12:56:26 master  vfat
Dec  4 12:56:26 master  fat
Dec  4 12:56:26 master  dm_mirror
Dec  4 12:56:26 master  dm_mod
Dec  4 12:56:26 master  ide_cd
Dec  4 12:56:26 master  piix
Dec  4 12:56:26 master  usb_storage
Dec  4 12:56:26 master  ide_core
Dec  4 12:56:26 master  st
Dec  4 12:56:26 master  aic7xxx
Dec  4 12:56:26 master  scsi_transport_spi
Dec  4 12:56:26 master  tsdev
Dec  4 12:56:26 master  usbmouse
Dec  4 12:56:26 master  usbhid
Dec  4 12:56:26 master  ff_memless
Dec  4 12:56:26 master  floppy
Dec  4 12:56:26 master  cpufreq_ondemand
Dec  4 12:56:26 master  cpufreq_conservative
Dec  4 12:56:26 master  cpufreq_powersave
Dec  4 12:56:26 master  p4_clockmod
Dec  4 12:56:26 master  speedstep_lib
Dec  4 12:56:26 master  freq_table
Dec  4 12:56:26 master  ehci_hcd
Dec  4 12:56:26 master  iTCO_wdt
Dec  4 12:56:26 master  iTCO_vendor_support
Dec  4 12:56:26 master  e1000
Dec  4 12:56:26 master  e752x_edac
Dec  4 12:56:26 master  uhci_hcd
Dec  4 12:56:26 master  edac_mc
Dec  4 12:56:26 master  usbcore
Dec  4 12:56:26 master  shpchp
Dec  4 12:56:26 master  pci_hotplug
Dec  4 12:56:26 master  evdev
Dec  4 12:56:26 master  sg
Dec  4 12:56:26 master  xfs
Dec  4 12:56:26 master  scsi_wait_scan
Dec  4 12:56:26 master  sd_mod
Dec  4 12:56:26 master  megaraid_mbox
Dec  4 12:56:26 master  megaraid_mm
Dec  4 12:56:26 master  scsi_mod
Dec  4 12:56:26 master
Dec  4 12:56:26 master CPU:    1
Dec  4 12:56:26 master EIP:    0060:[<c0181cf7>]    Not tainted VLI
Dec  4 12:56:26 master EFLAGS: 00010096   (2.6.22.12-server-1mdv #1)
Dec  4 12:56:26 master EIP is at cache_alloc_refill+0x1d7/0x560
Dec  4 12:56:26 master eax: 00000006   ebx: 00000010   ecx: f747f840
edx: f7a0a2c0
Dec  4 12:56:26 master esi: ffb2a005   edi: e2750000   ebp: d67edd5c
esp: d67edd0c
Dec  4 12:56:26 master ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Dec  4 12:56:26 master Process readarkeia (pid: 32292, ti=3Dd67ec000
task=3Dd49e3030 task.ti=3Dd67ec000)
Dec  4 12:56:26 master
Dec  4 12:56:26 master Stack:
Dec  4 12:56:26 master 000002d0
Dec  4 12:56:26 master 00000000
Dec  4 12:56:26 master f747f848
Dec  4 12:56:26 master f747f850
Dec  4 12:56:26 master f8e7c599
Dec  4 12:56:26 master 000002d0
Dec  4 12:56:26 master f7a0a2c0
Dec  4 12:56:26 master f7fb5c00
Dec  4 12:56:26 master
Dec  4 12:56:26 master
Dec  4 12:56:26 master f747f840
Dec  4 12:56:26 master c21834c0
Dec  4 12:56:26 master 98118557
Dec  4 12:56:26 master 00000000
Dec  4 12:56:26 master 00000000
Dec  4 12:56:26 master f13bc380
Dec  4 12:56:26 master 00000000
Dec  4 12:56:26 master 00000000
Dec  4 12:56:26 master
Dec  4 12:56:26 master
Dec  4 12:56:26 master 00000000
Dec  4 12:56:26 master 00000282
Dec  4 12:56:26 master f7a0a2c0
Dec  4 12:56:26 master 00000000
Dec  4 12:56:26 master d67edd6c
Dec  4 12:56:26 master c0181b1a
Dec  4 12:56:26 master 00000000
Dec  4 12:56:26 master 000002d0
Dec  4 12:56:26 master
Dec  4 12:56:26 master Call Trace:
Dec  4 12:56:26 master  [<c010527a>]
Dec  4 12:56:26 master show_trace_log_lvl+0x1a/0x30
Dec  4 12:56:26 master  [<c010533b>]
Dec  4 12:56:26 master show_stack_log_lvl+0xab/0xd0
Dec  4 12:56:26 master  [<c0105531>]
Dec  4 12:56:26 master show_registers+0x1d1/0x2d0
Dec  4 12:56:26 master  [<c0105748>]
Dec  4 12:56:26 master die+0x118/0x240
Dec  4 12:56:26 master  [<c0105901>]
Dec  4 12:56:26 master do_trap+0x91/0xc0
Dec  4 12:56:26 master  [<c0105cb8>]
Dec  4 12:56:26 master do_invalid_op+0x88/0xa0
Dec  4 12:56:26 master  [<c031847a>]
Dec  4 12:56:26 master error_code+0x72/0x78
Dec  4 12:56:26 master  [<c0181b1a>]
Dec  4 12:56:26 master kmem_cache_alloc+0x6a/0x70
Dec  4 12:56:26 master  [<f8e6ff25>]
Dec  4 12:56:26 master kmem_zone_alloc+0x55/0xc0 [xfs]
Dec  4 12:56:26 master  [<f8e6ffa8>]
Dec  4 12:56:26 master kmem_zone_zalloc+0x18/0x60 [xfs]
Dec  4 12:56:26 master  [<f8e62c97>]
Dec  4 12:56:26 master _xfs_trans_alloc+0x27/0x70 [xfs]
Dec  4 12:56:26 master  [<f8e63261>]
Dec  4 12:56:26 master xfs_trans_alloc+0x81/0x90 [xfs]
Dec  4 12:56:26 master  [<f8e6c9fc>]
Dec  4 12:56:26 master xfs_mkdir+0x1ac/0x630 [xfs]
Dec  4 12:56:26 master  [<f8e778e6>]
Dec  4 12:56:26 master xfs_vn_mknod+0x246/0x320 [xfs]
Dec  4 12:56:26 master  [<f8e779d5>]
Dec  4 12:56:26 master xfs_vn_mkdir+0x15/0x20 [xfs]
Dec  4 12:56:26 master  [<c018d306>]
Dec  4 12:56:26 master vfs_mkdir+0xc6/0x150
Dec  4 12:56:26 master  [<c018ffff>]
Dec  4 12:56:26 master sys_mkdirat+0x8f/0xd0
Dec  4 12:56:26 master  [<c0190060>]
Dec  4 12:56:26 master sys_mkdir+0x20/0x30
Dec  4 12:56:26 master  [<c01041a2>]
Dec  4 12:56:26 master sysenter_past_esp+0x6b/0xa1
Dec  4 12:56:26 master  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Dec  4 12:56:26 master Code:
Dec  4 12:56:26 master 83
Dec  4 12:56:26 master c4
Dec  4 12:56:26 master 44
Dec  4 12:56:26 master 5b
Dec  4 12:56:26 master 5e
Dec  4 12:56:26 master 5f
Dec  4 12:56:26 master 5d
Dec  4 12:56:26 master c3
Dec  4 12:56:26 master 8b
Dec  4 12:56:26 master 79
Dec  4 12:56:26 master 10
Dec  4 12:56:26 master c7
Dec  4 12:56:26 master 41
Dec  4 12:56:26 master 34
Dec  4 12:56:26 master 01
Dec  4 12:56:26 master 00
Dec  4 12:56:26 master last message repeated 2 times
Dec  4 12:56:26 master 39
Dec  4 12:56:26 master 7d
Dec  4 12:56:26 master bc
Dec  4 12:56:26 master 74
Dec  4 12:56:26 master ae
Dec  4 12:56:26 master 8b
Dec  4 12:56:26 master 55
Dec  4 12:56:26 master c8
Dec  4 12:56:26 master 8b
Dec  4 12:56:26 master 77
Dec  4 12:56:26 master 10
Dec  4 12:56:26 master 8b
Dec  4 12:56:26 master 82
Dec  4 12:56:26 master 98
Dec  4 12:56:26 master 00
Dec  4 12:56:26 master last message repeated 2 times
Dec  4 12:56:26 master 39
Dec  4 12:56:26 master c6
Dec  4 12:56:26 master 0f
Dec  4 12:56:26 master 82
Dec  4 12:56:26 master 05
Dec  4 12:56:26 master ff
Dec  4 12:56:26 master last message repeated 2 times
Dec  4 12:56:26 master 0b
Dec  4 12:56:26 master eb
Dec  4 12:56:26 master fe
Dec  4 12:56:26 master 90
Dec  4 12:56:26 master 8d
Dec  4 12:56:26 master 74
Dec  4 12:56:26 master 26
Dec  4 12:56:26 master 00
Dec  4 12:56:26 master 8b
Dec  4 12:56:26 master 4d
Dec  4 12:56:26 master d0
Dec  4 12:56:26 master 8b
Dec  4 12:56:26 master 41
Dec  4 12:56:26 master 08
Dec  4 12:56:26 master 89
Dec  4 12:56:26 master 78
Dec  4 12:56:26 master 04
Dec  4 12:56:26 master 89
Dec  4 12:56:26 master 07
Dec  4 12:56:26 master 8b
Dec  4 12:56:26 master
Dec  4 12:56:26 master EIP: [<c0181cf7>]
Dec  4 12:56:26 master cache_alloc_refill+0x1d7/0x560
Dec  4 12:56:26 master  SS:ESP 0068:d67edd0c
-- =

*Tobias Oed* - Octant Informatique <http://www.octant-fr.com>
tobias.oed@octant.org <mailto:tobias.oed@octant.org> - 04 76 50 82 38

*La R=E9gion Rh=F4ne Alpes soutient Octant dans le cadre de son projet
innovant... L'ERP OpenSource.*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
