Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:56:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9u0M2024513
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:56:02 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BB13331A2B
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:11 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id mOzsppPBDNBWN4kJ for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:11 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q9v1Ng031877
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 11:57:01 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q9v1D4031875
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 11:57:01 +0200
Date: Sat, 26 Jul 2008 11:57:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] move root inode IRELE into xfs_unmountfs
Message-ID: <20080726095701.GA31858@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The root inode is allocated in xfs_mountfs so it should be release in
xfs_unmountfs.  For the unmount case that means we do it after the
the xfs_sync(mp, SYNC_WAIT | SYNC_CLOSE) in the forced shutdown case
and the dmapi unmount event.  Note that both reference the rip variable
which might be freed by that time in case inode flushing has kicked in,
so strictly speaking this might count as a bug fix


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-26 09:08:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-26 09:21:25.000000000 +0200
@@ -1182,8 +1182,6 @@ xfs_fs_put_super(
 	error = xfs_unmount_flush(mp, 0);
 	WARN_ON(error);
 
-	IRELE(rip);
-
 	/*
 	 * If we're forcing a shutdown, typically because of a media error,
 	 * we want to make sure we invalidate dirty pages that belong to
@@ -1683,8 +1681,6 @@ xfs_fs_fill_super(
 	error = xfs_unmount_flush(mp, 0);
 	WARN_ON(error);
 
-	IRELE(mp->m_rootip);
-
 	xfs_unmountfs(mp);
 	goto out_free_fsname;
 }
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-07-26 09:02:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-07-26 09:27:36.000000000 +0200
@@ -1250,6 +1250,8 @@ xfs_unmountfs(xfs_mount_t *mp)
 	__uint64_t	resblks;
 	int		error = 0;
 
+	IRELE(mp->m_rootip);
+
 	/*
 	 * We can potentially deadlock here if we have an inode cluster
 	 * that has been freed has it's buffer still pinned in memory because
