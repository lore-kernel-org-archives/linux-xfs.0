Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D659457314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423031; cv=none; b=Y7OtmuEjBBCklEbpuAeVqJi8Svcux9SSleiIRzTmTGCT8OIilKmAjuYs9uQW2gUULnhaiuWZIWUxZmS/2BXfdHLnNbcV04SZObNQLZDf/z7o8jdEhHORhc5cXE+kIEjuVTBR6qBv9osGFnJnQy7wG90vkYe7HNh/hvPAiqXA9NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423031; c=relaxed/simple;
	bh=7UpBuV/rziA0OtW+6MuOeP/qddUsPyPyKJj3PSgT1OU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJWtGsQkuHJhzJzKHGYhayOwjdGla+vYzWw7V8Qk0IDnrNd2w3eNJPS2SrAr8gi2xxlL88fyR1Cicp8PjOw8hSrJfpL2Yf/77KqVaBjyULuq2nZ0+kjUSp+oZ24wtYAhSN+RJMeORIjoYEpufSbbf5nW6Ay8TRfJK7Umj4oUHus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sz+ix9By; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sz+ix9By"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3867C433F1;
	Tue, 26 Mar 2024 03:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423031;
	bh=7UpBuV/rziA0OtW+6MuOeP/qddUsPyPyKJj3PSgT1OU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sz+ix9ByjHpKfheuz/IRTJCL5ReYCjcOUEoLlnp8CqfaAHZOCheYHUvq48ga6lnnt
	 EuYTQJPlLELR5w6uGW8pJGj4kZ3JhkGAs2lUwN9WHLXjGsLLnz4thokPiS06tOTpzJ
	 5GpswjwR8KQE47dmGDfasKMNBH5byUnbRZDybWUDZgeuYyNwTFcuCEDbXzXXBWSqgH
	 tZ8JsMEgwhxsOimhD/cc85opolyE6pKwCoIWGbM28NHHIG9g9CgqZURUVgH8laH6E+
	 +1mtMXBgcyd2GBprn5lYYtEchFlSjuFHQhR5bO5lSW6gwvCjvELd4YtwJ7+GKeQmas
	 xh796WJWtiNXQ==
Date: Mon, 25 Mar 2024 20:17:11 -0700
Subject: [PATCH 55/67] xfs: return if_data from xfs_idata_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127749.2212320.9900554602905215823.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 45c76a2add55b332d965c901e14004ae0134a67e

Many of the xfs_idata_realloc callers need to set a local pointer to the
just reallocated if_data memory.  Return the pointer to simplify them a
bit and use the opportunity to re-use krealloc for freeing if_data if the
size hits 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr_leaf.c  |    7 +++----
 libxfs/xfs_dir2_sf.c    |   25 ++++++++++---------------
 libxfs/xfs_inode_fork.c |   20 ++++++++------------
 libxfs/xfs_inode_fork.h |    2 +-
 4 files changed, 22 insertions(+), 32 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 5ab52bf1aa66..a21740a87aea 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -687,8 +687,8 @@ xfs_attr_shortform_create(
 	ASSERT(ifp->if_bytes == 0);
 	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS)
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
-	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
-	hdr = ifp->if_data;
+
+	hdr = xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
@@ -764,8 +764,7 @@ xfs_attr_shortform_add(
 
 	offset = (char *)sfe - (char *)sf;
 	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
-	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
-	sf = ifp->if_data;
+	sf = xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
 	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
 	sfe->namelen = args->namelen;
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index b2b43e937476..37c7e1d5cc8a 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -466,12 +466,11 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Grow the in-inode space.
 	 */
-	xfs_idata_realloc(dp, xfs_dir2_sf_entsize(mp, sfp, args->namelen),
+	sfp = xfs_idata_realloc(dp, xfs_dir2_sf_entsize(mp, sfp, args->namelen),
 			  XFS_DATA_FORK);
 	/*
 	 * Need to set up again due to realloc of the inode data.
 	 */
-	sfp = dp->i_df.if_data;
 	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
 	/*
 	 * Fill in the new entry.
@@ -551,11 +550,8 @@ xfs_dir2_sf_addname_hard(
 	 * the data.
 	 */
 	xfs_idata_realloc(dp, -old_isize, XFS_DATA_FORK);
-	xfs_idata_realloc(dp, new_isize, XFS_DATA_FORK);
-	/*
-	 * Reset the pointer since the buffer was reallocated.
-	 */
-	sfp = dp->i_df.if_data;
+	sfp = xfs_idata_realloc(dp, new_isize, XFS_DATA_FORK);
+
 	/*
 	 * Copy the first part of the directory, including the header.
 	 */
@@ -820,15 +816,13 @@ xfs_dir2_sf_create(
 	ASSERT(dp->i_df.if_bytes == 0);
 	i8count = pino > XFS_DIR2_MAX_SHORT_INUM;
 	size = xfs_dir2_sf_hdr_size(i8count);
+
 	/*
-	 * Make a buffer for the data.
+	 * Make a buffer for the data and fill in the header.
 	 */
-	xfs_idata_realloc(dp, size, XFS_DATA_FORK);
-	/*
-	 * Fill in the header,
-	 */
-	sfp = dp->i_df.if_data;
+	sfp = xfs_idata_realloc(dp, size, XFS_DATA_FORK);
 	sfp->i8count = i8count;
+
 	/*
 	 * Now can put in the inode number, since i8count is set.
 	 */
@@ -976,11 +970,12 @@ xfs_dir2_sf_removename(
 	 */
 	sfp->count--;
 	dp->i_disk_size = newsize;
+
 	/*
 	 * Reallocate, making it smaller.
 	 */
-	xfs_idata_realloc(dp, newsize - oldsize, XFS_DATA_FORK);
-	sfp = dp->i_df.if_data;
+	sfp = xfs_idata_realloc(dp, newsize - oldsize, XFS_DATA_FORK);
+
 	/*
 	 * Are we changing inode number size?
 	 */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index fbcda5f544a7..c95abd43ab0b 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -494,7 +494,7 @@ xfs_iroot_realloc(
  * byte_diff -- the change in the number of bytes, positive or negative,
  *	 requested for the if_data array.
  */
-void
+void *
 xfs_idata_realloc(
 	struct xfs_inode	*ip,
 	int64_t			byte_diff,
@@ -506,19 +506,15 @@ xfs_idata_realloc(
 	ASSERT(new_size >= 0);
 	ASSERT(new_size <= xfs_inode_fork_size(ip, whichfork));
 
-	if (byte_diff == 0)
-		return;
-
-	if (new_size == 0) {
-		kmem_free(ifp->if_data);
-		ifp->if_data = NULL;
-		ifp->if_bytes = 0;
-		return;
+	if (byte_diff) {
+		ifp->if_data = krealloc(ifp->if_data, new_size,
+					GFP_NOFS | __GFP_NOFAIL);
+		if (new_size == 0)
+			ifp->if_data = NULL;
+		ifp->if_bytes = new_size;
 	}
 
-	ifp->if_data = krealloc(ifp->if_data, new_size,
-			GFP_NOFS | __GFP_NOFAIL);
-	ifp->if_bytes = new_size;
+	return ifp->if_data;
 }
 
 /* Free all memory and reset a fork back to its initial state. */
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 7edcf0e8cd53..96303249d28a 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -168,7 +168,7 @@ int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
 void		xfs_idestroy_fork(struct xfs_ifork *ifp);
-void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
+void *		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);

