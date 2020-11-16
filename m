Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44115C3E8C5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 21:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2BAE206B5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 21:16:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lvqb6F3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgKPVQA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:16:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48144 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgKPVQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 16:16:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AGLAiRN044062;
        Mon, 16 Nov 2020 21:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gihVicGSF4nn149aGq1SQCa8fFI8knOQKbARQcJCJHk=;
 b=lvqb6F3bUILjSRlAzLosD7YpxAHmIXcBXdIuf86WEHRqR6rfrUUI5ydhWwKyAa78E3uT
 U9esHKKaQ0jhrPRtcdidoEXA6P9s7iSGYW0epc/SgGKOWAGVZyMnITlyko6BTfBtiyYA
 ffOpJGiIkQIbUY4urXi4Sw//ChvHJuvK+l5uCObSJL1y/5LeYMml/MopSV11myOARJ46
 zaCcQzh/Fj5VqP8HuKx1G1T7Wz4XUHSEcXvLGKe7DSu27rKkyXuwuC7gjXIbf0s8B7Hh
 9ZjpGs1tBCeS5KrQONt2JtQd3PxVFQUxzjpcfdB0M1IBaeUgGcBUlXXdH9fkq6+wXnks bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4raqgnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Nov 2020 21:15:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AGLAThG110298;
        Mon, 16 Nov 2020 21:13:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34ts5v6mjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 21:13:54 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AGLDrV2004088;
        Mon, 16 Nov 2020 21:13:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 13:13:52 -0800
Date:   Mon, 16 Nov 2020 13:13:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 5/9] xfs_db: add inobtcnt upgrade path
Message-ID: <20201116211351.GT9695@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375521801.880355.2055596956122419535.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375521801.880355.2055596956122419535.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=7 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=7 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable users to upgrade their filesystems to support inode btree block
counters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: set inprogress to force repair (which xfs_admin immediately does),
clean up the code to pass around fewer arguments, and try to revert the
change if we hit io errors
---
 db/sb.c              |  149 ++++++++++++++++++++++++++++++++++++++++++++++++--
 db/xfs_admin.sh      |    6 ++
 man/man8/xfs_admin.8 |   16 +++++
 3 files changed, 163 insertions(+), 8 deletions(-)

diff --git a/db/sb.c b/db/sb.c
index e3b1fe0b2e6e..cfc2e32023fc 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -620,6 +620,117 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
 	return 1;
 }
 
+struct v5feat {
+	uint32_t		compat;
+	uint32_t		ro_compat;
+	uint32_t		incompat;
+	uint32_t		log_incompat;
+};
+
+static void
+get_v5_features(
+	struct xfs_mount	*mp,
+	struct v5feat		*feat)
+{
+	feat->compat = mp->m_sb.sb_features_compat;
+	feat->ro_compat = mp->m_sb.sb_features_ro_compat;
+	feat->incompat = mp->m_sb.sb_features_incompat;
+	feat->log_incompat = mp->m_sb.sb_features_log_incompat;
+}
+
+static bool
+set_v5_features(
+	struct xfs_mount	*mp,
+	const struct v5feat	*upgrade)
+{
+	struct xfs_sb		tsb;
+	struct v5feat		old;
+	xfs_agnumber_t		agno = 0;
+	xfs_agnumber_t		revert_agno = 0;
+
+	if (upgrade->compat == mp->m_sb.sb_features_compat &&
+	    upgrade->ro_compat == mp->m_sb.sb_features_ro_compat &&
+	    upgrade->incompat == mp->m_sb.sb_features_incompat &&
+	    upgrade->log_incompat == mp->m_sb.sb_features_log_incompat)
+		return true;
+
+	dbprintf(_("Upgrading V5 filesystem\n"));
+
+	/* Upgrade primary superblock. */
+	if (!get_sb(agno, &tsb))
+		goto fail;
+
+	/* Save old values */
+	old.compat = tsb.sb_features_compat;
+	old.ro_compat = tsb.sb_features_ro_compat;
+	old.incompat = tsb.sb_features_incompat;
+	old.log_incompat = tsb.sb_features_log_incompat;
+
+	/* Update feature flags and force user to run repair before mounting. */
+	tsb.sb_features_compat |= upgrade->compat;
+	tsb.sb_features_ro_compat |= upgrade->ro_compat;
+	tsb.sb_features_incompat |= upgrade->incompat;
+	tsb.sb_features_log_incompat |= upgrade->log_incompat;
+	tsb.sb_inprogress = 1;
+	libxfs_sb_to_disk(iocur_top->data, &tsb);
+
+	/* Write new primary superblock */
+	write_cur();
+	if (!iocur_top->bp || iocur_top->bp->b_error)
+		goto fail;
+
+	/* Update the secondary superblocks, or revert. */
+	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
+		if (!get_sb(agno, &tsb)) {
+			agno--;
+			goto revert;
+		}
+
+		/* Set features on secondary suepr. */
+		tsb.sb_features_compat |= upgrade->compat;
+		tsb.sb_features_ro_compat |= upgrade->ro_compat;
+		tsb.sb_features_incompat |= upgrade->incompat;
+		tsb.sb_features_log_incompat |= upgrade->log_incompat;
+		libxfs_sb_to_disk(iocur_top->data, &tsb);
+		write_cur();
+
+		/* Write or abort. */
+		if (!iocur_top->bp || iocur_top->bp->b_error)
+			goto revert;
+	}
+
+	/* All superblocks updated, update the incore values. */
+	mp->m_sb.sb_features_compat |= upgrade->compat;
+	mp->m_sb.sb_features_ro_compat |= upgrade->ro_compat;
+	mp->m_sb.sb_features_incompat |= upgrade->incompat;
+	mp->m_sb.sb_features_log_incompat |= upgrade->log_incompat;
+
+	dbprintf(_("Upgraded V5 filesystem.  Please run xfs_repair.\n"));
+	return true;
+
+revert:
+	/*
+	 * Try to revert feature flag changes, and don't worry if we fail.
+	 * We're probably in a mess anyhow, and the admin will have to run
+	 * repair anyways.
+	 */
+	for (revert_agno = 0; revert_agno <= agno; revert_agno++) {
+		if (!get_sb(revert_agno, &tsb))
+			continue;
+
+		tsb.sb_features_compat = old.compat;
+		tsb.sb_features_ro_compat = old.ro_compat;
+		tsb.sb_features_incompat = old.incompat;
+		tsb.sb_features_log_incompat = old.log_incompat;
+		libxfs_sb_to_disk(iocur_top->data, &tsb);
+		write_cur();
+	}
+fail:
+	dbprintf(
+_("Failed to upgrade V5 filesystem at AG %d, please run xfs_repair.\n"), agno);
+	return false;
+}
+
 static char *
 version_string(
 	xfs_sb_t	*sbp)
@@ -692,12 +803,7 @@ version_string(
 	return s;
 }
 
-/*
- * XXX: this only supports reading and writing to version 4 superblock fields.
- * V5 superblocks always define certain V4 feature bits - they are blocked from
- * being changed if a V5 sb is detected, but otherwise v5 superblock features
- * are not handled here.
- */
+/* Upgrade a superblock to support a feature. */
 static int
 version_f(
 	int		argc,
@@ -708,6 +814,9 @@ version_f(
 	xfs_agnumber_t	ag;
 
 	if (argc == 2) {	/* WRITE VERSION */
+		struct v5feat	v5features;
+
+		get_v5_features(mp, &v5features);
 
 		if ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode) {
 			dbprintf(_("%s: not in expert mode, writing disabled\n"),
@@ -716,7 +825,28 @@ version_f(
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
+			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
 				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
@@ -807,6 +937,11 @@ version_f(
 			mp->m_sb.sb_versionnum = version;
 			mp->m_sb.sb_features2 = features;
 		}
+
+		if (!set_v5_features(mp, &v5features)) {
+			exitcode = 1;
+			return 1;
+		}
 	}
 
 	if (argc == 3) {	/* VERSIONNUM + FEATURES2 */
diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index bd325da2f776..41a14d4521ba 100755
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
@@ -19,6 +19,9 @@ do
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
+	O)	DB_OPTS=$DB_OPTS" -c 'version "$OPTARG"'";
+		# Force repair to run by adding a single space to REPAIR_OPTS
+		REPAIR_OPTS="$REPAIR_OPTS ";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
 	V)	xfs_db -p xfs_admin -V
@@ -48,6 +51,7 @@ case $# in
 		fi
 		if [ -n "$REPAIR_OPTS" ]
 		then
+			echo "Running xfs_repair to ensure filesystem consistency."
 			# Hide normal repair output which is sent to stderr
 			# assuming the filesystem is fine when a user is
 			# running xfs_admin.
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
