Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D3EC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855FC2076E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u47d7RVb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgHUCNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:13:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:13:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L26gde111186;
        Fri, 21 Aug 2020 02:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=G4RS3IXT4x725yhJh8Tk0A1VLh0+RQwwrfJbT/1hR5Y=;
 b=u47d7RVbyAzSjioAGKq9+83AXOcU4c42INg1/UrRjLDOY1imf/RqsSk67GJQpZcWlCwo
 v73M68Bf85hHsklTqJTJiVKzrM4dymbQf/KfR61Wx0kRhY29NcIoD/uk+IwV2CA7W++x
 Ke6rVjfhFLscm/yl4eOV43rAxqmEUtSaPYxNRgccBL8LKjvHgbSqUHsW2DSv6gyc5XaS
 Bm3NRL4ba0/OyVcAi+sDS3yn6ID/cGb/xn2trwAT5ajLgbvWfAi7jHBaexGRulUKerMS
 jpl63QvY61TlaF/r44dQevt7oFHi5eduafz6+a830eMRrWZ39wdsHzloSv4s2RMOonI1 jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74rkwdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:13:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L28LkG017929;
        Fri, 21 Aug 2020 02:11:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3325368aen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:11:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07L2BmTP011003;
        Fri, 21 Aug 2020 02:11:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:11:47 -0700
Subject: [PATCH 03/11] xfs: refactor default quota grace period setting code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:11:47 -0700
Message-ID: <159797590685.965217.9321446937142682044.stgit@magnolia>
In-Reply-To: <159797588727.965217.7260803484540460144.stgit@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that sets the default quota grace period into a helper
function so that we can override the ondisk behavior later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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

