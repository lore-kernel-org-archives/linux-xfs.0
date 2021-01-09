Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4963C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6808E23A63
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbhAIG3U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 01:29:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34694 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbhAIG3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 01:29:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096A61K043325;
        Sat, 9 Jan 2021 06:28:35 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35y3wqr9em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 06:28:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096AgKu048525;
        Sat, 9 Jan 2021 06:28:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35y3tgvvt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 06:28:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1096SXwN026262;
        Sat, 9 Jan 2021 06:28:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 22:28:33 -0800
Subject: [PATCH 2/2] xfs_db: add bigtime upgrade path
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Fri, 08 Jan 2021 22:28:31 -0800
Message-ID: <161017371145.1142690.12339616139751619892.stgit@magnolia>
In-Reply-To: <161017369911.1142690.8979186737828708317.stgit@magnolia>
References: <161017369911.1142690.8979186737828708317.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable users to upgrade their filesystems to bigtime support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/sb.c              |   16 ++++++++++++++++
 man/man8/xfs_admin.8 |    5 +++++
 man/man8/xfs_db.8    |    4 ++++
 3 files changed, 25 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index b89ccdbe..f6d1c857 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -598,6 +598,7 @@ version_help(void)
 " 'version log2'     - enable v2 log format\n"
 " 'version needsrepair' - flag filesystem as requiring repair\n"
 " 'version inobtcount' - enable inode btree counters\n"
+" 'version bigtime'  - enable timestamps beyond year 2038\n"
 "\n"
 "The version function prints currently enabled features for a filesystem\n"
 "according to the version field of its primary superblock.\n"
@@ -879,6 +880,21 @@ version_f(
 			}
 
 			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
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
+			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
 		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index a776b375..a5ef9f84 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -123,6 +123,11 @@ This reduces mount time by caching the size of the inode btrees in the
 allocation group metadata.
 Once enabled, the filesystem will not be writable by older kernels.
 The filesystem cannot be downgraded after this feature is enabled.
+.TP
+.B bigtime
+Upgrade a V5 filesystem to support larger timestamps up to the year 2486.
+Once enabled, the filesystem will not be readable by older kernels.
+The filesystem cannot be downgraded.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 1b826e5d..cd2ace12 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -979,6 +979,10 @@ option is specified and the filesystem is formatted with the V5 format.
 Support for the inode btree counters feature can be enabled by using the
 .B inobtcount
 option if the filesystem is formatted with the V5 format.
+Support for timestamps between the years 2038 and 2486 can be enabled by
+using the
+.B bigtime
+option if the filesystem is formatted with the V5 format.
 .IP
 If no argument is given, the current version and feature bits are printed.
 With one argument, this command will write the updated version number

