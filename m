Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5090EC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B4020735
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lKjUYRdm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgEIQby (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:31:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgEIQby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:31:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRVvM196365;
        Sat, 9 May 2020 16:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ajMo4ReBISmalRahz1GRvjE9G54RLGKfhr37hRZKxIQ=;
 b=lKjUYRdmO4TJCQIOodsulyC1i1uonJRu1J7ZOcLDcDC41HIB1N2NUQadgyZflFxpyLmP
 ALUXrKhGioPoZBZuazhWICv5q7UWQ2QG5XLKdjUJ2wG2+Tg9U+meTWo2S4DZTyYYqoXp
 DSsWNEtov74C7q4H03kEuxMI3K/1nPB2K9t5SLocykh3e9P18SJ+YhkEcCRiPmRnisAW
 PkEVKq3QiioGJtuZfGBuK4ml6YFLbwmRX9GubD+LbEzmW5elvUTcAH+NrV7pacQAYl4P
 HWt0FZpbjdNnL4TH9IFEh1jXyH05bfG2Q5opQ+iKZJG/G/h/gOJAWoKfoUvD7VRoS9+q IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30wmfm152e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTuMe112431;
        Sat, 9 May 2020 16:31:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30wx11cvrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:48 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GVl7f020819;
        Sat, 9 May 2020 16:31:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:47 -0700
Subject: [PATCH 1/9] xfs_repair: port the online repair newbt structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sat, 09 May 2020 09:31:47 -0700
Message-ID: <158904190713.984305.3298591047333841655.stgit@magnolia>
In-Reply-To: <158904190079.984305.707785748675261111.stgit@magnolia>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Port the new btree staging context and related block reservation helper
code from the kernel to repair.  We'll use this in subsequent patches to
implement btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h         |    1 
 libxfs/libxfs_api_defs.h |    2 
 repair/Makefile          |    4 -
 repair/bload.c           |  276 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/bload.h           |   79 +++++++++++++
 repair/xfs_repair.c      |   17 +++
 6 files changed, 377 insertions(+), 2 deletions(-)
 create mode 100644 repair/bload.c
 create mode 100644 repair/bload.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 12447835..b9370139 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -76,6 +76,7 @@ struct iomap;
 #include "xfs_rmap.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
+#include "xfs_btree_staging.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index be06c763..61047f8f 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -27,12 +27,14 @@
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
 #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
 #define xfs_alloc_read_agf		libxfs_alloc_read_agf
+#define xfs_alloc_vextent		libxfs_alloc_vextent
 
 #define xfs_attr_get			libxfs_attr_get
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
 
+#define __xfs_bmap_add_free		__libxfs_bmap_add_free
 #define xfs_bmapi_read			libxfs_bmapi_read
 #define xfs_bmapi_write			libxfs_bmapi_write
 #define xfs_bmap_last_offset		libxfs_bmap_last_offset
diff --git a/repair/Makefile b/repair/Makefile
index 0964499a..8cc1ee68 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -9,11 +9,11 @@ LSRCFILES = README
 
 LTCOMMAND = xfs_repair
 
-HFILES = agheader.h attr_repair.h avl.h bmap.h btree.h \
+HFILES = agheader.h attr_repair.h avl.h bload.h bmap.h btree.h \
 	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
 	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
 
-CFILES = agheader.c attr_repair.c avl.c bmap.c btree.c \
+CFILES = agheader.c attr_repair.c avl.c bload.c bmap.c btree.c \
 	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
diff --git a/repair/bload.c b/repair/bload.c
new file mode 100644
index 00000000..ab05815c
--- /dev/null
+++ b/repair/bload.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include <libxfs.h>
+#include "bload.h"
+
+#define trace_xrep_newbt_claim_block(...)	((void) 0)
+#define trace_xrep_newbt_reserve_space(...)	((void) 0)
+#define trace_xrep_newbt_unreserve_space(...)	((void) 0)
+#define trace_xrep_newbt_claim_block(...)	((void) 0)
+
+int bload_leaf_slack = -1;
+int bload_node_slack = -1;
+
+/* Ported routines from fs/xfs/scrub/repair.c */
+
+/*
+ * Roll a transaction, keeping the AG headers locked and reinitializing
+ * the btree cursors.
+ */
+int
+xrep_roll_ag_trans(
+	struct repair_ctx	*sc)
+{
+	int			error;
+
+	/* Keep the AG header buffers locked so we can keep going. */
+	if (sc->agi_bp)
+		libxfs_trans_bhold(sc->tp, sc->agi_bp);
+	if (sc->agf_bp)
+		libxfs_trans_bhold(sc->tp, sc->agf_bp);
+	if (sc->agfl_bp)
+		libxfs_trans_bhold(sc->tp, sc->agfl_bp);
+
+	/*
+	 * Roll the transaction.  We still own the buffer and the buffer lock
+	 * regardless of whether or not the roll succeeds.  If the roll fails,
+	 * the buffers will be released during teardown on our way out of the
+	 * kernel.  If it succeeds, we join them to the new transaction and
+	 * move on.
+	 */
+	error = -libxfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+
+	/* Join AG headers to the new transaction. */
+	if (sc->agi_bp)
+		libxfs_trans_bjoin(sc->tp, sc->agi_bp);
+	if (sc->agf_bp)
+		libxfs_trans_bjoin(sc->tp, sc->agf_bp);
+	if (sc->agfl_bp)
+		libxfs_trans_bjoin(sc->tp, sc->agfl_bp);
+
+	return 0;
+}
+
+/* Initialize accounting resources for staging a new AG btree. */
+void
+xrep_newbt_init_ag(
+	struct xrep_newbt		*xnr,
+	struct repair_ctx		*sc,
+	const struct xfs_owner_info	*oinfo,
+	xfs_fsblock_t			alloc_hint,
+	enum xfs_ag_resv_type		resv)
+{
+	memset(xnr, 0, sizeof(struct xrep_newbt));
+	xnr->sc = sc;
+	xnr->oinfo = *oinfo; /* structure copy */
+	xnr->alloc_hint = alloc_hint;
+	xnr->resv = resv;
+	INIT_LIST_HEAD(&xnr->reservations);
+}
+
+/* Initialize accounting resources for staging a new inode fork btree. */
+void
+xrep_newbt_init_inode(
+	struct xrep_newbt		*xnr,
+	struct repair_ctx		*sc,
+	int				whichfork,
+	const struct xfs_owner_info	*oinfo)
+{
+	memset(xnr, 0, sizeof(struct xrep_newbt));
+	xnr->sc = sc;
+	xnr->oinfo = *oinfo; /* structure copy */
+	xnr->alloc_hint = XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino);
+	xnr->resv = XFS_AG_RESV_NONE;
+	xnr->ifake.if_fork = kmem_zone_zalloc(xfs_ifork_zone, 0);
+	xnr->ifake.if_fork_size = XFS_IFORK_SIZE(sc->ip, whichfork);
+	INIT_LIST_HEAD(&xnr->reservations);
+}
+
+/*
+ * Initialize accounting resources for staging a new btree.  Callers are
+ * expected to add their own reservations (and clean them up) manually.
+ */
+void
+xrep_newbt_init_bare(
+	struct xrep_newbt		*xnr,
+	struct repair_ctx		*sc)
+{
+	xrep_newbt_init_ag(xnr, sc, &XFS_RMAP_OINFO_ANY_OWNER, NULLFSBLOCK,
+			XFS_AG_RESV_NONE);
+}
+
+/* Add a space reservation manually. */
+int
+xrep_newbt_add_reservation(
+	struct xrep_newbt		*xnr,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len,
+	void				*priv)
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
+	resv->priv = priv;
+	list_add_tail(&resv->list, &xnr->reservations);
+	return 0;
+}
+
+/* Reserve disk space for our new btree. */
+int
+xrep_newbt_reserve_space(
+	struct xrep_newbt	*xnr,
+	uint64_t		nr_blocks)
+{
+	struct repair_ctx	*sc = xnr->sc;
+	xfs_alloctype_t		type;
+	xfs_fsblock_t		alloc_hint = xnr->alloc_hint;
+	int			error = 0;
+
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
+			.prod		= 1,
+			.resv		= xnr->resv,
+		};
+
+		error = -libxfs_alloc_vextent(&args);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK)
+			return -ENOSPC;
+
+		trace_xrep_newbt_reserve_space(sc->mp,
+				XFS_FSB_TO_AGNO(sc->mp, args.fsbno),
+				XFS_FSB_TO_AGBNO(sc->mp, args.fsbno),
+				args.len, xnr->oinfo.oi_owner);
+
+		/* We don't have real EFIs here so skip that. */
+
+		error = xrep_newbt_add_reservation(xnr, args.fsbno, args.len,
+				NULL);
+		if (error)
+			break;
+
+		nr_blocks -= args.len;
+		alloc_hint = args.fsbno + args.len - 1;
+
+		if (sc->ip)
+			error = -libxfs_trans_roll_inode(&sc->tp, sc->ip);
+		else
+			error = xrep_roll_ag_trans(sc);
+	}
+
+	return error;
+}
+
+/* Free all the accounting infor and disk space we reserved for a new btree. */
+void
+xrep_newbt_destroy(
+	struct xrep_newbt	*xnr,
+	int			error)
+{
+	struct repair_ctx	*sc = xnr->sc;
+	struct xrep_newbt_resv	*resv, *n;
+
+	if (error)
+		goto junkit;
+
+	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
+		/* We don't have EFIs here so skip the EFD. */
+
+		/* Free every block we didn't use. */
+		resv->fsbno += resv->used;
+		resv->len -= resv->used;
+		resv->used = 0;
+
+		if (resv->len > 0) {
+			trace_xrep_newbt_unreserve_space(sc->mp,
+					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
+					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
+					resv->len, xnr->oinfo.oi_owner);
+
+			__libxfs_bmap_add_free(sc->tp, resv->fsbno, resv->len,
+					&xnr->oinfo, true);
+		}
+
+		list_del(&resv->list);
+		kmem_free(resv);
+	}
+
+junkit:
+	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
+		list_del(&resv->list);
+		kmem_free(resv);
+	}
+
+	if (sc->ip) {
+		kmem_cache_free(xfs_ifork_zone, xnr->ifake.if_fork);
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
+	 * If last_resv doesn't have a block for us, move forward until we find
+	 * one that does (or run out of reservations).
+	 */
+	if (xnr->last_resv == NULL) {
+		list_for_each_entry(resv, &xnr->reservations, list) {
+			if (resv->used < resv->len) {
+				xnr->last_resv = resv;
+				break;
+			}
+		}
+		if (xnr->last_resv == NULL)
+			return -ENOSPC;
+	} else if (xnr->last_resv->used == xnr->last_resv->len) {
+		if (xnr->last_resv->list.next == &xnr->reservations)
+			return -ENOSPC;
+		xnr->last_resv = list_entry(xnr->last_resv->list.next,
+				struct xrep_newbt_resv, list);
+	}
+
+	/* Nab the block. */
+	fsb = xnr->last_resv->fsbno + xnr->last_resv->used;
+	xnr->last_resv->used++;
+
+	trace_xrep_newbt_claim_block(cur->bc_mp,
+			XFS_FSB_TO_AGNO(cur->bc_mp, fsb),
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsb),
+			xnr->oinfo.oi_owner);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(fsb);
+	else
+		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
+	return 0;
+}
diff --git a/repair/bload.h b/repair/bload.h
new file mode 100644
index 00000000..ba5f6d0b
--- /dev/null
+++ b/repair/bload.h
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_REPAIR_BLOAD_H__
+#define __XFS_REPAIR_BLOAD_H__
+
+extern int bload_leaf_slack;
+extern int bload_node_slack;
+
+struct repair_ctx {
+	struct xfs_mount	*mp;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+
+	struct xfs_buf		*agi_bp;
+	struct xfs_buf		*agf_bp;
+	struct xfs_buf		*agfl_bp;
+};
+
+struct xrep_newbt_resv {
+	/* Link to list of extents that we've reserved. */
+	struct list_head	list;
+
+	void			*priv;
+
+	/* FSB of the block we reserved. */
+	xfs_fsblock_t		fsbno;
+
+	/* Length of the reservation. */
+	xfs_extlen_t		len;
+
+	/* How much of this reservation we've used. */
+	xfs_extlen_t		used;
+};
+
+struct xrep_newbt {
+	struct repair_ctx	*sc;
+
+	/* List of extents that we've reserved. */
+	struct list_head	reservations;
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
+	/* The last reservation we allocated from. */
+	struct xrep_newbt_resv	*last_resv;
+
+	/* Allocation hint */
+	xfs_fsblock_t		alloc_hint;
+
+	/* per-ag reservation type */
+	enum xfs_ag_resv_type	resv;
+};
+
+#define for_each_xrep_newbt_reservation(xnr, resv, n)	\
+	list_for_each_entry_safe((resv), (n), &(xnr)->reservations, list)
+
+void xrep_newbt_init_bare(struct xrep_newbt *xba, struct repair_ctx *sc);
+void xrep_newbt_init_ag(struct xrep_newbt *xba, struct repair_ctx *sc,
+		const struct xfs_owner_info *oinfo, xfs_fsblock_t alloc_hint,
+		enum xfs_ag_resv_type resv);
+void xrep_newbt_init_inode(struct xrep_newbt *xba, struct repair_ctx *sc,
+		int whichfork, const struct xfs_owner_info *oinfo);
+int xrep_newbt_add_reservation(struct xrep_newbt *xba, xfs_fsblock_t fsbno,
+		xfs_extlen_t len, void *priv);
+int xrep_newbt_reserve_space(struct xrep_newbt *xba, uint64_t nr_blocks);
+void xrep_newbt_destroy(struct xrep_newbt *xba, int error);
+int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xba,
+		union xfs_btree_ptr *ptr);
+
+#endif /* __XFS_REPAIR_BLOAD_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9d72fa8e..8fbd3649 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -24,6 +24,7 @@
 #include "rmap.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/platform.h"
+#include "bload.h"
 
 /*
  * option tables for getsubopt calls
@@ -39,6 +40,8 @@ enum o_opt_nums {
 	AG_STRIDE,
 	FORCE_GEO,
 	PHASE2_THREADS,
+	BLOAD_LEAF_SLACK,
+	BLOAD_NODE_SLACK,
 	O_MAX_OPTS,
 };
 
@@ -49,6 +52,8 @@ static char *o_opts[] = {
 	[AG_STRIDE]		= "ag_stride",
 	[FORCE_GEO]		= "force_geometry",
 	[PHASE2_THREADS]	= "phase2_threads",
+	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
+	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -260,6 +265,18 @@ process_args(int argc, char **argv)
 		_("-o phase2_threads requires a parameter\n"));
 					phase2_threads = (int)strtol(val, NULL, 0);
 					break;
+				case BLOAD_LEAF_SLACK:
+					if (!val)
+						do_abort(
+		_("-o debug_bload_leaf_slack requires a parameter\n"));
+					bload_leaf_slack = (int)strtol(val, NULL, 0);
+					break;
+				case BLOAD_NODE_SLACK:
+					if (!val)
+						do_abort(
+		_("-o debug_bload_node_slack requires a parameter\n"));
+					bload_node_slack = (int)strtol(val, NULL, 0);
+					break;
 				default:
 					unknown('o', val);
 					break;

