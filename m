Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67537BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d45mPW5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58C9C433C7;
	Sun, 31 Dec 2023 20:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054348;
	bh=JKHnAMPrOVMhXLqlrao1pawLGYGhySHTm2enCiZh9vI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d45mPW5Q8wZ2rR5AuPIVOabffQnUplKG6UrxbONzrpwPzR3WWOrGvQy/BYqM7HKk6
	 8ju8UX/X8Qf2DMqAwopCFhbHTc76W+T6nRYUwDLHw1Zn1ac/p3Oya4Em3OCY0yGypX
	 v96l/VZdpVslYYGXQEoWPRGaTeUz8nNis4zK9t/B808UycGNd2CU6CxlXf0QJhfi8R
	 XihMwPxDqF7++4Q+2L+jL2P/Wryd0x5ja7pUoywbfv0uaINpClTGAzF+564kP3fOc3
	 mEluWu7rkNEa25Q4iUR9AdiMoozmjX6iaF7RsstCi5brPO5A5j8sgrJCCj8m+ZE2zV
	 PDlJpyi8jtZ8A==
Date: Sun, 31 Dec 2023 12:25:48 -0800
Subject: [PATCH 06/25] xfs: create a new helper to return a file's allocation
 unit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833234.1750288.618883893221493614.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

Create a new helper function to calculate the fundamental allocation
unit (i.e. the smallest unit of space we can allocate) of a file.
Things are going to get hairy with range-exchange on the realtime
device, so prepare for this now.

While we're at it, export xfs_is_falloc_aligned since the next patch
will need it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |   28 ++++++++++------------------
 fs/xfs/xfs_file.h  |    3 +++
 fs/xfs/xfs_inode.c |   13 +++++++++++++
 fs/xfs/xfs_inode.h |    1 +
 4 files changed, 27 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9becf6a075361..8ac3bc98e4369 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -39,33 +39,25 @@ static const struct vm_operations_struct xfs_file_vm_ops;
  * Decide if the given file range is aligned to the size of the fundamental
  * allocation unit for the file.
  */
-static bool
+bool
 xfs_is_falloc_aligned(
 	struct xfs_inode	*ip,
 	loff_t			pos,
 	long long int		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		mask;
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(ip);
 
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		if (!is_power_of_2(mp->m_sb.sb_rextsize)) {
-			u64	rextbytes;
-			u32	mod;
+	if (!is_power_of_2(alloc_unit)) {
+		u32	mod;
 
-			rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-			div_u64_rem(pos, rextbytes, &mod);
-			if (mod)
-				return false;
-			div_u64_rem(len, rextbytes, &mod);
-			return mod == 0;
-		}
-		mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
-	} else {
-		mask = mp->m_sb.sb_blocksize - 1;
+		div_u64_rem(pos, alloc_unit, &mod);
+		if (mod)
+			return false;
+		div_u64_rem(len, alloc_unit, &mod);
+		return mod == 0;
 	}
 
-	return !((pos | len) & mask);
+	return !((pos | len) & (alloc_unit - 1));
 }
 
 /*
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index 7d39e3eca56dc..2ad91f755caf3 100644
--- a/fs/xfs/xfs_file.h
+++ b/fs/xfs/xfs_file.h
@@ -9,4 +9,7 @@
 extern const struct file_operations xfs_file_operations;
 extern const struct file_operations xfs_dir_file_operations;
 
+bool xfs_is_falloc_aligned(struct xfs_inode *ip, loff_t pos,
+		long long int len);
+
 #endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index faa3d0abf4551..15668dbc5ca9e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4015,3 +4015,16 @@ xfs_break_layouts(
 
 	return error;
 }
+
+/* Returns the size of fundamental allocation unit for a file, in bytes. */
+unsigned int
+xfs_inode_alloc_unitsize(
+	struct xfs_inode	*ip)
+{
+	unsigned int		blocks = 1;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		blocks = ip->i_mount->m_sb.sb_rextsize;
+
+	return XFS_FSB_TO_B(ip->i_mount, blocks);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 5e2f163fd7445..e1d60ba75bbdd 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -625,6 +625,7 @@ int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 bool xfs_ifork_zapped(const struct xfs_inode *ip, int whichfork);
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
+unsigned int xfs_inode_alloc_unitsize(struct xfs_inode *ip);
 
 struct xfs_dir_update_params {
 	const struct xfs_inode	*dp;

