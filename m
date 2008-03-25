Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 22:36:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P5ZjC3003408
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 22:35:47 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA03060 for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 16:36:19 +1100
Date: Tue, 25 Mar 2008 16:39:02 +1100
Subject: REVIEW: Write primary superblock info to ALL secondaries during mkfs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Message-ID: <op.t8j4nch93jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Secondaries should contain redundant information from the primary
superblock. It does this for the filesystem geometry information,
but not inode values (rootino, rt inos, quota inos).

This patch updates all the secondaries from the primary just before
it marks the filesystem as good to go.

Unfortunately, this also affects the output of xfs_repair during
QA 030 and 178 which restores the primary superblock from the
secondaries.

Now that the secondaries have valid inode values, xfs_repair
does not have to restore them to the correct values after copying
the secondary into the primary.

Attached is the mkfs.xfs patch and also the updated golden
outputs for QA 030 and 178.

The next step after this is to enhance xfs_repair to be more
thorough in checking the secondaries during Phase 1.

--

Index: ci/xfsprogs/mkfs/xfs_mkfs.c
===================================================================
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.c	2008-03-25 13:30:53.000000000 +1100
+++ ci/xfsprogs/mkfs/xfs_mkfs.c	2008-03-25 16:29:44.811095380 +1100
@@ -2397,48 +2397,32 @@
  	}

  	/*
-	 * Write out multiple secondary superblocks with rootinode field set
+	 * Write out secondary superblocks with inode fields set
  	 */
-	if (mp->m_sb.sb_agcount > 1) {
-		/*
-		 * the last superblock
-		 */
-		buf = libxfs_readbuf(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount-1,
-					XFS_SB_DADDR),
-				XFS_FSS_TO_BB(mp, 1),
-				LIBXFS_EXIT_ON_FAILURE);
-		INT_SET((XFS_BUF_TO_SBP(buf))->sb_rootino,
-				ARCH_CONVERT, mp->m_sb.sb_rootino);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-		/*
-		 * and one in the middle for luck
-		 */
-		if (mp->m_sb.sb_agcount > 2) {
-			buf = libxfs_readbuf(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount-1)/2,
-					XFS_SB_DADDR),
-				XFS_FSS_TO_BB(mp, 1),
-				LIBXFS_EXIT_ON_FAILURE);
-			INT_SET((XFS_BUF_TO_SBP(buf))->sb_rootino,
-				ARCH_CONVERT, mp->m_sb.sb_rootino);
-			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-		}
+	buf = libxfs_getsb(mp, LIBXFS_EXIT_ON_FAILURE);
+	XFS_BUF_TO_SBP(buf)->sb_inprogress = 0;
+
+	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
+		xfs_buf_t	*sbuf;
+
+		sbuf = libxfs_getbuf(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_SB_DADDR),
+				XFS_FSS_TO_BB(mp, 1));
+		memcpy(XFS_BUF_PTR(sbuf), XFS_BUF_PTR(buf),
+				XFS_BUF_SIZE(sbuf));
+		libxfs_writebuf(sbuf, LIBXFS_EXIT_ON_FAILURE);
  	}

  	/*
-	 * Dump all inodes and buffers before marking us all done.
-	 * Need to drop references to inodes we still hold, first.
+	 * Flush out all inodes and buffers before marking us all done.
  	 */
  	libxfs_rtmount_destroy(mp);
  	libxfs_icache_purge();
-	libxfs_bcache_purge();
+	libxfs_bcache_flush();

  	/*
-	 * Mark the filesystem ok.
+	 * Finalize the filesystem (sb_inprogress = 0 from above).
  	 */
-	buf = libxfs_getsb(mp, LIBXFS_EXIT_ON_FAILURE);
-	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
  	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);

  	libxfs_umount(mp);
Index: ci/xfstests/030.out.linux
===================================================================
--- ci.orig/xfstests/030.out.linux	2007-10-10 16:12:52.000000000 +1000
+++ ci/xfstests/030.out.linux	2008-03-25 16:30:54.926056313 +1100
@@ -14,12 +14,6 @@
  found candidate secondary superblock...
  verified secondary superblock...
  writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
-resetting superblock root inode pointer to INO
-sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
-sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
  Phase 2 - using <TYPEOF> log
          - zero log...
          - scan filesystem freespace and inode maps...
@@ -132,12 +126,6 @@
  found candidate secondary superblock...
  verified secondary superblock...
  writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
-resetting superblock root inode pointer to INO
-sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
-sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
  Phase 2 - using <TYPEOF> log
          - zero log...
          - scan filesystem freespace and inode maps...
Index: ci/xfstests/178.out
===================================================================
--- ci.orig/xfstests/178.out	2007-10-10 16:12:56.000000000 +1000
+++ ci/xfstests/178.out	2008-03-25 16:31:09.944120144 +1100
@@ -12,12 +12,6 @@
  found candidate secondary superblock...
  verified secondary superblock...
  writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
-resetting superblock root inode pointer to INO
-sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
-sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
  Phase 2 - using <TYPEOF> log
          - zero log...
          - scan filesystem freespace and inode maps...
@@ -48,12 +42,6 @@
  found candidate secondary superblock...
  verified secondary superblock...
  writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
-resetting superblock root inode pointer to INO
-sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
-sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
  Phase 2 - using <TYPEOF> log
          - zero log...
          - scan filesystem freespace and inode maps...
