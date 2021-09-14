Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437E1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217DE610CC
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhINCl1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhINClW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9526610F9;
        Tue, 14 Sep 2021 02:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587205;
        bh=u9y2wPlxu19w3/BqbAGhJbcAGeL2XisX9FfrLXI6Pkg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F9GtDCWDbpQd+DPnlxo3kafhdxmt0kWfHVwFZFIRTIFzHnoKGs2vZzs06BDoScdAa
         3+UoetPnPBkvnLnrmOxE8c2OGYjLW21s8e3jpsBVDWpikFhoKrTzSZ99unMwOOpgcp
         toBcIV1inpFQUmPL25UiGF586ac/I4f82HFaB3kIs5URMaMNPOzv7JxRJYyqJQ0am2
         ypFtpHSwND56DQILl5ETaL7eSjsawrRnmBlTy0/XluAqOp9iR59kLqv+QcgYzGs9Hy
         kHNd/UsI+FajqBD6taB1l/N/FIwcqfqDptJqbjhvvmxWfpGpMqajfH5dbaRaEfLrGF
         I9ZTarbuWziTw==
Subject: [PATCH 01/43] xfs_{copy,db,logprint,repair}: pass xfs_mount pointers
 instead of xfs_sb pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:40:05 -0700
Message-ID: <163158720548.1604118.4802855306324389235.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Where possible, convert these four programs to pass a pointer to a
struct xfs_mount instead of the struct xfs_sb inside the mount.  This
will make it easier to convert some of the code to the new
xfs_has_FEATURE predicates later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c     |   21 +++++++------
 db/sb.c             |   66 ++++++++++++++++++++--------------------
 libxfs/init.c       |   14 ++++-----
 logprint/logprint.c |    2 +
 repair/versions.c   |   84 +++++++++++++++++++++++++--------------------------
 repair/versions.h   |    4 +-
 repair/xfs_repair.c |    2 +
 7 files changed, 95 insertions(+), 98 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index fc7d225f..5c4f65b4 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -512,9 +512,9 @@ write_wbuf(void)
 
 static void
 sb_update_uuid(
-	xfs_sb_t	*sb,		/* Original fs superblock */
-	ag_header_t	*ag_hdr,	/* AG hdr to update for this copy */
-	thread_args	*tcarg)		/* Args for this thread, with UUID */
+	struct xfs_mount	*mp,
+	ag_header_t		*ag_hdr, /* AG hdr to update for this copy */
+	thread_args		*tcarg)	 /* Args for this thread, with UUID */
 {
 	/*
 	 * If this filesystem has CRCs, the original UUID is stamped into
@@ -523,24 +523,25 @@ sb_update_uuid(
 	 * we must copy the original sb_uuid to the sb_meta_uuid slot and set
 	 * the incompat flag for the feature on this copy.
 	 */
-	if (xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb) &&
-	    !uuid_equal(&tcarg->uuid, &sb->sb_uuid)) {
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !xfs_sb_version_hasmetauuid(&mp->m_sb) &&
+	    !uuid_equal(&tcarg->uuid, &mp->m_sb.sb_uuid)) {
 		uint32_t feat;
 
 		feat = be32_to_cpu(ag_hdr->xfs_sb->sb_features_incompat);
 		feat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
 		ag_hdr->xfs_sb->sb_features_incompat = cpu_to_be32(feat);
 		platform_uuid_copy(&ag_hdr->xfs_sb->sb_meta_uuid,
-				   &sb->sb_uuid);
+				   &mp->m_sb.sb_uuid);
 	}
 
 	/* Copy the (possibly new) fs-identifier UUID into sb_uuid */
 	platform_uuid_copy(&ag_hdr->xfs_sb->sb_uuid, &tcarg->uuid);
 
 	/* We may have changed the UUID, so update the superblock CRC */
-	if (xfs_sb_version_hascrc(sb))
-		xfs_update_cksum((char *)ag_hdr->xfs_sb, sb->sb_sectsize,
-							 XFS_SB_CRC_OFF);
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		xfs_update_cksum((char *)ag_hdr->xfs_sb, mp->m_sb.sb_sectsize,
+				XFS_SB_CRC_OFF);
 }
 
 int
@@ -1221,7 +1222,7 @@ main(int argc, char **argv)
 			/* do each thread in turn, each has its own UUID */
 
 			for (j = 0, tcarg = targ; j < num_targets; j++)  {
-				sb_update_uuid(sb, &ag_hdr, tcarg);
+				sb_update_uuid(mp, &ag_hdr, tcarg);
 				do_write(tcarg, NULL);
 				tcarg++;
 			}
diff --git a/db/sb.c b/db/sb.c
index cec7dce9..b4c14276 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -633,76 +633,76 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
 
 static char *
 version_string(
-	xfs_sb_t	*sbp)
+	struct xfs_mount	*mp)
 {
-	static char	s[1024];
+	static char		s[1024];
 
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_1)
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_1)
 		strcpy(s, "V1");
-	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_2)
+	else if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_2)
 		strcpy(s, "V2");
-	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_3)
+	else if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_3)
 		strcpy(s, "V3");
-	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+	else if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_4)
 		strcpy(s, "V4");
-	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+	else if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
 		strcpy(s, "V5");
 
 	/*
 	 * We assume the state of these features now, so macros don't exist for
 	 * them any more.
 	 */
-	if (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT)
+	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)
 		strcat(s, ",NLINK");
-	if (sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT)
+	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_SHAREDBIT)
 		strcat(s, ",SHARED");
-	if (sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT)
+	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT)
 		strcat(s, ",DIRV2");
 
-	if (xfs_sb_version_hasattr(sbp))
+	if (xfs_sb_version_hasattr(&mp->m_sb))
 		strcat(s, ",ATTR");
-	if (xfs_sb_version_hasquota(sbp))
+	if (xfs_sb_version_hasquota(&mp->m_sb))
 		strcat(s, ",QUOTA");
-	if (xfs_sb_version_hasalign(sbp))
+	if (xfs_sb_version_hasalign(&mp->m_sb))
 		strcat(s, ",ALIGN");
-	if (xfs_sb_version_hasdalign(sbp))
+	if (xfs_sb_version_hasdalign(&mp->m_sb))
 		strcat(s, ",DALIGN");
-	if (xfs_sb_version_haslogv2(sbp))
+	if (xfs_sb_version_haslogv2(&mp->m_sb))
 		strcat(s, ",LOGV2");
 	/* This feature is required now as well */
-	if (sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT)
+	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_EXTFLGBIT)
 		strcat(s, ",EXTFLG");
-	if (xfs_sb_version_hassector(sbp))
+	if (xfs_sb_version_hassector(&mp->m_sb))
 		strcat(s, ",SECTOR");
-	if (xfs_sb_version_hasasciici(sbp))
+	if (xfs_sb_version_hasasciici(&mp->m_sb))
 		strcat(s, ",ASCII_CI");
-	if (xfs_sb_version_hasmorebits(sbp))
+	if (xfs_sb_version_hasmorebits(&mp->m_sb))
 		strcat(s, ",MOREBITS");
-	if (xfs_sb_version_hasattr2(sbp))
+	if (xfs_sb_version_hasattr2(&mp->m_sb))
 		strcat(s, ",ATTR2");
-	if (xfs_sb_version_haslazysbcount(sbp))
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
 		strcat(s, ",LAZYSBCOUNT");
-	if (xfs_sb_version_hasprojid32bit(sbp))
+	if (xfs_sb_version_hasprojid32bit(&mp->m_sb))
 		strcat(s, ",PROJID32BIT");
-	if (xfs_sb_version_hascrc(sbp))
+	if (xfs_sb_version_hascrc(&mp->m_sb))
 		strcat(s, ",CRC");
-	if (xfs_sb_version_hasftype(sbp))
+	if (xfs_sb_version_hasftype(&mp->m_sb))
 		strcat(s, ",FTYPE");
-	if (xfs_sb_version_hasfinobt(sbp))
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
 		strcat(s, ",FINOBT");
-	if (xfs_sb_version_hassparseinodes(sbp))
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
 		strcat(s, ",SPARSE_INODES");
-	if (xfs_sb_version_hasmetauuid(sbp))
+	if (xfs_sb_version_hasmetauuid(&mp->m_sb))
 		strcat(s, ",META_UUID");
-	if (xfs_sb_version_hasrmapbt(sbp))
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		strcat(s, ",RMAPBT");
-	if (xfs_sb_version_hasreflink(sbp))
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		strcat(s, ",REFLINK");
-	if (xfs_sb_version_hasinobtcounts(sbp))
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
 		strcat(s, ",INOBTCNT");
-	if (xfs_sb_version_hasbigtime(sbp))
+	if (xfs_sb_version_hasbigtime(&mp->m_sb))
 		strcat(s, ",BIGTIME");
-	if (xfs_sb_version_needsrepair(sbp))
+	if (xfs_sb_version_needsrepair(&mp->m_sb))
 		strcat(s, ",NEEDSREPAIR");
 	return s;
 }
@@ -834,7 +834,7 @@ version_f(
 	}
 
 	dbprintf(_("versionnum [0x%x+0x%x] = %s\n"), mp->m_sb.sb_versionnum,
-			mp->m_sb.sb_features2, version_string(&mp->m_sb));
+			mp->m_sb.sb_features2, version_string(mp));
 
 	if (argc == 3) {	/* now reset... */
 		mp->m_sb.sb_versionnum = version;
diff --git a/libxfs/init.c b/libxfs/init.c
index c3e6a899..735c7851 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -421,22 +421,20 @@ rtmount_init(
 	int		flags)
 {
 	struct xfs_buf	*bp;	/* buffer for last block of subvolume */
-	struct xfs_sb	*sbp;	/* filesystem superblock copy in mount */
 	xfs_daddr_t	d;	/* address of last block of subvolume */
 	int		error;
 
-	sbp = &mp->m_sb;
-	if (sbp->sb_rblocks == 0)
+	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 
-	if (xfs_sb_version_hasreflink(sbp)) {
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 		fprintf(stderr,
 	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
 				progname);
 		return -1;
 	}
 
-	if (xfs_sb_version_hasrmapbt(sbp)) {
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
 		fprintf(stderr,
 	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
 				progname);
@@ -448,11 +446,11 @@ rtmount_init(
 			progname);
 		return -1;
 	}
-	mp->m_rsumlevels = sbp->sb_rextslog + 1;
+	mp->m_rsumlevels = mp->m_sb.sb_rextslog + 1;
 	mp->m_rsumsize =
 		(uint)sizeof(xfs_suminfo_t) * mp->m_rsumlevels *
-		sbp->sb_rbmblocks;
-	mp->m_rsumsize = roundup(mp->m_rsumsize, sbp->sb_blocksize);
+		mp->m_sb.sb_rbmblocks;
+	mp->m_rsumsize = roundup(mp->m_rsumsize, mp->m_sb.sb_blocksize);
 	mp->m_rbmip = mp->m_rsumip = NULL;
 
 	/*
diff --git a/logprint/logprint.c b/logprint/logprint.c
index e882c5d4..18adf102 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -85,7 +85,7 @@ logstat(xfs_mount_t *mp)
 		x.logBBsize = XFS_FSB_TO_BB(mp, sb->sb_logblocks);
 		x.logBBstart = XFS_FSB_TO_DADDR(mp, sb->sb_logstart);
 		x.lbsize = BBSIZE;
-		if (xfs_sb_version_hassector(sb))
+		if (xfs_sb_version_hassector(&mp->m_sb))
 			x.lbsize <<= (sb->sb_logsectlog - BBSHIFT);
 
 		if (!x.logname && sb->sb_logstart == 0) {
diff --git a/repair/versions.c b/repair/versions.c
index 4c44b4e7..7f268f61 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -30,21 +30,18 @@ int fs_has_extflgbit;
 xfs_extlen_t	fs_ino_alignment;
 
 void
-update_sb_version(xfs_mount_t *mp)
+update_sb_version(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sb;
+	if (fs_attributes && !xfs_sb_version_hasattr(&mp->m_sb))
+		xfs_sb_version_addattr(&mp->m_sb);
 
-	sb = &mp->m_sb;
-
-	if (fs_attributes && !xfs_sb_version_hasattr(sb))
-		xfs_sb_version_addattr(sb);
-
-	if (fs_attributes2 && !xfs_sb_version_hasattr2(sb))
-		xfs_sb_version_addattr2(sb);
+	if (fs_attributes2 && !xfs_sb_version_hasattr2(&mp->m_sb))
+		xfs_sb_version_addattr2(&mp->m_sb);
 
 	/* V2 inode conversion is now always going to happen */
-	if (!(sb->sb_versionnum & XFS_SB_VERSION_NLINKBIT))
-		sb->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
+	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT))
+		mp->m_sb.sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
 
 	/*
 	 * fix up the superblock version number and feature bits,
@@ -52,22 +49,22 @@ update_sb_version(xfs_mount_t *mp)
 	 * have quotas.
 	 */
 	if (fs_quotas)  {
-		if (!xfs_sb_version_hasquota(sb))
-			xfs_sb_version_addquota(sb);
+		if (!xfs_sb_version_hasquota(&mp->m_sb))
+			xfs_sb_version_addquota(&mp->m_sb);
 
 		/*
 		 * protect against stray bits in the quota flag field
 		 */
-		if (sb->sb_qflags & ~XFS_MOUNT_QUOTA_ALL) {
+		if (mp->m_sb.sb_qflags & ~XFS_MOUNT_QUOTA_ALL) {
 			/*
 			 * update the incore superblock, if we're in
 			 * no_modify mode, it'll never get flushed out
 			 * so this is ok.
 			 */
 			do_warn(_("bogus quota flags 0x%x set in superblock"),
-				sb->sb_qflags & ~XFS_MOUNT_QUOTA_ALL);
+				mp->m_sb.sb_qflags & ~XFS_MOUNT_QUOTA_ALL);
 
-			sb->sb_qflags &= XFS_MOUNT_QUOTA_ALL;
+			mp->m_sb.sb_qflags &= XFS_MOUNT_QUOTA_ALL;
 
 			if (!no_modify)
 				do_warn(_(", bogus flags will be cleared\n"));
@@ -75,16 +72,16 @@ update_sb_version(xfs_mount_t *mp)
 				do_warn(_(", bogus flags would be cleared\n"));
 		}
 	} else  {
-		sb->sb_qflags = 0;
+		mp->m_sb.sb_qflags = 0;
 
-		if (xfs_sb_version_hasquota(sb))  {
+		if (xfs_sb_version_hasquota(&mp->m_sb))  {
 			lost_quotas = 1;
-			sb->sb_versionnum &= ~XFS_SB_VERSION_QUOTABIT;
+			mp->m_sb.sb_versionnum &= ~XFS_SB_VERSION_QUOTABIT;
 		}
 	}
 
-	if (!fs_aligned_inodes && xfs_sb_version_hasalign(sb))
-		sb->sb_versionnum &= ~XFS_SB_VERSION_ALIGNBIT;
+	if (!fs_aligned_inodes && xfs_sb_version_hasalign(&mp->m_sb))
+		mp->m_sb.sb_versionnum &= ~XFS_SB_VERSION_ALIGNBIT;
 }
 
 /*
@@ -93,7 +90,8 @@ update_sb_version(xfs_mount_t *mp)
  * global variables.
  */
 int
-parse_sb_version(xfs_sb_t *sb)
+parse_sb_version(
+	struct xfs_mount	*mp)
 {
 	fs_attributes = 0;
 	fs_attributes2 = 0;
@@ -107,7 +105,7 @@ parse_sb_version(xfs_sb_t *sb)
 	have_gquotino = 0;
 	have_pquotino = 0;
 
-	if (sb->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) {
+	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_SHAREDBIT) {
 		do_warn(_("Shared Version bit set. Not supported. Ever.\n"));
 		return 1;
 	}
@@ -116,38 +114,38 @@ parse_sb_version(xfs_sb_t *sb)
 	 * ok, check to make sure that the sb isn't newer
 	 * than we are
 	 */
-	if (!xfs_sb_good_version(sb))  {
+	if (!xfs_sb_good_version(&mp->m_sb))  {
 		do_warn(_("WARNING:  unknown superblock version %d\n"),
-			XFS_SB_VERSION_NUM(sb));
+			XFS_SB_VERSION_NUM(&mp->m_sb));
 		do_warn(
 _("This filesystem contains features not understood by this program.\n"));
 		return(1);
 	}
 
-	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_4)
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) >= XFS_SB_VERSION_4)
 		fs_sb_feature_bits = 1;
 
 	/* Look for V5 feature flags we don't know about */
-	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5 &&
-	    (xfs_sb_has_compat_feature(sb, XFS_SB_FEAT_COMPAT_UNKNOWN) ||
-	     xfs_sb_has_ro_compat_feature(sb, XFS_SB_FEAT_RO_COMPAT_UNKNOWN) ||
-	     xfs_sb_has_incompat_feature(sb, XFS_SB_FEAT_INCOMPAT_UNKNOWN))) {
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) >= XFS_SB_VERSION_5 &&
+	    (xfs_sb_has_compat_feature(&mp->m_sb, XFS_SB_FEAT_COMPAT_UNKNOWN) ||
+	     xfs_sb_has_ro_compat_feature(&mp->m_sb, XFS_SB_FEAT_RO_COMPAT_UNKNOWN) ||
+	     xfs_sb_has_incompat_feature(&mp->m_sb, XFS_SB_FEAT_INCOMPAT_UNKNOWN))) {
 		do_warn(
 _("Superblock has unknown compat/rocompat/incompat features (0x%x/0x%x/0x%x).\n"
   "Using a more recent xfs_repair is recommended.\n"),
-			sb->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN,
-			sb->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_UNKNOWN,
-			sb->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_UNKNOWN);
+			mp->m_sb.sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN,
+			mp->m_sb.sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_UNKNOWN,
+			mp->m_sb.sb_features_incompat & XFS_SB_FEAT_INCOMPAT_UNKNOWN);
 		return 1;
 	}
 
-	if (xfs_sb_version_hasattr(sb))
+	if (xfs_sb_version_hasattr(&mp->m_sb))
 		fs_attributes = 1;
 
-	if (xfs_sb_version_hasattr2(sb))
+	if (xfs_sb_version_hasattr2(&mp->m_sb))
 		fs_attributes2 = 1;
 
-	if (!(sb->sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
+	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
 		if (!no_modify) {
 			do_warn(
 _("WARNING: you have a V1 inode filesystem. It will be converted to a\n"
@@ -161,28 +159,28 @@ _("WARNING: you have a V1 inode filesystem. It would be converted to a\n"
 		}
 	}
 
-	if (xfs_sb_version_hasquota(sb))  {
+	if (xfs_sb_version_hasquota(&mp->m_sb))  {
 		fs_quotas = 1;
 
-		if (sb->sb_uquotino != 0 && sb->sb_uquotino != NULLFSINO)
+		if (mp->m_sb.sb_uquotino != 0 && mp->m_sb.sb_uquotino != NULLFSINO)
 			have_uquotino = 1;
 
-		if (sb->sb_gquotino != 0 && sb->sb_gquotino != NULLFSINO)
+		if (mp->m_sb.sb_gquotino != 0 && mp->m_sb.sb_gquotino != NULLFSINO)
 			have_gquotino = 1;
 
-		if (sb->sb_pquotino != 0 && sb->sb_pquotino != NULLFSINO)
+		if (mp->m_sb.sb_pquotino != 0 && mp->m_sb.sb_pquotino != NULLFSINO)
 			have_pquotino = 1;
 	}
 
-	if (xfs_sb_version_hasalign(sb))  {
+	if (xfs_sb_version_hasalign(&mp->m_sb))  {
 		fs_aligned_inodes = 1;
-		fs_ino_alignment = sb->sb_inoalignmt;
+		fs_ino_alignment = mp->m_sb.sb_inoalignmt;
 	}
 
 	/*
 	 * calculate maximum file offset for this geometry
 	 */
-	fs_max_file_offset = 0x7fffffffffffffffLL >> sb->sb_blocklog;
+	fs_max_file_offset = 0x7fffffffffffffffLL >> mp->m_sb.sb_blocklog;
 
 	return(0);
 }
diff --git a/repair/versions.h b/repair/versions.h
index e1e2521c..c40a8681 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -34,11 +34,11 @@ extern xfs_extlen_t	fs_ino_alignment;
  * modify superblock to reflect current state of global fs
  * feature vars above
  */
-void			update_sb_version(xfs_mount_t *mp);
+void update_sb_version(struct xfs_mount *mp);
 
 /*
  * parse current sb to set above feature vars
  */
-int			parse_sb_version(xfs_sb_t *sb);
+int parse_sb_version(struct xfs_mount *mp);
 
 #endif /* _XR_VERSIONS_H */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 38406eea..7a142ceb 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1155,7 +1155,7 @@ main(int argc, char **argv)
 	/* initialize random globals now that we know the fs geometry */
 	inodes_per_block = mp->m_sb.sb_inopblock;
 
-	if (parse_sb_version(&mp->m_sb))  {
+	if (parse_sb_version(mp))  {
 		do_warn(
 	_("Found unsupported filesystem features.  Exiting now.\n"));
 		return(1);

