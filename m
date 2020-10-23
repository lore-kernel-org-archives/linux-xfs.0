Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAA5C56201
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171032223F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tYZgWM+U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375340AbgJWGep (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:34:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S375331AbgJWGep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:34:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6OM6o025453
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=lPIOi3FTw8IY8rMaQf7ePLmYBs3nEc47qK6iAp6zpCM=;
 b=tYZgWM+U1SlTMmTWH/DbOlhH9nuzSVFbgD7Nuc6TGPy5slg/+H13RhafRZBXl7zsOszb
 AunX+Zd+WKDLY2+z4Za/E5uDPmcFGS4gjFCPHgg07UGZOLXj6d5yXDKq5uIpdLs59AoL
 VuYCDBa0H90wUuQpQFo+NBicVheYAiZSRFiIaJdO2QyDClCv3mrX051Mysp+RW80wM2Y
 v9JZWt1cfx8UDDJs78YfDZ1XbMDUlJ5FAKzkfJx67CCPaVvx4M5sq0+C+rt4epK3YMmC
 ijljXRcOLiyHEZRO5P4lLd1IfVKaHUTyS4cNtX5/pf31w288gnlUrr5Zt0CoxkyfXCwD sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34ak16snmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6P5Lb178335
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 348aj0na7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:43 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09N6YgpK027987
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:43 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:34:42 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 07/10] xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
Date:   Thu, 22 Oct 2020 23:34:32 -0700
Message-Id: <20201023063435.7510-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023063435.7510-1-allison.henderson@oracle.com>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR which
can be used to control turning on/off delayed attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 8 ++++++--
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 2 ++
 fs/xfs/xfs_super.c         | 3 +++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d419c34..18b41a7 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -483,7 +483,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -586,7 +588,9 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
 {
-	return false;
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_log_incompat &
+		XFS_SB_FEAT_INCOMPAT_LOG_DELATTR));
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2a2e3cf..f703d95 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
+#define XFS_FSOP_GEOM_FLAGS_DELATTR	(1 << 22) /* delayed attributes	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa5..a0ec327 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1168,6 +1168,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
 	if (xfs_sb_version_hasbigtime(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
+	if (xfs_sb_version_hasdelattr(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_DELATTR;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d1b5f2d..bb85884 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1580,6 +1580,9 @@ xfs_fc_fill_super(
 	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
 		xfs_warn(mp,
  "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
+	if (xfs_sb_version_hasdelattr(&mp->m_sb))
+		xfs_alert(mp,
+	"EXPERIMENTAL delayed attrs feature enabled. Use at your own risk!");
 
 	error = xfs_mountfs(mp);
 	if (error)
-- 
2.7.4

