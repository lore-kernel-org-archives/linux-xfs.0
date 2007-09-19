Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 10:59:05 -0700 (PDT)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JHwruw032089
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 10:58:55 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.edu.haifa.ac.il (Postfix) with ESMTP id 34B7114B1BD
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 10:49:29 +0200 (IST)
Received: from mail.edu.haifa.ac.il ([127.0.0.1])
	by localhost (mail.edu.haifa.ac.il [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Czbk+eY6tdDt for <xfs@oss.sgi.com>;
	Wed, 19 Sep 2007 10:49:29 +0200 (IST)
Received: from kozanostra (leon.edu.haifa.ac.il [132.74.41.33])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail.edu.haifa.ac.il (Postfix) with ESMTP id 0146ADE43
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 10:49:29 +0200 (IST)
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: Tips on xfs creation on MIPS R5000 machine running Linux?
Date: Wed, 19 Sep 2007 10:48:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Message-Id: <20070919084929.0146ADE43@mail.edu.haifa.ac.il>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello All,


Finally I've got my hands on some nice R5000 Model O2 machine with IRIX 6.5
on it.

# hinv
CPU: MIPS R5000 Processor Chip Revision: 2.1
FPU: MIPS R5000 Floating Point Coprocessor Revision: 1.0
1 180 MHZ IP32 Processor
Main memory size: 256 Mbytes
Secondary unified instruction/data cache size: 512 Kbytes on Processor 0
Instruction cache size: 32 Kbytes
Data cache size: 32 Kbytes
FLASH PROM version 4.13
Integral SCSI controller 0: Version ADAPTEC 7880
  Disk drive: unit 1 on SCSI controller 0
  Disk drive: unit 2 on SCSI controller 0
  CDROM: unit 4 on SCSI controller 0
Integral SCSI controller 1: Version ADAPTEC 7880
On-board serial ports: tty1
On-board serial ports: tty2
On-board EPP/ECP parallel port
CRM graphics installed
Integral Ethernet: ec0, version 1
Iris Audio Processor: version A3 revision 0
Video: MVP unit 0 version 1.4
AV: AV1 Card version 1, O2Cam type 1 version 0 connected.
Vice: TRE

I'm intending to install Gentoo on this machine and I need some advice.

Following are the commands I've used to create and mount my partitions on
some old x86 PC.
a) Should I use the same values for all partitions on R5000 ?

1) Creating FS:
mkfs.xfs -l internal,size=128m -d agcount=2 –d unwritten=0 /dev/hda1

2) Mount options:
mount -o noatime,nodiratime,logbufs=8

Any suggestion for best performance configuration for XFS on this machine?

b) If I'd like to replace the old 2GB disk to some new 80GB disk. Would PROM
recognize it? Is there any special procedure?

c) Anyone has any experience with Gentoo on MIPS as a desktop system
(performance, device recognition (i.e. webcam) etc.)?


Best Regards,
Leon Kolchinsky
