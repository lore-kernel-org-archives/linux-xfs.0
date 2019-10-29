Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A18DCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47A6B20659
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r4wHTcyO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfJ2Xbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:31:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2Xbg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:31:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSfeR038150
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=e7HgyVjYXjA0zOimCyivt21H1Ygqhtz8OT74EszURiw=;
 b=r4wHTcyOrAl5WQEqnKJJC9MNgIHh6OiVzG4zAmVvdJ7N4ldlTh2waWQlxsbvhge1YcTL
 gFHcIQ/HmMZ6GqutgpEKExUosdUWa6jpCxyWoBvG6lZq4FpCklw0/IfVPdwIsMJlCpi1
 yFOItz11RUMI/rmTHNgF6pD4O3okVdHzoMQ6szyPOnk0cZt73GdX5naK4lMd7csEKBYT
 dPGNswHEEE199mU2KCexYcKBjD8yzvVog35sBsZu6k/orsn4BPdedsGuE1C5/PuK4/5K
 XKduLTd3LCmXhV5d18nrzkATGQPlzh65VoJo4gAdy+tz7iVhbZnKMJdLtQqTZJjAfFts wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vxwhfgb4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNS68Z178679
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vxwj54xfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNVX4U007152
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:31:32 -0700
Subject: [PATCH 1/3] xfs: implement block reservation accounting for btrees
 we're staging
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:31:31 -0700
Message-ID: <157239189178.1267186.16260343655904829823.stgit@magnolia>
In-Reply-To: <157239188567.1267186.13893450077789311842.stgit@magnolia>
References: <157239188567.1267186.13893450077789311842.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new xrep_newbt structure to encapsulate a fake root for
creating a staged btree cursor as well as to track all the blocks that
we need to reserve in order to build that btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |  303 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |   55 +++++++++
 fs/xfs/scrub/trace.h  |   36 ++++++
 3 files changed, 394 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 088dbd7df096..f1aba01aba9d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -359,6 +359,309 @@ xrep_init_btblock(
 	return 0;
 }
 
+/* Initialize accounting resources for staging a new AG btree. */
+void
+xrep_newbt_init_ag(
+	struct xrep_newbt		*xnr,
+	struct xfs_scrub		*sc,
+	const struct xfs_owner_info	*oinfo,
+	xfs_fsblock_t			alloc_hint,
+	enum xfs_ag_resv_type		resv)
+{
+	memset(xnr, 0, sizeof(struct xrep_newbt));
+	xnr->sc = sc;
+	xnr->oinfo = *oinfo; /* structure copy */
+	xnr->alloc_hint = alloc_hint;
+	xnr->resv = resv;
+	INIT_LIST_HEAD(&xnr->resv_list);
+}
+
+/* Initialize accounting resources for staging a new inode fork btree. */
+void
+xrep_newbt_init_inode(
+	struct xrep_newbt		*xnr,
+	struct xfs_scrub		*sc,
+	int				whichfork,
+	const struct xfs_owner_info	*oinfo)
+{
+	xrep_newbt_init_ag(xnr, sc, oinfo,
+			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
+			XFS_AG_RESV_NONE);
+	xnr->ifake.if_fork = kmem_zone_zalloc(xfs_ifork_zone, 0);
+	xnr->ifake.if_fork_size = XFS_IFORK_SIZE(sc->ip, whichfork);
+}
+
+/*
+ * Initialize accounting resources for staging a new btree.  Callers are
+ * expected to add their own reservations (and clean them up) manually.
+ */
+void
+xrep_newbt_init_bare(
+	struct xrep_newbt		*xnr,
+	struct xfs_scrub		*sc)
+{
+	xrep_newbt_init_ag(xnr, sc, &XFS_RMAP_OINFO_ANY_OWNER, NULLFSBLOCK,
+			XFS_AG_RESV_NONE);
+}
+
+/* Designate specific blocks to be used to build our new btree. */
+int
+xrep_newbt_add_blocks(
+	struct xrep_newbt		*xnr,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len)
+{
+	struct xrep_newbt_resv	*resv;
+
+	resv = kmem_alloc(sizeof(struct xrep_newbt_resv), KM_MAYFAIL);
+	if (!resv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&resv->list);
+	resv->fsbno = fsbno;
+	resv->len = len;
+	resv->used = 0;
+	list_add_tail(&resv->list, &xnr->resv_list);
+	return 0;
+}
+
+/* Allocate disk space for our new btree. */
+int
+xrep_newbt_alloc_blocks(
+	struct xrep_newbt	*xnr,
+	uint64_t		nr_blocks)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+	xfs_alloctype_t		type;
+	xfs_fsblock_t		alloc_hint = xnr->alloc_hint;
+	int			error = 0;
+
+	/*
+	 * Inode-rooted btrees can allocate from any AG, whereas AG btrees
+	 * require a specific AG mentioned in the alloc hint..
+	 */
+	type = sc->ip ? XFS_ALLOCTYPE_START_BNO : XFS_ALLOCTYPE_NEAR_BNO;
+
+	while (nr_blocks > 0 && !error) {
+		struct xfs_alloc_arg	args = {
+			.tp		= sc->tp,
+			.mp		= sc->mp,
+			.type		= type,
+			.fsbno		= alloc_hint,
+			.oinfo		= xnr->oinfo,
+			.minlen		= 1,
+			.maxlen		= nr_blocks,
+			.prod		= nr_blocks,
+			.resv		= xnr->resv,
+		};
+
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK)
+			return -ENOSPC;
+
+		trace_xrep_newbt_alloc_blocks(sc->mp,
+				XFS_FSB_TO_AGNO(sc->mp, args.fsbno),
+				XFS_FSB_TO_AGBNO(sc->mp, args.fsbno),
+				args.len, xnr->oinfo.oi_owner);
+
+		error = xrep_newbt_add_blocks(xnr, args.fsbno, args.len);
+		if (error)
+			break;
+
+		nr_blocks -= args.len;
+		alloc_hint = args.fsbno + args.len - 1;
+
+		if (sc->ip)
+			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+		else
+			error = xrep_roll_ag_trans(sc);
+	}
+
+	return error;
+}
+
+/*
+ * Release blocks that were reserved for a btree repair.  If the repair
+ * succeeded then we log deferred frees for unused blocks.  Otherwise, we try
+ * to free the extents immediately to roll the filesystem back to where it was
+ * before we started.
+ */
+static inline int
+xrep_newbt_destroy_reservation(
+	struct xrep_newbt	*xnr,
+	struct xrep_newbt_resv	*resv,
+	bool			cancel_repair)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+
+	if (cancel_repair) {
+		int		error;
+
+		/* Free the extent then roll the transaction. */
+		error = xfs_free_extent(sc->tp, resv->fsbno, resv->len,
+				&xnr->oinfo, xnr->resv);
+		if (error)
+			return error;
+
+		if (sc->ip)
+			return xfs_trans_roll_inode(&sc->tp, sc->ip);
+		return xrep_roll_ag_trans(sc);
+	}
+
+	/*
+	 * Use the deferred freeing mechanism to schedule for deletion any
+	 * blocks we didn't use to rebuild the tree.  This enables us to log
+	 * them all in the same transaction as the root change.
+	 */
+	resv->fsbno += resv->used;
+	resv->len -= resv->used;
+	resv->used = 0;
+
+	if (resv->len == 0)
+		return 0;
+
+	trace_xrep_newbt_free_blocks(sc->mp,
+			XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
+			XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
+			resv->len, xnr->oinfo.oi_owner);
+
+	__xfs_bmap_add_free(sc->tp, resv->fsbno, resv->len, &xnr->oinfo, true);
+
+	return 0;
+}
+
+/* Free all the accounting info and disk space we reserved for a new btree. */
+void
+xrep_newbt_destroy(
+	struct xrep_newbt	*xnr,
+	int			error)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+	struct xrep_newbt_resv	*resv, *n;
+
+	/*
+	 * If the filesystem already went down, we can't free the blocks.  Skip
+	 * ahead to freeing the incore metadata because we can't fix anything.
+	 */
+	if (XFS_FORCED_SHUTDOWN(sc->mp))
+		goto junkit;
+
+	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
+		error = xrep_newbt_destroy_reservation(xnr, resv, error != 0);
+		if (error)
+			goto junkit;
+
+		list_del(&resv->list);
+		kmem_free(resv);
+	}
+
+junkit:
+	/*
+	 * If we still have reservations attached to @newbt, cleanup must have
+	 * failed and the filesystem is about to go down.  Clean up the incore
+	 * reservations.
+	 */
+	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
+		list_del(&resv->list);
+		kmem_free(resv);
+	}
+
+	if (sc->ip) {
+		kmem_zone_free(xfs_ifork_zone, xnr->ifake.if_fork);
+		xnr->ifake.if_fork = NULL;
+	}
+}
+
+/* Feed one of the reserved btree blocks to the bulk loader. */
+int
+xrep_newbt_claim_block(
+	struct xfs_btree_cur	*cur,
+	struct xrep_newbt	*xnr,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xrep_newbt_resv	*resv;
+	xfs_fsblock_t		fsb;
+
+	/*
+	 * The first item in the list should always have a free block unless
+	 * we're completely out.
+	 */
+	resv = list_first_entry(&xnr->resv_list, struct xrep_newbt_resv, list);
+	if (resv->used == resv->len)
+		return -ENOSPC;
+
+	/*
+	 * Peel off a block from the start of the reservation.  We allocate
+	 * blocks in order to place blocks on disk in increasing record or key
+	 * order.  The block reservations tend to end up on the list in
+	 * decreasing order, which hopefully results in leaf blocks ending up
+	 * together.
+	 */
+	fsb = resv->fsbno + resv->used;
+	resv->used++;
+
+	/* If we used all the blocks in this reservation, move it to the end. */
+	if (resv->used == resv->len)
+		list_move_tail(&resv->list, &xnr->resv_list);
+
+	trace_xrep_newbt_claim_block(cur->bc_mp,
+			XFS_FSB_TO_AGNO(cur->bc_mp, fsb),
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsb),
+			1, xnr->oinfo.oi_owner);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(fsb);
+	else
+		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
+	return 0;
+}
+
+/*
+ * Estimate proper slack values for a btree that's being reloaded.
+ *
+ * Under most circumstances, we'll take whatever default loading value the
+ * btree bulk loading code calculates for us.  However, there are some
+ * exceptions to this rule:
+ *
+ * (1) If someone turned one of the debug knobs.
+ * (2) If this is a per-AG btree and the AG has less than ~9% space free.
+ * (3) If this is an inode btree and the FS has less than ~9% space free.
+ *
+ * Note that we actually use 3/32 for the comparison to avoid division.
+ */
+void
+xrep_bload_estimate_slack(
+	struct xfs_scrub	*sc,
+	struct xfs_btree_bload	*bload)
+{
+	uint64_t		free;
+	uint64_t		sz;
+
+	/* Let the btree code compute the default slack values. */
+	bload->leaf_slack = -1;
+	bload->node_slack = -1;
+
+	if (sc->ops->type == ST_PERAG) {
+		free = sc->sa.pag->pagf_freeblks;
+		sz = xfs_ag_block_count(sc->mp, sc->sa.agno);
+	} else {
+		free = percpu_counter_sum(&sc->mp->m_fdblocks);
+		sz = sc->mp->m_sb.sb_dblocks;
+	}
+
+	/* No further changes if there's more than 3/32ths space left. */
+	if (free >= ((sz * 3) >> 5))
+		return;
+
+	/* We're low on space; load the btrees as tightly as possible. */
+	if (bload->leaf_slack < 0)
+		bload->leaf_slack = 0;
+	if (bload->node_slack < 0)
+		bload->node_slack = 0;
+}
+
 /*
  * Reconstructing per-AG Btrees
  *
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 479cfe38065e..43eca74b19d0 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -6,6 +6,10 @@
 #ifndef __XFS_SCRUB_REPAIR_H__
 #define __XFS_SCRUB_REPAIR_H__
 
+#include "scrub/bitmap.h"
+#include "xfs_btree.h"
+union xfs_btree_ptr;
+
 static inline int xrep_notsupported(struct xfs_scrub *sc)
 {
 	return -EOPNOTSUPP;
@@ -59,6 +63,57 @@ int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 
+struct xrep_newbt_resv {
+	/* Link to list of extents that we've reserved. */
+	struct list_head	list;
+
+	/* FSB of the block we reserved. */
+	xfs_fsblock_t		fsbno;
+
+	/* Length of the reservation. */
+	xfs_extlen_t		len;
+
+	/* How much of this reservation has been used. */
+	xfs_extlen_t		used;
+};
+
+struct xrep_newbt {
+	struct xfs_scrub	*sc;
+
+	/* List of extents that we've reserved. */
+	struct list_head	resv_list;
+
+	/* Fake root for new btree. */
+	union {
+		struct xbtree_afakeroot	afake;
+		struct xbtree_ifakeroot	ifake;
+	};
+
+	/* rmap owner of these blocks */
+	struct xfs_owner_info	oinfo;
+
+	/* Allocation hint */
+	xfs_fsblock_t		alloc_hint;
+
+	/* per-ag reservation type */
+	enum xfs_ag_resv_type	resv;
+};
+
+void xrep_newbt_init_bare(struct xrep_newbt *xba, struct xfs_scrub *sc);
+void xrep_newbt_init_ag(struct xrep_newbt *xba, struct xfs_scrub *sc,
+		const struct xfs_owner_info *oinfo, xfs_fsblock_t alloc_hint,
+		enum xfs_ag_resv_type resv);
+void xrep_newbt_init_inode(struct xrep_newbt *xba, struct xfs_scrub *sc,
+		int whichfork, const struct xfs_owner_info *oinfo);
+int xrep_newbt_add_blocks(struct xrep_newbt *xba, xfs_fsblock_t fsbno,
+		xfs_extlen_t len);
+int xrep_newbt_alloc_blocks(struct xrep_newbt *xba, uint64_t nr_blocks);
+void xrep_newbt_destroy(struct xrep_newbt *xba, int error);
+int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xba,
+		union xfs_btree_ptr *ptr);
+void xrep_bload_estimate_slack(struct xfs_scrub *sc,
+		struct xfs_btree_bload *bload);
+
 #else
 
 static inline int xrep_attempt(
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3362bae28b46..651d7b8ee09f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -904,6 +904,42 @@ TRACE_EVENT(xrep_ialloc_insert,
 		  __entry->freemask)
 )
 
+DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 int64_t owner),
+	TP_ARGS(mp, agno, agbno, len, owner),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(int64_t, owner)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->owner = owner;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner)
+);
+#define DEFINE_NEWBT_EXTENT_EVENT(name) \
+DEFINE_EVENT(xrep_newbt_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 int64_t owner), \
+	TP_ARGS(mp, agno, agbno, len, owner))
+DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_blocks);
+DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_free_blocks);
+DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_claim_block);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

