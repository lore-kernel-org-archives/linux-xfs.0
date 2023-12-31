Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2078779C4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZnkZKfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7B0C433C8;
	Sun, 31 Dec 2023 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056695;
	bh=KOYmVuvXzLfEgtS/pt6yydAKhZP+3PWCyyde7tTNOvw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TZnkZKfzzVIbFTVytez/ShQsE8hcTj3IsbX9+CYgzshUsxGH0bWkrODSfrmCJnB5w
	 NnkHCLIWbHROGEemp3bnVeE2t3GLyk52x2m0QB6MVd+rKKrUoE8laFe9xkImQYKu1h
	 SnqDiQHe+FuRMWDc+g68Iei53QbIjag7beUpgY2vadWcAcsvyJsxxX1RI974XI/YyZ
	 3AKVJFnONwf01HcPv0PmxkACimLI9EIh8XtxQUK51cy00CtoTFtdFm7IDyZP1OEUw6
	 l2gHUjpjNMTKE8A0aj+XGp6uc7+ibmwptFRMkq3SnaEI9Y3QXhyvg5MZ8pUJO9N7zC
	 lGbQ9vDdGEV7A==
Date: Sun, 31 Dec 2023 13:04:55 -0800
Subject: [PATCH 16/21] xfs: hoist inode free function to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844310.1759932.7287246598812974486.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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

Create a libxfs helper function that marks an inode free on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |   51 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    5 ++++
 fs/xfs/xfs_inode.c             |   35 +--------------------------
 3 files changed, 57 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 3de478eb5a83a..8f85c74603dba 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_iunlink_item.h"
+#include "xfs_inode_item.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -670,3 +671,53 @@ xfs_bumplink(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
+
+/* Mark an inode free on disk. */
+int
+xfs_dir_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
+	int			error;
+
+	/*
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
+	 */
+	error = xfs_difree(tp, pag, ip->i_ino, xic);
+	if (error)
+		return error;
+
+	error = xfs_iunlink_remove(tp, pag, ip);
+	if (error)
+		return error;
+
+	/*
+	 * Free any local-format data sitting around before we reset the
+	 * data fork to extents format.  Note that the attr fork data has
+	 * already been freed by xfs_attr_inactive.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		kmem_free(ip->i_df.if_u1.if_data);
+		ip->i_df.if_u1.if_data = NULL;
+		ip->i_df.if_bytes = 0;
+	}
+
+	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
+	ip->i_diflags = 0;
+	ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
+	ip->i_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+
+	/*
+	 * Bump the generation count so no one will be confused
+	 * by reincarnations of this inode.
+	 */
+	VFS_I(ip)->i_generation++;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index a2a1796a72ff3..521f044198c4a 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_INODE_UTIL_H__
 #define	__XFS_INODE_UTIL_H__
 
+struct xfs_icluster;
+
 uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
 uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
@@ -57,6 +59,9 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_dir_ifree(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip, struct xfs_icluster *xic);
+
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 70d13629071f5..11f7c2e78c8d9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1971,36 +1971,10 @@ xfs_ifree(
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
-	/*
-	 * Free the inode first so that we guarantee that the AGI lock is going
-	 * to be taken before we remove the inode from the unlinked list. This
-	 * makes the AGI lock -> unlinked list modification order the same as
-	 * used in O_TMPFILE creation.
-	 */
-	error = xfs_difree(tp, pag, ip->i_ino, &xic);
+	error = xfs_dir_ifree(tp, pag, ip, &xic);
 	if (error)
 		goto out;
 
-	error = xfs_iunlink_remove(tp, pag, ip);
-	if (error)
-		goto out;
-
-	/*
-	 * Free any local-format data sitting around before we reset the
-	 * data fork to extents format.  Note that the attr fork data has
-	 * already been freed by xfs_attr_inactive.
-	 */
-	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		kmem_free(ip->i_df.if_u1.if_data);
-		ip->i_df.if_u1.if_data = NULL;
-		ip->i_df.if_bytes = 0;
-	}
-
-	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
-	ip->i_diflags = 0;
-	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
-	ip->i_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 	if (xfs_iflags_test(ip, XFS_IPRESERVE_DM_FIELDS))
 		xfs_iflags_clear(ip, XFS_IPRESERVE_DM_FIELDS);
 
@@ -2009,13 +1983,6 @@ xfs_ifree(
 	iip->ili_fields &= ~(XFS_ILOG_AOWNER | XFS_ILOG_DOWNER);
 	spin_unlock(&iip->ili_lock);
 
-	/*
-	 * Bump the generation count so no one will be confused
-	 * by reincarnations of this inode.
-	 */
-	VFS_I(ip)->i_generation++;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
 	if (xic.deleted)
 		error = xfs_ifree_cluster(tp, pag, ip, &xic);
 out:

