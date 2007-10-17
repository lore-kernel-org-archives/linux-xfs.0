Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Oct 2007 21:58:07 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9H4vxwx009492
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2007 21:58:03 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l9H4w0vt011468
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 13:58:00 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l9H4u2SA023962
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 13:56:02 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l9H4u2f07733 for xfs@oss.sgi.com; Wed, 17 Oct 2007 13:56:02 +0900 (JST)
Received: from yonosuke.jp.nec.com (yonosuke.jp.nec.com [10.26.220.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l9H4u2B26717 for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 13:56:02 +0900 (JST)
Message-Id: <200710170456.AA06101@TNESG9305.wm.jp.nec.com>
Date: Wed, 17 Oct 2007 13:56:00 +0900
Subject: [PATCH] flush inode when changing atime.
From: Utako Kusaka <u-kusaka@wm.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

The atime is changed for reading but it returns to a previous value
after unmount. i_update_core is still off after reading a file using
read(), readdir() and readlink(). So an inode isn't flushed to disk.

I referred to following fix when I made a patch:
TAKE 946679 - fix, speedup and simplify atime handling
http://marc.info/?l=linux-xfs&m=113398234310217&w=4

Example:
# ls -lu mpnt/log3
-rw-r--r--  1 root root 63494 2007-04-05 16:35 mpnt/log3
# less mpnt/log3
# ls -lu mpnt/log3
-rw-r--r--  1 root root 63494 2007-10-05 15:27 mpnt/log3
# umount mpnt/
# mount -t xfs /dev/sda6 mpnt
# ls -lu mpnt/log3
-rw-r--r--  1 root root 63494 2007-04-05 16:35 mpnt/log3

--
Utako

Signed-off-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>
----------
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-10-15 15:50:10.000000000 +0900
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-10-15 16:49:35.000000000 +0900
@@ -1003,6 +1003,8 @@ xfs_readlink(
 		error = xfs_readlink_bmap(ip, link);
 	}
 
+	ip->i_update_core = 1;
+
  out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return error;
--- linux-2.6-xfs.orig/fs/xfs/xfs_dir2.c	2007-10-15 15:50:09.000000000 +0900
+++ linux-2.6-xfs/fs/xfs/xfs_dir2.c	2007-10-15 16:48:47.000000000 +0900
@@ -318,6 +318,9 @@ xfs_readdir(
 	else
 		rval = xfs_dir2_leaf_getdents(dp, dirent, bufsize, offset,
 					      filldir);
+
+	dp->i_update_core = 1;
+
 	return rval;
 }
 
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-10-15 15:50:10.000000000 +0900
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2007-10-15 16:50:50.000000000 +0900
@@ -275,6 +275,9 @@ xfs_read(
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
+	if (likely(!(ioflags & IO_INVIS)))
+		ip->i_update_core = 1;
 	return ret;
 }
 
----------
