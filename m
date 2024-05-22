Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C624C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347441; cv=none; b=q5ISnDXdVEdcLloCOhpy7gXB06JaKRjkFBUuU64Tz2DSK09LS9BA83e1Z3IESf2/EQXGi306qvuYRckVvFIqEg5qg2v8LHK4NvSsfM3rQVMXZslFlvBIhdJh9vNGZqi6rQ0zlaCHujxnaYFMnc6MEWjAU1Wy8+lyKst2i9jWiL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347441; c=relaxed/simple;
	bh=eN9mZ9/GaPXITQv9KB6OXHM7GmS4aqmCCxYLG7rYvvs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tGLzGhwiHWYSmyB3Dic8NLSv+bVW9MbX/la/XGVEDoWqPZdRIIyq1ZNgRsmUHNLLXL6O6FepRhgNqc5bauo8Xlco8d7WlrZUFq6U8/QaDtkhbGP615qBoRoVkrNLgm1heyxC3r0m9ehVcmcvfexsKbIm7+JTfQK+OjWZDPMctPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OG1PxSHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OG1PxSHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9037AC2BD11;
	Wed, 22 May 2024 03:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347441;
	bh=eN9mZ9/GaPXITQv9KB6OXHM7GmS4aqmCCxYLG7rYvvs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OG1PxSHbv2qzCIOITP0Oj4dHYZcnh6zUe96QAzxecd8b0IoTMCcibxj26JcBYuRc6
	 yH1oDPT+UiDLGsxWTueWN0eJ1kTbVH9a1oRCQDxp3SgYtqBR89I6Mlt7dOKgB5DTIm
	 x2JgoyaPo+XePrYjObX46cqNGBUG+GsF+lgQE+NlT2X2Xv0aC3ovB2eZJyxtzA1vj/
	 V0kOGbzE1FHswUHLQFG2DdsBrue0uSAbEZyIgq4bWdCTsFJc5LDZG8xG7c5ih3Zngq
	 trDqeXaLz2fNF2aFi5crJIybN4a3YIaCAwSbuFPd1mCsxG983QcB1Z6oJlr/uyB45D
	 U/+XBeHW7VpPg==
Date: Tue, 21 May 2024 20:10:41 -0700
Subject: [PATCH 084/111] xfs: factor out a __xfs_btree_check_lblock_hdr helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532959.2478931.18233373878393990634.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 79e72304dcba471e5c0dea2f3c67fe1a0558c140

This will allow sharing code with the in-memory block checking helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index e69b88b90..6b1839243 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -91,20 +91,14 @@ xfs_btree_check_agblock_siblings(
 	return NULL;
 }
 
-/*
- * Check a long btree block header.  Return the address of the failing check,
- * or NULL if everything is ok.
- */
 static xfs_failaddr_t
-__xfs_btree_check_fsblock(
+__xfs_btree_check_lblock_hdr(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_failaddr_t		fa;
-	xfs_fsblock_t		fsb;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -124,6 +118,28 @@ __xfs_btree_check_fsblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
+	return NULL;
+}
+
+/*
+ * Check a long btree block header.  Return the address of the failing check,
+ * or NULL if everything is ok.
+ */
+static xfs_failaddr_t
+__xfs_btree_check_fsblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_failaddr_t		fa;
+	xfs_fsblock_t		fsb;
+
+	fa = __xfs_btree_check_lblock_hdr(cur, block, level, bp);
+	if (fa)
+		return fa;
+
 	/*
 	 * For inode-rooted btrees, the root block sits in the inode fork.  In
 	 * that case bp is NULL, and the block must not have any siblings.

