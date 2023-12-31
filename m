Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE668C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z81CHwT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F785C433C8;
	Sun, 31 Dec 2023 23:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066267;
	bh=VhGAopvSxHO4gE/CE8g5BKgLRD+xPr6Tv54K1A/9E1s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z81CHwT68QrkHmpv9CieUxwNmJQ9DD55tF0PyjflHXoUratAplJeugjLzejWyebvq
	 w5nJiLXp97PhvRFd6tEzupmESVAvdN5FXYhB8NqYfffDuOUSWqMES+B/J2jot4zIGf
	 Gj2LUCtJNEanO87BjiqxuJf3XqqUqie697d90c6b2jbDqm1zqgUmQVk+jqGqm3+qjZ
	 emGvelV8u+D4A6xkroVLgL0S4T9jdZxTq0jzcnX/PcyA4Ul97Mgco3Jx+eCYrBiKOP
	 NZ+TCqmLj2oLIWtE2xa8fl8ji1rfQX8mhgQFcPFk/RZAb0vaL7wxZR2ElW+p5WVOCd
	 Nk93hLzzEaZ0g==
Date: Sun, 31 Dec 2023 15:44:26 -0800
Subject: [PATCH 57/58] mkfs.xfs: enable metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010707.1809361.800003234594178428.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_format.h    |    3 ++-
 man/man8/mkfs.xfs.8.in |   11 +++++++++++
 mkfs/lts_4.19.conf     |    1 +
 mkfs/lts_5.10.conf     |    1 +
 mkfs/lts_5.15.conf     |    1 +
 mkfs/proto.c           |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 mkfs/xfs_mkfs.c        |   24 +++++++++++++++++++++++-
 7 files changed, 83 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7596b928698..0636ca97622 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -398,7 +398,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
-		 XFS_SB_FEAT_INCOMPAT_PARENT)
+		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 8060d342c2a..587754ff95b 100644
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
index 8b2bdd7a347..6ed71c75347 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -6,6 +6,7 @@ bigtime=0
 crc=1
 finobt=1
 inobtcount=0
+metadir=0
 reflink=0
 rmapbt=0
 
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index 40189310af2..6eb25d7d4b2 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -6,6 +6,7 @@ bigtime=0
 crc=1
 finobt=1
 inobtcount=0
+metadir=0
 reflink=1
 rmapbt=0
 
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index aeecc035567..445719f6013 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -6,6 +6,7 @@ bigtime=1
 crc=1
 finobt=1
 inobtcount=1
+metadir=0
 reflink=1
 rmapbt=0
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0103fe54a5d..33d454cffb2 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -17,6 +17,7 @@ static void fail(char *msg, int i);
 static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static char *newregfile(char **pp, int *len);
+static int metadir_create(struct xfs_mount *mp);
 static void rtinit(xfs_mount_t *mp);
 static void rtfreesp_init(struct xfs_mount *mp);
 static long filesize(int fd);
@@ -705,8 +706,15 @@ parseproto(
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
 			name = getdirentname(pp);
@@ -744,6 +752,41 @@ parse_proto(
 	parseproto(mp, NULL, fsx, pp, NULL);
 }
 
+/* Create a new metadata root directory. */
+static int
+metadir_create(
+	struct xfs_mount	*mp)
+{
+	struct xfs_imeta_update	upd;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	if (!xfs_has_metadir(mp))
+		return 0;
+
+	error = -libxfs_imeta_start_create(mp, &XFS_IMETA_METADIR, &upd);
+	if (error)
+		return error;
+
+	error = -libxfs_imeta_create(&upd, S_IFDIR, &ip);
+	if (error)
+		goto out_cancel;
+
+	error = -libxfs_imeta_commit_update(&upd);
+	if (error)
+		goto out_rele;
+
+	mp->m_metadirip = ip;
+	return 0;
+
+out_cancel:
+	libxfs_imeta_cancel_update(&upd, error);
+out_rele:
+	if (ip)
+		libxfs_irele(ip);
+	return error;
+}
+
 /* Create the realtime bitmap inode. */
 static void
 rtbitmap_create(
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 15be7e0fb60..de4d1b25c26 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -147,6 +147,7 @@ enum {
 	M_REFLINK,
 	M_INOBTCNT,
 	M_BIGTIME,
+	M_METADIR,
 	M_MAX_OPTS,
 };
 
@@ -801,6 +802,7 @@ static struct opt_params mopts = {
 		[M_REFLINK] = "reflink",
 		[M_INOBTCNT] = "inobtcount",
 		[M_BIGTIME] = "bigtime",
+		[M_METADIR] = "metadir",
 		[M_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -844,6 +846,12 @@ static struct opt_params mopts = {
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
 
@@ -896,6 +904,7 @@ struct sb_feat_args {
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	inobtcnt;		/* XFS_SB_FEAT_RO_COMPAT_INOBTCNT */
 	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
+	bool	metadir;		/* XFS_SB_FEAT_INCOMPAT_METADIR */
 	bool	nodalign;
 	bool	nortalign;
 	bool	nrext64;
@@ -1028,7 +1037,7 @@ usage( void )
 /* blocksize */		[-b size=num]\n\
 /* config file */	[-c options=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
-			    inobtcount=0|1,bigtime=0|1]\n\
+			    inobtcount=0|1,bigtime=0|1,metadir=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num,concurrency=num]\n\
@@ -1845,6 +1854,9 @@ meta_opts_parser(
 	case M_BIGTIME:
 		cli->sb_feat.bigtime = getnum(value, opts, subopt);
 		break;
+	case M_METADIR:
+		cli->sb_feat.metadir = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2384,6 +2396,13 @@ _("64 bit extent count not supported without CRC support\n"));
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
@@ -3508,6 +3527,8 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_PARENT;
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	}
+	if (fp->metadir)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_METADIR;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
@@ -3957,6 +3978,7 @@ finish_superblock_setup(
 	platform_uuid_copy(&sbp->sb_meta_uuid, &cfg->uuid);
 	sbp->sb_logstart = cfg->logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
+	sbp->sb_metadirino = NULLFSINO;
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
 	sbp->sb_rbmblocks = cfg->rtbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;

