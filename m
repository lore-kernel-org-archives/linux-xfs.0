Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2EJAW9a222618 for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 14:10:52 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B311B1987FA
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 12:10:09 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id Muqan0eVnr4pajy9 for
	<xfs@oss.sgi.com>; Sat, 14 Mar 2009 12:10:09 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: LWN article: 4K disk sectors
Date: Sat, 14 Mar 2009 20:10:44 +0100
References: <200903121258.51497@zmi.at>
	<200903121517.48426.Martin@lichtvoll.de>
	<49B92449.90805@sandeen.net> (sfid-20090312_171312_078129_6F30934B)
In-Reply-To: <49B92449.90805@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903142010.45564.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Am Donnerstag 12 M=E4rz 2009 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > Am Donnerstag 12 M=E4rz 2009 schrieb Michael Monnerie:
> >> On Donnerstag 12 M=E4rz 2009 Eric Sandeen wrote:
> >>> Take a look at the mkfs.xfs man page:
> >>>
> >>>        -s sector_size
> >>>               This option specifies the fundamental  sector  size =

> >>> of the filesystem.  The sector_size is specified either as a value
> >>> in bytes with size=3Dvalue or as a base two loga- rithm value with
> >>> log=3Dvalue.  The default sector_size is 512 bytes. The minimum value
> >>> for sector  size  is  512; the  maximum is 32768 (32 KiB). The
> >>> sector_size must be a power of 2 size and cannot be made  larger =

> >>> than  the filesystem block size.
> >>
> >> Ugh, I felt so good this morning, until you responded ... ;-)
> >>
> >> I thought that it's a limitation of the Linux kernel in more parts
> >> than just the filesystem (like block cache), that sector sizes must
> >> be 512B. If I had a 4K drive, would that be usable with XFS already?
> >
> > I have an USB stick with 2KB hardware sector size. It worked nicely
> > when using fdisk instead of cfdisk which only supports 512 byte
> > sectors. Dunno remember exactly which filesystems I tried back then.
>
> really?  what kind of usb stick?  I've never seen such a thing.

Its a stick I got from a customer.

shambhala:~> tail -fn0 /var/log/syslog
Mar 14 20:07:53 localhost kernel: usb 2-4: new high speed USB device using =

ehci_hcd and address 18
Mar 14 20:07:53 localhost kernel: usb 2-4: configuration #1 chosen from 1 =

choice
Mar 14 20:07:53 localhost kernel: scsi16 : SCSI emulation for USB Mass =

Storage devices
Mar 14 20:07:53 localhost kernel: usb 2-4: New USB device found, =

idVendor=3D17ef, idProduct=3D3815
Mar 14 20:07:53 localhost kernel: usb 2-4: New USB device strings: Mfr=3D1, =

Product=3D2, SerialNumber=3D3
Mar 14 20:07:53 localhost kernel: usb 2-4: Product: Flash Disk
Mar 14 20:07:53 localhost kernel: usb 2-4: Manufacturer:
Mar 14 20:07:53 localhost kernel: usb 2-4: SerialNumber: ABCDEF1234000423
Mar 14 20:07:53 localhost kernel: usb-storage: device found at 18
Mar 14 20:07:53 localhost kernel: usb-storage: waiting for device to =

settle before scanning
Mar 14 20:07:58 localhost kernel: usb-storage: device scan complete
Mar 14 20:07:58 localhost kernel: scsi 16:0:0:0: Direct-Access              =

Flash Disk       5.00 PQ: 0 ANSI: 2
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] 504832 2048-byte =

hardware sectors: (1.03 GB/986 MiB)
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] Write Protect is off
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] Mode Sense: 0b 00 00 =

08
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] Assuming drive cache: =

write through
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] 504832 2048-byte =

hardware sectors: (1.03 GB/986 MiB)
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] Write Protect is off
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] Mode Sense: 0b 00 00 =

08
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] Assuming drive cache: =

write through
Mar 14 20:07:58 localhost kernel: sdb: sdb1
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: [sdb] Attached SCSI =

removable disk
Mar 14 20:07:58 localhost kernel: sd 16:0:0:0: Attached scsi generic sg2 =

type 0
^C

Hmmm, it appears to be from Lenovo.

shambhala:~> lsusb | grep USB
Bus 002 Device 018: ID 17ef:3815 Lenovo ChipsBnk 2GB USB Stick

But its definately not 2 GB... strange. Its branded for the customer, no =

manufacturer logo on it.

-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
