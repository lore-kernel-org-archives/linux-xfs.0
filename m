Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5222110E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299152; cv=none; b=gJRhij4l8k7Fdr7mtCMZFTQboIcRKRX8dL5hZzoGJYdLM7AY3d0A/B2CxxjMxNhjpiJRN5XpQs+Ssd4Ow5FZ2wt1ohr9O+9kCc9PH+mM2w/+urFLQUqZR2S14443/pwvhg8OUKeWCkdcLknp7Ma2qNmsvOQX01SK9xC5xBNpP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299152; c=relaxed/simple;
	bh=xHade0oEwlt7qy+CUpAwlI7jrhVVf5nfqOrNoxd39k8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oTuV4EB1eoiUY3GO6yE3Vj24U+t9+bbClr6H/wz6LiFJv8lgQuQkdalZ+2qg2SGq16bDEIYti2ibgzbw0viy2CCxPSHgrF3noY9GgNmGQfJbVcF9wDhbGrd3OL5UK2xISOqFjcsYpHyPvX5NaKDMl+8OPHjRFUBGzlW5Bao7KmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umk75NU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umk75NU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2CEC32786;
	Tue, 30 Jul 2024 00:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299152;
	bh=xHade0oEwlt7qy+CUpAwlI7jrhVVf5nfqOrNoxd39k8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=umk75NU79vqYVvlDlJJdxvM4/2YDtIv7rrZ1Qx+IXa5EmWXfG0P8X5mLIqF4Ekrxf
	 RhYNIm/Gnub51j8U1b+5rOGY/et3ug2jENzDcqqh/7Ukdiu25L6jn21opGRWLY7EmU
	 awJX2rScmWECnUb6uZcDBssKJwzRHDViUJFnyHf0yVs2E9yJLxMV0Sn20/pBt5iEar
	 UygYLBTzLbiu4MOM/IiahhJkRLBeslhmC+L41MsM2xf/oVsqbOK0gIe9peaeY8eRWy
	 VrT5+nCUjxYzwgkT1tvC6BQ/L1EMfb5Sf/cu/jJ5lc2Tf7miCPsc0vdrCvwUEWcdfY
	 t7wivpeTgNxhA==
Date: Mon, 29 Jul 2024 17:25:51 -0700
Subject: [PATCH 008/115] xfs: condense extended attributes after a mapping
 exchange operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842555.1338752.7642064315901500418.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 497d7a2608f8b7329e92bdaaf745ca127a582ad9

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_exchmaps.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_exchmaps.h |    5 +++++
 2 files changed, 56 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index ef30d0b27..afe2c2d22 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -21,6 +21,10 @@
 #include "xfs_errortag.h"
 #include "xfs_health.h"
 #include "defer_item.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr.h"
 
 struct kmem_cache	*xfs_exchmaps_intent_cache;
 
@@ -118,7 +122,8 @@ static inline bool
 xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
 {
 	return xmi->xmi_flags & (XFS_EXCHMAPS_CLEAR_INO1_REFLINK |
-				 XFS_EXCHMAPS_CLEAR_INO2_REFLINK);
+				 XFS_EXCHMAPS_CLEAR_INO2_REFLINK |
+				 __XFS_EXCHMAPS_INO2_SHORTFORM);
 }
 
 /* Check all mappings to make sure we can actually exchange them. */
@@ -357,6 +362,36 @@ xfs_exchmaps_one_step(
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
@@ -375,6 +410,16 @@ xfs_exchmaps_do_postop_work(
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
@@ -806,8 +851,10 @@ xfs_exchmaps_init_intent(
 	xmi->xmi_isize1 = xmi->xmi_isize2 = -1;
 	xmi->xmi_flags = req->flags & XFS_EXCHMAPS_PARAMS;
 
-	if (xfs_exchmaps_whichfork(xmi) == XFS_ATTR_FORK)
+	if (xfs_exchmaps_whichfork(xmi) == XFS_ATTR_FORK) {
+		xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
 		return xmi;
+	}
 
 	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
 		xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
@@ -1028,6 +1075,8 @@ xfs_exchange_mappings(
 {
 	struct xfs_exchmaps_intent	*xmi;
 
+	BUILD_BUG_ON(XFS_EXCHMAPS_INTERNAL_FLAGS & XFS_EXCHMAPS_LOGGED_FLAGS);
+
 	xfs_assert_ilocked(req->ip1, XFS_ILOCK_EXCL);
 	xfs_assert_ilocked(req->ip2, XFS_ILOCK_EXCL);
 	ASSERT(!(req->flags & ~XFS_EXCHMAPS_LOGGED_FLAGS));
diff --git a/libxfs/xfs_exchmaps.h b/libxfs/xfs_exchmaps.h
index e8fc3f80c..d8718fca6 100644
--- a/libxfs/xfs_exchmaps.h
+++ b/libxfs/xfs_exchmaps.h
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

