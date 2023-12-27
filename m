Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC96CA43
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMfxAFWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF754C433C7;
	Mon,  1 Jan 2024 00:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067299;
	bh=s0EXCCfydEqnCNJ55+0Ip+DSP7KKBIGhyBQQRbHumZw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hMfxAFWP/xvTwby31OQY8Y+msJZPbX3ZTh2b6n/HOJ8VXznQAxvFcuXy+0/UEQaf6
	 N/FDrzq377kZ3vAanb02yCx2hV8WRqAyM1L5s7CcS+uyx3Qu7H1TiXJijjHWcEc26W
	 YUNeAqExMddnZ7ZR6MV/UWToe87Qz0hbzj9QHn2U+Nz96FJWvkHz9S9daD6PMgamo6
	 QkUuWIUwYdB4+CtWB0RzzgasglSYU9q8XsNnl59cMWfk5jjYiDWlcQ51JRkQQzNo5W
	 N26QzqfwDLNEqbjBaW2OW9xJHZdSuBHCOhHi/tgcZ5KWiGXtuThC+GPzVJC0iWB8ZF
	 RyXY3H5KtX4RQ==
Date: Sun, 31 Dec 2023 16:01:38 +9900
Subject: [PATCH 02/14] xfs: refactor the allocation and freeing of incore
 inode fork btree roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013228.1812545.15094582290392984235.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
References: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_inode_fork.c |   53 +++++++++++++++++++++++++++++++++--------------
 libxfs/xfs_inode_fork.h |    3 +++
 2 files changed, 40 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 2d67e35c7e3..05f7ada0ae3 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -205,8 +205,7 @@ xfs_iformat_btree(
 		return -EFSCORRUPTED;
 	}
 
-	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmem_alloc(size, KM_NOFS);
+	xfs_iroot_alloc(ip, whichfork, size);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -356,6 +355,32 @@ xfs_iformat_attr_fork(
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
@@ -404,8 +429,7 @@ xfs_iroot_realloc(
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
-			ifp->if_broot_bytes = (int)new_size;
+			xfs_iroot_alloc(ip, whichfork, new_size);
 			return;
 		}
 
@@ -444,17 +468,15 @@ xfs_iroot_realloc(
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
@@ -478,9 +500,8 @@ xfs_iroot_realloc(
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
 
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index ebeb925be09..18ea2d27777 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
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

