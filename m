Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42439651AF
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389862; cv=none; b=a2gs5ToaXNsYqHHi5wChgZCCv5eNS3Fg17C91/x3UXwV3hEdxz1y4Nf9MKGudsE4cznfzklNuNr0mzCr0Vgsu4iMF1vnP2iad4/WTCvFXdi7nM5lwjuOjshWZiMgkbibFA9R9Wsy5JCDqwtGLN6eCfqolEfw6o6hqq28su/aIX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389862; c=relaxed/simple;
	bh=BKXE5amKownAiUn6MJEXBIwYdqujbH/DGhHolRaW8fg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hUlvvFtU/3fEuZOFFDstVCHqRwS374eWvuKDlB09XEOF7qRDAM8TexB7jC1Cl6htHPcPZPvzneqykuxAX0Hpo8emhe+tOhcFzholnYX00KLf6bz4ESTdVb8r7UD5PDK3PajRzq9ZjEg+QQ9zJ6jnH7NnunwVvZokM9JwgMy/uQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0XQN9Gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0XQN9Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A852C072AA;
	Wed, 17 Apr 2024 21:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389862;
	bh=BKXE5amKownAiUn6MJEXBIwYdqujbH/DGhHolRaW8fg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g0XQN9GgBjGc6O5R13AHIo6HORIf86MIlp9cwzbkTxm7qqGEKHR10z4w1V9Tp4pTP
	 DkbvcDGft3Mf068kj8O4G1ZWO9ie0f6vl0A07szbJEh5BgX4eWjEXHnAmKre7tkqVm
	 9Af64xgCAvyYS8xyrK2jh5Glf8raHu/o0N0HbQe+a34Mi+ba+l8dij7vHRbNGv4UoI
	 4wWnF1OJdGtzsFD4pPZcO6pkjc8TGgc+OyjnI80+udONmu4DcDnQCHA4DdMv25dGb/
	 0EkKllXsUQD9oLQXLrOMThngvExRjlfk4Z5SLHTamz5YAvfAOAOMdAadnO2mYH5gvE
	 Ekqh5fcw35cGQ==
Date: Wed, 17 Apr 2024 14:37:41 -0700
Subject: [PATCH 61/67] xfs: remove xfs_attr_sf_hdr_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843256.1853449.15185441049129435460.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
index 31c50c127..01e4afb90 100644
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
index 636e753fc..164f51d4c 100644
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

