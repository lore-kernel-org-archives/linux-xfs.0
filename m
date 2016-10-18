Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45994 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932197AbcJRXr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 19:47:26 -0400
Date: Tue, 18 Oct 2016 16:47:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: v3 inodes are only valid on crc-enabled filesystems
Message-ID: <20161018234719.GF20337@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

>From 307ae950647d7db413c8e05dc17eb6aca9ef35d2 Mon Sep 17 00:00:00 2001
From: Roger Willcocks <roger@filmlight.ltd.uk>

xfs_repair was not detecting that version 3 inodes are invalid for
for non-CRC filesystems. The result is specific inode corruptions go
undetected and hence aren't repaired if only the version number is
out of range.

The core of the problem is that the XFS_DINODE_GOOD_VERSION() macro
doesn't know that valid inode versions are dependent on a superblock
version number. Fix this in libxfs, and propagate the new function
out into the rest of xfsprogs to fix the issue.

[dchinner: forward port from 3.2.4 to 4.2.0-rc1, move
xfs_dinode_good_version() to libxfs/xfs_inode-buf.c with all the
other dinode validation functions. ]

Reported-by: Leslie Rhorer <lrhorer@mygrande.net>
Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_format.h    |    1 -
 fs/xfs/libxfs/xfs_inode_buf.c |   13 ++++++++++++-
 fs/xfs/libxfs/xfs_inode_buf.h |    2 ++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f6547fc..6b7579e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -865,7 +865,6 @@ typedef struct xfs_timestamp {
  * padding field for v3 inodes.
  */
 #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
-#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
 typedef struct xfs_dinode {
 	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__be16		di_mode;	/* mode and type of file */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8de9a3a..134424f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -57,6 +57,17 @@ xfs_inobp_check(
 }
 #endif
 
+bool
+xfs_dinode_good_version(
+	struct xfs_mount *mp,
+	__u8		version)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return version == 3;
+
+	return version == 1 || version == 2;
+}
+
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
@@ -91,7 +102,7 @@ xfs_inode_buf_verify(
 
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_version);
+			xfs_dinode_good_version(mp, dip->di_version);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 62d9d46..3cfe12a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -74,6 +74,8 @@ void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
+bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
+
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
