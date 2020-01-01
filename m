Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EDCC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E0F206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gwdy6tPp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgAABBn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:01:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48906 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgAABBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:01:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010xCj4104005
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zcpUAYKGm1MyZlO/X1kyakV+CJLmLoSHKGWQnSn8wdg=;
 b=gwdy6tPp4jn6YapM5qtMmnzfPkPeUtQZTASaS1D4VlxeojUAOAvD6ZFyPba2R9M2vT6o
 eJ2RugJpwau9RCoWBkUe0k/rBHzviSi7fHPZD8vKZURzc/PQ/ujnLTDVGwD831IcNDv7
 QRWLrmGEjPLGIWZ8GfPamecWyeEklTmn8K2ecf6lLJFxHY9sS3yto21uMj0Scj7fPgZ9
 DBOGjFvMdaCHewzUkyZVoVkbFz2S2ky3+Ay7TJ61KBXg+5p2h3Jbquy/XGdgxEN7YYsy
 Zv3OZ+32UyVhAACub9eFfAYoc93Ve/Ic7f9AKr7L/gZPlR7Z3giQOdbsXxc2cyvvf64H xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk24j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:01:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wwsF190729
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guedcf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:01:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00111dqd019118
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:39 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:01:39 -0800
Subject: [PATCH 3/3] xfs: use deferred frees to reap old btree blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:01:37 -0800
Message-ID: <157784049699.1357430.2709645557384623682.stgit@magnolia>
In-Reply-To: <157784047838.1357430.18292934559846279176.stgit@magnolia>
References: <157784047838.1357430.18292934559846279176.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
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

