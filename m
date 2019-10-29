Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E31CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2781420659
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oozq0Je5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfJ2Xbs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:31:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2Xbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:31:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNT0p5017364
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dXsvhpsUDcLyk5wzeoRgfuJZTUZ3nNYfja40hpqSy+4=;
 b=Oozq0Je5ElE1E8h6Spa+SYA+PNcrHjC+sxg2I2kAAgB5NPuza3yps+clrEkHeECSiGNo
 Ue8RKwRW7gdALyrU8CLV6x+lmBSOc0ZluJp886v7lNOhXYnEOunDwLemeKhUTCX8gcfQ
 GX73UiRRV86GgPx9P9f69mfDe1f62y6IvHhDI22x+md5T1YtfojsBX6kJDZ76LpTbCms
 kYcPsSpsWBr5iAlnH0wpj9fmpa+UOrHQQB6arPeHlxgmTZp6/l/7nse5Ljyo0riHkGjj
 3b3hTg4t5oaw9QoJx5dod7gq8/VQsfjG8uCfyroz/SkOxbreJDHx164365EEh3fuqdNH hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vxwhf8b42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNRkrj183292
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vxwj84ag5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:46 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TNVjMH024446
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:31:44 -0700
Subject: [PATCH 3/3] xfs: log EFIs for all btree blocks being used to stage
 a btree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:31:44 -0700
Message-ID: <157239190396.1267186.8416850290295073322.stgit@magnolia>
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

We need to log EFIs for every extent that we allocate for the purpose of
staging a new btree so that if we fail then the blocks will be freed
during log recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c     |   63 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/repair.h     |    4 ++-
 fs/xfs/xfs_extfree_item.c |    2 -
 3 files changed, 64 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c38ff20b8fa9..e66596d0f21a 100644
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
@@ -409,7 +411,8 @@ int
 xrep_newbt_add_blocks(
 	struct xrep_newbt		*xnr,
 	xfs_fsblock_t			fsbno,
-	xfs_extlen_t			len)
+	xfs_extlen_t			len,
+	void				*priv)
 {
 	struct xrep_newbt_resv	*resv;
 
@@ -421,10 +424,55 @@ xrep_newbt_add_blocks(
 	resv->fsbno = fsbno;
 	resv->len = len;
 	resv->used = 0;
+	resv->priv = priv;
 	list_add_tail(&resv->list, &xnr->resv_list);
 	return 0;
 }
 
+/*
+ * Set up automatic reaping of the blocks reserved for btree reconstruction in
+ * case we crash by logging a deferred free item for each extent we allocate so
+ * that we can get all of the space back if we crash before we can commit the
+ * new btree.  This function returns a token that can be used to cancel
+ * automatic reaping if repair is successful.
+ */
+static void *
+xrep_newbt_schedule_reap(
+	struct xfs_trans		*tp,
+	struct xfs_owner_info		*oinfo,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len)
+{
+	struct xfs_extent_free_item	efi_item = {
+		.xefi_startblock	= fsbno,
+		.xefi_blockcount	= len,
+		.xefi_oinfo		= *oinfo, /* struct copy */
+		.xefi_skip_discard	= true,
+	};
+	struct xfs_efi_log_item		*efi;
+
+	INIT_LIST_HEAD(&efi_item.xefi_list);
+	efi = xfs_extent_free_defer_type.create_intent(tp, 1);
+	xfs_extent_free_defer_type.log_item(tp, efi, &efi_item.xefi_list);
+	return efi;
+}
+
+/*
+ * Cancel a previously scheduled automatic reap (see above) by logging a
+ * deferred free done for each extent we allocated.  We cheat since we know
+ * that log recovery has never looked at the extents attached to an EFD.
+ */
+static void
+xrep_newbt_cancel_reap(
+	struct xfs_trans	*tp,
+	void			*token)
+{
+	struct xfs_efd_log_item	*efd;
+
+	efd = xfs_extent_free_defer_type.create_done(tp, token, 0);
+	set_bit(XFS_LI_DIRTY, &efd->efd_item.li_flags);
+}
+
 /* Allocate disk space for our new btree. */
 int
 xrep_newbt_alloc_blocks(
@@ -454,6 +502,7 @@ xrep_newbt_alloc_blocks(
 			.prod		= nr_blocks,
 			.resv		= xnr->resv,
 		};
+		void			*token;
 
 		error = xfs_alloc_vextent(&args);
 		if (error)
@@ -466,7 +515,9 @@ xrep_newbt_alloc_blocks(
 				XFS_FSB_TO_AGBNO(sc->mp, args.fsbno),
 				args.len, xnr->oinfo.oi_owner);
 
-		error = xrep_newbt_add_blocks(xnr, args.fsbno, args.len);
+		token = xrep_newbt_schedule_reap(sc->tp, &xnr->oinfo,
+				args.fsbno, args.len);
+		error = xrep_newbt_add_blocks(xnr, args.fsbno, args.len, token);
 		if (error)
 			break;
 
@@ -510,6 +561,13 @@ xrep_newbt_destroy_reservation(
 		return xrep_roll_ag_trans(sc);
 	}
 
+	/*
+	 * Since we succeeded in rebuilding the btree, we need to log an EFD
+	 * for every extent we reserved to prevent log recovery from freeing
+	 * them mistakenly.
+	 */
+	xrep_newbt_cancel_reap(sc->tp, resv->priv);
+
 	/*
 	 * Use the deferred freeing mechanism to schedule for deletion any
 	 * blocks we didn't use to rebuild the tree.  This enables us to log
@@ -564,6 +622,7 @@ xrep_newbt_destroy(
 	 * reservations.
 	 */
 	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
+		xfs_extent_free_defer_type.abort_intent(resv->priv);
 		list_del(&resv->list);
 		kmem_free(resv);
 	}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 43eca74b19d0..6ca5dc8dfb2d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -67,6 +67,8 @@ struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
 	struct list_head	list;
 
+	void			*priv;
+
 	/* FSB of the block we reserved. */
 	xfs_fsblock_t		fsbno;
 
@@ -106,7 +108,7 @@ void xrep_newbt_init_ag(struct xrep_newbt *xba, struct xfs_scrub *sc,
 void xrep_newbt_init_inode(struct xrep_newbt *xba, struct xfs_scrub *sc,
 		int whichfork, const struct xfs_owner_info *oinfo);
 int xrep_newbt_add_blocks(struct xrep_newbt *xba, xfs_fsblock_t fsbno,
-		xfs_extlen_t len);
+		xfs_extlen_t len, void *priv);
 int xrep_newbt_alloc_blocks(struct xrep_newbt *xba, uint64_t nr_blocks);
 void xrep_newbt_destroy(struct xrep_newbt *xba, int error);
 int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xba,
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

