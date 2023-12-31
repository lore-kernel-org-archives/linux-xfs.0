Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B21BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rriZCs3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC591C433C7;
	Sun, 31 Dec 2023 21:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056961;
	bh=d9X+PrBYE8AfKCvLPbN/y588wMprB0AsvFMayyuwkAc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rriZCs3V+vQKJJOfz9sycwiURQbVlcgAOIJX12lEkWcJyRbOpIahBTqBnkFwc5ZBT
	 c9XkgjS/rjvgPOXsXLoSHsX+uXTWdimWdxsossLRIsKKbEauuCbDjkbRss1TTIZwE5
	 dZ9G/hPHUQM4Jupv8KCJdqhDQ7obMYmAgF+qbE0xlkfTneoaOKFjGgfx90Md80WYK0
	 bW5HEinp7sx/ifoviY+uuJhWKFLRaz6AIvkuthjzk+OEafuSN3Mgcn/1CZLexz9kRF
	 jv7nO6mj1GlaIUlVAq8xLoeMLeJWkZ1nKNeFWFnatPhJJo2vY81WGLjqg7N1CquxCy
	 2qpRz+4ZltcNA==
Date: Sun, 31 Dec 2023 13:09:21 -0800
Subject: [PATCH 12/32] xfs: allow deletion of metadata directory files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845058.1760491.4701180036795884150.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Make it possible to free metadata files once we've unlinked them from
the directory structure.  We don't do this in the kernel, at least not
yet, but don't leave a logic bomb for later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.c        |    2 +-
 fs/xfs/xfs_inode.h        |    3 +++
 3 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index bab82c3dde5de..38f79827b9354 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -23,6 +23,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_trans_space.h"
+#include "xfs_ag.h"
 
 /*
  * Metadata File Management
@@ -360,6 +361,38 @@ xfs_imeta_create(
 	return error;
 }
 
+/* Free a file from the metadata directory tree. */
+STATIC int
+xfs_imeta_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	struct xfs_icluster	xic = { 0 };
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(ip->i_df.if_nextents == 0);
+	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
+	ASSERT(ip->i_nblocks == 0);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	error = xfs_dir_ifree(tp, pag, ip, &xic);
+	if (error)
+		goto out;
+
+	/* Metadata files do not support ownership changes or DMAPI. */
+
+	if (xic.deleted)
+		error = xfs_ifree_cluster(tp, pag, ip, &xic);
+out:
+	xfs_perag_put(pag);
+	return error;
+}
+
 /*
  * Unlink a metadata inode @upd->ip from the metadata directory given by @path.
  * The path must already exist.
@@ -368,10 +401,24 @@ int
 xfs_imeta_unlink(
 	struct xfs_imeta_update		*upd)
 {
+	int				error;
+
 	ASSERT(xfs_imeta_path_check(upd->path));
 	ASSERT(xfs_imeta_verify(upd->mp, upd->ip->i_ino));
 
-	return xfs_imeta_sb_unlink(upd);
+	error = xfs_imeta_sb_unlink(upd);
+	if (error)
+		return error;
+
+	/*
+	 * Metadata files require explicit resource cleanup.  In other words,
+	 * the inactivation system will not touch these files, so we must free
+	 * the ondisk inode by ourselves if warranted.
+	 */
+	if (VFS_I(upd->ip)->i_nlink > 0)
+		return 0;
+
+	return xfs_imeta_ifree(upd->tp, upd->ip);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4699a9382f757..7f5ad390b6c7c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1807,7 +1807,7 @@ xfs_ifree_mark_inode_stale(
  * inodes that are in memory - they all must be marked stale and attached to
  * the cluster buffer.
  */
-static int
+int
 xfs_ifree_cluster(
 	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 10fbb3d4d193e..e967fa10721f9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -550,6 +550,9 @@ uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
 int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
+int		xfs_ifree_cluster(struct xfs_trans *tp, struct xfs_perag *pag,
+				struct xfs_inode *free_ip,
+				struct xfs_icluster *xic);
 int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);

