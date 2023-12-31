Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49ACC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVFMHwn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70408C433C8;
	Sun, 31 Dec 2023 22:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061764;
	bh=dWoZ9ckEp86/XZB2rt40VHweOj/F4QMaiz4U0stIgnQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TVFMHwn7X2CbPUiiNGZ2j5FwKavTAYTakdXWryQkf2fl5FSGzpnwUC3GOnbYljMjs
	 PIhUD/jdNLX0fpW5jqnDkaD2lHq2xDlF3fp1Cp3dWXkg0Zk/DDqlrz/HmkBSd0Pyhc
	 yd74lW29iMkd1JjrLx9CKqnzPKRCUj/Ixq7G/bTOFvYKPIQ1YZjqXxdu9mhj7S8xAe
	 0weQu4gcD2cIeQiGXi5GE6h+7nKcZ2uD/sLTpb7cZDQYGpJh4oDkmEkFEFKUF8Ug3i
	 A6qqemM41W3d4XPoWW7nmSnj461Etojmfn5OUOljMGVq+E/7FhCX5q0bHsjJfiOAGb
	 3j7iQpVyF8KGw==
Date: Sun, 31 Dec 2023 14:29:23 -0800
Subject: [PATCH 09/20] xfs: condense directories after an atomic swap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996395.1796128.8047856963725448892.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

The previous commit added a new swapext flag that enables us to perform
post-swap processing on file2 once we're done swapping the extent maps.
Now add this ability for directories.

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online directory repair feature can
create salvaged dirents in a temporary directory and swap the data forks
when ready.  If one file is in extents format and the other is inline,
we will have to promote both to extents format to perform the swap.
After the swap, we can try to condense the fixed directory down to
inline format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_swapext.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index d643cb870c7..c5d404cfa56 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -26,6 +26,8 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -393,6 +395,42 @@ xfs_swapext_attr_to_sf(
 	return xfs_attr3_leaf_to_shortform(bp, &args, forkoff);
 }
 
+/* Convert inode2's block dir fork back to shortform, if possible.. */
+STATIC int
+xfs_swapext_dir_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_da_args	args = {
+		.dp		= sxi->sxi_ip2,
+		.geo		= tp->t_mountp->m_dir_geo,
+		.whichfork	= XFS_DATA_FORK,
+		.trans		= tp,
+	};
+	struct xfs_dir2_sf_hdr	sfh;
+	struct xfs_buf		*bp;
+	bool			isblock;
+	int			size;
+	int			error;
+
+	error = xfs_dir2_isblock(&args, &isblock);
+	if (error)
+		return error;
+
+	if (!isblock)
+		return 0;
+
+	error = xfs_dir3_block_read(tp, sxi->sxi_ip2, &bp);
+	if (error)
+		return error;
+
+	size = xfs_dir2_block_sfsize(sxi->sxi_ip2, bp->b_addr, &sfh);
+	if (size > xfs_inode_data_fork_size(sxi->sxi_ip2))
+		return 0;
+
+	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
+}
+
 static inline void
 xfs_swapext_clear_reflink(
 	struct xfs_trans	*tp,
@@ -415,6 +453,8 @@ xfs_swapext_do_postop_work(
 
 		if (sxi->sxi_flags & XFS_SWAP_EXT_ATTR_FORK)
 			error = xfs_swapext_attr_to_sf(tp, sxi);
+		else if (S_ISDIR(VFS_I(sxi->sxi_ip2)->i_mode))
+			error = xfs_swapext_dir_to_sf(tp, sxi);
 		sxi->sxi_flags &= ~XFS_SWAP_EXT_CVT_INO2_SF;
 		if (error)
 			return error;
@@ -1069,7 +1109,9 @@ xfs_swapext(
 	if (req->req_flags & XFS_SWAP_REQ_SET_SIZES)
 		ASSERT(req->whichfork == XFS_DATA_FORK);
 	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
-		ASSERT(req->whichfork == XFS_ATTR_FORK);
+		ASSERT(req->whichfork == XFS_ATTR_FORK ||
+		       (req->whichfork == XFS_DATA_FORK &&
+			S_ISDIR(VFS_I(req->ip2)->i_mode)));
 
 	if (req->blockcount == 0)
 		return;

