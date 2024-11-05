Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6D51DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845030; cv=none; b=aMcHlnXipKQJMzqdm+Y7ZOGl7k/SeZl0KZmzhO8NKH7/ie9nu/uwMe/noqGLU0JZBHCjT8ojAKM3UEonFR9SRJOtExzmakYwVYJLw6DxqMmPSNOJD6vdtqx4NYfYPEhxmlb4JC3QLs0NJPbP5a7JCYJKJ9g1w7ZuJsGh1p6ZTR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845030; c=relaxed/simple;
	bh=WzU18gqe0sHaMj37q5BNiTRfgm9OyZY8jkFeDapFzIg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rEXcoA9nXIPAfo/OnP+J3aSP7gzib/a9riqeS4nInXH5waH2k7mNIzSCJ5gg+5Iwx1zDwIiJG5UotzS42G7NVx64eX39dhT6tZTMa3YCWExnXtYt67lYrgjgzMn+13+amzO98zg+MSQ0lee/stpJH8F1Yialw6XUnUjmmZy09rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=swIkdUaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="swIkdUaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B802DC4CECF;
	Tue,  5 Nov 2024 22:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845029;
	bh=WzU18gqe0sHaMj37q5BNiTRfgm9OyZY8jkFeDapFzIg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=swIkdUaQgFia6m6V9z/8uLXFt0gr8/Q4gvqUHJJYtYNwz8R/MnerLzL3n4Jm5PQ3q
	 qluInAHf6DKIHOub+8dUbrBW5Zkj14SK+fxU4U37BtkHrCjbIdfQGjoKClMccY63fL
	 5M/hapQg8OyT9nEeY6C8UsMTpf73osGxzvTJt+U6HXH9HLrm21lg/dh8NhpJMy6y/7
	 qQLWhfUgpqhfssTtBKKKfAkDFiO7N6H0hd0xroi1RThn+ewcu0zZd2qimEgCAoSPgA
	 JRKug6K6A9Iglj95TsMQ5+oxOvhhkAPRPStoEneJ6F7zFZ5sch26dYvK0sMAwKoB+x
	 1c/3HpR2gKVHw==
Date: Tue, 05 Nov 2024 14:17:09 -0800
Subject: [PATCH 02/28] xfs: constify the xfs_inode predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396052.1870066.10505160345401074015.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
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
index 693770f9bb09f0..a8430f30d6df29 100644
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
index 03944b6c5fba1c..41444a557576c1 100644
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
@@ -301,17 +301,17 @@ static inline bool xfs_inode_has_filedata(const struct xfs_inode *ip)
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
@@ -320,7 +320,7 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  * Decide if this file is a realtime file whose data allocation unit is larger
  * than a single filesystem block.
  */
-static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
+static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 {
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
@@ -625,9 +625,9 @@ void xfs_sort_inodes(struct xfs_inode **i_tab, unsigned int num_inodes);
 
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

