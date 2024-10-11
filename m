Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A846EADA
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609689; cv=none; b=GcXnK8Fsn1EcG3e4PaLd55zq32ebvX4O0V6ULLwb8RGzsbWH6Fo6R8PksTduKY+u0yax6GO+YJUBWgdbJ7HlWADqkQNBruY3fKK5rHSyulJYjU6/FyJaI6qSnct62+OoQAo8dkyctHAdTDKy3zSxZzevuqTIFMPra8D2fHxNX7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609689; c=relaxed/simple;
	bh=Ex7c+dR7Pi2XR1IWDd+pIZi0l0HHKL9NKmqcTd9mx1o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kWn1w3B6xtEqPMPx3GTfSsae9D/mT5Mxc1rz2Yp047+31mUsGTn6k69JH4Xm//kz+0NTp62yuGyAv8rAqmBNZIz/gXW+dj4pqWUhMJJCF0mvJsyh/bNIwMO38FRUSe7f1JjFFrpG/sK3d04lWKX/cuxnbsc+NQoRt7Z/Umu+rM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RaFoCP+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RaFoCP+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DD2C4CEC5;
	Fri, 11 Oct 2024 01:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609687;
	bh=Ex7c+dR7Pi2XR1IWDd+pIZi0l0HHKL9NKmqcTd9mx1o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RaFoCP+ZizYp2NFes8Jm7duj1jL/GGMQ3MtBMjBg3j7gzmgwwLhOk3e8yynrvoDJg
	 wrc+7pZdx4dGpRTFs3XR95snrK/SEewaQuGS7zne9hE9oYjSf/3T1xM6B7cy0Pyl5a
	 5VSD8dwhzrlGNNiaBT5fNkListC5xdFGiqBf4EM1RkKzAwGzEe6AB9wA23Ot+WOmcL
	 39snhpDRNYFunujTXi116jda95j39ctDwtbMeDn7uRgiHZv2jitSWMJH2RK3ZsnsmZ
	 vQuvuhgBrn1ZrnOFZA3b0LkJw2hosHF4yGR7HOgg5mvk9V1R9LqxsTh7KFPN3wuxhr
	 h5Z8C0i0rI5iQ==
Date: Thu, 10 Oct 2024 18:21:27 -0700
Subject: [PATCH 28/38] xfs_repair: pass private data pointer to scan_lbtree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654407.4183231.16012011258611923115.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Pass a private data pointer through scan_lbtree.  We'll use this
later when scanning the rtrmapbt to keep track of scan state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    2 +-
 repair/scan.c   |   11 +++++++----
 repair/scan.h   |    7 +++++--
 3 files changed, 13 insertions(+), 7 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 7abeb43a2f4fc6..3a157e74e3e336 100644
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

