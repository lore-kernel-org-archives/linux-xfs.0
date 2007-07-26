Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 14:09:26 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6QL9Mbm028849
	for <linux-xfs@oss.sgi.com>; Thu, 26 Jul 2007 14:09:23 -0700
Received: from localhost (dslb-084-056-125-167.pools.arcor-ip.net [84.56.125.167])
	by mail.lichtvoll.de (Postfix) with ESMTP id 648665ADEE
	for <linux-xfs@oss.sgi.com>; Thu, 26 Jul 2007 23:10:17 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_fsr and null byte areas in files
Date: Thu, 26 Jul 2007 23:09:23 +0200
References: <200707092313.48876.Martin@lichtvoll.de> <20070710005030.GQ31489@sgi.com> (sfid-20070710_091332_436725_890FB700)
In-Reply-To: <20070710005030.GQ31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262309.24012.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 10 Juli 2007 schrieb David Chinner:

> > 1) Is there an XFS qa test available for xfs_fsr? If so I could use
> > that one. Are there some hints on how to get started on XFS qa?
>
> Yes, test 042. Download it from CVS, build it (installing all the
> bits it asks for ;), edit common.config to add your test and scratch
> partitions (both volatile) and the 'check -l 042' to run test 042.

Hi!

I ran test 42 and it completes successfully.

shambala:Quelltext/xfs-cmds/xfstests> ./check -l 42
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 localhost 2.6.21.6-tp42-cfs-v19-sws2-2.2.10
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda3
MOUNT_OPTIONS -- /dev/sda3 /mnt/zeit

042     Passed all 0 tests


shambala:Quelltext/xfs-cmds/xfstests> ./check -l 42
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 localhost 2.6.21.6-tp42-cfs-v19-sws2-2.2.10
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda3
MOUNT_OPTIONS -- /dev/sda3 /mnt/zeit

042
Passed all 1 tests
shambala:Quelltext/xfs-cmds/xfstests> ./check 42
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 localhost 2.6.21.6-tp42-cfs-v19-sws2-2.2.10
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda3
MOUNT_OPTIONS -- /dev/sda3 /mnt/zeit

042 154s ...
Passed all 1 tests


(I ran it another time, with the same good result and I think I will run 
it some more times in the next days...)

On one side thats good. On the other side, I still do not know how lots of 
Bazaar and Mercurial repositories and about 200-300 other files god 
trashed with null byte areas in them.

I am reluctant to try xfs_fsr on those partitions again since they contain 
my operating system and user data. Only thing that could work to 
reproduce this IMHO is doing a backup right before running xfs_fsr, then 
run xfs_fsr on a partition I have in daily use, and afterwards compare 
the file data with rsync -acn. When it finds broken files I could put 
them in some place and restore my data with rsync -ac (without -n). But 
honestly I am not sure whether I want to go through that hassle. It would 
easily take half a day or more and may reduce the redundancy of my data 
temporarily since one copy of it may get trashed partly.

I am not sure whether there is a sensible easier way on how to try to 
reproduce this. Maybe it really hadn't anything to do with xfs_fsr, but 
then I have no other idea what could have touched all those files and 
wrote zeros in them.

Anyway right now I have no proof of any misbehavior of xfs_fsr and I want 
to note that here clearly!

I thank you, David, Timothy, Eric and Justin for hints and help with 
setting up this test so that it can run here. Thanks for the patch to run 
without scratch device, Timothy. I really appreciate your help.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
