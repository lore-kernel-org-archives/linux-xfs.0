Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA82D527
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9W8fEJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A483AC433C8;
	Sun, 31 Dec 2023 22:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061748;
	bh=uV5TT6Kb8m2AEQdeXe5hinuY2kAnm9+cXxGq4s6RcTE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c9W8fEJBZHO0m/gbFIh5UiD60hlZRpPJy7YuHKZKBLvi4UcauXKvHJ7RnUflfLl7c
	 NLZJzVv1n4ScZZPudBoEMMnoxNiDwuMBEJOr+rp7Tk1MJ/jaP+9flQNGT6irfT2S44
	 epvoBDCAk5lp0Hh1Mv5l7mmlDz/3uVATBuXi0b0n6esDPutdcmvpZMVUxeFMiaDth3
	 bclICRZ7MWouVVBnAdbOmJWy0XZFiZ7lvFrUiw4vPikH3pjCvmTLHimvqOxkd1ZGf2
	 oZDcN1enxFMZqMYDQsh5mT7dasaoCnGHy6hTYq6z+L1oyJU3ztn6zxQMriPvMTcpPs
	 wpI2Vo/ftH7pQ==
Date: Sun, 31 Dec 2023 14:29:08 -0800
Subject: [PATCH 08/20] xfs: condense extended attributes after an atomic swap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996381.1796128.138020942106712640.stgit@frogsfrogsfrogs>
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

Add a new swapext flag that enables us to perform post-swap processing
on file2 once we're done swapping the extent maps.  If we were swapping
the extended attributes, we want to be able to convert file2's attr fork
from block to inline format.

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online xattr repair feature can create
salvaged attrs in a temporary file and swap the attr forks when ready.
If one file is in extents format and the other is inline, we will have to
promote both to extents format to perform the swap.  After the swap, we
can try to condense the fixed file's attr fork back down to inline
format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_log_format.h |    9 ++++++--
 libxfs/xfs_swapext.c    |   51 ++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_swapext.h    |    9 ++++++--
 3 files changed, 64 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 3341792cf43..d4531060b6b 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -916,18 +916,23 @@ struct xfs_swap_extent {
 /* Clear the reflink flag from inode2 after the operation. */
 #define XFS_SWAP_EXT_CLEAR_INO2_REFLINK	(1ULL << 4)
 
+/* Try to convert inode2 from block to short format at the end, if possible. */
+#define XFS_SWAP_EXT_CVT_INO2_SF	(1ULL << 5)
+
 #define XFS_SWAP_EXT_FLAGS		(XFS_SWAP_EXT_ATTR_FORK | \
 					 XFS_SWAP_EXT_SET_SIZES | \
 					 XFS_SWAP_EXT_INO1_WRITTEN | \
 					 XFS_SWAP_EXT_CLEAR_INO1_REFLINK | \
-					 XFS_SWAP_EXT_CLEAR_INO2_REFLINK)
+					 XFS_SWAP_EXT_CLEAR_INO2_REFLINK | \
+					 XFS_SWAP_EXT_CVT_INO2_SF)
 
 #define XFS_SWAP_EXT_STRINGS \
 	{ XFS_SWAP_EXT_ATTR_FORK,		"ATTRFORK" }, \
 	{ XFS_SWAP_EXT_SET_SIZES,		"SETSIZES" }, \
 	{ XFS_SWAP_EXT_INO1_WRITTEN,		"INO1_WRITTEN" }, \
 	{ XFS_SWAP_EXT_CLEAR_INO1_REFLINK,	"CLEAR_INO1_REFLINK" }, \
-	{ XFS_SWAP_EXT_CLEAR_INO2_REFLINK,	"CLEAR_INO2_REFLINK" }
+	{ XFS_SWAP_EXT_CLEAR_INO2_REFLINK,	"CLEAR_INO2_REFLINK" }, \
+	{ XFS_SWAP_EXT_CVT_INO2_SF,		"CVT_INO2_SF" }
 
 /* This is the structure used to lay out an sxi log item in the log. */
 struct xfs_sxi_log_format {
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 5de586c6816..d643cb870c7 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -22,6 +22,10 @@
 #include "xfs_health.h"
 #include "defer_item.h"
 #include "xfs_errortag.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -110,7 +114,8 @@ static inline bool
 sxi_has_postop_work(const struct xfs_swapext_intent *sxi)
 {
 	return sxi->sxi_flags & (XFS_SWAP_EXT_CLEAR_INO1_REFLINK |
-				 XFS_SWAP_EXT_CLEAR_INO2_REFLINK);
+				 XFS_SWAP_EXT_CLEAR_INO2_REFLINK |
+				 XFS_SWAP_EXT_CVT_INO2_SF);
 }
 
 static inline void
@@ -358,6 +363,36 @@ xfs_swapext_exchange_mappings(
 	sxi_advance(sxi, irec1);
 }
 
+/* Convert inode2's leaf attr fork back to shortform, if possible.. */
+STATIC int
+xfs_swapext_attr_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_da_args	args = {
+		.dp		= sxi->sxi_ip2,
+		.geo		= tp->t_mountp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.trans		= tp,
+	};
+	struct xfs_buf		*bp;
+	int			forkoff;
+	int			error;
+
+	if (!xfs_attr_is_leaf(sxi->sxi_ip2))
+		return 0;
+
+	error = xfs_attr3_leaf_read(tp, sxi->sxi_ip2, 0, &bp);
+	if (error)
+		return error;
+
+	forkoff = xfs_attr_shortform_allfit(bp, sxi->sxi_ip2);
+	if (forkoff == 0)
+		return 0;
+
+	return xfs_attr3_leaf_to_shortform(bp, &args, forkoff);
+}
+
 static inline void
 xfs_swapext_clear_reflink(
 	struct xfs_trans	*tp,
@@ -375,6 +410,16 @@ xfs_swapext_do_postop_work(
 	struct xfs_trans		*tp,
 	struct xfs_swapext_intent	*sxi)
 {
+	if (sxi->sxi_flags & XFS_SWAP_EXT_CVT_INO2_SF) {
+		int			error = 0;
+
+		if (sxi->sxi_flags & XFS_SWAP_EXT_ATTR_FORK)
+			error = xfs_swapext_attr_to_sf(tp, sxi);
+		sxi->sxi_flags &= ~XFS_SWAP_EXT_CVT_INO2_SF;
+		if (error)
+			return error;
+	}
+
 	if (sxi->sxi_flags & XFS_SWAP_EXT_CLEAR_INO1_REFLINK) {
 		xfs_swapext_clear_reflink(tp, sxi->sxi_ip1);
 		sxi->sxi_flags &= ~XFS_SWAP_EXT_CLEAR_INO1_REFLINK;
@@ -802,6 +847,8 @@ xfs_swapext_init_intent(
 
 	if (req->req_flags & XFS_SWAP_REQ_INO1_WRITTEN)
 		sxi->sxi_flags |= XFS_SWAP_EXT_INO1_WRITTEN;
+	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
+		sxi->sxi_flags |= XFS_SWAP_EXT_CVT_INO2_SF;
 
 	if (req->req_flags & XFS_SWAP_REQ_LOGGED)
 		sxi->sxi_op_flags |= XFS_SWAP_EXT_OP_LOGGED;
@@ -1021,6 +1068,8 @@ xfs_swapext(
 	ASSERT(!(req->req_flags & ~XFS_SWAP_REQ_FLAGS));
 	if (req->req_flags & XFS_SWAP_REQ_SET_SIZES)
 		ASSERT(req->whichfork == XFS_DATA_FORK);
+	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
+		ASSERT(req->whichfork == XFS_ATTR_FORK);
 
 	if (req->blockcount == 0)
 		return;
diff --git a/libxfs/xfs_swapext.h b/libxfs/xfs_swapext.h
index fa786bc9352..37842a4ee9a 100644
--- a/libxfs/xfs_swapext.h
+++ b/libxfs/xfs_swapext.h
@@ -180,16 +180,21 @@ struct xfs_swapext_req {
 /* Files need to be upgraded to have large extent counts. */
 #define XFS_SWAP_REQ_NREXT64		(1U << 3)
 
+/* Try to convert inode2's fork to local format, if possible. */
+#define XFS_SWAP_REQ_CVT_INO2_SF	(1U << 4)
+
 #define XFS_SWAP_REQ_FLAGS		(XFS_SWAP_REQ_LOGGED | \
 					 XFS_SWAP_REQ_SET_SIZES | \
 					 XFS_SWAP_REQ_INO1_WRITTEN | \
-					 XFS_SWAP_REQ_NREXT64)
+					 XFS_SWAP_REQ_NREXT64 | \
+					 XFS_SWAP_REQ_CVT_INO2_SF)
 
 #define XFS_SWAP_REQ_STRINGS \
 	{ XFS_SWAP_REQ_LOGGED,		"LOGGED" }, \
 	{ XFS_SWAP_REQ_SET_SIZES,	"SETSIZES" }, \
 	{ XFS_SWAP_REQ_INO1_WRITTEN,	"INO1_WRITTEN" }, \
-	{ XFS_SWAP_REQ_NREXT64,		"NREXT64" }
+	{ XFS_SWAP_REQ_NREXT64,		"NREXT64" }, \
+	{ XFS_SWAP_REQ_CVT_INO2_SF,	"CVT_INO2_SF" }
 
 unsigned int xfs_swapext_reflink_prep(const struct xfs_swapext_req *req);
 void xfs_swapext_reflink_finish(struct xfs_trans *tp,

