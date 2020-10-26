Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5689C55178
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9609520878
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TGUWSm49"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407161AbgJZXgd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55920 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407157AbgJZXgc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOXtJ164622;
        Mon, 26 Oct 2020 23:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eGZl6IsBHZwC4gxKqVYChM1np/iCuaavY5rYcrl56C0=;
 b=TGUWSm494f9EP9kJ+P9mcsPSHRjMikM8lgVVG1FkAYVbZAP3yzxeN+pIsJHJ3+VVOYzi
 i8NgZmsdL5yC3zrRd/xwpTlNTy8lg4zopRsQyecIam5CmbEMwjjci8nJpP4Q8keFKprL
 t810+tuMVsG/50KBPQeLbdgCjXKuV/98FUE+RqdeKsFwOO8HSW3I7qKL+V+QsytZZ7ds
 KPoe2OyG2xNqkLh0QHhKXeQAAdq1AZjc6dM/RM7wJiSqdwHHJfYFO2mO1kfZjtytoE/5
 4eQ5Qm6i/yskECfWRDtF0gK06UaNIRRTNCgyR4iBCWLhbENTPtHSje7KPy64amB+BTBC Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3vutu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxIl110453;
        Mon, 26 Oct 2020 23:36:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cx5wft1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:29 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNaT2D013262;
        Mon, 26 Oct 2020 23:36:29 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:29 -0700
Subject: [PATCH 22/26] xfs_db: add bigtime upgrade path
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:28 -0700
Message-ID: <160375538851.881414.17245799256703762517.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable users to upgrade their filesystems to bigtime support.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/sb.c              |   15 +++++++++++++++
 man/man8/xfs_admin.8 |    5 +++++
 2 files changed, 20 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index a04f36c73255..c77d7f038de2 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -781,6 +781,21 @@ version_f(
 			}
 
 			upgrade_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+		} else if (!strcasecmp(argv[1], "bigtime")) {
+			if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+				dbprintf(
+		_("bigtime feature is already enabled\n"));
+				exitcode = 1;
+				return 1;
+			}
+			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+				dbprintf(
+		_("bigtime feature cannot be enabled on pre-V5 filesystems\n"));
+				exitcode = 1;
+				return 1;
+			}
+
+			upgrade_incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
 		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 65ca6afc1e12..c09fe62b6827 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -117,6 +117,11 @@ This reduces mount time by caching the size of the inode btrees in the
 allocation group metadata.
 Once enabled, the filesystem will not be writable by older kernels.
 The filesystem cannot be downgraded after this feature is enabled.
+.TP
+.B bigtime
+Upgrade the filesystem to support larger timestamps up to the year 2486.
+Once enabled, the filesystem will not be readable by older kernels.
+The filesystem cannot be downgraded.
 .RE
 .TP
 .BI \-U " uuid"

