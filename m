Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E448BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ru5ZkzwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A330C433C7;
	Sun, 31 Dec 2023 20:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053927;
	bh=s7Cr8ezCBYRuKr6CQw1wg53AQ0ZE1vwDzQJqDk3lip0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ru5ZkzwNosvSwPBer0xE/uJMyFay0S3gLOw58yiRE+gdSgVhqxOm+ZCpPRP+VN6UX
	 ymTq8msZdkrhI7UtVp5Eg7RKDomEW9g4fPf3pvifiMd/mrhVd+Bd1uu/l00awpHdmv
	 diJ2axCTf7lqE88cLp76dn3nlomVzfKXK6NAy0ft6ahAOCUb5CV1TWEZpQ6nkrUbKB
	 lsgL8zHuCgp1cDJ7FCxAPNIeobtR8tD9ZjIrEfCqG8gfkT9mZJbeT5ktfzdPswHizn
	 AFhJLndvcumaETMAxUnd+OqxTlGLTyolx3dIQI932HXp8M4/7veqFlhsegHq5A+RH4
	 G9CFwmH4uOxQw==
Date: Sun, 31 Dec 2023 12:18:46 -0800
Subject: [PATCH 7/9] xfs: remove the unnecessary daddr paramter to _init_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830626.1749286.10458122932703633490.stgit@frogsfrogsfrogs>
In-Reply-To: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_bmap.c          |    3 +--
 fs/xfs/libxfs/xfs_bmap_btree.c    |    3 +--
 fs/xfs/libxfs/xfs_btree.c         |   19 ++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.h         |    2 +-
 fs/xfs/libxfs/xfs_btree_staging.c |    5 ++---
 5 files changed, 21 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 75ab7d203c6de..17a2194ac0486 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -644,8 +644,7 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the root.
 	 */
 	block = ifp->if_broot;
-	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL, 1,
-			1, ip->i_ino);
+	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, 1, 1, ip->i_ino);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 22ce7bf32b06a..54e0a47169487 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -44,8 +44,7 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
-			0, 0, ip->i_ino);
+	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0fdaacefe45e2..285dc609daa8d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1212,8 +1212,8 @@ xfs_btree_set_sibling(
 	}
 }
 
-void
-xfs_btree_init_block(
+static void
+__xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1254,6 +1254,19 @@ xfs_btree_init_block(
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
@@ -1263,7 +1276,7 @@ xfs_btree_init_buf(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 6a27c34e68c30..41000bd6cccf7 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -456,7 +456,7 @@ void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		__u64 owner);
 void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
-		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
+		__u16 level, __u16 numrecs, __u64 owner);
 
 /*
  * Common btree core entry points.
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index c4b628a606da7..8f186ada630ba 100644
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

