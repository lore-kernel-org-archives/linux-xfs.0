Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAD0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbiLaCVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbiLaCVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:21:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB9619C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17A4161C61
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ECFC433D2;
        Sat, 31 Dec 2022 02:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453289;
        bh=jI4QEsE/tOObNYQNcHhuNBz7xRc7CZnhsNsO6F8Gnts=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZCf1Yjhyd31g8GgtOiBJaJlRT18QdtPzXxp9tXzVQr/weTWVPVtL4oj45ESYoKekr
         F/ReHLN8sJYOXzXdP32cF2WaqNKfZCbC0FVp6jOhDiUBqwtneVby4NOMmGzfFLTNkB
         YnCyajFeacmKXyEQkyVSmscJEKeuNe4HDGr5NT1ccOG/Qd3pabapFDrXEreKIkzAj6
         WUPSM+xTYc33OkDzicQvFiPO8nZWpdmjUY2RsE3dlJ7XmqEKRb14dlX/HM/dTiHXYN
         kOpSNGsyJ0qZlmjZvk9bwWhknpPe7wAtTOsEHIjukuf5BFhOWDo2D3jwwGVJC+3iy5
         LjIo1fUTffuuQ==
Subject: [PATCH 45/46] mkfs.xfs: enable metadata directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:25 -0800
Message-ID: <167243876520.725900.4751980558366218829.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable formatting filesystems with metadata directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h    |    3 +-
 man/man8/mkfs.xfs.8.in |   11 ++++++++
 mkfs/lts_4.19.conf     |    1 +
 mkfs/lts_5.10.conf     |    1 +
 mkfs/lts_5.15.conf     |    1 +
 mkfs/proto.c           |   65 +++++++++++++++++++++++++++++++++++++++++++++++-
 mkfs/xfs_mkfs.c        |   24 +++++++++++++++++-
 7 files changed, 103 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 0bd915bd4ee..33b047f9cf0 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -396,7 +396,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 94f117b6917..8cdfe9a7ff1 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -271,6 +271,17 @@ option set.
 When the option
 .B \-m finobt=0
 is used, the inode btree counter feature is not supported and is disabled.
+.TP
+.BI metadir= value
+This option creates an internal directory tree to store filesystem metadata.
+.IP
+By default,
+.B mkfs.xfs
+will not enable this feature.
+If the option
+.B \-m crc=0
+is used, the metadata directory feature is not supported and is disabled.
+
 .TP
 .BI uuid= value
 Use the given value as the filesystem UUID for the newly created filesystem.
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index 751be45e519..20b35e5e13a 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -7,6 +7,7 @@ bigtime=0
 crc=1
 finobt=1
 inobtcount=0
+metadir=0
 reflink=0
 rmapbt=0
 
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index a1c991cec3c..606b3e0149a 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -7,6 +7,7 @@ bigtime=0
 crc=1
 finobt=1
 inobtcount=0
+metadir=0
 reflink=1
 rmapbt=0
 
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index d751f4c4667..571d6dd3e44 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -7,6 +7,7 @@ bigtime=1
 crc=1
 finobt=1
 inobtcount=1
+metadir=0
 reflink=1
 rmapbt=0
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6fb58bd7cd4..484b5deced8 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -17,6 +17,7 @@ static void fail(char *msg, int i);
 static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static char *newregfile(char **pp, int *len);
+static int metadir_create(struct xfs_mount *mp);
 static void rtinit(xfs_mount_t *mp);
 static long filesize(int fd);
 
@@ -637,8 +638,15 @@ parseproto(
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
 		 */
-		if (isroot)
+		if (isroot) {
+			error = metadir_create(mp);
+			if (error)
+				fail(
+	_("Creation of the metadata directory inode failed"),
+					error);
+
 			rtinit(mp);
+		}
 		tp = NULL;
 		for (;;) {
 			name = getstr(pp);
@@ -672,6 +680,61 @@ parse_proto(
 	parseproto(mp, NULL, fsx, pp, NULL);
 }
 
+/* Create a new metadata root directory. */
+static int
+metadir_create(
+	struct xfs_mount	*mp)
+{
+	struct xfs_imeta_update	upd;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	int			error;
+
+	if (!xfs_has_metadir(mp))
+		return 0;
+
+	/*
+	 * The root of the metadata directory tree must be the next inode
+	 * after the root directory.  Reset the AGI rotor to satisfy this
+	 * requirement.
+	 */
+	mp->m_agirotor = 0;
+
+	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_METADIR, &upd);
+	if (error)
+		return error;
+
+	/*
+	 * The metadata directory should always be the inode after the root
+	 * directory.  The chunk containing both of those inodes should already
+	 * exist, because we (re)create the root directory first.  So, no block
+	 * reservation is necessary.
+	 */
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		goto out_end;
+
+	error = -libxfs_imeta_create(&tp, &XFS_IMETA_METADIR, S_IFDIR, 0, &ip,
+			&upd);
+	if (error)
+		goto out_cancel;
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		goto out_end;
+
+	libxfs_imeta_end_update(mp, &upd, error);
+	mp->m_metadirip = ip;
+	return 0;
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+out_end:
+	libxfs_imeta_end_update(mp, &upd, error);
+	return error;
+}
+
 /* Create the realtime bitmap inode. */
 static void
 rtbitmap_create(
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bd730d6cb07..df8acf221ac 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -139,6 +139,7 @@ enum {
 	M_REFLINK,
 	M_INOBTCNT,
 	M_BIGTIME,
+	M_METADIR,
 	M_MAX_OPTS,
 };
 
@@ -762,6 +763,7 @@ static struct opt_params mopts = {
 		[M_REFLINK] = "reflink",
 		[M_INOBTCNT] = "inobtcount",
 		[M_BIGTIME] = "bigtime",
+		[M_METADIR] = "metadir",
 		[M_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -805,6 +807,12 @@ static struct opt_params mopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = M_METADIR,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -857,6 +865,7 @@ struct sb_feat_args {
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	inobtcnt;		/* XFS_SB_FEAT_RO_COMPAT_INOBTCNT */
 	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
+	bool	metadir;		/* XFS_SB_FEAT_INCOMPAT_METADIR */
 	bool	nodalign;
 	bool	nortalign;
 	bool	nrext64;
@@ -987,7 +996,7 @@ usage( void )
 /* blocksize */		[-b size=num]\n\
 /* config file */	[-c options=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
-			    inobtcount=0|1,bigtime=0|1]\n\
+			    inobtcount=0|1,bigtime=0|1,metadir=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num,concurrency=num]\n\
@@ -1810,6 +1819,9 @@ meta_opts_parser(
 	case M_BIGTIME:
 		cli->sb_feat.bigtime = getnum(value, opts, subopt);
 		break;
+	case M_METADIR:
+		cli->sb_feat.metadir = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2310,6 +2322,13 @@ _("64 bit extent count not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.nrext64 = false;
+
+		if (cli->sb_feat.metadir) {
+			fprintf(stderr,
+_("metadata directory not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.metadir = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3455,6 +3474,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
 	if (fp->bigtime)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
+	if (fp->metadir)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_METADIR;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
@@ -3903,6 +3924,7 @@ finish_superblock_setup(
 	platform_uuid_copy(&sbp->sb_meta_uuid, &cfg->uuid);
 	sbp->sb_logstart = cfg->logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
+	sbp->sb_metadirino = NULLFSINO;
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
 	sbp->sb_rbmblocks = cfg->rtbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;

