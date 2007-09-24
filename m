Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 17:20:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8O0KKQ3028297
	for <linux-xfs@oss.sgi.com>; Sun, 23 Sep 2007 17:20:23 -0700
Message-ID: <46F7032E.9010004@sgi.com>
Date: Mon, 24 Sep 2007 10:22:06 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE - 964316: Dmapi get_bulkall appears to return incorrect inode
 information
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

get_bulkall() could return incorrect inode state

In the following scenario xfs_bulkstat() returns incorrect
stale inode state:

1. File_A is created and its inode synced to disk.
2. File_A is unlinked and doesn't exist anymore.
3. Filesystem sync is invoked.
4. File_B is created. File_B happens to reclaim File_A's inode.
5. xfs_bulkstat() is called and detects File_B but reports the
 incorrect File_A inode state.

Explanation for the incorrect inode state is that inodes are not immediately
synced on file create for performance reasons. This leaves the on-disk inode
buffer uninitialized (or with old state from a previous generation inode)
and this is what xfs_bulkstat() would report.

The patch marks the on-disk inode buffer "dirty" on unlink. When the inode
is reclaimed (by a new file create), xfs_bulkstat() would filter this inode
by the "dirty" mark. Once the inode is flushed to disk, the on-disk buffer
"dirty" mark is automatically removed and a following xfs_bulkstat() would
return the correct inode state.

Marking the on-disk inode buffer "dirty" on unlink is achieved by 
setting the
on-disk di_nlink field to 0. Note that the in-core di_nlink has already been
set to 0 and a corresponding transaction logged by xfs_droplink().
This is an exception from the rule that any on-disk inode buffer changes
has to be followed by a disk write (inode flush).
Synchronizing the in-core to on-disk di_nlink values in advance (before the
actual inode flush to disk) should be fine in this case because the inode
is already unlinked and it would never change its di_nlink again for this
inode generation.


Date:  Mon Sep 24 10:14:37 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs1
Inspected by:  tes, dgc, markgw, aelder, hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29757a
fs/xfs/xfs_itable.c - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
    - pv 964316 - get_bulkall() could return incorrect inode stat

fs/xfs/xfs_inode.c - 1.483 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.483&r2=text&tr2=1.482&f=h
    - pv 964316 - get_bulkall() could return incorrect inode stat
