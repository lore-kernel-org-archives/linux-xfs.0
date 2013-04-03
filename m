Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5346F29E21
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 00:12:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 342E630407E
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 22:12:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	02Ivj5NzDFfQzO0N for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 22:12:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UNFzR-0000Ls-MU
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:12:05 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UNFzH-0005C6-JA
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/22] xfs: split remote attribute code out
Date: Wed,  3 Apr 2013 16:11:27 +1100
Message-Id: <1364965892-19623-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1364965892-19623-1-git-send-email-david@fromorbit.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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

Adding CRC support to remote attributes adds a significant amount of
remote attribute specific code. Split the existing remote attribute
code out into it's own file so that all the relevant remote
attribute code is in a single, easy to find place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile          |    1 +
 fs/xfs/xfs_attr.c        |  298 +----------------------------------------
 fs/xfs/xfs_attr.h        |    1 -
 fs/xfs/xfs_attr_leaf.c   |    1 +
 fs/xfs/xfs_attr_remote.c |  328 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_remote.h |   25 ++++
 6 files changed, 356 insertions(+), 298 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_remote.c
 create mode 100644 fs/xfs/xfs_attr_remote.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 062f25c..6313b69 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -58,6 +58,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_alloc_btree.o \
 				   xfs_attr.o \
 				   xfs_attr_leaf.o \
+				   xfs_attr_remote.o \
 				   xfs_bmap.o \
 				   xfs_bmap_btree.o \
 				   xfs_btree.o \
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index de4093f..449a240 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -35,6 +35,7 @@
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_attr_remote.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_vnodeops.h"
@@ -73,13 +74,6 @@ STATIC int xfs_attr_node_list(xfs_attr_list_context_t *context);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
-/*
- * Routines to manipulate out-of-line attribute values.
- */
-STATIC int xfs_attr_rmtval_set(xfs_da_args_t *args);
-STATIC int xfs_attr_rmtval_remove(xfs_da_args_t *args);
-
-#define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
 STATIC int
 xfs_attr_name_to_xname(
@@ -1926,293 +1920,3 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	xfs_trans_brelse(NULL, bp);
 	return 0;
 }
-
-
-/*========================================================================
- * External routines for manipulating out-of-line attribute values.
- *========================================================================*/
-
-/*
- * Read the value associated with an attribute from the out-of-line buffer
- * that we stored it in.
- */
-int
-xfs_attr_rmtval_get(xfs_da_args_t *args)
-{
-	xfs_bmbt_irec_t map[ATTR_RMTVALUE_MAPSIZE];
-	xfs_mount_t *mp;
-	xfs_daddr_t dblkno;
-	void *dst;
-	xfs_buf_t *bp;
-	int nmap, error, tmp, valuelen, blkcnt, i;
-	xfs_dablk_t lblkno;
-
-	trace_xfs_attr_rmtval_get(args);
-
-	ASSERT(!(args->flags & ATTR_KERNOVAL));
-
-	mp = args->dp->i_mount;
-	dst = args->value;
-	valuelen = args->valuelen;
-	lblkno = args->rmtblkno;
-	while (valuelen > 0) {
-		nmap = ATTR_RMTVALUE_MAPSIZE;
-		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
-				       args->rmtblkcnt, map, &nmap,
-				       XFS_BMAPI_ATTRFORK);
-		if (error)
-			return(error);
-		ASSERT(nmap >= 1);
-
-		for (i = 0; (i < nmap) && (valuelen > 0); i++) {
-			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
-			       (map[i].br_startblock != HOLESTARTBLOCK));
-			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
-			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
-						   dblkno, blkcnt, 0, &bp, NULL);
-			if (error)
-				return(error);
-
-			tmp = min_t(int, valuelen, BBTOB(bp->b_length));
-			xfs_buf_iomove(bp, 0, tmp, dst, XBRW_READ);
-			xfs_buf_relse(bp);
-			dst += tmp;
-			valuelen -= tmp;
-
-			lblkno += map[i].br_blockcount;
-		}
-	}
-	ASSERT(valuelen == 0);
-	return(0);
-}
-
-/*
- * Write the value associated with an attribute into the out-of-line buffer
- * that we have defined for it.
- */
-STATIC int
-xfs_attr_rmtval_set(xfs_da_args_t *args)
-{
-	xfs_mount_t *mp;
-	xfs_fileoff_t lfileoff;
-	xfs_inode_t *dp;
-	xfs_bmbt_irec_t map;
-	xfs_daddr_t dblkno;
-	void *src;
-	xfs_buf_t *bp;
-	xfs_dablk_t lblkno;
-	int blkcnt, valuelen, nmap, error, tmp, committed;
-
-	trace_xfs_attr_rmtval_set(args);
-
-	dp = args->dp;
-	mp = dp->i_mount;
-	src = args->value;
-
-	/*
-	 * Find a "hole" in the attribute address space large enough for
-	 * us to drop the new attribute's value into.
-	 */
-	blkcnt = XFS_B_TO_FSB(mp, args->valuelen);
-	lfileoff = 0;
-	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
-						   XFS_ATTR_FORK);
-	if (error) {
-		return(error);
-	}
-	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
-	args->rmtblkcnt = blkcnt;
-
-	/*
-	 * Roll through the "value", allocating blocks on disk as required.
-	 */
-	while (blkcnt > 0) {
-		/*
-		 * Allocate a single extent, up to the size of the value.
-		 */
-		xfs_bmap_init(args->flist, args->firstblock);
-		nmap = 1;
-		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
-				  blkcnt,
-				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-				  args->firstblock, args->total, &map, &nmap,
-				  args->flist);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
-		if (error) {
-			ASSERT(committed);
-			args->trans = NULL;
-			xfs_bmap_cancel(args->flist);
-			return(error);
-		}
-
-		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args->trans, dp, 0);
-
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-		lblkno += map.br_blockcount;
-		blkcnt -= map.br_blockcount;
-
-		/*
-		 * Start the next trans in the chain.
-		 */
-		error = xfs_trans_roll(&args->trans, dp);
-		if (error)
-			return (error);
-	}
-
-	/*
-	 * Roll through the "value", copying the attribute value to the
-	 * already-allocated blocks.  Blocks are written synchronously
-	 * so that we can know they are all on disk before we turn off
-	 * the INCOMPLETE flag.
-	 */
-	lblkno = args->rmtblkno;
-	valuelen = args->valuelen;
-	while (valuelen > 0) {
-		int buflen;
-
-		/*
-		 * Try to remember where we decided to put the value.
-		 */
-		xfs_bmap_init(args->flist, args->firstblock);
-		nmap = 1;
-		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
-				       args->rmtblkcnt, &map, &nmap,
-				       XFS_BMAPI_ATTRFORK);
-		if (error)
-			return(error);
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
-		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
-
-		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt, 0);
-		if (!bp)
-			return ENOMEM;
-
-		buflen = BBTOB(bp->b_length);
-		tmp = min_t(int, valuelen, buflen);
-		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
-		if (tmp < buflen)
-			xfs_buf_zero(bp, tmp, buflen - tmp);
-
-		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
-		xfs_buf_relse(bp);
-		if (error)
-			return error;
-		src += tmp;
-		valuelen -= tmp;
-
-		lblkno += map.br_blockcount;
-	}
-	ASSERT(valuelen == 0);
-	return(0);
-}
-
-/*
- * Remove the value associated with an attribute by deleting the
- * out-of-line buffer that it is stored on.
- */
-STATIC int
-xfs_attr_rmtval_remove(xfs_da_args_t *args)
-{
-	xfs_mount_t *mp;
-	xfs_bmbt_irec_t map;
-	xfs_buf_t *bp;
-	xfs_daddr_t dblkno;
-	xfs_dablk_t lblkno;
-	int valuelen, blkcnt, nmap, error, done, committed;
-
-	trace_xfs_attr_rmtval_remove(args);
-
-	mp = args->dp->i_mount;
-
-	/*
-	 * Roll through the "value", invalidating the attribute value's
-	 * blocks.
-	 */
-	lblkno = args->rmtblkno;
-	valuelen = args->rmtblkcnt;
-	while (valuelen > 0) {
-		/*
-		 * Try to remember where we decided to put the value.
-		 */
-		nmap = 1;
-		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
-				       args->rmtblkcnt, &map, &nmap,
-				       XFS_BMAPI_ATTRFORK);
-		if (error)
-			return(error);
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
-		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
-
-		/*
-		 * If the "remote" value is in the cache, remove it.
-		 */
-		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt, XBF_TRYLOCK);
-		if (bp) {
-			xfs_buf_stale(bp);
-			xfs_buf_relse(bp);
-			bp = NULL;
-		}
-
-		valuelen -= map.br_blockcount;
-
-		lblkno += map.br_blockcount;
-	}
-
-	/*
-	 * Keep de-allocating extents until the remote-value region is gone.
-	 */
-	lblkno = args->rmtblkno;
-	blkcnt = args->rmtblkcnt;
-	done = 0;
-	while (!done) {
-		xfs_bmap_init(args->flist, args->firstblock);
-		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
-				    XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-				    1, args->firstblock, args->flist,
-				    &done);
-		if (!error) {
-			error = xfs_bmap_finish(&args->trans, args->flist,
-						&committed);
-		}
-		if (error) {
-			ASSERT(committed);
-			args->trans = NULL;
-			xfs_bmap_cancel(args->flist);
-			return(error);
-		}
-
-		/*
-		 * bmap_finish() may have committed the last trans and started
-		 * a new one.  We need the inode to be in all transactions.
-		 */
-		if (committed)
-			xfs_trans_ijoin(args->trans, args->dp, 0);
-
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll(&args->trans, args->dp);
-		if (error)
-			return (error);
-	}
-	return(0);
-}
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index e920d68..de8dd58 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -140,7 +140,6 @@ typedef struct xfs_attr_list_context {
  * Overall external interface routines.
  */
 int xfs_attr_inactive(struct xfs_inode *dp);
-int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 9c18451..a1cb746 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -32,6 +32,7 @@
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_attr_sf.h"
+#include "xfs_attr_remote.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
new file mode 100644
index 0000000..d0d67e9
--- /dev/null
+++ b/fs/xfs/xfs_attr_remote.c
@@ -0,0 +1,328 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_error.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_inode_item.h"
+#include "xfs_bmap.h"
+#include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr_remote.h"
+#include "xfs_trans_space.h"
+#include "xfs_trace.h"
+
+
+#define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
+
+/*
+ * Read the value associated with an attribute from the out-of-line buffer
+ * that we stored it in.
+ */
+int
+xfs_attr_rmtval_get(xfs_da_args_t *args)
+{
+	xfs_bmbt_irec_t map[ATTR_RMTVALUE_MAPSIZE];
+	xfs_mount_t *mp;
+	xfs_daddr_t dblkno;
+	void *dst;
+	xfs_buf_t *bp;
+	int nmap, error, tmp, valuelen, blkcnt, i;
+	xfs_dablk_t lblkno;
+
+	trace_xfs_attr_rmtval_get(args);
+
+	ASSERT(!(args->flags & ATTR_KERNOVAL));
+
+	mp = args->dp->i_mount;
+	dst = args->value;
+	valuelen = args->valuelen;
+	lblkno = args->rmtblkno;
+	while (valuelen > 0) {
+		nmap = ATTR_RMTVALUE_MAPSIZE;
+		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
+				       args->rmtblkcnt, map, &nmap,
+				       XFS_BMAPI_ATTRFORK);
+		if (error)
+			return(error);
+		ASSERT(nmap >= 1);
+
+		for (i = 0; (i < nmap) && (valuelen > 0); i++) {
+			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
+			       (map[i].br_startblock != HOLESTARTBLOCK));
+			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
+			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
+			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+						   dblkno, blkcnt, 0, &bp, NULL);
+			if (error)
+				return(error);
+
+			tmp = min_t(int, valuelen, BBTOB(bp->b_length));
+			xfs_buf_iomove(bp, 0, tmp, dst, XBRW_READ);
+			xfs_buf_relse(bp);
+			dst += tmp;
+			valuelen -= tmp;
+
+			lblkno += map[i].br_blockcount;
+		}
+	}
+	ASSERT(valuelen == 0);
+	return(0);
+}
+
+/*
+ * Write the value associated with an attribute into the out-of-line buffer
+ * that we have defined for it.
+ */
+int
+xfs_attr_rmtval_set(xfs_da_args_t *args)
+{
+	xfs_mount_t *mp;
+	xfs_fileoff_t lfileoff;
+	xfs_inode_t *dp;
+	xfs_bmbt_irec_t map;
+	xfs_daddr_t dblkno;
+	void *src;
+	xfs_buf_t *bp;
+	xfs_dablk_t lblkno;
+	int blkcnt, valuelen, nmap, error, tmp, committed;
+
+	trace_xfs_attr_rmtval_set(args);
+
+	dp = args->dp;
+	mp = dp->i_mount;
+	src = args->value;
+
+	/*
+	 * Find a "hole" in the attribute address space large enough for
+	 * us to drop the new attribute's value into.
+	 */
+	blkcnt = XFS_B_TO_FSB(mp, args->valuelen);
+	lfileoff = 0;
+	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
+						   XFS_ATTR_FORK);
+	if (error) {
+		return(error);
+	}
+	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
+	args->rmtblkcnt = blkcnt;
+
+	/*
+	 * Roll through the "value", allocating blocks on disk as required.
+	 */
+	while (blkcnt > 0) {
+		/*
+		 * Allocate a single extent, up to the size of the value.
+		 */
+		xfs_bmap_init(args->flist, args->firstblock);
+		nmap = 1;
+		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
+				  blkcnt,
+				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
+				  args->firstblock, args->total, &map, &nmap,
+				  args->flist);
+		if (!error) {
+			error = xfs_bmap_finish(&args->trans, args->flist,
+						&committed);
+		}
+		if (error) {
+			ASSERT(committed);
+			args->trans = NULL;
+			xfs_bmap_cancel(args->flist);
+			return(error);
+		}
+
+		/*
+		 * bmap_finish() may have committed the last trans and started
+		 * a new one.  We need the inode to be in all transactions.
+		 */
+		if (committed)
+			xfs_trans_ijoin(args->trans, dp, 0);
+
+		ASSERT(nmap == 1);
+		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
+		       (map.br_startblock != HOLESTARTBLOCK));
+		lblkno += map.br_blockcount;
+		blkcnt -= map.br_blockcount;
+
+		/*
+		 * Start the next trans in the chain.
+		 */
+		error = xfs_trans_roll(&args->trans, dp);
+		if (error)
+			return (error);
+	}
+
+	/*
+	 * Roll through the "value", copying the attribute value to the
+	 * already-allocated blocks.  Blocks are written synchronously
+	 * so that we can know they are all on disk before we turn off
+	 * the INCOMPLETE flag.
+	 */
+	lblkno = args->rmtblkno;
+	valuelen = args->valuelen;
+	while (valuelen > 0) {
+		int buflen;
+
+		/*
+		 * Try to remember where we decided to put the value.
+		 */
+		xfs_bmap_init(args->flist, args->firstblock);
+		nmap = 1;
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
+				       args->rmtblkcnt, &map, &nmap,
+				       XFS_BMAPI_ATTRFORK);
+		if (error)
+			return(error);
+		ASSERT(nmap == 1);
+		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
+		       (map.br_startblock != HOLESTARTBLOCK));
+
+		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
+
+		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt, 0);
+		if (!bp)
+			return ENOMEM;
+
+		buflen = BBTOB(bp->b_length);
+		tmp = min_t(int, valuelen, buflen);
+		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
+		if (tmp < buflen)
+			xfs_buf_zero(bp, tmp, buflen - tmp);
+
+		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
+		xfs_buf_relse(bp);
+		if (error)
+			return error;
+		src += tmp;
+		valuelen -= tmp;
+
+		lblkno += map.br_blockcount;
+	}
+	ASSERT(valuelen == 0);
+	return(0);
+}
+
+/*
+ * Remove the value associated with an attribute by deleting the
+ * out-of-line buffer that it is stored on.
+ */
+int
+xfs_attr_rmtval_remove(xfs_da_args_t *args)
+{
+	xfs_mount_t *mp;
+	xfs_bmbt_irec_t map;
+	xfs_buf_t *bp;
+	xfs_daddr_t dblkno;
+	xfs_dablk_t lblkno;
+	int valuelen, blkcnt, nmap, error, done, committed;
+
+	trace_xfs_attr_rmtval_remove(args);
+
+	mp = args->dp->i_mount;
+
+	/*
+	 * Roll through the "value", invalidating the attribute value's
+	 * blocks.
+	 */
+	lblkno = args->rmtblkno;
+	valuelen = args->rmtblkcnt;
+	while (valuelen > 0) {
+		/*
+		 * Try to remember where we decided to put the value.
+		 */
+		nmap = 1;
+		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
+				       args->rmtblkcnt, &map, &nmap,
+				       XFS_BMAPI_ATTRFORK);
+		if (error)
+			return(error);
+		ASSERT(nmap == 1);
+		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
+		       (map.br_startblock != HOLESTARTBLOCK));
+
+		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
+
+		/*
+		 * If the "remote" value is in the cache, remove it.
+		 */
+		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt, XBF_TRYLOCK);
+		if (bp) {
+			xfs_buf_stale(bp);
+			xfs_buf_relse(bp);
+			bp = NULL;
+		}
+
+		valuelen -= map.br_blockcount;
+
+		lblkno += map.br_blockcount;
+	}
+
+	/*
+	 * Keep de-allocating extents until the remote-value region is gone.
+	 */
+	lblkno = args->rmtblkno;
+	blkcnt = args->rmtblkcnt;
+	done = 0;
+	while (!done) {
+		xfs_bmap_init(args->flist, args->firstblock);
+		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
+				    XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
+				    1, args->firstblock, args->flist,
+				    &done);
+		if (!error) {
+			error = xfs_bmap_finish(&args->trans, args->flist,
+						&committed);
+		}
+		if (error) {
+			ASSERT(committed);
+			args->trans = NULL;
+			xfs_bmap_cancel(args->flist);
+			return(error);
+		}
+
+		/*
+		 * bmap_finish() may have committed the last trans and started
+		 * a new one.  We need the inode to be in all transactions.
+		 */
+		if (committed)
+			xfs_trans_ijoin(args->trans, args->dp, 0);
+
+		/*
+		 * Close out trans and start the next one in the chain.
+		 */
+		error = xfs_trans_roll(&args->trans, args->dp);
+		if (error)
+			return (error);
+	}
+	return(0);
+}
+
diff --git a/fs/xfs/xfs_attr_remote.h b/fs/xfs/xfs_attr_remote.h
new file mode 100644
index 0000000..2a34b9a
--- /dev/null
+++ b/fs/xfs/xfs_attr_remote.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_ATTR_REMOTE_H__
+#define	__XFS_ATTR_REMOTE_H__
+
+int xfs_attr_rmtval_get(struct xfs_da_args *args);
+int xfs_attr_rmtval_set(struct xfs_da_args *args);
+int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+
+#endif /* __XFS_ATTR_REMOTE_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
