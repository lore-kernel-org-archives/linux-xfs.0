Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85C51CFA9
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504324; cv=none; b=LeQSX4e6E+CmnruAVLfvi1g/iZrGpRVTaNpfQYOBQ/3rs2RSYtVjp/45Xg+XW4jUGyT9lsbZBrIIDbUENp2pkGdD9kkxBpJbKir36sDVm1Bv+UcKlESf/e/gMj/dU5alv8h20AQAd6ZYDSTVSsMWTBGcYPPCs7gskKHU4dKEGVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504324; c=relaxed/simple;
	bh=q1HJvQu/GIDUAWonryaObirosihQ149FhduDyHcK9no=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jSV9kXgx8a6EYooOKH8rIRSpMfnZq0Qu9uYQDty+s7hqSRah8W8BG4yHv/zuBGmBaqFiWP8mRHGK4SMp4zr3JKWyUKWvQL501Lph1KldrXrwC0uxidHdCrTuxkIhHBfBfwW7/vaoTk59GPQMbLdXa7M7axSWwTH/4pkVSYL4DRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eHOvRLPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eHOvRLPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A591C433B1;
	Wed, 27 Mar 2024 01:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504323;
	bh=q1HJvQu/GIDUAWonryaObirosihQ149FhduDyHcK9no=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eHOvRLPWbCaFmWTTgLmgRdgebykc4ibdjn1yBGqCC/3hOUR85qZn2rhjtbPlFqBu1
	 kQ4DhVNR2Y2I396LQAL5sveN6XqjDJ95hWNOodbTuERHshu8nEJPilFM5EKGkfgNBK
	 qTbT6xktL4O6qI2ssOTyTR90S+5Jhb74s/54FqtPN8dX+szzm5Ld200oPy7FlVCyRV
	 hz8OnLM/cQYIuJ45AovTsEXY6dxo6d2dxW7fki8OGkwgNUnJ1xOBw4LOc7Djs3mbtc
	 kW4UK7G43Y+p9UGe2UJTeltSGS4keOBpiNqVPU943hRCASutUZMn4B03M7OBWd9Cm9
	 Nioy2FirNmcdw==
Date: Tue, 26 Mar 2024 18:52:03 -0700
Subject: [PATCH 4/7] xfs: create a new helper to return a file's allocation
 unit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380199.3216450.7509540918465429427.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
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

Remove the static attribute from xfs_is_falloc_aligned since the next
patch will need it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index b95e249cc46a5..1cf061a7324ae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3997,3 +3997,16 @@ xfs_break_layouts(
 
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
index b2dde0e0f265a..fa3e605901e24 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -625,6 +625,7 @@ int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 bool xfs_ifork_zapped(const struct xfs_inode *ip, int whichfork);
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
+unsigned int xfs_inode_alloc_unitsize(struct xfs_inode *ip);
 
 struct xfs_dir_update_params {
 	const struct xfs_inode	*dp;

