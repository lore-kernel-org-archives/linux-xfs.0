Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88t4MY089594 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:55:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3739F1DA9D94
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:30 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	MEnywk2QTfWPy3Wc for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:30 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	45901305-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:28 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWS-0001Cw-UO
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:16 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVl-0004nm-39
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/16] xfs: connect up buffer reclaim priority hooks
Date: Mon,  8 Nov 2010 19:55:14 +1100
Message-Id: <1289206519-18377-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that the buffer reclaim infrastructure can handle different reclaim
priorities for different types of buffers, reconnect the hooks in the
XFS code that has been sitting dormant since it was ported to Linux. This
should finally give use reclaim prioritisation that is on a par with the
functionality that Irix provided XFS 15 years ago.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |   31 +++++++++++++++++++++++++++++--
 fs/xfs/quota/xfs_dquot.c   |    2 +-
 fs/xfs/xfs_alloc.c         |    4 ++--
 fs/xfs/xfs_btree.c         |   11 +++++------
 fs/xfs/xfs_da_btree.c      |    4 ++--
 fs/xfs/xfs_ialloc.c        |    2 +-
 fs/xfs/xfs_inode.c         |    2 +-
 fs/xfs/xfs_trans.h         |    2 +-
 8 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 4601eab..2dff03f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -336,9 +336,36 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
 #define XFS_BUF_SET_SIZE(bp, cnt)	((bp)->b_buffer_length = (cnt))
 
-#define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	do { } while (0)
+/*
+ * buffer types 
+ */
+#define	B_FS_DQUOT	1
+#define	B_FS_AGFL	2
+#define	B_FS_AGF	3
+#define	B_FS_ATTR_BTREE	4
+#define	B_FS_DIR_BTREE	5
+#define	B_FS_MAP	6
+#define	B_FS_INOMAP	7
+#define	B_FS_AGI	8
+#define	B_FS_INO	9
+
+static inline void
+xfs_buf_set_vtype_ref(
+	struct xfs_buf	*bp,
+	int		type,
+	int		lru_ref)
+{
+	atomic_set(&bp->b_lru_ref, lru_ref);
+}
+
+static inline void
+xfs_buf_set_ref(
+	struct xfs_buf	*bp,
+	int		lru_ref)
+{
+	atomic_set(&bp->b_lru_ref, lru_ref);
+}
 #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
-#define XFS_BUF_SET_REF(bp, ref)		do { } while (0)
 
 #define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
 
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index faf8e1a..682cbf5 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -607,7 +607,7 @@ xfs_qm_dqread(
 	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
 
 	/* Mark the buf so that this will stay incore a little longer */
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_DQUOT, XFS_DQUOT_REF);
+	xfs_buf_set_vtype_ref(bp, B_FS_DQUOT, XFS_DQUOT_REF);
 
 	/*
 	 * We got the buffer with a xfs_trans_read_buf() (in dqtobp())
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 112abc4..702b097 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -463,7 +463,7 @@ xfs_alloc_read_agfl(
 		return error;
 	ASSERT(bp);
 	ASSERT(!XFS_BUF_GETERROR(bp));
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGFL, XFS_AGFL_REF);
+	xfs_buf_set_vtype_ref(bp, B_FS_AGFL, XFS_AGFL_REF);
 	*bpp = bp;
 	return 0;
 }
@@ -2160,7 +2160,7 @@ xfs_read_agf(
 		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
-	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGF, XFS_AGF_REF);
+	xfs_buf_set_vtype_ref(*bpp, B_FS_AGF, XFS_AGF_REF);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 04f9cca..20cec22 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -634,9 +634,8 @@ xfs_btree_read_bufl(
 		return error;
 	}
 	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
-	if (bp != NULL) {
-		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
-	}
+	if (bp)
+		xfs_buf_set_vtype_ref(bp, B_FS_MAP, refval);
 	*bpp = bp;
 	return 0;
 }
@@ -944,13 +943,13 @@ xfs_btree_set_refs(
 	switch (cur->bc_btnum) {
 	case XFS_BTNUM_BNO:
 	case XFS_BTNUM_CNT:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
+		xfs_buf_set_vtype_ref(bp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
 		break;
 	case XFS_BTNUM_INO:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_INOMAP, XFS_INO_BTREE_REF);
+		xfs_buf_set_vtype_ref(bp, B_FS_INOMAP, XFS_INO_BTREE_REF);
 		break;
 	case XFS_BTNUM_BMAP:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_BMAP_BTREE_REF);
+		xfs_buf_set_vtype_ref(bp, B_FS_MAP, XFS_BMAP_BTREE_REF);
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 1c00bed..eea90ff 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2056,10 +2056,10 @@ xfs_da_do_buf(
 			continue;
 		if (caller == 1) {
 			if (whichfork == XFS_ATTR_FORK) {
-				XFS_BUF_SET_VTYPE_REF(bp, B_FS_ATTR_BTREE,
+				xfs_buf_set_vtype_ref(bp, B_FS_ATTR_BTREE,
 						XFS_ATTR_BTREE_REF);
 			} else {
-				XFS_BUF_SET_VTYPE_REF(bp, B_FS_DIR_BTREE,
+				xfs_buf_set_vtype_ref(bp, B_FS_DIR_BTREE,
 						XFS_DIR_BTREE_REF);
 			}
 		}
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 0626a32..7fe7f35 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1517,7 +1517,7 @@ xfs_read_agi(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
-	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGI, XFS_AGI_REF);
+	xfs_buf_set_vtype_ref(*bpp, B_FS_AGI, XFS_AGI_REF);
 
 	xfs_check_agi_unlinked(agi);
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 25becb1..fc09a22 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -887,7 +887,7 @@ xfs_iread(
 	 * around for a while.  This helps to keep recently accessed
 	 * meta-data in-core longer.
 	 */
-	XFS_BUF_SET_REF(bp, XFS_INO_REF);
+	xfs_buf_set_ref(bp, XFS_INO_REF);
 
 	/*
 	 * Use xfs_trans_brelse() to release the buffer containing the
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 246286b..c2042b7 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -294,8 +294,8 @@ struct xfs_log_item_desc {
 #define	XFS_ALLOC_BTREE_REF	2
 #define	XFS_BMAP_BTREE_REF	2
 #define	XFS_DIR_BTREE_REF	2
+#define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
-#define	XFS_INO_REF		1
 #define	XFS_DQUOT_REF		1
 
 #ifdef __KERNEL__
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
