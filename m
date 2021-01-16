Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C7CC4332D
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E66823B04
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbhAPBZc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbhAPBZ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF23623A40;
        Sat, 16 Jan 2021 01:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760288;
        bh=lAWfVsJRpQZ/MXoRTbcIzRf7Rgy0oOzUWfNEXlTuQcs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oxn1WyQRkAUzBXlpmzfkKV2evuSpxY4Fa8wSOI5bN18+TKi1bV2ED6E2Z96oN4F7v
         uPrF6mS4X3LlmlEj3wrI8LRyyBTVFeby3LCjdUE+YA49PWH2IKSJbi5CCCFdxhv5K2
         bN9iGHQLemeUuctXuPMpGaA38xK1j69hhBx40CVIGd7La9rAnwi1j8Gtn7uPkzDngC
         ZM9LrEPzGbkmfyFB4DUFynbVDTHnUJqv76BxpSbE0sZy/NRjRAriDWtwQ+qRIsdiWP
         M92V98TXBkLeTtem7R8svaeDDiBttMg7IKzg/XJwRU9VYmsaTgYbxOr/XyEO3QLM6W
         pmR1q1Sc5u3fQ==
Subject: [PATCH 1/2] xfs_db: support the needsrepair feature flag in the
 version command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:24:47 -0800
Message-ID: <161076028723.3386490.10074737936252642930.stgit@magnolia>
In-Reply-To: <161076028124.3386490.8050189989277321393.stgit@magnolia>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
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
 db/sb.c              |  153 ++++++++++++++++++++++++++++++++++++++++++++++++--
 db/xfs_admin.sh      |   10 ++-
 man/man8/xfs_admin.8 |   15 +++++
 man/man8/xfs_db.8    |    5 ++
 5 files changed, 178 insertions(+), 10 deletions(-)


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
index d09f653d..fcc2a0ed 100644
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
@@ -620,6 +633,112 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
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
@@ -691,15 +810,12 @@ version_string(
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
@@ -710,6 +826,9 @@ version_f(
 	xfs_agnumber_t	ag;
 
 	if (argc == 2) {	/* WRITE VERSION */
+		struct v5feat	v5features;
+
+		get_v5_features(&v5features, &mp->m_sb);
 
 		if ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode) {
 			dbprintf(_("%s: not in expert mode, writing disabled\n"),
@@ -717,8 +836,23 @@ version_f(
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
@@ -809,6 +943,11 @@ version_f(
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
index bd325da2..0e79bbf9 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -7,9 +7,9 @@
 status=0
 DB_OPTS=""
 REPAIR_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
+USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] [-O v5_feature] device [logdev]"
 
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
@@ -34,6 +37,7 @@ set -- extra $@
 shift $OPTIND
 case $# in
 	1|2)
+		status=0
 		# Pick up the log device, if present
 		if [ -n "$2" ]; then
 			DB_OPTS=$DB_OPTS" -l '$2'"
@@ -46,7 +50,7 @@ case $# in
 			eval xfs_db -x -p xfs_admin $DB_OPTS $1
 			status=$?
 		fi
-		if [ -n "$REPAIR_OPTS" ]
+		if [ -n "$REPAIR_OPTS" ] && [ $status -ne 2 ]
 		then
 			# Hide normal repair output which is sent to stderr
 			# assuming the filesystem is fine when a user is
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 8afc873f..b423981d 100644
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
index 58727495..7331cf19 100644
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

