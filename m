Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C171442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801719; cv=none; b=EEWXnjX7d9LBuWEnL+4L/3502mCNsPVdsfC5TDC++mJfUKYfjh5z0kPnNow4I7pnigpFerlBijl+Elin2knOENFdjb2q8NVWiPNLlIWWOzFlL2uYTuqDPeIFa28Xp9VM8uqDtnvCclvdKrCCVJ4oJzXYdWuMnKhrQOUcvqvZHec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801719; c=relaxed/simple;
	bh=lMul9wEff8qXvkbEiaR0UXVL01bDA+5yh7IDRwJHbvc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uR4tK4LL6AgYI71WpilMp3QHHHFycJnev6fwFate//VTw6pWGZAppB593yrDbRRnyjP2IcFt31RwQQfz4hsB8MbKYfkLPvkr/3IfQ/ICfsMD9heADwbxWdGJGhe2VZiYPtb8zeIEeIhKQiuD4IOO00rA6uihad63PBlc6cGyDUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQjtfhhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQjtfhhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D4CC56740;
	Tue, 27 Aug 2024 23:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801718;
	bh=lMul9wEff8qXvkbEiaR0UXVL01bDA+5yh7IDRwJHbvc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iQjtfhhudjLFkB7xg/DFK3yrOyHx/9b6pQRQSZ9uF6Fw4MmPSN1+kyVQAPq5KvA/p
	 6A9YeJw1kYPehCFtTR7m5kH4QlIRsb7c8YdVegiDrROZQH+arTeVEUNoALxVsc2/C/
	 ipgcGIzVgKDOJTln7sLlLy/q5/y5nYy6GWRcwV3hZk+vShmgRHpIdMp4701SEHlXwD
	 zhO0r/lXDrDL1oW1Tmav9VTq2H8x1ZzFOSZTMt5bIgfI7gJplVKR1a+ZhJJmuXDjRD
	 +WycuwoZXcma7tpyaCVRLkuz2lL+nNQ6E04guN660FoC5fO6Kh2LPZcNnLqG9xvCHd
	 wqluw73+fi5Gw==
Date: Tue, 27 Aug 2024 16:35:17 -0700
Subject: [PATCH 06/10] xfs: refactor the allocation and freeing of incore
 inode fork btree roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172480131609.2291268.5922161016077004451.stgit@frogsfrogsfrogs>
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_inode_fork.c |   39 ++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_inode_fork.h |    3 +++
 2 files changed, 33 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index acb1e9cc45b76..60646a6c32ec7 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -211,9 +211,7 @@ xfs_iformat_btree(
 		return -EFSCORRUPTED;
 	}
 
-	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmalloc(size,
-				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+	xfs_iroot_alloc(ip, whichfork, size);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -362,6 +360,33 @@ xfs_iformat_attr_fork(
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
+	ifp->if_broot = kmalloc(bytes,
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
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
+	kfree(ifp->if_broot);
+	ifp->if_broot = NULL;
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
@@ -410,9 +435,7 @@ xfs_iroot_realloc(
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			ifp->if_broot = kmalloc(new_size,
-						GFP_KERNEL | __GFP_NOFAIL);
-			ifp->if_broot_bytes = (int)new_size;
+			xfs_iroot_alloc(ip, whichfork, new_size);
 			return;
 		}
 
@@ -450,9 +473,7 @@ xfs_iroot_realloc(
 
 	new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	if (new_size == 0) {
-		kfree(ifp->if_broot);
-		ifp->if_broot = NULL;
-		ifp->if_broot_bytes = 0;
+		xfs_iroot_free(ip, whichfork);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 2373d12fd474f..3f228a00b67dd 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -170,6 +170,9 @@ void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 void		xfs_idestroy_fork(struct xfs_ifork *ifp);
 void *		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
+void		xfs_iroot_alloc(struct xfs_inode *ip, int whichfork,
+				size_t bytes);
+void		xfs_iroot_free(struct xfs_inode *ip, int whichfork);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,

