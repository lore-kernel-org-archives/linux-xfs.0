Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F33BBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8yL4QtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F2CC433C8;
	Sun, 31 Dec 2023 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057759;
	bh=B71TZlY3PdASFDNwDdpVwQCr9YiYmLbPQz+bZg6tXXk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F8yL4QtH7Tj4fAlHkhCbi3HuF0rfyOKn5PHiw7QdBb7qlH+5R5j5zBrqsqH5KPL/2
	 D4qjuZkEnFc934WQEEh45Ax6PLEeH8a/2SJx9jIz4LXFKIeUOHIlNFJq9Jqr0kWlXA
	 KqOSHN4T2cDGCqYYIQSkUK3jXB/ccqdutcKSRjDajXV2Qgv4DCntkaqvjhK33KWrWN
	 h1v5c6s3KghBYW3e42LDw2yestFUbmfCY/LI1Z/lPY9icI+YNJm8fbxk8DSyAxbjTO
	 f0Y1SncUtbXttSsWuDLUj9ur2ikUQBWpMPMhG55COKRMXrRdLmBrAWNny146abI9xU
	 x5hK1jZk0pXEg==
Date: Sun, 31 Dec 2023 13:22:39 -0800
Subject: [PATCH 02/14] xfs: refactor the allocation and freeing of incore
 inode fork btree roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847400.1763835.14167223022878479185.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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

Refactor the code that allocates and freese the incore inode fork btree
roots.  This will help us disentangle some of the weird logic when we're
creating and tearing down inode-based btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   53 ++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_inode_fork.h |    3 ++
 2 files changed, 40 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 62cd25ed4c59d..9256499589408 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -207,8 +207,7 @@ xfs_iformat_btree(
 		return -EFSCORRUPTED;
 	}
 
-	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmem_alloc(size, KM_NOFS);
+	xfs_iroot_alloc(ip, whichfork, size);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -358,6 +357,32 @@ xfs_iformat_attr_fork(
 	return error;
 }
 
+/* Allocate a new incore ifork btree root. */
+void
+xfs_iroot_alloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	size_t			bytes)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+
+	ifp->if_broot = kmem_alloc(bytes, KM_NOFS);
+	ifp->if_broot_bytes = bytes;
+}
+
+/* Free all the memory and state associated with an incore ifork btree root. */
+void
+xfs_iroot_free(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+
+	ifp->if_broot_bytes = 0;
+	kmem_free(ifp->if_broot);
+	ifp->if_broot = NULL;
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
@@ -406,8 +431,7 @@ xfs_iroot_realloc(
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
-			ifp->if_broot_bytes = (int)new_size;
+			xfs_iroot_alloc(ip, whichfork, new_size);
 			return;
 		}
 
@@ -446,17 +470,15 @@ xfs_iroot_realloc(
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	else
 		new_size = 0;
-	if (new_size > 0) {
-		new_broot = kmem_alloc(new_size, KM_NOFS);
-		/*
-		 * First copy over the btree block header.
-		 */
-		memcpy(new_broot, ifp->if_broot,
-			xfs_bmbt_block_len(ip->i_mount));
-	} else {
-		new_broot = NULL;
+	if (new_size == 0) {
+		xfs_iroot_free(ip, whichfork);
+		return;
 	}
 
+	/* First copy over the btree block header. */
+	new_broot = kmem_alloc(new_size, KM_NOFS);
+	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
+
 	/*
 	 * Only copy the records and pointers if there are any.
 	 */
@@ -480,9 +502,8 @@ xfs_iroot_realloc(
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
-	if (ifp->if_broot)
-		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-			xfs_inode_fork_size(ip, whichfork));
+	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+		xfs_inode_fork_size(ip, whichfork));
 	return;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index ebeb925be09d9..18ea2d27777a2 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -172,6 +172,9 @@ void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 void		xfs_idestroy_fork(struct xfs_ifork *ifp);
 void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
+void		xfs_iroot_alloc(struct xfs_inode *ip, int whichfork,
+				size_t bytes);
+void		xfs_iroot_free(struct xfs_inode *ip, int whichfork);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,

