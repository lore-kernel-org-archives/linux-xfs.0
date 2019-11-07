Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F66FC6194
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 695952187F
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d+xVFne9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733020AbfKGDEE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:04:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732304AbfKGDED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:04:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7342DR027622
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZGIsjIEV37cj8nUPVxlvTTvamFInGvqeSPgmxKCsx9E=;
 b=d+xVFne9Nzm0eucIid/K0gVKXeFGI3M7ImM3HaLv5AsUnoAwXnDnVfun0dUxyd/57+V0
 i0eVN2v89bxiT7MS8EPWL+PfS+K4emXWlKWv62QNj5lyO98YGzVnDzHqoTXzWn5ES+Lo
 RYkoVw1n/FFJJWN+KZIevU6QmYm98OJMsgy1g2uNuv0mBMwzkI7/pwBT7SG0IehzmS5u
 8AMFZIdyBWGWyjM/bbJVBRXjZEeKMjc7JpsV+IBZvmM2ZwGVhXcsb0uZ9P7H+rpR0rKO
 kS1svFtKsV+//G1YBGfNwO3aAIGozDnNyX+GjDiK+QCvurGjkqHz9XYs/RAvpRBojzwV IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w0u0qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:04:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA733rRs164292
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w41w8krg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:57 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA733tf3018277
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:03:55 -0800
Subject: [PATCH 08/10] xfs: report quota block corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:03:54 -0800
Message-ID: <157309583477.46704.14074516523692406974.stgit@magnolia>
In-Reply-To: <157309578380.46704.8292405543138526332.stgit@magnolia>
References: <157309578380.46704.8292405543138526332.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070032
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
 fs/xfs/xfs_qm.c            |    3 +++
 4 files changed, 25 insertions(+)


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
index 47318671013e..87ba581dac14 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -23,6 +23,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -757,6 +758,7 @@ xfs_qm_qino_alloc(
 			ino = mp->m_sb.sb_gquotino;
 			if (XFS_IS_CORRUPT(mp,
 			    mp->m_sb.sb_pquotino != NULLFSINO)) {
+				xfs_quota_mark_sick(mp, XFS_DQ_PROJ);
 				return -EFSCORRUPTED;
 			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
@@ -764,6 +766,7 @@ xfs_qm_qino_alloc(
 			ino = mp->m_sb.sb_pquotino;
 			if (XFS_IS_CORRUPT(mp,
 			    mp->m_sb.sb_gquotino != NULLFSINO)) {
+				xfs_quota_mark_sick(mp, XFS_DQ_GROUP);
 				return -EFSCORRUPTED;
 			}
 		}

