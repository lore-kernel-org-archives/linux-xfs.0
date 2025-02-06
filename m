Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C9A2417CD
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882607; cv=none; b=aNgwzzwu0N/93uId/wndxaxsqFNTHnh0OUCItln+lCjl3CDaS7wUQl8XSJrdYYtTKhCDOIrABFRSfewzGoh69VANE7y67h0Xhv1XXxzfmVDYR9hlemucTqC9tdrPnbS/EnDqJBYy/eUCz0OsB560uxOQSGADotAPVB6vT++T7V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882607; c=relaxed/simple;
	bh=T/uWJUxjIWqcuJEDzjPqfkI7nUy63Odqwek1TFIZX/E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C31tGha+MkzwE2JrNSt5GPQSQH+NInhC2bwp4bWVigPx28rDwQkFgJ3ddrweIFqZcjNzg66nwniMwBuzWKgFZsAIqbdZ9uJN4G3TewObmyEZ+dahrLttPOO/fBo/+fWNC5JtViJRq9jDUovNkpGAYYBKyrIR+XjqhdXunb5IHVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=so0Ubjte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="so0Ubjte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B00C4CEDF;
	Thu,  6 Feb 2025 22:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882606;
	bh=T/uWJUxjIWqcuJEDzjPqfkI7nUy63Odqwek1TFIZX/E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=so0Ubjtes7ydaeveHIutzpVmS4srFPCQmAF23xpgPV33xIoq/r6Ps9d8jIv8OhuNz
	 Rkpb80VMTssnvQCSxdTqOTV0+kcdbqkAa6PpATip7911jUFqUeaO42F0qn81jJ3ZVm
	 eWBXK/pcDqq6L4/A79Rn2nnZJsSXjyLk/wRB9laKfvaQ/qhhAgE31hdxKIf8yxCIJv
	 4V8kAhj/YW7X4EDoNZ0sbn/cVMNRMrpYj8oCU4ojJ8l5qa+rzCrq/QlJEwCY+scigP
	 mS5bo6CknG9elckQyIBg9fRpPiEwGGvqxaYL4zTo/YStMf1yJN1lOa8tKjX3KtZeq9
	 92kA7+6Dd67FQ==
Date: Thu, 06 Feb 2025 14:56:46 -0800
Subject: [PATCH 27/27] mkfs: create the realtime rmap inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088511.2741033.12591731083152285550.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a realtime rmapbt inode if we format the fs with realtime
and rmap.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/init.c            |    7 ----
 libxfs/libxfs_api_defs.h |    3 ++
 mkfs/proto.c             |   29 +++++++++++++++
 mkfs/xfs_mkfs.c          |   87 +++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 114 insertions(+), 12 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 02a4cfdf38b198..f92805620c33f1 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -312,13 +312,6 @@ rtmount_init(
 		return -1;
 	}
 
-	if (xfs_has_rmapbt(mp)) {
-		fprintf(stderr,
-	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
-				progname);
-		return -1;
-	}
-
 	if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 193b1eeaa7537e..df24f36f0d2874 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -224,6 +224,8 @@
 
 #define xfs_metafile_iget		libxfs_metafile_iget
 #define xfs_trans_metafile_iget		libxfs_trans_metafile_iget
+#define xfs_metafile_resv_free		libxfs_metafile_resv_free
+#define xfs_metafile_resv_init		libxfs_metafile_resv_init
 #define xfs_metafile_set_iflag		libxfs_metafile_set_iflag
 #define xfs_metadir_cancel		libxfs_metadir_cancel
 #define xfs_metadir_commit		libxfs_metadir_commit
@@ -324,6 +326,7 @@
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
+#define xfs_rtrmapbt_init_rtsb		libxfs_rtrmapbt_init_rtsb
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 #define xfs_rtrmapbt_mem_init		libxfs_rtrmapbt_mem_init
 #define xfs_rtrmapbt_mem_cursor		libxfs_rtrmapbt_mem_cursor
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 60e5c7d02713d0..2c453480271666 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1095,6 +1095,28 @@ rtinit_nogroups(
 	}
 }
 
+static int
+init_rtrmap_for_rtsb(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = -libxfs_trans_alloc_inode(rtg_rmap(rtg),
+			&M_RES(mp)->tr_itruncate, 0, 0, false, &tp);
+	if (error)
+		return error;
+
+	error = -libxfs_rtrmapbt_init_rtsb(mp, rtg, tp);
+	if (error) {
+		libxfs_trans_cancel(tp);
+		return error;
+	}
+
+	return -libxfs_trans_commit(tp);
+}
+
 static void
 rtinit_groups(
 	struct xfs_mount	*mp)
@@ -1115,6 +1137,13 @@ rtinit_groups(
 						error);
 		}
 
+		if (xfs_has_rtsb(mp) && xfs_has_rtrmapbt(mp) &&
+		    rtg_rgno(rtg) == 0) {
+			error = init_rtrmap_for_rtsb(rtg);
+			if (error)
+				fail(_("rtrmap rtsb init failed"), error);
+		}
+
 		rtfreesp_init(rtg);
 	}
 }
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f5556fcc4040ed..c8042261328171 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2678,12 +2678,18 @@ _("reflink not supported with realtime devices\n"));
 		}
 		cli->sb_feat.reflink = false;
 
-		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
-			fprintf(stderr,
-_("rmapbt not supported with realtime devices\n"));
-			usage();
+		if (!cli->sb_feat.metadir && cli->sb_feat.rmapbt) {
+			if (cli_opt_set(&mopts, M_RMAPBT) &&
+			    cli_opt_set(&mopts, M_METADIR)) {
+				fprintf(stderr,
+_("rmapbt not supported on realtime devices without metadir feature\n"));
+				usage();
+			} else if (cli_opt_set(&mopts, M_RMAPBT)) {
+				cli->sb_feat.metadir = true;
+			} else {
+				cli->sb_feat.rmapbt = false;
+			}
 		}
-		cli->sb_feat.rmapbt = false;
 	}
 
 	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
@@ -5006,6 +5012,74 @@ write_rtsb(
 	libxfs_buf_relse(sb_bp);
 }
 
+static inline void
+prealloc_fail(
+	struct xfs_mount	*mp,
+	int			error,
+	xfs_filblks_t		ask,
+	const char		*tag)
+{
+	if (error == ENOSPC)
+		fprintf(stderr,
+	_("%s: cannot handle expansion of %s; need %llu free blocks, have %llu\n"),
+				progname, tag, (unsigned long long)ask,
+				(unsigned long long)mp->m_sb.sb_fdblocks);
+	else
+		fprintf(stderr,
+	_("%s: error %d while checking free space for %s\n"),
+				progname, error, tag);
+	exit(1);
+}
+
+/*
+ * Make sure there's enough space on the data device to handle realtime
+ * metadata btree expansions.
+ */
+static void
+check_rt_meta_prealloc(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
+	xfs_filblks_t		ask;
+	int			error;
+
+	/*
+	 * First create all the per-AG reservations, since they take from the
+	 * free block count.  Each AG should start with enough free space for
+	 * the per-AG reservation.
+	 */
+	mp->m_finobt_nores = false;
+
+	while ((pag = xfs_perag_next(mp, pag))) {
+		error = -libxfs_ag_resv_init(pag, NULL);
+		if (error && error != ENOSPC) {
+			fprintf(stderr,
+	_("%s: error %d while checking AG free space for realtime metadata\n"),
+					progname, error);
+			exit(1);
+		}
+	}
+
+	/* Realtime metadata btree inode */
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		ask = libxfs_rtrmapbt_calc_reserves(mp);
+		error = -libxfs_metafile_resv_init(rtg_rmap(rtg), ask);
+		if (error)
+			prealloc_fail(mp, error, ask, _("realtime rmap btree"));
+	}
+
+	/* Unreserve the realtime metadata reservations. */
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		libxfs_metafile_resv_free(rtg_rmap(rtg));
+
+	/* Unreserve the per-AG reservations. */
+	while ((pag = xfs_perag_next(mp, pag)))
+		libxfs_ag_resv_free(pag);
+
+	mp->m_finobt_nores = false;
+}
+
 int
 main(
 	int			argc,
@@ -5343,6 +5417,9 @@ main(
 	 */
 	check_root_ino(mp);
 
+	/* Make sure we can handle space preallocations of rt metadata btrees */
+	check_rt_meta_prealloc(mp);
+
 	/*
 	 * Re-write multiple secondary superblocks with rootinode field set
 	 */

