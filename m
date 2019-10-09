Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D29ECE58C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E26A621848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IfIFaaar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfJIQuo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:50:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731192AbfJIQuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:50:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjkeM039885
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=UaRCpYmpwDmaWjye5UC/A2p5QLieg6woCE7S1b6Srio=;
 b=IfIFaaarCuOQENW45zRv3pekrf3J5vQYZuUeGZk365OLhRCkoh2IJKI5EufsfPGTtjBw
 8QxrlxMvikCYOyqWy8UdIyRVxkOHYsJCuRASOeBqvPWrKPsJohqCKiP3goTbpID5plYd
 iMOJUrpMjPQRICm+f+2Ke7IM9GxjqiqEzaw2JwaE/NfmvZ7NwPDvTslAFEsbafObBU+t
 3HSWzCUmXDwVG2vfOxNFH1ZWhVH+osqvYHyFMJixVdSn04p754grgCMcIRwmE+mEn0d3
 k/300OYJbFOCwmjvMhyYHF0oa2IE14WwOuaJdlgZX0uZeCP+G87Wj7wlHjYl5ZG2McSn HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vejkup16v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjQnw111700
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vgev1ts7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99GodsR028202
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:50:38 -0700
Subject: [PATCH 4/4] xfs: repair refcount btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:50:37 -0700
Message-ID: <157063983721.2915883.7967564615356803429.stgit@magnolia>
In-Reply-To: <157063980873.2915883.8510302923584220865.stgit@magnolia>
References: <157063980873.2915883.8510302923584220865.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Reconstruct the refcount data from the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/scrub/refcount_repair.c |  605 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |    2 
 fs/xfs/scrub/scrub.c           |    2 
 fs/xfs/scrub/trace.h           |   13 -
 5 files changed, 616 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/scrub/refcount_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6ca9755f031e..5ece4a554c9f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -164,6 +164,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   array.o \
 				   bitmap.o \
 				   ialloc_repair.o \
+				   refcount_repair.o \
 				   repair.o \
 				   xfile.o \
 				   )
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
new file mode 100644
index 000000000000..477b1d5146d5
--- /dev/null
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -0,0 +1,605 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_error.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/array.h"
+
+/*
+ * Rebuilding the Reference Count Btree
+ * ====================================
+ *
+ * This algorithm is "borrowed" from xfs_repair.  Imagine the rmap
+ * entries as rectangles representing extents of physical blocks, and
+ * that the rectangles can be laid down to allow them to overlap each
+ * other; then we know that we must emit a refcnt btree entry wherever
+ * the amount of overlap changes, i.e. the emission stimulus is
+ * level-triggered:
+ *
+ *                 -    ---
+ *       --      ----- ----   ---        ------
+ * --   ----     ----------- ----     ---------
+ * -------------------------------- -----------
+ * ^ ^  ^^ ^^    ^ ^^ ^^^  ^^^^  ^ ^^ ^  ^     ^
+ * 2 1  23 21    3 43 234  2123  1 01 2  3     0
+ *
+ * For our purposes, a rmap is a tuple (startblock, len, fileoff, owner).
+ *
+ * Note that in the actual refcnt btree we don't store the refcount < 2
+ * cases because the bnobt tells us which blocks are free; single-use
+ * blocks aren't recorded in the bnobt or the refcntbt.  If the rmapbt
+ * supports storing multiple entries covering a given block we could
+ * theoretically dispense with the refcntbt and simply count rmaps, but
+ * that's inefficient in the (hot) write path, so we'll take the cost of
+ * the extra tree to save time.  Also there's no guarantee that rmap
+ * will be enabled.
+ *
+ * Given an array of rmaps sorted by physical block number, a starting
+ * physical block (sp), a bag to hold rmaps that cover sp, and the next
+ * physical block where the level changes (np), we can reconstruct the
+ * refcount btree as follows:
+ *
+ * While there are still unprocessed rmaps in the array,
+ *  - Set sp to the physical block (pblk) of the next unprocessed rmap.
+ *  - Add to the bag all rmaps in the array where startblock == sp.
+ *  - Set np to the physical block where the bag size will change.  This
+ *    is the minimum of (the pblk of the next unprocessed rmap) and
+ *    (startblock + len of each rmap in the bag).
+ *  - Record the bag size as old_bag_size.
+ *
+ *  - While the bag isn't empty,
+ *     - Remove from the bag all rmaps where startblock + len == np.
+ *     - Add to the bag all rmaps in the array where startblock == np.
+ *     - If the bag size isn't old_bag_size, store the refcount entry
+ *       (sp, np - sp, bag_size) in the refcnt btree.
+ *     - If the bag is empty, break out of the inner loop.
+ *     - Set old_bag_size to the bag size
+ *     - Set sp = np.
+ *     - Set np to the physical block where the bag size will change.
+ *       This is the minimum of (the pblk of the next unprocessed rmap)
+ *       and (startblock + len of each rmap in the bag).
+ *
+ * Like all the other repairers, we make a list of all the refcount
+ * records we need, then reinitialize the refcount btree root and
+ * insert all the records.
+ */
+
+/* The only parts of the rmap that we care about for computing refcounts. */
+struct xrep_refc_rmap {
+	xfs_agblock_t		startblock;
+	xfs_extlen_t		blockcount;
+} __packed;
+
+struct xrep_refc {
+	/* refcount extents */
+	struct xfbma		*refcount_records;
+
+	/* new refcountbt information */
+	struct xrep_newbt	new_btree_info;
+
+	/* old refcountbt blocks */
+	struct xbitmap		old_refcountbt_blocks;
+
+	struct xfs_scrub	*sc;
+
+	/* # of refcountbt blocks */
+	xfs_extlen_t		btblocks;
+
+	/* get_data()'s position in the free space record array. */
+	uint64_t		iter;
+};
+
+/* Record a reference count extent. */
+STATIC int
+xrep_refc_remember(
+	struct xrep_refc		*rr,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len,
+	xfs_nlink_t			refcount)
+{
+	struct xfs_refcount_irec	irec = {
+		.rc_startblock		= agbno,
+		.rc_blockcount		= len,
+		.rc_refcount		= refcount,
+	};
+
+	trace_xrep_refc_found(rr->sc->mp, rr->sc->sa.agno, agbno, len,
+			refcount);
+
+	return xfbma_append(rr->refcount_records, &irec);
+}
+
+/* Record a CoW staging extent. */
+STATIC int
+xrep_refc_remember_cow(
+	struct xrep_refc		*rr,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	return xrep_refc_remember(rr, agbno + XFS_REFC_COW_START, len, 1);
+}
+
+/* Grab the next (abbreviated) rmap record from the rmapbt. */
+STATIC int
+xrep_refc_next_rrm(
+	struct xfs_btree_cur	*cur,
+	struct xrep_refc	*rr,
+	struct xrep_refc_rmap	*rrm,
+	bool			*have_rec)
+{
+	struct xfs_rmap_irec	rmap;
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_fsblock_t		fsbno;
+	int			have_gt;
+	int			error = 0;
+
+	*have_rec = false;
+	/*
+	 * Loop through the remaining rmaps.  Remember CoW staging
+	 * extents and the refcountbt blocks from the old tree for later
+	 * disposal.  We can only share written data fork extents, so
+	 * keep looping until we find an rmap for one.
+	 */
+	do {
+		if (xchk_should_terminate(rr->sc, &error))
+			goto out_error;
+
+		error = xfs_btree_increment(cur, 0, &have_gt);
+		if (error)
+			goto out_error;
+		if (!have_gt)
+			return 0;
+
+		error = xfs_rmap_get_rec(cur, &rmap, &have_gt);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
+
+		if (rmap.rm_owner == XFS_RMAP_OWN_COW) {
+			error = xrep_refc_remember_cow(rr, rmap.rm_startblock,
+					rmap.rm_blockcount);
+			if (error)
+				goto out_error;
+		} else if (rmap.rm_owner == XFS_RMAP_OWN_REFC) {
+			/* refcountbt block, dump it when we're done. */
+			rr->btblocks += rmap.rm_blockcount;
+			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+					cur->bc_private.a.agno,
+					rmap.rm_startblock);
+			error = xbitmap_set(&rr->old_refcountbt_blocks,
+					fsbno, rmap.rm_blockcount);
+			if (error)
+				goto out_error;
+		}
+	} while (XFS_RMAP_NON_INODE_OWNER(rmap.rm_owner) ||
+		 xfs_internal_inum(mp, rmap.rm_owner) ||
+		 (rmap.rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+				   XFS_RMAP_UNWRITTEN)));
+
+	rrm->startblock = rmap.rm_startblock;
+	rrm->blockcount = rmap.rm_blockcount;
+	*have_rec = true;
+	return 0;
+
+out_error:
+	return error;
+}
+
+/* Compare two btree extents. */
+static int
+xrep_refc_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xfs_refcount_irec	*ap = a;
+	const struct xfs_refcount_irec	*bp = b;
+
+	if (ap->rc_startblock > bp->rc_startblock)
+		return 1;
+	else if (ap->rc_startblock < bp->rc_startblock)
+		return -1;
+	return 0;
+}
+
+#define RRM_NEXT(r)	((r).startblock + (r).blockcount)
+/*
+ * Find the next block where the refcount changes, given the next rmap we
+ * looked at and the ones we're already tracking.
+ */
+static inline xfs_agblock_t
+xrep_refc_next_edge(
+	struct xfbma		*rmap_bag,
+	struct xrep_refc_rmap	*next_rrm,
+	bool			next_valid)
+{
+	struct xrep_refc_rmap	rrm;
+	uint64_t		i;
+	xfs_agblock_t		nbno;
+
+	nbno = next_valid ? next_rrm->startblock : NULLAGBLOCK;
+	foreach_xfbma_item(rmap_bag, i, rrm)
+		nbno = min_t(xfs_agblock_t, nbno, RRM_NEXT(rrm));
+	return nbno;
+}
+
+/* Iterate all the rmap records to generate reference count data. */
+STATIC int
+xrep_refc_find_refcounts(
+	struct xrep_refc	*rr)
+{
+	struct xrep_refc_rmap	rrm;
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfbma		*rmap_bag;
+	struct xfs_btree_cur	*cur;
+	xfs_agblock_t		sbno;
+	xfs_agblock_t		cbno;
+	xfs_agblock_t		nbno;
+	size_t			old_stack_sz;
+	size_t			stack_sz = 0;
+	bool			have;
+	int			have_gt;
+	int			error;
+
+	/* Start the rmapbt cursor to the left of all records. */
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno);
+	error = xfs_rmap_lookup_le(cur, 0, 0, 0, 0, 0, &have_gt);
+	if (error)
+		goto out_cur;
+	ASSERT(have_gt == 0);
+
+	/* Set up some storage */
+	rmap_bag = xfbma_init(sizeof(struct xrep_refc_rmap));
+	if (IS_ERR(rmap_bag)) {
+		error = PTR_ERR(rmap_bag);
+		goto out_cur;
+	}
+
+	/* Process reverse mappings into refcount data. */
+	while (xfs_btree_has_more_records(cur)) {
+		/* Push all rmaps with pblk == sbno onto the stack */
+		error = xrep_refc_next_rrm(cur, rr, &rrm, &have);
+		if (error)
+			goto out;
+		if (!have)
+			break;
+		sbno = cbno = rrm.startblock;
+		while (have && rrm.startblock == sbno) {
+			error = xfbma_insert_anywhere(rmap_bag, &rrm);
+			if (error)
+				goto out;
+			stack_sz++;
+			error = xrep_refc_next_rrm(cur, rr, &rrm, &have);
+			if (error)
+				goto out;
+		}
+		error = xfs_btree_decrement(cur, 0, &have_gt);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(sc->mp, have_gt, out);
+
+		/* Set nbno to the bno of the next refcount change */
+		nbno = xrep_refc_next_edge(rmap_bag, &rrm, have);
+		if (nbno == NULLAGBLOCK) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+
+		ASSERT(nbno > sbno);
+		old_stack_sz = stack_sz;
+
+		/* While stack isn't empty... */
+		while (stack_sz) {
+			uint64_t	i;
+
+			/* Pop all rmaps that end at nbno */
+			foreach_xfbma_item(rmap_bag, i, rrm) {
+				if (RRM_NEXT(rrm) != nbno)
+					continue;
+				error = xfbma_nullify(rmap_bag, i);
+				if (error)
+					goto out;
+				stack_sz--;
+			}
+
+			/* Push array items that start at nbno */
+			error = xrep_refc_next_rrm(cur, rr, &rrm, &have);
+			if (error)
+				goto out;
+			while (have && rrm.startblock == nbno) {
+				error = xfbma_insert_anywhere(rmap_bag,
+						&rrm);
+				if (error)
+					goto out;
+				stack_sz++;
+				error = xrep_refc_next_rrm(cur, rr, &rrm,
+						&have);
+				if (error)
+					goto out;
+			}
+			error = xfs_btree_decrement(cur, 0, &have_gt);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(sc->mp, have_gt, out);
+
+			/* Emit refcount if necessary */
+			ASSERT(nbno > cbno);
+			if (stack_sz != old_stack_sz) {
+				if (old_stack_sz > 1) {
+					error = xrep_refc_remember(rr, cbno,
+							nbno - cbno,
+							old_stack_sz);
+					if (error)
+						goto out;
+				}
+				cbno = nbno;
+			}
+
+			/* Stack empty, go find the next rmap */
+			if (stack_sz == 0)
+				break;
+			old_stack_sz = stack_sz;
+			sbno = nbno;
+
+			/* Set nbno to the bno of the next refcount change */
+			nbno = xrep_refc_next_edge(rmap_bag, &rrm, have);
+			if (nbno == NULLAGBLOCK) {
+				error = -EFSCORRUPTED;
+				goto out;
+			}
+
+			ASSERT(nbno > sbno);
+		}
+	}
+
+	ASSERT(stack_sz == 0);
+out:
+	xfbma_destroy(rmap_bag);
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+#undef RRM_NEXT
+
+/* Retrieve refcountbt data for bulk load. */
+STATIC int
+xrep_refc_get_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct xfs_refcount_irec	*refc = &cur->bc_rec.rc;
+	struct xrep_refc		*rr = priv;
+	int				error;
+
+	do {
+		error = xfbma_get(rr->refcount_records, rr->iter++, refc);
+	} while (error == 0 && xfbma_is_null(rr->refcount_records, refc));
+
+	return error;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_refc_bload_alloc(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_refc        *rr = priv;
+
+	return xrep_newbt_alloc_block(cur, &rr->new_btree_info, ptr);
+}
+
+/* Update the AGF counters. */
+STATIC int
+xrep_refc_reset_counters(
+	struct xrep_refc	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_buf		*bp;
+
+	/*
+	 * Mark the pagf information stale and use the accessor function to
+	 * forcibly reload it from the values we just logged.  We still own the
+	 * AGF bp so we can safely ignore bp.
+	 */
+	ASSERT(pag->pagf_init);
+	pag->pagf_init = 0;
+
+	return xfs_alloc_read_agf(sc->mp, sc->tp, sc->sa.agno, 0, &bp);
+}
+
+/*
+ * Use the collected refcount information to stage a new refcount btree.  If
+ * this is successful we'll return with the new btree root information logged
+ * to the repair transaction but not yet committed.
+ */
+STATIC int
+xrep_refc_build_new_tree(
+	struct xrep_refc	*rr)
+{
+	struct xfs_btree_bload	refc_bload = {
+		.get_data	= xrep_refc_get_data,
+		.alloc_block	= xrep_refc_bload_alloc,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*refc_cur;
+	int			error;
+
+	xrep_bload_estimate_slack(sc, &refc_bload);
+
+	/*
+	 * Sort the refcount extents by startblock or else the btree records
+	 * will be in the wrong order.
+	 */
+	error = xfbma_sort(rr->refcount_records, xrep_refc_extent_cmp);
+	if (error)
+		return error;
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the AG header.
+	 */
+	xrep_newbt_init_ag(&rr->new_btree_info, sc, &XFS_RMAP_OINFO_REFC,
+			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno,
+				       xfs_refc_block(sc->mp)),
+			XFS_AG_RESV_METADATA);
+
+	/* Compute how many blocks we'll need. */
+	refc_cur = xfs_refcountbt_stage_cursor(sc->mp, sc->tp,
+			&rr->new_btree_info.afake, sc->sa.agno);
+	error = xfs_btree_bload_compute_geometry(refc_cur, &refc_bload,
+			xfbma_length(rr->refcount_records));
+	if (error)
+		goto err_cur;
+	xfs_btree_del_cursor(refc_cur, error);
+
+	/*
+	 * Reserve the space we'll need for the new btree.  Drop the cursor
+	 * while we do this because that can roll the transaction and cursors
+	 * can't handle that.
+	 */
+	error = xrep_newbt_reserve_space(&rr->new_btree_info,
+			refc_bload.nr_blocks);
+	if (error)
+		goto err_newbt;
+
+	/* Add all observed refcount records. */
+	rr->iter = 0;
+	refc_cur = xfs_refcountbt_stage_cursor(sc->mp, sc->tp,
+			&rr->new_btree_info.afake, sc->sa.agno);
+	error = xfs_btree_bload(refc_cur, &refc_bload, rr);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new btree in the AG header.  After this point the old
+	 * btree is no longer accessible and the new tree is live.
+	 *
+	 * Note: We re-read the AGF here to ensure the buffer type is set
+	 * properly.  Since we built a new tree without attaching to the AGF
+	 * buffer, the buffer item may have fallen off the buffer.  This ought
+	 * to succeed since the AGF is held across transaction rolls.
+	 */
+	error = xfs_read_agf(sc->mp, sc->tp, sc->sa.agno, 0, &sc->sa.agf_bp);
+	if (error)
+		goto err_cur;
+
+	/* Commit our new btree. */
+	xfs_refcountbt_commit_staged_btree(refc_cur, sc->sa.agf_bp);
+	xfs_btree_del_cursor(refc_cur, 0);
+
+	/* Reset the AGF counters now that we've changed the btree shape. */
+	error = xrep_refc_reset_counters(rr);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting information. */
+	xrep_newbt_destroy(&rr->new_btree_info, error);
+
+	return xrep_roll_ag_trans(sc);
+err_cur:
+	xfs_btree_del_cursor(refc_cur, error);
+err_newbt:
+	xrep_newbt_destroy(&rr->new_btree_info, error);
+	return error;
+}
+
+/*
+ * Now that we've logged the roots of the new btrees, invalidate all of the
+ * old blocks and free them.
+ */
+STATIC int
+xrep_refc_remove_old_tree(
+	struct xrep_refc	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	/* Free the old refcountbt blocks if they're not in use. */
+	error = xrep_reap_extents(sc, &rr->old_refcountbt_blocks,
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
+	if (error)
+		return error;
+
+	sc->flags |= XREP_RESET_PERAG_RESV;
+	return 0;
+}
+
+/* Rebuild the refcount btree. */
+int
+xrep_refcountbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_refc	*rr;
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	rr = kmem_zalloc(sizeof(struct xrep_refc), KM_NOFS | KM_MAYFAIL);
+	if (!rr)
+		return -ENOMEM;
+	rr->sc = sc;
+
+	xchk_perag_get(sc->mp, &sc->sa);
+
+	/* Set up some storage */
+	rr->refcount_records = xfbma_init(sizeof(struct xfs_refcount_irec));
+	if (IS_ERR(rr->refcount_records)) {
+		error = PTR_ERR(rr->refcount_records);
+		goto out_rr;
+	}
+
+	/* Collect all reference counts. */
+	xbitmap_init(&rr->old_refcountbt_blocks);
+	error = xrep_refc_find_refcounts(rr);
+	if (error)
+		goto out_bitmap;
+
+	/* Rebuild the refcount information. */
+	error = xrep_refc_build_new_tree(rr);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old tree. */
+	error = xrep_refc_remove_old_tree(rr);
+
+out_bitmap:
+	xbitmap_destroy(&rr->old_refcountbt_blocks);
+	xfbma_destroy(rr->refcount_records);
+out_rr:
+	kmem_free(rr);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 6719f98eae61..b89f3fd74e7b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -70,6 +70,7 @@ int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
+int xrep_refcountbt(struct xfs_scrub *sc);
 
 struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
@@ -170,6 +171,7 @@ xrep_reset_perag_resv(
 #define xrep_agi			xrep_notsupported
 #define xrep_allocbt			xrep_notsupported
 #define xrep_iallocbt			xrep_notsupported
+#define xrep_refcountbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6011823d0d40..b104231af049 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -254,7 +254,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_ag_refcountbt,
 		.scrub	= xchk_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_refcountbt,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e9aed8256680..2e1f0fe6a512 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -782,10 +782,11 @@ TRACE_EVENT(xrep_ibt_found,
 		  __entry->freemask)
 )
 
-TRACE_EVENT(xrep_refcount_extent_fn,
+TRACE_EVENT(xrep_refc_found,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 struct xfs_refcount_irec *irec),
-	TP_ARGS(mp, agno, irec),
+		 xfs_agblock_t startblock, xfs_extlen_t blockcount,
+		 xfs_nlink_t refcount),
+	TP_ARGS(mp, agno, startblock, blockcount, refcount),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -796,9 +797,9 @@ TRACE_EVENT(xrep_refcount_extent_fn,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->startblock = irec->rc_startblock;
-		__entry->blockcount = irec->rc_blockcount;
-		__entry->refcount = irec->rc_refcount;
+		__entry->startblock = startblock;
+		__entry->blockcount = blockcount;
+		__entry->refcount = refcount;
 	),
 	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),

