Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B50819259D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990906; cv=none; b=eGWdHzrTldIydnL9R4YK3DVUnpQFvqYwol6/D1p5cTa9xy6k2VwLb+rYyu2aLkYe8PB1RWSPrP3YLm0yJmu+8yqHQaqPS72X68N7gxRbT1mhO1oJexATDbXLSq9XiV9risCWzs2i4hKyWzJSQuH6H5QZJigKCgEEwcmxoTWlgho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990906; c=relaxed/simple;
	bh=5eeo+6EuWAOv8PfOHufJjvecuPAZ5gABUa4UQ4OOA78=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4QRcOGanBf7GEkvpHyQbVrDNNjKGimLnZrMhaTSMUZvBf3jFQL+5IkcSGHe2Z2xcyhWxqsLBu3UJCDj0peS8FCUdg5NXWgj/wvk6YrvyoHepP7HvCiZ1JRThXZppsgdju37PlEnaeMjOh9UoaTklrra2FEZWfaJql8TgeSBjs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K67ceYCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K67ceYCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F6DC4CED3;
	Mon, 23 Dec 2024 21:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990906;
	bh=5eeo+6EuWAOv8PfOHufJjvecuPAZ5gABUa4UQ4OOA78=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K67ceYCiaDXzp9AP62h7I9QVsKbTXfiI/gvKW6NkQiVIRGU4fTnrNQHraCNfqjcKe
	 8rX95eF5lNALGxqAfjqIKOCh0J/ThlGmDLW2F4ECyPcJE93N4Q4TfcfNjxNCfYgBOy
	 oapFXrvtn5FB32TwDpwCSbGpPfdhmpqSc1J0Zj0I73Ihqu2AajwpPHVHhPAe1horBj
	 8ZT2s/nOn1ccYUB+68pJBXhOqUXRW4PkBBuBRXr1H5XAHHtyh/CLizhsnDKD/4PGaT
	 s8JUDa+Lz0wYsxT49IldiLsNCsLfSytTv94qsLFWdIZ2wi9rMTMCqQhhzf37HKgsOZ
	 KGraqWBUfLLwQ==
Date: Mon, 23 Dec 2024 13:55:05 -0800
Subject: [PATCH 33/41] xfs_repair: pass private data pointer to scan_lbtree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941474.2294268.18233001467953743677.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Pass a private data pointer through scan_lbtree.  We'll use this
later when scanning the rtrmapbt to keep track of scan state.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |    2 +-
 repair/scan.c   |   11 +++++++----
 repair/scan.h   |    7 +++++--
 3 files changed, 13 insertions(+), 7 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 60a853d152ccec..4ca45ad4aab1fa 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -839,7 +839,7 @@ _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 
 		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
 				type, whichfork, lino, tot, nex, blkmapp,
-				&cursor, 1, check_dups, magic,
+				&cursor, 1, check_dups, magic, NULL,
 				&xfs_bmbt_buf_ops))
 			return(1);
 		/*
diff --git a/repair/scan.c b/repair/scan.c
index b115dd4948b969..f6d46a2861b312 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -139,7 +139,8 @@ scan_lbtree(
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
-				uint64_t		magic),
+				uint64_t		magic,
+				void			*priv),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
@@ -150,6 +151,7 @@ scan_lbtree(
 	int		isroot,
 	int		check_dups,
 	uint64_t	magic,
+	void		*priv,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf	*bp;
@@ -181,7 +183,7 @@ scan_lbtree(
 	err = (*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1,
 			type, whichfork, root, ino, tot, nex, blkmapp,
 			bm_cursor, isroot, check_dups, &dirty,
-			magic);
+			magic, priv);
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
 
@@ -210,7 +212,8 @@ scan_bmapbt(
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
-	uint64_t		magic)
+	uint64_t		magic,
+	void			*priv)
 {
 	int			i;
 	int			err;
@@ -486,7 +489,7 @@ _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 		err = scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt,
 				type, whichfork, ino, tot, nex, blkmapp,
-				bm_cursor, 0, check_dups, magic,
+				bm_cursor, 0, check_dups, magic, priv,
 				&xfs_bmbt_buf_ops);
 		if (err)
 			return(1);
diff --git a/repair/scan.h b/repair/scan.h
index ee16362b6d3c69..4da788becbef66 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -26,7 +26,8 @@ int scan_lbtree(
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
-				uint64_t		magic),
+				uint64_t		magic,
+				void			*priv),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
@@ -37,6 +38,7 @@ int scan_lbtree(
 	int		isroot,
 	int		check_dups,
 	uint64_t	magic,
+	void		*priv,
 	const struct xfs_buf_ops *ops);
 
 int scan_bmapbt(
@@ -53,7 +55,8 @@ int scan_bmapbt(
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
-	uint64_t		magic);
+	uint64_t		magic,
+	void			*priv);
 
 void
 scan_ags(

