Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8CCC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e72nA/JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AEFC433C7;
	Sun, 31 Dec 2023 23:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066126;
	bh=UJcPyPCG4LkPa+5aSj+fzHcXYjc3egkGXyBzRY0MT+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e72nA/JItSXwxwziF/LhJvUfTkZBoOk8bZIVGobhtj/ldofxaQcSumUt+WM6yMYsZ
	 s0KkzDHP7nyetDPoOVKSnM4HYnrRk6+qRCFjKQPLa1ue+C5OOWYoIp+Q7NH03fgcB+
	 vFxK2jomWYjAwa1wY6kk4rBilxTcVXXRKCfrQ7PeJXZ7RfPLSc4ogYF/lF8t7Er6J9
	 zAcrH/6nLz73hi24lSfKM3/1L/+eGzSX4/3Vs4gI01cJeuvgulBl48jAYFXF6cN/Gx
	 m+n9QzyHMjwWtt/RHyu1WW/rPriADJcve8IxQTH2H3zX9g4TXnF7SXB85x7KUoPS2m
	 zX45BsX7NR5GQ==
Date: Sun, 31 Dec 2023 15:42:05 -0800
Subject: [PATCH 48/58] xfs_repair: pass private data pointer to scan_lbtree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010587.1809361.13220845218706420190.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
index 7c3e5d86404..9b7309afcaf 100644
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
index fbe1916ac6c..8822f0f05fb 100644
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
@@ -497,7 +500,7 @@ _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 		err = scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt,
 				type, whichfork, ino, tot, nex, blkmapp,
-				bm_cursor, 0, check_dups, magic,
+				bm_cursor, 0, check_dups, magic, priv,
 				&xfs_bmbt_buf_ops);
 		if (err)
 			return(1);
diff --git a/repair/scan.h b/repair/scan.h
index ee16362b6d3..4da788becbe 100644
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

