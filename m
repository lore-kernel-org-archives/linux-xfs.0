Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE0DC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1706021848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KMHGxjIW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbfJIQub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:50:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJIQub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:50:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Gjcpx026561
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=u67sm4h6AjCQot81oQLvtN934DXbiVSUFebVqN8sFJA=;
 b=KMHGxjIW7a7wznullRhqTbotclIxbBE3rX4Te+A5Lkj+M9n+RSADjnvdepFd2wj7G65d
 eYg1z2Ovwu1k8obhz+jc7++hQVXfal5fwRfjeCbqcSBFONUAvGAfS7KznAFKnQEhhDZD
 jHDLSRFNcQNcRtuDwObjOwsl7sOicNN1haq8qewRQriM1r9d+fIJhmMTFHRt+le6YltA
 li6HkANBsrJh2R3jYfXcKkRRlFDBLKB8DaGGmX0XOwe2kQw948lmVJcq7/2Io3Dq/2fC
 SSuVfDeE6moQFjSJnos/nDW4lxvcmd4bGwbG7n1xD3ZFvHajgXdt/XFADMqp7zuQVHbS Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vektrnrw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjXX2054968
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vh5cb2252-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99GoPA0022366
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:50:25 -0700
Subject: [PATCH 2/4] xfs: repair free space btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:50:23 -0700
Message-ID: <157063982384.2915883.13910212943524070246.stgit@magnolia>
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

Rebuild the free space btrees from the gaps in the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_ag_resv.c |    2 
 fs/xfs/libxfs/xfs_types.h   |    7 
 fs/xfs/scrub/alloc_repair.c |  705 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c       |    8 
 fs/xfs/scrub/repair.h       |    8 
 fs/xfs/scrub/scrub.c        |    6 
 fs/xfs/scrub/trace.h        |   24 +
 fs/xfs/xfs_extent_busy.c    |   13 +
 fs/xfs/xfs_extent_busy.h    |    2 
 10 files changed, 772 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d21b59cfc530..ffcebf428ca9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -160,6 +160,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   alloc_repair.o \
 				   array.o \
 				   bitmap.o \
 				   repair.o \
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 87a9747f1d36..3f79958ce08e 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -381,6 +381,8 @@ xfs_ag_resv_free_extent(
 		/* fall through */
 	case XFS_AG_RESV_NONE:
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		/* fall through */
+	case XFS_AG_RESV_IGNORE:
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 300b3e91ca3a..6ed204333e51 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -175,6 +175,13 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_AGFL,
 	XFS_AG_RESV_METADATA,
 	XFS_AG_RESV_RMAPBT,
+
+	/*
+	 * Don't increase fdblocks when freeing extent.  This is a pony for
+	 * the bnobt repair functions to re-free the free space without
+	 * altering fdblocks.  If you think you need this you're wrong.
+	 */
+	XFS_AG_RESV_IGNORE,
 };
 
 /*
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
new file mode 100644
index 000000000000..b62ad760379b
--- /dev/null
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -0,0 +1,705 @@
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
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_refcount.h"
+#include "xfs_extent_busy.h"
+#include "xfs_health.h"
+#include "xfs_bmap.h"
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
+ * Free Space Btree Repair
+ * =======================
+ *
+ * The reverse mappings are supposed to record all space usage for the entire
+ * AG.  Therefore, we can recalculate the free extents in an AG by looking for
+ * gaps in the physical extents recorded in the rmapbt.  On a reflink
+ * filesystem this is a little more tricky in that we have to be aware that
+ * the rmap records are allowed to overlap.
+ *
+ * We derive which blocks belonged to the old bnobt/cntbt by recording all the
+ * OWN_AG extents and subtracting out the blocks owned by all other OWN_AG
+ * metadata: the rmapbt blocks visited while iterating the reverse mappings
+ * and the AGFL blocks.
+ *
+ * Once we have both of those pieces, we can reconstruct the bnobt and cntbt
+ * by blowing out the free block state and freeing all the extents that we
+ * found.  This adds the requirement that we can't have any busy extents in
+ * the AG because the busy code cannot handle duplicate records.
+ *
+ * Note that we can only rebuild both free space btrees at the same time
+ * because the regular extent freeing infrastructure loads both btrees at the
+ * same time.
+ *
+ * We use the prefix 'xrep_abt' here because we regenerate both free space
+ * allocation btrees at the same time.
+ */
+
+struct xrep_abt {
+	/* Blocks owned by the rmapbt or the agfl. */
+	struct xbitmap		not_allocbt_blocks;
+
+	/* All OWN_AG blocks. */
+	struct xbitmap		old_allocbt_blocks;
+
+	/*
+	 * New bnobt information.  All btree block reservations are added to
+	 * the reservation list in new_bnobt_info.
+	 */
+	struct xrep_newbt	new_bnobt_info;
+
+	/* new cntbt information */
+	struct xrep_newbt	new_cntbt_info;
+
+	/* Free space extents. */
+	struct xfbma		*free_records;
+
+	struct xfs_scrub	*sc;
+
+	/* Number of non-null records in @free_records. */
+	uint64_t		nr_real_records;
+
+	/* get_data()'s position in the free space record array. */
+	uint64_t		iter;
+
+	/*
+	 * Next block we anticipate seeing in the rmap records.  If the next
+	 * rmap record is greater than next_bno, we have found unused space.
+	 */
+	xfs_agblock_t		next_bno;
+
+	/* Number of free blocks in this AG. */
+	xfs_agblock_t		nr_blocks;
+
+	/* Longest free extent we found in the AG. */
+	xfs_agblock_t		longest;
+};
+
+/*
+ * Stash a free space record for all the space since the last bno we found
+ * all the way up to @end.
+ */
+static int
+xrep_abt_stash(
+	struct xrep_abt		*ra,
+	xfs_agblock_t		end)
+{
+	struct xfs_alloc_rec_incore arec = {
+		.ar_startblock	= ra->next_bno,
+		.ar_blockcount	= end - ra->next_bno,
+	};
+	int			error;
+
+	trace_xrep_abt_found(ra->sc->mp, ra->sc->sa.agno, arec.ar_startblock,
+			arec.ar_blockcount);
+
+	error = xfbma_append(ra->free_records, &arec);
+	if (error)
+		return error;
+	ra->nr_blocks += arec.ar_blockcount;
+	return 0;
+}
+
+/* Record extents that aren't in use from gaps in the rmap records. */
+STATIC int
+xrep_abt_walk_rmap(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xrep_abt		*ra = priv;
+	xfs_fsblock_t		fsb;
+	int			error;
+
+	/* Record all the OWN_AG blocks... */
+	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		error = xbitmap_set(&ra->old_allocbt_blocks, fsb,
+				rec->rm_blockcount);
+		if (error)
+			return error;
+	}
+
+	/* ...and all the rmapbt blocks... */
+	error = xbitmap_set_btcur_path(&ra->not_allocbt_blocks, cur);
+	if (error)
+		return error;
+
+	/* ...and all the free space. */
+	if (rec->rm_startblock > ra->next_bno) {
+		error = xrep_abt_stash(ra, rec->rm_startblock);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * rmap records can overlap on reflink filesystems, so project next_bno
+	 * as far out into the AG space as we currently know about.
+	 */
+	ra->next_bno = max_t(xfs_agblock_t, ra->next_bno,
+			rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
+/* Collect an AGFL block for the not-to-release list. */
+static int
+xrep_abt_walk_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		bno,
+	void			*priv)
+{
+	struct xrep_abt		*ra = priv;
+	xfs_fsblock_t		fsb;
+
+	fsb = XFS_AGB_TO_FSB(mp, ra->sc->sa.agno, bno);
+	return xbitmap_set(&ra->not_allocbt_blocks, fsb, 1);
+}
+
+/*
+ * Compare two free space extents by block number.  We want to sort by block
+ * number.
+ */
+static int
+xrep_bnobt_extent_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_alloc_rec_incore *ap = a;
+	const struct xfs_alloc_rec_incore *bp = b;
+
+	if (ap->ar_startblock > bp->ar_startblock)
+		return 1;
+	else if (ap->ar_startblock < bp->ar_startblock)
+		return -1;
+	return 0;
+}
+
+/*
+ * Compare two free space extents by length and then block number.  We want
+ * to sort first in order of decreasing length and then in increasing block
+ * number.
+ */
+static int
+xrep_cntbt_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xfs_alloc_rec_incore *ap = a;
+	const struct xfs_alloc_rec_incore *bp = b;
+
+	if (ap->ar_blockcount > bp->ar_blockcount)
+		return 1;
+	else if (ap->ar_blockcount < bp->ar_blockcount)
+		return -1;
+	return xrep_bnobt_extent_cmp(a, b);
+}
+
+/*
+ * Iterate all reverse mappings to find (1) the gaps between rmap records (all
+ * unowned space), (2) the OWN_AG extents (which encompass the free space
+ * btrees, the rmapbt, and the agfl), (3) the rmapbt blocks, and (4) the AGFL
+ * blocks.  The free space is (1) + (2) - (3) - (4).
+ */
+STATIC int
+xrep_abt_find_freespace(
+	struct xrep_abt		*ra)
+{
+	struct xfs_scrub	*sc = ra->sc;
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_agblock_t		agend;
+	int			error;
+
+	xbitmap_init(&ra->not_allocbt_blocks);
+
+	/*
+	 * Iterate all the reverse mappings to find gaps in the physical
+	 * mappings, all the OWN_AG blocks, and all the rmapbt extents.
+	 */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xrep_abt_walk_rmap, ra);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto err;
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agend = be32_to_cpu(XFS_BUF_TO_AGF(sc->sa.agf_bp)->agf_length);
+	if (ra->next_bno < agend) {
+		error = xrep_abt_stash(ra, agend);
+		if (error)
+			goto err;
+	}
+
+	/* Collect all the AGFL blocks. */
+	error = xfs_agfl_walk(mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
+			sc->sa.agfl_bp, xrep_abt_walk_agfl, ra);
+	if (error)
+		goto err;
+
+	/* Compute the old bnobt/cntbt blocks. */
+	xbitmap_disunion(&ra->old_allocbt_blocks, &ra->not_allocbt_blocks);
+
+	ra->nr_real_records = xfbma_length(ra->free_records);
+err:
+	xbitmap_destroy(&ra->not_allocbt_blocks);
+	return error;
+}
+
+/*
+ * We're going to use the observed free space records to reserve blocks for the
+ * new free space btrees, so we play an iterative game where we try to converge
+ * on the number of blocks we need:
+ *
+ * 1. Estimate how many blocks we'll need to store the records.
+ * 2. If the first free record has more blocks than we need, we're done.
+ *    We will have to re-sort the records prior to building the cntbt.
+ * 3. If that record has exactly the number of blocks we need, null out the
+ *    record.  We're done.
+ * 4. Otherwise, we still need more blocks.  Null out the record, subtract its
+ *    length from the number of blocks we need, and go back to step 1.
+ *
+ * Fortunately, we don't have to do any transaction work to play this game, so
+ * we don't have to tear down the staging cursors.
+ */
+STATIC int
+xrep_abt_reserve_space(
+	struct xrep_abt		*ra,
+	struct xfs_btree_cur	*bno_cur,
+	struct xfs_btree_bload	*bno_bload,
+	struct xfs_btree_cur	*cnt_cur,
+	struct xfs_btree_bload	*cnt_bload,
+	bool			*need_resort)
+{
+	struct xfs_scrub	*sc = ra->sc;
+	uint64_t		record_nr = xfbma_length(ra->free_records) - 1;
+	unsigned int		allocated = 0;
+	int			error = 0;
+
+	*need_resort = false;
+	do {
+		struct xfs_alloc_rec_incore arec;
+		uint64_t		required;
+		unsigned int		desired;
+		unsigned int		found;
+
+		/* Compute how many blocks we'll need. */
+		error = xfs_btree_bload_compute_geometry(cnt_cur, cnt_bload,
+				ra->nr_real_records);
+		if (error)
+			break;
+
+		error = xfs_btree_bload_compute_geometry(bno_cur, bno_bload,
+				ra->nr_real_records);
+		if (error)
+			break;
+
+		/* How many btree blocks do we need to store all records? */
+		required = cnt_bload->nr_blocks + bno_bload->nr_blocks;
+		ASSERT(required < INT_MAX);
+
+		/* If we've reserved enough blocks, we're done. */
+		if (allocated >= required)
+			break;
+
+		desired = required - allocated;
+
+		/* We need space but there's none left; bye! */
+		if (ra->nr_real_records == 0) {
+			error = -ENOSPC;
+			break;
+		}
+
+		/* Grab the first record from the list. */
+		error = xfbma_get(ra->free_records, record_nr, &arec);
+		if (error)
+			break;
+
+		ASSERT(arec.ar_blockcount <= UINT_MAX);
+		found = min_t(unsigned int, arec.ar_blockcount, desired);
+
+		error = xrep_newbt_add_reservation(&ra->new_bnobt_info,
+				XFS_AGB_TO_FSB(sc->mp, sc->sa.agno,
+						arec.ar_startblock),
+				found, NULL);
+		if (error)
+			break;
+		allocated += found;
+		ra->nr_blocks -= found;
+
+		if (arec.ar_blockcount > desired) {
+			/*
+			 * Record has more space than we need.  The number of
+			 * free records doesn't change, so shrink the free
+			 * record and exit the loop.
+			 */
+			arec.ar_startblock += desired;
+			arec.ar_blockcount -= desired;
+			error = xfbma_set(ra->free_records, record_nr, &arec);
+			if (error)
+				break;
+			*need_resort = true;
+			break;
+		}
+
+		/*
+		 * We're going to use up the entire record, so nullify it and
+		 * move on to the next one.  This changes the number of free
+		 * records, so we must go around the loop once more to re-run
+		 * _bload_init.
+		 */
+		error = xfbma_nullify(ra->free_records, record_nr);
+		if (error)
+			break;
+		ra->nr_real_records--;
+		record_nr--;
+	} while (1);
+
+	return error;
+}
+
+/*
+ * Deal with all the space we reserved.  Blocks that were allocated for the
+ * free space btrees need to have a (deferred) rmap added for the OWN_AG
+ * allocation, and blocks that didn't get used can be freed via the usual
+ * (deferred) means.
+ */
+STATIC void
+xrep_abt_dispose_reservations(
+	struct xrep_abt		*ra,
+	int			error)
+{
+	struct xrep_newbt_resv	*resv, *n;
+	struct xfs_scrub	*sc = ra->sc;
+
+	if (error)
+		goto junkit;
+
+	for_each_xrep_newbt_reservation(&ra->new_bnobt_info, resv, n) {
+		/* Add a deferred rmap for each extent we used. */
+		if (resv->used > 0)
+			xfs_rmap_alloc_extent(sc->tp,
+					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
+					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
+					resv->used, XFS_RMAP_OWN_AG);
+
+		/*
+		 * Add a deferred free for each block we didn't use and now
+		 * have to add to the free space since the new btrees are
+		 * online.
+		 */
+		if (resv->used < resv->len)
+			__xfs_bmap_add_free(sc->tp, resv->fsbno + resv->used,
+					resv->len - resv->used, NULL, true);
+	}
+
+junkit:
+	for_each_xrep_newbt_reservation(&ra->new_bnobt_info, resv, n) {
+		list_del(&resv->list);
+		kmem_free(resv);
+	}
+
+	xrep_newbt_destroy(&ra->new_bnobt_info, error);
+	xrep_newbt_destroy(&ra->new_cntbt_info, error);
+}
+
+/* Retrieve free space data for bulk load. */
+STATIC int
+xrep_abt_get_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
+	struct xrep_abt			*ra = priv;
+	int				error;
+
+	do {
+		error = xfbma_get(ra->free_records, ra->iter++, arec);
+	} while (error == 0 && xfbma_is_null(ra->free_records, arec));
+
+	ra->longest = max(ra->longest, arec->ar_blockcount);
+	return error;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_abt_bload_alloc(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_abt		*ra = priv;
+
+	return xrep_newbt_alloc_block(cur, &ra->new_bnobt_info, ptr);
+}
+
+/*
+ * Reset the AGF counters to reflect the free space btrees that we just
+ * rebuilt, then reinitialize the per-AG data.
+ */
+STATIC int
+xrep_abt_reset_counters(
+	struct xrep_abt		*ra,
+	unsigned int		freesp_btreeblks)
+{
+	struct xfs_scrub	*sc = ra->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_agf		*agf;
+	struct xfs_buf		*bp;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+
+	/*
+	 * Mark the pagf information stale and use the accessor function to
+	 * forcibly reload it from the values we just logged.  We still own the
+	 * AGF buffer so we can safely ignore bp.
+	 */
+	ASSERT(pag->pagf_init);
+	pag->pagf_init = 0;
+
+	agf->agf_btreeblks = cpu_to_be32(freesp_btreeblks +
+				(be32_to_cpu(agf->agf_rmap_blocks) - 1));
+	agf->agf_freeblks = cpu_to_be32(ra->nr_blocks);
+	agf->agf_longest = cpu_to_be32(ra->longest);
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_BTREEBLKS |
+						 XFS_AGF_LONGEST |
+						 XFS_AGF_FREEBLKS);
+
+	return xfs_alloc_read_agf(sc->mp, sc->tp, sc->sa.agno, 0, &bp);
+}
+
+/*
+ * Use the collected free space information to stage new free space btrees.
+ * If this is successful we'll return with the new btree root
+ * information logged to the repair transaction but not yet committed.
+ */
+STATIC int
+xrep_abt_build_new_trees(
+	struct xrep_abt		*ra)
+{
+	struct xfs_btree_bload	bno_bload = {
+		.get_data	= xrep_abt_get_data,
+		.alloc_block	= xrep_abt_bload_alloc,
+	};
+	struct xfs_btree_bload	cnt_bload = {
+		.get_data	= xrep_abt_get_data,
+		.alloc_block	= xrep_abt_bload_alloc,
+	};
+	struct xfs_scrub	*sc = ra->sc;
+	struct xfs_btree_cur	*bno_cur;
+	struct xfs_btree_cur	*cnt_cur;
+	bool			need_resort;
+	int			error;
+
+	xrep_bload_estimate_slack(sc, &bno_bload);
+	xrep_bload_estimate_slack(sc, &cnt_bload);
+
+	/*
+	 * Sort the free extents by length so that we can set up the free space
+	 * btrees in as few extents as possible.  This reduces the amount of
+	 * deferred rmap / free work we have to do at the end.
+	 */
+	error = xfbma_sort(ra->free_records, xrep_cntbt_extent_cmp);
+	if (error)
+		return error;
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the AG header.
+	 */
+	xrep_newbt_init_bare(&ra->new_bnobt_info, sc);
+	xrep_newbt_init_bare(&ra->new_cntbt_info, sc);
+
+	/* Allocate cursors for the staged btrees. */
+	bno_cur = xfs_allocbt_stage_cursor(sc->mp, sc->tp,
+			&ra->new_bnobt_info.afake, sc->sa.agno, XFS_BTNUM_BNO);
+	cnt_cur = xfs_allocbt_stage_cursor(sc->mp, sc->tp,
+			&ra->new_cntbt_info.afake, sc->sa.agno, XFS_BTNUM_CNT);
+
+	/* Reserve the space we'll need for the new btrees. */
+	error = xrep_abt_reserve_space(ra, bno_cur, &bno_bload, cnt_cur,
+			&cnt_bload, &need_resort);
+	if (error)
+		goto out_cur;
+
+	/*
+	 * If we need to re-sort the free extents by length, do so so that we
+	 * can put the records into the cntbt in the correct order.
+	 */
+	if (need_resort) {
+		error = xfbma_sort(ra->free_records, xrep_cntbt_extent_cmp);
+		if (error)
+			goto out_cur;
+	}
+
+	/* Load the free space by length tree. */
+	ra->iter = 0;
+	ra->longest = 0;
+	error = xfs_btree_bload(cnt_cur, &cnt_bload, ra);
+	if (error)
+		goto out_cur;
+
+	/* Re-sort the free extents by block number so so that we can put the
+	 * records into the bnobt in the correct order.
+	 */
+	error = xfbma_sort(ra->free_records, xrep_bnobt_extent_cmp);
+	if (error)
+		goto out_cur;
+
+	/* Load the free space by block number tree. */
+	ra->iter = 0;
+	error = xfs_btree_bload(bno_cur, &bno_bload, ra);
+	if (error)
+		goto out_cur;
+
+	/*
+	 * Install the new btrees in the AG header.  After this point the old
+	 * btree is no longer accessible and the new tree is live.
+	 *
+	 * Note: We re-read the AGF here to ensure the buffer type is set
+	 * properly.  Since we built a new tree without attaching to the AGF
+	 * buffer, the buffer item may have fallen off the buffer.  This ought
+	 * to succeed since the AGF is held across transaction rolls.
+	 */
+	error = xfs_read_agf(sc->mp, sc->tp, sc->sa.agno, 0, &sc->sa.agf_bp);
+	if (error)
+		goto out_cur;
+
+	/* Commit our new btrees. */
+	xfs_allocbt_commit_staged_btree(bno_cur, sc->sa.agf_bp);
+	xfs_btree_del_cursor(bno_cur, 0);
+	xfs_allocbt_commit_staged_btree(cnt_cur, sc->sa.agf_bp);
+	xfs_btree_del_cursor(cnt_cur, 0);
+
+	/* Reset the AGF counters now that we've changed the btree shape. */
+	error = xrep_abt_reset_counters(ra, (bno_bload.nr_blocks - 1) +
+					    (cnt_bload.nr_blocks - 1));
+	if (error)
+		goto out_newbt;
+
+	/* Dispose of any unused blocks and the accounting information. */
+	xrep_abt_dispose_reservations(ra, error);
+
+	return xrep_roll_ag_trans(sc);
+
+out_cur:
+	xfs_btree_del_cursor(cnt_cur, error);
+	xfs_btree_del_cursor(bno_cur, error);
+out_newbt:
+	xrep_abt_dispose_reservations(ra, error);
+	return error;
+}
+
+/*
+ * Now that we've logged the roots of the new btrees, invalidate all of the
+ * old blocks and free them.
+ */
+STATIC int
+xrep_abt_remove_old_trees(
+	struct xrep_abt		*ra)
+{
+	/* Free the old inode btree blocks if they're not in use. */
+	return xrep_reap_extents(ra->sc, &ra->old_allocbt_blocks,
+			&XFS_RMAP_OINFO_AG, XFS_AG_RESV_IGNORE);
+}
+
+/* Repair the freespace btrees for some AG. */
+int
+xrep_allocbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_abt		*ra;
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	ra = kmem_zalloc(sizeof(struct xrep_abt), KM_NOFS | KM_MAYFAIL);
+	if (!ra)
+		return -ENOMEM;
+	ra->sc = sc;
+
+	/* We rebuild both data structures. */
+	sc->sick_mask = XFS_SICK_AG_BNOBT | XFS_SICK_AG_CNTBT;
+
+	xchk_perag_get(sc->mp, &sc->sa);
+
+	/*
+	 * Make sure the busy extent list is clear because we can't put
+	 * extents on there twice.
+	 */
+	if (!xfs_extent_busy_list_empty(sc->sa.pag))
+		return -EDEADLOCK;
+
+	/* Set up some storage */
+	ra->free_records = xfbma_init(sizeof(struct xfs_alloc_rec_incore));
+	if (IS_ERR(ra->free_records)) {
+		error = PTR_ERR(ra->free_records);
+		goto out_ra;
+	}
+
+	/* Collect the free space data and find the old btree blocks. */
+	xbitmap_init(&ra->old_allocbt_blocks);
+	error = xrep_abt_find_freespace(ra);
+	if (error)
+		goto out_bitmap;
+
+	/* Rebuild the free space information. */
+	error = xrep_abt_build_new_trees(ra);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old trees. */
+	error = xrep_abt_remove_old_trees(ra);
+
+out_bitmap:
+	xbitmap_destroy(&ra->old_allocbt_blocks);
+	xfbma_destroy(ra->free_records);
+out_ra:
+	kmem_free(ra);
+	return error;
+}
+
+/* Make sure both btrees are ok after we've rebuilt them. */
+int
+xrep_revalidate_allocbt(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xchk_bnobt(sc);
+	if (error)
+		return error;
+
+	return xchk_cntbt(sc);
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 18876056e5e0..4a49a9099477 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -634,8 +634,14 @@ xchk_setup_ag_btree(
 	 * expensive operation should be performed infrequently and only
 	 * as a last resort.  Any caller that sets force_log should
 	 * document why they need to do so.
+	 *
+	 * Force everything in memory out to disk if we're repairing.
+	 * This ensures we won't get tripped up by btree blocks sitting
+	 * in memory waiting to have LSNs stamped in.  The AGF/AGI repair
+	 * routines use any available rmap data to try to find a btree
+	 * root that also passes the read verifiers.
 	 */
-	if (force_log) {
+	if (force_log || (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)) {
 		error = xchk_checkpoint_log(mp);
 		if (error)
 			return error;
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index cb86281de28b..4d6b9027b527 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -55,6 +55,10 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 
+/* Metadata revalidators */
+
+int xrep_revalidate_allocbt(struct xfs_scrub *sc);
+
 /* Metadata repairers */
 
 int xrep_probe(struct xfs_scrub *sc);
@@ -62,6 +66,7 @@ int xrep_superblock(struct xfs_scrub *sc);
 int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
+int xrep_allocbt(struct xfs_scrub *sc);
 
 struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
@@ -141,11 +146,14 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+#define xrep_revalidate_allocbt		(NULL)
+
 #define xrep_probe			xrep_notsupported
 #define xrep_superblock			xrep_notsupported
 #define xrep_agf			xrep_notsupported
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
+#define xrep_allocbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0f0b64d7164b..b42ac8ecdb49 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -217,13 +217,15 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
 		.scrub	= xchk_bnobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_allocbt,
+		.repair_eval = xrep_revalidate_allocbt,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
 		.scrub	= xchk_cntbt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_allocbt,
+		.repair_eval = xrep_revalidate_allocbt,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
 		.type	= ST_PERAG,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index ec6774d03dd2..754d1d71261e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -722,11 +722,33 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
-DEFINE_REPAIR_RMAP_EVENT(xrep_alloc_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
 
+TRACE_EVENT(xrep_abt_found,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t startblock, xfs_extlen_t blockcount),
+	TP_ARGS(mp, agno, startblock, blockcount),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, startblock)
+		__field(xfs_extlen_t, blockcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startblock = startblock;
+		__entry->blockcount = blockcount;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startblock,
+		  __entry->blockcount)
+)
+
 TRACE_EVENT(xrep_refcount_extent_fn,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 struct xfs_refcount_irec *irec),
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 2183d87be4cf..3ab163e223aa 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -657,3 +657,16 @@ xfs_extent_busy_ag_cmp(
 		diff = b1->bno - b2->bno;
 	return diff;
 }
+
+/* Are there any busy extents in this AG? */
+bool
+xfs_extent_busy_list_empty(
+	struct xfs_perag	*pag)
+{
+	bool			res;
+
+	spin_lock(&pag->pagb_lock);
+	res = RB_EMPTY_ROOT(&pag->pagb_tree);
+	spin_unlock(&pag->pagb_lock);
+	return res;
+}
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 990ab3891971..2f8c73c712c6 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -65,4 +65,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
 	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
+bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
+
 #endif /* __XFS_EXTENT_BUSY_H__ */

