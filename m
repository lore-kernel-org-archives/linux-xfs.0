Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE68C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B5E2076E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FJaH1+4S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgHUCLs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:11:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCLr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:11:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L27Dod043451;
        Fri, 21 Aug 2020 02:11:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=q0eZn6ljrRRnRRwgY6wnSckiGqNH+BBScAwjfyV/cFU=;
 b=FJaH1+4SIDJhsKsVvHhj3qqxyiL8bgP+6QCWOMcFt+G+zu9c5wIU5ZqeRsK6gdQlz2jw
 nLMNjQRx5eJjBuZPITB4EdA9tBamziTQSJ7zFDG7YsjeX8+daWXz65O5pp1xiX+7yfqX
 g24+idQRPPILeA/c8b1cAzU7spmDAgB1s7nsVDQDuhq3g+b2RSFEzwWExdBZ30dYYCXf
 fYrKSZUqGVnXRsyBkr19aY3PsbInyaoUbbHG7DsvemoMyQIZh+QsQjkxfQ0plZ48LLHP
 7fDvo+ONkgDZzfL/WcJuKQmUDxkIIQBKll80lCbtI9H7NALpYD5pCjGsrlyHyyWyLOWz QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bnkr6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:11:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L294nV012379;
        Fri, 21 Aug 2020 02:11:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsn22ym3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:11:42 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07L2Bf7R019518;
        Fri, 21 Aug 2020 02:11:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:11:41 -0700
Subject: [PATCH 02/11] xfs: refactor quota expiration timer modification
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:11:40 -0700
Message-ID: <159797590052.965217.10856208107922013686.stgit@magnolia>
In-Reply-To: <159797588727.965217.7260803484540460144.stgit@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define explicit limits on the range of quota grace period expiration
timeouts and refactor the code that modifies the timeouts into helpers
that clamp the values appropriately.  Note that we'll deal with the
grace period timer separately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_format.h |   22 ++++++++++++++++++++++
 fs/xfs/xfs_dquot.c         |   13 ++++++++++++-
 fs/xfs/xfs_dquot.h         |    2 ++
 fs/xfs/xfs_ondisk.h        |    2 ++
 fs/xfs/xfs_qm_syscalls.c   |    9 +++++++--
 5 files changed, 45 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b1b8a5c05cea..ef36978239ac 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1197,6 +1197,28 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 #define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
 
+/*
+ * XFS Quota Timers
+ * ================
+ *
+ * Quota grace period expiration timers are an unsigned 32-bit seconds counter;
+ * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
+ * of zero means that the quota limit has not been reached, and therefore no
+ * expiration has been set.
+ */
+
+/*
+ * Smallest possible quota expiration with traditional timestamps, which is
+ * Jan  1 00:00:01 UTC 1970.
+ */
+#define XFS_DQ_TIMEOUT_MIN	((int64_t)1)
+
+/*
+ * Largest possible quota expiration with traditional timestamps, which is
+ * Feb  7 06:28:15 UTC 2106.
+ */
+#define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bcd73b9c2994..2425b1c30d11 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -98,6 +98,16 @@ xfs_qm_adjust_dqlimits(
 		xfs_dquot_set_prealloc_limits(dq);
 }
 
+/* Set the expiration time of a quota's grace period. */
+void
+xfs_dquot_set_timeout(
+	time64_t		*timer,
+	time64_t		value)
+{
+	*timer = clamp_t(time64_t, value, XFS_DQ_TIMEOUT_MIN,
+					  XFS_DQ_TIMEOUT_MAX);
+}
+
 /*
  * Determine if this quota counter is over either limit and set the quota
  * timers as appropriate.
@@ -112,7 +122,8 @@ xfs_qm_adjust_res_timer(
 	if ((res->softlimit && res->count > res->softlimit) ||
 	    (res->hardlimit && res->count > res->hardlimit)) {
 		if (res->timer == 0)
-			res->timer = ktime_get_real_seconds() + qlim->time;
+			xfs_dquot_set_timeout(&res->timer,
+					ktime_get_real_seconds() + qlim->time);
 	} else {
 		if (res->timer == 0)
 			res->warnings = 0;
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 282a65da93c7..11bd0ee9b0fa 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -237,4 +237,6 @@ typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq,
 int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
 		xfs_qm_dqiterate_fn iter_fn, void *priv);
 
+void xfs_dquot_set_timeout(time64_t *timer, time64_t limit);
+
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 48a64fa49f91..38ccffcf3336 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -25,6 +25,8 @@ xfs_check_limits(void)
 	/* make sure timestamp limits are correct */
 	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
 	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
+	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MIN,			1LL);
+	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
 }
 
 static inline void __init
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1c542b4a5220..b16d533a6feb 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -483,9 +483,14 @@ xfs_setqlim_timer(
 	struct xfs_quota_limits	*qlim,
 	s64			timer)
 {
-	res->timer = timer;
-	if (qlim)
+	if (qlim) {
+		/* Set the length of the default grace period. */
+		res->timer = timer;
 		qlim->time = timer;
+	} else {
+		/* Set the grace period expiration on a quota. */
+		xfs_dquot_set_timeout(&res->timer, timer);
+	}
 }
 
 /*

