Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60F3C3F68F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B520206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kN4otolW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgAABHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:07:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgAABHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:07:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115IBw107534
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pO1JNr9SvzewIA9eXuwGIZH71fC2yC/pXddcyudiDls=;
 b=kN4otolW8/EMAyhAe4yrsNhNPoo1RImZlYSoeNDuMVfBF0voOg+uF7bss3GUfDZJbgob
 4BDLYXneHQcvOjvNSvmWa9Lj3/XhWC+U0S3jgfd4+N47RjWSVevzliaNrun/lzVzIe6v
 8C0vGf6Jys/az+3QTohyI4unne9ukZA64y4F0S+JBxP8vBxGDZnc1PxUJ8l6w8gd3twz
 zPSWnVSXLgd4BBwxzzdlEybj/6ArdyV/WRNxylgy7y4dfbJFFCiXyrw9hIi7KV9q0qlK
 7JxUt2m9Fqd0LIJH6Qv8iqX3268icB90f1QcvImNYFpAiknF94zCEHZqx1XJyBJCtwMk 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x5xftk2b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:07:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115FAM165836
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2x8gj91346-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:15 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00114uDE025938
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:04:56 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:04:56 -0800
Subject: [PATCH 02/10] xfs: report ag header corruption errors to the health
 tracking system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:04:52 -0800
Message-ID: <157784069209.1360095.11446811087494881964.stgit@magnolia>
In-Reply-To: <157784067947.1360095.12276226432994685051.stgit@magnolia>
References: <157784067947.1360095.12276226432994685051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter a corrupt AG header, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |    6 ++++++
 fs/xfs/libxfs/xfs_health.h |   13 ++++++++++---
 fs/xfs/libxfs/xfs_ialloc.c |    3 +++
 fs/xfs/libxfs/xfs_sb.c     |    2 ++
 fs/xfs/xfs_health.c        |   17 +++++++++++++++++
 fs/xfs/xfs_inode.c         |    9 +++++++++
 6 files changed, 47 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fc93fd88ec89..63d3fc97719c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
@@ -699,6 +700,8 @@ xfs_alloc_read_agfl(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGFL);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_AGFL_REF);
@@ -722,6 +725,7 @@ xfs_alloc_update_counters(
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
 		xfs_buf_corruption_error(agbp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
 		return -EFSCORRUPTED;
 	}
 
@@ -2960,6 +2964,8 @@ xfs_read_agf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGF);
 	if (error)
 		return error;
 	if (!*bpp)
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 96919a257870..c34c393d5aa7 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -26,9 +26,11 @@
  * and the "sick" field tells us if that piece was found to need repairs.
  * Therefore we can conclude that for a given sick flag value:
  *
- *  - checked && sick  => metadata needs repair
- *  - checked && !sick => metadata is ok
- *  - !checked         => has not been examined since mount
+ *  - checked && sick   => metadata needs repair
+ *  - checked && !sick  => metadata is ok
+ *  - !checked && sick  => errors have been observed during normal operation,
+ *                         but the metadata has not been checked thoroughly
+ *  - !checked && !sick => has not been examined since mount
  */
 
 struct xfs_mount;
@@ -121,6 +123,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
@@ -201,4 +205,7 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
+#define xfs_metadata_is_sick(error) \
+	(unlikely((error) == -EFSCORRUPTED || (error) == -EFSBADCRC))
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 67ad8ff95178..ce52fd9332e5 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2643,6 +2644,8 @@ xfs_read_agi(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 	if (error)
 		return error;
 	if (tp)
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
index 8a424fac2d27..906b0e2f68e2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -35,6 +35,7 @@
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -781,6 +782,8 @@ xfs_ialloc(
 	 */
 	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
 		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
 		return -EFSCORRUPTED;
 	}
 
@@ -2111,6 +2114,7 @@ xfs_iunlink_update_bucket(
 	 */
 	if (old_value == new_agino) {
 		xfs_buf_corruption_error(agibp);
+		xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2177,6 +2181,7 @@ xfs_iunlink_update_inode(
 	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -2191,6 +2196,7 @@ xfs_iunlink_update_inode(
 		if (next_agino != NULLAGINO) {
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			error = -EFSCORRUPTED;
 		}
 		goto out;
@@ -2245,6 +2251,7 @@ xfs_iunlink(
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
 		xfs_buf_corruption_error(agibp);
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2382,6 +2389,7 @@ xfs_iunlink_map_prev(
 			XFS_CORRUPTION_ERROR(__func__,
 					XFS_ERRLEVEL_LOW, mp,
 					*dipp, sizeof(**dipp));
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 			error = -EFSCORRUPTED;
 			return error;
 		}
@@ -2428,6 +2436,7 @@ xfs_iunlink_remove(
 	if (!xfs_verify_agino(mp, agno, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 

