Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDFAC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65752206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WNfD5vfb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgAABKf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:10:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49486 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:10:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119226091305
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=bXxo6tQy1HWVhsoOK0SuqE4FsLoah6Q8hQnYF6BIT6g=;
 b=WNfD5vfbdS/hL8RDnXQ5LBKz1RZ9MxQYrgnyb9WVSOZFXYr6thSX2AEfdlaQuokXc17T
 VUiaIzng5GQ9dt2cNRmiAuKU/zxjHj/vZBOppDbl/D00bn1JBjf2NjIruk8xe4jGl+3F
 cxL1xSwqDBA2qz8SUqNfemVYhV/Uqh25orYaoeGiyewxWHQ2VsDuLiuJZi74t6GxNWOT
 TUU6+4E9QbE6llxeEO5pil11XB6hXYx0Oz4rUqb0ji/V+gSfEiYJjk0NYjGwlnAanSEy
 svkjuxquzM1Lgh35Bv2byRs8/aiaHjHb7Q8wiOvk4D8CtFxgnB2Q+QNypPmJq7cMKm6R yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118wVF172138
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj916rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:31 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011AUrR032041
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:31 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:30 -0800
Subject: [PATCH 3/5] xfs: repair the rmapbt
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:10:27 -0800
Message-ID: <157784102768.1364003.15017358874495761949.stgit@magnolia>
In-Reply-To: <157784100871.1364003.10658176827446969836.stgit@magnolia>
References: <157784100871.1364003.10658176827446969836.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rebuild the reverse mapping btree from all primary metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_bmap.c   |   34 +
 fs/xfs/libxfs/xfs_bmap.h   |    8 
 fs/xfs/scrub/bitmap.c      |   14 
 fs/xfs/scrub/bitmap.h      |    1 
 fs/xfs/scrub/repair.c      |   27 +
 fs/xfs/scrub/repair.h      |   15 -
 fs/xfs/scrub/rmap.c        |    6 
 fs/xfs/scrub/rmap_repair.c | 1304 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c       |    2 
 fs/xfs/scrub/trace.h       |    2 
 11 files changed, 1406 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/rmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7e3571469845..6f56ebcadeb6 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -169,6 +169,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode_repair.o \
 				   refcount_repair.o \
 				   repair.o \
+				   rmap_repair.o \
 				   symlink_repair.o \
 				   xfile.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c0b8f20b2a0e..a7287272b04e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6465,3 +6465,37 @@ xfs_bunmapi_range(
 out:
 	return error;
 }
+
+struct xfs_bmap_query_range {
+	xfs_bmap_query_range_fn	fn;
+	void			*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_bmap_query_range_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_bmap_query_range	*query = priv;
+	struct xfs_bmbt_irec		irec;
+
+	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all bmaps. */
+int
+xfs_bmap_query_all(
+	struct xfs_btree_cur		*cur,
+	xfs_bmap_query_range_fn		fn,
+	void				*priv)
+{
+	struct xfs_bmap_query_range	query = {
+		.priv			= priv,
+		.fn			= fn,
+	};
+
+	return xfs_btree_query_all(cur, xfs_bmap_query_range_helper, &query);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index ec29d5012a49..f8da2d5b81b8 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -290,4 +290,12 @@ int	xfs_bunmapi_range(struct xfs_trans **tpp, struct xfs_inode *ip,
 		int whichfork, xfs_fileoff_t startoff, xfs_filblks_t unmap_len,
 		int bunmapi_flags);
 
+typedef int (*xfs_bmap_query_range_fn)(
+	struct xfs_btree_cur	*cur,
+	struct xfs_bmbt_irec	*rec,
+	void			*priv);
+
+int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
+		void *priv);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 4fad962a360b..a304a54997f9 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -368,3 +368,17 @@ xbitmap_empty(
 {
 	return bitmap->xb_root.rb_root.rb_node == NULL;
 }
+
+/* Count the number of set regions in this bitmap. */
+uint64_t
+xbitmap_count_set_regions(
+	struct xbitmap		*bitmap)
+{
+	struct xbitmap_node	*bn;
+	uint64_t		nr = 0;
+
+	for_each_xbitmap_extent(bn, bitmap)
+		nr++;
+
+	return nr;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 102ab5c89012..33548004f111 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -38,5 +38,6 @@ int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
 		void *priv);
 
 bool xbitmap_empty(struct xbitmap *bitmap);
+uint64_t xbitmap_count_set_regions(struct xbitmap *bitmap);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 78e1355f3665..a0a607f05919 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -507,6 +507,18 @@ xrep_newbt_alloc_blocks(
 		};
 		void			*token;
 
+		/*
+		 * If we don't want an rmap update on the allocation, we need
+		 * to fix the freelist with the NORMAP flag set so that we
+		 * don't also try to create an rmap for new AGFL blocks.  This
+		 * should only ever be used by the rmap repair function.
+		 */
+		if (xfs_rmap_should_skip_owner_update(&xnr->oinfo)) {
+			error = xrep_fix_freelist(sc, XFS_ALLOC_FLAG_NORMAP);
+			if (error)
+				return error;
+		}
+
 		error = xfs_alloc_vextent(&args);
 		if (error)
 			return error;
@@ -797,7 +809,7 @@ xrep_bload_estimate_slack(
 int
 xrep_fix_freelist(
 	struct xfs_scrub	*sc,
-	bool			can_shrink)
+	int			alloc_flags)
 {
 	struct xfs_alloc_arg	args = {0};
 
@@ -807,8 +819,7 @@ xrep_fix_freelist(
 	args.alignment = 1;
 	args.pag = sc->sa.pag;
 
-	return xfs_alloc_fix_freelist(&args,
-			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
+	return xfs_alloc_fix_freelist(&args, alloc_flags);
 }
 
 /*
@@ -822,7 +833,7 @@ xrep_put_freelist(
 	int			error;
 
 	/* Make sure there's space on the freelist. */
-	error = xrep_fix_freelist(sc, true);
+	error = xrep_fix_freelist(sc, 0);
 	if (error)
 		return error;
 
@@ -946,6 +957,14 @@ xrep_reap_block(
 	} else if (rb->resv == XFS_AG_RESV_AGFL) {
 		xrep_reap_invalidate_block(sc, fsbno);
 		error = xrep_put_freelist(sc, agbno);
+	} else if (rb->resv == XFS_AG_RESV_RMAPBT) {
+		/*
+		 * rmapbt blocks are counted as free space, so we have to pass
+		 * XFS_AG_RESV_RMAPBT in the freeing operation to avoid
+		 * decreasing fdblocks incorrectly.
+		 */
+		xrep_reap_invalidate_block(sc, fsbno);
+		error = xfs_free_extent(sc->tp, fsbno, 1, rb->oinfo, rb->resv);
 	} else {
 		/*
 		 * Use deferred frees to get rid of the old btree blocks to try
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 1854b3f3ebec..4bfa2d0b0f37 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -34,7 +34,7 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 
 struct xbitmap;
 
-int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
+int xrep_fix_freelist(struct xfs_scrub *sc, int alloc_flags);
 int xrep_reap_extents(struct xfs_scrub *sc, struct xbitmap *exlist,
 		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
@@ -57,6 +57,7 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
 int xrep_xattr_reset_fork(struct xfs_scrub *sc, uint64_t nr_attrs);
 int xrep_metadata_inode_forks(struct xfs_scrub *sc);
+int xrep_rmapbt_setup(struct xfs_scrub *sc, struct xfs_inode *ip);
 
 /* Metadata revalidators */
 
@@ -72,6 +73,7 @@ int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
+int xrep_rmapbt(struct xfs_scrub *sc);
 int xrep_refcountbt(struct xfs_scrub *sc);
 int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
@@ -170,6 +172,16 @@ xrep_reset_perag_resv(
 	return -EOPNOTSUPP;
 }
 
+/* rmap setup function for CONFIG_XFS_REPAIR=n */
+static inline int
+xrep_rmapbt_setup(
+	struct xfs_scrub	*sc,
+	struct xfs_inode		*ip)
+{
+	/* We don't support rmap repair, but we can still do a scan. */
+	return xchk_setup_ag_btree(sc, ip, false);
+}
+
 #define xrep_revalidate_allocbt		(NULL)
 #define xrep_revalidate_iallocbt	(NULL)
 
@@ -180,6 +192,7 @@ xrep_reset_perag_resv(
 #define xrep_agi			xrep_notsupported
 #define xrep_allocbt			xrep_notsupported
 #define xrep_iallocbt			xrep_notsupported
+#define xrep_rmapbt			xrep_notsupported
 #define xrep_refcountbt			xrep_notsupported
 #define xrep_inode			xrep_notsupported
 #define xrep_bmap_data			xrep_notsupported
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index eb92ccb67a98..b50604b7f87d 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -15,6 +15,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub reverse mapping btrees.
@@ -24,7 +25,10 @@ xchk_setup_ag_rmapbt(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
-	return xchk_setup_ag_btree(sc, ip, false);
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		return xrep_rmapbt_setup(sc, ip);
+	else
+		return xchk_setup_ag_btree(sc, ip, false);
 }
 
 /* Reverse-mapping scrubber. */
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
new file mode 100644
index 000000000000..e28a65388868
--- /dev/null
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -0,0 +1,1304 @@
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
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_iwalk.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/array.h"
+#include "scrub/xfile.h"
+
+/*
+ * Reverse Mapping Btree Repair
+ * ============================
+ *
+ * This is the most involved of all the AG space btree rebuilds.  Everywhere
+ * else in XFS we lock inodes and then AG data structures, but generating the
+ * list of rmap records requires that we be able to scan both block mapping
+ * btrees of every inode in the filesystem to see if it owns any extents in
+ * this AG.  We can't tolerate any inode updates while we do this, so we
+ * freeze the filesystem to lock everyone else out, and grant ourselves
+ * special privileges to run transactions with regular background reclamation
+ * turned off.
+ *
+ * We also have to be very careful not to allow inode reclaim to start a
+ * transaction because all transactions (other than our own) will block.
+ * Deferred inode inactivation helps us out there.
+ *
+ * I) Reverse mappings for all non-space metadata and file data are collected
+ * according to the following algorithm:
+ *
+ * 1. For each fork of each inode:
+ * 1.1. Create a bitmap BMBIT to track bmbt blocks if necessary.
+ * 1.2. If the incore extent map isn't loaded, walk the bmbt to accumulate
+ *      bmaps into rmap records (see 1.1.4).  Set bits in BMBIT for each btree
+ *      block.
+ * 1.3. If the incore extent map is loaded but the fork is in btree format,
+ *      just visit the bmbt blocks to set the corresponding BMBIT areas.
+ * 1.4. From the incore extent map, accumulate each bmap that falls into our
+ *      target AG.  Remember, multiple bmap records can map to a single rmap
+ *      record, so we cannot simply emit rmap records 1:1.
+ * 1.5. Emit rmap records for each extent in BMBIT and free it.
+ * 2. Create bitmaps INOBIT and ICHUNKBIT.
+ * 3. For each record in the inobt, set the corresponding areas in ICHUNKBIT,
+ *    and set bits in INOBIT for each btree block.  If the inobt has no records
+ *    at all, we must be careful to record its root in INOBIT.
+ * 4. For each block in the finobt, set the corresponding INOBIT area.
+ * 5. Emit rmap records for each extent in INOBIT and ICHUNKBIT and free them.
+ * 6. Create bitmaps REFCBIT and COWBIT.
+ * 7. For each CoW staging extent in the refcountbt, set the corresponding
+ *    areas in COWBIT.
+ * 8. For each block in the refcountbt, set the corresponding REFCBIT area.
+ * 9. Emit rmap records for each extent in REFCBIT and COWBIT and free them.
+ * A. Emit rmap for the AG headers.
+ * B. Emit rmap for the log, if there is one.
+ *
+ * II) The rmapbt shape and space metadata rmaps are computed as follows:
+ *
+ * 1. Count the rmaps collected in the previous step. (= NR)
+ * 2. Estimate the number of rmapbt blocks needed to store NR records. (= RMB)
+ * 3. Reserve RMB blocks through the newbt using the allocator in normap mode.
+ * 4. Create bitmap AGBIT.
+ * 5. For each reservation in the newbt, set the corresponding areas in AGBIT.
+ * 6. For each block in the AGFL, bnobt, and cntbt, set the bits in AGBIT.
+ * 7. Count the extents in AGBIT. (= AGNR)
+ * 8. Estimate the number of rmapbt blocks needed for NR + AGNR rmaps. (= RMB')
+ * 9. If RMB' >= RMB, reserve RMB' - RMB more newbt blocks, set RMB = RMB',
+ *    and clear AGBIT.  Go to step 5.
+ * A. Emit rmaps for each extent in AGBIT.
+ *
+ * III) The rmapbt is constructed and set in place as follows:
+ *
+ * 1. Sort the rmap records.
+ * 2. Bulk load the rmaps.
+ *
+ * IV) Reap the old btree blocks.
+ *
+ * 1. Create a bitmap OLDRMBIT.
+ * 2. For each gap in the new rmapbt, set the corresponding areas of OLDRMBIT.
+ * 3. For each extent in the bnobt, clear the corresponding parts of OLDRMBIT.
+ * 4. Reap the extents corresponding to the set areas in OLDRMBIT.  These are
+ *    the parts of the AG that the rmap didn't find during its scan of the
+ *    primary metadata and aren't known to be in the free space, which implies
+ *    that they were the old rmapbt blocks.
+ * 5. Commit.
+ *
+ * We use the 'xrep_rmap' prefix for all the rmap functions.
+ */
+
+/* Set us up to repair reverse mapping btrees. */
+int
+xrep_rmapbt_setup(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	/*
+	 * Freeze out anything that can lock an inode.  We reconstruct
+	 * the rmapbt by reading inode bmaps with the AGF held, which is
+	 * only safe w.r.t. ABBA deadlocks if we're the only ones locking
+	 * inodes.
+	 */
+	error = xchk_fs_freeze(sc);
+	if (error)
+		return error;
+
+	/* Check the AG number and set up the scrub context. */
+	error = xchk_setup_fs(sc, ip);
+	if (error)
+		return error;
+
+	return xchk_ag_init(sc, sc->sm->sm_agno, &sc->sa);
+}
+
+/*
+ * Packed rmap record.  The ATTR/BMBT/UNWRITTEN flags are hidden in the upper
+ * bits of offset, just like the on-disk record.
+ */
+struct xrep_rmap_extent {
+	xfs_agblock_t	startblock;
+	xfs_extlen_t	blockcount;
+	uint64_t	owner;
+	uint64_t	offset;
+} __packed;
+
+/* Context for collecting rmaps */
+struct xrep_rmap {
+	/* new rmapbt information */
+	struct xrep_newbt	new_btree_info;
+	struct xfs_btree_bload	rmap_bload;
+
+	/* rmap records generated from primary metadata */
+	struct xfbma		*rmap_records;
+
+	struct xfs_scrub	*sc;
+
+	/* get_data()'s position in the free space record array. */
+	uint64_t		iter;
+
+	/* bnobt/cntbt contribution to btreeblks */
+	xfs_agblock_t		freesp_btblocks;
+};
+
+/* Compare two rmapbt extents. */
+static int
+xrep_rmap_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xrep_rmap_extent	*ap = a;
+	const struct xrep_rmap_extent	*bp = b;
+	struct xfs_rmap_irec		ar = {
+		.rm_startblock		= ap->startblock,
+		.rm_blockcount		= ap->blockcount,
+		.rm_owner		= ap->owner,
+	};
+	struct xfs_rmap_irec		br = {
+		.rm_startblock		= bp->startblock,
+		.rm_blockcount		= bp->blockcount,
+		.rm_owner		= bp->owner,
+	};
+	int				error;
+
+	error = xfs_rmap_irec_offset_unpack(ap->offset, &ar);
+	if (error)
+		ASSERT(error == 0);
+
+	error = xfs_rmap_irec_offset_unpack(bp->offset, &br);
+	if (error)
+		ASSERT(error == 0);
+
+	return xfs_rmap_compare(&ar, &br);
+}
+
+/* Store a reverse-mapping record. */
+static inline int
+xrep_rmap_stash(
+	struct xrep_rmap	*rr,
+	xfs_agblock_t		startblock,
+	xfs_extlen_t		blockcount,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags)
+{
+	struct xrep_rmap_extent	rre = {
+		.startblock	= startblock,
+		.blockcount	= blockcount,
+		.owner		= owner,
+	};
+	struct xfs_rmap_irec	rmap = {
+		.rm_offset	= offset,
+		.rm_flags	= flags,
+	};
+	int			error = 0;
+
+	trace_xrep_rmap_found(rr->sc->mp, rr->sc->sa.agno, startblock,
+			blockcount, owner, offset, flags);
+
+	if (xchk_should_terminate(rr->sc, &error))
+		return error;
+
+	rre.offset = xfs_rmap_irec_offset_pack(&rmap);
+	return xfbma_append(rr->rmap_records, &rre);
+}
+
+struct xrep_rmap_stash_run {
+	struct xrep_rmap	*rr;
+	uint64_t		owner;
+	unsigned int		rmap_flags;
+};
+
+static int
+xrep_rmap_stash_run(
+	uint64_t			start,
+	uint64_t			len,
+	void				*priv)
+{
+	struct xrep_rmap_stash_run	*rsr = priv;
+	struct xrep_rmap		*rr = rsr->rr;
+
+	return xrep_rmap_stash(rr, XFS_FSB_TO_AGBNO(rr->sc->mp, start), len,
+			rsr->owner, 0, rsr->rmap_flags);
+}
+
+/*
+ * Emit rmaps for every extent of bits set in the bitmap.  Caller must ensure
+ * that the ranges are in units of FS blocks.
+ */
+STATIC int
+xrep_rmap_stash_bitmap(
+	struct xrep_rmap		*rr,
+	struct xbitmap			*bitmap,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xrep_rmap_stash_run	rsr = {
+		.rr			= rr,
+		.owner			= oinfo->oi_owner,
+		.rmap_flags		= 0,
+	};
+
+	if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
+		rsr.rmap_flags |= XFS_RMAP_ATTR_FORK;
+	if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
+		rsr.rmap_flags |= XFS_RMAP_BMBT_BLOCK;
+
+	return xbitmap_walk(bitmap, xrep_rmap_stash_run, &rsr);
+}
+
+/* Section (I): Finding all file and bmbt extents. */
+
+/* Context for accumulating rmaps for an inode fork. */
+struct xrep_rmap_ifork {
+	/*
+	 * Accumulate rmap data here to turn multiple adjacent bmaps into a
+	 * single rmap.
+	 */
+	struct xfs_rmap_irec	accum;
+
+	/* Bitmap of bmbt blocks. */
+	struct xbitmap		bmbt_blocks;
+
+	struct xrep_rmap	*rr;
+
+	/* Transaction associated with this rmap recovery attempt. */
+	struct xfs_trans	*tp;
+
+	/* Which inode fork? */
+	int			whichfork;
+};
+
+/* Add a bmbt block to the bitmap. */
+STATIC int
+xrep_rmap_visit_bmbt_block(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*priv)
+{
+	struct xrep_rmap_ifork	*rf = priv;
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		fsb;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	if (XFS_FSB_TO_AGNO(cur->bc_mp, fsb) != rf->rr->sc->sa.agno)
+		return 0;
+
+	return xbitmap_set(&rf->bmbt_blocks, fsb, 1);
+}
+
+/* Stash an rmap that we accumulated while walking an inode fork. */
+STATIC int
+xrep_rmap_stash_accumulated(
+	struct xrep_rmap_ifork	*rf)
+{
+	if (rf->accum.rm_blockcount == 0)
+		return 0;
+
+	return xrep_rmap_stash(rf->rr, rf->accum.rm_startblock,
+			rf->accum.rm_blockcount, rf->accum.rm_owner,
+			rf->accum.rm_offset, rf->accum.rm_flags);
+}
+
+/* Accumulate a bmbt record. */
+STATIC int
+xrep_rmap_visit_bmbt(
+	struct xfs_btree_cur	*cur,
+	struct xfs_bmbt_irec	*rec,
+	void			*priv)
+{
+	struct xrep_rmap_ifork	*rf = priv;
+	struct xfs_mount	*mp = rf->rr->sc->mp;
+	struct xfs_rmap_irec	*accum = &rf->accum;
+	xfs_agblock_t		agbno;
+	unsigned int		rmap_flags = 0;
+	int			error;
+
+	if (XFS_FSB_TO_AGNO(mp, rec->br_startblock) != rf->rr->sc->sa.agno)
+		return 0;
+
+	agbno = XFS_FSB_TO_AGBNO(mp, rec->br_startblock);
+	if (rf->whichfork == XFS_ATTR_FORK)
+		rmap_flags |= XFS_RMAP_ATTR_FORK;
+	if (rec->br_state == XFS_EXT_UNWRITTEN)
+		rmap_flags |= XFS_RMAP_UNWRITTEN;
+
+	/* If this bmap is adjacent to the previous one, just add it. */
+	if (accum->rm_blockcount > 0 &&
+	    rec->br_startoff == accum->rm_offset + accum->rm_blockcount &&
+	    agbno == accum->rm_startblock + accum->rm_blockcount &&
+	    rmap_flags == accum->rm_flags) {
+		accum->rm_blockcount += rec->br_blockcount;
+		return 0;
+	}
+
+	/* Otherwise stash the old rmap and start accumulating a new one. */
+	error = xrep_rmap_stash_accumulated(rf);
+	if (error)
+		return error;
+
+	accum->rm_startblock = agbno;
+	accum->rm_blockcount = rec->br_blockcount;
+	accum->rm_offset = rec->br_startoff;
+	accum->rm_flags = rmap_flags;
+	return 0;
+}
+
+static inline bool
+is_rt_data_fork(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	return whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
+}
+
+/*
+ * Iterate the block mapping btree to collect rmap records for anything in this
+ * fork that matches the AG.
+ */
+STATIC int
+xrep_rmap_scan_bmbt(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_inode	*ip,
+	bool			*done)
+{
+	struct xfs_owner_info	oinfo;
+	struct xrep_rmap	*rr = rf->rr;
+	struct xfs_btree_cur	*cur;
+	struct xfs_ifork	*ifp;
+	int			error;
+	bool			iterate_bmbt = false;
+
+	*done = false;
+	ifp = XFS_IFORK_PTR(ip, rf->whichfork);
+
+	/*
+	 * If the incore extent cache isn't loaded (and this isn't the data
+	 * fork of a realtime inode), we only need to scan the bmbt for
+	 * mapping records.  Avoid loading the cache, which will increase
+	 * memory pressure at a time when we're trying to run as quickly as
+	 * we possibly can.
+	 */
+	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
+	    !is_rt_data_fork(ip, rf->whichfork))
+		iterate_bmbt = true;
+
+	xbitmap_init(&rf->bmbt_blocks);
+	cur = xfs_bmbt_init_cursor(rr->sc->mp, rf->tp, ip, rf->whichfork);
+
+	/* Accumulate all the mappings in the bmap btree. */
+	if (iterate_bmbt) {
+		error = xfs_bmap_query_all(cur, xrep_rmap_visit_bmbt, rf);
+		if (error)
+			goto out_cur;
+	}
+
+	/* Record all the blocks in the bmbt itself. */
+	error = xfs_btree_visit_blocks(cur, xrep_rmap_visit_bmbt_block,
+			XFS_BTREE_VISIT_ALL, rf);
+	if (error)
+		goto out_cur;
+	xfs_btree_del_cursor(cur, error);
+
+	/* Emit rmaps for the bmbt blocks. */
+	xfs_rmap_ino_bmbt_owner(&oinfo, rf->accum.rm_owner, rf->whichfork);
+	error = xrep_rmap_stash_bitmap(rr, &rf->bmbt_blocks, &oinfo);
+	if (error)
+		goto out_bitmap;
+	xbitmap_destroy(&rf->bmbt_blocks);
+
+	/* We're done if we scanned the bmbt or it's a realtime inode. */
+	*done = iterate_bmbt;
+
+	/* Stash any remaining accumulated rmap. */
+	return xrep_rmap_stash_accumulated(rf);
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+out_bitmap:
+	xbitmap_destroy(&rf->bmbt_blocks);
+	return error;
+}
+
+/*
+ * Iterate the in-core extent cache to collect rmap records for anything in
+ * this fork that matches the AG.
+ */
+STATIC int
+xrep_rmap_scan_iext(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_ifork	*ifp)
+{
+	struct xfs_bmbt_irec	rec;
+	struct xfs_iext_cursor	icur;
+	int			error;
+
+	for_each_xfs_iext(ifp, &icur, &rec) {
+		if (isnullstartblock(rec.br_startblock))
+			continue;
+		error = xrep_rmap_visit_bmbt(NULL, &rec, rf);
+		if (error)
+			return error;
+	}
+
+	return xrep_rmap_stash_accumulated(rf);
+}
+
+/* Find all the extents from a given AG in an inode fork. */
+STATIC int
+xrep_rmap_scan_ifork(
+	struct xrep_rmap	*rr,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xrep_rmap_ifork	rf = {
+		.accum		= { .rm_owner = ip->i_ino, },
+		.rr		= rr,
+		.tp		= tp,
+		.whichfork	= whichfork,
+	};
+	struct xfs_ifork	*ifp;
+	bool			done;
+	int			fmt;
+	int			error = 0;
+
+	/* Do we even have data mapping extents? */
+	fmt = XFS_IFORK_FORMAT(ip, whichfork);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (!ifp)
+		return 0;
+
+	switch (fmt) {
+	case XFS_DINODE_FMT_BTREE:
+		error = xrep_rmap_scan_bmbt(&rf, ip, &done);
+		if (error || done)
+			return error;
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		break;
+	default:
+		return 0;
+	}
+
+	if (is_rt_data_fork(ip, whichfork))
+		return 0;
+
+	/* Scan incore extent cache. */
+	return xrep_rmap_scan_iext(&rf, ifp);
+}
+
+/* Record reverse mappings for a file. */
+STATIC int
+xrep_rmap_scan_inode(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	xfs_ino_t			ino,
+	void				*data)
+{
+	struct xrep_rmap		*rr = data;
+	struct xfs_inode		*ip;
+	unsigned int			lock_mode;
+	int				error;
+
+	/* Grab inode and lock it so we can scan it. */
+	error = xfs_iget(mp, rr->sc->tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
+	if (error)
+		return error;
+
+	lock_mode = xfs_ilock_data_map_shared(ip);
+
+	/* Check the data fork. */
+	error = xrep_rmap_scan_ifork(rr, tp, ip, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
+
+	/* Check the attr fork. */
+	error = xrep_rmap_scan_ifork(rr, tp, ip, XFS_ATTR_FORK);
+	if (error)
+		goto out_unlock;
+
+	/* COW fork extents are "owned" by the refcount btree. */
+
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+	xfs_irele(ip);
+	return error;
+}
+
+/* Section (I): Find all AG metadata extents except for free space metadata. */
+
+/* Add a btree block to the rmap list. */
+STATIC int
+xrep_rmap_visit_btblock(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*priv)
+{
+	struct xbitmap		*bitmap = priv;
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		fsb;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	return xbitmap_set(bitmap, fsb, 1);
+}
+
+struct xrep_rmap_inodes {
+	struct xrep_rmap	*rr;
+	struct xbitmap		inobt_blocks;	/* INOBIT */
+	struct xbitmap		ichunk_blocks;	/* ICHUNKBIT */
+};
+
+/* Record inode btree rmaps. */
+STATIC int
+xrep_rmap_walk_inobt(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	irec;
+	struct xrep_rmap_inodes		*ri = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_fsblock_t			fsbno;
+	xfs_agino_t			agino;
+	xfs_agino_t			iperhole;
+	unsigned int			i;
+	int				error;
+
+	/* Record the inobt blocks. */
+	error = xbitmap_set_btcur_path(&ri->inobt_blocks, cur);
+	if (error)
+		return error;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+	agino = irec.ir_startino;
+
+	/* Record a non-sparse inode chunk. */
+	if (!xfs_inobt_issparse(irec.ir_holemask)) {
+		fsbno = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+				XFS_AGINO_TO_AGBNO(mp, agino));
+
+		return xbitmap_set(&ri->ichunk_blocks, fsbno,
+				XFS_INODES_PER_CHUNK / mp->m_sb.sb_inopblock);
+	}
+
+	/* Iterate each chunk. */
+	iperhole = max_t(xfs_agino_t, mp->m_sb.sb_inopblock,
+			XFS_INODES_PER_HOLEMASK_BIT);
+	for (i = 0, agino = irec.ir_startino;
+	     i < XFS_INOBT_HOLEMASK_BITS;
+	     i += iperhole / XFS_INODES_PER_HOLEMASK_BIT, agino += iperhole) {
+		/* Skip holes. */
+		if (irec.ir_holemask & (1 << i))
+			continue;
+
+		/* Record the inode chunk otherwise. */
+		fsbno = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+				XFS_AGINO_TO_AGBNO(mp, agino));
+		error = xbitmap_set(&ri->ichunk_blocks, fsbno,
+				iperhole / mp->m_sb.sb_inopblock);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Collect rmaps for the blocks containing inode btrees and the inode chunks. */
+STATIC int
+xrep_rmap_find_inode_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xrep_rmap_inodes	ri = {
+		.rr		= rr,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	xbitmap_init(&ri.inobt_blocks);
+	xbitmap_init(&ri.ichunk_blocks);
+
+	/*
+	 * Iterate every record in the inobt so we can capture all the inode
+	 * chunks and the blocks in the inobt itself.
+	 */
+	cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp,
+			sc->sa.agno, XFS_BTNUM_INO);
+	error = xfs_btree_query_all(cur, xrep_rmap_walk_inobt, &ri);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_bitmap;
+
+	/*
+	 * Note that if there are zero records in the inobt then query_all does
+	 * nothing and we have to account the empty inobt root manually.
+	 */
+	if (xbitmap_empty(&ri.ichunk_blocks)) {
+		struct xfs_agi	*agi;
+		xfs_fsblock_t	agi_root;
+
+		agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+		agi_root = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno,
+				be32_to_cpu(agi->agi_root));
+		error = xbitmap_set(&ri.inobt_blocks, agi_root, 1);
+		if (error)
+			goto out_bitmap;
+	}
+
+	/* Scan the finobt too. */
+	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb)) {
+		cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp,
+				sc->sa.agno, XFS_BTNUM_FINO);
+		error = xfs_btree_visit_blocks(cur, xrep_rmap_visit_btblock,
+				XFS_BTREE_VISIT_ALL, &ri.inobt_blocks);
+		xfs_btree_del_cursor(cur, error);
+		if (error)
+			goto out_bitmap;
+	}
+
+	/* Generate rmaps for everything. */
+	error = xrep_rmap_stash_bitmap(rr, &ri.inobt_blocks,
+			&XFS_RMAP_OINFO_INOBT);
+	if (error)
+		goto out_bitmap;
+	error = xrep_rmap_stash_bitmap(rr, &ri.ichunk_blocks,
+			&XFS_RMAP_OINFO_INODES);
+
+out_bitmap:
+	xbitmap_destroy(&ri.inobt_blocks);
+	xbitmap_destroy(&ri.ichunk_blocks);
+	return error;
+}
+
+/* Record a CoW staging extent. */
+STATIC int
+xrep_rmap_walk_cowblocks(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xbitmap			*bitmap = priv;
+	struct xfs_refcount_irec	refc;
+	xfs_fsblock_t			fsbno;
+
+	xfs_refcount_btrec_to_irec(rec, &refc);
+	if (refc.rc_refcount != 1)
+		return -EFSCORRUPTED;
+
+	fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+			refc.rc_startblock - XFS_REFC_COW_START);
+	return xbitmap_set(bitmap, fsbno, refc.rc_blockcount);
+}
+
+/*
+ * Collect rmaps for the blocks containing the refcount btree, and all CoW
+ * staging extents.
+ */
+STATIC int
+xrep_rmap_find_refcount_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xbitmap		refcountbt_blocks;	/* REFCBIT */
+	struct xbitmap		cow_blocks;		/* COWBIT */
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	if (!xfs_sb_version_hasreflink(&sc->mp->m_sb))
+		return 0;
+
+	xbitmap_init(&refcountbt_blocks);
+	xbitmap_init(&cow_blocks);
+
+	/* refcountbt */
+	cur = xfs_refcountbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno);
+	error = xfs_btree_visit_blocks(cur, xrep_rmap_visit_btblock,
+			XFS_BTREE_VISIT_ALL, &refcountbt_blocks);
+	if (error) {
+		xfs_btree_del_cursor(cur, error);
+		goto out_bitmap;
+	}
+
+	/* Collect rmaps for CoW staging extents. */
+	memset(&low, 0, sizeof(low));
+	low.rc.rc_startblock = XFS_REFC_COW_START;
+	memset(&high, 0xFF, sizeof(high));
+	error = xfs_btree_query_range(cur, &low, &high,
+			xrep_rmap_walk_cowblocks, &cow_blocks);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_bitmap;
+
+	/* Generate rmaps for everything. */
+	error = xrep_rmap_stash_bitmap(rr, &cow_blocks, &XFS_RMAP_OINFO_COW);
+	if (error)
+		goto out_bitmap;
+	error = xrep_rmap_stash_bitmap(rr, &refcountbt_blocks,
+			&XFS_RMAP_OINFO_REFC);
+
+out_bitmap:
+	xbitmap_destroy(&cow_blocks);
+	xbitmap_destroy(&refcountbt_blocks);
+	return error;
+}
+
+/* Generate rmaps for the AG headers (AGI/AGF/AGFL) */
+STATIC int
+xrep_rmap_find_agheader_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+
+	/* Create a record for the AG sb->agfl. */
+	return xrep_rmap_stash(rr, XFS_SB_BLOCK(sc->mp),
+			XFS_AGFL_BLOCK(sc->mp) - XFS_SB_BLOCK(sc->mp) + 1,
+			XFS_RMAP_OWN_FS, 0, 0);
+}
+
+/* Generate rmaps for the log, if it's in this AG. */
+STATIC int
+xrep_rmap_find_log_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+
+	if (sc->mp->m_sb.sb_logstart == 0 ||
+	    XFS_FSB_TO_AGNO(sc->mp, sc->mp->m_sb.sb_logstart) != sc->sa.agno)
+		return 0;
+
+	return xrep_rmap_stash(rr,
+			XFS_FSB_TO_AGBNO(sc->mp, sc->mp->m_sb.sb_logstart),
+			sc->mp->m_sb.sb_logblocks, XFS_RMAP_OWN_LOG, 0, 0);
+}
+
+/*
+ * Generate all the reverse-mappings for this AG, a list of the old rmapbt
+ * blocks, and the new btreeblks count.  Figure out if we have enough free
+ * space to reconstruct the inode btrees.  The caller must clean up the lists
+ * if anything goes wrong.  This implements section (I) above.
+ */
+STATIC int
+xrep_rmap_find_rmaps(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	/* Iterate all AGs for inodes rmaps. */
+	error = xfs_iwalk(sc->mp, sc->tp, 0, 0, xrep_rmap_scan_inode, 0, rr);
+	if (error)
+		return error;
+
+	/* Find all the other per-AG metadata. */
+	error = xrep_rmap_find_inode_rmaps(rr);
+	if (error)
+		return error;
+
+	error = xrep_rmap_find_refcount_rmaps(rr);
+	if (error)
+		return error;
+
+	error = xrep_rmap_find_agheader_rmaps(rr);
+	if (error)
+		return error;
+
+	return xrep_rmap_find_log_rmaps(rr);
+}
+
+/* Section (II): Reserving space for new rmapbt and setting free space bitmap */
+
+struct xrep_rmap_agfl {
+	struct xbitmap		*bitmap;
+	xfs_agnumber_t		agno;
+};
+
+/* Add an AGFL block to the rmap list. */
+STATIC int
+xrep_rmap_walk_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		bno,
+	void			*priv)
+{
+	struct xrep_rmap_agfl	*ra = priv;
+
+	return xbitmap_set(ra->bitmap, XFS_AGB_TO_FSB(mp, ra->agno, bno), 1);
+}
+
+/*
+ * Run one round of reserving space for the new rmapbt and recomputing the
+ * number of blocks needed to store the previously observed rmapbt records and
+ * the ones we'll create for the free space metadata.  When we don't need more
+ * blocks, return a bitmap of OWN_AG extents in @freesp_blocks and set @done to
+ * true.
+ */
+STATIC int
+xrep_rmap_try_reserve(
+	struct xrep_rmap	*rr,
+	uint64_t		nr_records,
+	struct xbitmap		*freesp_blocks,
+	uint64_t		*blocks_reserved,
+	bool			*done)
+{
+	struct xrep_rmap_agfl	ra = {
+		.bitmap		= freesp_blocks,
+		.agno		= rr->sc->sa.agno,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*cur;
+	struct xrep_newbt_resv	*resv, *n;
+	uint64_t		nr_blocks;	/* RMB */
+	uint64_t		freesp_records;
+	int			error;
+
+	/*
+	 * We're going to recompute rmap_bload.nr_blocks at the end of this
+	 * function to reflect however many btree blocks we need to store all
+	 * the rmap records (including the ones that reflect the changes we
+	 * made to support the new rmapbt blocks), so we save the old value
+	 * here so we can decide if we've reserved enough blocks.
+	 */
+	nr_blocks = rr->rmap_bload.nr_blocks;
+
+	/*
+	 * Make sure we've reserved enough space for the new btree.  This can
+	 * change the shape of the free space btrees, which can cause secondary
+	 * interactions with the rmap records because all three space btrees
+	 * have the same rmap owner.  We'll account for all that below.
+	 */
+	error = xrep_newbt_alloc_blocks(&rr->new_btree_info,
+			nr_blocks - *blocks_reserved);
+	if (error)
+		return error;
+
+	*blocks_reserved = rr->rmap_bload.nr_blocks;
+
+	/* Clear everything in the bitmap. */
+	xbitmap_destroy(freesp_blocks);
+
+	/* Set all the bnobt blocks in the bitmap. */
+	cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno, XFS_BTNUM_BNO);
+	error = xfs_btree_visit_blocks(cur, xrep_rmap_visit_btblock,
+			XFS_BTREE_VISIT_ALL, freesp_blocks);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		return error;
+
+	/* Set all the cntbt blocks in the bitmap. */
+	cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno, XFS_BTNUM_CNT);
+	error = xfs_btree_visit_blocks(cur, xrep_rmap_visit_btblock,
+			XFS_BTREE_VISIT_ALL, freesp_blocks);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		return error;
+
+	/* Record our new btreeblks value. */
+	rr->freesp_btblocks = xbitmap_hweight(freesp_blocks) - 2;
+
+	/* Set all the new rmapbt blocks in the bitmap. */
+	for_each_xrep_newbt_reservation(&rr->new_btree_info, resv, n) {
+		error = xbitmap_set(freesp_blocks, resv->fsbno, resv->len);
+		if (error)
+			return error;
+	}
+
+	/* Set all the AGFL blocks in the bitmap. */
+	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
+			sc->sa.agfl_bp, xrep_rmap_walk_agfl, &ra);
+	if (error)
+		return error;
+
+	/* Count the extents in the bitmap. */
+	freesp_records = xbitmap_count_set_regions(freesp_blocks);
+
+	/* Compute how many blocks we'll need for all the rmaps. */
+	cur = xfs_rmapbt_stage_cursor(sc->mp, sc->tp,
+			&rr->new_btree_info.afake, sc->sa.agno);
+	error = xfs_btree_bload_compute_geometry(cur, &rr->rmap_bload,
+			nr_records + freesp_records);
+	xfs_btree_del_cursor(cur, error);
+
+	/* We're done when we don't need more blocks. */
+	*done = nr_blocks >= rr->rmap_bload.nr_blocks;
+	return 0;
+}
+
+/*
+ * Iteratively reserve space for rmap btree while recording OWN_AG rmaps for
+ * the free space metadata.  This implements section (II) above.
+ */
+STATIC int
+xrep_rmap_reserve_space(
+	struct xrep_rmap	*rr)
+{
+	struct xbitmap		freesp_blocks;	/* AGBIT */
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*rmap_cur;
+	uint64_t		nr_records;	/* NR */
+	uint64_t		blocks_reserved = 0;
+	bool			done = false;
+	int			error;
+
+	nr_records = xfbma_length(rr->rmap_records);
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the AG header.
+	 */
+	xrep_newbt_init_ag(&rr->new_btree_info, sc, &XFS_RMAP_OINFO_SKIP_UPDATE,
+			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno,
+				       XFS_RMAP_BLOCK(sc->mp)),
+			XFS_AG_RESV_RMAPBT);
+
+	/* Compute how many blocks we'll need for the rmaps collected so far. */
+	rmap_cur = xfs_rmapbt_stage_cursor(sc->mp, sc->tp,
+			&rr->new_btree_info.afake, sc->sa.agno);
+	error = xfs_btree_bload_compute_geometry(rmap_cur, &rr->rmap_bload,
+			nr_records);
+	xfs_btree_del_cursor(rmap_cur, error);
+	if (error)
+		return error;
+
+	xbitmap_init(&freesp_blocks);
+
+	/*
+	 * Iteratively reserve space for the new rmapbt and recompute the
+	 * number of blocks needed to store the previously observed rmapbt
+	 * records and the ones we'll create for the free space metadata.
+	 * Finish when we don't need more blocks.
+	 */
+	do {
+		error = xrep_rmap_try_reserve(rr, nr_records, &freesp_blocks,
+				&blocks_reserved, &done);
+		if (error)
+			goto out_bitmap;
+	} while (!done);
+
+	/* Emit rmaps for everything in the free space bitmap. */
+	error = xrep_rmap_stash_bitmap(rr, &freesp_blocks, &XFS_RMAP_OINFO_AG);
+
+out_bitmap:
+	xbitmap_destroy(&freesp_blocks);
+	return error;
+}
+
+/* Section (III): Building the new rmap btree. */
+
+/* Update the AGF counters. */
+STATIC int
+xrep_rmap_reset_counters(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_agf		*agf;
+	struct xfs_buf		*bp;
+	xfs_agblock_t		rmap_btblocks;
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
+	rmap_btblocks = rr->new_btree_info.afake.af_blocks - 1;
+	agf->agf_btreeblks = cpu_to_be32(rr->freesp_btblocks + rmap_btblocks);
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_BTREEBLKS);
+
+	return xfs_alloc_read_agf(sc->mp, sc->tp, sc->sa.agno, 0, &bp);
+}
+
+/* Retrieve rmapbt data for bulk load. */
+STATIC int
+xrep_rmap_get_data(
+	struct xfs_btree_cur	*cur,
+	void			*priv)
+{
+	struct xrep_rmap_extent	rec;
+	struct xfs_rmap_irec	*irec = &cur->bc_rec.r;
+	struct xrep_rmap	*rr = priv;
+	int			error;
+
+	error = xfbma_get_data(rr->rmap_records, &rr->iter, &rec);
+	if (error)
+		return error;
+
+	irec->rm_startblock = rec.startblock;
+	irec->rm_blockcount = rec.blockcount;
+	irec->rm_owner = rec.owner;
+	return xfs_rmap_irec_offset_unpack(rec.offset, irec);
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_rmap_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_rmap        *rr = priv;
+
+	return xrep_newbt_claim_block(cur, &rr->new_btree_info, ptr);
+}
+
+/*
+ * Use the collected rmap information to stage a new rmap btree.  If this is
+ * successful we'll return with the new btree root information logged to the
+ * repair transaction but not yet committed.  This implements section (III)
+ * above.
+ */
+STATIC int
+xrep_rmap_build_new_tree(
+	struct xrep_rmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*rmap_cur;
+	int			error;
+
+	rr->rmap_bload.get_data = xrep_rmap_get_data;
+	rr->rmap_bload.alloc_block = xrep_rmap_alloc_block;
+	xrep_bload_estimate_slack(sc, &rr->rmap_bload);
+
+	/*
+	 * Initialize @rr->new_btree_info, reserve space for the new rmapbt,
+	 * and compute OWN_AG rmaps.
+	 */
+	error = xrep_rmap_reserve_space(rr);
+	if (error)
+		return error;
+
+	/*
+	 * Sort the rmap records by startblock or else the btree records
+	 * will be in the wrong order.
+	 */
+	error = xfbma_sort(rr->rmap_records, xrep_rmap_extent_cmp);
+	if (error)
+		goto err_newbt;
+
+	/* Add all observed rmap records. */
+	rr->iter = 0;
+	rmap_cur = xfs_rmapbt_stage_cursor(sc->mp, sc->tp,
+			&rr->new_btree_info.afake, sc->sa.agno);
+	error = xfs_btree_bload(rmap_cur, &rr->rmap_bload, rr);
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
+	xfs_rmapbt_commit_staged_btree(rmap_cur, sc->sa.agf_bp);
+	xfs_btree_del_cursor(rmap_cur, 0);
+
+	/* Reset the AGF counters now that we've changed the btree shape. */
+	error = xrep_rmap_reset_counters(rr);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting information. */
+	xrep_newbt_destroy(&rr->new_btree_info, error);
+
+	return xrep_roll_ag_trans(sc);
+err_cur:
+	xfs_btree_del_cursor(rmap_cur, error);
+err_newbt:
+	xrep_newbt_destroy(&rr->new_btree_info, error);
+	return error;
+}
+
+/* Section (IV): Reaping the old btree. */
+
+/* Subtract each free extent in the bnobt from the rmap gaps. */
+STATIC int
+xrep_rmap_find_freesp(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv)
+{
+	struct xbitmap			*bitmap = priv;
+	xfs_fsblock_t			fsb;
+
+	fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+			rec->ar_startblock);
+	xbitmap_clear(bitmap, fsb, rec->ar_blockcount);
+	return 0;
+}
+
+/*
+ * Reap the old rmapbt blocks.  Now that the rmapbt is fully rebuilt, we make
+ * a list of gaps in the rmap records and a list of the extents mentioned in
+ * the bnobt.  Any block that's in the new rmapbt gap list but not mentioned
+ * in the bnobt is a block from the old rmapbt and can be removed.
+ */
+STATIC int
+xrep_rmap_remove_old_tree(
+	struct xrep_rmap	*rr)
+{
+	struct xbitmap		rmap_gaps;
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_agf		*agf;
+	struct xfs_btree_cur	*cur;
+	xfs_fsblock_t		next_fsb = XFS_AGB_TO_FSB(mp, sc->sa.agno, 0);
+	xfs_fsblock_t		agend_fsb;
+	uint64_t		nr_records = xfbma_length(rr->rmap_records);
+	int			error;
+
+	xbitmap_init(&rmap_gaps);
+
+	/* Compute free space from the new rmapbt. */
+	for (rr->iter = 0; rr->iter < nr_records; rr->iter++) {
+		struct xrep_rmap_extent	rec;
+		xfs_fsblock_t	fsbno;
+
+		error = xfbma_get(rr->rmap_records, rr->iter, &rec);
+		if (error)
+			goto out_bitmap;
+
+		/* Record the free space we find. */
+		fsbno = XFS_AGB_TO_FSB(mp, sc->sa.agno, rec.startblock);
+		if (fsbno > next_fsb) {
+			error = xbitmap_set(&rmap_gaps, next_fsb,
+					fsbno - next_fsb);
+			if (error)
+				goto out_bitmap;
+		}
+		next_fsb = max_t(xfs_fsblock_t, next_fsb,
+				fsbno + rec.blockcount);
+	}
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agend_fsb = XFS_AGB_TO_FSB(mp, sc->sa.agno,
+			be32_to_cpu(agf->agf_length));
+	if (next_fsb < agend_fsb) {
+		error = xbitmap_set(&rmap_gaps, next_fsb,
+				agend_fsb - next_fsb);
+		if (error)
+			goto out_bitmap;
+	}
+
+	/* Compute free space from the existing bnobt. */
+	cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno, XFS_BTNUM_BNO);
+	error = xfs_alloc_query_all(cur, xrep_rmap_find_freesp, &rmap_gaps);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_bitmap;
+
+	/*
+	 * Free the "free" blocks that the new rmapbt knows about but
+	 * the bnobt doesn't.  These are the old rmapbt blocks.
+	 */
+	error = xrep_reap_extents(sc, &rmap_gaps, &XFS_RMAP_OINFO_ANY_OWNER,
+			XFS_AG_RESV_RMAPBT);
+	if (error)
+		goto out_bitmap;
+
+	sc->flags |= XREP_RESET_PERAG_RESV;
+out_bitmap:
+	xbitmap_destroy(&rmap_gaps);
+	return error;
+}
+
+/* Repair the rmap btree for some AG. */
+int
+xrep_rmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_rmap	*rr;
+	int			error;
+
+	rr = kmem_zalloc(sizeof(struct xrep_rmap), KM_NOFS | KM_MAYFAIL);
+	if (!rr)
+		return -ENOMEM;
+	rr->sc = sc;
+
+	xchk_perag_get(sc->mp, &sc->sa);
+
+	/* Set up some storage */
+	rr->rmap_records = xfbma_init(sizeof(struct xrep_rmap_extent));
+	if (IS_ERR(rr->rmap_records)) {
+		error = PTR_ERR(rr->rmap_records);
+		goto out_rr;
+	}
+
+	/*
+	 * Collect rmaps for everything in this AG that isn't space metadata.
+	 * These rmaps won't change even as we try to allocate blocks.
+	 */
+	error = xrep_rmap_find_rmaps(rr);
+	if (error)
+		goto out_records;
+
+	/* Rebuild the rmap information. */
+	error = xrep_rmap_build_new_tree(rr);
+	if (error)
+		goto out_records;
+
+	/* Kill the old tree. */
+	error = xrep_rmap_remove_old_tree(rr);
+
+out_records:
+	xfbma_destroy(rr->rmap_records);
+out_rr:
+	kmem_free(rr);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 37ed41c05e88..84a25647ac43 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -255,7 +255,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_ag_rmapbt,
 		.scrub	= xchk_rmapbt,
 		.has	= xfs_sb_version_hasrmapbt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rmapbt,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
 		.type	= ST_PERAG,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 01975c79aab0..4e145055e37e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -725,7 +725,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
-DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_found);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_walk_rmap);
 
 TRACE_EVENT(xrep_abt_found,

