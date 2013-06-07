Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7BEF77FA3
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B589304089
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DJfG25sPD7ufDE9Y for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVm-0003ue-9n
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:34 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVc-0001Kg-6p
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/48] xfs: split remote attribute code out
Date: Fri,  7 Jun 2013 10:25:39 +1000
Message-Id: <1370564771-4929-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
 include/libxfs.h          |    1 +
 include/xfs_attr_remote.h |   31 +++++
 libxfs/Makefile           |    2 +-
 libxfs/xfs.h              |    9 +-
 libxfs/xfs_attr.c         |  296 -------------------------------------------
 libxfs/xfs_attr_remote.c  |  306 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 346 insertions(+), 299 deletions(-)
 create mode 100644 include/xfs_attr_remote.h
 create mode 100644 libxfs/xfs_attr_remote.c

diff --git a/include/libxfs.h b/include/libxfs.h
index 41cb585..972d850 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -589,6 +589,7 @@ extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
 #include <xfs/xfs_rtalloc.h>
 
 #include <xfs/xfs_attr_leaf.h>
+#include <xfs/xfs_attr_remote.h>
 #include <xfs/xfs_quota.h>
 #include <xfs/xfs_trans_space.h>
 #include <xfs/xfs_log.h>
diff --git a/include/xfs_attr_remote.h b/include/xfs_attr_remote.h
new file mode 100644
index 0000000..b4be90e
--- /dev/null
+++ b/include/xfs_attr_remote.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2013 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Further, this software is distributed without any warranty that it is
+ * free of the rightful claim of any third person regarding infringement
+ * or the like.  Any license provided herein, whether implied or
+ * otherwise, applies only to this software file.  Patent licenses, if
+ * any, provided herein do not apply to combinations of this program with
+ * other software, or any other product whatsoever.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
+ * USA.
+ */
+#ifndef __XFS_ATTR_REMOTE_H__
+#define	__XFS_ATTR_REMOTE_H__
+
+int xfs_attr_rmtval_get(struct xfs_da_args *args);
+int xfs_attr_rmtval_set(struct xfs_da_args *args);
+int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+
+#endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 75f365c..d0b483d 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -16,7 +16,7 @@ CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
 	xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c \
 	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
 	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
-	xfs_mount.c xfs_rtalloc.c xfs_trans.c xfs_attr.c \
+	xfs_mount.c xfs_rtalloc.c xfs_trans.c xfs_attr.c xfs_attr_remote.c \
 	crc32.c xfs_symlink.c
 
 CFILES += $(PKG_PLATFORM).c
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index b3b45bb..c69dc4a 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -180,14 +180,19 @@ roundup_pow_of_two(uint v)
 #define XFS_BUF_SET_VTYPE_REF(a,b,c)	((void) 0)
 #define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
 
-#define xfs_incore(bt,blkno,len,lockit)	0
+/* avoid gcc warning */
+#define xfs_incore(bt,blkno,len,lockit)	({		\
+	typeof(blkno) __foo = (blkno);			\
+	(blkno) = __foo;				\
+	NULL;						\
+})
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_read_buf(mp,devp,blkno,len,f,bpp)	\
 					(*(bpp) = libxfs_readbuf((devp), \
 							(blkno), (len), 1), 0)
 #define xfs_buf_get(devp,blkno,len,f)	\
 					(libxfs_getbuf((devp), (blkno), (len)))
-#define xfs_bwrite(mp,bp)		libxfs_writebuf((bp), 0)
+#define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
 
 #define XBRW_READ			LIBXFS_BREAD
 #define XBRW_WRITE			LIBXFS_BWRITE
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4429cb7..cfc2f4b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -49,13 +49,6 @@ STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
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
@@ -1518,292 +1511,3 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	xfs_da_state_free(state);
 	return(retval);
 }
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
-		error = xfs_bwrite(mp, bp);	/* GROT: NOTE: synchronous write */
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
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
new file mode 100644
index 0000000..36f8b5d
--- /dev/null
+++ b/libxfs/xfs_attr_remote.c
@@ -0,0 +1,306 @@
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
+#include <xfs.h>
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
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
