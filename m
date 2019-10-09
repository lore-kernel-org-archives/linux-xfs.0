Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2BEC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC561218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SnBClgOO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfJIQuP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:50:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47010 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJIQuP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:50:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Gjp90026856
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=l55gL0fOYrHH0cd93hgXznlpDeo59gSi61EFVG2DhKg=;
 b=SnBClgOOPWcet7L0TwuNpmOYuGxtaSAPX9PxLeR7TR9Y2WhFMGy1rTxT/FVcdBmBS2PM
 D7/0z0toV3nFZyS3VZ+s1PkllQC/ulHg8LkXBXSuZNftP1MfVzuhl7dbUdW+PFfI3zO/
 yUcFGUns4r4ntnufWdQn1RWP/zg0GNWA6+YwrbVR5Ggpt4VrKl2vuwjvRMnHhR1YwA0j
 Hdi/q5Fc+/Uh8CP8YD9yL9VznsbF9e+/ck6xO0EIWFsp5kCoaFLKePMYqM0RQ6ZYnFS3
 HM3MBhr3noLIL/obve4YSD2HJsfLOvVbJDMa1vzrzQu8dqewdQBwb16+4d7PLeZFor+6 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vektrnruh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjWLV054943
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vh5cb217u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:09 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99Go7Q8028078
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:50:07 -0700
Subject: [PATCH 3/3] xfs: log EFIs for all btree blocks being used to stage
 a btree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:50:06 -0700
Message-ID: <157063980635.2914891.10711621853635545427.stgit@magnolia>
In-Reply-To: <157063978750.2914891.14339604572380248276.stgit@magnolia>
References: <157063978750.2914891.14339604572380248276.stgit@magnolia>
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

We need to log EFIs for every extent that we allocate for the purpose of
staging a new btree so that if we fail then the blocks will be freed
during log recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c     |   37 +++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/repair.h     |    4 +++-
 fs/xfs/xfs_extfree_item.c |    2 --
 3 files changed, 38 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index beebd484c5f3..49cea124148b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -25,6 +25,8 @@
 #include "xfs_ag_resv.h"
 #include "xfs_quota.h"
 #include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_extfree_item.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -412,7 +414,8 @@ int
 xrep_newbt_add_reservation(
 	struct xrep_newbt		*xnr,
 	xfs_fsblock_t			fsbno,
-	xfs_extlen_t			len)
+	xfs_extlen_t			len,
+	void				*priv)
 {
 	struct xrep_newbt_resv	*resv;
 
@@ -424,6 +427,7 @@ xrep_newbt_add_reservation(
 	resv->fsbno = fsbno;
 	resv->len = len;
 	resv->used = 0;
+	resv->priv = priv;
 	list_add_tail(&resv->list, &xnr->reservations);
 	return 0;
 }
@@ -434,6 +438,7 @@ xrep_newbt_reserve_space(
 	struct xrep_newbt	*xnr,
 	uint64_t		nr_blocks)
 {
+	const struct xfs_defer_op_type *efi_type = &xfs_extent_free_defer_type;
 	struct xfs_scrub	*sc = xnr->sc;
 	xfs_alloctype_t		type;
 	xfs_fsblock_t		alloc_hint = xnr->alloc_hint;
@@ -442,6 +447,7 @@ xrep_newbt_reserve_space(
 	type = sc->ip ? XFS_ALLOCTYPE_START_BNO : XFS_ALLOCTYPE_NEAR_BNO;
 
 	while (nr_blocks > 0 && !error) {
+		struct xfs_extent_free_item	efi_item;
 		struct xfs_alloc_arg	args = {
 			.tp		= sc->tp,
 			.mp		= sc->mp,
@@ -453,6 +459,7 @@ xrep_newbt_reserve_space(
 			.prod		= nr_blocks,
 			.resv		= xnr->resv,
 		};
+		void			*efi;
 
 		error = xfs_alloc_vextent(&args);
 		if (error)
@@ -465,7 +472,20 @@ xrep_newbt_reserve_space(
 				XFS_FSB_TO_AGBNO(sc->mp, args.fsbno),
 				args.len, xnr->oinfo.oi_owner);
 
-		error = xrep_newbt_add_reservation(xnr, args.fsbno, args.len);
+		/*
+		 * Log a deferred free item for each extent we allocate so that
+		 * we can get all of the space back if we crash before we can
+		 * commit the new btree.
+		 */
+		efi_item.xefi_startblock = args.fsbno;
+		efi_item.xefi_blockcount = args.len;
+		efi_item.xefi_oinfo = xnr->oinfo;
+		efi_item.xefi_skip_discard = true;
+		efi = efi_type->create_intent(sc->tp, 1);
+		efi_type->log_item(sc->tp, efi, &efi_item.xefi_list);
+
+		error = xrep_newbt_add_reservation(xnr, args.fsbno, args.len,
+				efi);
 		if (error)
 			break;
 
@@ -487,6 +507,7 @@ xrep_newbt_destroy(
 	struct xrep_newbt	*xnr,
 	int			error)
 {
+	const struct xfs_defer_op_type *efi_type = &xfs_extent_free_defer_type;
 	struct xfs_scrub	*sc = xnr->sc;
 	struct xrep_newbt_resv	*resv, *n;
 
@@ -494,6 +515,17 @@ xrep_newbt_destroy(
 		goto junkit;
 
 	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
+		struct xfs_efd_log_item *efd;
+
+		/*
+		 * Log a deferred free done for each extent we allocated now
+		 * that we've linked the block into the filesystem.  We cheat
+		 * since we know that log recovery has never looked at the
+		 * extents attached to an EFD.
+		 */
+		efd = efi_type->create_done(sc->tp, resv->priv, 0);
+		set_bit(XFS_LI_DIRTY, &efd->efd_item.li_flags);
+
 		/* Free every block we didn't use. */
 		resv->fsbno += resv->used;
 		resv->len -= resv->used;
@@ -515,6 +547,7 @@ xrep_newbt_destroy(
 
 junkit:
 	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
+		efi_type->abort_intent(resv->priv);
 		list_del(&resv->list);
 		kmem_free(resv);
 	}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index ab6c1199ecc0..cb86281de28b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -67,6 +67,8 @@ struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
 	struct list_head	list;
 
+	void			*priv;
+
 	/* FSB of the block we reserved. */
 	xfs_fsblock_t		fsbno;
 
@@ -112,7 +114,7 @@ void xrep_newbt_init_ag(struct xrep_newbt *xba, struct xfs_scrub *sc,
 void xrep_newbt_init_inode(struct xrep_newbt *xba, struct xfs_scrub *sc,
 		int whichfork, const struct xfs_owner_info *oinfo);
 int xrep_newbt_add_reservation(struct xrep_newbt *xba, xfs_fsblock_t fsbno,
-		xfs_extlen_t len);
+		xfs_extlen_t len, void *priv);
 int xrep_newbt_reserve_space(struct xrep_newbt *xba, uint64_t nr_blocks);
 void xrep_newbt_destroy(struct xrep_newbt *xba, int error);
 int xrep_newbt_alloc_block(struct xfs_btree_cur *cur, struct xrep_newbt *xba,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e44efc41a041..1e49936afbfb 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -328,8 +328,6 @@ xfs_trans_get_efd(
 {
 	struct xfs_efd_log_item		*efdp;
 
-	ASSERT(nextents > 0);
-
 	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
 		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
 				(nextents - 1) * sizeof(struct xfs_extent),

