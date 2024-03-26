Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C521353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424739; cv=none; b=UuenqMWmGwgfxPLZXHe45OTQg/U60z91MWpImuIh6KBoEQ/nvlqFkrBzCxHdz738KvYAuOGkDAgrLeJ/bpsTp00CONvHDJdvaj3YcgMIrkbJSDKujwMb5aG7b2GmzAtwrJk4KLgUd584x2qF+906VjDGR6ejGZ3RUHw7DdmSr7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424739; c=relaxed/simple;
	bh=lAqgy7GZ7Ro98uxAxs5a2RDV2SeyvpqS4cXO6VlJ+ik=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H34YsmY5yfJOuH5mHq0C4aIUjPcY0MxpM3odVA3/O7E+Nrb5DpAGtkMfm3RCoucU+9aq+cfznPF0IbkWR1gLaegUUKdPIsXb5a4Qr+Ml1lmQDh/RPsvC0wsZaVn7xbssRLbBgZnrTZywbYiviVXtH7nxGDBSfgOkesEIeHpTZjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mn54TstT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mn54TstT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD6DC433F1;
	Tue, 26 Mar 2024 03:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424739;
	bh=lAqgy7GZ7Ro98uxAxs5a2RDV2SeyvpqS4cXO6VlJ+ik=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Mn54TstTVqsJaJpEi7NwJfgw9CvWj3BzGViKto2QuNul1HwXIDE+Xt51vQBF7BoBk
	 G1ULf+l6g9wQjYmeL73C9R5wNSGUnbPzecH2t85rkh/mWGGB4bI8M1C33owPkghyaK
	 pcV8uPPFq8ElbFK4ElY9IMBTHnC1hzSBSapvdN6Zep/mbQENtoHzlNsbcuo7m9YUKg
	 /vPP0mp8YPtp553H5UeuI3QkT0BqgWhWZ1kzZNr8CKDH1ciBNecAxkzR/bHmTiPYdG
	 amPTALKwIGiHJlSivmk0zuN8v51WZKHX/1vwFFuBNc1E5ZzxiUfDs8MdDrR/fmqh4D
	 oJXSJ++DOri3w==
Date: Mon, 25 Mar 2024 20:45:38 -0700
Subject: [PATCH 066/110] xfs: add a name field to struct xfs_btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132330.2215168.854879710080967193.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 77953b97bb19dc031673d055c811a5ba7df92307

The btnum in struct xfs_btree_ops is often used for printing a symbolic
name for the btree.  Add a name field to the ops structure and use that
directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h         |    2 +-
 libxfs/xfs_alloc.c          |    8 +++-----
 libxfs/xfs_alloc_btree.c    |    2 ++
 libxfs/xfs_bmap_btree.c     |    1 +
 libxfs/xfs_btree.c          |    8 ++++----
 libxfs/xfs_btree.h          |    2 ++
 libxfs/xfs_ialloc.c         |    5 ++---
 libxfs/xfs_ialloc_btree.c   |    2 ++
 libxfs/xfs_refcount_btree.c |    1 +
 libxfs/xfs_rmap_btree.c     |    1 +
 libxfs/xfs_types.h          |    9 ---------
 11 files changed, 19 insertions(+), 22 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index e7cbd0d9d416..df25dc2a9d62 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -8,7 +8,7 @@
 
 #define trace_xfs_agfl_reset(a,b,c,d)		((void) 0)
 #define trace_xfs_agfl_free_defer(a,b,c,d,e)	((void) 0)
-#define trace_xfs_alloc_cur_check(a,b,c,d,e,f)	((void) 0)
+#define trace_xfs_alloc_cur_check(...)		((void) 0)
 #define trace_xfs_alloc_cur(a)			((void) 0)
 #define trace_xfs_alloc_cur_left(a)		((void) 0)
 #define trace_xfs_alloc_cur_lookup(a)		((void) 0)
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1fdd7d44cb1a..b7690dfde8cc 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -269,9 +269,8 @@ xfs_alloc_complain_bad_rec(
 	struct xfs_mount		*mp = cur->bc_mp;
 
 	xfs_warn(mp,
-		"%s Freespace BTree record corruption in AG %d detected at %pS!",
-		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size",
-		cur->bc_ag.pag->pag_agno, fa);
+		"%sbt record corruption in AG %d detected at %pS!",
+		cur->bc_ops->name, cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
@@ -992,8 +991,7 @@ xfs_alloc_cur_check(
 out:
 	if (deactivate)
 		cur->bc_flags &= ~XFS_BTREE_ALLOCBT_ACTIVE;
-	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
-				  *new);
+	trace_xfs_alloc_cur_check(cur, bno, len, diff, *new);
 	return 0;
 }
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index dd9584269fc0..d9e9ba53a7c4 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -466,6 +466,7 @@ xfs_allocbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bnobt_ops = {
+	.name			= "bno",
 	.type			= XFS_BTREE_TYPE_AG,
 
 	.rec_len		= sizeof(xfs_alloc_rec_t),
@@ -495,6 +496,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 };
 
 const struct xfs_btree_ops xfs_cntbt_ops = {
+	.name			= "cnt",
 	.type			= XFS_BTREE_TYPE_AG,
 	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 828dfb7d4247..12b94c74ecb1 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -516,6 +516,7 @@ xfs_bmbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bmbt_ops = {
+	.name			= "bmap",
 	.type			= XFS_BTREE_TYPE_INODE,
 
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 42a1ed786284..95f77fbe7111 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -295,17 +295,17 @@ xfs_btree_check_ptr(
 				level))
 			return 0;
 		xfs_err(cur->bc_mp,
-"Inode %llu fork %d: Corrupt btree %d pointer at level %d index %d.",
+"Inode %llu fork %d: Corrupt %sbt pointer at level %d index %d.",
 				cur->bc_ino.ip->i_ino,
-				cur->bc_ino.whichfork, cur->bc_btnum,
+				cur->bc_ino.whichfork, cur->bc_ops->name,
 				level, index);
 	} else {
 		if (xfs_btree_check_sptr(cur, be32_to_cpu((&ptr->s)[index]),
 				level))
 			return 0;
 		xfs_err(cur->bc_mp,
-"AG %u: Corrupt btree %d pointer at level %d index %d.",
-				cur->bc_ag.pag->pag_agno, cur->bc_btnum,
+"AG %u: Corrupt %sbt pointer at level %d index %d.",
+				cur->bc_ag.pag->pag_agno, cur->bc_ops->name,
 				level, index);
 	}
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 99194ae94694..6bc6096205b3 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -123,6 +123,8 @@ enum xfs_btree_type {
 };
 
 struct xfs_btree_ops {
+	const char		*name;
+
 	/* Type of btree - AG-rooted or inode-rooted */
 	enum xfs_btree_type	type;
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 21577a50f655..94f4f86902b5 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -136,9 +136,8 @@ xfs_inobt_complain_bad_rec(
 	struct xfs_mount		*mp = cur->bc_mp;
 
 	xfs_warn(mp,
-		"%s Inode BTree record corruption in AG %d detected at %pS!",
-		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free",
-		cur->bc_ag.pag->pag_agno, fa);
+		"%sbt record corruption in AG %d detected at %pS!",
+		cur->bc_ops->name, cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 6a34de28293b..5e8a47563183 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -398,6 +398,7 @@ xfs_inobt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_inobt_ops = {
+	.name			= "ino",
 	.type			= XFS_BTREE_TYPE_AG,
 
 	.rec_len		= sizeof(xfs_inobt_rec_t),
@@ -426,6 +427,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 };
 
 const struct xfs_btree_ops xfs_finobt_ops = {
+	.name			= "fino",
 	.type			= XFS_BTREE_TYPE_AG,
 
 	.rec_len		= sizeof(xfs_inobt_rec_t),
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 760163ca414e..397ce2131933 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -317,6 +317,7 @@ xfs_refcountbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_refcountbt_ops = {
+	.name			= "refcount",
 	.type			= XFS_BTREE_TYPE_AG,
 
 	.rec_len		= sizeof(struct xfs_refcount_rec),
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 82052ce78554..5bf5340c8983 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -470,6 +470,7 @@ xfs_rmapbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_rmapbt_ops = {
+	.name			= "rmap",
 	.type			= XFS_BTREE_TYPE_AG,
 	.geom_flags		= XFS_BTGEO_OVERLAPPING,
 
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index a1004fb3c8fb..f577247b748d 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -125,15 +125,6 @@ typedef enum {
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
-#define XFS_BTNUM_STRINGS \
-	{ XFS_BTNUM_BNOi,	"bnobt" }, \
-	{ XFS_BTNUM_CNTi,	"cntbt" }, \
-	{ XFS_BTNUM_RMAPi,	"rmapbt" }, \
-	{ XFS_BTNUM_BMAPi,	"bmbt" }, \
-	{ XFS_BTNUM_INOi,	"inobt" }, \
-	{ XFS_BTNUM_FINOi,	"finobt" }, \
-	{ XFS_BTNUM_REFCi,	"refcbt" }
-
 struct xfs_name {
 	const unsigned char	*name;
 	int			len;

