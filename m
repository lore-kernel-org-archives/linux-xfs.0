Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778432194B1
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191119; cv=none; b=RFGsP4dRDR8qnKbRp+uxh112sEyiu75cYvABHenOPSYIQiDuIN8ZmYuX6Rjh9FuiN5YPbWWzBpmuFNJfniA9yBWA2UGKIfWd9EiYdeOpoBHMMCpJ3LmrmGKlzaCc+QciTkSWgCWxL8otvSuZHAv3U4BSwdR83ltpAPrB0uW5rXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191119; c=relaxed/simple;
	bh=TCipWp8oevBqM3OjhqXhsRLCe93xcev0+jNV4uMKeMs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXnD/uonYWve1HaG5Dw2I8ALlTuTErPMRPTUrHrFLwullBr8FtPuNFSy4u2Jxm3claaXwAJYZln95nS2YQkXGwSiZLDxJFJsxJUZrktMREL9LPF8JK7YIDRjoReQBYvCmMZLGCQHNNhtgRYXJSDD5kE5vzBApc2++LMsCjV96W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gx1MG4PL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gx1MG4PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E38C4CEC3;
	Thu, 17 Oct 2024 18:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191119;
	bh=TCipWp8oevBqM3OjhqXhsRLCe93xcev0+jNV4uMKeMs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gx1MG4PLU7T6jG+dxVs/V87VJGCMJs57mbulaEQQ/uX6FAbaQUL7h7/LWBkTBuox9
	 CUKKFyNX9ysR3pngXL5RiQYq1Xv2+X9xZXcOFqIT3/YBCMzokfn1JNfU85URZ5Ei5R
	 1aIQLuW2s5/uNpckNiqTJTJocCy/qomKkAlUTgKxzG7gjluV/3jCQ9/DhrLedmv7Q1
	 Me91LhxO1x18Oz7HZ+D7dPFZrk4zqtQwye304RLRPndLMdq7uUF20UKCfYbI2U31kk
	 rb44cQXMSdIp5D/NBj44mBwcqM2IytlR581kCfTSoXlcNze5W2vNniL/mtsxPELIrS
	 1Rfpowgp7BVaw==
Date: Thu, 17 Oct 2024 11:51:54 -0700
Subject: [PATCH 01/16] xfs: factor out a xfs_iwalk_args helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068683.3450737.7402024591855630308.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add a helper to share more code between xfs_iwalk and xfs_inobt_walk,
and at the same time do away with the extra flags indirect so that
everyone use the same names for the same flags when using the common
iwalk code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iwalk.c |   83 ++++++++++++++++++++--------------------------------
 fs/xfs/xfs_iwalk.h |    7 +---
 2 files changed, 33 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index d4ef7485e8f740..a89ae2aef7c445 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -534,6 +534,35 @@ xfs_iwalk_prefetch(
 	return max(inobt_records, 2U);
 }
 
+static int
+xfs_iwalk_args(
+	struct xfs_iwalk_ag	*iwag,
+	unsigned int		flags)
+{
+	struct xfs_mount	*mp = iwag->mp;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	int			error;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
+
+	error = xfs_iwalk_alloc(iwag);
+	if (error)
+		return error;
+
+	for_each_perag_from(mp, agno, iwag->pag) {
+		error = xfs_iwalk_ag(iwag);
+		if (error || (flags & XFS_IWALK_SAME_AG)) {
+			xfs_perag_rele(iwag->pag);
+			break;
+		}
+		iwag->startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+	}
+
+	xfs_iwalk_free(iwag);
+	return error;
+}
+
 /*
  * Walk all inodes in the filesystem starting from @startino.  The @iwalk_fn
  * will be called for each allocated inode, being passed the inode's number and
@@ -562,32 +591,8 @@ xfs_iwalk(
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
 		.lastino	= NULLFSINO,
 	};
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
-	int			error;
 
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
-
-	error = xfs_iwalk_alloc(&iwag);
-	if (error)
-		return error;
-
-	for_each_perag_from(mp, agno, pag) {
-		iwag.pag = pag;
-		error = xfs_iwalk_ag(&iwag);
-		if (error)
-			break;
-		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
-		if (flags & XFS_INOBT_WALK_SAME_AG)
-			break;
-		iwag.pag = NULL;
-	}
-
-	if (iwag.pag)
-		xfs_perag_rele(pag);
-	xfs_iwalk_free(&iwag);
-	return error;
+	return xfs_iwalk_args(&iwag, flags);
 }
 
 /* Run per-thread iwalk work. */
@@ -673,7 +678,7 @@ xfs_iwalk_threaded(
 		iwag->lastino = NULLFSINO;
 		xfs_pwork_queue(&pctl, &iwag->pwork);
 		startino = XFS_AGINO_TO_INO(mp, pag->pag_agno + 1, 0);
-		if (flags & XFS_INOBT_WALK_SAME_AG)
+		if (flags & XFS_IWALK_SAME_AG)
 			break;
 	}
 	if (pag)
@@ -747,30 +752,6 @@ xfs_inobt_walk(
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
 		.lastino	= NULLFSINO,
 	};
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
-	int			error;
 
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(!(flags & ~XFS_INOBT_WALK_FLAGS_ALL));
-
-	error = xfs_iwalk_alloc(&iwag);
-	if (error)
-		return error;
-
-	for_each_perag_from(mp, agno, pag) {
-		iwag.pag = pag;
-		error = xfs_iwalk_ag(&iwag);
-		if (error)
-			break;
-		iwag.startino = XFS_AGINO_TO_INO(mp, pag->pag_agno + 1, 0);
-		if (flags & XFS_INOBT_WALK_SAME_AG)
-			break;
-		iwag.pag = NULL;
-	}
-
-	if (iwag.pag)
-		xfs_perag_rele(pag);
-	xfs_iwalk_free(&iwag);
-	return error;
+	return xfs_iwalk_args(&iwag, flags);
 }
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 83699089755ebb..17a5a2c6debb15 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -25,7 +25,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 		unsigned int flags, xfs_iwalk_fn iwalk_fn,
 		unsigned int inode_records, bool poll, void *data);
 
-/* Only iterate inodes within the same AG as @startino. */
+/* Only iterate within the same AG as @startino. */
 #define XFS_IWALK_SAME_AG	(1U << 0)
 
 #define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
@@ -41,9 +41,4 @@ int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_inobt_walk_fn inobt_walk_fn, unsigned int inobt_records,
 		void *data);
 
-/* Only iterate inobt records within the same AG as @startino. */
-#define XFS_INOBT_WALK_SAME_AG	(XFS_IWALK_SAME_AG)
-
-#define XFS_INOBT_WALK_FLAGS_ALL (XFS_INOBT_WALK_SAME_AG)
-
 #endif /* __XFS_IWALK_H__ */

