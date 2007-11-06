Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 06:41:35 -0800 (PST)
Received: from r2d2.neofacto.lu (mail.neofacto.lu [158.64.60.195])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6EfULA018283
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 06:41:32 -0800
Received: from localhost (localhost [127.0.0.1])
	by r2d2.neofacto.lu (Postfix) with ESMTP id 323CCC2F3E
	for <xfs@oss.sgi.com>; Tue,  6 Nov 2007 15:09:14 +0100 (CET)
Received: from r2d2.neofacto.lu ([127.0.0.1])
	by localhost (r2d2.neofacto.lu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cYvlIgzHPDPY for <xfs@oss.sgi.com>;
	Tue,  6 Nov 2007 15:09:00 +0100 (CET)
Received: from [192.168.1.166] (SU105.tudor.lu [158.64.4.205])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by r2d2.neofacto.lu (Postfix) with ESMTP id 80341C2F49
	for <xfs@oss.sgi.com>; Tue,  6 Nov 2007 14:58:15 +0100 (CET)
Message-ID: <473072FD.4070104@jamendo.com>
Date: Tue, 06 Nov 2007 14:58:21 +0100
From: Amandine AUPETIT <amandine@jamendo.com>
MIME-Version: 1.0
Subject: 7Tb XFS partition lost on reboot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi !
(I'm on Ubuntu 7.10 64 bits)
I have array of 12 750gb disks in hardware Raid 6 that gives me a 7Tb 
partition. I tried to format it in ext3, but it took too much time, so I 
tried in Reiserfs, but the partition were lost on reboot, and now i'm 
trying XFS.

So I created the partition with parted, because fdisk can't do more that 
2tb partitions.
It's ok, I can do what I want but...

on reboot, there is a Superblock problem, something like that. When I 
check with xfs_check :

xfs_check: unexpected XFS SB magic number 0x00000000
xfs_check: read failed: Invalid argument
xfs_check: data size check failed
cache_node_purge: refcount was 1, not zero (node=0x681420)
xfs_check: cannot read root inode (22)
bad superblock magic number 0, giving up

So, I tried to delete the partition with parted, to recreate a new one. 
No problem. But when I mount the new partition, all the data that were 
on my deleted partition are there !!! That's of course not a problem, 
but I'm wondering if there's a way to have this partition work directly 
without having to delete and recreate it ?

I checked the /proc/partition before and after doing parted :

BEFORE
major minor  #blocks  name
 104     0   35532720 cciss/c0d0
 104     1   34025638 cciss/c0d0p1
 104     2          1 cciss/c0d0p2
 104     5    1502046 cciss/c0d0p5
 105     0 7325417080 cciss/c1d0
 105     1  [B]882966102[/B] cciss/c1d0p1

AFTER
major minor  #blocks  name
 104     0   35532720 cciss/c0d0
 104     1   34025638 cciss/c0d0p1
 104     2          1 cciss/c0d0p2
 104     5    1502046 cciss/c0d0p5
 105     0 7325417080 cciss/c1d0
 105     1 [B]7325417046[/B] cciss/c1d0p1


So, any idea what I could do ?

Thanks a lot
Amandine
