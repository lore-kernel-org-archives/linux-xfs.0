Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5573C43141
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7818F2071B
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qmvydj87"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfKNSWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:22:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48340 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfKNSWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 13:22:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEIJxMj073034
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=hoHewMf0nOFNBp8vRwVN6pJQdQl/SYIbCNsOtLuOY+E=;
 b=Qmvydj87OG/yNvuKhTSIiqUDTg+vk1zyi8M+XZ2TNIqnzSYQx2f9/m+QwYotTl2qKWgd
 rC5qblBvf9T+MTjQ+6Ojop8p2j7YDL878wyDrTJCbaGpaLjm/+zEt/1GDeD04noHtoQW
 459ostOQKyF3jaonHGI6Idhgne/KR0m1bPHxqzJPMzXR3gue7CtqU+bGt9KsAWrL1A0Y
 ujlH5syZrRwU4bPM4ZmH6le+/vv++My11kL/NlxBI2ihYp36weK5rX/ivnjDJSycX62g
 o8whN+vMN5tQnkAsR0N4aI0oSmSkWQL3Tqu3O9vLYRpF2SykBZZdXtLRiGAlA61Azai7 Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5p3r4wkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:22:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEI43QX027111
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w8v365mgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAEIK6Ke023402
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 10:20:05 -0800
Subject: [PATCH 8/9] xfs: report quota block corruption errors to the health
 system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Nov 2019 10:20:05 -0800
Message-ID: <157375560509.3692735.4663382867926594973.stgit@magnolia>
In-Reply-To: <157375555426.3692735.1357467392517392169.stgit@magnolia>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140156
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
index 1d97e897ebde..35f1d794f952 100644
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
index 0b0909657bad..ed6cc943db92 100644
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
-					   mp->m_sb.sb_pquotino != NULLFSINO))
+					   mp->m_sb.sb_pquotino != NULLFSINO)) {
+				xfs_quota_mark_sick(mp, XFS_DQ_PROJ);
 				return -EFSCORRUPTED;
+			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
 			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_pquotino;
 			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_gquotino != NULLFSINO))
+					   mp->m_sb.sb_gquotino != NULLFSINO)) {
+				xfs_quota_mark_sick(mp, XFS_DQ_GROUP);
 				return -EFSCORRUPTED;
+			}
 		}
 		if (ino != NULLFSINO) {
 			error = xfs_iget(mp, NULL, ino, 0, 0, ip);

