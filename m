Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36957 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751877AbdH2XvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:02 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002cz-SM
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005WD-RB
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/42] mkfs: factor secondary superblock updates
Date: Wed, 30 Aug 2017 09:50:28 +1000
Message-Id: <20170829235052.21050-19-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 63 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 13af1ef1cd41..1fd5108be520 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2468,6 +2468,39 @@ initialise_ag_freespace(
 	libxfs_trans_commit(tp);
 }
 
+/*
+ * rewrite several secondary superblocks with the root inode number filled out.
+ * This can help repair recovery from a trashed primary superblock without
+ * losing the root inode.
+ */
+static void
+rewrite_secondary_superblocks(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*buf;
+
+	/* rewrite the last superblock */
+	buf = libxfs_readbuf(mp->m_dev,
+			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
+				XFS_SB_DADDR),
+			XFS_FSS_TO_BB(mp, 1),
+			LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
+	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+	/* and one in the middle for luck if there's enough AGs for that */
+	if (mp->m_sb.sb_agcount <= 2)
+		return;
+
+	buf = libxfs_readbuf(mp->m_dev,
+			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
+				XFS_SB_DADDR),
+			XFS_FSS_TO_BB(mp, 1),
+			LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
+	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+}
+
 int
 main(
 	int			argc,
@@ -3688,34 +3721,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	}
 
 	/*
-	 * Write out multiple secondary superblocks with rootinode field set
+	 * Re-write multiple secondary superblocks with rootinode field set
 	 */
-	if (mp->m_sb.sb_agcount > 1) {
-		/*
-		 * the last superblock
-		 */
-		buf = libxfs_readbuf(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount-1,
-					XFS_SB_DADDR),
-				XFS_FSS_TO_BB(mp, 1),
-				LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
-		XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(
-							mp->m_sb.sb_rootino);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-		/*
-		 * and one in the middle for luck
-		 */
-		if (mp->m_sb.sb_agcount > 2) {
-			buf = libxfs_readbuf(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount-1)/2,
-					XFS_SB_DADDR),
-				XFS_FSS_TO_BB(mp, 1),
-				LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
-			XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(
-							mp->m_sb.sb_rootino);
-			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-		}
-	}
+	if (mp->m_sb.sb_agcount > 1)
+		rewrite_secondary_superblocks(mp);
 
 	/*
 	 * Dump all inodes and buffers before marking us all done.
-- 
2.13.3

