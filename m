Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF12127B42
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816599; cv=none; b=sRrD7G+vh+dvv2l/7zZBrs+maNLsIshMV2oQyYj4zrhgzxtSxVdKKE62p5rDk+APJAUlhGD83b6p3Ze5Nea4Ro6Lr/fTZgVssR4p10NZ5CI68nLHMAhz873p7iPg1QDQL53xdwBG8mN7iMjZsivEyX4sa11euMrqQVPuyTf/2oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816599; c=relaxed/simple;
	bh=erqJ95CAuZWIwmOD+SXnSpSZ2uPFbZ9/u0jgvU50/ws=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQDx0HCyI1T8jGKZL2jn370pAWeFFKL/TzUIsMYxf6sFJr7/iuCX49KtQIlTmOvgt1nh2sK4EglCIG+cyfN0EHYvov3usJr5DjY1wYuXIluTEZ3FLrmvJM7piXi9mdTMe1l7Jwejq6qqNEb7q+HnHo8TmJRFvkRycJkgibbcbOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+hD4OB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+hD4OB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C49BC433F1;
	Thu,  1 Feb 2024 19:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816599;
	bh=erqJ95CAuZWIwmOD+SXnSpSZ2uPFbZ9/u0jgvU50/ws=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M+hD4OB4xM8uQhcV3/KphuTxz9yuTu3eNZgfss759pxr11v9NtY06riDCLN+Ykxhr
	 T3WejaDdydzc2VeHa2PhRsc2lI3YcW90WegevWX7Fw1gG9khIw5dbKu+VERL4AteC8
	 tD6tMphpU6fvvCK3dXuoVyOACFSY8GuxjlWACeEnpJ300SkCwQ1ednkenh/T6e7xts
	 nFUGou86Z22yaNbyB+Ogv7yUAfqmnWVsAQc41bqKil593KTapzySBbGqF/PIbEjELi
	 tdKlStn7eCA1RcJBlTW85fI+BzWXng+7vgh3jY2iAocrjux27YBosf3bsEWi3YxJ5x
	 LXlOBY4lxEbXw==
Date: Thu, 01 Feb 2024 11:43:19 -0800
Subject: [PATCH 14/23] xfs: remove the unnecessary daddr paramter to
 _init_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334167.1604831.5447790708752564207.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Now that all of the callers pass XFS_BUF_DADDR_NULL as the daddr
parameter, we can elide that too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap_btree.c    |    4 ++--
 fs/xfs/libxfs/xfs_btree.c         |   19 ++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.h         |    2 +-
 fs/xfs/libxfs/xfs_btree_staging.c |    5 ++---
 4 files changed, 21 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index ddaf40e0f3092..fa116c2d13aef 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -38,8 +38,8 @@ xfs_bmbt_init_block(
 		xfs_btree_init_buf(ip->i_mount, bp, &xfs_bmbt_ops, level,
 				numrecs, ip->i_ino);
 	else
-		xfs_btree_init_block(ip->i_mount, buf, &xfs_bmbt_ops,
-				XFS_BUF_DADDR_NULL, level, numrecs, ip->i_ino);
+		xfs_btree_init_block(ip->i_mount, buf, &xfs_bmbt_ops, level,
+				numrecs, ip->i_ino);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6927bebe66292..cb2ba43b9b0c2 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1153,8 +1153,8 @@ xfs_btree_set_sibling(
 	}
 }
 
-void
-xfs_btree_init_block(
+static void
+__xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1195,6 +1195,19 @@ xfs_btree_init_block(
 	}
 }
 
+void
+xfs_btree_init_block(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	const struct xfs_btree_ops *ops,
+	__u16			level,
+	__u16			numrecs,
+	__u64			owner)
+{
+	__xfs_btree_init_block(mp, block, ops, XFS_BUF_DADDR_NULL, level,
+			numrecs, owner);
+}
+
 void
 xfs_btree_init_buf(
 	struct xfs_mount		*mp,
@@ -1204,7 +1217,7 @@ xfs_btree_init_buf(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e07d06da64579..7d24681bf0994 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -440,7 +440,7 @@ void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		__u64 owner);
 void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
-		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
+		__u16 level, __u16 numrecs, __u64 owner);
 
 /*
  * Common btree core entry points.
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index fa89c1e5175e2..9718be22e8414 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -410,9 +410,8 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
-				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
-				nr_this_block, cur->bc_ino.ip->i_ino);
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot, cur->bc_ops,
+				level, nr_this_block, cur->bc_ino.ip->i_ino);
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;

