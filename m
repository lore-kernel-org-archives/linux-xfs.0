Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32EEC14F
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295737; cv=none; b=HE8WXIMGd+5A3HoS267QVc+M4hTjc9nHdtkMUdEHy7U5qfZLhANKgvLEUkoWzutD74YQUe7q+KPIk692ZQltpSfyzpQ4TxqOHIfAxVAxgHX9TFoxb5DcX63b0Tluf555ZnheVWpZ0UOuKJBRFK8SfatHjKeEZQGMiJXFQEThvM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295737; c=relaxed/simple;
	bh=UutiBFRJ8CWIySPlNN/mdsduMD8h0dLf8Er/+yK6SXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9x8VP6GMAZVZmtlJq/13WDqJ1tf5j2GEjZ3rdclEZ+TR2qRf+bSpuOBgG/M5OswolKKgyOdLI12lxZg1pEr946DI/91hN1r43CChjZyp6xrU1eTvEY1sJCrqG/uAFDVNjgJ+se+kyePWKpqnFxrOhxLAXy8SHU38EmdwcSTLbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbCw2E/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbCw2E/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA024C433B1;
	Wed, 13 Mar 2024 02:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295736;
	bh=UutiBFRJ8CWIySPlNN/mdsduMD8h0dLf8Er/+yK6SXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gbCw2E/f6ZAUXHywtxm2MLpZUkbaO/R2TAC3iK90AxjmXVCxCHm14hpnLE1YQVvSd
	 S18gEJKEToGYDg5Mul3OqXo3RPBzmfYrrWAvD4VKUnMNp9gTL1mgMOCGHC9fO3x9El
	 XyigTRHz9n0SVpdfjebQlYUx7sv9sTOqT7isctwwpIqcdLFVY/YFjq74N6taYoQC+r
	 LhToVIw6NO+rauJpKikXZqYiyLtGX1GczbcQm+RtJOJICeCXlU2GODDW9OKGRDjctN
	 S6wBmgctEDKCHPAHq0B1kD1Dow7XsEIFja2qyxN/h9Jzl/fkrEJ0D4ucJbcOZs8Vg1
	 eM5w4cEECUsgQ==
Date: Tue, 12 Mar 2024 19:08:56 -0700
Subject: [PATCH 61/67] xfs: remove xfs_attr_sf_hdr_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029432075.2061787.15988267555200998016.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

