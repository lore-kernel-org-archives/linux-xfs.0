Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DBFCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5664820659
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h9PPwMSb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfJ2Xcz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:32:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2Xcy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:32:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSjrx010477
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zcpUAYKGm1MyZlO/X1kyakV+CJLmLoSHKGWQnSn8wdg=;
 b=h9PPwMSbMIsEQeaMBm7uAjGTsWeo9b3csjaB0TZfAOZTQDxqtex5WZDkazRtjZ2ovwHm
 grT4PPa0gGDahnkgXezTgO0ZB77VWqDofcI77/V2wurGTlZa1w910JglEDUWoEKlKgRp
 ccpLAdX9aFOKS1s/8qxfHmNGuaV0FeS9lSedxNM675QXbAitzAh1CSLVvM6SEfxzfUvd
 ukOuEV/o4h1r3Rd7/LESmAM/B5XHYYzRVVqleOSP7Spp5DYvE55C+zzmvXoRE+qP4Vim
 fKjlneiQJfg+cu2sxblDyoko/mFyA4D5GcDjplyxqehkcDQxVuy6pX/6NI4Tqa1TfgYq Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vxwhfgb2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:32:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSES8039069
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vxwj8v030-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:52 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TNUpup024039
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:30:51 -0700
Subject: [PATCH 3/3] xfs: use deferred frees to reap old btree blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:30:50 -0700
Message-ID: <157239185082.1266870.16094965166871219902.stgit@magnolia>
In-Reply-To: <157239183075.1266870.1797402857427212175.stgit@magnolia>
References: <157239183075.1266870.1797402857427212175.stgit@magnolia>
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

Use deferred frees (EFIs) to reap the blocks of a btree that we just
replaced.  This helps us to shrink the window in which those old blocks
could be lost due to a system crash, though we try to flush the EFIs
every few hundred blocks so that we don't also overflow the transaction
reservations during and after we commit the new btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 62a9b77eba3d..477df76174b9 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -24,6 +24,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_ag_resv.h"
 #include "xfs_quota.h"
+#include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -510,13 +511,15 @@ xrep_reap_block(
 	struct xfs_scrub		*sc,
 	xfs_fsblock_t			fsbno,
 	const struct xfs_owner_info	*oinfo,
-	enum xfs_ag_resv_type		resv)
+	enum xfs_ag_resv_type		resv,
+	unsigned int			*deferred)
 {
 	struct xfs_btree_cur		*cur;
 	struct xfs_buf			*agf_bp = NULL;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	bool				has_other_rmap;
+	bool				need_roll = true;
 	int				error;
 
 	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
@@ -563,14 +566,24 @@ xrep_reap_block(
 		xrep_reap_invalidate_block(sc, fsbno);
 		error = xrep_put_freelist(sc, agbno);
 	} else {
+		/*
+		 * Use deferred frees to get rid of the old btree blocks to try
+		 * to minimize the window in which we could crash and lose the
+		 * old blocks.  However, we still need to roll the transaction
+		 * every 100 or so EFIs so that we don't exceed the log
+		 * reservation.
+		 */
 		xrep_reap_invalidate_block(sc, fsbno);
-		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
+		__xfs_bmap_add_free(sc->tp, fsbno, 1, oinfo, false);
+		(*deferred)++;
+		need_roll = *deferred > 100;
 	}
 	if (agf_bp != sc->sa.agf_bp)
 		xfs_trans_brelse(sc->tp, agf_bp);
-	if (error)
+	if (error || !need_roll)
 		return error;
 
+	*deferred = 0;
 	if (sc->ip)
 		return xfs_trans_roll_inode(&sc->tp, sc->ip);
 	return xrep_roll_ag_trans(sc);
@@ -592,6 +605,7 @@ xrep_reap_extents(
 	struct xfs_bitmap_range		*bmr;
 	struct xfs_bitmap_range		*n;
 	xfs_fsblock_t			fsbno;
+	unsigned int			deferred = 0;
 	int				error = 0;
 
 	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
@@ -603,12 +617,17 @@ xrep_reap_extents(
 				XFS_FSB_TO_AGNO(sc->mp, fsbno),
 				XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
 
-		error = xrep_reap_block(sc, fsbno, oinfo, type);
+		error = xrep_reap_block(sc, fsbno, oinfo, type, &deferred);
 		if (error)
 			break;
 	}
 
-	return error;
+	if (error || deferred == 0)
+		return error;
+
+	if (sc->ip)
+		return xfs_trans_roll_inode(&sc->tp, sc->ip);
+	return xrep_roll_ag_trans(sc);
 }
 
 /*

