Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 09:39:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IGdYGO008211
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:39:34 -0700
Received: from bay0-omc1-s3.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACEC6CE69F1
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:40:32 -0700 (PDT)
Received: from bay0-omc1-s3.bay0.hotmail.com (bay0-omc1-s3.bay0.hotmail.com [65.54.246.75]) by cuda.sgi.com with ESMTP id dVszXOghj6Lqx3NH for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:40:32 -0700 (PDT)
Message-ID: <BAY103-DAV10F0AFAC45572E50A384AB2AB0@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV69C0718B7EDB534D9337FB2A90@phx.gbl> <20080618161252.GV3700@disturbed>
Subject: Re: XFS: 2.6.26-rc6 link count mismatch for inode
Date: Wed, 18 Jun 2008 18:39:59 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner wrote:

> On Mon, Jun 16, 2008 at 11:11:31AM +0200, Marco Berizzi wrote:
> > Hi Folk,
> >
> > I was tring to compile firefox 3.0rc3
> > and while I was erasing a previous
> > /tmp/mozilla tree, I started a new
> > tar xjf mozilla-blabla.
> > After a while linux 2.6.26-rc6 was
> > unresponsive: I have unplugged the
> > power cable. No problem at startup,
> > but:
>
> What are your mount options?

root@Venus:/etc# cat mtab
/dev/sda2 / xfs rw 0 0

root@Venus:/etc# cat fstab
/dev/sda2        /                xfs         defaults         1   1

> Are you using barriers (what does XFS
> output in dmesg when mounting the filesystem)?

scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xe4809000 port 0xe4809100 irq 17
ata2: DUMMY
ata3: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: ATA-7: ST9160821AS, 3.BHE, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      ST9160821AS      3.BH PQ: 0
ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO
 or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO
 or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40c0 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40c8 irq 15
ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-T20L, NC08, max MWDMA2
ata4.00: configured for MWDMA2
ata5: port disabled. ignoring.
scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20L  NC08 PQ: 0
ANSI: 5
PNP: PS/2 Controller [PNP0303:C298,PNP0f13:C299] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/inpu
t0
XFS mounting filesystem sda2
Ending clean XFS mount for filesystem: sda2
VFS: Mounted root (xfs filesystem) readonly.

> I ask because I've
> seen this sort of directory corruption before when using volatile
> write caches and yanking the power....
>
> i.e. the corruption could have been caused by the way you reset the
> system, not because of the hang. Do you have any information on what
> caused the hang?

The tar xf mozilla-source.tarball was not responding
nor writing anything on the disk. I did issue also a
kill -9 'pid of tar xf' but it did not want to die.
So I think the problem was on the filesystem before
the incorrect shutdown.
I can retry the test. Let me know if I can do a
xfs_repair.
