Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174A9FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7D512087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:05:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P6aVNzwT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfKHHFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:05:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40558 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHFo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:05:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8741QX043259
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=aH2OuIgANtULHocoT4EY67HP3o07nkJzc09+ytZsap4=;
 b=P6aVNzwTGKNfp402hoLToQzFrJv5wLj+V0OafPHQH/sh2W4K6ScG/SmwLk47riISxXt+
 +ZRM8HpywFSoeVWn5nZXqITuifTPMYEDHsiOjofWLQJs0BMskbg+rnsHcsU8250vH4py
 CRtSvLfd3BexVGncJzJk+kLwdwLlito1tf15i/w0B8NBjiMVnKSpw7UYwKaTyN3Rz0ny
 9qd9s24612Z93+8WOJFPikMuaiCktLE9wAQULHLhBRjl162CqCc9cM3Hon7JXNeFicac
 ScdgCgyMp8FcUCoL4WF+8K4agiudu0Mp+ehPwBu8A4sVQChRgY2l1ivmBEiOeVlfNgsS DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w41w13ces-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:05:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8737Sh059505
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:05:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w4k30h96v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:05:41 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA875eDU020520
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:05:40 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:05:40 -0800
Subject: [PATCH 02/10] xfs: report ag header corruption errors to the health
 tracking system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 07 Nov 2019 23:05:38 -0800
Message-ID: <157319673868.834783.8513708296129892514.stgit@magnolia>
In-Reply-To: <157319672612.834783.1318671695966912922.stgit@magnolia>
References: <157319672612.834783.1318671695966912922.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter a corrupt AG header, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c    |    6 ++++++
 fs/xfs/libxfs/xfs_health.h   |    6 ++++++
 fs/xfs/libxfs/xfs_ialloc.c   |    3 +++
 fs/xfs/libxfs/xfs_refcount.c |    5 ++++-
 fs/xfs/libxfs/xfs_rmap.c     |    5 ++++-
 fs/xfs/libxfs/xfs_sb.c       |    2 ++
 fs/xfs/xfs_health.c          |   17 +++++++++++++++++
 fs/xfs/xfs_inode.c           |    9 +++++++++
 8 files changed, 51 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d3764de08f5f..0d95aab033cd 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
@@ -694,6 +695,8 @@ xfs_alloc_read_agfl(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGFL);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_AGFL_REF);
@@ -717,6 +720,7 @@ xfs_alloc_update_counters(
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
 		xfs_buf_corruption_error(agbp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
 		return -EFSCORRUPTED;
 	}
 
@@ -2945,6 +2949,8 @@ xfs_read_agf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGF);
 	if (error)
 		return error;
 	if (!*bpp)
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 3657a9cb8490..ce8954a10c66 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -123,6 +123,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
@@ -203,4 +205,8 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
+#define xfs_metadata_is_sick(error) \
+	(unlikely((error) == -EFSCORRUPTED || (error) == -EIO || \
+		  (error) == -EFSBADCRC))
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index cc29b61b35d7..cc552ac6721e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2635,6 +2636,8 @@ xfs_read_agi(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 	if (error)
 		return error;
 	if (tp)
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 05061edc4e15..988cedd2107e 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -22,6 +22,7 @@
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
 #include "xfs_rmap.h"
+#include "xfs_health.h"
 
 /* Allowable refcount adjustment amounts. */
 enum xfs_refc_adjust_op {
@@ -1177,8 +1178,10 @@ xfs_refcount_finish_one(
 				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+			xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
 			return -EFSCORRUPTED;
+		}
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
 		if (!rcur) {
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 61d4596931ff..eb163c7927ce 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -21,6 +21,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_inode.h"
+#include "xfs_health.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -2394,8 +2395,10 @@ xfs_rmap_finish_one(
 		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+			xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
 			return -EFSCORRUPTED;
+		}
 
 		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
 		if (!rcur) {
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 0ac69751fe85..4a923545465d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1169,6 +1169,8 @@ xfs_sb_read_secondary(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_SSB_REF);
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 860dc70c99e7..36c32b108b39 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -200,6 +200,23 @@ xfs_rt_measure_sickness(
 	spin_unlock(&mp->m_sb_lock);
 }
 
+/* Mark unhealthy per-ag metadata given a raw AG number. */
+void
+xfs_agno_mark_sick(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	unsigned int		mask)
+{
+	struct xfs_perag	*pag = xfs_perag_get(mp, agno);
+
+	/* per-ag structure not set up yet? */
+	if (!pag)
+		return;
+
+	xfs_ag_mark_sick(pag, mask);
+	xfs_perag_put(pag);
+}
+
 /* Mark unhealthy per-ag metadata. */
 void
 xfs_ag_mark_sick(
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a92d4521748d..d02246e2fb21 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -35,6 +35,7 @@
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -787,6 +788,8 @@ xfs_ialloc(
 	 */
 	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
 		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
 		return -EFSCORRUPTED;
 	}
 
@@ -2138,6 +2141,7 @@ xfs_iunlink_update_bucket(
 	 */
 	if (old_value == new_agino) {
 		xfs_buf_corruption_error(agibp);
+		xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2204,6 +2208,7 @@ xfs_iunlink_update_inode(
 	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -2218,6 +2223,7 @@ xfs_iunlink_update_inode(
 		if (next_agino != NULLAGINO) {
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			error = -EFSCORRUPTED;
 		}
 		goto out;
@@ -2272,6 +2278,7 @@ xfs_iunlink(
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
 		xfs_buf_corruption_error(agibp);
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2409,6 +2416,7 @@ xfs_iunlink_map_prev(
 			XFS_CORRUPTION_ERROR(__func__,
 					XFS_ERRLEVEL_LOW, mp,
 					*dipp, sizeof(**dipp));
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 			error = -EFSCORRUPTED;
 			return error;
 		}
@@ -2455,6 +2463,7 @@ xfs_iunlink_remove(
 	if (!xfs_verify_agino(mp, agno, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 

