Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 070D829E14
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C25E2304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9H45QGRGVrFka9Qk for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:57 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxa-0006Ov-29
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxa-0002Fy-1K
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/32] libxfs: unify xfs_btree.c with kernel code
Date: Mon, 30 Sep 2013 13:15:24 +1000
Message-Id: <1380510944-8571-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

The libxfs/xfs_btree.c code does not contain a small amount of code
for btree block readahead that the kernel code does. Instead, it
short circuits it at a higher layer and doesn't include the lower
layer functions. There is no harm in calling the lower lay functions
and have them do nothing, and doing so unifies the kernel and
userspace code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs.h       |  8 +++++---
 libxfs/xfs_btree.c | 48 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 31acf1b..364fd83 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -319,10 +319,12 @@ roundup_64(__uint64_t x, __uint32_t y)
 
 #define xfs_trans_buf_copy_type(dbp, sbp)
 
-#define xfs_buf_readahead(a,b,c,ops)		((void) 0)	/* no readahead */
+/* no readahead, need to avoid set-but-unused var warnings. */
+#define xfs_buf_readahead(a,d,c,ops)		({	\
+	xfs_daddr_t __d = d;				\
+	__d = __d; /* no set-but-unused warning */	\
+})
 #define xfs_buf_readahead_map(a,b,c,ops)	((void) 0)	/* no readahead */
-#define xfs_btree_reada_bufl(m,fsb,c,ops)	((void) 0)
-#define xfs_btree_reada_bufs(m,fsb,c,x,ops)	((void) 0)
 #define xfs_buftrace(x,y)			((void) 0)	/* debug only */
 
 #define xfs_cmn_err(tag,level,mp,fmt,args...)	cmn_err(level,fmt, ## args)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0099926..ce149ad 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -396,7 +396,6 @@ static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 			return XFS_BTREE_LBLOCK_CRC_LEN;
 		return XFS_BTREE_LBLOCK_LEN;
 	}
-
 	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS)
 		return XFS_BTREE_SBLOCK_CRC_LEN;
 	return XFS_BTREE_SBLOCK_LEN;
@@ -493,7 +492,7 @@ xfs_btree_ptr_addr(
 }
 
 /*
- * Get a the root block which is stored in the inode.
+ * Get the root block which is stored in the inode.
  *
  * For now this btree implementation assumes the btree root is always
  * stored in the if_broot field of an inode fork.
@@ -716,6 +715,46 @@ xfs_btree_read_bufl(
 	return 0;
 }
 
+/*
+ * Read-ahead the block, don't wait for it, don't return a buffer.
+ * Long-form addressing.
+ */
+/* ARGSUSED */
+void
+xfs_btree_reada_bufl(
+	struct xfs_mount	*mp,		/* file system mount point */
+	xfs_fsblock_t		fsbno,		/* file system block number */
+	xfs_extlen_t		count,		/* count of filesystem blocks */
+	const struct xfs_buf_ops *ops)
+{
+	xfs_daddr_t		d;
+
+	ASSERT(fsbno != NULLFSBLOCK);
+	d = XFS_FSB_TO_DADDR(mp, fsbno);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, ops);
+}
+
+/*
+ * Read-ahead the block, don't wait for it, don't return a buffer.
+ * Short-form addressing.
+ */
+/* ARGSUSED */
+void
+xfs_btree_reada_bufs(
+	struct xfs_mount	*mp,		/* file system mount point */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_agblock_t		agbno,		/* allocation group block number */
+	xfs_extlen_t		count,		/* count of filesystem blocks */
+	const struct xfs_buf_ops *ops)
+{
+	xfs_daddr_t		d;
+
+	ASSERT(agno != NULLAGNUMBER);
+	ASSERT(agbno != NULLAGBLOCK);
+	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, ops);
+}
+
 STATIC int
 xfs_btree_readahead_lblock(
 	struct xfs_btree_cur	*cur,
@@ -1339,7 +1378,7 @@ xfs_btree_log_block(
 			 * We don't log the CRC when updating a btree
 			 * block but instead recreate it during log
 			 * recovery.  As the log buffers have checksums
-			 * of their this is safe and avoids logging a crc
+			 * of their own this is safe and avoids logging a crc
 			 * update in a lot of places.
 			 */
 			if (fields == XFS_BB_ALL_BITS)
@@ -1629,7 +1668,7 @@ xfs_lookup_get_search_key(
 
 /*
  * Lookup the record.  The cursor is made to point to it, based on dir.
- * Return 0 if can't find any such record, 1 for success.
+ * stat is set to 0 if can't find any such record, 1 for success.
  */
 int					/* error */
 xfs_btree_lookup(
@@ -2701,7 +2740,6 @@ xfs_btree_make_block_unfull(
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-
 			xfs_iroot_realloc(ip, 1, cur->bc_private.b.whichfork);
 		} else {
 			/* A root block that needs replacing */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
