Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACFEC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2223224BE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgLDBQR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:16:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49064 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLDBQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:16:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4192Ec014328;
        Fri, 4 Dec 2020 01:15:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=A/1OlJc7GQyU6jX5fIqyztqAarUqmHY9XK9N8+JkOvQ=;
 b=pZsZguwKcCGCtBecYpFD3YrUF+QbFRYAV+/cpdjj3XD0BW6IAd5JHJtdUxCuHQycQ87G
 4gf869fYab1i4Wkze8jHWCWnx0jTikrJ/EvrCjAqDdet8045NSBFNiHJxT+fMc0AuiOV
 Ah8/jvs1Ii/lhTD742HenmSHTDdm+O++JsclwqLY6CwW0GqOABNMkloz8QmASwBcGBzI
 2IkUk/iPlgC7vkS9VTBkC9I35ljNF2N/f1LgVGKnIgY+AwwjnVeyBZtbciaw+uGxAtfU
 zifBxWc5j7wTMDBu8RSzmQ1Tye4Svw0hk6X1CuZsJEUIuvrcgpvLFyPLic8sqds/7vpT Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egm0ysv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 01:15:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41BSQF157310;
        Fri, 4 Dec 2020 01:13:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540g2swuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 01:13:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B41DVHc025714;
        Fri, 4 Dec 2020 01:13:31 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:13:30 -0800
Date:   Thu, 3 Dec 2020 17:13:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/3] xfs_db: support the needsrepair feature flag in the
 version command
Message-ID: <20201204011330.GC629293@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679383892.447856.12907477074923729733.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach the xfs_db version command about the 'needsrepair' flag, which can
be used to force the system administrator to repair the filesystem with
xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c           |    5 ++
 db/sb.c              |  159 ++++++++++++++++++++++++++++++++++++++++++++++++--
 db/xfs_admin.sh      |    6 ++
 man/man8/xfs_admin.8 |   15 +++++
 man/man8/xfs_db.8    |    5 ++
 5 files changed, 182 insertions(+), 8 deletions(-)

diff --git a/db/check.c b/db/check.c
index 33736e33e833..485e855e8b78 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3970,6 +3970,11 @@ scan_ag(
 			dbprintf(_("mkfs not completed successfully\n"));
 		error++;
 	}
+	if (xfs_sb_version_needsrepair(sb)) {
+		if (!sflag)
+			dbprintf(_("filesystem needs xfs_repair\n"));
+		error++;
+	}
 	set_dbmap(agno, XFS_SB_BLOCK(mp), 1, DBM_SB, agno, XFS_SB_BLOCK(mp));
 	if (sb->sb_logstart && XFS_FSB_TO_AGNO(mp, sb->sb_logstart) == agno)
 		set_dbmap(agno, XFS_FSB_TO_AGBNO(mp, sb->sb_logstart),
diff --git a/db/sb.c b/db/sb.c
index d09f653dcedf..2c13d44d9954 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -379,6 +379,11 @@ uuid_f(
 				progname);
 			return 0;
 		}
+		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
+			dbprintf(_("%s: filesystem needs xfs_repair\n"),
+				progname);
+			return 0;
+		}
 
 		if (!strcasecmp(argv[1], "generate")) {
 			platform_uuid_generate(&uu);
@@ -501,6 +506,7 @@ do_label(xfs_agnumber_t agno, char *label)
 		memcpy(&lbl[0], &tsb.sb_fname, sizeof(tsb.sb_fname));
 		return &lbl[0];
 	}
+
 	/* set label */
 	if ((len = strlen(label)) > sizeof(tsb.sb_fname)) {
 		if (agno == 0)
@@ -543,6 +549,12 @@ label_f(
 			return 0;
 		}
 
+		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
+			dbprintf(_("%s: filesystem needs xfs_repair\n"),
+				progname);
+			return 0;
+		}
+
 		dbprintf(_("writing all SBs\n"));
 		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++)
 			if ((p = do_label(ag, argv[1])) == NULL) {
@@ -584,6 +596,7 @@ version_help(void)
 " 'version attr1'    - enable v1 inline extended attributes\n"
 " 'version attr2'    - enable v2 inline extended attributes\n"
 " 'version log2'     - enable v2 log format\n"
+" 'version needsrepair' - flag filesystem as requiring repair\n"
 "\n"
 "The version function prints currently enabled features for a filesystem\n"
 "according to the version field of its primary superblock.\n"
@@ -620,6 +633,118 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
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
+	/* Upgrade primary superblock. */
+	if (!get_sb(agno, &tsb))
+		goto fail;
+
+	dbprintf(_("Upgrading V5 filesystem\n"));
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
+	tsb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
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
+	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
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
@@ -691,15 +816,12 @@ version_string(
 		strcat(s, ",INOBTCNT");
 	if (xfs_sb_version_hasbigtime(sbp))
 		strcat(s, ",BIGTIME");
+	if (xfs_sb_version_needsrepair(sbp))
+		strcat(s, ",NEEDSREPAIR");
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
@@ -710,6 +832,9 @@ version_f(
 	xfs_agnumber_t	ag;
 
 	if (argc == 2) {	/* WRITE VERSION */
+		struct v5feat	v5features;
+
+		get_v5_features(mp, &v5features);
 
 		if ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode) {
 			dbprintf(_("%s: not in expert mode, writing disabled\n"),
@@ -717,8 +842,23 @@ version_f(
 			return 0;
 		}
 
+		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
+			dbprintf(_("%s: filesystem needs xfs_repair\n"),
+				progname);
+			return 0;
+		}
+
 		/* Logic here derived from the IRIX xfs_chver(1M) script. */
-		if (!strcasecmp(argv[1], "extflg")) {
+		if (!strcasecmp(argv[1], "needsrepair")) {
+			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+				dbprintf(
+		_("needsrepair flag cannot be enabled on pre-V5 filesystems\n"));
+				exitcode = 1;
+				return 1;
+			}
+
+			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
 				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
@@ -809,6 +949,11 @@ version_f(
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
index 8afc873fb50a..b423981d8049 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
 [
 .B \-eflpu
 ] [
+.BI \-O " feature"
+] [
 .BR "\-c 0" | 1
 ] [
 .B \-L
@@ -103,6 +105,19 @@ The filesystem label can be cleared using the special "\c
 " value for
 .IR label .
 .TP
+.BI \-O " feature"
+Add a new feature to the filesystem.
+Only one feature can be specified at a time.
+Features are as follows:
+.RS 0.7i
+.TP
+.B needsrepair
+If this is a V5 filesystem, flag the filesystem as needing repairs.
+Until
+.BR xfs_repair (8)
+is run, the filesystem will not be mountable.
+.RE
+.TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to
 .IR uuid .
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 587274957de3..7331cf196bb0 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -971,6 +971,11 @@ may toggle between
 and
 .B attr2
 at will (older kernels may not support the newer version).
+The filesystem can be flagged as requiring a run through
+.BR xfs_repair (8)
+if the
+.B needsrepair
+option is specified and the filesystem is formatted with the V5 format.
 .IP
 If no argument is given, the current version and feature bits are printed.
 With one argument, this command will write the updated version number
