Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 02:47:11 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l979l6Zg016236
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 02:47:07 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1IeSj5-0002dR-AA
	for linux-xfs@oss.sgi.com; Sun, 07 Oct 2007 02:47:07 -0700
Message-ID: <13081228.post@talk.nabble.com>
Date: Sun, 7 Oct 2007 02:47:07 -0700 (PDT)
From: qon <blamaul@web.de>
Subject: Re: unexpected XFS SB magic number
In-Reply-To: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


I'm sorry this is quite late for you but I recently had exactly the same
problem and now finally found the solution. So this might help people that
will get the same error hopefully.

You used a GPT Partition Table. To protect the GPT table from os that do not
support is a standard mbr with msdos partition table is written to the disc
in front of the GPT table that indicates the whole disc space is used by an
unknown partition of 2TB (as msdos tables do not support larger partitions).

Linux recognizes GPT table when booting only when this is explicitly enable
in the Kernel (filesystem/partition types/efi). Though when creating a GPT
table using parted for example obviously when then rereading the partition
table the partition is recognized correctly. This might change after a
reboot as in you case. For me it then reportet a 2TB partition on my 2,X TB
harddisk and it could no longer mount my XFS filesystem. I ran xfs_check and
got exactly the same error as you (unexspected XFS SB). This is because it
tried to mount the partition in the fake msdos partition table of 2 tb that
startet exactly where the GPT table resides, so when looking for the
superblock it found the EFI Bootloader.

When you ran xfs_repair it of course found a superblock (may be even the
correct superblock), but all pointers are shiftet so it did not find any
files. Then you partition was reportet as 2tb partition after the repair,
because it used the partition size from the msdos table again.

So for me updateing the kernel to directly support efi tables solved the
problem.

qon



Gaspar Bakos wrote:
> 
> Dear all,
> 
> I have a 12 x 500Gb RAID-5 hardware RAID array on an ARECA 1130-ML
> controller. There is one single partition on it, exported as /dev/sdc1.
> This configuration used to work fine for 4 months.
> Then the computer crashed a couple of times, and led to a situation where
> 
> xfs_check /dev/sdc1 output is:
> 
> xfs_check: unexpected XFS SB magic number 0x45464920
> xfs_check: size check failed
> xfs_check: read failed: Invalid argument
> xfs_check: data size check failed
> xfs_check: failed to alloc 58876353264 bytes: Cannot allocate memory
> 
> I also checked the RAID, and seemingly the controller is fine; I can
> communicate with it, all 12 disks are visible, their SMART status is
> OK, the RAID-5 is reported to be in 'normal' condition, etc.
> 
> [root@localhost ~]# xfs_db -r /dev/sdc1
> xfs_db: unexpected XFS SB magic number 0x45464920
> xfs_db: size check failed
> xfs_db: read failed: Invalid argument
> xfs_db: data size check failed
> xfs_db: failed to alloc 58876353264 bytes: Cannot allocate memory
> 
> --------------------
> 
> [root@localhost ~]# xfs_repair -nv /dev/sdc1
> 
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> attempting to find secondary superblock...
> ................................................................................
> ...
> ....................found candidate secondary superblock...
> unable to verify superblock, continuing...
> ...
> ....................found candidate secondary superblock...
> verified secondary superblock...
> would write modified primary superblock
> Primary superblock would have been modified.
> Cannot proceed further in no_modify mode.
> Exiting now.
> 
> ----------------
> 
> 
> I would very much appreciate advice on how to proceed in such situation.
> I worry that xfs_repair will repair, but may leave a mess that is hard
> to recover. I am hoping there may be a safer way.
> 
> 
> Best regards
> Gaspar
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/unexpected-XFS-SB-magic-number-tf2871877.html#a13081228
Sent from the linux-xfs mailing list archive at Nabble.com.
