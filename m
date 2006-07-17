Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 03:07:43 -0700 (PDT)
Received: from rproxy.teamix.net (team.teamix.net [194.150.191.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6HA7FDW017712
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 03:07:28 -0700
Received: from mango.of.teamix.net (unknown [172.21.123.1])
	(using TLSv1 with cipher EXP1024-RC4-SHA (56/128 bits))
	(No client certificate requested)
	by rproxy.teamix.net (Postfix) with ESMTP id AD04447E2B
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 09:05:48 +0000 (UTC)
From: Martin Steigerwald <ms@teamix.de>
Subject: Unfixable XFS defect - fatal error -- can't read block 16777216
Date: Mon, 17 Jul 2006 11:05:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607171105.46445.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello,

today I got a "E: Bus error" on my workstation and KDE went down as well as no 
files were accessible anymore. Like trying to run "bash" gives "Input/Output 
error". I have no idea what this was, why it happened and found no mention of 
it in the syslog.

I booted into Knoppix 5 and did an XFS check on the partition just to make 
sure it is okay. Well the root partition has some problems:

root@1[~]# xfs_check /dev/sda6
agi unlinked bucket 1 is 100033 in ag 0 (inode=100033)
[... some more of these ...]
bad free block nused 3 should be 8 for dir ino 58973313 block 16777216
[... I thought things like this shouldn't happen anymore)
missing free index for data block 0 in dir ino 100884318
missing free index for data block 1 in dir ino 100884318
missing free index for data block 2 in dir ino 100884318
missing free index for data block 3 in dir ino 100884318
missing free index for data block 4 in dir ino 100884318
missing free index for data block 5 in dir ino 100884318
missing free index for data block 6 in dir ino 100884318
missing free index for data block 7 in dir ino 100884318
missing free index for data block 8 in dir ino 100884318
missing free index for data block 9 in dir ino 100884318
missing free index for data block 10 in dir ino 100884318
missing free index for data block 11 in dir ino 100884318
missing free index for data block 12 in dir ino 100884318
missing free index for data block 13 in dir ino 100884318
missing free index for data block 14 in dir ino 100884318
missing free index for data block 32 in dir ino 100884318
agi unlinked bucket 2 is 964930 in ag 13 (inode=110016834)
allocated inode 207228 has 0 link count
[... some more of these ...]

Does not seem to be a big problem, but xfs_repair cannot repair it:

Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...

fatal error -- can't read block 16777216 for directory inode 100884318


I darkly recall having read about this problem here before, but I do not find 
the relevant mail anymore. Can anyone give me a pointer on where to look?

I am using kernel:

mango:~# uname -a
Linux mango 2.6.17.3-workstation-sws2-2.2.6-xfs-fix #1 PREEMPT Thu Jul 6 
12:50:38 CEST 2006 i686 GNU/Linux

which has the fix from
http://bugzilla.kernel.org/show_bug.cgi?id=6757

on a Dell Dimension 5100 with SATA controller:

mango:/home_lokal/ms# lspci
0000:00:00.0 Host bridge: Intel Corporation 945G/P Memory Controller Hub (rev 
02)
0000:00:01.0 PCI bridge: Intel Corporation 945G/P PCI Express Graphics Port 
(rev 02)
0000:00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller (rev 01)
0000:00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 1 (rev 01)
0000:00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#1 (rev 01)
[... some more of these ...]
0000:00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
0000:00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC 
Interface Bridge (rev 01)
0000:00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE 
Controller (rev 01)
0000:00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) 
Serial ATA Storage Controllers cc=IDE (rev 01)
0000:00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
(rev 01)
0000:01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 
[Radeon X300 (PCIE)]
0000:01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
0000:03:08.0 Ethernet controller: Intel Corporation 82801G (ICH7 Family) LAN 
Controller (rev 01)

Regards,
-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
