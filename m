Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9626DBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+Z0yjm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685CCC433C8;
	Sun, 31 Dec 2023 21:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058636;
	bh=Fqg75wC5yfmbLY+AKLukU8nCMWwwMd1aDdLF7GUqxQs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P+Z0yjm7RFKYJmPeTUJ3By3Q2DpEVqIB/eeVmWpCRYYcSgUoAQ30KPbwRQn/BqmhF
	 2mRoAHFztTc8NW7ih67JkjT5zdx0m+vGxy81YQJCv6d0JEFf9Cty3TQqN0ojP6K6OJ
	 gLw1jRtlMjxwZ5cx1kTLLGlrWRv/3KdOYgGLht4XU21z6QAyvX7I7IXV7S/GwcC0Ta
	 EwnOlSnv4R1DVFO09H4MKo0Dc8qOOkVtG6KwT2iast+LPzkJ0ClMFBtyvViGPxSl2H
	 mYH3uF438SHrNRTWL9yyreDDSXKwify7J375mX5sJDVSmJRWvHAL5MY6oo++oDbrbN
	 /5/1CYISpMXBA==
Date: Sun, 31 Dec 2023 13:37:15 -0800
Subject: [PATCH 21/39] xfs: add realtime rmap btree when adding rt volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850238.1764998.14223965488625049404.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

If we're adding enough space to the realtime section to require the
creation of new realtime groups, create the rt rmap btree inode before
we start adding the space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ac6580bda2052..f6b23439b674d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -24,8 +24,11 @@
 #include "xfs_health.h"
 #include "xfs_da_format.h"
 #include "xfs_imeta.h"
+#include "xfs_imeta_utils.h"
 #include "xfs_rtgroup.h"
 #include "xfs_error.h"
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
 
@@ -1017,6 +1020,74 @@ xfs_growfs_rt_init_primary(
 	return 0;
 }
 
+/* Add a metadata inode for a realtime rmap btree. */
+static int
+xfs_growfsrt_create_rtrmap(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_update	upd;
+	struct xfs_rmap_irec	rmap = {
+		.rm_startblock	= 0,
+		.rm_blockcount	= mp->m_sb.sb_rextsize,
+		.rm_owner	= XFS_RMAP_OWN_FS,
+		.rm_offset	= 0,
+		.rm_flags	= 0,
+	};
+	struct xfs_btree_cur	*cur;
+	struct xfs_imeta_path	*path;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp) || rtg->rtg_rmapip)
+		return 0;
+
+	error = xfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	error = xfs_imeta_ensure_dirpath(mp, path);
+	if (error)
+		goto out_path;
+
+	error = xfs_imeta_start_create(mp, path, &upd);
+	if (error)
+		goto out_path;
+
+	error = xfs_rtrmapbt_create(&upd, &ip);
+	if (error)
+		goto out_cancel;
+
+	lockdep_set_class(&ip->i_lock.mr_lock, &xfs_rrmapip_key);
+
+	/* Rmap the rtgroup superblock; this had better fit in the data fork. */
+	cur = xfs_rtrmapbt_init_cursor(mp, upd.tp, rtg, ip);
+	error = xfs_rmap_map_raw(cur, &rmap);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_imeta_commit_update(&upd);
+	if (error)
+		goto out_path;
+
+	xfs_imeta_free_path(path);
+	xfs_finish_inode_setup(ip);
+	rtg->rtg_rmapip = ip;
+	return 0;
+
+out_cancel:
+	xfs_imeta_cancel_update(&upd, error);
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
+out_path:
+	xfs_imeta_free_path(path);
+	return error;
+}
+
 /*
  * Check that changes to the realtime geometry won't affect the minimum
  * log size, which would cause the fs to become unusable.
@@ -1122,7 +1193,9 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
+	if (!xfs_has_rtgroups(mp) && xfs_has_rmapbt(mp))
+		return -EOPNOTSUPP;
+	if (xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
@@ -1261,10 +1334,21 @@ xfs_growfs_rt(
 		/* recompute growfsrt reservation from new rsumsize */
 		xfs_trans_resv_calc(nmp, &nmp->m_resv);
 
-		if (xfs_has_rtgroups(mp))
+		if (xfs_has_rtgroups(mp)) {
+			xfs_rgnumber_t	rgno = last_rgno;
+
 			nsbp->sb_rgcount = howmany_64(nsbp->sb_rblocks,
 						      nsbp->sb_rgblocks);
 
+			for_each_rtgroup_range(mp, rgno, nsbp->sb_rgcount, rtg) {
+				error = xfs_growfsrt_create_rtrmap(rtg);
+				if (error) {
+					xfs_rtgroup_rele(rtg);
+					break;
+				}
+			}
+		}
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */

