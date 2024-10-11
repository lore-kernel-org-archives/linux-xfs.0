Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F172107
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607469; cv=none; b=sN8ytO+dWYBf5TX7/C/PPPw2W6J2c0kkq/jwPHhHM4H/A/4NA1XjMBsWxttoT93B38u90Z6eAtvyI+k1TZ22p0mdSAnRETj7dLpyaciBYeRjguPwv7xQppctM34D97Cfz/oLLURNtvokQsRD7Gei+9X2BMRAlDDcHk1kOXLkQeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607469; c=relaxed/simple;
	bh=TCipWp8oevBqM3OjhqXhsRLCe93xcev0+jNV4uMKeMs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LWOy+YdPlnWQFeLa8lTz2IYlPRg/RerUSFKg29hwRInZbOBYCnBOg5/J+KYo8P5XzkAIZpshhLSrzJCZiFqA/r7kt4mzTOwb7AVEtAodY961EIeu75/dfZLev1t6zrjJjwiyyvjbQU7BAFxP+kWRXquIHvD1tcZwDtqwtXv1vdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gY0khigW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gY0khigW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F09C4CEC5;
	Fri, 11 Oct 2024 00:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607467;
	bh=TCipWp8oevBqM3OjhqXhsRLCe93xcev0+jNV4uMKeMs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gY0khigWPYOmYq3jPEgLgQBJ/i0cvF8eQhBmOZqvNG9EMc7Mg40mLUBsfKcRPa5kP
	 J10YvoQBkZ1P2iLUN0iUKXuvEmH3lK6x9Ay3LerUPN1js5OjA6pT+U/NmKjhVe9luj
	 +f8EfXX0/0YMyQBypOSLc7n0bUFJAzW4ucMPRmJTChA2WZpHw7wlOw90F4O9Y4yHrn
	 q+FMV1M14Tp3D2XI8h6PTcOqucfUNBIA00ovH+Kd/9H75g/8c720EHONcsPS6v3wjY
	 rrxpRLn3jIzGljAAz56AlSoUHPvxXV8y1eGWvqnFoVcWBwBkNnI53r1lwBDnIEjg7a
	 dtR3GZmUtpZkw==
Date: Thu, 10 Oct 2024 17:44:27 -0700
Subject: [PATCH 01/16] xfs: factor out a xfs_iwalk_args helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641271.4176300.13007245796585970604.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
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

