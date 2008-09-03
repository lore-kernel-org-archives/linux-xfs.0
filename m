Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Sep 2008 23:53:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m836rdfD016127
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 23:53:41 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA00718 for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 16:55:05 +1000
Date: Wed, 03 Sep 2008 16:57:30 +1000
Subject: REVIEW: Change mkfs.xfs to set primary superblock inodes in ALL
 secondaries
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugv794p63jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

One peculiarity of mkfs.xfs that no-one has yet been able to explain
to me is that all the secondary superblocks do not contain the
primary superblock's root inode, realtime inodes and quota inodes.

The root inode is stored in the middle and last AG as well to
make things more unexpected.

The following makes all the secondaries the same as the primary
(other than the global counters).

---
  xfsprogs/mkfs/xfs_mkfs.c |   45  
+++++++++++++++------------------------------
  xfstests/030.out.linux   |   12 ------------
  xfstests/178.out         |   12 ------------
  3 files changed, 15 insertions(+), 54 deletions(-)

Index: ci/xfsprogs/mkfs/xfs_mkfs.c
===================================================================
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.c
+++ ci/xfsprogs/mkfs/xfs_mkfs.c
@@ -2397,33 +2397,20 @@ an AG size that is one stripe unit small
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
@@ -2432,13 +2419,11 @@ an AG size that is one stripe unit small
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
--- ci.orig/xfstests/030.out.linux
+++ ci/xfstests/030.out.linux
@@ -14,12 +14,6 @@ attempting to find secondary superblock.
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
@@ -132,12 +126,6 @@ attempting to find secondary superblock.
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
--- ci.orig/xfstests/178.out
+++ ci/xfstests/178.out
@@ -12,12 +12,6 @@ attempting to find secondary superblock.
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
@@ -48,12 +42,6 @@ attempting to find secondary superblock.
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
