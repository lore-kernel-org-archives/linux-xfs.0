Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D3F1F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528879; cv=none; b=aDNbel3bbUCnEiOmt29U6qduQnImMgrzAsPeV4hi3RYGufhKvnH4wHFcDvzzz9QpEXKElep8uo4b3i9rwca/9OcAnHuGclT/dexDBEO337e0DJEhwjK2RDgUUC9NZRnGM2lpJyBOsZO+zxJCxxJbtXeTP/3+upTnv+QFnfis2uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528879; c=relaxed/simple;
	bh=zYn8XHRi90Ww034IOy+f2ZHpqkI4UvtOS60SnVikw1E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJ9MAHbf7Ar7joeq+NxthkigpQE4lXqQlvHR1jsE9N/bU8A4MH+AHBAFbUt3l6XGU3XIsmZGeOqItS54PfUsDOuB8lc/ZKpavwjHEYeDMqh+/49vtKIR5yOV5rZVIIlBT6PnBHYRx7sfY2QAObtVb09FaH5/GcJDqtjt71tFwJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSJpEVmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSJpEVmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFDCC4CED1;
	Fri,  6 Dec 2024 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528879;
	bh=zYn8XHRi90Ww034IOy+f2ZHpqkI4UvtOS60SnVikw1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PSJpEVmPZrL6jLqn6eAJU9vX4oYOgNUb4FNH1MhCDaynCwGrs3xHdwB1vFEotgETe
	 NKbmc36tipHUsqSYB/lmONxogXGFndLZLYzPu8cXyR1MyVqjXhfwrkRxB3CmhBj3bp
	 tI/Z4oFZfeprXLrpukTPkViFM+sPD8didcwELSfZIapZZ2FNa3U1SLgnGp62U/0a3+
	 pzfQLElZrARhzXzLU9BZWdegawO1hBuDbKUn1cnLa4d/moRKq6drbvTBct5ZciGiMf
	 XPUB7IMcrUb28nFl6vT6LQkrdXoBxQeZNuvse3Ktgr4eVFnzFtCztaHX/NNrUkU8R9
	 tQQRAS4HrCJaQ==
Date: Fri, 06 Dec 2024 15:47:59 -0800
Subject: [PATCH 32/41] xfs_repair: pass private data pointer to scan_lbtree
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748725.122992.1994741139588590565.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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
---
 repair/dinode.c |    2 +-
 repair/scan.c   |   11 +++++++----
 repair/scan.h   |    7 +++++--
 3 files changed, 13 insertions(+), 7 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index b9d2d15882c593..4d4e901ef796d6 100644
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

