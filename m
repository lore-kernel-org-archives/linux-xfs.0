Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6582A7F91
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 15:43:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 548328F8035
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 13:43:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SOGyxkdUDRuOXVuS for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 13:43:11 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Y8yNe-0005HU-0w
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:06 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Y8yNe-0001uG-0B
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: move struct xfs_bmalloca to libxfs
Date: Thu,  8 Jan 2015 08:43:02 +1100
Message-Id: <1420666983-7275-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1420666983-7275-1-git-send-email-david@fromorbit.com>
References: <1420666983-7275-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

It no long is used for stack splits, so strip the kernel workqueue
bits from it and push it back into libxfs/xfs_bmap.h so that
it can be shared with the userspace code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.h | 31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h   | 35 +----------------------------------
 2 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 44db6db..856f53c 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -28,6 +28,37 @@ struct xfs_trans;
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
 /*
+ * Argument structure for xfs_bmap_alloc.
+ */
+struct xfs_bmalloca {
+	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
+	struct xfs_bmap_free	*flist;	/* bmap freelist */
+	struct xfs_trans	*tp;	/* transaction pointer */
+	struct xfs_inode	*ip;	/* incore inode pointer */
+	struct xfs_bmbt_irec	prev;	/* extent before the new one */
+	struct xfs_bmbt_irec	got;	/* extent after, or delayed */
+
+	xfs_fileoff_t		offset;	/* offset in file filling in */
+	xfs_extlen_t		length;	/* i/o length asked/allocated */
+	xfs_fsblock_t		blkno;	/* starting block of new extent */
+
+	struct xfs_btree_cur	*cur;	/* btree cursor */
+	xfs_extnum_t		idx;	/* current extent index */
+	int			nallocs;/* number of extents alloc'd */
+	int			logflags;/* flags for transaction logging */
+
+	xfs_extlen_t		total;	/* total blocks needed for xaction */
+	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
+	xfs_extlen_t		minleft; /* amount must be left after alloc */
+	bool			eof;	/* set if allocating past last extent */
+	bool			wasdel;	/* replacing a delayed allocation */
+	bool			userdata;/* set if is user data */
+	bool			aeof;	/* allocated space at eof */
+	bool			conv;	/* overwriting unwritten extents */
+	int			flags;
+};
+
+/*
  * List of extents to be free "later".
  * The list is kept sorted on xbf_startblock.
  */
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 2fdb72d..1fce0f3 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -26,40 +26,7 @@ struct xfs_ifork;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
-
-/*
- * Argument structure for xfs_bmap_alloc.
- */
-struct xfs_bmalloca {
-	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
-	struct xfs_bmap_free	*flist;	/* bmap freelist */
-	struct xfs_trans	*tp;	/* transaction pointer */
-	struct xfs_inode	*ip;	/* incore inode pointer */
-	struct xfs_bmbt_irec	prev;	/* extent before the new one */
-	struct xfs_bmbt_irec	got;	/* extent after, or delayed */
-
-	xfs_fileoff_t		offset;	/* offset in file filling in */
-	xfs_extlen_t		length;	/* i/o length asked/allocated */
-	xfs_fsblock_t		blkno;	/* starting block of new extent */
-
-	struct xfs_btree_cur	*cur;	/* btree cursor */
-	xfs_extnum_t		idx;	/* current extent index */
-	int			nallocs;/* number of extents alloc'd */
-	int			logflags;/* flags for transaction logging */
-
-	xfs_extlen_t		total;	/* total blocks needed for xaction */
-	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
-	xfs_extlen_t		minleft; /* amount must be left after alloc */
-	bool			eof;	/* set if allocating past last extent */
-	bool			wasdel;	/* replacing a delayed allocation */
-	bool			userdata;/* set if is user data */
-	bool			aeof;	/* allocated space at eof */
-	bool			conv;	/* overwriting unwritten extents */
-	int			flags;
-	struct completion	*done;
-	struct work_struct	work;
-	int			result;
-};
+struct xfs_bmalloca;
 
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 			int *committed);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
