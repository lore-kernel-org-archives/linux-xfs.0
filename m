Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF51FC0C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000578; cv=none; b=RT51jKyGiAEnTh9bTpku/2onrC1dgpzVhL/jJPdb++66/KaCO1opC4xE0GXHgmfcl+tagyJanMzSx0qVHwj8nksUa6f/HYHg97c5UAwvJG0jG8KMeKIWffIrwMHR2E2hBQqP7CNWQ/EsTTj2qV8k7jfvQNg1TqdQG576h1L8QWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000578; c=relaxed/simple;
	bh=M1zgPj8tzQKSsl/BJTMjQyhYrKKmahRv18U7YUjW738=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g0ZmbEHKG1VDTvSQ5s/w3dGp7tIz+eX8wlsn4I+iEvEddLRviY7/ZKlS7WZpXKs8raS+m3Bx5gksUhJoFfTzOMiikGLQYueVt5fyBWUjVdzBKvD/QC8ylC2E+B8F0PhJE1aOx9qZK+JVFnrLiTDmA0amtWDNhiGWVLCgE/yC4as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nVtM3csD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVtM3csD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8C2C433F1;
	Tue, 27 Feb 2024 02:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000577;
	bh=M1zgPj8tzQKSsl/BJTMjQyhYrKKmahRv18U7YUjW738=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nVtM3csDWAy91xqCxOLriisfM5fa9INJmxN+DjPQBZ4rkTgBp9S423yRm6AwDHYc0
	 Mz1txpzKcTgss0qhctX3xACKX/AtUnJANOqShLSqiPhWVXrx0ih0I8e6C1YFhWNROa
	 7v/dOd6LfzqCaE7yXBqrUer6u3y+TyD3yaNCpMY3T8INlrTUPBDddAhSiota04mamb
	 H/Fob5pJmRA6vBjaTvzNnE8WljqvnnZ+8AFhqxvWTV4plSt5YeNfv88f0+pHDYnG3f
	 gCWUEPmYUcHI7njpWZa25dHBwBAWRolbS6kQYYb4JbpToPQHqY/tflqHxErVdCjNLf
	 e59GA6kHR6Png==
Date: Mon, 26 Feb 2024 18:22:57 -0800
Subject: [PATCH 08/14] xfs: condense extended attributes after a mapping
 exchange operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011774.938268.18374557632879056571.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
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

Add a new file mapping exchange flag that enables us to perform
post-exchange processing on file2 once we're done exchanging the extent
mappings.  If we were swapping mappings between extended attribute
forks, we want to be able to convert file2's attr fork from block to
inline format.

(This implies that all fork contents are exchanged.)

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online xattr repair feature can create
salvaged attrs in a temporary file and exchange the attr fork mappings
when ready.  If one file is in extents format and the other is inline,
we will have to promote both to extents format to perform the exchange.
After the exchange, we can try to condense the fixed file's attr fork
back down to inline format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_exchmaps.c |   53 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_exchmaps.h |    5 ++++
 fs/xfs/xfs_trace.h           |    3 ++
 3 files changed, 58 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 228eb15fce212..a2af9ecfe4b01 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -24,6 +24,10 @@
 #include "xfs_errortag.h"
 #include "xfs_health.h"
 #include "xfs_exchmaps_item.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr.h"
 
 struct kmem_cache	*xfs_exchmaps_intent_cache;
 
@@ -121,7 +125,8 @@ static inline bool
 xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
 {
 	return xmi->xmi_flags & (XFS_EXCHMAPS_CLEAR_INO1_REFLINK |
-				 XFS_EXCHMAPS_CLEAR_INO2_REFLINK);
+				 XFS_EXCHMAPS_CLEAR_INO2_REFLINK |
+				 __XFS_EXCHMAPS_INO2_SHORTFORM);
 }
 
 /* Check all mappings to make sure we can actually exchange them. */
@@ -360,6 +365,36 @@ xfs_exchmaps_one_step(
 	xmi_advance(xmi, irec1);
 }
 
+/* Convert inode2's leaf attr fork back to shortform, if possible.. */
+STATIC int
+xfs_exchmaps_attr_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi)
+{
+	struct xfs_da_args	args = {
+		.dp		= xmi->xmi_ip2,
+		.geo		= tp->t_mountp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.trans		= tp,
+	};
+	struct xfs_buf		*bp;
+	int			forkoff;
+	int			error;
+
+	if (!xfs_attr_is_leaf(xmi->xmi_ip2))
+		return 0;
+
+	error = xfs_attr3_leaf_read(tp, xmi->xmi_ip2, 0, &bp);
+	if (error)
+		return error;
+
+	forkoff = xfs_attr_shortform_allfit(bp, xmi->xmi_ip2);
+	if (forkoff == 0)
+		return 0;
+
+	return xfs_attr3_leaf_to_shortform(bp, &args, forkoff);
+}
+
 /* Clear the reflink flag after an exchange. */
 static inline void
 xfs_exchmaps_clear_reflink(
@@ -378,6 +413,16 @@ xfs_exchmaps_do_postop_work(
 	struct xfs_trans		*tp,
 	struct xfs_exchmaps_intent	*xmi)
 {
+	if (xmi->xmi_flags & __XFS_EXCHMAPS_INO2_SHORTFORM) {
+		int			error = 0;
+
+		if (xmi->xmi_flags & XFS_EXCHMAPS_ATTR_FORK)
+			error = xfs_exchmaps_attr_to_sf(tp, xmi);
+		xmi->xmi_flags &= ~__XFS_EXCHMAPS_INO2_SHORTFORM;
+		if (error)
+			return error;
+	}
+
 	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO1_REFLINK) {
 		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip1);
 		xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
@@ -795,8 +840,10 @@ xfs_exchmaps_init_intent(
 	xmi->xmi_isize1 = xmi->xmi_isize2 = -1;
 	xmi->xmi_flags = req->flags & XFS_EXCHMAPS_PARAMS;
 
-	if (xfs_exchmaps_whichfork(xmi) == XFS_ATTR_FORK)
+	if (xfs_exchmaps_whichfork(xmi) == XFS_ATTR_FORK) {
+		xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
 		return xmi;
+	}
 
 	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
 		xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
@@ -1017,6 +1064,8 @@ xfs_exchange_mappings(
 {
 	struct xfs_exchmaps_intent	*xmi;
 
+	BUILD_BUG_ON(XFS_EXCHMAPS_INTERNAL_FLAGS & XFS_EXCHMAPS_LOGGED_FLAGS);
+
 	ASSERT(xfs_isilocked(req->ip1, XFS_ILOCK_EXCL));
 	ASSERT(xfs_isilocked(req->ip2, XFS_ILOCK_EXCL));
 	ASSERT(!(req->flags & ~XFS_EXCHMAPS_LOGGED_FLAGS));
diff --git a/fs/xfs/libxfs/xfs_exchmaps.h b/fs/xfs/libxfs/xfs_exchmaps.h
index e8fc3f80c68c2..d8718fca606e5 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.h
+++ b/fs/xfs/libxfs/xfs_exchmaps.h
@@ -27,6 +27,11 @@ struct xfs_exchmaps_intent {
 	uint64_t		xmi_flags;	/* XFS_EXCHMAPS_* flags */
 };
 
+/* Try to convert inode2 from block to short format at the end, if possible. */
+#define __XFS_EXCHMAPS_INO2_SHORTFORM	(1ULL << 63)
+
+#define XFS_EXCHMAPS_INTERNAL_FLAGS	(__XFS_EXCHMAPS_INO2_SHORTFORM)
+
 /* flags that can be passed to xfs_exchmaps_{estimate,mappings} */
 #define XFS_EXCHMAPS_PARAMS		(XFS_EXCHMAPS_ATTR_FORK | \
 					 XFS_EXCHMAPS_SET_SIZES | \
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3929022b03cfe..d6666aa6a9529 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4799,7 +4799,8 @@ DEFINE_XFBTREE_FREESP_EVENT(xfbtree_free_block);
 	{ XFS_EXCHMAPS_SET_SIZES,		"SETSIZES" }, \
 	{ XFS_EXCHMAPS_INO1_WRITTEN,		"INO1_WRITTEN" }, \
 	{ XFS_EXCHMAPS_CLEAR_INO1_REFLINK,	"CLEAR_INO1_REFLINK" }, \
-	{ XFS_EXCHMAPS_CLEAR_INO2_REFLINK,	"CLEAR_INO2_REFLINK" }
+	{ XFS_EXCHMAPS_CLEAR_INO2_REFLINK,	"CLEAR_INO2_REFLINK" }, \
+	{ __XFS_EXCHMAPS_INO2_SHORTFORM,	"INO2_SF" }
 
 DEFINE_INODE_IREC_EVENT(xfs_exchmaps_mapping1_skip);
 DEFINE_INODE_IREC_EVENT(xfs_exchmaps_mapping1);

