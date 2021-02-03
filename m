Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C63C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB34C64F95
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhBCToV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhBCToU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:44:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B581C64F8D;
        Wed,  3 Feb 2021 19:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381409;
        bh=hNEjSd/OoXWraCj89MpcDhFs/OAEuPkio/iRBPt7H8Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=phJ5bG/QnvrTDBPFy3mTX8s25oCSVCYcvLhFmqhV+/iaH0gYIGpTC6J8HsITbLVlq
         SCV2FC96Jw4Aaf/s808ZZdJT+VfLbzzWqil3ifz8VhjwHo3Y9l4Zi8iZadCvuQGyDP
         a739wOhXi8C64aXKCnj42jGEZj6mch9U6kYigsBziL2wdbQJpnvkabh8DyzzAXTsG5
         VwG0rTJ6n/W0dqjx0yZzW4Z0RC6ISmbS0im+0q8VH66A06OV0ytEqJIeTgdeD18wP/
         aFrRyLdCr7A/f7YsSOLtGSgTIXpJWSRbG9f1OEcI5gCcqJ1GKrexSCzaIyzn95G8Ms
         Xci1nFUYxZygQ==
Subject: [PATCH 3/5] xfs_db: support the needsrepair feature flag in the
 version command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 03 Feb 2021 11:43:29 -0800
Message-ID: <161238140924.1278306.7058193268638972167.stgit@magnolia>
In-Reply-To: <161238139177.1278306.5915396345874239435.stgit@magnolia>
References: <161238139177.1278306.5915396345874239435.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the xfs_db version command about the 'needsrepair' flag, which can
be used to force the system administrator to repair the filesystem with
xfs_repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c           |    5 ++
 db/sb.c              |  154 ++++++++++++++++++++++++++++++++++++++++++++++++--
 db/xfs_admin.sh      |   25 +++++++-
 man/man8/xfs_admin.8 |   30 ++++++++++
 man/man8/xfs_db.8    |    8 +++
 5 files changed, 213 insertions(+), 9 deletions(-)


diff --git a/db/check.c b/db/check.c
index 33736e33..485e855e 100644
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
index f306e939..223b84fe 100644
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
@@ -543,6 +548,12 @@ label_f(
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
@@ -584,6 +595,7 @@ version_help(void)
 " 'version attr1'    - enable v1 inline extended attributes\n"
 " 'version attr2'    - enable v2 inline extended attributes\n"
 " 'version log2'     - enable v2 log format\n"
+" 'version needsrepair' - flag filesystem as requiring repair\n"
 "\n"
 "The version function prints currently enabled features for a filesystem\n"
 "according to the version field of its primary superblock.\n"
@@ -623,6 +635,114 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
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
+	struct v5feat		*feat,
+	const struct xfs_sb	*sbp)
+{
+	feat->compat = sbp->sb_features_compat;
+	feat->ro_compat = sbp->sb_features_ro_compat;
+	feat->incompat = sbp->sb_features_incompat;
+	feat->log_incompat = sbp->sb_features_log_incompat;
+}
+
+static void
+set_v5_features(
+	struct xfs_sb		*sbp,
+	const struct v5feat	*feat)
+{
+	sbp->sb_features_compat = feat->compat;
+	sbp->sb_features_ro_compat = feat->ro_compat;
+	sbp->sb_features_incompat = feat->incompat;
+	sbp->sb_features_log_incompat = feat->log_incompat;
+}
+
+static bool
+upgrade_v5_features(
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
+	/* Save the old primary super features in case we revert. */
+	get_v5_features(&old, &tsb);
+
+	/* Update features and force user to run repair before mounting. */
+	set_v5_features(&tsb, upgrade);
+	tsb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
+	/* Write new primary superblock */
+	libxfs_sb_to_disk(iocur_top->data, &tsb);
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
+		/* Set features and write secondary super. */
+		set_v5_features(&tsb, upgrade);
+		tsb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		libxfs_sb_to_disk(iocur_top->data, &tsb);
+		write_cur();
+
+		/* Write or abort. */
+		if (!iocur_top->bp || iocur_top->bp->b_error)
+			goto revert;
+	}
+
+	/* All superblocks updated, update the incore values. */
+	set_v5_features(&mp->m_sb, upgrade);
+	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
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
+		set_v5_features(&tsb, &old);
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
@@ -694,15 +814,12 @@ version_string(
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
@@ -713,6 +830,9 @@ version_f(
 	xfs_agnumber_t	ag;
 
 	if (argc == 2) {	/* WRITE VERSION */
+		struct v5feat	v5features;
+
+		get_v5_features(&v5features, &mp->m_sb);
 
 		if ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode) {
 			dbprintf(_("%s: not in expert mode, writing disabled\n"),
@@ -720,8 +840,23 @@ version_f(
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
+				exitcode = 2;
+				return 1;
+			}
+
+			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
 				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
@@ -813,6 +948,11 @@ version_f(
 			mp->m_sb.sb_versionnum = version;
 			mp->m_sb.sb_features2 = features;
 		}
+
+		if (!upgrade_v5_features(mp, &v5features)) {
+			exitcode = 1;
+			return 1;
+		}
 	}
 
 	if (argc == 3) {	/* VERSIONNUM + FEATURES2 */
diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 5c57b461..f465bd43 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -6,10 +6,11 @@
 
 status=0
 DB_OPTS=""
+DASH_O_DB_OPTS=""
 REPAIR_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
+USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] [-O v5_feature] device [logdev]"
 
-while getopts "efjlpuc:L:U:V" c
+while getopts "efjlpuc:L:O:U:V" c
 do
 	case $c in
 	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
@@ -19,6 +20,13 @@ do
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
+	O)
+		if [ -n "$DASH_O_DB_OPTS" ]; then
+			echo "-O can only be specified once." 1>&2
+			exit 1
+		fi
+		DASH_O_DB_OPTS=" -c 'version "$OPTARG"'"
+		;;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
 	V)	xfs_db -p xfs_admin -V
@@ -30,6 +38,13 @@ do
 		;;
 	esac
 done
+if [ -n "$DASH_O_DB_OPTS" ]; then
+	if [ -n "$DB_OPTS" ]; then
+		echo "-O can only be used by itself." 1>&2
+		exit 1
+	fi
+	DB_OPTS="$DASH_O_DB_OPTS"
+fi
 set -- extra $@
 shift $OPTIND
 case $# in
@@ -48,6 +63,12 @@ case $# in
 		fi
 		if [ $status -eq 1 ]; then
 			echo "Conversion failed due to filesystem errors; run xfs_repair."
+		elif xfs_db -c 'version' "$1" | grep -q NEEDSREPAIR; then
+			# Upgrade required us to run repair, so force
+			# xfs_repair to run by adding a single space to
+			# REPAIR_OPTS.
+			echo "Running xfs_repair to complete the upgrade."
+			REPAIR_OPTS="$REPAIR_OPTS "
 		fi
 		if [ -n "$REPAIR_OPTS" ]
 		then
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 8afc873f..d8a0125c 100644
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
@@ -103,6 +105,34 @@ The filesystem label can be cleared using the special "\c
 " value for
 .IR label .
 .TP
+.BI \-O " feature"
+Add a new feature to a V5 filesystem.
+Only one filesystem feature can be specified per invocation of xfs_admin.
+This option cannot be combined with any other
+.B xfs_admin
+option.
+.IP
+.B NOTE:
+Administrators must ensure the filesystem is clean by running
+.B xfs_repair -n
+to inspect the filesystem before performing the upgrade.
+If corruption is found, recovery procedures (e.g. reformat followed by
+restoration from backup; or running
+.B xfs_repair
+without the
+.BR -n )
+must be followed to clean the filesystem.
+.IP
+Features are as follows:
+.RS 0.7i
+.TP
+.B needsrepair
+Flag the filesystem as needing repairs.
+Until
+.BR xfs_repair (8)
+is run, the filesystem will not be mountable.
+.RE
+.TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to
 .IR uuid .
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index ee57b03a..792d98c8 100644
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
@@ -983,6 +988,9 @@ bits respectively, and their string equivalent reported
 (but no modifications are made).
 .IP
 If the feature upgrade succeeds, the program will return 0.
+The upgrade process may set the NEEDSREPAIR feature in the superblock to
+force the filesystem to be run through
+.BR xfs_repair (8).
 If the requested upgrade has already been applied to the filesystem, the
 program will also return 0.
 If the upgrade fails due to corruption or IO errors, the program will return

