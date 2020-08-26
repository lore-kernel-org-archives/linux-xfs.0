Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4273C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B96FD2087C
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZCgHLNhG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHZWFZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:05:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZWFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:05:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QLxnbK028198;
        Wed, 26 Aug 2020 22:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FJ+JncYf9c0+vD/COVhGq8o1y2yYZn+ey+OIUmdufKA=;
 b=ZCgHLNhGkH0X2xrjL9RD3o2568EEA+Y2W1iXvs5MJ6jhD645ayMwKrn2FWLCaZpPVgWP
 fLHRdpbO2TFQNRaKCof/CoZ1ZA0bsTpTDqvw5l4HPVemLcmOAPPi4Yc3RG5lmsQ2+qt7
 HTMXGXZWzJCoVbhY6sKeaxEEMhyFthMeaUA21OlaaBViNAaSR7tD9kf64+ZY+c/C8fa4
 HhiPGSCh+ybVEHMJIHovKT8SuJCHAF1PXLqTqsA4nLMF3L9UVPMIgd7zIPXLHl9BrdPS
 yjjrnkiDfJ4/AmU20jSW/byFMTFAGZ9XjsKP3dGoLnfI+n44N9R+dk2kD1jeW2NDRHod Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbs31jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 22:05:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM4irl015464;
        Wed, 26 Aug 2020 22:05:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 333ru0prfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 22:05:19 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07QM5Ix2001824;
        Wed, 26 Aug 2020 22:05:19 GMT
Received: from localhost (/10.159.146.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 15:05:18 -0700
Subject: [PATCH 03/11] xfs: refactor default quota grace period setting code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Wed, 26 Aug 2020 15:05:17 -0700
Message-ID: <159847951741.2601708.15806838224468188924.stgit@magnolia>
In-Reply-To: <159847949739.2601708.16579235017313836378.stgit@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260169
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
 fs/xfs/xfs_dquot.c         |    8 ++++++++
 fs/xfs/xfs_dquot.h         |    1 +
 fs/xfs/xfs_qm_syscalls.c   |    4 ++--
 4 files changed, 24 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cb316053d3db..4b68a473b090 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1209,6 +1209,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * been reached, and therefore no expiration has been set.  Therefore, the
  * ondisk min and max defined here can be used directly to constrain the incore
  * quota expiration timestamps on a Unix system.
+ *
+ * The grace period for each quota type is stored in the root dquot (id = 0)
+ * and is applied to a non-root dquot when it exceeds the soft or hard limits.
+ * The length of quota grace periods are unsigned 32-bit quantities measured in
+ * units of seconds.  A value of zero means to use the default period.
  */
 
 /*
@@ -1223,6 +1228,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
 
+/*
+ * Default quota grace periods, ranging from zero (use the compiled defaults)
+ * to ~136 years.  These are applied to a non-root dquot that has exceeded
+ * either limit.
+ */
+#define XFS_DQ_GRACE_MIN		((int64_t)0)
+#define XFS_DQ_GRACE_MAX		((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f34841f98d44..e63a933413a3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -110,6 +110,14 @@ xfs_dquot_set_timeout(
 					  qi->qi_expiry_max);
 }
 
+/* Set the length of the default grace period. */
+time64_t
+xfs_dquot_set_grace_period(
+	time64_t		grace)
+{
+	return clamp_t(time64_t, grace, XFS_DQ_GRACE_MIN, XFS_DQ_GRACE_MAX);
+}
+
 /*
  * Determine if this quota counter is over either limit and set the quota
  * timers as appropriate.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 0e449101c861..f642884a6834 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -238,5 +238,6 @@ int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
 		xfs_qm_dqiterate_fn iter_fn, void *priv);
 
 time64_t xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t timeout);
+time64_t xfs_dquot_set_grace_period(time64_t grace);
 
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 750f775ae915..ca1b57d291dc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -486,8 +486,8 @@ xfs_setqlim_timer(
 {
 	if (qlim) {
 		/* Set the length of the default grace period. */
-		res->timer = timer;
-		qlim->time = timer;
+		res->timer = xfs_dquot_set_grace_period(timer);
+		qlim->time = res->timer;
 	} else {
 		/* Set the grace period expiration on a quota. */
 		res->timer = xfs_dquot_set_timeout(mp, timer);

