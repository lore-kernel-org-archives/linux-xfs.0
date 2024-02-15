Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616D95466D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998961; cv=none; b=oVZstcmvnz8zpu7IErSTHBMCS6oc+rodOsRUyd5b0Rem5/fAx9TvUoqLN+MYyvNje57ov+4Qyt3NPGvB/V/NPLuGURHB0axkWapuOUSXOedlDpbFQfLQZYgX8mn87pYUyUJ7K8Pmptty+iz5vKseFrI2foXkEEIhl8gL+JGiCxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998961; c=relaxed/simple;
	bh=rdaNw4/APeaBiP64rgMozc9f5nvV9fJx9rM9HpkrQF4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J33BcC7lY5LuOHfHEsvJJWZ20B0BNNsh2JfW/O4foAHjvVMGQji3lSivBnatsEtDdeGSIp3NVZ5/C1em1ziWSQv7e/27d9d34zdNHekFYRV1S3V7MPZiWf2Cp93yap4Jvlmkfj4fc9y9L+jqkd4CkQnV2VQmNzeMGBk7KePlEN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuEAazeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuEAazeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A8EC433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998961;
	bh=rdaNw4/APeaBiP64rgMozc9f5nvV9fJx9rM9HpkrQF4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TuEAazeKzdQoN32Z3FY+jDpk7XAicw1Aq1oofF9m4qPFWpX05Sm0Ug48oBpROjHPm
	 p/0EJugRaRdQAECbX6/+09y77CRmZRzaKIm7hu6n15bCLZPkKS2gBI+EUMJjBLmnXu
	 /qeqonOcZ5DOYPmJFhfo0HAAcffnnpakr1qhTA/UQpBWln6TNMjC9PU0VTo58xHwEg
	 Im05XVcISv4i3v5eRcOrfRHoa4fKhy8VJyml9fi7qJZ19UvOphEfpS4F1sQC++hRdy
	 QpTij7kCaiTJtne7Ip09gswDCQl+1QAjCe02vS6TO9lokaL6e7vM9ZGyXOTNH5/AaH
	 HN3C/73L1MFEg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 06/35] xfs: convert rt bitmap/summary block numbers to xfs_fileoff_t
Date: Thu, 15 Feb 2024 13:08:18 +0100
Message-ID: <20240215120907.1542854-7-cem@kernel.org>
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

Source kernel commit: 03f4de332e2e79db36ed2156fb2350480f142bec

We should use xfs_fileoff_t to store the file block offset of any
location within the realtime bitmap or summary files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 22 +++++++++++-----------
 libxfs/xfs_rtbitmap.h | 12 ++++++------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 976b1aca6..9a9097edd 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -53,7 +53,7 @@ int
 xfs_rtbuf_get(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	block,		/* block number in bitmap or summary */
+	xfs_fileoff_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
 	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
@@ -99,7 +99,7 @@ xfs_rtfind_back(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -274,7 +274,7 @@ xfs_rtfind_forw(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -444,15 +444,15 @@ xfs_rtmodify_summary_int(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
 	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
-	xfs_fsblock_t	sb;		/* summary fsblock */
+	xfs_fileoff_t	sb;		/* summary fsblock */
 	int		so;		/* index into the summary file */
 	xfs_suminfo_t	*sp;		/* pointer to returned data */
 
@@ -514,10 +514,10 @@ xfs_rtmodify_summary(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
 					delta, rbpp, rsb, NULL);
@@ -537,7 +537,7 @@ xfs_rtmodify_range(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -690,7 +690,7 @@ xfs_rtfree_range(
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_rtxlen_t	len,		/* length to free */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
 	int		error;		/* error value */
@@ -771,7 +771,7 @@ xfs_rtcheck_range(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index d44496101..e2ea6d31c 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -24,7 +24,7 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 
 #ifdef CONFIG_XFS_RT
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+		  xfs_fileoff_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		      xfs_rtblock_t start, xfs_rtxlen_t len, int val,
 		      xfs_rtblock_t *new, int *stat);
@@ -37,15 +37,15 @@ int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		       xfs_rtblock_t start, xfs_rtxlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
-			     int log, xfs_rtblock_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
+			     int log, xfs_fileoff_t bbno, int delta,
+			     struct xfs_buf **rbpp, xfs_fileoff_t *rsb,
 			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fsblock_t *rsb);
+			 xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
+			 xfs_fileoff_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_rtxlen_t len,
-		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+		     struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
-- 
2.43.0

