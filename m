Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379D5BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwIUgatp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4A2C433C8;
	Sun, 31 Dec 2023 20:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054583;
	bh=aqsUycNL0VlnPnh1K3BR4wXYbg/AKDJW1F5dJ4tHhfY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KwIUgatp8yrdpZds+Fpepsb5DpG0qEe8OFfipBy+Z8Sk/pQ8xeClmRNb+luEv+aKD
	 z4UNwvb4bcOI5UP1NeMyC0bf2vN9ErCijKdYYA60Kuh8QxivfODjoYCHj+xs0kiGm+
	 mBzMXwNJFJW+bb1GSwoFbNTjLParF7c/rLOTEY7XitQXGjzPm8lhfDrfBKMzc16UKK
	 XXKbPlnz+MXtqandkq4k3y3Uc1e/DMEwy5uk8+nk1NX8juTRdjm2ZeqQlIuUxPMNOB
	 vRElJlCVCfygZ2Wo9zEu+eaqIPwiJBM3v774NgSDkH1NfnslgLBBFakoPQ28g8o0Yt
	 Hvrl0F4qMF4AA==
Date: Sun, 31 Dec 2023 12:29:43 -0800
Subject: [PATCH 21/25] xfs: condense directories after an atomic swap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833478.1750288.1071012670058055167.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_swapext.c |   44 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 8e729fffb99df..06c5fffec6423 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -28,6 +28,8 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -395,6 +397,42 @@ xfs_swapext_attr_to_sf(
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
@@ -417,6 +455,8 @@ xfs_swapext_do_postop_work(
 
 		if (sxi->sxi_flags & XFS_SWAP_EXT_ATTR_FORK)
 			error = xfs_swapext_attr_to_sf(tp, sxi);
+		else if (S_ISDIR(VFS_I(sxi->sxi_ip2)->i_mode))
+			error = xfs_swapext_dir_to_sf(tp, sxi);
 		sxi->sxi_flags &= ~XFS_SWAP_EXT_CVT_INO2_SF;
 		if (error)
 			return error;
@@ -1071,7 +1111,9 @@ xfs_swapext(
 	if (req->req_flags & XFS_SWAP_REQ_SET_SIZES)
 		ASSERT(req->whichfork == XFS_DATA_FORK);
 	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
-		ASSERT(req->whichfork == XFS_ATTR_FORK);
+		ASSERT(req->whichfork == XFS_ATTR_FORK ||
+		       (req->whichfork == XFS_DATA_FORK &&
+			S_ISDIR(VFS_I(req->ip2)->i_mode)));
 
 	if (req->blockcount == 0)
 		return;

