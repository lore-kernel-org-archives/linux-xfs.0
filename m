Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA69128814
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423126; cv=none; b=nVNcjnKQkOCiypL5PQitVQK4ktMavX03LGaRkyo/i3/nBwg0/FPizA3Gu8Tb0JNN3hRrgfHssyvv0z89mKe/kyRQgXeSzrtBV4to2V4bKQh+qnqPvv0S//LtYl9/vns9myVUx/IXvLQ4wH+DBcqd0KXcfLDxRfynfNyvJy/j+7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423126; c=relaxed/simple;
	bh=bERhmcBkRXhxI8CI5jD7SkTsd0mcJdDlRnQlflJLhbc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PqDKNXsF7NwWzqwWwKgJFCpYChys488W2yY0RwtIdac67Rrltvaq6TmPACnsYNZUt/39ugwhREjJDY7zVRJauFH2hKP3oiEN7hzXp/ZLo9/x4MpbiuMEnhU1+G9dZ0HZD1nEb0eUFgv8Ab2pxqSmNzq9obpBj/C8t5NhmZJTL48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EASBAfxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EASBAfxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FB0C433F1;
	Tue, 26 Mar 2024 03:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423125;
	bh=bERhmcBkRXhxI8CI5jD7SkTsd0mcJdDlRnQlflJLhbc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EASBAfxTwr4KCEia/nMCPBydHZdd7ZtIZcOgSXPKF0Ac75EkK7G1hiu+PoXhcwgi8
	 n5HvpvYI9PWquTZmkYQCKX6ASYFf21iVEJEEms2R3x1P6gQu6f24ScjSdtdOZ8EB5F
	 9isoGU3a4yz+ORUwhmKtxMwM/zFzSYbgcEuFr/5VN7Yux0V4K8FdSD6RJE0BpM7MzJ
	 thOxVE/HIfESV3OoaCJ1BvJiDbPZXa7lL3ys/GDRoVz1JLqerIYhsP3X9h/agNAFco
	 V/sxrpLVdbpG7LTpA6DEy6ujJfpz7ld0jYS1REdU65EV0jbLb34mqjTAXKLUIzlQCA
	 pUjw9eLwUwy5Q==
Date: Mon, 25 Mar 2024 20:18:45 -0700
Subject: [PATCH 61/67] xfs: remove xfs_attr_sf_hdr_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127837.2212320.2681676124137587652.stgit@frogsfrogsfrogs>
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

Source kernel commit: 074aea4be1a4074be49a7ec41c674cc02b52fd60

Remove the last two users of the typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/attrshort.c         |    2 +-
 libxfs/xfs_attr_leaf.c |    4 ++--
 libxfs/xfs_attr_sf.h   |    8 --------
 repair/attr_repair.c   |    6 +++---
 repair/dinode.c        |    4 ++--
 5 files changed, 8 insertions(+), 16 deletions(-)


diff --git a/db/attrshort.c b/db/attrshort.c
index c98b90be3ec0..7c386d46f88f 100644
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
index cf172b6ea4ab..e3f8f67b5195 100644
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
index 9abf7de95465..bc4422223024 100644
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
index 31c50c127d41..01e4afb90d5c 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -222,14 +222,14 @@ process_shortform_attr(
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
@@ -240,7 +240,7 @@ process_shortform_attr(
 			}
 		}
 
-	currentsize = sizeof(xfs_attr_sf_hdr_t);
+	currentsize = sizeof(struct xfs_attr_sf_hdr);
 	remainingspace = be16_to_cpu(hdr->totsize) - currentsize;
 	nextentry = libxfs_attr_sf_firstentry(hdr);
 	for (i = 0; i < hdr->count; i++)  {
diff --git a/repair/dinode.c b/repair/dinode.c
index 636e753fc744..164f51d4c4fc 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1014,11 +1014,11 @@ process_lclinode(
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

