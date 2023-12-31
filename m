Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19890BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvZEbARf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC6FC433C8;
	Sun, 31 Dec 2023 20:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055835;
	bh=kgyEQeowIu4fQNWGEhwbQUlgF6ABeqrslfLtIcgBODs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kvZEbARfwhLPMt03+6AObfg4Q/HrqGJBTy7jJ4ukubRVY5fj5hvAjnp7v2MDiO+bv
	 rxLz2lU0LlQk4ktG7WTlHQFLZ+jVfVWRtj8Y6TWeTQnW2lW4zcGZL8cbXHKIjeACRD
	 jfN9QSXDYfxhDqJ6VilujlP/8K605zrtjC4/COjeF6inD5Ybfw436Vrgce5xKo8+xs
	 zaXU67yI9edgSQxXdwfs4sWHd67k4UwuZpGYC3tpXqzCUNz+vBK5YTEWlI7ZYIT06g
	 ILhOu+wnhJV/Fx2s2513FPrl21gqgO/SGwOnMaelfZteadqoVeKiRbsEXo69QODt7u
	 kn9Ow143gLpdQ==
Date: Sun, 31 Dec 2023 12:50:35 -0800
Subject: [PATCH 08/18] xfs: add parent attributes to symlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841168.1756905.3742334033342369885.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixups]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.c |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    4 ++--
 fs/xfs/scrub/symlink_repair.c   |    2 +-
 fs/xfs/xfs_symlink.c            |   28 +++++++++++++++++++++++-----
 4 files changed, 43 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index cf775750120e8..c8adda82debe0 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -64,3 +64,20 @@ xfs_link_space_res(
 
 	return ret;
 }
+
+unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+			fsblocks;
+
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 5539634009fb2..354ad1d6e18d6 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
@@ -106,5 +104,7 @@ unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_symlink_space_res(struct xfs_mount *mp, unsigned int namelen,
+		unsigned int fsblocks);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 60246350ebfc9..62190fa738553 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -403,7 +403,7 @@ xrep_symlink_rebuild(
 	 * unlikely.
 	 */
 	fs_blocks = xfs_symlink_blocks(sc->mp, target_len);
-	resblks = XFS_SYMLINK_SPACE_RES(sc->mp, target_len, fs_blocks);
+	resblks = xfs_symlink_space_res(sc->mp, target_len, fs_blocks);
 	error = xfs_trans_reserve_quota_nblks(sc->tp, sc->tempip, resblks, 0,
 			true);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 307a2b7e5426e..ced29d8c48c0a 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -25,6 +25,8 @@
 #include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -101,6 +103,7 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_args	*ppargs;
 
 	*ipp = NULL;
 
@@ -131,18 +134,24 @@ xfs_symlink(
 
 	/*
 	 * The symlink will fit into the inode data fork?
-	 * There can't be any attributes so we get the whole variable part.
+	 * If there are no parent pointers, then there wont't be any attributes.
+	 * So we get the whole variable part, and do not need to reserve extra
+	 * blocks.  Otherwise, we need to reserve the blocks.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
+	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
+
+	error = xfs_parent_start(mp, &ppargs);
+	if (error)
+		goto out_release_dquots;
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -162,7 +171,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -196,6 +205,12 @@ xfs_symlink(
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	/* Add parent pointer for the new symlink. */
+	error = xfs_parent_add(tp, ppargs, dp, link_name, ip);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_dir_update_hook(dp, ip, 1, link_name);
 
 	/*
@@ -217,6 +232,7 @@ xfs_symlink(
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
 out_trans_cancel:
@@ -232,6 +248,8 @@ xfs_symlink(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+out_parent:
+	xfs_parent_finish(mp, ppargs);
 out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);

