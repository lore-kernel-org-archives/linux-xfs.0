Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871038;
	b=4EQ+KU2mhidOc6+at+37hbr0r3z8mdupJcA3wcB4MzZjcZ8R0cAaHoMsQAwhTX5iRHwO
	 kpRvGY6iYzi3WpifmcTNA5WDGaYBFuHQboBpVIoOQeiwx8cEMh0qTB1upZhocc413szfi
	 xq5uWLSKkJjNkKtm3BoaREmwu06sSDqeHYeGMcgsWom0L2rZXIBCnzDWdNCvUFXIPgNcV
	 hZKIgNNxUiqE3w4mcpSDN2/l0zim8SNiZZa36+OtQ5r0+CPyXqJvvn9/Tmy0ztIA9X6UZ
	 ipnM59BwYitpsEqHKdPS71EwONoNuYvotPctj2LfIEMI8tuUhSAvnhv+SeNOYyNKFew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YeL8yRXu2RhjyFwDwFEeBg11Sncko6M+bdov2T+ysTo=;
	b=dOx+4dbJPBhpDWhapuokJVXTUj9jV25ptNUKMtNK2gEFPpGKEuu6D2aPUiyCxaTc3Yhg
	 6ah+PGR7Ln2fA/+4/TqKSdqOpwiA2AKF8mY+tyHnV3z6JSS49FdyAoeJVrblx1IL6qF0y
	 1O6nN24o3BUwvND31bz0xLs2E6JwKb+FQxtR6V0MYFcy4BVf31LserLC/s1iC+PwGO4JI
	 2iH8HzmB6xlFCDa43LmVDpc2rTU9/46B/eLtEwowZd8hs86reKfjEa8yIgxYsqci5suDI
	 I+MFhflAB17Mj0c36wILXIZDELIBlsx9r7qmSPIBvDAJoIyzVaZAEu4J32+olFgvMZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVE04ZWG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72759606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVE04ZWG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2601F000C4;
	Mon, 16 Nov 2026 23:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871038;
	bh=YeL8yRXu2RhjyFwDwFEeBg11Sncko6M+bdov2T+ysTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVE04ZWG8kK0lGLzC6xTvR1+3WVzX6cqzyg3AmxhWQBuEb+aawNwgnbB9Q6v8wOTi
	 EZfYRZd67P+CE2r1HfiT85Z4Wa7ePpN4AJd9CV6JNO38yHFfjhpQzY2rhD9q1oMkKh
	 k3f7u8NZiasaqYDJB2QGAof9YEjKS46euhAGwi7QXWOP2KwN7/VVBBHNtYGtGOoTIq
	 8joR211HaTbF+fvYwKGHrdFu4WpH9LGYc2wNWAhasQxGlnun40YYZhozdUe9hWSGRY
	 XvWYPvQ7fx+C7BTiRSNmOv+DqEizMrSalHu6XYlZYwbc+G3CIhBwq4pNKzV+wFIYro
	 veamIgTkUU/Tg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 03/59] xfs: allow an empty rt refcount btree root before the rt volume exists
Date: Tue, 17 Nov 2026 10:14:20 +1100
Message-ID: <20261116231707.3625263-4-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a transient state on disk where an rtrefcount inode has no contents,
because growfs can create rtrefcount inodes dynamically. m_rtrefc_maxlevels is
zero until growfs adds the first realtime volume. Growfs loads an existing
rtrefcount inode before it adds the space and recomputes m_rtrefc_maxlevels. An
inode left behind by an earlier growfs that failed after creating it is loaded
while m_rtrefc_maxlevels is still zero.

Commit cc3144da377d changed the root loader to reject levels at or above
m_rtrefc_maxlevels. That rejects every level when m_rtrefc_maxlevels is zero,
including the empty level zero root. A retried growfs then fails on a valid
inode.

Accept an empty level zero root when m_rtrefc_maxlevels is zero. A non-empty
level zero root is a normal leaf root that is still checked to fit within the
inode fork.

The inode repair code rejects only levels greater than m_rtrefc_maxlevels, so it
disagrees with the root loader. Give it the same root level rules.

Fixes: cc3144da377d ("xfs: fix off-by-one in rtrefcount btree root level validation")
Fixes: 92b2019493d1 ("xfs: repair inodes that have a refcount btree in the data fork")
Cc: stable@vger.kernel.org # v6.14
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 27 +++++++++++++++++++++++----
 fs/xfs/scrub/inode_repair.c          |  7 ++++++-
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 697f5e622685..b91b2f1895ce 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -559,17 +559,36 @@ xfs_iformat_rtrefcount(
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
-	if (level >= mp->m_rtrefc_maxlevels ||
-	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
-		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
-		return -EFSCORRUPTED;
+	if (level == 0) {
+		/*
+		 * rtrefcount inodes can be dynamically created by growfs,
+		 * resulting in a transient state on disk where they can have no
+		 * contents. Hence a rtrefcount inode with an empty level zero
+		 * root is a valid state. Until growfs adds the first realtime
+		 * volume there is nothing to count, so the root must be empty.
+		 */
+		if (mp->m_rtrefc_maxlevels == 0 && numrecs != 0)
+			goto out_corrupt;
+	} else if (level >= mp->m_rtrefc_maxlevels) {
+		/*
+		 * m_rtrefc_maxlevels includes the inode root level, so the
+		 * deepest valid root level is one less than that.
+		 */
+		goto out_corrupt;
 	}
 
+	if (xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize)
+		goto out_corrupt;
+
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
 			xfs_rtrefcount_broot_space_calc(level, numrecs));
 	if (broot)
 		xfs_rtrefcountbt_from_disk(ip, dfp, dsize, broot);
 	return 0;
+
+out_corrupt:
+	xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
+	return -EFSCORRUPTED;
 }
 
 /*
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 4486881329b9..05bb4be29390 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1002,8 +1002,13 @@ xrep_dinode_bad_rtrefcountbt_fork(
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
-	if (level > sc->mp->m_rtrefc_maxlevels)
+	/* Same root level rules as xfs_iformat_rtrefcount(). */
+	if (level == 0) {
+		if (sc->mp->m_rtrefc_maxlevels == 0 && nrecs != 0)
+			return true;
+	} else if (level >= sc->mp->m_rtrefc_maxlevels) {
 		return true;
+	}
 	if (xfs_rtrefcount_droot_space_calc(level, nrecs) > dfork_size)
 		return true;
 	if (level > 0 && nrecs == 0)
-- 
2.55.0

