Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1A115381E
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804040; cv=none; b=dWBpzaKe71Z2mTMmshnOU0nrww833L/bAZJf3c06tmqVWr5CoPR583oaIRJrVAOS/u1JkYIhaotNWe0LPQhOb/JIlXWTe8NvTnRGi1Fm/4Tde5iRShXsnd4PtBroTtpJOdKiFSEK9cMQTPV+uIAbKJNNycCP+NH3jgarF04U6CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804040; c=relaxed/simple;
	bh=0KEXvLgylqoJ81b4/0NMS259VN31vqag+i5G/AHx5tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya59E0miG9xKMJ3ptmKYUT0k9QLLKrioUqPfg+0dXHcatFc0q8v9uKTbCsdmaqu7jc8xq4XXfVry2T817/ogL2/yOeX6KQ7asVIcROiSnyZoOS7RZfW2MxTHvdWInnk3Hu+YS1flHL6IkdPbBwEABuiRwWLveRSo+TMNhB3GEYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXeqklei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXeqklei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F1EC116B1;
	Mon, 22 Apr 2024 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804040;
	bh=0KEXvLgylqoJ81b4/0NMS259VN31vqag+i5G/AHx5tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXeqkleiR4ATqEuA+598qImTcVz0aTrOotPVLaJA8uObb5MtOHbMVu+FRVqTdK2Sw
	 yNqfhH/VM6S5+NBS0AxUeGKaqP+lHdgEt2zXkOpYdsb0cEqIERyHVQs5pAnarvoxIQ
	 FNTjo6oFkOqfctWxxnPC+ZiCcXZ1nnwpZ00Ihf5TUUrw7wRD3VWIH2qB1cUUNG107U
	 Y6pz9LGFi1uTFOZ99IET7GXE/pW44HZ8bu8CSS7PCI+pwjw37BOEyk3o/yVF5N6KZA
	 gpoaAOVkAqNlPKWO+g2AkeS2FQJRwYoFJ4QPqr8e/CW4pPqaraGTHiPZEBDwApD3oZ
	 JwrBGJPgnOlCw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 61/67] xfs: remove xfs_attr_sf_hdr_t
Date: Mon, 22 Apr 2024 18:26:23 +0200
Message-ID: <20240422163832.858420-63-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 074aea4be1a4074be49a7ec41c674cc02b52fd60

Remove the last two users of the typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 db/attrshort.c         | 2 +-
 libxfs/xfs_attr_leaf.c | 4 ++--
 libxfs/xfs_attr_sf.h   | 8 --------
 repair/attr_repair.c   | 6 +++---
 repair/dinode.c        | 6 +++---
 5 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/db/attrshort.c b/db/attrshort.c
index c98b90be3..7c386d46f 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -25,7 +25,7 @@ const field_t	attr_shortform_flds[] = {
 	{ NULL }
 };
 
-#define	HOFF(f)	bitize(offsetof(xfs_attr_sf_hdr_t, f))
+#define	HOFF(f)	bitize(offsetof(struct xfs_attr_sf_hdr, f))
 const field_t	attr_sf_hdr_flds[] = {
 	{ "totsize", FLDT_UINT16D, OI(HOFF(totsize)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT8D, OI(HOFF(count)), C1, 0, TYP_NONE },
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index cf172b6ea..e3f8f67b5 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -813,7 +813,7 @@ xfs_attr_sf_removename(
 	/*
 	 * Fix up the start offset of the attribute fork
 	 */
-	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
+	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
 		xfs_attr_fork_remove(dp, args->trans);
@@ -821,7 +821,7 @@ xfs_attr_sf_removename(
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 		dp->i_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
 		ASSERT(dp->i_forkoff);
-		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
+		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
 				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index 9abf7de95..bc4422223 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -6,14 +6,6 @@
 #ifndef __XFS_ATTR_SF_H__
 #define	__XFS_ATTR_SF_H__
 
-/*
- * Attribute storage when stored inside the inode.
- *
- * Small attribute lists are packed as tightly as possible so as
- * to fit into the literal area of the inode.
- */
-typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
-
 /*
  * We generate this then sort it, attr_list() must return things in hash-order.
  */
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index b65b28a20..0d22feb4f 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -224,14 +224,14 @@ process_shortform_attr(
 	*/
 	if (hdr->count == 0)
 		/* then the total size should just be the header length */
-		if (be16_to_cpu(hdr->totsize) != sizeof(xfs_attr_sf_hdr_t)) {
+		if (be16_to_cpu(hdr->totsize) != sizeof(struct xfs_attr_sf_hdr)) {
 			/* whoops there's a discrepancy. Clear the hdr */
 			if (!no_modify) {
 				do_warn(
 	_("there are no attributes in the fork for inode %" PRIu64 "\n"),
 					ino);
 				hdr->totsize =
-					cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
+					cpu_to_be16(sizeof(struct xfs_attr_sf_hdr));
 				*repair = 1;
 				return(1);
 			} else {
@@ -242,7 +242,7 @@ process_shortform_attr(
 			}
 		}
 
-	currentsize = sizeof(xfs_attr_sf_hdr_t);
+	currentsize = sizeof(struct xfs_attr_sf_hdr);
 	remainingspace = be16_to_cpu(hdr->totsize) - currentsize;
 	nextentry = libxfs_attr_sf_firstentry(hdr);
 	for (i = 0; i < hdr->count; i++)  {
diff --git a/repair/dinode.c b/repair/dinode.c
index f4398c0df..cc3f07dda 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -100,7 +100,7 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
 	if (!no_modify) {
 		struct xfs_attr_sf_hdr *hdr = XFS_DFORK_APTR(dino);
-		hdr->totsize = cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
+		hdr->totsize = cpu_to_be16(sizeof(struct xfs_attr_sf_hdr));
 		hdr->count = 0;
 		dino->di_forkoff = 0;  /* got to do this after hdr is set */
 	}
@@ -1009,11 +1009,11 @@ process_lclinode(
 				XFS_DFORK_ASIZE(dip, mp));
 			return(1);
 		}
-		if (be16_to_cpu(hdr->totsize) < sizeof(xfs_attr_sf_hdr_t)) {
+		if (be16_to_cpu(hdr->totsize) < sizeof(struct xfs_attr_sf_hdr)) {
 			do_warn(
 	_("local inode %" PRIu64 " attr too small (size = %d, min size = %zd)\n"),
 				lino, be16_to_cpu(hdr->totsize),
-				sizeof(xfs_attr_sf_hdr_t));
+				sizeof(struct xfs_attr_sf_hdr));
 			return(1);
 		}
 	}
-- 
2.44.0

