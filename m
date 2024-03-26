Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CCE128823
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424896; cv=none; b=mLr2LmZQE1IHWWMCqI6m7pEEnm2yjlF+pJYswOHhHwYAPJ/lLCcmTo+pKm8xMGSADbntwjO0rEYOzHTWatKqaai8m9n2vNAtEVfp9Nlu5TkvyUlWljY9P/IZuPjMfHhJV4ieGDg2Gi/0AD2Tbm0csBs5yHFnMFvQgN6O0hWpJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424896; c=relaxed/simple;
	bh=PKkry7GaYjlDUxkRTw8ujAaZ2j4vNK1O68+kZljULsM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hsna5KoJgglI4WMK1VxgzElAw0hP/3U4oQ7/obKRgUyuY1mbsGgSYDHQsB4R3GP95lyzV276gOTGrhhVtsCfPVRqF4I0gnYZ5fT1eluy1vJn3oylTZazNmPbFwmPj0DLab85O2X3vjhggjcIPMpuTluC9Oku9YqG8Og3yBAAxwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDZKdvdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDZKdvdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1012C433F1;
	Tue, 26 Mar 2024 03:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424895;
	bh=PKkry7GaYjlDUxkRTw8ujAaZ2j4vNK1O68+kZljULsM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kDZKdvdbKhAGdbxwoYsU+WCxFtBYEWIiIu+a1ECky8z5RNVV+u65zL6NpUzP9K8X4
	 2Lgoxts0LyoOhZ/rUD2zTUe+bHjjbbpAhZRNvEVzffJIaTa/Dh6udhDW9b7QusgZTD
	 ee+1+YJPkZTWKOpkyLpBDADxHdk65wC3G7tTpgu5oLaYTB05lAJBgd7a9uvfSLEt3R
	 t5pRCxQ7YKjUpSj9EZ1mgHLYbz0lwwpiQyoO7YbysLJra/2TzYkpD2OybW5gGHhwpP
	 /lmZqujSHahVq4U/hQGuYy1s+mzcT96ju0vNKfR/7dv/eXHKieor9WKFWcmk0/vrS2
	 VaBDq8/umvtqQ==
Date: Mon, 25 Mar 2024 20:48:15 -0700
Subject: [PATCH 076/110] xfs: simplify xfs_btree_check_lblock_siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132475.2215168.17920299383250212272.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8b8ada973cacff338a0e817a97dd0afa301798c0

Stop using xfs_btree_check_lptr in xfs_btree_check_lblock_siblings,
as it only duplicates the xfs_verify_fsbno call in the other leg of
if / else besides adding a tautological level check.

With this the cur and level arguments can be removed as they are
now unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4ba36ecbbc36..55775ddf0a22 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -56,8 +56,6 @@ xfs_btree_magic(
 static inline xfs_failaddr_t
 xfs_btree_check_lblock_siblings(
 	struct xfs_mount	*mp,
-	struct xfs_btree_cur	*cur,
-	int			level,
 	xfs_fsblock_t		fsb,
 	__be64			dsibling)
 {
@@ -69,14 +67,8 @@ xfs_btree_check_lblock_siblings(
 	sibling = be64_to_cpu(dsibling);
 	if (sibling == fsb)
 		return __this_address;
-	if (level >= 0) {
-		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
-			return __this_address;
-	} else {
-		if (!xfs_verify_fsbno(mp, sibling))
-			return __this_address;
-	}
-
+	if (!xfs_verify_fsbno(mp, sibling))
+		return __this_address;
 	return NULL;
 }
 
@@ -136,10 +128,9 @@ __xfs_btree_check_lblock(
 	if (bp)
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
-	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-			block->bb_u.l.bb_leftsib);
+	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+		fa = xfs_btree_check_lblock_siblings(mp, fsb,
 				block->bb_u.l.bb_rightsib);
 	return fa;
 }
@@ -4648,10 +4639,9 @@ xfs_btree_lblock_verify(
 
 	/* sibling pointer verification */
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-			block->bb_u.l.bb_leftsib);
+	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+		fa = xfs_btree_check_lblock_siblings(mp, fsb,
 				block->bb_u.l.bb_rightsib);
 	return fa;
 }

