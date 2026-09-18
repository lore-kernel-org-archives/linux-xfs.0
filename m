Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF0F4E4C27;
	Fri, 18 Sep 2026 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730173; cv=none; b=jEGzt0hsLfPfFwRtbhiNWD9MO485EqEBjkIByDX7OqJF5znjvQaaOxxySFJN+EyCp1Ne4acg3y7hwvGlgNI3GCRUBZqcD2FMxSag5l5QODLrqgqCsO3SMJS6bVvhFzCI66L4dmOG44dfyghtwdylAy3beAxJvLjlNVOXfiK4bVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730173; c=relaxed/simple;
	bh=BrImC1zQUupHyWjfco3L85lPWp/4vRjvL457rfr9be4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yic21bqYMLSywjTujJS42UsZ0yiE3y/w8dogWuJfsjNSZWaj9gxqmkYPRme0IBnMWbeIj9F7LLo7uaXkqyKEXaadGJwFYtnBlp1huuwjJTRR6M8TB1z512YHXA2TCOjXrt2OVjGWoRZ/5T5nOQe/PWob/LIH458EPwlc6s5U5PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZkuP67J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZkuP67J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E411F00893;
	Fri, 18 Sep 2026 11:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730168;
	bh=UVN+59hMO8qdkHBssLzN1RNNKhQ8KQ1mimLdxlbt15M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZkuP67JkDt9cOly/B5gDPgmqVKlFGmNgN2bGf3BsBSVhLmdT2gyX3ITnS02+4TmF
	 buRwkStz/gNjo5qFnwCQMJtxDUYdXjLwnCJKiEkBETGm1QbEg3BTorw+2e4OmOKU+8
	 dJquPurhKS3Qpr45lSm5mV7B679+GKMpDgIGOlhiNx/TqYRKEqgBT1z3a585ruhYvH
	 woM91zB7zjMZsU4GcGv44DILODI6P+gTmsJ00VPFHau0tPjN9LjUhJLDL5L6mqbKD9
	 rAzD71lBbmM4laQwMhev1028U5nByBKRqNOa4jQY1p8pXr5OUdtXK3mXSiq/mAAfdb
	 t4qA7KpuDEMSw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	stable@vger.kernel.org
Subject: [PATCH v16 06/21] fsverity: hoist statx reporting of fs-verity flag
Date: Fri, 18 Sep 2026 13:15:18 +0200
Message-ID: <20260918111539.1003439-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All filesystems, supporting fsverity, report this status by checking
inode flag. Also, BTRFS was missing stat->attributes_mask, which is
fixed now.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/btrfs/inode.c | 3 ---
 fs/ext4/inode.c  | 5 +----
 fs/f2fs/file.c   | 5 +----
 fs/stat.c        | 6 +++++-
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 93ef3cec191e..c34d0198b988 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8236,7 +8236,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
-	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime_sec;
@@ -8249,8 +8248,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (bi_ro_flags & BTRFS_INODE_RO_VERITY)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03..206c6245c619 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6318,15 +6318,12 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & EXT4_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (flags & EXT4_VERITY_FL)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP |
-				  STATX_ATTR_VERITY);
+				  STATX_ATTR_NODUMP);
 
 	generic_fillattr(idmap, request_mask, inode, stat);
 	return 0;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index edc352569e87..dc1cc0965532 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1075,15 +1075,12 @@ int f2fs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & F2FS_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (IS_VERITY(inode))
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_APPEND |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP |
-				  STATX_ATTR_VERITY);
+				  STATX_ATTR_NODUMP);
 
 	generic_fillattr(idmap, request_mask, inode, stat);
 
diff --git a/fs/stat.c b/fs/stat.c
index c461c3054234..e03954c36b33 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -203,8 +203,12 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	if (IS_DAX(inode))
 		stat->attributes |= STATX_ATTR_DAX;
 
+	if (IS_VERITY(inode))
+		stat->attributes |= STATX_ATTR_VERITY;
+
 	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
-				  STATX_ATTR_DAX);
+				  STATX_ATTR_DAX |
+				  STATX_ATTR_VERITY);
 
 	idmap = mnt_idmap(path->mnt);
 	if (inode->i_op->getattr) {
-- 
2.54.0

