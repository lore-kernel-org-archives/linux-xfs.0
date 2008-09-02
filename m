Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 22:39:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m825ddvk010703
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 22:39:40 -0700
Message-ID: <48BCD3BE.5040107@sgi.com>
Date: Tue, 02 Sep 2008 15:48:46 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Tweak tracing allocation sizes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

The size of a single ktrace entry is 16 pointers so 128 bytes.  For the case
of XFS_RW_KTRACE_SIZE which is 128 entries this equates to 16KB and on a system
with 4KB pages that is under memory pressure this can stall that process for a
significant time while it hunts for 4 free pages.  Cutting this value back to
32 means it will only need one page.

Initialize the ktrace system with a zone size of 32 so calls to ktrace_alloc()
that want 32 trace entries (ie 1 page) will go through the ktrace entry zone.
Bump INODE_TRACE_SIZE from 16 to 32 since if we are going to allocate half a
page we might as well give it a full page and have it allocate from the zone
too.

More can be done here but these changes reduce the liklihood of hitting
deadlocks due to memory pressure.

--- a/fs/xfs/linux-2.6/xfs_lrw.h	2008-09-02 15:28:27.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_lrw.h	2008-08-22 14:50:55.000000000 +1000
@@ -28,7 +28,7 @@ struct xfs_iomap;
 /*
  * Defines for the trace mechanisms in xfs_lrw.c.
  */
-#define	XFS_RW_KTRACE_SIZE	128
+#define	XFS_RW_KTRACE_SIZE	32
 
 #define	XFS_READ_ENTER		1
 #define	XFS_WRITE_ENTER		2

--- a/fs/xfs/linux-2.6/xfs_super.c	2008-09-02 15:28:27.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_super.c	2008-08-22 14:52:58.000000000 +1000
@@ -2151,7 +2151,7 @@ init_xfs_fs(void)
 
 	printk(message);
 
-	ktrace_init(64);
+	ktrace_init(32);
 	vn_init();
 	xfs_dir_startup();
 
--- a/fs/xfs/linux-2.6/xfs_vnode.h	2008-09-02 15:28:27.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_vnode.h	2008-08-22 14:52:14.000000000 +1000
@@ -126,7 +126,7 @@ static inline void vn_atime_to_time_t(st
  */
 #if defined(XFS_INODE_TRACE)
 
-#define	INODE_TRACE_SIZE	16		/* number of trace entries */
+#define	INODE_TRACE_SIZE	32		/* number of trace entries */
 #define	INODE_KTRACE_ENTRY	1
 #define	INODE_KTRACE_EXIT	2
 #define	INODE_KTRACE_HOLD	3
