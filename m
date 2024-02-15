Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E1212BF3D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998988; cv=none; b=JqivAREqXMeCB7R0/pO04r5UG+VO4Ta02173M/tFKRz9NZEA3Aoqw6dQrk+YzQacWMeBTSSwwT3fOmlbUygiYYTvcS8VZrlNCQzTt+n1D4MMtBCd8w2/AEqwcs5oC4xvuZNMDAziv2JbOM4wJ/wGO2fBa2DiF+hEvt3CdjACQV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998988; c=relaxed/simple;
	bh=OzlZIYmL9LsNFiOGzKu9Cs/L6LMBKv8mToJm2XKDYro=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2qMBhnT8XR3pV4BVqU0qdF5qK8xvsfVp5S2ntISHe1dUSEw6WssbDdT9OLuAZmLlCi3jVq25yg6EyzUuUDn79bj9Sg3dKY5wXfg7HBcyAJi35TRm8DhokcggA3ftSUcCanAJnsqM+SorD82LB/D03+MJEMN5LijnzN3WR8asQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdxkiUMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdxkiUMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D371FC433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998987;
	bh=OzlZIYmL9LsNFiOGzKu9Cs/L6LMBKv8mToJm2XKDYro=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TdxkiUMSrIaCBcj2ZKlxbFSpHFyOAvG+vnVSGGusNg1l2kmnE24N29bx1zWZ6vk36
	 UrJZtuhQq6P8MyMsOzAHzy8VeqCxDot0MmCETWtcJwXDi6T4yB6+HsrE5+zxA+Qj+h
	 VvKgF98FM2xU/FFEwkWQadrhGZFPo69puikwDQbvYbURfOI2odOOoCsF2GjZznICYo
	 bTArC8ZgUM2lQPMmbHNF9VcQmLRLvyaHCQtD0twprjqsLOVYEr1NkMg5bPnXee1kc0
	 4aLiaGYRY6I0SZXbgVuZur/PdoFPCi3mFEOaEyTQAFOTdU9ApNDRrlCgRnbAJzVLEN
	 cyvvHNTHsn5rQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 30/35] xfs: simplify rt bitmap/summary block accessor functions
Date: Thu, 15 Feb 2024 13:08:42 +0100
Message-ID: <20240215120907.1542854-31-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: e2cf427c91494ea0d1173a911090c39665c5fdef

Simplify the calling convention of these functions since the
xfs_rtalloc_args structure contains the parameters we need.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 61 ++++++++++++++++++++-----------------------
 libxfs/xfs_rtbitmap.h | 24 ++++++++---------
 2 files changed, 41 insertions(+), 44 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index bc3ce7bce..f5d7e14ab 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -171,7 +171,7 @@ xfs_rtfind_back(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	incore = xfs_rtbitmap_getword(args->rbmbp, word);
+	incore = xfs_rtbitmap_getword(args, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -226,7 +226,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -265,7 +265,7 @@ xfs_rtfind_back(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -325,7 +325,7 @@ xfs_rtfind_forw(
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
 	 */
-	incore = xfs_rtbitmap_getword(args->rbmbp, word);
+	incore = xfs_rtbitmap_getword(args, word);
 	want = (incore & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
 	/*
 	 * If the starting position is not word-aligned, deal with the
@@ -379,7 +379,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = incore ^ want)) {
 			/*
 			 * Different, mark where we are and return.
@@ -416,7 +416,7 @@ xfs_rtfind_forw(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = (incore ^ want) & mask)) {
 			/*
 			 * Different, mark where we are and return.
@@ -437,16 +437,16 @@ xfs_rtfind_forw(
 /* Log rtsummary counter at @infoword. */
 static inline void
 xfs_trans_log_rtsummary(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		infoword)
 {
+	struct xfs_buf		*bp = args->sumbp;
 	size_t			first, last;
 
-	first = (void *)xfs_rsumblock_infoptr(bp, infoword) - bp->b_addr;
+	first = (void *)xfs_rsumblock_infoptr(args, infoword) - bp->b_addr;
 	last = first + sizeof(xfs_suminfo_t) - 1;
 
-	xfs_trans_log_buf(tp, bp, first, last);
+	xfs_trans_log_buf(args->tp, bp, first, last);
 }
 
 /*
@@ -490,8 +490,7 @@ xfs_rtmodify_summary_int(
 	 */
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
 	if (delta) {
-		xfs_suminfo_t	val = xfs_suminfo_add(args->sumbp, infoword,
-						      delta);
+		xfs_suminfo_t	val = xfs_suminfo_add(args, infoword, delta);
 
 		if (mp->m_rsum_cache) {
 			if (val == 0 && log == mp->m_rsum_cache[bbno])
@@ -499,11 +498,11 @@ xfs_rtmodify_summary_int(
 			if (val != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_rtsummary(args->tp, args->sumbp, infoword);
+		xfs_trans_log_rtsummary(args, infoword);
 		if (sum)
 			*sum = val;
 	} else if (sum) {
-		*sum = xfs_suminfo_get(args->sumbp, infoword);
+		*sum = xfs_suminfo_get(args, infoword);
 	}
 	return 0;
 }
@@ -521,17 +520,17 @@ xfs_rtmodify_summary(
 /* Log rtbitmap block from the word @from to the byte before @next. */
 static inline void
 xfs_trans_log_rtbitmap(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		from,
 	unsigned int		next)
 {
+	struct xfs_buf		*bp = args->rbmbp;
 	size_t			first, last;
 
-	first = (void *)xfs_rbmblock_wordptr(bp, from) - bp->b_addr;
-	last = ((void *)xfs_rbmblock_wordptr(bp, next) - 1) - bp->b_addr;
+	first = (void *)xfs_rbmblock_wordptr(args, from) - bp->b_addr;
+	last = ((void *)xfs_rbmblock_wordptr(args, next) - 1) - bp->b_addr;
 
-	xfs_trans_log_buf(tp, bp, first, last);
+	xfs_trans_log_buf(args->tp, bp, first, last);
 }
 
 /*
@@ -589,12 +588,12 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if (val)
 			incore |= mask;
 		else
 			incore &= ~mask;
-		xfs_rtbitmap_setword(args->rbmbp, word, incore);
+		xfs_rtbitmap_setword(args, word, incore);
 		i = lastbit - bit;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -605,8 +604,7 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword,
-					word);
+			xfs_trans_log_rtbitmap(args, firstword, word);
 			error = xfs_rtbitmap_read_buf(args, ++block);
 			if (error)
 				return error;
@@ -627,7 +625,7 @@ xfs_rtmodify_range(
 		/*
 		 * Set the word value correctly.
 		 */
-		xfs_rtbitmap_setword(args->rbmbp, word, val);
+		xfs_rtbitmap_setword(args, word, val);
 		i += XFS_NBWORD;
 		/*
 		 * Go on to the next block if that's where the next word is
@@ -638,8 +636,7 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword,
-					word);
+			xfs_trans_log_rtbitmap(args, firstword, word);
 			error = xfs_rtbitmap_read_buf(args, ++block);
 			if (error)
 				return error;
@@ -659,19 +656,19 @@ xfs_rtmodify_range(
 		/*
 		 * Set/clear the active bits.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if (val)
 			incore |= mask;
 		else
 			incore &= ~mask;
-		xfs_rtbitmap_setword(args->rbmbp, word, incore);
+		xfs_rtbitmap_setword(args, word, incore);
 		word++;
 	}
 	/*
 	 * Log any remaining changed bytes.
 	 */
 	if (word > firstword)
-		xfs_trans_log_rtbitmap(args->tp, args->rbmbp, firstword, word);
+		xfs_trans_log_rtbitmap(args, firstword, word);
 	return 0;
 }
 
@@ -808,7 +805,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -847,7 +844,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = incore ^ val)) {
 			/*
 			 * Different, compute first wrong bit and return.
@@ -885,7 +882,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute difference between actual and desired value.
 		 */
-		incore = xfs_rtbitmap_getword(args->rbmbp, word);
+		incore = xfs_rtbitmap_getword(args, word);
 		if ((wdiff = (incore ^ val) & mask)) {
 			/*
 			 * Different, compute first wrong bit and return.
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index b5505da7a..db2f8c924 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -175,10 +175,10 @@ xfs_rbmblock_to_rtx(
 /* Return a pointer to a bitmap word within a rt bitmap block. */
 static inline union xfs_rtword_raw *
 xfs_rbmblock_wordptr(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_rtword_raw	*words = bp->b_addr;
+	union xfs_rtword_raw	*words = args->rbmbp->b_addr;
 
 	return words + index;
 }
@@ -186,10 +186,10 @@ xfs_rbmblock_wordptr(
 /* Convert an ondisk bitmap word to its incore representation. */
 static inline xfs_rtword_t
 xfs_rtbitmap_getword(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
+	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
 	return word->old;
 }
@@ -197,11 +197,11 @@ xfs_rtbitmap_getword(
 /* Set an ondisk bitmap word from an incore representation. */
 static inline void
 xfs_rtbitmap_setword(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index,
 	xfs_rtword_t		value)
 {
-	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
+	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
 	word->old = value;
 }
@@ -248,10 +248,10 @@ xfs_rtsumoffs_to_infoword(
 /* Return a pointer to a summary info word within a rt summary block. */
 static inline union xfs_suminfo_raw *
 xfs_rsumblock_infoptr(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_suminfo_raw	*info = bp->b_addr;
+	union xfs_suminfo_raw	*info = args->sumbp->b_addr;
 
 	return info + index;
 }
@@ -259,10 +259,10 @@ xfs_rsumblock_infoptr(
 /* Get the current value of a summary counter. */
 static inline xfs_suminfo_t
 xfs_suminfo_get(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
+	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
 	return info->old;
 }
@@ -270,11 +270,11 @@ xfs_suminfo_get(
 /* Add to the current value of a summary counter and return the new value. */
 static inline xfs_suminfo_t
 xfs_suminfo_add(
-	struct xfs_buf		*bp,
+	struct xfs_rtalloc_args	*args,
 	unsigned int		index,
 	int			delta)
 {
-	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
+	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
 	info->old += delta;
 	return info->old;
-- 
2.43.0

