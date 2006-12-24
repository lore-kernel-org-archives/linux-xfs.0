Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Dec 2006 22:09:49 -0800 (PST)
Received: from cfa.harvard.edu (cfa.harvard.edu [131.142.10.1])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBO69gqw014284
	for <linux-xfs@oss.sgi.com>; Sat, 23 Dec 2006 22:09:43 -0800
Date: Sun, 24 Dec 2006 01:08:44 -0500 (EST)
From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Reply-To: gbakos@cfa.harvard.edu
Subject: Re: unexpected XFS SB magic number
In-Reply-To: <458DF8F7.5030104@sandeen.net>
Message-ID: <Pine.SOL.4.58.0612240053080.3446@titan.cfa.harvard.edu>
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
 <458C6719.6080106@sandeen.net> <Pine.SOL.4.58.0612221824500.2856@titan.cfa.harvard.edu>
 <458C6C5A.6090504@sandeen.net> <Pine.SOL.4.58.0612231748450.3446@titan.cfa.harvard.edu>
 <458DF8F7.5030104@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

Hi, Eric,

RE:
> Well, something put a gpt label on top of your xfs partition... and it
> wasn't xfs :)

After some contemplation I allowed xfs_repair to make an attempt.
It seems that nothing was recovered.

If found a secondary suplerblock, and then lot of message followed ...
(attached).

The repaired XFS filesystem is 2Tb in size (as opposed to the 5TB), and
0% is used:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdd1            2147352448       528 2147351920   1% /mnt/ar1/un0

After the recovery parted reports:
Error: Unable to open /dev/sdd - unrecognised disk label.

( For parted /dev/sdd1: partition type reported as 'loop'. _

fdisk reports GPT partition type for /dev/sdd:

[root@cfhat7 xfs]# fdisk -l /dev/sdd
WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'!
The util fdisk doesn't support GPT. Use GNU Parted.
Disk /dev/sdd: 4999.9 GB, 4999998341120 bytes
255 heads, 63 sectors/track, 607881 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      267350  2147483647+  ee  EFI GPT

---------
So all this is a great mess.
parted is supposed to be better than fdisk, yet it does not recognize
what fdisk does?

Now having lost all the data, I may start experimenting if I can
reproduce this.

Gaspar
