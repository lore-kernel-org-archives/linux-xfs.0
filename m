Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C431C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F4120825
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xPsxw9Dd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgHQW6b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:58:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgHQW62 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:58:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwRhc062519;
        Mon, 17 Aug 2020 22:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xzZepFg299dT7dIxEjMtBemndiHJOh2X+cXACEXNBQU=;
 b=xPsxw9Dd2wcJtJLppMpdXcdY3plYd16C6l2Mzkq/cKb9TmX5SxEqbTSFf3/E0DV2aiwB
 k1nxTyhOWicF7+AhbIh6ANRcnEp7+M/nJD3ebNeDD7ZvHoTsEbsalRo2QFBMvhWVt60H
 jZzrXDh1ofMZ/8ddP15Qejr34PhwZekSZVNJyjsXNwcPfR67MPZmAdjpltor8Gj7mLOu
 9feEwsUmz2cD5YvorfxcIj/nabVmqUdQTH2Fow9PgRuO4860CzZWr+SCk8KMyZoFntrt
 LfuKwcaXRv553/sGSdeMGNpADKedfcICZ4Wc3J5gePAJ7XNZp8zFTDa0XRmLrdWH7OXK 9A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nm9jp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:58:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMviIl113836;
        Mon, 17 Aug 2020 22:58:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32xsm18p25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:58:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMwPIx017619;
        Mon, 17 Aug 2020 22:58:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:58:25 -0700
Subject: [PATCH 3/7] xfs_db: add bigtime upgrade path
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:58:24 -0700
Message-ID: <159770510435.3958545.6606540263072605314.stgit@magnolia>
In-Reply-To: <159770508586.3958545.417872750558976156.stgit@magnolia>
References: <159770508586.3958545.417872750558976156.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable users to upgrade their filesystems to bigtime support.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/sb.c              |   73 +++++++++++++++++++++++++++++++++++++++++++++++++-
 db/xfs_admin.sh      |    4 ++-
 man/man8/xfs_admin.8 |   16 +++++++++++
 3 files changed, 91 insertions(+), 2 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index e3b1fe0b2e6e..33d9f7df49bb 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -620,6 +620,44 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
 	return 1;
 }
 
+/* Add new V5 features to the filesystem. */
+static bool
+add_v5_features(
+	struct xfs_mount	*mp,
+	uint32_t		compat,
+	uint32_t		ro_compat,
+	uint32_t		incompat,
+	uint32_t		log_incompat)
+{
+	struct xfs_sb		tsb;
+	xfs_agnumber_t		agno;
+
+	dbprintf(_("Upgrading V5 filesystem\n"));
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		if (!get_sb(agno, &tsb))
+			break;
+
+		tsb.sb_features_compat |= compat;
+		tsb.sb_features_ro_compat |= ro_compat;
+		tsb.sb_features_incompat |= incompat;
+		tsb.sb_features_log_incompat |= log_incompat;
+		libxfs_sb_to_disk(iocur_top->data, &tsb);
+		write_cur();
+	}
+
+	if (agno != mp->m_sb.sb_agcount) {
+		dbprintf(
+_("Failed to upgrade V5 filesystem AG %d\n"), agno);
+		return false;
+	}
+
+	mp->m_sb.sb_features_compat |= compat;
+	mp->m_sb.sb_features_ro_compat |= ro_compat;
+	mp->m_sb.sb_features_incompat |= incompat;
+	mp->m_sb.sb_features_log_incompat |= log_incompat;
+	return true;
+}
+
 static char *
 version_string(
 	xfs_sb_t	*sbp)
@@ -705,6 +743,10 @@ version_f(
 {
 	uint16_t	version = 0;
 	uint32_t	features = 0;
+	uint32_t	upgrade_compat = 0;
+	uint32_t	upgrade_ro_compat = 0;
+	uint32_t	upgrade_incompat = 0;
+	uint32_t	upgrade_log_incompat = 0;
 	xfs_agnumber_t	ag;
 
 	if (argc == 2) {	/* WRITE VERSION */
@@ -716,7 +758,25 @@ version_f(
 		}
 
 		/* Logic here derived from the IRIX xfs_chver(1M) script. */
-		if (!strcasecmp(argv[1], "extflg")) {
+		if (!strcasecmp(argv[1], "inobtcount")) {
+			if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature is already enabled\n"));
+				return 0;
+			}
+			if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature cannot be enabled on filesystems lacking free inode btrees\n"));
+				return 0;
+			}
+			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature cannot be enabled on pre-V5 filesystems\n"));
+				return 0;
+			}
+
+			upgrade_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
 				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
@@ -807,6 +867,17 @@ version_f(
 			mp->m_sb.sb_versionnum = version;
 			mp->m_sb.sb_features2 = features;
 		}
+
+		if (upgrade_compat || upgrade_ro_compat || upgrade_incompat ||
+		    upgrade_log_incompat) {
+			if (!add_v5_features(mp, upgrade_compat,
+					upgrade_ro_compat,
+					upgrade_incompat,
+					upgrade_log_incompat)) {
+				exitcode = 1;
+				return 1;
+			}
+		}
 	}
 
 	if (argc == 3) {	/* VERSIONNUM + FEATURES2 */
diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index bd325da2f776..0f0c8d18d6cb 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -9,7 +9,7 @@ DB_OPTS=""
 REPAIR_OPTS=""
 USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
 
-while getopts "efjlpuc:L:U:V" c
+while getopts "efjlpuc:L:O:U:V" c
 do
 	case $c in
 	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
@@ -19,6 +19,8 @@ do
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
+	O)	DB_OPTS=$DB_OPTS" -c 'version "$OPTARG"'";
+		REPAIR_OPTS="$REPAIR_OPTS ";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
 	V)	xfs_db -p xfs_admin -V
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 8afc873fb50a..65ca6afc1e12 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
 [
 .B \-eflpu
 ] [
+.BR \-O " feature"
+] [
 .BR "\-c 0" | 1
 ] [
 .B \-L
@@ -103,6 +105,20 @@ The filesystem label can be cleared using the special "\c
 " value for
 .IR label .
 .TP
+.BI \-O " feature"
+Add a new feature to the filesystem.
+Only one feature can be specified at a time.
+Features are as follows:
+.RS 0.7i
+.TP
+.B inobtcount
+Upgrade the filesystem to support the inode btree counters feature.
+This reduces mount time by caching the size of the inode btrees in the
+allocation group metadata.
+Once enabled, the filesystem will not be writable by older kernels.
+The filesystem cannot be downgraded after this feature is enabled.
+.RE
+.TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to
 .IR uuid .

