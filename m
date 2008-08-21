Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 11:21:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LILWZ8006259
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 11:21:33 -0700
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E5B7F9BFEE
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 11:22:52 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com with ESMTP id PzrJNlCcEfo7ldgl for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 11:22:52 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression? 2.6.27-rc3 segfault on cold boot; not on warm boot.
Date: Thu, 21 Aug 2008 20:26:16 +0200
References: <48AD3921.5090709@dgreaves.com>
In-Reply-To: <48AD3921.5090709@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212026.17590.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>

[Adding CCs]

[The issue is probably present in 2.6.26 too]

On Thursday, 21 of August 2008, David Greaves wrote:
> I have a desktop system that has started having problems booting up in the morning.
> 
> It appears to just happen on more recent kernels.
> I was having unrelated CDROM problems with a driver in an old kernel and decided
> to test 2.6.27-rcX
> The CDROM problem is fine now.
> 
> However I started having problems on -rc1. I found that the machine was hanging
> soon after booting and needed a reboot. After a reboot it would work fine for
> the rest of the day.
> When -rc3 came out I tried that and the problem still appears to be there.
> 
> The normal process is now to boot to single-user, ctrl-alt-sysreq-SUB and then
> reboot to multi-user. This isn't ideal.
> 
> 
> If I cold boot 2.6.25.3 the problem doesn't occur.
> I will try different versions over the next few days.
> 
> Sample log from a few days back. (2.6.27-rc1 I think)
> 
> The problem does cause filesystem crashes so I'm cautious about messing around
> unguided.
> 
> Happy to try any suggestions.
> 
> David
> PS I've run memtest and it's fine.
> 
> 
> Aug 12 09:49:10 (none) syslogd 1.5.0#5: restart.
> Aug 12 09:49:10 (none) kernel: klogd 1.5.0#5, log source = /proc/kmsg started.
> Aug 12 09:49:10 (none) kernel: ddr 00:04:e2:cd:ac:db
> Aug 12 09:49:10 (none) kernel: via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by
> Donald Becker
> Aug 12 09:49:10 (none) kernel: via-rhine 0000:00:12.0: PCI INT A -> GSI 23
> (level, low) -> IRQ 23
> Aug 12 09:49:10 (none) kernel: eth1: VIA Rhine II at 0xdd000000,
> 00:11:2f:cd:d0:b6, IRQ 23.
> Aug 12 09:49:10 (none) kernel: eth1: MII PHY found at address 1, status 0x7849
> advertising 01e1 Link 0000.
> Aug 12 09:49:10 (none) kernel: netconsole: local port 6665
> Aug 12 09:49:10 (none) kernel: netconsole: local IP 10.0.0.74
> Aug 12 09:49:10 (none) kernel: netconsole: interface eth0
> Aug 12 09:49:10 (none) kernel: netconsole: remote port 6666
> Aug 12 09:49:10 (none) kernel: netconsole: remote IP 10.0.0.7
> Aug 12 09:49:10 (none) kernel: netconsole: remote ethernet address 00:13:20:55:b6:60
> Aug 12 09:49:10 (none) kernel: netconsole: device eth0 not up yet, forcing it
> Aug 12 09:49:10 (none) kernel: skge eth0: enabling interface
> Aug 12 09:49:10 (none) kernel: skge eth0: Link is up at 1000 Mbps, full duplex,
> flow control both
> Aug 12 09:49:10 (none) kernel: console [netcon0] enabled
> Aug 12 09:49:10 (none) kernel: netconsole: network logging started
> Aug 12 09:49:10 (none) kernel: Driver 'sd' needs updating - please use bus_type
> methods
> Aug 12 09:49:10 (none) kernel: Driver 'sr' needs updating - please use bus_type
> methods
> Aug 12 09:49:10 (none) kernel: sata_sil 0000:00:0a.0: version 2.3
> Aug 12 09:49:10 (none) kernel: sata_sil 0000:00:0a.0: PCI INT A -> GSI 16
> (level, low) -> IRQ 16
> Aug 12 09:49:10 (none) kernel: scsi0 : sata_sil
> Aug 12 09:49:10 (none) kernel: scsi1 : sata_sil
> Aug 12 09:49:10 (none) kernel: ata1: SATA max UDMA/100 mmio m512@0xde800000 tf
> 0xde800080 irq 16
> Aug 12 09:49:10 (none) kernel: ata2: SATA max UDMA/100 mmio m512@0xde800000 tf
> 0xde8000c0 irq 16
> Aug 12 09:49:10 (none) kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl
> 310)
> Aug 12 09:49:10 (none) kernel: ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
> Aug 12 09:49:10 (none) kernel: ata1.00: 625142448 sectors, multi 0: LBA48 NCQ
> (depth 0/32)
> Aug 12 09:49:10 (none) kernel: ata1.00: configured for UDMA/100
> Aug 12 09:49:10 (none) kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl
> 310)
> Aug 12 09:49:10 (none) kernel: ata2.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
> Aug 12 09:49:10 (none) kernel: ata2.00: 625142448 sectors, multi 0: LBA48 NCQ
> (depth 0/32)
> Aug 12 09:49:10 (none) kernel: ata2.00: configured for UDMA/100
> Aug 12 09:49:10 (none) kernel: scsi 0:0:0:0: Direct-Access     ATA
> ST3320620AS      3.AA PQ: 0 ANSI: 5
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] 625142448 512-byte hardware
> sectors (320073 MB)
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] 625142448 512-byte hardware
> sectors (320073 MB)
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel:  sda: sda1
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Attached SCSI disk
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
> Aug 12 09:49:10 (none) kernel: scsi 1:0:0:0: Direct-Access     ATA
> ST3320620AS      3.AA PQ: 0 ANSI: 5
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] 625142448 512-byte hardware
> sectors (320073 MB)
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel:  sda: sda1
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: [sda] Attached SCSI disk
> Aug 12 09:49:10 (none) kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
> Aug 12 09:49:10 (none) kernel: scsi 1:0:0:0: Direct-Access     ATA
> ST3320620AS      3.AA PQ: 0 ANSI: 5
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] 625142448 512-byte hardware
> sectors (320073 MB)
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] 625142448 512-byte hardware
> sectors (320073 MB)
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel:  sdb: sdb1 sdb2
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
> Aug 12 09:49:10 (none) kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
> Aug 12 09:49:10 (none) kernel: sata_via 0000:00:0f.0: version 2.3
> Aug 12 09:49:10 (none) kernel: sata_via 0000:00:0f.0: PCI INT B -> GSI 20
> (level, low) -> IRQ 20
> Aug 12 09:49:10 (none) kernel: sata_via 0000:00:0f.0: routed to hard irq line 0
> Aug 12 09:49:10 (none) kernel: scsi2 : sata_via
> Aug 12 09:49:10 (none) kernel: scsi3 : sata_via
> Aug 12 09:49:10 (none) kernel: ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400
> bmdma 0x8400 irq 20
> Aug 12 09:49:10 (none) kernel: ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800
> bmdma 0x8408 irq 20
> Aug 12 09:49:10 (none) kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl
> 300)
> Aug 12 09:49:10 (none) kernel: ata3.00: ATA-7: Maxtor 6L300S0, BANC1E00, max
> UDMA/133
> Aug 12 09:49:10 (none) kernel: ata3.00: 586114704 sectors, multi 16: LBA48 NCQ
> (not used)
> Aug 12 09:49:10 (none) kernel: ata3.00: configured for UDMA/133
> Aug 12 09:49:10 (none) kernel: ata4: SATA link up 1.5 Gbps (SStatus 113 SControl
> 300)
> Aug 12 09:49:10 (none) kernel: ata4.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
> Aug 12 09:49:10 (none) kernel: ata4.00: 625134827 sectors, multi 16: LBA48 NCQ
> (depth 0/32)
> Aug 12 09:49:10 (none) kernel: ata4.00: configured for UDMA/133
> Aug 12 09:49:10 (none) kernel: scsi 2:0:0:0: Direct-Access     ATA      Maxtor
> 6L300S0   BANC PQ: 0 ANSI: 5
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] 586114704 512-byte hardware
> sectors (300091 MB)
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] 586114704 512-byte hardware
> sectors (300091 MB)
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel:  sdc: sdc1 sdc2
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: [sdc] Attached SCSI disk
> Aug 12 09:49:10 (none) kernel: sd 2:0:0:0: Attached scsi generic sg2 type 0
> Aug 12 09:49:10 (none) kernel: scsi 3:0:0:0: Direct-Access     ATA
> ST3320620AS      3.AA PQ: 0 ANSI: 5
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] 625134827 512-byte hardware
> sectors (320069 MB)
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] 625134827 512-byte hardware
> sectors (320069 MB)
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] Write Protect is off
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> Aug 12 09:49:10 (none) kernel:  sdd: sdd1 sdd2 sdd3
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: [sdd] Attached SCSI disk
> Aug 12 09:49:10 (none) kernel: sd 3:0:0:0: Attached scsi generic sg3 type 0
> Aug 12 09:49:10 (none) kernel: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
> at 0x60,0x64 irq 1,12
> Aug 12 09:49:10 (none) kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
> Aug 12 09:49:10 (none) kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
> Aug 12 09:49:10 (none) kernel: mice: PS/2 mouse device common for all mice
> Aug 12 09:49:10 (none) kernel: input: AT Translated Set 2 keyboard as
> /class/input/input2
> Aug 12 09:49:10 (none) kernel: md: raid1 personality registered for level 1
> Aug 12 09:49:10 (none) kernel: raid6: int32x1    925 MB/s
> Aug 12 09:49:10 (none) kernel: raid6: int32x2    972 MB/s
> Aug 12 09:49:10 (none) kernel: raid6: int32x4    789 MB/s
> Aug 12 09:49:10 (none) kernel: raid6: int32x8    636 MB/s
> Aug 12 09:49:10 (none) kernel: raid6: mmxx1     1753 MB/s
> Aug 12 09:49:10 (none) kernel: raid6: mmxx2     3128 MB/s
> Aug 12 09:49:10 (none) kernel: raid6: sse1x1    1644 MB/s
> Aug 12 09:49:10 (none) kernel: raid6: sse1x2    2781 MB/s
> Aug 12 09:49:10 (none) kernel: raid6: using algorithm sse1x2 (2781 MB/s)
> Aug 12 09:49:10 (none) kernel: md: raid6 personality registered for level 6
> Aug 12 09:49:10 (none) kernel: md: raid5 personality registered for level 5
> Aug 12 09:49:10 (none) kernel: md: raid4 personality registered for level 4
> Aug 12 09:49:10 (none) kernel: TCP cubic registered
> Aug 12 09:49:10 (none) kernel: Using IPI Shortcut mode
> Aug 12 09:49:10 (none) kernel: PM: Resume from partition /dev/sdd3
> Aug 12 09:49:10 (none) kernel: PM: Checking hibernation image.
> Aug 12 09:49:10 (none) kernel: PM: Resume from disk failed.
> Aug 12 09:49:10 (none) kernel: input: ImExPS/2 Generic Explorer Mouse as
> /class/input/input3
> Aug 12 09:49:10 (none) kernel: md: Autodetecting RAID arrays.
> Aug 12 09:49:10 (none) kernel: md: Scanned 2 and added 2 devices.
> Aug 12 09:49:10 (none) kernel: md: autorun ...
> Aug 12 09:49:10 (none) kernel: md: considering sdc2 ...
> Aug 12 09:49:10 (none) kernel: md:  adding sdc2 ...
> Aug 12 09:49:10 (none) kernel: md:  adding sdb2 ...
> Aug 12 09:49:10 (none) kernel: md: created md0
> Aug 12 09:49:10 (none) kernel: md: bind<sdb2>
> Aug 12 09:49:10 (none) kernel: md: bind<sdc2>
> Aug 12 09:49:10 (none) kernel: md: running: <sdc2><sdb2>
> Aug 12 09:49:10 (none) kernel: raid1: raid set md0 active with 2 out of 2 mirrors
> Aug 12 09:49:10 (none) kernel: md: ... autorun DONE.
> Aug 12 09:49:10 (none) kernel: Filesystem "md0": Disabling barriers, not
> supported by the underlying device
> Aug 12 09:49:10 (none) kernel: XFS mounting filesystem md0
> Aug 12 09:49:10 (none) kernel: Ending clean XFS mount for filesystem: md0
> Aug 12 09:49:10 (none) kernel: VFS: Mounted root (xfs filesystem) readonly.
> Aug 12 09:49:10 (none) kernel: Freeing unused kernel memory: 248k freed
> Aug 12 09:49:10 (none) kernel: uname[892]: segfault at ffffffbf ip ffffffbf sp
> bfb4b09c error 4
> Aug 12 09:49:10 (none) kernel: cat[894]: segfault at ffffffbf ip ffffffbf sp
> bfb121ec error 4
> Aug 12 09:49:10 (none) kernel: uname[898]: segfault at ffffffbf ip ffffffbf sp
> bfccc22c error 4
> Aug 12 09:49:10 (none) kernel: uname[903]: segfault at ffffffbf ip ffffffbf sp
> bfb8a0ec error 4
> Aug 12 09:49:10 (none) kernel: uname[910]: segfault at ffffffbf ip ffffffbf sp
> bfd7f2ec error 4
> Aug 12 09:49:10 (none) kernel: uname[922]: segfault at ffffffbf ip ffffffbf sp
> bffbe51c error 4
> Aug 12 09:49:10 (none) kernel: uname[923]: segfault at ffffffbf ip ffffffbf sp
> bf8dae3c error 4
> Aug 12 09:49:10 (none) kernel: uname[1004]: segfault at ffffffbf ip ffffffbf sp
> bff2dc8c error 4
> Aug 12 09:49:10 (none) kernel: uname[1005]: segfault at ffffffbf ip ffffffbf sp
> bfd86adc error 4
> Aug 12 09:49:10 (none) kernel: Adding 2048276k swap on /dev/sdd3.  Priority:-1
> extents:1 across:2048276k
> Aug 12 09:49:10 (none) kernel: Filesystem "md0": Disabling barriers, not
> supported by the underlying device
> Aug 12 09:49:10 (none) kernel: uname[1032]: segfault at ffffffbf ip ffffffbf sp
> bffd453c error 4
> Aug 12 09:49:10 (none) kernel: device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
> initialised: dm-devel@redhat.com
> Aug 12 09:49:10 (none) kernel: Filesystem "md0": XFS internal error
> xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xc01f51fa
> Aug 12 09:49:10 (none) kernel: Pid: 1113, comm: sh Not tainted 2.6.27-rc1 #10
> Aug 12 09:49:10 (none) kernel:  [<c01efe64>] ? xfs_cmn_err+0x34/0x60
> Aug 12 09:49:10 (none) kernel:  [<c01efede>] xfs_error_report+0x4e/0x50
> Aug 12 09:49:10 (none) kernel:  [<c01f51fa>] ? xfs_inobt_lookup+0xfa/0x3a0
> Aug 12 09:49:10 (none) kernel:  [<c01e29c6>] xfs_btree_check_sblock+0x56/0xd0
