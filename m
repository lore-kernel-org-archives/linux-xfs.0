Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E7ED07F85
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:39:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 648DAAC006
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:39:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SWDwlq4XqJA8jwzY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:39:53 -0700 (PDT)
Subject: [PATCH 06/14] xfs: implement copy-on-write for reflinked blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:39:50 -0700
Message-ID: <20150625233950.4992.83245.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Implement a copy-on-write handler for the buffered write path.  When
writepages is called, allocate a new block (which we then tell the log
that we intend to delete so that it's freed if we crash), and then
write the buffer to the new block.  Upon completion, remove the freed
block intent from the log and remap the file so that the changes
appear.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |   38 +++++-
 fs/xfs/xfs_aops.h    |    5 +
 fs/xfs/xfs_reflink.c |  340 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |   15 ++
 4 files changed, 393 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index dc52698..be57e5d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -31,6 +31,8 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
+#include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
@@ -190,7 +192,8 @@ xfs_finish_ioend(
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
 		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
 
-		if (ioend->io_type == XFS_IO_UNWRITTEN)
+		if (ioend->io_type == XFS_IO_UNWRITTEN ||
+		    ioend->io_type == XFS_IO_FORKED)
 			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
 		else if (ioend->io_append_trans)
 			queue_work(mp->m_data_workqueue, &ioend->io_work);
@@ -218,6 +221,19 @@ xfs_end_io(
 		goto done;
 
 	/*
+	 * If we forked the block, we need to remap the bmbt and possibly
+	 * finish up the i_size transaction too.
+	 */
+	if (ioend->io_type == XFS_IO_FORKED) {
+		error = xfs_reflink_end_io(ip->i_mount, ip, ioend);
+		if (error)
+			goto done;
+		if (ioend->io_append_trans)
+			error = xfs_setfilesize_ioend(ioend);
+		goto done;
+	}
+
+	/*
 	 * For unwritten extents we need to issue transactions to convert a
 	 * range to normal written extens after the data I/O has finished.
 	 */
@@ -268,6 +284,7 @@ xfs_alloc_ioend(
 	ioend->io_append_trans = NULL;
 
 	INIT_WORK(&ioend->io_work, xfs_end_io);
+	INIT_LIST_HEAD(&ioend->io_reflink_endio_list);
 	return ioend;
 }
 
@@ -567,7 +584,8 @@ xfs_add_to_ioend(
 	xfs_off_t		offset,
 	unsigned int		type,
 	xfs_ioend_t		**result,
-	int			need_ioend)
+	int			need_ioend,
+	xfs_reflink_end_io_t	*eio)
 {
 	xfs_ioend_t		*ioend = *result;
 
@@ -588,6 +606,8 @@ xfs_add_to_ioend(
 
 	bh->b_private = NULL;
 	ioend->io_size += bh->b_size;
+	if (eio)
+		list_add_tail(&eio->rlei_list, &ioend->io_reflink_endio_list);
 }
 
 STATIC void
@@ -788,7 +808,7 @@ xfs_convert_page(
 			if (type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type,
-					 ioendp, done);
+					 ioendp, done, NULL);
 
 			page_dirty--;
 			count++;
@@ -951,6 +971,7 @@ xfs_vm_writepage(
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
 	int			nonblocking = 0;
+	struct xfs_inode	*ip = XFS_I(inode);
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
@@ -1119,11 +1140,17 @@ xfs_vm_writepage(
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
 		}
 		if (imap_valid) {
+			xfs_reflink_end_io_t *eio = NULL;
+
+			err = xfs_reflink_fork_block(ip, &imap, offset,
+						     &type, &eio);
+			if (err)
+				goto error;
 			lock_buffer(bh);
 			if (type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
-					 new_ioend);
+					 new_ioend, eio);
 			count++;
 		}
 
@@ -1137,6 +1164,9 @@ xfs_vm_writepage(
 
 	xfs_start_page_writeback(page, 1, count);
 
+	if (err)
+		goto error;
+
 	/* if there is no IO to be submitted for this page, we are done */
 	if (!ioend)
 		return 0;
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 86afd1a..9cf206a 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -27,12 +27,14 @@ enum {
 	XFS_IO_DELALLOC,	/* covers delalloc region */
 	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
 	XFS_IO_OVERWRITE,	/* covers already allocated extent */
+	XFS_IO_FORKED,		/* covers copy-on-write region */
 };
 
 #define XFS_IO_TYPES \
 	{ XFS_IO_DELALLOC,		"delalloc" }, \
 	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
-	{ XFS_IO_OVERWRITE,		"overwrite" }
+	{ XFS_IO_OVERWRITE,		"overwrite" }, \
+	{ XFS_IO_FORKED,		"forked" }
 
 /*
  * xfs_ioend struct manages large extent writes for XFS.
@@ -50,6 +52,7 @@ typedef struct xfs_ioend {
 	xfs_off_t		io_offset;	/* offset in the file */
 	struct work_struct	io_work;	/* xfsdatad work queue */
 	struct xfs_trans	*io_append_trans;/* xact. for size update */
+	struct list_head	io_reflink_endio_list;/* remappings for CoW */
 } xfs_ioend_t;
 
 extern const struct address_space_operations xfs_address_space_operations;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ce5feeb..39b29a4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -45,6 +45,31 @@
 #include "xfs_alloc.h"
 #include "xfs_quota_defs.h"
 #include "xfs_quota.h"
+#include "xfs_btree.h"
+#include "xfs_bmap_btree.h"
+
+#define CHECK_AG_NUMBER(mp, agno) \
+	do { \
+		ASSERT((agno) != NULLAGNUMBER); \
+		ASSERT((agno) < (mp)->m_sb.sb_agcount); \
+	} while(0);
+
+#define CHECK_AG_EXTENT(mp, agbno, len) \
+	do { \
+		ASSERT((agbno) != NULLAGBLOCK); \
+		ASSERT((len) > 0); \
+		ASSERT((unsigned long long)(agbno) + (len) <= \
+				(mp)->m_sb.sb_agblocks); \
+	} while(0);
+
+#define XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, have, agbno, len, nr, label) \
+	do { \
+		XFS_WANT_CORRUPTED_GOTO((mp), (have) == 1, label); \
+		XFS_WANT_CORRUPTED_GOTO((mp), (len) > 0, label); \
+		XFS_WANT_CORRUPTED_GOTO((mp), (nr) >= 2, label); \
+		XFS_WANT_CORRUPTED_GOTO((mp), (unsigned long long)(agbno) + \
+				(len) <= (mp)->m_sb.sb_agblocks, label); \
+	} while(0);
 
 /**
  * xfs_reflink() - link a range of blocks from one inode to another
@@ -294,3 +319,318 @@ out_unlock_io:
 
 	return error;
 }
+
+/**
+ * xfs_reflink_get_refcount() - get refcount and extent length for a given pblk
+ *
+ * @mp: XFS mount object
+ * @agno: AG number
+ * @agbno: AG block number
+ * @len: length of extent
+ * @nr: refcount
+ */
+int
+xfs_reflink_get_refcount(
+	struct xfs_mount	*mp,		/* xfs mount object */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_agblock_t		agbno,		/* ag start of range to free */
+	xfs_extlen_t		*len,		/* out: length of extent */
+	xfs_nlink_t		*nr)		/* out: refcount */
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agbp;
+	xfs_agblock_t		lbno;		/* rlextent start */
+	xfs_extlen_t		llen;		/* rlextent length */
+	xfs_nlink_t		lnr;		/* rlextent refcount */
+	xfs_extlen_t		aglen;
+	int			error;
+	int			i, have;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
+		*len = 0;
+		*nr = 1;
+		return 0;
+	}
+
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, 1);
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+	aglen = be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length);
+	ASSERT(agbno < aglen);
+
+	/*
+	 * See if there's an extent covering the block we want.
+	 */
+	cur = xfs_reflinkbt_init_cursor(mp, NULL, agbp, agno);
+	error = xfs_reflink_lookup_le(cur, agbno, &have);
+	if (error)
+		goto error0;
+	if (!have)
+		goto hole;
+	error = xfs_reflink_get_rec(cur, &lbno, &llen, &lnr, &i);
+	if (error)
+		goto error0;
+	XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr, error0);
+	if (lbno + llen <= agbno)
+		goto hole;
+
+	*len = llen - (agbno - lbno);
+	*nr = lnr;
+	goto out;
+hole:
+	/*
+	 * We're in a hole, so pretend that this we have a refcount=1 extent
+	 * going to the next rlextent or the end of the AG.
+	 */
+	error = xfs_btree_increment(cur, 0, &have);
+	if (error)
+		goto error0;
+	if (!have)
+		*len = aglen - agbno;
+	else {
+		error = xfs_reflink_get_rec(cur, &lbno, &llen,
+				&lnr, &i);
+		XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr, error0);
+		ASSERT(lbno + llen >= agbno);
+		*len = lbno - agbno;
+	}
+	*nr = 1;
+out:
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	xfs_buf_relse(agbp);
+	return error;
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_buf_relse(agbp);
+	return error;
+}
+
+/**
+ * xfs_reflink_fork_block() - start forking a block, if reflinked
+ *
+ * @ip: XFS inode object
+ * @imap: the fileoff:fsblock mapping that we might fork
+ * @offset: the file offset of the block we're examining
+ * @type: the ioend type
+ */
+int
+xfs_reflink_fork_block(
+	struct xfs_inode	*ip,		/* xfs inode object */
+	xfs_bmbt_irec_t		*imap,		/* in/out: block mapping */
+	xfs_off_t		offset,		/* file offset */
+	unsigned int		*type,		/* in/out: what kind of io is this? */
+	xfs_reflink_end_io_t	**peio)		/* out: reflink context for end_io */
+{
+	xfs_fsblock_t		fsbno;
+	xfs_off_t		iomap_offset;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_alloc_arg_t		args;		/* allocation arguments */
+	xfs_extlen_t		len;		/* rlextent length */
+	xfs_nlink_t		nr;		/* rlextent refcount */
+	struct xfs_trans	*tp = NULL;
+	int			error;
+	xfs_reflink_end_io_t	*eio;
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+	if (*type == XFS_IO_DELALLOC || *type == XFS_IO_UNWRITTEN)
+		return 0;
+
+	iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	fsbno = imap->br_startblock + XFS_B_TO_FSB(mp, offset - iomap_offset);
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, 1);
+	ASSERT(imap->br_state == XFS_EXT_NORM);
+
+	/*
+	 * See if there's an extent covering the block we want.  If so,
+	 * then this block is reflinked and must be forked.
+	 */
+	error = xfs_reflink_get_refcount(mp, agno, agbno, &len, &nr);
+	if (error)
+		return error;
+	ASSERT(len != 0);
+	if (nr < 2)
+		goto out;
+
+	/*
+	 * Ok, we have to fork this block.  First set up a transaction...
+	 */
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+				  XFS_DIOSTRAT_SPACE_RES(mp, 2), 0);
+	if (error)
+		goto error0;
+
+	/*
+	 * Now allocate a block, stash the new mapping, and add an EFI entry
+	 * so the block gets cleared if we crash.
+	 *
+	 * XXX: Ideally we'd scan up and down the incore extent list
+	 * looking for a block, but do this stupid thing for now.
+	 */
+	memset(&args, 0, sizeof(args));
+	args.tp = tp;
+	args.mp = mp;
+	args.type = XFS_ALLOCTYPE_START_BNO;
+	args.firstblock = imap->br_startblock;
+	args.fsbno = imap->br_startblock;
+	args.minlen = args.maxlen = args.prod = 1;
+	args.userdata = XFS_ALLOC_USERDATA;
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto error0;
+	ASSERT(args.len == 1);
+
+	imap->br_startblock = args.fsbno;
+	imap->br_startoff = XFS_B_TO_FSB(mp, offset);
+	imap->br_blockcount = args.len;
+	imap->br_state = XFS_EXT_NORM;
+
+	eio = kmem_zalloc(sizeof(*eio), KM_SLEEP | KM_NOFS);
+	eio->rlei_efi = xfs_trans_get_efi(tp, 1);
+	eio->rlei_mapping = *imap;
+	xfs_trans_log_efi_extent(tp, eio->rlei_efi, imap->br_startblock,
+				 imap->br_blockcount);
+	*peio = eio;
+
+	/*
+	 * ...and we're done.
+	 */
+	*type = XFS_IO_FORKED;
+	error = xfs_trans_commit(tp);
+
+	return error;
+out:
+	return 0;
+error0:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/**
+ * xfs_reflink_remap_after_io() - remap a range of file blocks after forking
+ *
+ * @mp: XFS mount object
+ * @ip: XFS inode object
+ * @imap: the new mapping
+ */
+STATIC int
+xfs_reflink_remap_after_io(
+	struct xfs_mount	*mp,		/* XFS mount object */
+	struct xfs_inode	*ip,		/* inode */
+	xfs_reflink_end_io_t	*eio)		/* endio data */
+{
+	struct xfs_trans	*tp = NULL;
+	int			error;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_fsblock_t		firstfsb;
+	int			committed;
+	xfs_bmbt_irec_t		imaps[1];
+	int			nimaps = 1;
+	int			done;
+	xfs_bmap_free_t		free_list;
+	xfs_bmbt_irec_t		*imap = &eio->rlei_mapping;
+	struct xfs_efd_log_item	*efd;
+	unsigned int		resblks;
+
+	ASSERT(xfs_sb_version_hasreflink(&mp->m_sb));
+	agno = XFS_FSB_TO_AGNO(mp, imap->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, imap->br_startblock);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, 1);
+	ASSERT(imap->br_state == XFS_EXT_NORM);
+
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+
+	/*
+	 * Set up a transaction -- we're munging the rlbt update, the unmap,
+	 * and the remap operation into one huge transaction.
+	 */
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, imap->br_blockcount * 3);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Remove the EFD.
+	 */
+	efd = xfs_trans_get_efd(tp, eio->rlei_efi, 1);
+	xfs_trans_log_efd_extent(tp, efd, imap->br_startblock,
+				 imap->br_blockcount);
+
+	/*
+	 * Remap the old blocks.
+	 */
+	xfs_bmap_init(&free_list, &firstfsb);
+	error = xfs_bunmapi(tp, ip, imap->br_startoff, imap->br_blockcount, 0,
+			imap->br_blockcount, &firstfsb, &free_list, &done);
+	if (error)
+		goto error2;
+
+	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
+					XFS_BMAPI_REFLINK, &imap->br_startblock,
+					0, &imaps[0], &nimaps, &free_list);
+	if (error)
+		goto error2;
+
+	/*
+	 * Finish transaction.
+	 */
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto error1;
+
+
+	error = xfs_trans_commit(tp);
+	return error;
+
+error2:
+	xfs_bmap_cancel(&free_list);
+error1:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/**
+ * xfs_reflink_end_io() - remap all blocks after forking
+ *
+ * @mp: XFS mount object
+ * @ip: XFS inode object
+ * @ioend: the io completion object
+ */
+int
+xfs_reflink_end_io(
+	struct xfs_mount	*mp,		/* XFS mount object */
+	struct xfs_inode	*ip,		/* inode */
+	xfs_ioend_t		*ioend)		/* IO completion object */
+{
+	int			error, err2;
+	struct list_head	*pos, *n;
+	xfs_reflink_end_io_t	*eio;
+
+	error = 0;
+	list_for_each_safe(pos, n, &ioend->io_reflink_endio_list) {
+		eio = list_entry(pos, xfs_reflink_end_io_t, rlei_list);
+		err2 = xfs_reflink_remap_after_io(mp, ip, eio);
+		if (error == 0)
+			error = err2;
+		kfree(eio);
+	}
+
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 7cccd50..40a6576 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -18,7 +18,22 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
+typedef struct xfs_reflink_end_io {
+	struct list_head	rlei_list;
+	xfs_bmbt_irec_t		rlei_mapping;
+	struct xfs_efi_log_item	*rlei_efi;
+} xfs_reflink_end_io_t;
+
 extern int xfs_reflink(struct xfs_inode *src, xfs_off_t srcoff,
 	struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
 
+extern int xfs_reflink_get_refcount(struct xfs_mount *mp, xfs_agnumber_t agno,
+	xfs_agblock_t agbno, xfs_extlen_t *len, xfs_nlink_t *nr);
+
+extern int xfs_reflink_fork_block(struct xfs_inode *ip, xfs_bmbt_irec_t *imap,
+	xfs_off_t offset, unsigned int *type, xfs_reflink_end_io_t **peio);
+
+extern int xfs_reflink_end_io(struct xfs_mount *mp, struct xfs_inode *ip,
+	xfs_ioend_t *ioend);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
