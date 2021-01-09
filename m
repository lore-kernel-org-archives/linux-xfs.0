Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188F1C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D707C23A69
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbhAIGbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 01:31:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57962 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbhAIGbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 01:31:10 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10968v2E039445;
        Sat, 9 Jan 2021 06:30:28 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35y20ageb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 06:30:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096BXPa011435;
        Sat, 9 Jan 2021 06:28:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35y1ksuc9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 06:28:27 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1096SQcG025158;
        Sat, 9 Jan 2021 06:28:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Jan 2021 06:28:26 +0000
Subject: [PATCH 1/2] xfs_db: add inobtcnt upgrade path
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 08 Jan 2021 22:28:25 -0800
Message-ID: <161017370529.1142690.11100691491331155224.stgit@magnolia>
In-Reply-To: <161017369911.1142690.8979186737828708317.stgit@magnolia>
References: <161017369911.1142690.8979186737828708317.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable users to upgrade their filesystems to support inode btree block
counters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c              |   22 ++++++++++++++++++++++
 man/man8/xfs_admin.8 |    7 +++++++
 man/man8/xfs_db.8    |    3 +++
 3 files changed, 32 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index 93e4c405..b89ccdbe 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -597,6 +597,7 @@ version_help(void)
 " 'version attr2'    - enable v2 inline extended attributes\n"
 " 'version log2'     - enable v2 log format\n"
 " 'version needsrepair' - flag filesystem as requiring repair\n"
+" 'version inobtcount' - enable inode btree counters\n"
 "\n"
 "The version function prints currently enabled features for a filesystem\n"
 "according to the version field of its primary superblock.\n"
@@ -857,6 +858,27 @@ version_f(
 			}
 
 			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		} else if (!strcasecmp(argv[1], "inobtcount")) {
+			if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature is already enabled\n"));
+				exitcode = 1;
+				return 1;
+			}
+			if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature cannot be enabled on filesystems lacking free inode btrees\n"));
+				exitcode = 1;
+				return 1;
+			}
+			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature cannot be enabled on pre-V5 filesystems\n"));
+				exitcode = 1;
+				return 1;
+			}
+
+			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
 		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index b423981d..a776b375 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -116,6 +116,13 @@ If this is a V5 filesystem, flag the filesystem as needing repairs.
 Until
 .BR xfs_repair (8)
 is run, the filesystem will not be mountable.
+.TP
+.B inobtcount
+Upgrade a V5 filesystem to support the inode btree counters feature.
+This reduces mount time by caching the size of the inode btrees in the
+allocation group metadata.
+Once enabled, the filesystem will not be writable by older kernels.
+The filesystem cannot be downgraded after this feature is enabled.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 7331cf19..1b826e5d 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -976,6 +976,9 @@ The filesystem can be flagged as requiring a run through
 if the
 .B needsrepair
 option is specified and the filesystem is formatted with the V5 format.
+Support for the inode btree counters feature can be enabled by using the
+.B inobtcount
+option if the filesystem is formatted with the V5 format.
 .IP
 If no argument is given, the current version and feature bits are printed.
 With one argument, this command will write the updated version number

