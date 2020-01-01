Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA94C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 282F3206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nG8pWhQG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgAABMK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:12:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53450 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABMK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011A4ki089813
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mDXMBGbcOhcz180zYq4pVnljFJpWnDh7Uhwj5XPeQO8=;
 b=nG8pWhQGOnBBW1Rdzf8dqU7o29L2Jsxs6wh1ARRLHQjq9Rf4zNhbU3OYyx/iVGX1i2lF
 pUkzVA2KkHFAp67YOhSTsCAdS6M3CXJKfZ0b5VqgL7H8o+HCzDBcZ5r5tWiNI1XCCg0t
 /eashMi18guUGq6PZilO3k7QS9tv4NSnuBNA05yv03DXISCZEuJY5zzrF6GmbtYYTM2g
 vLoZFd9yg07fGQDg9K+FWKbH67Gh+mAqATzfnHElMvjnB1wizQKZNPgvOP6E4Q2wuOlj
 ANBrdlOqW345wcsblzbSJFHZk2nXdu4FuM+blWhVp1CunYsrr+iaLLeuCOQHjVbJ1Nge rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vU0190348
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrg086-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011A7GM031832
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:07 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:07 -0800
Subject: [PATCH 3/3] xfs: update health status if we get a clean bill of
 health
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:10:05 -0800
Message-ID: <157784100507.1362990.1400618050295392346.stgit@magnolia>
In-Reply-To: <157784098622.1362990.10967551303351018359.stgit@magnolia>
References: <157784098622.1362990.10967551303351018359.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If scrub finds that everything is ok with the filesystem, we need a way
to tell the health tracking that it can let go of indirect health flags,
since indirect flags only mean that at some point in the past we lost
some context.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    3 +-
 fs/xfs/scrub/health.c  |   71 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h  |    1 +
 fs/xfs/scrub/repair.c  |    1 +
 fs/xfs/scrub/scrub.c   |    6 ++++
 fs/xfs/scrub/trace.h   |    3 +-
 6 files changed, 83 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 0fcde7b2d89b..121c520189b9 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -682,9 +682,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
+#define XFS_SCRUB_TYPE_HEALTHY	25	/* everything checked out ok */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	25
+#define XFS_SCRUB_TYPE_NR	26
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index d6345e547422..a8d562753334 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -7,11 +7,14 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_btree.h"
 #include "xfs_sb.h"
 #include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/health.h"
+#include "scrub/common.h"
 
 /*
  * Scrub and In-Core Filesystem Health Assessments
@@ -113,6 +116,28 @@ xchk_health_mask_for_scrub_type(
 	return type_to_health_flag[scrub_type].sick_mask;
 }
 
+/*
+ * Scrub gave the filesystem a clean bill of health, so clear all the indirect
+ * markers of past problems (at least for the fs and ags) so that we can be
+ * healthy again.
+ */
+STATIC void
+xchk_mark_all_healthy(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
+	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
+	for (agno = 0; error == 0 && agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		xfs_ag_mark_healthy(pag, XFS_SICK_AG_INDIRECT);
+		xfs_perag_put(pag);
+	}
+}
+
 /*
  * Update filesystem health assessments based on what we found and did.
  *
@@ -130,6 +155,18 @@ xchk_update_health(
 	struct xfs_perag	*pag;
 	bool			bad;
 
+	/*
+	 * The HEALTHY scrub type is a request from userspace to clear all the
+	 * indirect flags after a clean scan of the entire filesystem.  As such
+	 * there's no sick flag defined for it, so we branch here ahead of the
+	 * mask check.
+	 */
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_HEALTHY &&
+	    !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
+		xchk_mark_all_healthy(sc->mp);
+		return;
+	}
+
 	if (!sc->sick_mask)
 		return;
 
@@ -252,3 +289,37 @@ xchk_ag_btree_healthy_enough(
 
 	return true;
 }
+
+/*
+ * Quick scan to double-check that there isn't any evidence of lingering
+ * primary health problems.  If we're still clear, then the health update will
+ * take care of clearing the indirect evidence.
+ */
+int
+xchk_health_record(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	unsigned int		sick;
+	unsigned int		checked;
+
+	xfs_fs_measure_sickness(mp, &sick, &checked);
+	if (sick & XFS_SICK_FS_PRIMARY)
+		xchk_set_corrupt(sc);
+
+	xfs_rt_measure_sickness(mp, &sick, &checked);
+	if (sick & XFS_SICK_RT_PRIMARY)
+		xchk_set_corrupt(sc);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		xfs_ag_measure_sickness(pag, &sick, &checked);
+		if (sick & XFS_SICK_AG_PRIMARY)
+			xchk_set_corrupt(sc);
+		xfs_perag_put(pag);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index d0b938d3d028..ee80b663cfab 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -10,5 +10,6 @@ unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
 void xchk_update_health(struct xfs_scrub *sc);
 bool xchk_ag_btree_healthy_enough(struct xfs_scrub *sc, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
+int xchk_health_record(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_HEALTH_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 2ee15fed7603..78e1355f3665 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -29,6 +29,7 @@
 #include "xfs_extfree_item.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 89df65c1dbab..ff0b9c8d3de7 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -343,6 +343,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_fscounters,
 		.repair	= xrep_notsupported,
 	},
+	[XFS_SCRUB_TYPE_HEALTHY] = {	/* fs healthy; clean all reminders */
+		.type	= ST_FS,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_health_record,
+		.repair = xrep_notsupported,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 7b208e36b8e9..01975c79aab0 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -77,7 +77,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
 	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
-	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }
+	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
+	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }
 
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,

