Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD59FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 958EB2087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CDOcUSDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfKHHGV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:06:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfKHHGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:06:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873png070580
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=8ngniUKeV9GYp934fm5V5NtIT2yBXLsU64U8TMg8UJY=;
 b=CDOcUSDg+Vv+b+VwLYkBDoUR/V9DUbuFZTwoTo0cfNBij1bgbhdEK1rj6DnQZ9ZXOihC
 Nm+bcBaOkRHZAPhJppjN0QV875Uj5Za2po4azxeD8wluVVCoWP4fgCGYLmvOWfo9LDKb
 9KNXHP7sAsiEl/+ez5eL/Z6O43GEJwwsoCGmJJvzYwappJOS+/uBgJCn0kdxwBvHX0sJ
 dVWdrZaN2x08epDixxX3xZjdYFGrU3HFWlKcH//L/AbYc7cbEgvc/RFrUX7v1iZlMmij
 aBIjS9wX482G+06K8vOXyCqbTYURl8+MxgmRi0bdM4xF7rXmCG23s6CLt6yzuuFmxznH nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w1bda5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:06:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873ne6081334
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:06:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w50m4c7xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:06:19 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA876I1P014523
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:06:18 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:06:18 -0800
Subject: [PATCH 08/10] xfs: report quota block corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 07 Nov 2019 23:06:17 -0800
Message-ID: <157319677748.834783.6070110333112068379.stgit@magnolia>
In-Reply-To: <157319672612.834783.1318671695966912922.stgit@magnolia>
References: <157319672612.834783.1318671695966912922.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt quota blocks, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_health.h |    1 +
 fs/xfs/xfs_dquot.c         |    6 ++++++
 fs/xfs/xfs_health.c        |   15 +++++++++++++++
 fs/xfs/xfs_qm.c            |    9 +++++++--
 4 files changed, 29 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index d9404cd3d09b..69e7d97ed480 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -144,6 +144,7 @@ void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork);
 void xfs_da_mark_sick(struct xfs_da_args *args);
+void xfs_quota_mark_sick(struct xfs_mount *mp, uint dq_flags);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bcd4247b5014..cfaab8771f7b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -23,6 +23,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_health.h"
 
 /*
  * Lock order:
@@ -419,6 +420,8 @@ xfs_dquot_disk_read(
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
 			mp->m_quotainfo->qi_dqchunklen, 0, &bp,
 			&xfs_dquot_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_quota_mark_sick(mp, dqp->dq_flags);
 	if (error) {
 		ASSERT(bp == NULL);
 		return error;
@@ -1107,6 +1110,8 @@ xfs_qm_dqflush(
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
 				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
 				   &xfs_dquot_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_quota_mark_sick(mp, dqp->dq_flags);
 	if (error)
 		goto out_unlock;
 
@@ -1126,6 +1131,7 @@ xfs_qm_dqflush(
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		xfs_quota_mark_sick(mp, dqp->dq_flags);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index c1b6e8fb72ec..2d3da765722e 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -17,6 +17,7 @@
 #include "xfs_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_quota_defs.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -556,3 +557,17 @@ xfs_da_mark_sick(
 {
 	xfs_dirattr_mark_sick(args->dp, args->whichfork);
 }
+
+/* Record observations of quota corruption with the health tracking system. */
+void
+xfs_quota_mark_sick(
+	struct xfs_mount	*mp,
+	uint			dq_flags)
+{
+	if (dq_flags & XFS_DQ_USER)
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_UQUOTA);
+	if (dq_flags & XFS_DQ_GROUP)
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_GQUOTA);
+	if (dq_flags & XFS_DQ_PROJ)
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_PQUOTA);
+}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3d8a08d02649..87ba581dac14 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -23,6 +23,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -756,14 +757,18 @@ xfs_qm_qino_alloc(
 			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_gquotino;
 			if (XFS_IS_CORRUPT(mp,
-			    mp->m_sb.sb_pquotino != NULLFSINO))
+			    mp->m_sb.sb_pquotino != NULLFSINO)) {
+				xfs_quota_mark_sick(mp, XFS_DQ_PROJ);
 				return -EFSCORRUPTED;
+			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
 			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_pquotino;
 			if (XFS_IS_CORRUPT(mp,
-			    mp->m_sb.sb_gquotino != NULLFSINO))
+			    mp->m_sb.sb_gquotino != NULLFSINO)) {
+				xfs_quota_mark_sick(mp, XFS_DQ_GROUP);
 				return -EFSCORRUPTED;
+			}
 		}
 		if (ino != NULLFSINO) {
 			error = xfs_iget(mp, NULL, ino, 0, 0, ip);

