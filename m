Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6317EC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 302FF2087C
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UJpLc5o0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406419AbgJZXfo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43922 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407035AbgJZXfn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP91i177061;
        Mon, 26 Oct 2020 23:35:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YK+0EidTrv5tI5/lMwL41iatm0NDYdjM+gncL6lk8x0=;
 b=UJpLc5o0ufYVLM5cfDApC3rn2gi1cTuHCkgCi4OFKxNeKINK4yWGvJL9x1i46RyKqPUW
 g2FxCNuDQb3X1k2+lfRFxjFOSEt/bVfH4mibf0ELuULQ0Rhkx/VQJtmgAXfs/r+6PLTN
 LDCYYVvi5F9LJcKJeJziqjpnnL7oj328xN3pT6/al2YuOsiumLjiwjGkXrPJxXmGoiHo
 siHXtm+ElSw649tdE21rO9AY5Iw3JHBmZaG8b++e5Y98mGWezSzbkItOgLCdXMw/VaUO
 xRkrGGsOHkAEjIyDfnCOMOee/A/kmf3rgBblryuznJdLnLoU2D43N+HZfHCyPXOEns/6 Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saqd5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNJH058412;
        Mon, 26 Oct 2020 23:33:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwukr83q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:40 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNXdhC007137;
        Mon, 26 Oct 2020 23:33:39 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:38 -0700
Subject: [PATCH 5/9] xfs_db: add inobtcnt upgrade path
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:38 -0700
Message-ID: <160375521801.880355.2055596956122419535.stgit@magnolia>
In-Reply-To: <160375518573.880355.12052697509237086329.stgit@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable users to upgrade their filesystems to support inode btree block
counters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/sb.c              |   76 +++++++++++++++++++++++++++++++++++++++++++++++++-
 db/xfs_admin.sh      |    4 ++-
 man/man8/xfs_admin.8 |   16 +++++++++++
 3 files changed, 94 insertions(+), 2 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index e3b1fe0b2e6e..b1033e5ef7f0 100644
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
@@ -716,7 +758,28 @@ version_f(
 		}
 
 		/* Logic here derived from the IRIX xfs_chver(1M) script. */
-		if (!strcasecmp(argv[1], "extflg")) {
+		if (!strcasecmp(argv[1], "inobtcount")) {
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
+			upgrade_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
 				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
@@ -807,6 +870,17 @@ version_f(
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

