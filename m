Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E935C8C7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609828; cv=none; b=CjfplvcV9P+s8sHxD5tcndSBz2UyQn6FVzjn2smDsSu6oGSEfRQsfsyh/VFwB+DgYwES94MHBtlyyU4NPSxH40Krt4cjAC79jYczL0qstN6jdJStaMmF9vZGiqdohsF+jQuEirnQHCLXGQMskqRBk5KohjtrqlXbGCTqnw/N8JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609828; c=relaxed/simple;
	bh=J/YC+DqB/J1IJo9h8TGxElXs6z2gJ9b+3MLZMyAtTLI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kjbb/kPCl23jymJiwMTd7YjgPjfi1Az+wqOryhtj/Ft+HWi3nsQIJuQfYoasharefoJW4x85PDOc3DizlDriabOEv8y2c3Wr66IrQTPUCNjcr1BRPN+S+jQMJ6Qrv7jCC1V3MVADoG3YzAhyyU8DDkioX4nH5bRzrLf6+9XXA7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PcRBZqFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PcRBZqFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017A1C4CEC5;
	Fri, 11 Oct 2024 01:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609828;
	bh=J/YC+DqB/J1IJo9h8TGxElXs6z2gJ9b+3MLZMyAtTLI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PcRBZqFTWDNY0+q6dsXCcFRdoBg2VVduUCbNKdPjf2hhydXv0lEoHMVqo/zwiabZ5
	 x7tTq9SinWmK589OLjhoTVR3fClNrbB7UD9OwswLTNlJd5moEZZWe0YJqVDGrzx2Sc
	 xo74LcJ0j1yzdonrzizZ11OEx321QjTAVQ+/fpaK5//kLmNTIZAEJaE6MiSDT9dwlx
	 8AcOoFUBlzQGfat/YQexGwdaVmkTBVKscCLI/ciTr1LuiyLz3iJQacXyBJ+IcoEsZC
	 EqfArq+DOH0LysnKoz6xbePT7udOYwbWTB1QwHXT5OiGKBygJOgyogLeRBjTjXEvF5
	 SN42SSglkhFbA==
Date: Thu, 10 Oct 2024 18:23:47 -0700
Subject: [PATCH 37/38] mkfs.xfs: enable metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654544.4183231.9365433694511078.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enable formatting filesystems with metadata directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 man/man8/mkfs.xfs.8.in   |   11 +++++++
 mkfs/lts_4.19.conf       |    1 +
 mkfs/lts_5.10.conf       |    1 +
 mkfs/lts_5.15.conf       |    1 +
 mkfs/lts_5.4.conf        |    1 +
 mkfs/lts_6.1.conf        |    1 +
 mkfs/lts_6.6.conf        |    1 +
 mkfs/proto.c             |   68 +++++++++++++++++++++++++++++++++++++++++++++-
 mkfs/xfs_mkfs.c          |   29 ++++++++++++++++++--
 10 files changed, 113 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index beabb47fcd9c40..dd9ae59032eb22 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -216,6 +216,8 @@
 #define xfs_metafile_iget		libxfs_metafile_iget
 #define xfs_trans_metafile_iget		libxfs_trans_metafile_iget
 #define xfs_metafile_set_iflag		libxfs_metafile_set_iflag
+#define xfs_metadir_cancel		libxfs_metadir_cancel
+#define xfs_metadir_commit		libxfs_metadir_commit
 #define xfs_metadir_link		libxfs_metadir_link
 #define xfs_metadir_lookup		libxfs_metadir_lookup
 #define xfs_metadir_start_create	libxfs_metadir_start_create
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index a854b0e87cb1a2..a76c6a9ee695b3 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -271,6 +271,17 @@ .SH OPTIONS
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
index 4f190bacf9780c..4aa12f429ca2dd 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -6,6 +6,7 @@
 crc=1
 finobt=1
 inobtcount=0
+metadir=0
 reflink=0
 rmapbt=0
 autofsck=0
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index a55fc68e4e3f2f..9625135c011f08 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -6,6 +6,7 @@
 crc=1
 finobt=1
 inobtcount=0
+metadir=0
 reflink=1
 rmapbt=0
 autofsck=0
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index daea0b40671936..5306fad7e02f0f 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -6,6 +6,7 @@
 crc=1
 finobt=1
 inobtcount=1
+metadir=0
 reflink=1
 rmapbt=0
 autofsck=0
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index 0f807fc35e34b4..9114388b0248a5 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -6,6 +6,7 @@
 crc=1
 finobt=1
 inobtcount=0
+metadir=0
 reflink=1
 rmapbt=0
 autofsck=0
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
index 0ff5bbad5a1c2d..1d5378042eed6c 100644
--- a/mkfs/lts_6.1.conf
+++ b/mkfs/lts_6.1.conf
@@ -6,6 +6,7 @@
 crc=1
 finobt=1
 inobtcount=1
+metadir=0
 reflink=1
 rmapbt=0
 autofsck=0
diff --git a/mkfs/lts_6.6.conf b/mkfs/lts_6.6.conf
index 2ef5957e0b3a3f..d2649c562fac12 100644
--- a/mkfs/lts_6.6.conf
+++ b/mkfs/lts_6.6.conf
@@ -6,6 +6,7 @@
 crc=1
 finobt=1
 inobtcount=1
+metadir=0
 reflink=1
 rmapbt=1
 autofsck=0
diff --git a/mkfs/proto.c b/mkfs/proto.c
index d8eb6ca33672bd..05c2621f8a0b13 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -471,6 +471,65 @@ creatproto(
 	return 0;
 }
 
+/* Create a new metadata root directory. */
+static int
+create_metadir(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip = NULL;
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_icreate_args	args = {
+		.mode		= S_IFDIR,
+		.flags		= XFS_ICREATE_UNLINKABLE,
+	};
+	xfs_ino_t		ino;
+
+	if (!xfs_has_metadir(mp))
+		return 0;
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create,
+			libxfs_create_space_res(mp, MAXNAMELEN), 0, 0, &tp);
+	if (error)
+		return error;
+
+	/*
+	 * Create a new inode and set the sb pointer.  The primary super is
+	 * still marked inprogress, so we do not need to log the metadirino
+	 * change ourselves.
+	 */
+	error = -libxfs_dialloc(&tp, &args, &ino);
+	if (error)
+		goto out_cancel;
+	error = -libxfs_icreate(tp, ino, &args, &ip);
+	if (error)
+		goto out_cancel;
+	mp->m_sb.sb_metadirino = ino;
+
+	/*
+	 * Initialize the root directory.  There are no ILOCKs in userspace
+	 * so we do not need to drop it here.
+	 */
+	libxfs_metafile_set_iflag(tp, ip, XFS_METAFILE_DIR);
+	error = -libxfs_dir_init(tp, ip, ip);
+	if (error)
+		goto out_cancel;
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		goto out_rele;
+
+	mp->m_metadirip = ip;
+	return 0;
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+out_rele:
+	if (ip)
+		libxfs_irele(ip);
+	return error;
+}
+
 static void
 parseproto(
 	xfs_mount_t	*mp,
@@ -709,8 +768,15 @@ parseproto(
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
 		 */
-		if (isroot)
+		if (isroot) {
+			error = create_metadir(mp);
+			if (error)
+				fail(
+	_("Creation of the metadata directory inode failed"),
+					error);
+
 			rtinit(mp);
+		}
 		tp = NULL;
 		for (;;) {
 			name = getdirentname(pp);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bbd0dbb6c80ab6..aa8b189a9ac0df 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -150,6 +150,7 @@ enum {
 	M_INOBTCNT,
 	M_BIGTIME,
 	M_AUTOFSCK,
+	M_METADIR,
 	M_MAX_OPTS,
 };
 
@@ -812,6 +813,7 @@ static struct opt_params mopts = {
 		[M_INOBTCNT] = "inobtcount",
 		[M_BIGTIME] = "bigtime",
 		[M_AUTOFSCK] = "autofsck",
+		[M_METADIR] = "metadir",
 		[M_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -861,6 +863,12 @@ static struct opt_params mopts = {
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
 
@@ -913,6 +921,7 @@ struct sb_feat_args {
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	inobtcnt;		/* XFS_SB_FEAT_RO_COMPAT_INOBTCNT */
 	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
+	bool	metadir;		/* XFS_SB_FEAT_INCOMPAT_METADIR */
 	bool	nodalign;
 	bool	nortalign;
 	bool	nrext64;
@@ -1048,7 +1057,8 @@ usage( void )
 /* blocksize */		[-b size=num]\n\
 /* config file */	[-c options=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
-			    inobtcount=0|1,bigtime=0|1,autofsck=xxx]\n\
+			    inobtcount=0|1,bigtime=0|1,autofsck=xxx,\n\
+			    metadir=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num,concurrency=num]\n\
@@ -1883,6 +1893,9 @@ meta_opts_parser(
 				illegal(value, "m autofsck");
 		}
 		break;
+	case M_METADIR:
+		cli->sb_feat.metadir = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2465,6 +2478,14 @@ _("autofsck not supported without CRC support\n"));
 			usage();
 		}
 		cli->autofsck = FSPROP_AUTOFSCK_UNSET;
+
+		if (cli->sb_feat.metadir &&
+		    cli_opt_set(&mopts, M_METADIR)) {
+			fprintf(stderr,
+_("metadata directory not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.metadir = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3568,7 +3589,8 @@ sb_set_features(
 	 * the sb_bad_features2 field. To avoid older kernels mounting
 	 * filesystems they shouldn't, set both field to the same value.
 	 */
-	sbp->sb_bad_features2 = sbp->sb_features2;
+	if (!fp->metadir)
+		sbp->sb_bad_features2 = sbp->sb_features2;
 
 	if (!fp->crcs_enabled)
 		return;
@@ -3618,6 +3640,8 @@ sb_set_features(
 		 */
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	}
+	if (fp->metadir)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_METADIR;
 }
 
 /*
@@ -4053,6 +4077,7 @@ finish_superblock_setup(
 	platform_uuid_copy(&sbp->sb_meta_uuid, &cfg->uuid);
 	sbp->sb_logstart = cfg->logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
+	sbp->sb_metadirino = NULLFSINO;
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
 	sbp->sb_rbmblocks = cfg->rtbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;

