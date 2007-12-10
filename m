Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 14:20:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lBAMK7l9018129
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:20:08 -0800
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 27D6BB24B0B
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:00:32 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com with SMTP id uBG2TS0yRDZlXYv2 for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:00:32 -0800 (PST)
From: "Chris" <hsvchris@gmx.de>
Subject: Unexpected XFS SB number 0x00000000
Date: Mon, 10 Dec 2007 22:33:35 +0100
Message-ID: <002a01c83b74$52060330$f6120990$@de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: de
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello!

I'm running a home file server with Debian GNU/Linux 4.0 4.0r1 etch
(2.6.18-5-amd64 Kernel) and an Areca ARC-1220 hardware RAID controller.
I used to have 4 750GB HDDs connected and set up as RAID 5 array, single
volume, single XFS partition (set up during the installation of Debian). No
problems so far.

Now I added another 750GB HDD to the array, online capacity/volume expansion
by the controller finished just fine.
My plan was to add the extra space to the above mentioned XFS partition. So
I unmounted the partition, started cfdisk, removed the partition table and
wrote a new one that included the new free space. 
After rebooting the partition wasn't mounted, so I couldn't use xfs_growth
to expand the filesystem.  

xfs_check: unexpected XFS SB magic number 0x00000000

xfs_repair -n:
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!
attempting to find secondary superblock.......[...].............found
candidate secondary superblock...unable to verify superblock,
continuing..........[...]................
.......Sorry, could not find valid secondary superblock
Exciting now.

I realize the magic number 0x00000000 is probably not a good thing and maybe
using fdisk to write a new table was not the way to do it?
Any suggestions on restoring the old partition table / magic number or how
to proceed? Is there an easy fix or is this a serious problem?

Kind Regards,
Chris
