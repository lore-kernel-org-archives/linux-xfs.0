Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E831FC7E9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191299; cv=none; b=KN2IZEojCmuZnPgEqwTjTrV8+HrcZoUGO+NKuT3MA8hXaxDnReWxmwU81UxGvzwN05DRvVq/nCsl9jV7EsbofUbkxPkXc3Vau+bmXmMYb3a6KKenoNe5XTOfUjJdU5GWmfgDZbSN+wpmG3WxRQ5iWs6tjiQICdiH9zpunoKyXSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191299; c=relaxed/simple;
	bh=lZ8R9jab/vJKGofNxZRHx3Hwwm3bhmQ5nn1emfKDUSs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UvHjcOvAsr32mcWq7fmFU97Rhwi8PyXBqBIjd9kTXzlIOJnVqNLqdcQl+Nnbt4C9z/Y3zwhdYyqj193sP0D1oH/P7b88K/1EU+6kIKTApPcGDifxvs64hbps7Dn37LqysRj0+U+4u2pHOZB9e8DzSO/lZVMxaRdfbnY5ljMT82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lj7ysORG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lj7ysORG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913B9C4CECD;
	Thu, 17 Oct 2024 18:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191299;
	bh=lZ8R9jab/vJKGofNxZRHx3Hwwm3bhmQ5nn1emfKDUSs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lj7ysORG2fMqVSZjNnSD4Rsr9j++DoJUzUuR0A7A2c+qJQylaYvoE8nlEIW+LmH4q
	 VkwJcFMwr+YoJ+XCyj3tdBcP1BiT4o3PD2CpN3hwVoIArdQV0q9ihlAozsrbhklt5P
	 tqnfiqZJtg+iLob4LblV4gRqYGpIfRlGxDQ0bk/cRg1GRPNS2E+3ZOXbLrBnjGcGqq
	 AUXZBODNbN5ZOsDXElXwL7plNLKNCuJlpU5kpsbdnjgtL1239Pkhl1DtkXCZSnPFiq
	 uv0ETUSTIN0oEMpxIV9IQAFQHeIw36zMdnatWway0FDhlAt/YK1RXtAnd4ZhRJv7TL
	 ksu9AMsUre9iw==
Date: Thu, 17 Oct 2024 11:54:59 -0700
Subject: [PATCH 02/29] xfs: constify the xfs_inode predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069478.3451313.2576556252762140635.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Change the xfs_inode predicates to take a const struct xfs_inode pointer
because they do not change the inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c |    2 +-
 fs/xfs/xfs_inode.h |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 07356c0c1ed7cc..0439f129629937 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3040,7 +3040,7 @@ xfs_inode_alloc_unitsize(
 /* Should we always be using copy on write for file writes? */
 bool
 xfs_is_always_cow_inode(
-	struct xfs_inode	*ip)
+	const struct xfs_inode	*ip)
 {
 	return ip->i_mount->m_always_cow && xfs_has_reflink(ip->i_mount);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 97ed912306fd06..be7d4b26aaea3f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -100,7 +100,7 @@ static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
 	return ip->i_prev_unlinked != 0;
 }
 
-static inline bool xfs_inode_has_attr_fork(struct xfs_inode *ip)
+static inline bool xfs_inode_has_attr_fork(const struct xfs_inode *ip)
 {
 	return ip->i_forkoff > 0;
 }
@@ -271,7 +271,7 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned long flags)
 	return ret;
 }
 
-static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
+static inline bool xfs_is_reflink_inode(const struct xfs_inode *ip)
 {
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
@@ -285,9 +285,9 @@ static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
 	       xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
 }
 
-bool xfs_is_always_cow_inode(struct xfs_inode *ip);
+bool xfs_is_always_cow_inode(const struct xfs_inode *ip);
 
-static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
+static inline bool xfs_is_cow_inode(const struct xfs_inode *ip)
 {
 	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
 }
@@ -296,17 +296,17 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
  */
-static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
+static inline bool xfs_inode_has_cow_data(const struct xfs_inode *ip)
 {
 	return ip->i_cowfp && ip->i_cowfp->if_bytes;
 }
 
-static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
+static inline bool xfs_inode_has_bigtime(const struct xfs_inode *ip)
 {
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
-static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
+static inline bool xfs_inode_has_large_extent_counts(const struct xfs_inode *ip)
 {
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
@@ -315,7 +315,7 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  * Decide if this file is a realtime file whose data allocation unit is larger
  * than a single filesystem block.
  */
-static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
+static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 {
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
@@ -620,9 +620,9 @@ void xfs_sort_inodes(struct xfs_inode **i_tab, unsigned int num_inodes);
 
 static inline bool
 xfs_inode_unlinked_incomplete(
-	struct xfs_inode	*ip)
+	const struct xfs_inode	*ip)
 {
-	return VFS_I(ip)->i_nlink == 0 && !xfs_inode_on_unlinked_list(ip);
+	return VFS_IC(ip)->i_nlink == 0 && !xfs_inode_on_unlinked_list(ip);
 }
 int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_inode_reload_unlinked(struct xfs_inode *ip);

