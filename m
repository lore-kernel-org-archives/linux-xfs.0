Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253E2642
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHyF/m7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3D9C433C8;
	Mon,  1 Jan 2024 00:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068347;
	bh=ds0ER+b71NTgT5J7cUPJe0RFyA6JeW6r50sxeNPJb20=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hHyF/m7RzpkjvI61jDB3elsXoV6wGSIA7cdWCEi6bPE/zCzCQPsD+4JwKjueVYege
	 J2SV0YRcdPnu4L/MqezvDUU+J9pt2zfwZkwK3vUFL0QtPexyt6BJM/tpqr+DZT3ViI
	 3BS3XYHr4Yw0RQLoCSjHGYmNkMXAlnHp5xyogFjaVE3MLf4qyBFMMfrpxYND0+4v+a
	 b7mMrSMpXBgMBLXJE1Pt8A28cbceBPrq4FQHcfFb8Qotn2LHfe1dsodCl3twdm+gUH
	 3sRsQphtXI2GkUTMlOxuT+Wi8k/XCpv3QtyrpW97M+fr4T9pwlGWINgAs5/eLeEDQo
	 1eQlJ0ilf87XA==
Date: Sun, 31 Dec 2023 16:19:07 +9900
Subject: [PATCH 33/47] xfs_repair: flag suspect long-format btree blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015752.1815505.8105108722415202517.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Pass a "suspect" counter through scan_lbtree just like we do for
short-format btree blocks, and increment its value when we encounter
blocks with bad CRCs or outright corruption.  This makes it so that
repair actually catches bmbt blocks with bad crcs or other verifier
errors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    2 +-
 repair/scan.c   |   15 ++++++++++++---
 repair/scan.h   |    3 +++
 3 files changed, 16 insertions(+), 4 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 31b3cd74139..a0071d5de88 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -872,7 +872,7 @@ _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 
 		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
 				type, whichfork, lino, tot, nex, blkmapp,
-				&cursor, 1, check_dups, magic,
+				&cursor, 0, 1, check_dups, magic,
 				(void *)zap_metadata, &xfs_bmbt_buf_ops))
 			return(1);
 		/*
diff --git a/repair/scan.c b/repair/scan.c
index 1cd4d0ad2e1..2f8a3348ae1 100644
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
@@ -516,7 +525,7 @@ _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 		err = scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt,
 				type, whichfork, ino, tot, nex, blkmapp,
-				bm_cursor, 0, check_dups, magic, priv,
+				bm_cursor, suspect, 0, check_dups, magic, priv,
 				&xfs_bmbt_buf_ops);
 		if (err)
 			return(1);
@@ -584,7 +593,7 @@ _("bad fwd (right) sibling pointer (saw %" PRIu64 " should be NULLFSBLOCK)\n"
 				be64_to_cpu(pkey[numrecs - 1].br_startoff);
 	}
 
-	return(0);
+	return suspect > 0 ? 1 : 0;
 }
 
 static void
diff --git a/repair/scan.h b/repair/scan.h
index 4da788becbe..aeaf9f1a7f4 100644
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

