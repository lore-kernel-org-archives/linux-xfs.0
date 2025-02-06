Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE73F2417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882403; cv=none; b=s7DAbsaJmciQlK83T74Wo6gmOYvRBk4GCercSemEgK96wqM3ZwJZDP4OhPHvdvSjTRRlmlb9GjQJ24VkjSlkSTq4Oe/5tyZm+FH88YtAWmMLgOCEwzHpp9noj7RohPFZlmQmLTby2c628Hvw8efhDXfJRCLUR3QDLh1aFOl7CBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882403; c=relaxed/simple;
	bh=fJDwr2OXE0H6iP4i3pQwnsNI3O2rq3H9f7IDbS0J9TY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYYa2iyx8xnO1Dny9yMJYa6/3HTJWa4uWFjJ/mytQIp6eayA06vYRXUzzfzsajDP64TRwi+jpbPzVV4uThV9Wl/Q9RimyWWA4Knp0okQvEYq16ff5QIgZV9M2VeqeMDQ7yCYiMISj9mGRpJprbck1hGjrlmXl1fjv+OUfpJbQtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abj32C73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abj32C73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B955C4CEDD;
	Thu,  6 Feb 2025 22:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882403;
	bh=fJDwr2OXE0H6iP4i3pQwnsNI3O2rq3H9f7IDbS0J9TY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=abj32C73QhbvkLP/7yXw3gzLrQ+yABCivLFm2iF7T3qZSMocNTa03zZHIOxaXW8b2
	 YQKair9Xm/4U2FjluT+Ieiy6eagqkthNUhuJpCIIp3zlYgZBSWDp/0serBHeCttuvy
	 thwgFNYE2qq1aDYeoYRzdDOV1DtL+HqFxeF6XBPJBhGAIoizJgsOv2FxhMedP3zDCg
	 jzCgHdEI/SRkoyDe2w4oNAgJ6rYbPaQaqpAQmkFUXoS7cXV82gypq6GzC6wE4W7Tnp
	 UXRQRzbKmQnUQYwXu4ao1vdYIg3PVoyKu224O+q4dyCUcgFZJ4mTDsoaZqgN83p7Si
	 wL1H82Ot1LywQ==
Date: Thu, 06 Feb 2025 14:53:23 -0800
Subject: [PATCH 14/27] xfs_repair: flag suspect long-format btree blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088311.2741033.11494162687682570792.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Pass a "suspect" counter through scan_lbtree just like we do for
short-format btree blocks, and increment its value when we encounter
blocks with bad CRCs or outright corruption.  This makes it so that
repair actually catches bmbt blocks with bad crcs or other verifier
errors.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c |    2 +-
 repair/scan.c   |   15 ++++++++++++---
 repair/scan.h   |    3 +++
 3 files changed, 16 insertions(+), 4 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 9ab193bc5fe973..4eafb2324909e1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -923,7 +923,7 @@ _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 
 		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
 				type, whichfork, lino, tot, nex, blkmapp,
-				&cursor, 1, check_dups, magic,
+				&cursor, 0, 1, check_dups, magic,
 				(void *)zap_metadata, &xfs_bmbt_buf_ops))
 			return(1);
 		/*
diff --git a/repair/scan.c b/repair/scan.c
index 88fbda6b83f61a..cd44a9b14f3a1c 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -136,6 +136,7 @@ scan_lbtree(
 				xfs_extnum_t		*nex,
 				blkmap_t		**blkmapp,
 				bmap_cursor_t		*bm_cursor,
+				int			suspect,
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
@@ -148,6 +149,7 @@ scan_lbtree(
 	xfs_extnum_t	*nex,
 	blkmap_t	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
+	int		suspect,
 	int		isroot,
 	int		check_dups,
 	uint64_t	magic,
@@ -167,6 +169,12 @@ scan_lbtree(
 			XFS_FSB_TO_AGBNO(mp, root));
 		return(1);
 	}
+	if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
+		do_warn(_("btree block %d/%d is suspect, error %d\n"),
+			XFS_FSB_TO_AGNO(mp, root),
+			XFS_FSB_TO_AGBNO(mp, root), bp->b_error);
+		suspect++;
+	}
 
 	/*
 	 * only check for bad CRC here - caller will determine if there
@@ -182,7 +190,7 @@ scan_lbtree(
 
 	err = (*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1,
 			type, whichfork, root, ino, tot, nex, blkmapp,
-			bm_cursor, isroot, check_dups, &dirty,
+			bm_cursor, suspect, isroot, check_dups, &dirty,
 			magic, priv);
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
@@ -209,6 +217,7 @@ scan_bmapbt(
 	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	bmap_cursor_t		*bm_cursor,
+	int			suspect,
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
@@ -505,7 +514,7 @@ _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 		err = scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt,
 				type, whichfork, ino, tot, nex, blkmapp,
-				bm_cursor, 0, check_dups, magic, priv,
+				bm_cursor, suspect, 0, check_dups, magic, priv,
 				&xfs_bmbt_buf_ops);
 		if (err)
 			return(1);
@@ -573,7 +582,7 @@ _("bad fwd (right) sibling pointer (saw %" PRIu64 " should be NULLFSBLOCK)\n"
 				be64_to_cpu(pkey[numrecs - 1].br_startoff);
 	}
 
-	return(0);
+	return suspect > 0 ? 1 : 0;
 }
 
 static void
diff --git a/repair/scan.h b/repair/scan.h
index 4da788becbef66..aeaf9f1a7f4ba9 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -23,6 +23,7 @@ int scan_lbtree(
 				xfs_extnum_t		*nex,
 				struct blkmap		**blkmapp,
 				bmap_cursor_t		*bm_cursor,
+				int			suspect,
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
@@ -35,6 +36,7 @@ int scan_lbtree(
 	xfs_extnum_t	*nex,
 	struct blkmap	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
+	int		suspect,
 	int		isroot,
 	int		check_dups,
 	uint64_t	magic,
@@ -52,6 +54,7 @@ int scan_bmapbt(
 	xfs_extnum_t		*nex,
 	struct blkmap		**blkmapp,
 	bmap_cursor_t		*bm_cursor,
+	int			suspect,
 	int			isroot,
 	int			check_dups,
 	int			*dirty,

