Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1382417FF
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882138; cv=none; b=EaJIkNoBnZZp7BTRbwEFqq3R/aTQzq+TmqUL1XV9XJrEu7WFRzZ3eyFmtFsNHTYGxXTRK4qQzV+77iVAs+kviAftNgGIbRBKWXhcK5UlmaBOKCkGJQ7n81Bcx7u/r5umFjNJTTdrownBCcwxZhHPrIFb/WMZkTgpyGFr7FiSjXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882138; c=relaxed/simple;
	bh=3wusq3VQDxKRnv5ZaPP+AkPpKzPQ6a/uVZY2Ab7MoRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MiMv4xeh7997fRhDQh68+qeBmef23vZIhHEtLlt+YNSWvww8bNB+vCpzxJf/fvaCOtPiTSGyOXAI3eo+Ng4J8WzaPSzSdinKUSjX/MKn376BFKN76kKre3iz2no07l2LwoHRRJr4f+H/0RrDGYka9gaBrsVILY2TsXAc+KbT6WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIKSdgYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIKSdgYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4343C4CEDF;
	Thu,  6 Feb 2025 22:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882137;
	bh=3wusq3VQDxKRnv5ZaPP+AkPpKzPQ6a/uVZY2Ab7MoRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jIKSdgYTrb7BT0DxYIXO6poN7uMm+fPrHKDWPT/oh/lb9Q8gci5u9ZpQ71GYrbmlh
	 Y0HRVoz8skVeSwfG1yNHGyMwhiEx4daRcehJTiaDkCBXf/Hj7DVe6yJi3TOXpqgYVa
	 1qqzV64WyyVIBZk/YJBt5kc83nrSSxdvi2HrHYJevbPsw3XOZACb4OQHo0oLmARDQT
	 Hf5Y995D4tq/7VltR7G1CLOc/4j0yKHoOvmlw7dUgTSrgwsNX03vxVQxw0Xh5kzZeq
	 WqVJnrRouIFYtPjIgwV5Y/G2XjjdSjSI7cqkJywl2Lv48XOta6SLPO1E+S/7eD2CQF
	 uKccWdEr0ocFg==
Date: Thu, 06 Feb 2025 14:48:57 -0800
Subject: [PATCH 53/56] xfs: mark xfs_dir_isempty static
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087605.2739176.6385277999824081377.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 23ebf63925989adbe4c4277c8e9b04e0a37f6005

And return bool instead of a boolean condition as int.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dir2.c |    6 +++---
 libxfs/xfs_dir2.h |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 0b026d5f55d0fd..29e64603d4ae82 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -196,7 +196,7 @@ xfs_da_unmount(
 /*
  * Return 1 if directory contains only "." and "..".
  */
-int
+static bool
 xfs_dir_isempty(
 	xfs_inode_t	*dp)
 {
@@ -204,9 +204,9 @@ xfs_dir_isempty(
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	if (dp->i_disk_size == 0)	/* might happen during shutdown. */
-		return 1;
+		return true;
 	if (dp->i_disk_size > xfs_inode_data_fork_size(dp))
-		return 0;
+		return false;
 	sfp = dp->i_df.if_data;
 	return !sfp->count;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 576068ed81fac2..a6594a5a941d9f 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -58,7 +58,6 @@ extern void xfs_dir_startup(void);
 extern int xfs_da_mount(struct xfs_mount *mp);
 extern void xfs_da_unmount(struct xfs_mount *mp);
 
-extern int xfs_dir_isempty(struct xfs_inode *dp);
 extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,

