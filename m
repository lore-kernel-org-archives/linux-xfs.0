Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91237C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6594421848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b9pQvJbf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbfJIQs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:48:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbfJIQs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:48:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Gjdhs039810
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=BexpD3s79PvgMYPnNWt4N0XKJdrckBFDmbiPnQz8RSY=;
 b=b9pQvJbfyfbuNdg4PIkKdvyrwbtOqzwA9dK1zJOYFjXwv9QrSLW9vh5ZzcLGCt5Zz3KR
 SJn9VbmCqbUHigRSgrPkuxsyHsqTNkcL6/jjj6VvQ/8pPBrwDz4xK7Ck8ap4N16d84tM
 CLWAdPd3fC93BBrcyYApYOF3vBH0HqEKj1HJU/JPlBWelxaB6q6JhCHuqZm7CiWwnWFq
 sriXUTTI9BxQNVIxw0oaYSQhsZSxFT2UiwGjLjiHPfehCXaCPjhgD+zAAbgCpctqkBVz
 EVbV4Kbrwh9JRjq7nBMPogdfzoRKrw2eCB5ewtkFK3/igtRhM4qz9fqh8yrYwo52VdeO KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vejkup0xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:48:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GiZec144612
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vh8k145db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:48:55 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99GmsfR021431
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:48:54 -0700
Subject: [PATCH 3/3] xfs: use deferred frees to reap old btree blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:48:53 -0700
Message-ID: <157063973378.2913192.158267929318422892.stgit@magnolia>
In-Reply-To: <157063971218.2913192.8762913814390092382.stgit@magnolia>
References: <157063971218.2913192.8762913814390092382.stgit@magnolia>
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
index e21faef6db5a..8349694f985d 100644
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
@@ -512,13 +513,15 @@ xrep_reap_block(
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
@@ -565,14 +568,24 @@ xrep_reap_block(
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
+		__xfs_bmap_add_free(sc->tp, fsbno, 1, oinfo, true);
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
@@ -594,6 +607,7 @@ xrep_reap_extents(
 	struct xfs_bitmap_range		*bmr;
 	struct xfs_bitmap_range		*n;
 	xfs_fsblock_t			fsbno;
+	unsigned int			deferred = 0;
 	int				error = 0;
 
 	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
@@ -605,12 +619,17 @@ xrep_reap_extents(
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

