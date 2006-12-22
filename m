Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 10:31:19 -0800 (PST)
Received: from cfa.harvard.edu (cfa.harvard.edu [131.142.10.1])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBMIVBqw010191
	for <linux-xfs@oss.sgi.com>; Fri, 22 Dec 2006 10:31:13 -0800
Received: from titan (titan [131.142.24.40])
	by cfa.harvard.edu (8.13.7/8.13.7/cfunix Mast-Sol 1.0) with ESMTP id kBMHgx8x000419
	for <linux-xfs@oss.sgi.com>; Fri, 22 Dec 2006 12:42:59 -0500 (EST)
Date: Fri, 22 Dec 2006 12:42:59 -0500 (EST)
From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Reply-To: gbakos@cfa.harvard.edu
Subject: unexpected XFS SB magic number
Message-ID: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Dear all,

I have a 12 x 500Gb RAID-5 hardware RAID array on an ARECA 1130-ML
controller. There is one single partition on it, exported as /dev/sdc1.
This configuration used to work fine for 4 months.
Then the computer crashed a couple of times, and led to a situation where

xfs_check /dev/sdc1 output is:

xfs_check: unexpected XFS SB magic number 0x45464920
xfs_check: size check failed
xfs_check: read failed: Invalid argument
xfs_check: data size check failed
xfs_check: failed to alloc 58876353264 bytes: Cannot allocate memory

I also checked the RAID, and seemingly the controller is fine; I can
communicate with it, all 12 disks are visible, their SMART status is
OK, the RAID-5 is reported to be in 'normal' condition, etc.

[root@localhost ~]# xfs_db -r /dev/sdc1
xfs_db: unexpected XFS SB magic number 0x45464920
xfs_db: size check failed
xfs_db: read failed: Invalid argument
xfs_db: data size check failed
xfs_db: failed to alloc 58876353264 bytes: Cannot allocate memory

--------------------

[root@localhost ~]# xfs_repair -nv /dev/sdc1

Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!
attempting to find secondary superblock...
................................................................................
...
....................found candidate secondary superblock...
unable to verify superblock, continuing...
...
....................found candidate secondary superblock...
verified secondary superblock...
would write modified primary superblock
Primary superblock would have been modified.
Cannot proceed further in no_modify mode.
Exiting now.

----------------


I would very much appreciate advice on how to proceed in such situation.
I worry that xfs_repair will repair, but may leave a mess that is hard
to recover. I am hoping there may be a safer way.


Best regards
Gaspar
