Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 01:32:03 -0700 (PDT)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8N8VvQ3022440
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 01:31:59 -0700
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: Tips on xfs creation on MIPS R5000 machine running Linux?
Date: Sun, 23 Sep 2007 10:30:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
In-Reply-To: <20070919084929.0146ADE43@mail.edu.haifa.ac.il>
Message-Id: <20070923083214.3D5018E1B@mail.edu.haifa.ac.il>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Leon Kolchinsky' <leonk@construct.haifa.ac.il>, xfs@oss.sgi.com

> Hello All,
> 
> 
> Finally I've got my hands on some nice R5000 Model O2 machine with IRIX
> 6.5
> on it.
> 
> # hinv
> CPU: MIPS R5000 Processor Chip Revision: 2.1
> FPU: MIPS R5000 Floating Point Coprocessor Revision: 1.0
> 1 180 MHZ IP32 Processor
> Main memory size: 256 Mbytes
> Secondary unified instruction/data cache size: 512 Kbytes on Processor 0
> Instruction cache size: 32 Kbytes
> Data cache size: 32 Kbytes
> FLASH PROM version 4.13
> Integral SCSI controller 0: Version ADAPTEC 7880
>   Disk drive: unit 1 on SCSI controller 0
>   Disk drive: unit 2 on SCSI controller 0
>   CDROM: unit 4 on SCSI controller 0
> Integral SCSI controller 1: Version ADAPTEC 7880
> On-board serial ports: tty1
> On-board serial ports: tty2
> On-board EPP/ECP parallel port
> CRM graphics installed
> Integral Ethernet: ec0, version 1
> Iris Audio Processor: version A3 revision 0
> Video: MVP unit 0 version 1.4
> AV: AV1 Card version 1, O2Cam type 1 version 0 connected.
> Vice: TRE
> 
> I'm intending to install Gentoo on this machine and I need some advice.
> 
> Following are the commands I've used to create and mount my partitions on
> some old x86 PC.
> a) Should I use the same values for all partitions on R5000 ?
> 
> 1) Creating FS:
> mkfs.xfs -l internal,size=128m -d agcount=2 –d unwritten=0 /dev/hda1
> 
> 2) Mount options:
> mount -o noatime,nodiratime,logbufs=8
> 
> Any suggestion for best performance configuration for XFS on this machine?
> 
> b) If I'd like to replace the old 2GB disk to some new 80GB disk. Would
> PROM
> recognize it? Is there any special procedure?
> 
> c) Anyone has any experience with Gentoo on MIPS as a desktop system
> (performance, device recognition (i.e. webcam) etc.)?
> 
> 
> Best Regards,
> Leon Kolchinsky

No takers here?
There are some former and current SGI people on the list who have some
information on the above topic.

Could you shed some light on it please?



Regards,
Leon
