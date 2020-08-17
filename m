Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21691C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F39452078B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RyAJh604"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgHQW7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:59:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52066 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgHQW7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:59:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvST9050069;
        Mon, 17 Aug 2020 22:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=p6osruwW8aIJF0KuLU/0ofB+J7yjZmtmF9VX6+cPvQI=;
 b=RyAJh604TgLF0cQyP0Dp75jhBTU53BAt6+NDm/zT7Exk6hK5Rb3hSBC8Mzj9Bf3VgFqZ
 YcNvuvG5QCm/NbVnxpkHES/PCZ1uFiGLM8CBRPoM6ZHjPxXnjyvSK2hdKWV7oikBZDrF
 DCmPGwt+FrZPz6Nl0UrJM9jSXFjoAOjd+YvCndGbwhZWmpeNpvEJidoDNXXc7GQenRhV
 Pk/cGXxewcohK6N/tRAqKTw1xqk1zEliJf6FZXKan2rqjURPQ/4dMX8yGXsvCawTfIuu
 QuUSdJpz/7AyHbDasIPpO1u2Kbq717IaXdGCnLZFcoa/YJckUQvDZQyfxGM67yyRKe7P hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nm9jqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:59:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMlhMQ075550;
        Mon, 17 Aug 2020 22:57:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32xsm18ks6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:57:08 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMv8N0013385;
        Mon, 17 Aug 2020 22:57:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:57:07 -0700
Subject: [PATCH 03/11] xfs: refactor default quota grace period setting code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Mon, 17 Aug 2020 15:57:07 -0700
Message-ID: <159770502702.3956827.5672717512043351449.stgit@magnolia>
In-Reply-To: <159770500809.3956827.8869892960975362931.stgit@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that sets the default quota grace period into a helper
function so that we can override the ondisk behavior later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   13 +++++++++++++
 fs/xfs/xfs_dquot.c         |    9 +++++++++
 fs/xfs/xfs_dquot.h         |    1 +
 fs/xfs/xfs_ondisk.h        |    2 ++
 fs/xfs/xfs_qm_syscalls.c   |    4 ++--
 5 files changed, 27 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ef36978239ac..e9e6248b35be 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1205,6 +1205,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
  * of zero means that the quota limit has not been reached, and therefore no
  * expiration has been set.
+ *
+ * The grace period for each quota type is stored in the root dquot (id = 0)
+ * and is applied to a non-root dquot when it exceeds the soft or hard limits.
+ * The length of quota grace periods are unsigned 32-bit quantities measured in
+ * units of seconds.  A value of zero means to use the default period.
  */
 
 /*
@@ -1219,6 +1224,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
 
+/*
+ * Default quota grace periods, ranging from zero (use the compiled defaults)
+ * to ~136 years.  These are applied to a non-root dquot that has exceeded
+ * either limit.
+ */
+#define XFS_DQ_GRACE_MIN	((int64_t)0)
+#define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 2425b1c30d11..ed3fa6ada0d3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -98,6 +98,15 @@ xfs_qm_adjust_dqlimits(
 		xfs_dquot_set_prealloc_limits(dq);
 }
 
+/* Set the length of the default grace period. */
+void
+xfs_dquot_set_grace_period(
+	time64_t		*timer,
+	time64_t		value)
+{
+	*timer = clamp_t(time64_t, value, XFS_DQ_GRACE_MIN, XFS_DQ_GRACE_MAX);
+}
+
 /* Set the expiration time of a quota's grace period. */
 void
 xfs_dquot_set_timeout(
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 11bd0ee9b0fa..0ba4d91c3a11 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -237,6 +237,7 @@ typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq,
 int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
 		xfs_qm_dqiterate_fn iter_fn, void *priv);
 
+void xfs_dquot_set_grace_period(time64_t *timer, time64_t limit);
 void xfs_dquot_set_timeout(time64_t *timer, time64_t limit);
 
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 38ccffcf3336..498e9063c605 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -27,6 +27,8 @@ xfs_check_limits(void)
 	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
 	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MIN,			1LL);
 	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
+	XFS_CHECK_VALUE(XFS_DQ_GRACE_MIN,			0LL);
+	XFS_CHECK_VALUE(XFS_DQ_GRACE_MAX,			4294967295LL);
 }
 
 static inline void __init
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index b16d533a6feb..95b0c25b9969 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -485,8 +485,8 @@ xfs_setqlim_timer(
 {
 	if (qlim) {
 		/* Set the length of the default grace period. */
-		res->timer = timer;
-		qlim->time = timer;
+		xfs_dquot_set_grace_period(&res->timer, timer);
+		qlim->time = res->timer;
 	} else {
 		/* Set the grace period expiration on a quota. */
 		xfs_dquot_set_timeout(&res->timer, timer);

