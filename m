Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 May 2008 18:13:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m481D0s0018823
	for <xfs@oss.sgi.com>; Wed, 7 May 2008 18:13:02 -0700
Subject: TAKE 981296 - Fix fsync() b0rkage.
Message-Id: <20080508011342.2710A58C4C15@chook.melbourne.sgi.com>
Date: Thu,  8 May 2008 11:13:42 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix fsync() b0rkage.

xfs_fsync() fails to wait for data I/O completion before checking if
the inode is dirty or clean to decide whether to log the inode or not.
This misses inode size updates when the data flushed by the fsync()
is extending the file.

Hence, like fdatasync(), we need to wait for I/o completion first,
then check the inode for cleanliness. Doing so makes the behaviour of
xfs_fsync() identical for fsync and fdatasync and we *always* use
synchronous semantics if the inode is dirty. Therefore also kill the
differences and remove the unused flags from the xfs_fsync function
and callers.


Date:  Thu May  8 11:13:29 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31033a
fs/xfs/xfs_vnodeops.c - 1.758 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.758&r2=text&tr2=1.757&f=h
	- fix xfs_fsync() to make fsync wait for data I/O completion and inode size
	  updates correctly.

fs/xfs/linux-2.6/xfs_file.c - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
	- fsync and fdatasync are implemented identically now.

fs/xfs/linux-2.6/xfs_vnode.h - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
	- remove xfs_fsync() flags are they are unused now.

fs/xfs/dmapi/xfs_dm.c - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
	- clean up xfs_fsync() usage.

fs/xfs/xfs_vnodeops.h - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- remove unused flags from xfs_fsync().
