Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 15:23:02 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7VMMvXJ023347
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 15:22:58 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D56281BCA608
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 15:24:20 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id EP52ddsbX0KVguNj for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 15:24:20 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m7VMOKIF002426
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 00:24:20 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m7VMOKbY002424
	for xfs@oss.sgi.com; Mon, 1 Sep 2008 00:24:20 +0200
Date: Mon, 1 Sep 2008 00:24:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] btree test harness
Message-ID: <20080831222420.GA2301@lst.de>
References: <20080813223022.GA15025@lst.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20080813223022.GA15025@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

New version below.  Now we use an ioctl to driver the tests for
a given maximum of levels.  There's a small program for xfstests
that calls it.  No real testcases yet because the setup is still a
little weird:

mkfs.xfs -f \
        -b size=512 \
	-d agcount=1 \
	-l logdev=/dev/hdb,size=65000b,lazy-count=1 \
	/dev/hdd

mount -t xfs -o logdev=/dev/hdb /dev/hdd /mnt/

./src/btree-test /mnt 0 <levels to test>

Next step would be to find the largest span of free blocks using real
allocator functions, which should make this a lot safer, and might also
get rid of the requirement of an external log.



--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-btree-test-harness

Index: linux-2.6-xfs/fs/xfs/xfs_btree_test.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/xfs_btree_test.c	2008-08-31 19:18:01.000000000 -0300
@@ -0,0 +1,1283 @@
+/*
+ * Copyright (c) 2008 Silicon Graphics, Inc.
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
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_btree_trace.h"
+#include "xfs_ialloc.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+#include "xfs_trans_space.h"
+#include "xfs_rw.h"
+
+/*
+ * Btree test harness.
+ *
+ * The idea is we implement a btree not that we can freely excercise
+ * without the rest of the filesystem involed.  It basically mirrors
+ * the alloc by block number btree, just with a separate root block
+ * and dummy agf, and a "special" allocator.  The allocator here
+ * just takes over the whole allocation group from a start offset
+ * and uses a simple bitmap - that way we can stree the btree without
+ * having to call into the XFS allocator (and this another btree).
+ * This is of course very dangerous on a real live filesystem, but
+ * this code shouldn't be used on those anyway.
+ *
+ * Initially this is based on the alloc btree code because it is
+ * the simplest. Ideally this also needs to be expanded to handle
+ * inode rooted btrees and all the other features of the btrees
+ * (e.g. longest extent tracking).
+ *
+ * The test harness itself is at the bottom of the file. It
+ * gets invoked in a debug build on XFS initialisation, and
+ * when it is complete it is never referenced again.
+ *
+ * Test harness
+ *
+ * The following tests are necessary:
+ *
+ *	- split test
+ *	- merge test
+ *	- sparse tree test
+ *	- depth test
+ *
+ * Ideally the tests should grow and shrink the tree, thereby
+ * exercising root splitting and merging.
+ *
+ * what we need:
+ *
+ *	- a fake struct xfs_mount
+ *	- a fake struct xfs_trans
+ *	- a fake agf
+ *	- a fake agf struct xfs_buf
+ *	- special cursor init
+ */
+
+/* We need to start a little after 0 to avoid hardcoded assumptions */
+#define XFS_TBT_FIRST_FREE_BLOCK	8
+
+
+static unsigned long *xfs_tbt_allocmap;
+static size_t xfs_tbt_allomap_size;
+
+STATIC int
+xfs_tbt_init_freelist(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_agf		*agf;
+	int			error;
+	__uint32_t		freeblks, startblk;
+	int			i;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error || agbp == NULL) {
+		cmn_err(CE_WARN, "xfs_alloc_read_agf failed (%d).\n", error);
+		return error ? error : ENOMEM;
+	}
+
+	/*
+	 * See what the largest free space is and used for us.
+	 *
+	 * XXX(hch): this assumes it's clustered at the end..
+	 */
+	agf = XFS_BUF_TO_AGF(agbp);
+	freeblks = be32_to_cpu(agf->agf_longest);
+	startblk = be32_to_cpu(agf->agf_length) - freeblks;
+	xfs_buf_relse(agbp);
+
+	cmn_err(CE_NOTE, "%s: using %d blocks, starting at %d\n",
+			__func__, freeblks, startblk);
+
+	/* just us a simple bitmap array indexed by blockno */
+	xfs_tbt_allomap_size = freeblks / NBBY;
+	xfs_tbt_allocmap = kmalloc(xfs_tbt_allomap_size, GFP_KERNEL);
+	if (!xfs_tbt_allocmap) {
+		cmn_err(CE_WARN, "xfs_tbt_init_freelist: ENOMEM");
+		return ENOMEM;
+	}
+
+	memset(xfs_tbt_allocmap, 0xff, xfs_tbt_allomap_size); /* all free */
+	for (i = 0; i < startblk; i++)
+		clear_bit(i, xfs_tbt_allocmap);	/* except for used blocks */
+
+	return 0;
+}
+
+STATIC void
+xfs_tbt_destroy_freelist(
+	struct xfs_mount	*mp)
+{
+	kfree(xfs_tbt_allocmap);
+}
+
+STATIC int
+xfs_tbt_alloc(
+	xfs_agblock_t		*bnop)
+{
+	xfs_agblock_t		bno;
+	int			val;
+
+	bno = find_first_bit(xfs_tbt_allocmap,
+			xfs_tbt_allomap_size/sizeof(long));
+	if (bno >= xfs_tbt_allomap_size/sizeof(long)) {
+		cmn_err(CE_WARN, "%s: ran out of space\n", __func__);
+		return ENOSPC;
+	}
+
+	val = test_and_clear_bit(bno, xfs_tbt_allocmap);
+
+	ASSERT(val);
+	ASSERT(find_first_bit(xfs_tbt_allocmap,
+		xfs_tbt_allomap_size/sizeof(long)) > bno);
+	ASSERT(bno != NULLAGBLOCK);
+
+	*bnop = bno;
+	return 0;
+}
+
+STATIC int
+xfs_tbt_free(
+	xfs_agblock_t		bno)
+{
+	int			val;
+
+	ASSERT(bno <= xfs_tbt_allomap_size);
+
+	val = test_and_set_bit(bno, xfs_tbt_allocmap);
+	ASSERT(val == 0);
+
+	return 0;
+}
+
+STATIC int
+xfs_tbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			length,
+	int			*stat)
+{
+	xfs_agblock_t		bno;
+	int			error;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	error = xfs_tbt_alloc(&bno);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+
+	new->s = cpu_to_be32(bno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+}
+
+STATIC int
+xfs_tbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	xfs_tbt_free(XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp)));
+	return 0;
+}
+
+STATIC struct xfs_btree_cur *
+xfs_tbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_cur	*new;
+
+	new = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	new->bc_mp = cur->bc_mp;
+	new->bc_tp = cur->bc_tp;
+	new->bc_nlevels = cur->bc_nlevels;
+	new->bc_btnum = XFS_BTNUM_BNO;
+	new->bc_blocklog = cur->bc_mp->m_sb.sb_blocklog;
+
+	new->bc_ops = cur->bc_ops;
+
+	new->bc_private.a.agbp = cur->bc_private.a.agbp;
+	new->bc_private.a.agno = cur->bc_private.a.agno;
+
+	return new;
+}
+
+STATIC void
+xfs_tbt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	int			btnum = cur->bc_btnum;
+
+	ASSERT(ptr->s != 0);
+
+	agf->agf_roots[btnum] = ptr->s;
+	be32_add_cpu(&agf->agf_levels[btnum], inc);
+	cur->bc_mp->m_perag[seqno].pagf_levels[btnum] += inc;
+}
+
+STATIC int
+xfs_tbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_alloc_mnr[level != 0];
+}
+
+STATIC int
+xfs_tbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_alloc_mxr[level != 0];
+}
+
+STATIC void
+xfs_tbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->alloc.ar_startblock = rec->alloc.ar_startblock;
+	key->alloc.ar_blockcount = rec->alloc.ar_blockcount;
+}
+
+STATIC void
+xfs_tbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	rec->alloc.ar_startblock = key->alloc.ar_startblock;
+	rec->alloc.ar_blockcount = key->alloc.ar_blockcount;
+}
+
+STATIC void
+xfs_tbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	rec->alloc.ar_startblock = cpu_to_be32(cur->bc_rec.a.ar_startblock);
+	rec->alloc.ar_blockcount = cpu_to_be32(cur->bc_rec.a.ar_blockcount);
+}
+
+STATIC void
+xfs_tbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(agf->agf_roots[cur->bc_btnum] != 0);
+
+	ptr->s = agf->agf_roots[cur->bc_btnum];
+}
+
+STATIC __int64_t
+xfs_tbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
+	xfs_alloc_key_t		*kp = &key->alloc;
+
+	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+}
+
+STATIC int
+xfs_tbt_kill_root(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			level,
+	union xfs_btree_ptr	*newroot)
+{
+	int			error;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, killroot);
+
+	/*
+	 * Update the root pointer, decreasing the level by 1 and then
+	 * free the old root.
+	 */
+	xfs_tbt_set_root(cur, newroot, -1);
+	error = xfs_tbt_free_block(cur, bp);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+
+	XFS_BTREE_STATS_INC(cur, free);
+
+	xfs_btree_setbuf(cur, level, NULL);
+	cur->bc_nlevels--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
+
+#ifdef DEBUG
+STATIC int
+xfs_tbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->alloc.ar_startblock) <
+	       be32_to_cpu(k2->alloc.ar_startblock);
+}
+
+STATIC int
+xfs_tbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	return be32_to_cpu(r1->alloc.ar_startblock) +
+		be32_to_cpu(r1->alloc.ar_blockcount) <=
+		be32_to_cpu(r2->alloc.ar_startblock);
+}
+#endif	/* DEBUG */
+
+#ifdef XFS_BTREE_TRACE
+ktrace_t	*xfs_tbt_trace_buf;
+
+STATIC void
+xfs_tbt_trace_enter(
+	struct xfs_btree_cur	*cur,
+	const char		*func,
+	char			*s,
+	int			type,
+	int			line,
+	__psunsigned_t		a0,
+	__psunsigned_t		a1,
+	__psunsigned_t		a2,
+	__psunsigned_t		a3,
+	__psunsigned_t		a4,
+	__psunsigned_t		a5,
+	__psunsigned_t		a6,
+	__psunsigned_t		a7,
+	__psunsigned_t		a8,
+	__psunsigned_t		a9,
+	__psunsigned_t		a10)
+{
+	/* do nothing for now */
+}
+
+STATIC void
+xfs_tbt_trace_cursor(
+	struct xfs_btree_cur	*cur,
+	__uint32_t		*s0,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*s0 = cur->bc_private.a.agno;
+	*l0 = cur->bc_rec.a.ar_startblock;
+	*l1 = cur->bc_rec.a.ar_blockcount;
+}
+
+STATIC void
+xfs_tbt_trace_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*l0 = be32_to_cpu(key->alloc.ar_startblock);
+	*l1 = be32_to_cpu(key->alloc.ar_blockcount);
+}
+
+STATIC void
+xfs_tbt_trace_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	__uint64_t		*l0,
+	__uint64_t		*l1,
+	__uint64_t		*l2)
+{
+	*l0 = be32_to_cpu(rec->alloc.ar_startblock);
+	*l1 = be32_to_cpu(rec->alloc.ar_blockcount);
+	*l2 = 0;
+}
+#endif /* XFS_BTREE_TRACE */
+
+static const struct xfs_btree_ops xfs_tbt_ops = {
+	.rec_len		= sizeof(xfs_alloc_rec_t),
+	.key_len		= sizeof(xfs_alloc_key_t),
+
+	.dup_cursor		= xfs_tbt_dup_cursor,
+	.set_root		= xfs_tbt_set_root,
+	.kill_root		= xfs_tbt_kill_root,
+	.alloc_block		= xfs_tbt_alloc_block,
+	.free_block		= xfs_tbt_free_block,
+	.get_minrecs		= xfs_tbt_get_minrecs,
+	.get_maxrecs		= xfs_tbt_get_maxrecs,
+	.init_key_from_rec	= xfs_tbt_init_key_from_rec,
+	.init_rec_from_key	= xfs_tbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_tbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_tbt_init_ptr_from_cur,
+	.key_diff		= xfs_tbt_key_diff,
+
+#ifdef DEBUG
+	.keys_inorder		= xfs_tbt_keys_inorder,
+	.recs_inorder		= xfs_tbt_recs_inorder,
+#endif
+
+#ifdef XFS_BTREE_TRACE
+	.trace_enter		= xfs_tbt_trace_enter,
+	.trace_cursor		= xfs_tbt_trace_cursor,
+	.trace_key		= xfs_tbt_trace_key,
+	.trace_record		= xfs_tbt_trace_record,
+#endif
+};
+
+/*
+ * Allocate a new allocation btree cursor.
+ */
+STATIC struct xfs_btree_cur *
+xfs_tbt_init_cursor(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+	struct xfs_trans	*tp;
+	int			error;
+	uint			resblks;
+
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	tp->t_flags |= XFS_TRANS_RESERVE;
+	error = xfs_trans_reserve(tp, resblks,
+			XFS_WRITE_LOG_RES(mp), 0,
+			XFS_TRANS_PERM_LOG_RES,
+			XFS_WRITE_LOG_COUNT);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return NULL;
+	}
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	cur->bc_mp = mp;
+	cur->bc_tp = tp;
+	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	cur->bc_btnum = XFS_BTNUM_BNO;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+
+	cur->bc_ops = &xfs_tbt_ops;
+
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
+
+	return cur;
+}
+
+/*
+ * Lookup the record equal to [bno, len] in the btree given by cur.
+ */
+STATIC int				/* error */
+xfs_tbt_lookup_eq(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.a.ar_startblock = bno;
+	cur->bc_rec.a.ar_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
+/*
+ * Lookup the first record greater than or equal to [bno, len]
+ * in the btree given by cur.
+ */
+STATIC int				/* error */
+xfs_tbt_lookup_ge(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.a.ar_startblock = bno;
+	cur->bc_rec.a.ar_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+}
+
+/*
+ * Lookup the first record less than or equal to [bno, len]
+ * in the btree given by cur.
+ */
+STATIC int				/* error */
+xfs_tbt_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.a.ar_startblock = bno;
+	cur->bc_rec.a.ar_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int				/* error */
+xfs_tbt_update(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len)	/* length of extent */
+{
+	union xfs_btree_rec	rec;
+
+	rec.alloc.ar_startblock = cpu_to_be32(bno);
+	rec.alloc.ar_blockcount = cpu_to_be32(len);
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+STATIC int				/* error */
+xfs_tbt_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		*bno,	/* output: starting block of extent */
+	xfs_extlen_t		*len,	/* output: length of extent */
+	int			*stat)	/* output: success/failure */
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (!error && *stat == 1) {
+		*bno = be32_to_cpu(rec->alloc.ar_startblock);
+		*len = be32_to_cpu(rec->alloc.ar_blockcount);
+	}
+	return error;
+}
+
+STATIC int
+xfs_tbt_destroy_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_trans	*tp = cur->bc_tp;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+}
+
+/*
+ * Build a full tree of the required depth of single block extents
+ * separated by a single block. We want discrete reecords to be
+ * built here.
+ *
+ * XXX: we probably want to create larger holes as well to be able
+ * to do more coverage on left and right merging and splitting.
+ * However, that is really a function of the specific implementation,
+ * not the core btree code which
+ */
+STATIC int
+xfs_tbt_build_sparse_tree(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agbp,
+	int			levels)
+{
+	struct xfs_btree_cur	*cur;
+	int			i;
+	xfs_agblock_t		offset = XFS_TBT_FIRST_FREE_BLOCK;
+	xfs_extlen_t		len = 1;
+	struct xfs_agf		*agf;
+	int			error = 0, error2;
+
+	agf = XFS_BUF_TO_AGF(agbp);
+	while (be32_to_cpu(agf->agf_levels[0]) < levels) {
+		cur = xfs_tbt_init_cursor(mp, agno, agbp);
+		if (!cur)
+			return ENOMEM;
+
+		i = 0;
+		/* Check the extent does not exist */
+		error = xfs_tbt_lookup_eq(cur, offset, len, &i);
+		if (error) {
+			cmn_err(CE_ALERT, "%s: lookup error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 0);
+
+		/* Insert the extent */
+		cur->bc_rec.a.ar_startblock = offset;
+		cur->bc_rec.a.ar_blockcount = len;
+		i = 0;
+		error = xfs_btree_insert(cur, &i);
+		if (error) {
+			cmn_err(CE_ALERT, "%s: insert failed at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		/* keep a count of records in the tree */
+		be32_add_cpu(&agf->agf_spare0, 1);
+
+		/* move on to new extent */
+		offset += 2;
+
+out_error:
+		error2 = xfs_tbt_destroy_cursor(cur);
+		if (error2) {
+			cmn_err(CE_ALERT,
+				"%s: failed to commit transaction (%d)",
+				__func__, error);
+			if (!error)
+				error = error2;
+		}
+
+		if (error)
+			return error;
+	}
+
+	/* record largest offset added */
+	agf->agf_spare1 = cpu_to_be32(offset);
+	return error;
+}
+
+STATIC int
+xfs_tbt_empty_sparse_tree(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agbp,
+	int			levels)
+{
+	int			error = 0, error2;
+	int			i;
+	struct xfs_btree_cur	*cur;
+	struct xfs_agf		*agf;
+
+	agf = XFS_BUF_TO_AGF(agbp);
+	while (be32_to_cpu(agf->agf_spare0) > 0) {
+		cur = xfs_tbt_init_cursor(mp, agno, agbp);
+		if (!cur)
+			return ENOMEM;
+		i = 0;
+
+		/* find the extent that spans this offset/len */
+		error = xfs_tbt_lookup_ge(cur, XFS_TBT_FIRST_FREE_BLOCK, 1, &i);
+		if (error) {
+			cmn_err(CE_ALERT, "%s: lookup error at offset %u (%d)",
+				__func__, XFS_TBT_FIRST_FREE_BLOCK, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		error = xfs_btree_delete(cur, &i);
+		if (error) {
+			cmn_err(CE_ALERT, "%s: "
+				"%s error at offset %u (%d)",
+				__func__, "xfs_btree_delete",
+				XFS_TBT_FIRST_FREE_BLOCK, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		be32_add_cpu(&agf->agf_spare0, -1);
+out_error:
+		error2 = xfs_tbt_destroy_cursor(cur);
+		if (error2) {
+			cmn_err(CE_ALERT,
+				"%s: failed to commit transaction (%d)",
+				__func__, error);
+			if (!error)
+				error = error2;
+		}
+
+		if (error)
+			return error;
+	}
+
+	return error;
+}
+
+/*
+ * Take a tree and punch alternate blocks out of it until it
+ * reaches the required depth. The will split records apart.
+ *
+ * Hacked out of xfs_tbt_fixup_trees()
+ */
+STATIC int
+xfs_tbt_punch_sparse_tree(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agbp,
+	int			levels,
+	int			dir)
+{
+	int			error = 0, error2;
+	int			i;
+	xfs_agblock_t		fbno;
+	xfs_agblock_t		nfbno1;
+	xfs_agblock_t		nfbno2;
+	xfs_extlen_t		flen = 0;
+	xfs_extlen_t		nflen1 = 0;
+	xfs_extlen_t		nflen2 = 0;
+	xfs_agblock_t		offset;
+	xfs_extlen_t		len;
+	xfs_agblock_t		delta;
+	struct xfs_btree_cur	*cur;
+	struct xfs_agf		*agf;
+
+	agf = XFS_BUF_TO_AGF(agbp);
+
+	switch (dir) {
+	default:
+	case 0:	/* r to l */
+		offset = XFS_TBT_FIRST_FREE_BLOCK + 1;
+		len = 1;
+		delta = 2;
+		break;
+	case 1:	/* l to r */
+		offset = be32_to_cpu(agf->agf_spare1) - 3; // why??
+		len = 1;
+		delta = -2;
+		break;
+	case 2:	/* middle to r/l */
+		/* XXX: not implemented yet */
+		return 0;
+		break;
+	}
+
+	while (be32_to_cpu(agf->agf_levels[0]) < levels) {
+		cur = xfs_tbt_init_cursor(mp, agno, agbp);
+		if (!cur)
+			return ENOMEM;
+
+		i = 0;
+		/* find the extent that spans this offset/len */
+		error = xfs_tbt_lookup_le(cur, offset, 1, &i);
+		if (error) {
+			cmn_err(CE_ALERT, "%s: lookup error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		/* get the range of the extent */
+		error = xfs_tbt_get_rec(cur, &fbno, &flen, &i);
+		if (error) {
+			cmn_err(CE_ALERT, "%s: get_rec error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1 && fbno <= offset && flen >= len);
+
+		if (fbno == offset && flen == len)
+			/* just delete the record under the cursor */
+			nfbno1 = nfbno2 = NULLAGBLOCK;
+		else if (fbno == offset) {
+			/* punching out left edge */
+			nfbno1 = fbno + len;
+			nflen1 = flen - len;
+			nfbno2 = NULLAGBLOCK;
+		} else if (fbno + flen == offset + len) {
+			/* punching out right edge */
+			nfbno1 = fbno;
+			nflen1 = flen - len;
+			nfbno2 = NULLAGBLOCK;
+		} else {
+			/* punching out left and right edge */
+			nfbno1 = fbno;
+			nflen1 = offset - fbno;
+			nfbno2 = offset + len;
+			nflen2 = (fbno + flen) - nfbno2;
+		}
+
+		if (nfbno1 == NULLAGBLOCK) {
+			error = xfs_btree_delete(cur, &i);
+			if (error) {
+				cmn_err(CE_ALERT, "%s: "
+					"%s error at offset %u (%d)",
+					__func__, "xfs_btree_delete",
+					offset, error);
+				goto out_error;
+			}
+			XFS_WANT_CORRUPTED_RETURN(i == 1);
+			be32_add_cpu(&agf->agf_spare0, -1);
+		} else {
+			/*
+			 * Update the by-block entry to start later|be shorter.
+			 */
+			error = xfs_tbt_update(cur, nfbno1, nflen1);
+			if (error) {
+				cmn_err(CE_ALERT, "%s: "
+				"xfs_btree_update error at offset %u (%d)",
+				__func__, offset, error);
+				goto out_error;
+			}
+		}
+		if (nfbno2 != NULLAGBLOCK) {
+			/*
+			 * Need to add the second entry. Confirm it does not
+			 * exist first
+			 */
+			error = xfs_tbt_lookup_eq(cur, nfbno2, nflen2, &i);
+			if (error) {
+				cmn_err(CE_ALERT, "%s: "
+				"lookup equal error at nfbno2 %u (%d)",
+				__func__, nfbno2, error);
+				goto out_error;
+			}
+			XFS_WANT_CORRUPTED_RETURN(i == 0);
+			error = xfs_btree_insert(cur, &i);
+			if (error) {
+				cmn_err(CE_ALERT,
+					"%s: insert error at nfbno2 %u (%d)",
+					__func__, nfbno2, error);
+				goto out_error;
+			}
+			XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+			/* keep a count of records in the tree */
+			be32_add_cpu(&agf->agf_spare0, 1);
+		}
+
+		/* move on to new extent */
+		offset += delta;
+
+out_error:
+		error2 = xfs_tbt_destroy_cursor(cur);
+		if (error2) {
+			cmn_err(CE_ALERT,
+				"%s: failed to commit transaction (%d)",
+				__func__, error);
+			if (!error)
+				error = error2;
+		}
+
+		if (error)
+			return error;
+	}
+
+	return error;
+}
+
+/*
+ * Take a sparse tree and fill the holes in it until there are
+ * no holes left. This requires finding the hole and it's adjacent
+ * extent(s) and updating extents in place and deleting old
+ * overlapping extents.
+ *
+ * XXX: only handles single extent holes in the tree
+ */
+STATIC int
+xfs_tbt_fill_sparse_tree(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agbp,
+	int			levels,
+	int			dir)
+{
+	int			error = 0, error2;
+	int			i;
+	xfs_agblock_t		lbno;
+	xfs_agblock_t		rbno;
+	xfs_extlen_t		llen = 0;
+	xfs_extlen_t		rlen = 0;
+	xfs_agblock_t		offset;
+	xfs_extlen_t		len;
+	struct xfs_btree_cur	*cur;
+	struct xfs_agf		*agf;
+	int			delta;
+
+	agf = XFS_BUF_TO_AGF(agbp);
+
+	switch (dir) {
+	default:
+	case 0:	/* r to l */
+		offset = XFS_TBT_FIRST_FREE_BLOCK + 1;
+		len = 1;
+		delta = 2;
+		break;
+	case 1:	/* l to r */
+		offset = be32_to_cpu(agf->agf_spare1) - 3; // why??
+		len = 1;
+		delta = -2;
+		break;
+	case 2:	/* middle to r/l */
+		/* XXX: not implemented yet */
+		return 0;
+		break;
+	}
+
+	while (be32_to_cpu(agf->agf_spare0) > 1) {
+		cur = xfs_tbt_init_cursor(mp, agno, agbp);
+		if (!cur)
+			return ENOMEM;
+
+		/* are we in a hole? (should be) */
+		error = xfs_tbt_lookup_eq(cur, offset, len, &i);
+		if (error) {
+			cmn_err(CE_ALERT,
+				"%s: eqlookup error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 0);
+
+		/* find left neighbour */
+		error = xfs_tbt_lookup_le(cur, offset, len, &i);
+		if (error) {
+			cmn_err(CE_ALERT,
+				"%s: lelookup error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		/* get the range of the extent */
+		error = xfs_tbt_get_rec(cur, &lbno, &llen, &i);
+		if (error) {
+			cmn_err(CE_ALERT,
+				"%s: leget_rec error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		/* find right neighbour */
+		error = xfs_tbt_lookup_ge(cur, offset, len, &i);
+		if (error) {
+			cmn_err(CE_ALERT,
+				"%s: gelookup error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		/* get the range of the extent */
+		error = xfs_tbt_get_rec(cur, &rbno, &rlen, &i);
+		if (error) {
+			cmn_err(CE_ALERT,
+				"%s: geget_rec error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		error = EIO;
+		if (lbno + llen != offset) {
+			cmn_err(CE_ALERT,
+				"%s: left record not correct at %u (%u,%u)",
+				__func__, offset, lbno, llen);
+			goto out_error;
+		} else if (offset + len != rbno) {
+			cmn_err(CE_ALERT,
+				"%s: right record not correct at %u (%u,%u)",
+				__func__, offset, rbno, rlen);
+			goto out_error;
+		}
+
+		/*
+		 * fill hole: update one record, delete the other.
+		 * The cursor currently points at the right record,
+		 * so delete it and update the left record. Technically
+		 * this is correct as the index of the left record does
+		 * not change - only it's length
+		 */
+		llen = llen + len + rlen;
+		error = xfs_btree_delete(cur, &i);
+		if (error) {
+			cmn_err(CE_ALERT,
+				"%s: xfs_btree_delete error at offset %u (%d)",
+				__func__, rbno, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		be32_add_cpu(&agf->agf_spare0, -1);
+
+		/* find left neighbour (again) */
+		error = xfs_tbt_lookup_le(cur, offset, len, &i);
+		if (error) {
+			cmn_err(CE_ALERT,
+				"%s: lelookup error at offset %u (%d)",
+				__func__, offset, error);
+			goto out_error;
+		}
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		/* Update the left entry */
+		error = xfs_tbt_update(cur, lbno, llen);
+		if (error) {
+			cmn_err(CE_ALERT,
+				"%s: xfs_btree_update error at offset %u (%d)",
+				__func__, lbno, error);
+			goto out_error;
+		}
+
+		/* move on to new extent */
+		offset += delta;
+
+out_error:
+		error2 = xfs_tbt_destroy_cursor(cur);
+		if (error2) {
+			cmn_err(CE_ALERT,
+				"%s: failed to commit transaction (%d)",
+				__func__, error);
+			if (!error)
+				error = error2;
+		}
+
+		if (error)
+			return error;
+	}
+
+	return error;
+}
+
+STATIC int
+xfs_tbt_init_ag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		*agbnop)
+{
+	xfs_extlen_t		agsize = mp->m_sb.sb_agblocks;
+	struct xfs_buf		*bp;
+	struct xfs_btree_block	*block;
+	struct xfs_alloc_rec	*arec;
+	xfs_agblock_t		agbno;
+	xfs_agblock_t		rbno;
+	int			error;
+	struct xfs_agf		*agf;
+
+	/* Allocate a btree root block */
+	error = xfs_tbt_alloc(&rbno);
+	if (error) {
+		printk("xfs_tbt_alloc failed\n");
+		return error;
+	}
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AGB_TO_DADDR(mp, agno, rbno),
+			 BTOBB(mp->m_sb.sb_blocksize), 0);
+
+	block = XFS_BUF_TO_BLOCK(bp);
+	memset(block, 0, mp->m_sb.sb_blocksize);
+	block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
+	block->bb_level = 0;
+	block->bb_numrecs = cpu_to_be16(1);
+	block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
+	block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+
+	arec = XFS_BTREE_REC_ADDR(xfs_alloc, block, 1);
+	arec->ar_startblock = cpu_to_be32(2); /* don't start at the beginning */
+	arec->ar_blockcount = cpu_to_be32(mp->m_sb.sb_agblocks -
+					  be32_to_cpu(arec->ar_startblock));
+
+	error = xfs_bwrite(mp, bp);
+	if (error)
+		return error;
+
+	/*
+	 * AG freelist header block
+	 */
+	error = xfs_tbt_alloc(&agbno);
+	if (error) {
+		printk("xfs_tbt_alloc failed\n");
+		return error;
+	}
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			  XFS_AG_DADDR(mp, agno, agbno),
+			  XFS_FSS_TO_BB(mp, 1), 0);
+
+	agf = XFS_BUF_TO_AGF(bp);
+	memset(agf, 0, mp->m_sb.sb_sectsize);
+	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
+	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
+	agf->agf_seqno = cpu_to_be32(agno);
+	agf->agf_length = cpu_to_be32(agsize);
+	agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(rbno); //
+	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(rbno); //
+	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
+	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
+	agf->agf_flfirst = 0;
+	agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
+	agf->agf_flcount = 0;
+	/* don't start at the beginning */
+	agf->agf_freeblks = cpu_to_be32(agsize - 2);
+	agf->agf_longest = cpu_to_be32(agsize - 2);
+
+	error = xfs_bwrite(mp, bp);
+	if (error)
+		return error;
+
+	*agbnop = agbno;
+	return 0;
+}
+
+STATIC int
+xfs_tbt_read_agf(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	struct xfs_buf		**bpp)
+{
+	int			error;
+
+	ASSERT(agno != NULLAGNUMBER);
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, agno, agbno),
+			XFS_FSS_TO_BB(mp, 1), 0, bpp);
+	if (error)
+		return error;
+
+	ASSERT(*bpp);
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	return 0;
+}
+
+int
+xfs_tbt_test_one(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			levels)
+{
+	struct xfs_buf		*agbp = NULL;
+	int			error;
+	xfs_agblock_t		agbno;
+
+	if (levels > XFS_AG_MAXLEVELS(mp)) {
+		cmn_err(CE_WARN, "filesystem only supports %d btree levels\n",
+				 XFS_AG_MAXLEVELS(mp));
+		return -EINVAL;
+	}
+
+	cmn_err(CE_NOTE, "xfs_tbt_test_all: Testing %d levels", levels);
+
+	error = xfs_tbt_init_freelist(mp, agno);
+	if (error) {
+		cmn_err(CE_WARN, "xfs_tbt_init_freelist failed (%d).\n", error);
+		goto out;
+	}
+
+	error = xfs_tbt_init_ag(mp, agno, &agbno);
+	if (error) {
+		cmn_err(CE_WARN, "xfs_tbt_init_ag failed (%d).\n", error);
+		goto out_free_freelist;
+	}
+
+	error = xfs_tbt_read_agf(mp, NULL, agno, agbno, &agbp);
+	if (error || agbp == NULL) {
+		cmn_err(CE_WARN, "xfs_alloc_read_agf failed (%d).\n", error);
+		goto out_free_ag;
+	}
+
+
+	error = xfs_tbt_build_sparse_tree(mp, agno, agbp, levels);
+	if (error)
+		goto out_free_ag;
+	error = xfs_tbt_fill_sparse_tree(mp, agno, agbp, levels,
+					 0 /* left to right */);
+	if (error)
+		goto out_free_ag;
+	error = xfs_tbt_punch_sparse_tree(mp, agno, agbp, levels,
+					  0 /* l to r */);
+	if (error)
+		goto out_free_ag;
+	error = xfs_tbt_fill_sparse_tree(mp, agno, agbp, levels,
+					 1 /* r to l */);
+	if (error)
+		goto out_free_ag;
+	error = xfs_tbt_punch_sparse_tree(mp, agno, agbp, levels,
+					  1 /* r to l */);
+	if (error)
+		goto out_free_ag;
+#ifdef notyet
+	error = xfs_tbt_fill_sparse_tree(mp, agno, agbp, levels,
+					 2 /* middle to r/l */);
+	if (error)
+		goto out_free_ag;
+	error = xfs_tbt_punch_sparse_tree(mp, agno, agbp, levels,
+					  2 /* middle to r/l */);
+	if (error)
+		goto out_free_ag;
+#endif
+
+	error = xfs_tbt_empty_sparse_tree(mp, agno, agbp, levels);
+	if (error)
+		goto out_free_ag;
+
+	cmn_err(CE_NOTE, "xfs_tbt_test_all: Tested %d levels OK", levels);
+
+ out_free_ag:
+ 	xfs_buf_relse(agbp);
+ out_free_freelist:
+	xfs_tbt_destroy_freelist(mp);
+ out:
+ 	if (error) {
+		cmn_err(CE_WARN,
+			"xfs_tbt_test_all: fail with error %d\n", error);
+		return error;
+	}
+	cmn_err(CE_NOTE, "xfs_tbt_test_all: passed successfully\n");
+	return 0;
+}
+
+int
+xfs_ioc_test_btree(
+	struct xfs_mount	*mp,
+	void __user		*argp)
+{
+	struct xfs_ioc_test_btree tb;
+
+	if (copy_from_user(&tb, argp, sizeof(tb)))
+		return -EFAULT;
+	if (tb.flags != 0)
+		return -EINVAL;
+	return xfs_tbt_test_one(mp, tb.agno, tb.levels);
+}
Index: linux-2.6-xfs/fs/xfs/Makefile
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile	2008-08-30 18:28:46.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/Makefile	2008-08-30 18:29:03.000000000 -0300
@@ -84,6 +84,8 @@ xfs-y				+= xfs_alloc.o \
 xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o \
 				   xfs_dir2_trace.o
 
+xfs-$(CONFIG_XFS_DEBUG)		+= xfs_btree_test.o
+
 # Objects in linux/
 xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   kmem.o \
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-08-31 19:17:54.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-08-31 19:18:01.000000000 -0300
@@ -1578,7 +1578,13 @@ xfs_ioctl(
 
 		error = xfs_errortag_clearall(mp, 1);
 		return -error;
+#ifdef DEBUG
+	case XFS_IOC_TEST_BTREE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 
+		return xfs_ioc_test_btree(mp, (void __user *)arg);
+#endif
 	default:
 		return -ENOTTY;
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2008-08-31 19:17:54.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h	2008-08-31 19:18:01.000000000 -0300
@@ -74,4 +74,6 @@ extern int xfs_dev_is_read_only(struct x
 
 extern int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 
+extern int xfs_ioc_test_btree(struct xfs_mount *, void __user *);
+
 #endif	/* __XFS_LRW_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fs.h	2008-08-31 19:17:54.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfs_fs.h	2008-08-31 19:18:01.000000000 -0300
@@ -421,6 +421,15 @@ typedef struct xfs_handle {
 #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
 
 /*
+ * Arguments for the btree test suite (debug builds only).
+ */
+struct xfs_ioc_test_btree {
+	__u32		agno;
+	__u32		levels;
+	__u32		flags;
+};
+
+/*
  * ioctl commands that are used by Linux filesystems
  */
 #define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
@@ -485,6 +494,7 @@ typedef struct xfs_handle {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
+#define XFS_IOC_TEST_BTREE	     _IOW ('X', 126, struct xfs_ioc_test_btree)
 
 
 #ifndef HAVE_BBMACROS

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=fsqa-add-btree-testharness

Index: xfstests/src/Makefile
===================================================================
--- xfstests.orig/src/Makefile	2008-08-31 19:09:03.000000000 -0300
+++ xfstests/src/Makefile	2008-08-31 19:15:00.000000000 -0300
@@ -15,7 +15,7 @@ TARGETS = dirstress fill fill2 getpagesi
 LINUX_TARGETS = loggen xfsctl bstat t_mtab getdevicesize \
 	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
 	fs_perms testx looptest locktest unwritten_mmap \
-	bulkstat_unlink_test bulkstat_unlink_test_modified
+	bulkstat_unlink_test bulkstat_unlink_test_modified btree-test
 
 IRIX_TARGETS = open_unlink
 
Index: xfstests/src/btree-test.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests/src/btree-test.c	2008-08-31 19:15:14.000000000 -0300
@@ -0,0 +1,48 @@
+
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <xfs/xfs.h>
+
+/*
+ * Until headers are ready.
+ */
+#ifndef XFS_IOC_TEST_BTREE
+struct xfs_ioc_test_btree {
+	__u32		agno;
+	__u32		levels;
+	__u32		flags;
+};
+#define XFS_IOC_TEST_BTREE          _IOW ('X', 126, struct xfs_ioc_test_btree)
+#endif /* XFS_IOC_TEST_BTREE */
+
+int main(int argc, char **argv)
+{
+	struct xfs_ioc_test_btree tb;
+	int fd;
+
+	if (argc != 4) {
+		fprintf(stderr, "usage: %s path agno levels\n", argv[0]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "can't open %s\n", argv[1]);
+		return 1;
+	}
+
+	tb.agno = atoi(argv[2]);
+	tb.levels = atoi(argv[3]);
+	tb.flags = 0;
+
+	if (ioctl(fd, XFS_IOC_TEST_BTREE, &tb)) {
+		fprintf(stderr, "btree test failed: %s\n",
+			strerror(errno));
+		return 1;
+	}
+
+	return 0;
+}

--EeQfGwPcQSOJBaQU--
