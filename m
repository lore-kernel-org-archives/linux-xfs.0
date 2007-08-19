Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Aug 2007 23:05:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7J64vbm017531
	for <xfs@oss.sgi.com>; Sat, 18 Aug 2007 23:04:58 -0700
Received: from Liberator.local (unknown [10.0.0.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id D439B18DF93BD
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 01:05:01 -0500 (CDT)
Message-ID: <46C7DD96.6030001@sandeen.net>
Date: Sun, 19 Aug 2007 01:05:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] optimize dmapi event tests w/o dmapi config
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Defining XFS_DM_EVENT* macros to 0 in the absence of 
CONFIG_XFS_DMAPI allows gcc to optimize away tests that 
should never be true. Also wrap one hunk of xfs_unmount 
in #ifdef CONFIG_XFS_DMAPI

Stack deltas on x86, gcc 4.1:

xfs_create		-16
xfs_free_file_space	-4
xfs_getbmap		+4
xfs_link		-8
xfs_mkidr		-20
xfs_read		-24
xfs_remove		-12
xfs_rename		-8
xfs_rmdir		-16
xfs_setattr		-20
xfs_splice_read		-20
xfs_splice_write	-20
xfs_unmount		-48
xfs_write		-20

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.22.i386/fs/xfs/xfs_dmapi.h
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_dmapi.h
+++ linux-2.6.22.i386/fs/xfs/xfs_dmapi.h
@@ -66,6 +66,7 @@ typedef enum {
 } dm_right_t;
 #define HAVE_DM_RIGHT_T
 
+#ifdef CONFIG_XFS_DMAPI
 /* Defines for determining if an event message should be sent. */
 #define	DM_EVENT_ENABLED(vfsp, ip, event) ( \
 	unlikely ((vfsp)->vfs_flag & VFS_DMI) && \
@@ -78,6 +79,11 @@ typedef enum {
 		( ((io)->io_dmevmask & (1 << event)) || \
 		  ((io)->io_mount->m_dmevmask & (1 << event)) ) \
 	)
+#else
+#define DM_EVENT_ENABLED(vfsp, ip, event) (0)
+#define DM_EVENT_ENABLED_IO(vfsp, io, event) (0)
+#endif
+
 
 #define DM_XFS_VALID_FS_EVENTS		( \
 	(1 << DM_EVENT_PREUNMOUNT)	| \
Index: linux-2.6.22.i386/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_vfsops.c
+++ linux-2.6.22.i386/fs/xfs/xfs_vfsops.c
@@ -568,6 +568,7 @@ xfs_unmount(
 	rip = mp->m_rootip;
 	rvp = XFS_ITOV(rip);
 
+#ifdef CONFIG_XFS_DMAPI
 	if (vfsp->vfs_flag & VFS_DMI) {
 		error = XFS_SEND_PREUNMOUNT(mp, vfsp,
 				rvp, DM_RIGHT_NULL, rvp, DM_RIGHT_NULL,
@@ -580,7 +581,7 @@ xfs_unmount(
 		unmount_event_flags = (mp->m_dmevmask & (1<<DM_EVENT_UNMOUNT))?
 					0 : DM_FLAGS_UNWANTED;
 	}
-
+#endif
 	/*
 	 * First blow any referenced inode from this file system
 	 * out of the reference cache, and delete the timer.
