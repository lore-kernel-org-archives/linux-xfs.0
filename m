Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BEBF4FC
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000421; cv=none; b=BL4sk0pXta8RZE27UXzHpjGqJQfiWDSz56d6ENg8DehlOTfOYIXVnnDAELneDieTleqLpwwRoZm6z6bkCRA9GAYkRtCFtV6OOjPJWr17zS5ecJEJ/fVp1OGszJq00V0UNCzuO45ThWwZm74IRp/+DEjtqTL6t0Evq19k4I7FAz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000421; c=relaxed/simple;
	bh=x3Ngt9tmDbuN83m0Phbi73LURLGzz+87zUziZluYG50=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kXnyz/ZSzyVUBS9d9vV/62WLixI9sF74f/OvgXOHaz1aROzCrQca1MqKs/mvzhM4Pl9XbhLwamf7HDb3NXFqn0rfYWvIl3gKRbwKSZpWE6yFfjmlT11VkXR9aicC+Pu1l0bYD8lmCwyGjjzBADRaz4VWZE9bLAa4bQuRkOLQTNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cleQro++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cleQro++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB5AC433F1;
	Tue, 27 Feb 2024 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000421;
	bh=x3Ngt9tmDbuN83m0Phbi73LURLGzz+87zUziZluYG50=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cleQro++Bpmc/Ljhn7T6gWf+YAroAz8QB04CFr5ZZ0Mm+4uuFnpA5OK80jVIwliEb
	 108Bg50QoWu8OaPitB5RRH3Hu/IdJYMLrGGbzukezo0i9VZPndZ+NZFsdY6eiwW51k
	 ciRvggDl4CBmc5tz/TIPhM133mVgKGQqNA3/NGPvaKRkUxT+3Z2mm2GzMUhwQbNCtU
	 XK5cXzr/zWBEg/36pElA6t6WnWOYiAfwwDLJSKpX/JNW4u8Nq5Sohg1gAaiO+KRvIG
	 sxbcqkZYh/lN7lk1QA6twVZaFs3v51MSXj1tlXIxcK0k+Y/K0Zb8hWsCCjsN2WPIlt
	 Klb6RYPWFQwKg==
Date: Mon, 26 Feb 2024 18:20:20 -0800
Subject: [PATCH 4/6] xfs: create a new helper to return a file's allocation
 unit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011198.938068.6280271502861171630.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
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
index 9961d4b5efbe6..64278f8acaeee 100644
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
index 97ad5e959f65e..440e9c0ebd6b8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4019,3 +4019,16 @@ xfs_break_layouts(
 
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
index 361a3d5efb903..c8799a55d885f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -625,6 +625,7 @@ int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 bool xfs_ifork_zapped(const struct xfs_inode *ip, int whichfork);
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
+unsigned int xfs_inode_alloc_unitsize(struct xfs_inode *ip);
 
 struct xfs_dir_update_params {
 	const struct xfs_inode	*dp;

