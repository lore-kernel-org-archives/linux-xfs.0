Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT0voGd075291 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 18:57:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D965E13DF71B
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:59:30 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	XekVuvYaAVZwmW6B for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:59:30 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48049199-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 11:29:29 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMs5Y-0000ZB-3z
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:59:28 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMs5I-0005Ro-Pi
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:59:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: connect up buffer reclaim priority hooks
Date: Mon, 29 Nov 2010 11:58:59 +1100
Message-Id: <1290992339-20849-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1290992339-20849-1-git-send-email-david@fromorbit.com>
References: <1290992339-20849-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/linux-2.6/xfs_buf.h |   10 ++++++++--
 fs/xfs/xfs_btree.c         |    9 ++++-----
 fs/xfs/xfs_inode.c         |    2 +-
 fs/xfs/xfs_trans.h         |    2 +-
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 4601eab..a76c242 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -336,9 +336,15 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
 #define XFS_BUF_SET_SIZE(bp, cnt)	((bp)->b_buffer_length = (cnt))
 
-#define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	do { } while (0)
+static inline void
+xfs_buf_set_ref(
+	struct xfs_buf	*bp,
+	int		lru_ref)
+{
+	atomic_set(&bp->b_lru_ref, lru_ref);
+}
+#define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	xfs_buf_set_ref(bp, ref)
 #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
-#define XFS_BUF_SET_REF(bp, ref)		do { } while (0)
 
 #define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 04f9cca..2f9e97c 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -634,9 +634,8 @@ xfs_btree_read_bufl(
 		return error;
 	}
 	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
-	if (bp != NULL) {
+	if (bp)
 		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
-	}
 	*bpp = bp;
 	return 0;
 }
@@ -944,13 +943,13 @@ xfs_btree_set_refs(
 	switch (cur->bc_btnum) {
 	case XFS_BTNUM_BNO:
 	case XFS_BTNUM_CNT:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
+		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
 		break;
 	case XFS_BTNUM_INO:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_INOMAP, XFS_INO_BTREE_REF);
+		XFS_BUF_SET_VTYPE_REF(bp, B_FS_INOMAP, XFS_INO_BTREE_REF);
 		break;
 	case XFS_BTNUM_BMAP:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_BMAP_BTREE_REF);
+		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, XFS_BMAP_BTREE_REF);
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 43ffd90..be7cf62 100644
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
