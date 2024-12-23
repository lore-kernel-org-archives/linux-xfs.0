Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FED1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991031; cv=none; b=lf8cumHL4Ndvp8b+QNmv9xeDgrWqHGO8TiT+Sb4mcNbwTTvIC0cHDtVXewEOTrhazpWicS3g4k1HYQJ5aLi24U6IlWu8+j5QERV8AoDsAefuyUHJdzP7TEbFUkHPR7XJbSSwv8HROFlRrh5mqEVDciCj2zqrJAEKlIS98ERBJBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991031; c=relaxed/simple;
	bh=P1hK+7zEA27qmyW0L/SVdBH1YcVaJat0QAt4SNKvzGI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VC5HrBF6d1DZwhJmm4yZ9ZyEGDBBaSXatIU7RC9zh3o7BW7Il/DiKSINrVKTctjJrrWaZ41A4RCe8BuZyStBcmHBESj2fkFYpvIprUDRwqY4xzLVcQEzrPflRv+sLfUb3/WY5vxm5jRGZ3tMEv5iSHlW06vMj7ci/VIopC83rdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J81eodG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J81eodG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C48BC4CED3;
	Mon, 23 Dec 2024 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991031;
	bh=P1hK+7zEA27qmyW0L/SVdBH1YcVaJat0QAt4SNKvzGI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J81eodG37S6qJnBNuQGsHS2p3HGactHWy60fK4YdnROPsJH9jNjFgw/8G2JKU2H+w
	 wQP1em6mkNt0d6PponNN+pP2o2ICy8keYdA3L8+lTmPWGxvl8tnY3Tb7HfDnZ3G3E7
	 F+IillCGWwSYBs9zCV3B4fRfo3xQBT1AgSPkAPISAbx7XzB2amLjRpxrNxwvdYvdPS
	 lBtS3t9YjCZNcQwx7NhsHWtT7D/PZZq7UZ6ecMjZdTuib4v4XBuEH5XS8lKQbhVcTu
	 9UvKKojcpY9bBqLs42qtfOntLKNjlDe5+aUGecuEC6AP5st8/V/DOgoLA34p15ccdT
	 Pf5+in1xMFSKw==
Date: Mon, 23 Dec 2024 13:57:10 -0800
Subject: [PATCH 41/41] mkfs.xfs: enable metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941597.2294268.604845279727850514.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    2 +
 man/man8/mkfs.xfs.8.in   |   11 +++++++
 mkfs/lts_4.19.conf       |    1 +
 mkfs/lts_5.10.conf       |    1 +
 mkfs/lts_5.15.conf       |    1 +
 mkfs/lts_5.4.conf        |    1 +
 mkfs/lts_6.1.conf        |    1 +
 mkfs/lts_6.12.conf       |    1 +
 mkfs/lts_6.6.conf        |    1 +
 mkfs/proto.c             |   68 +++++++++++++++++++++++++++++++++++++++++++++-
 mkfs/xfs_mkfs.c          |   33 +++++++++++++++++++++-
 11 files changed, 118 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e79aa0e06e4f90..2f218296688477 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -215,6 +215,8 @@
 #define xfs_metafile_iget		libxfs_metafile_iget
 #define xfs_trans_metafile_iget		libxfs_trans_metafile_iget
 #define xfs_metafile_set_iflag		libxfs_metafile_set_iflag
+#define xfs_metadir_cancel		libxfs_metadir_cancel
+#define xfs_metadir_commit		libxfs_metadir_commit
 #define xfs_metadir_link		libxfs_metadir_link
 #define xfs_metadir_lookup		libxfs_metadir_lookup
 #define xfs_metadir_start_create	libxfs_metadir_start_create
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index e56c8f31a52c78..de5f6baf59df95 100644
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
diff --git a/mkfs/lts_6.12.conf b/mkfs/lts_6.12.conf
index 35b79082495d24..b204b78511f666 100644
--- a/mkfs/lts_6.12.conf
+++ b/mkfs/lts_6.12.conf
@@ -6,6 +6,7 @@
 crc=1
 finobt=1
 inobtcount=1
+metadir=0
 reflink=1
 rmapbt=1
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
index bbd0dbb6c80ab6..4e51caead9dac2 100644
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
@@ -4279,6 +4304,8 @@ rewrite_secondary_superblocks(
 	}
 	dsb = buf->b_addr;
 	dsb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
+	if (xfs_has_metadir(mp))
+		dsb->sb_metadirino = cpu_to_be64(mp->m_sb.sb_metadirino);
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
@@ -4297,6 +4324,8 @@ rewrite_secondary_superblocks(
 	}
 	dsb = buf->b_addr;
 	dsb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
+	if (xfs_has_metadir(mp))
+		dsb->sb_metadirino = cpu_to_be64(mp->m_sb.sb_metadirino);
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 }

