Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 15:14:17 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBBNEAB3007751
	for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 15:14:12 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3644810FA446
	for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 15:14:20 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id SechnEgai1hzDiZq for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 15:14:20 -0800 (PST)
Received: from [192.168.1.21] (dslb-084-056-075-184.pools.arcor-ip.net [84.56.75.184])
	by mail.lichtvoll.de (Postfix) with ESMTP id 3799A5ADDC
	for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 23:40:41 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: write barrier over device mapper supported or not?
Date: Tue, 11 Dec 2007 23:42:23 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712112342.24094.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello!

Are write barriers over device mapper supported or not?

On LVM2 xfs tells me:

Dec 11 23:00:09 shambala kernel: Filesystem "dm-0": Disabling barriers, 
not supported by the underlying device
Dec 11 23:00:09 shambala kernel: XFS mounting filesystem dm-0
Dec 11 23:00:09 shambala kernel: Ending clean XFS mount for filesystem: 
dm-0

But when I mount ext3 on LVM2 I get:

Dec 11 23:05:34 shambala kernel: kjournald starting.  Commit interval 5 
seconds
Dec 11 23:05:34 shambala kernel: EXT3 FS on dm-1, internal journal
Dec 11 23:05:34 shambala kernel: EXT3-fs: mounted filesystem with ordered 
data mode.

even when I explicetely specify "-o barrier=1" which should enable 
barriers on ext3.

As far as I understood from the changelogs as I wrote my Linux-Magazin I 
thought there should be device mapper support in the kernel, but I can 
not reproduce that finding anymore at the moment.

But back then I also looked at the ext3 / jbd sources and found that jbd 
issues a warning when barrier support is not available. However I do not 
find that one either.

And when I use reisferfs it also seems that write barriers are not 
available over LVM2:

Dec 11 23:34:58 shambala kernel: ReiserFS: dm-2: found reiserfs 
format "3.6" with standard journal
Dec 11 23:34:58 shambala kernel: ReiserFS: dm-2: using ordered data mode
Dec 11 23:34:58 shambala kernel: reiserfs: using flush barriers
Dec 11 23:34:58 shambala kernel: ReiserFS: dm-2: journal params: device 
dm-2, size 8192, journal first block 18, max trans len 1024, max batch 
900, max commit age 30, max trans age 30
Dec 11 23:34:58 shambala kernel: ReiserFS: dm-2: checking transaction log 
(dm-2)
Dec 11 23:35:01 shambala kernel: reiserfs: disabling flush barriers on 
dm-2
Dec 11 23:35:01 shambala kernel: ReiserFS: dm-2: Using r5 hash to sort 
names
Dec 11 23:35:01 shambala kernel: ReiserFS: dm-2: warning: 
Created .reiserfs_priv on dm-2 - reserved for xattr storage.

Hmmm... too bad... means I will likely not use LVM on my next laptop 
harddisk. I think I should file a kernel bug report about that. Anyone 
knows of any plans to support write barriers via device mapper? Well I 
guess I should ask on dm-devel or so if such a mailinglist exists.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
