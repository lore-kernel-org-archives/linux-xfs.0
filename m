Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F1E1292E6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424332; cv=none; b=ej79YGYbKTWxfO4mbCLs766GZvV79wjFq0eog4dv4+4372CsnneoJopzG1nlKjNYvJDGDau6uFHRh7lDGBvWtrli4IsCB9POVNNH7CsLvCbEwXgcJ7hr8cFq8ZOVlm2s1AoXlGNa5+y371MWbFzH+Y+2M1lsfw7pa3gKcwNFJP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424332; c=relaxed/simple;
	bh=7mjcGDEWk+51k02z+0iXh+tfUiJ0CGHwA46pTm9HkH4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lz0d8m8ZRVlUapEU3ZL8jJkY1+z0D3yqNH4BOY+u51h3pyzHaXmrIA/l5zrUGHC48SO7TXRT5FSg3xV7BrC13azPvEw8WGT2bTvK5BhZZ5QOA9ljTLQoIQDkL43Ro9zGkug0yt+nlRkbBROuJav9lFHt07/wHmHY+cMOiF5f+Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c559URDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c559URDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C551C433F1;
	Tue, 26 Mar 2024 03:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424331;
	bh=7mjcGDEWk+51k02z+0iXh+tfUiJ0CGHwA46pTm9HkH4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c559URDDDFOILd+gpUKvg9W6f7n+99QOGmX9CPlDUByKFK60agWyO9MDRhN9CS9/u
	 UgyzU+lOYBlhsgEjIQQT127U3q6kwb8wGQBCQVZpbFkOYTdGt4NqMEN8mOnyPwLkCL
	 bt4hZP7YNI3htmywkWGG3vy/EksCpZDmKloS9O0kDZjezonkJ8EvUxFQDoZwxKTcUh
	 qS97fHBULhh8xNAgX53oHjUWVSYPVcUn5quWZVvFCJZaqRlmKQ+sO1ziSJKlBBLNO0
	 c01nxdkISRbGxwwOm3sCFFjgO6Qp9FHhnCw0pOG9hUpnAcieLA4HC6zgBtII5x+bGb
	 wZON0vIJDRxMA==
Date: Mon, 25 Mar 2024 20:38:50 -0700
Subject: [PATCH 040/110] xfs: remove the unnecessary daddr paramter to
 _init_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131961.2215168.18224396740796755232.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 11388f6581f40e7d5a69ce5f8b13264eca7c2c5c

Now that all of the callers pass XFS_BUF_DADDR_NULL as the daddr
parameter, we can elide that too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap_btree.c    |    4 ++--
 libxfs/xfs_btree.c         |   19 ++++++++++++++++---
 libxfs/xfs_btree.h         |    2 +-
 libxfs/xfs_btree_staging.c |    5 ++---
 4 files changed, 21 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 65ba3ae8a549..2d84118099d8 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -37,8 +37,8 @@ xfs_bmbt_init_block(
 		xfs_btree_init_buf(ip->i_mount, bp, &xfs_bmbt_ops, level,
 				numrecs, ip->i_ino);
 	else
-		xfs_btree_init_block(ip->i_mount, buf, &xfs_bmbt_ops,
-				XFS_BUF_DADDR_NULL, level, numrecs, ip->i_ino);
+		xfs_btree_init_block(ip->i_mount, buf, &xfs_bmbt_ops, level,
+				numrecs, ip->i_ino);
 }
 
 /*
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 372a521c1af8..2386084a531d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1150,8 +1150,8 @@ xfs_btree_set_sibling(
 	}
 }
 
-void
-xfs_btree_init_block(
+static void
+__xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1192,6 +1192,19 @@ xfs_btree_init_block(
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
@@ -1201,7 +1214,7 @@ xfs_btree_init_buf(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 56901d2591ed..80be40ca8954 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -440,7 +440,7 @@ void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		__u64 owner);
 void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
-		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
+		__u16 level, __u16 numrecs, __u64 owner);
 
 /*
  * Common btree core entry points.
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 47ef8e23a59e..39e95a771c3b 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
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

