Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Aug 2008 02:47:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7N9lA5r003046
	for <xfs@oss.sgi.com>; Sat, 23 Aug 2008 02:47:11 -0700
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1131A3C2FDB
	for <xfs@oss.sgi.com>; Sat, 23 Aug 2008 02:48:30 -0700 (PDT)
Received: from mail.ukfsn.org (mail.ukfsn.org [77.75.108.10]) by cuda.sgi.com with ESMTP id t7TaMJEBntuLM4Ce for <xfs@oss.sgi.com>; Sat, 23 Aug 2008 02:48:30 -0700 (PDT)
Message-ID: <48AFDCE7.7010508@dgreaves.com>
Date: Sat, 23 Aug 2008 10:48:23 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: Regression? 2.6.27-rc3 segfault on cold boot; not on warm boot.
References: <48AD3921.5090709@dgreaves.com> <200808212026.17590.rjw@sisk.pl>
In-Reply-To: <200808212026.17590.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>

Rafael J. Wysocki wrote:
> [Adding CCs]
> 
> [The issue is probably present in 2.6.26 too]

Yes, below is a netconsole boot of 2.26.6.3

I cold booted - lots of segfaults. I then did a ctrl-Alt-SysRq-S-U-B to a warm
boot. No segfaults
(lots of #### mark the split)

I've just started 2.6.25.14 building for tomorrow to confirm how far back it
goes. (I'm 99% sure 2.6.25 is OK)

David

elm:~# netcat -u -l -p 6666
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 20
sata_via 0000:00:0f.0: routed to hard irq line 0
scsi2 : sata_via
scsi3 : sata_via
ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400 bmdma 0x8400 irq 20
ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800 bmdma 0x8408 irq 20
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: Maxtor 6L300S0, BANC1E00, max UDMA/133
ata3.00: 586114704 sectors, multi 16: LBA48 NCQ (not used)
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata4.00: 625134827 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L300S0   BANC PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 586114704 512-byte hardware sectors (300091 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 2:0:0:0: [sdc] 586114704 512-byte hardware sectors (300091 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdc: sdc1 sdc2
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 625134827 512-byte hardware sectors (320069 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 3:0:0:0: [sdd] 625134827 512-byte hardware sectors (320069 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: [sdd] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
md: raid1 personality registered for level 1
raid6: int32x1    925 MB/s
raid6: int32x2    972 MB/s
raid6: int32x4    777 MB/s
raid6: int32x8    601 MB/s
raid6: mmxx1     1730 MB/s
raid6: mmxx2     3105 MB/s
raid6: sse1x1    1644 MB/s
raid6: sse1x2    2789 MB/s
raid6: using algorithm sse1x2 (2789 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
TCP cubic registered
Using IPI Shortcut mode
input: ImExPS/2 Generic Explorer Mouse as /class/input/input3
md: Autodetecting RAID arrays.
md: Scanned 2 and added 2 devices.
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md:  adding sdb2 ...
md: created md0
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
Filesystem "md0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md0
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 228k freed
Linux agpgart interface v0.103
agpgart: Detected VIA KT400/KT400A/KT600 chipset
agpgart: AGP aperture is 32M @ 0xfc000000
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 20
scsi4 : pata_via
scsi5 : pata_via
ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x7800 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x7808 irq 15
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ata5.00: ATAPI: PLEXTOR DVDR   PX-708A, 1.02, max UDMA/33
ata5.01: ATAPI: TSSTcorpCD/DVDW SH-W162C, TS10, max UDMA/33
ata5.00: configured for UDMA/33
ata5.01: configured for UDMA/33
ata6.00: ATAPI: PLEXTOR CD-R   PX-W2410A, 1.02, max UDMA/33
ata6.00: configured for UDMA/33
scsi 4:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-708A   1.02 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi generic sg4 type 5
scsi 4:0:1:0: CD-ROM            TSSTcorp CD/DVDW SH-W162C TS10 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
sr 4:0:1:0: Attached scsi generic sg5 type 5
scsi 5:0:0:0: CD-ROM            PLEXTOR  CD-R   PX-W2410A 1.02 PQ: 0 ANSI: 5
sr2: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 5:0:0:0: Attached scsi generic sg6 type 5
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 21, io base 0x00007400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 21, io base 0x00007000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 21, io base 0x00006800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.3: irq 21, io base 0x00006400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:10.4: irq 21, io mem 0xdd800000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
Adding 2048276k swap on /dev/sdd3.  Priority:-1 extents:1 across:2048276k
Filesystem "md0": Disabling barriers, not supported by the underlying device
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
md: md1 stopped.
md: bind<sdc1>
md: bind<sdb1>
md: bind<sda1>
md: bind<sdd1>
raid5: device sdd1 operational as raid disk 0
raid5: device sda1 operational as raid disk 3
raid5: device sdb1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 4203kB for md1
raid5: raid level 5 set md1 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sdd1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sda1
md1: bitmap initialized from disk: read 9/9 pages, set 0 bits
created bitmap (135 pages) for device md1
Filesystem "dm-0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-0
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
acpid[2800]: segfault at ffffffbf ip ffffffbf sp bfe7839c error 4
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
env[3550]: segfault at ffffffbf ip ffffffbf sp bf92962c error 4
env[3551]: segfault at ffffffbf ip ffffffbf sp bff9648c error 4
env[3558]: segfault at ffffffbf ip ffffffbf sp bfb3683c error 4
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized radeon 1.29.0 20080528 on minor 0
agpgart: Found an AGP 3.5 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
kdm_greet[3710]: segfault at ffffffbf ip ffffffbf sp bfc5a3ac error 4
Filesystem "md0": XFS internal error xfs_btree_check_lblock at line 213 of file
fs/xfs/xfs_btree.c.  Caller 0xc01ddfa1
Pid: 161, comm: pdflush Not tainted 2.6.26.3 #12
 [<c01ee734>] ? xfs_cmn_err+0x34/0x60
 [<c01ee7ae>] xfs_error_report+0x4e/0x50
 [<c01ddfa1>] ? xfs_bmbt_lookup+0x2c1/0x4f0
 [<c01e140d>] xfs_btree_check_lblock+0x4d/0x150
 [<c01ddfa1>] ? xfs_bmbt_lookup+0x2c1/0x4f0
 [<c01ddfa1>] xfs_bmbt_lookup+0x2c1/0x4f0
 [<c01de225>] xfs_bmbt_lookup_eq+0x25/0x30
 [<c01d5faf>] xfs_bmap_add_extent_delay_real+0x72f/0x11b0
 [<c020ff30>] ? xfs_trans_log_buf+0x70/0x80
 [<c01c5f12>] ? xfs_alloc_search_busy+0xb2/0xe0
 [<c01c83be>] ? xfs_alloc_vextent+0x33e/0x450
 [<c01d79a3>] ? xfs_bmap_btalloc+0x743/0xa80
 [<c01f6899>] ? xfs_iext_bno_to_ext+0x89/0x1a0
 [<c0156d69>] ? get_page_from_freelist+0x239/0x4e0
 [<c01d6e57>] xfs_bmap_add_extent+0x427/0x450
 [<c01e0d98>] ? xfs_btree_init_cursor+0x28/0x1d0
 [<c01db022>] xfs_bmapi+0xd12/0x12e0
 [<c0218d20>] ? kmem_zone_alloc+0x80/0xc0
 [<c01fcf44>] xfs_iomap_write_allocate+0x254/0x3e0
 [<c020f5a8>] ? xfs_trans_unlocked_item+0x38/0x50
 [<c01fdf87>] xfs_iomap+0x327/0x370
 [<c023277d>] ? submit_bio+0x6d/0x110
 [<c0219b4e>] xfs_map_blocks+0x3e/0x90
 [<c021a97a>] xfs_page_state_convert+0x41a/0x810
 [<c0231d4a>] ? blk_done_softirq+0x5a/0x70
 [<c021b05a>] xfs_vm_writepage+0x5a/0xf0
 [<c015769b>] __writepage+0xb/0x40
 [<c015811e>] write_cache_pages+0x17e/0x330
 [<c0157690>] ? __writepage+0x0/0x40
 [<c0220e27>] ? xfs_bdstrat_cb+0x37/0x70
 [<c021ce62>] ? xfs_buf_iostart+0x42/0xb0
 [<c01f93e8>] ? xfs_iflush+0x288/0x2f0
 [<c01582f3>] generic_writepages+0x23/0x30
 [<c021afc5>] xfs_vm_writepages+0x55/0x70
 [<c021af70>] ? xfs_vm_writepages+0x0/0x70
 [<c015832e>] do_writepages+0x2e/0x50
 [<c0194ee3>] __writeback_single_inode+0x93/0x490
 [<f895d1a3>] ? dm_table_any_congested+0x33/0x80 [dm_mod]
 [<c02e3b6c>] ? raid1_congested+0x7c/0xb0
 [<c01957a2>] sync_sb_inodes+0x242/0x390
 [<c0211f0d>] ? xfs_sync+0x3d/0x60
 [<c0195b1e>] writeback_inodes+0x5e/0x140
 [<c015845b>] wb_kupdate+0x7b/0xf0
 [<c0158d80>] ? pdflush+0x0/0x210
 [<c0158e90>] pdflush+0x110/0x210
 [<c01583e0>] ? wb_kupdate+0x0/0xf0
 [<c013572a>] kthread+0x3a/0x70
 [<c01356f0>] ? kthread+0x0/0x70
 [<c0103d1f>] kernel_thread_helper+0x7/0x18
 =======================
Filesystem "md0": XFS internal error xfs_trans_cancel at line 1163 of file
fs/xfs/xfs_trans.c.  Caller 0xc01fd04c
Pid: 161, comm: pdflush Not tainted 2.6.26.3 #12
 [<c01ee734>] ? xfs_cmn_err+0x34/0x60
 [<c01ee7ae>] xfs_error_report+0x4e/0x50
 [<c01fd04c>] ? xfs_iomap_write_allocate+0x35c/0x3e0
 [<c020e3ea>] xfs_trans_cancel+0xca/0xf0
 [<c01fd04c>] ? xfs_iomap_write_allocate+0x35c/0x3e0
 [<c01fd04c>] xfs_iomap_write_allocate+0x35c/0x3e0
 [<c020f5a8>] ? xfs_trans_unlocked_item+0x38/0x50
 [<c01fdf87>] xfs_iomap+0x327/0x370
 [<c023277d>] ? submit_bio+0x6d/0x110
 [<c0219b4e>] xfs_map_blocks+0x3e/0x90
 [<c021a97a>] xfs_page_state_convert+0x41a/0x810
 [<c0231d4a>] ? blk_done_softirq+0x5a/0x70
 [<c021b05a>] xfs_vm_writepage+0x5a/0xf0
 [<c015769b>] __writepage+0xb/0x40
 [<c015811e>] write_cache_pages+0x17e/0x330
 [<c0157690>] ? __writepage+0x0/0x40
 [<c0220e27>] ? xfs_bdstrat_cb+0x37/0x70
 [<c021ce62>] ? xfs_buf_iostart+0x42/0xb0
 [<c01f93e8>] ? xfs_iflush+0x288/0x2f0
 [<c01582f3>] generic_writepages+0x23/0x30
 [<c021afc5>] xfs_vm_writepages+0x55/0x70
 [<c021af70>] ? xfs_vm_writepages+0x0/0x70
 [<c015832e>] do_writepages+0x2e/0x50
 [<c0194ee3>] __writeback_single_inode+0x93/0x490
 [<f895d1a3>] ? dm_table_any_congested+0x33/0x80 [dm_mod]
 [<c02e3b6c>] ? raid1_congested+0x7c/0xb0
 [<c01957a2>] sync_sb_inodes+0x242/0x390
 [<c0211f0d>] ? xfs_sync+0x3d/0x60
 [<c0195b1e>] writeback_inodes+0x5e/0x140
 [<c015845b>] wb_kupdate+0x7b/0xf0
 [<c0158d80>] ? pdflush+0x0/0x210
 [<c0158e90>] pdflush+0x110/0x210
 [<c01583e0>] ? wb_kupdate+0x0/0xf0
 [<c013572a>] kthread+0x3a/0x70
 [<c01356f0>] ? kthread+0x0/0x70
 [<c0103d1f>] kernel_thread_helper+0x7/0x18
 =======================
xfs_force_shutdown(md0,0x8) called from line 1164 of file fs/xfs/xfs_trans.c.
Return address = 0xc020e402
Filesystem "md0": Corruption of in-memory data detected.  Shutting down
filesystem: md0
Please umount the filesystem, and rectify the problem(s)
SysRq : Emergency Sync
Filesystem "md0": xfs_log_force: error 5 returned.
Emergency Sync complete
SysRq : Emergency Remount R/O
Filesystem "md0": xfs_log_force: error 5 returned.
Filesystem "md0": xfs_log_force: error 5 returned.
xfs_force_shutdown(md0,0x1) called from line 420 of file fs/xfs/xfs_rw.c.
Return address = 0xc021880c
Filesystem "md0": xfs_log_force: error 5 returned.
Filesystem "md0": xfs_log_force: error 5 returned.
xfs_force_shutdown(md0,0x1) called from line 420 of file fs/xfs/xfs_rw.c.
Return address = 0xc021880c
Filesystem "md0": xfs_log_force: error 5 returned.
Filesystem "md0": xfs_log_force: error 5 returned.
Emergency Remount complete
SysRq : Resetting






##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################






ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 20
sata_via 0000:00:0f.0: routed to hard irq line 0
scsi2 : sata_via
scsi3 : sata_via
ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400 bmdma 0x8400 irq 20
ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800 bmdma 0x8408 irq 20
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: Maxtor 6L300S0, BANC1E00, max UDMA/133
ata3.00: 586114704 sectors, multi 16: LBA48 NCQ (not used)
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata4.00: 625134827 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L300S0   BANC PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 586114704 512-byte hardware sectors (300091 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 2:0:0:0: [sdc] 586114704 512-byte hardware sectors (300091 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdc: sdc1 sdc2
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 625134827 512-byte hardware sectors (320069 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 3:0:0:0: [sdd] 625134827 512-byte hardware sectors (320069 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: [sdd] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
md: raid1 personality registered for level 1
raid6: int32x1    925 MB/s
raid6: int32x2    972 MB/s
raid6: int32x4    777 MB/s
raid6: int32x8    601 MB/s
raid6: mmxx1     1730 MB/s
raid6: mmxx2     3105 MB/s
raid6: sse1x1    1644 MB/s
raid6: sse1x2    2789 MB/s
raid6: using algorithm sse1x2 (2789 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
TCP cubic registered
Using IPI Shortcut mode
input: ImExPS/2 Generic Explorer Mouse as /class/input/input3
md: Autodetecting RAID arrays.
md: Scanned 2 and added 2 devices.
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md:  adding sdb2 ...
md: created md0
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
Filesystem "md0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md0
Starting XFS recovery on filesystem: md0 (logdev: internal)
Ending XFS recovery on filesystem: md0 (logdev: internal)
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 228k freed
Linux agpgart interface v0.103
agpgart: Detected VIA KT400/KT400A/KT600 chipset
agpgart: AGP aperture is 32M @ 0xfc000000
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 20
scsi4 : pata_via
scsi5 : pata_via
ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x7800 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x7808 irq 15
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ata5.00: ATAPI: PLEXTOR DVDR   PX-708A, 1.02, max UDMA/33
ata5.01: ATAPI: TSSTcorpCD/DVDW SH-W162C, TS10, max UDMA/33
ata5.00: configured for UDMA/33
ata5.01: configured for UDMA/33
ata6.00: ATAPI: PLEXTOR CD-R   PX-W2410A, 1.02, max UDMA/33
ata6.00: configured for UDMA/33
scsi 4:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-708A   1.02 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi generic sg4 type 5
scsi 4:0:1:0: CD-ROM            TSSTcorp CD/DVDW SH-W162C TS10 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
sr 4:0:1:0: Attached scsi generic sg5 type 5
scsi 5:0:0:0: CD-ROM            PLEXTOR  CD-R   PX-W2410A 1.02 PQ: 0 ANSI: 5
sr2: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 5:0:0:0: Attached scsi generic sg6 type 5
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 21, io base 0x00007400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 21, io base 0x00007000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 21, io base 0x00006800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.3: irq 21, io base 0x00006400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:10.4: irq 21, io mem 0xdd800000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
Adding 2048276k swap on /dev/sdd3.  Priority:-1 extents:1 across:2048276k
Filesystem "md0": Disabling barriers, not supported by the underlying device
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
md: md1 stopped.
md: bind<sdc1>
md: bind<sdb1>
md: bind<sda1>
md: bind<sdd1>
raid5: device sdd1 operational as raid disk 0
raid5: device sda1 operational as raid disk 3
raid5: device sdb1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 4203kB for md1
raid5: raid level 5 set md1 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sdd1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sda1
md1: bitmap initialized from disk: read 9/9 pages, set 2 bits
created bitmap (135 pages) for device md1
Filesystem "dm-0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-0
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized radeon 1.29.0 20080528 on minor 0
agpgart: Found an AGP 3.5 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
