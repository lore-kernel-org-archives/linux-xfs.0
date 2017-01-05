Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36110 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936425AbdAEUnf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2017 15:43:35 -0500
Received: by mail-io0-f174.google.com with SMTP id p127so42204098iop.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2017 12:42:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170105202108.GE17846@birch.djwong.org>
References: <CABPa+v3fgLjBo2CLBXxg8xE3D5tWdjk2C3gM2o1-xEFT45_Rkg@mail.gmail.com>
 <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net> <20170105191316.GD17846@birch.djwong.org>
 <CABPa+v2t_wF-n55GWRcHL7D3_ANcLqaDx1qa5SQ07pU7CgomXg@mail.gmail.com>
 <0e31b8db-9721-f735-7e29-0eaae5fd21eb@sandeen.net> <20170105202108.GE17846@birch.djwong.org>
From: Xingbo Wu <wuxb45@gmail.com>
Date: Thu, 5 Jan 2017 14:41:35 -0600
Message-ID: <CABPa+v3YS6f6oRB7ByJAz2Jwz5Qo4PoG5Rki9a58xpNo-hmE+Q@mail.gmail.com>
Subject: Re: [BUG] xfs.mkfs recognizes wrong disk size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

>> > [    7.158847] sd 0:0:6:0: [sdf] 5860533168 512-byte logical blocks:
>> > (3.00 TB/2.73 TiB)
>> > [    7.158851] sd 0:0:6:0: [sdf] 4096-byte physical blocks
>> > [    7.259937] sd 0:0:6:0: [sdf] Write Protect is off
>> > [    7.259943] sd 0:0:6:0: [sdf] Mode Sense: 9b 00 10 08
>> > [    7.282316] sd 0:0:6:0: [sdf] Write cache: enabled, read cache:
>> > enabled, supports DPO and FUA
>> > [    7.418959] sd 0:0:6:0: [sdf] Attached SCSI disk
>> > [1807850.471959] XFS (sdf): Mounting V5 Filesystem
>> > [1807850.605057] XFS (sdf): Ending clean mount
>> > [1807875.741657] sd 0:0:6:0: [sdf] tag#0 UNKNOWN(0x2003) Result:
>> > hostbyte=3D0x07 driverbyte=3D0x00
>> > [1807875.741670] sd 0:0:6:0: [sdf] tag#0 CDB: opcode=3D0x8a 8a 08 00 0=
0
>> > 00 00 ae a8 52 28 00 00 00 08 00 00
>
> WRITE(16) with FUA set... on a SATA drive?
>
> A dumb Google search of "ST3000DM001 FUA" pulls up a lot of dmesg
> that show the drive not advertising DPO or FUA support.
>
> 0:0:6:0 ... SCSI host0, ctrl0, target6, lun0, huh?  Is this SATA drive
> connected to a SAS/RAID controller or something?  It could be
> advertising FUA support to Linux but the drive (or even the SATL I
> guess) rejects an actual command w/ the FUA bit set.
>
> --D
>

It's a Dell T630 Tower server. All disks are connected through a panel
that looks like some controller. Anyway no RAID was configured and I
just plugged in disks/ssds. Never had a problem with other disks.

Here is a longer part of the dmesg:
[    4.378499] scsi host0: Avago SAS based MegaRAID driver
[    4.379725] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6
Gbps 0x3f impl SATA mode
[    4.379730] ahci 0000:00:1f.2: flags: 64bit ncq stag led clo pio
slum part ems apst
[    4.384933] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD
840  BB6Q PQ: 0 ANSI: 6
[    4.429659] scsi host5: ahci
[    4.429847] scsi host6: ahci
[    4.430065] scsi host7: ahci
[    4.430246] scsi host8: ahci
[    4.430434] scsi host9: ahci
[    4.430650] scsi host10: ahci
[    4.430757] ata5: SATA max UDMA/133 abar m2048@0x91f00000 port
0x91f00100 irq 63
[    4.430760] ata6: SATA max UDMA/133 abar m2048@0x91f00000 port
0x91f00180 irq 63
[    4.430762] ata7: SATA max UDMA/133 abar m2048@0x91f00000 port
0x91f00200 irq 63
[    4.430765] ata8: SATA max UDMA/133 abar m2048@0x91f00000 port
0x91f00280 irq 63
[    4.430767] ata9: SATA max UDMA/133 abar m2048@0x91f00000 port
0x91f00300 irq 63
[    4.430770] ata10: SATA max UDMA/133 abar m2048@0x91f00000 port
0x91f00380 irq 63
[    4.446366] scsi 0:0:2:0: Direct-Access     ATA
ST2000NM0055-1V4 DA03 PQ: 0 ANSI: 6
[    4.520634] scsi 0:0:3:0: Direct-Access     ATA
ST2000NM0055-1V4 DA03 PQ: 0 ANSI: 6
[    4.566866] scsi 0:0:4:0: Direct-Access     ATA      WDC
WD40EZRX-00S 0A80 PQ: 0 ANSI: 6
[    4.603520] scsi 0:0:5:0: Direct-Access     ATA      WDC
WD40EZRX-00S 0A80 PQ: 0 ANSI: 6
[    4.639943] scsi 0:0:6:0: Direct-Access     ATA
ST3000DM001-9YN1 CC98 PQ: 0 ANSI: 6
[    4.648847] ata1: SATA link down (SStatus 0 SControl 300)
[    4.671763] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    4.691709] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    4.745205] ata5: SATA link down (SStatus 0 SControl 300)
[    4.815850] hub 1-1:1.0: USB hub found
[    4.815982] hub 1-1:1.0: 6 ports detected
[    4.842352] hub 2-1:1.0: USB hub found
[    4.842393] hub 2-1:1.0: 8 ports detected
[    4.911744] tsc: Refined TSC clocksource calibration: 2197.454 MHz
[    4.911764] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x1faccdc500e, max_idle_ns: 440795287451 ns
[    4.961561] ata2: SATA link down (SStatus 0 SControl 300)
[    5.098384] usb 1-1.6: new high-speed USB device number 3 using ehci-pci
[    5.123235] random: fast init done
[    5.196708] hub 1-1.6:1.0: USB hub found
[    5.196863] hub 1-1.6:1.0: 6 ports detected
[    5.275437] ata3: SATA link down (SStatus 0 SControl 300)
[    5.588809] ata4: SATA link down (SStatus 0 SControl 300)
[    5.902119] ata6: SATA link down (SStatus 0 SControl 300)
[    5.925244] clocksource: Switched to clocksource tsc
[    6.215354] ata7: SATA link down (SStatus 0 SControl 300)
[    6.528669] ata8: SATA link down (SStatus 0 SControl 300)
[    6.841961] ata9: SATA link down (SStatus 0 SControl 300)
[    7.155272] ata10: SATA link down (SStatus 0 SControl 300)
[    7.158789] sd 0:0:5:0: [sde] 7814037168 512-byte logical blocks:
(4.00 TB/3.64 TiB)
[    7.158793] sd 0:0:5:0: [sde] 4096-byte physical blocks
[    7.158801] sd 0:0:4:0: [sdd] 7814037168 512-byte logical blocks:
(4.00 TB/3.64 TiB)
[    7.158805] sd 0:0:4:0: [sdd] 4096-byte physical blocks
[    7.158847] sd 0:0:6:0: [sdf] 5860533168 512-byte logical blocks:
(3.00 TB/2.73 TiB)
[    7.158851] sd 0:0:6:0: [sdf] 4096-byte physical blocks
[    7.159772] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks:
(250 GB/233 GiB)
[    7.163014] sd 0:0:3:0: [sdc] 3907029168 512-byte logical blocks:
(2.00 TB/1.82 TiB)
[    7.165425] sd 0:0:4:0: [sdd] Write Protect is off
[    7.165431] sd 0:0:4:0: [sdd] Mode Sense: 9b 00 10 08
[    7.165507] sd 0:0:0:0: [sda] Write Protect is off
[    7.165512] sd 0:0:0:0: [sda] Mode Sense: 9b 00 10 08
[    7.165524] sd 0:0:5:0: [sde] Write Protect is off
[    7.165530] sd 0:0:5:0: [sde] Mode Sense: 9b 00 10 08
[    7.165910] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    7.166445] sd 0:0:4:0: [sdd] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    7.166637] sd 0:0:5:0: [sde] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    7.167238] sd 0:0:2:0: [sdb] 3907029168 512-byte logical blocks:
(2.00 TB/1.82 TiB)
[    7.172598]  sda: sda1 sda2
[    7.179065] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.191963] sd 0:0:3:0: [sdc] Write Protect is off
[    7.191969] sd 0:0:3:0: [sdc] Mode Sense: 9b 00 10 08
[    7.193469] sd 0:0:3:0: [sdc] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    7.195788] sd 0:0:2:0: [sdb] Write Protect is off
[    7.195793] sd 0:0:2:0: [sdb] Mode Sense: 9b 00 10 08
[    7.197287] sd 0:0:2:0: [sdb] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    7.243312] sd 0:0:3:0: [sdc] Attached SCSI disk
[    7.247197] sd 0:0:2:0: [sdb] Attached SCSI disk
[    7.259937] sd 0:0:6:0: [sdf] Write Protect is off
[    7.259943] sd 0:0:6:0: [sdf] Mode Sense: 9b 00 10 08
[    7.282316] sd 0:0:6:0: [sdf] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    7.418959] sd 0:0:6:0: [sdf] Attached SCSI disk
[    7.971468] sd 0:0:4:0: [sdd] Attached SCSI disk
[    8.010606] sd 0:0:5:0: [sde] Attached SCSI disk
[    8.270177] SGI XFS with ACLs, security attributes, realtime, no
debug enabled
[    8.274002] XFS (sda1): Mounting V4 Filesystem
[    8.274707] random: crng init done
[    8.286898] XFS (sda1): Ending clean mount



--=20

Regards,
        Wu, Xingbo (=E5=90=B4=E5=85=B4=E5=8D=9A)  <wuxb45@gmail.com>
