Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9C88F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928622; cv=none; b=jIMRMJis08bKFICKGnSEbiUGFCh/pL5QUKlTEi7yIF4q/qQJKIpQn54GIF9JnVQbWEGW4bKH11rll2V/lKKfk5G4JnrPatihC0lK4UhmKmTdqxISqL3kPEN3NXdl6tGTObiQAwlRzw9EO/u2XjzCnirPeEmj2hknQk22sV5YmAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928622; c=relaxed/simple;
	bh=4TPzPUwR77RIM5ydMWWvbMq7leJbX9yIW1V+9OfVZls=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dVQKcuuKnhSzKmygHgSMQpVb+P9ZbDrW/sPvw1Cc6hHMVk4kygxu5Y6kdTGpG5akL4eNV7Lq08iLoJ9seIILb7kryFLM7Hj780uGaJ/PzIKw4Vy+9F6z51/Dr0wDrWEjdj17WtUyxZntFKyQbx0OobhZ3apD4JcPqv/VMAecaOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cyjhEwIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyjhEwIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DD7C116B1;
	Wed, 24 Apr 2024 03:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928621;
	bh=4TPzPUwR77RIM5ydMWWvbMq7leJbX9yIW1V+9OfVZls=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cyjhEwIEmAqJOK8CNY76hMsslxoLZaFV7dcm+XrbDeHpmdtfkFhsveK2IRD46yjYU
	 NCZ3ezW3SoKwj9hLq+5z8LJxg5bJqc/NWVSPvtdd3aGl1sNfJ+JFyvjBYI8uBiydJL
	 yNC2ElWpQgfpTrHHvcAM/47tMqd5x+gXDtBzanJggpVu10Ka7CRQBM6XP72fpOYx9B
	 XeJ3wWws3AUWsPxqNbV0njyP4Pti2jSGni3Ck5YtSaUmkbBJRRyxSshFL/4VJpt+5z
	 nAe0h74sBehAp54lmpfHD0Pg6wC+HPF8Ju/I01n+GWEP4p2prFsc1rUCgKFgmL34d4
	 eZSKhK2P0/qug==
Date: Tue, 23 Apr 2024 20:17:01 -0700
Subject: [PATCH 17/30] xfs: add parent attributes to symlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783555.1905110.9704351944080273528.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_space.c |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    4 ++--
 fs/xfs/scrub/symlink_repair.c   |    2 +-
 fs/xfs/xfs_symlink.c            |   30 +++++++++++++++++++++++++-----
 4 files changed, 45 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index cf775750120e..c8adda82debe 100644
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
index 5539634009fb..354ad1d6e18d 100644
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
index 178304959535..c8b5a5b878ac 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -421,7 +421,7 @@ xrep_symlink_rebuild(
 	 * unlikely.
 	 */
 	fs_blocks = xfs_symlink_blocks(sc->mp, target_len);
-	resblks = XFS_SYMLINK_SPACE_RES(sc->mp, target_len, fs_blocks);
+	resblks = xfs_symlink_space_res(sc->mp, target_len, fs_blocks);
 	error = xfs_trans_reserve_quota_nblks(sc->tp, sc->tempip, resblks, 0,
 			true);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 85ef56fdd7df..17aee806ec2e 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -25,6 +25,8 @@
 #include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 int
 xfs_readlink(
@@ -100,6 +102,7 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_args	*ppargs;
 
 	*ipp = NULL;
 
@@ -130,18 +133,24 @@ xfs_symlink(
 
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
@@ -161,7 +170,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -195,6 +204,14 @@ xfs_symlink(
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	/* Add parent pointer for the new symlink. */
+	if (ppargs) {
+		error = xfs_parent_addname(tp, ppargs, dp, link_name, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_dir_update_hook(dp, ip, 1, link_name);
 
 	/*
@@ -216,6 +233,7 @@ xfs_symlink(
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
 out_trans_cancel:
@@ -231,6 +249,8 @@ xfs_symlink(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+out_parent:
+	xfs_parent_finish(mp, ppargs);
 out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);

