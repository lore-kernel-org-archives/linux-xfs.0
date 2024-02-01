Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676CC85286
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817381; cv=none; b=ljs9VMdxa7yW5gifvaX84uv02kQ/HYf/HvqA/0YkJPIeR48RHyrXDDStuKp9QG39XCBqem4m66H4nzv6xdJ/8kO/opPkphaGA+OOucP5oKMpT8M1wmKvJVuxkytohrbsnSylZTeZW9TR2DXHfWre9/DQ8R+xQ+omG17ET1c8K2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817381; c=relaxed/simple;
	bh=6psr/O7SSM8ZuLIXXTCi3J4LVnVP1HaDmpuuo1TuXtI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdqJJr/PlQpkS3mVd6vcJx28JLBSIlq7xZ8bOBRJ78HV0IFurG726GpFv4j20RznOHLSM8nVx7Qr/ZZ7gRGcaQzMjr5yfMCsRA+NPmoPKI07vcDi8rnnREZJcHQxDrQRXa3Wdtl+v53rgOtE8wlS7wWbzv+7JSKPBXwPweiYqwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZ5J5vIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZ5J5vIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366E0C433F1;
	Thu,  1 Feb 2024 19:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817381;
	bh=6psr/O7SSM8ZuLIXXTCi3J4LVnVP1HaDmpuuo1TuXtI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hZ5J5vIUM5rcLRY/aGnapowvRekvLm/KcqX3V/N5nwenYNdNCnXdJP9oV7em5Hh5j
	 FsNFPmUPbEX8ESbb3WAG0qaOi43s51nuPVWCrs1sxEeeDsBKBu7CNiBseMoDj5hte6
	 M3fAyN8O9CAd02zEhAxeH0buXe/N5EoXmu/JdZ4pp2okjzX9FJ7YVgHwI80jumEsXn
	 1+dyqNRubni6S8leh2dxYsDWiZtLeVqh+cUC5VZWR1uali3mYV0CeV1JA1PK8ySrE8
	 rW8+HTmdDTzzn+hd9T2ze5uNUOTPNgrAMAq0xo/xsMiIaNqWI6nd/5zKm40hNbTHNd
	 FQpp2sKueZwAg==
Date: Thu, 01 Feb 2024 11:56:20 -0800
Subject: [PATCH 4/4] xfs: split xfs_buf_rele for cached vs uncached buffers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336195.1608096.7359208662047509867.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
References: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
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

xfs_buf_rele is a bit confusing because it mixes up handling of normal
cached and the special uncached buffers without much explanation.
Split the handling into two different helpers, and use a clearly named
helper that checks the hash key to distinguish the two cases instead
of checking the pag pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8e5bd50d29feb..79a87fb399064 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -60,6 +60,11 @@ xfs_buf_submit(
 	return __xfs_buf_submit(bp, !(bp->b_flags & XBF_ASYNC));
 }
 
+static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
+{
+	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
+}
+
 static inline int
 xfs_buf_is_vmapped(
 	struct xfs_buf	*bp)
@@ -990,12 +995,19 @@ xfs_buf_hold(
 	atomic_inc(&bp->b_hold);
 }
 
-/*
- * Release a hold on the specified buffer. If the hold count is 1, the buffer is
- * placed on LRU or freed (depending on b_lru_ref).
- */
-void
-xfs_buf_rele(
+static void
+xfs_buf_rele_uncached(
+	struct xfs_buf		*bp)
+{
+	ASSERT(list_empty(&bp->b_lru));
+	if (atomic_dec_and_test(&bp->b_hold)) {
+		xfs_buf_ioacct_dec(bp);
+		xfs_buf_free(bp);
+	}
+}
+
+static void
+xfs_buf_rele_cached(
 	struct xfs_buf		*bp)
 {
 	struct xfs_perag	*pag = bp->b_pag;
@@ -1004,15 +1016,6 @@ xfs_buf_rele(
 
 	trace_xfs_buf_rele(bp, _RET_IP_);
 
-	if (!pag) {
-		ASSERT(list_empty(&bp->b_lru));
-		if (atomic_dec_and_test(&bp->b_hold)) {
-			xfs_buf_ioacct_dec(bp);
-			xfs_buf_free(bp);
-		}
-		return;
-	}
-
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 
 	/*
@@ -1080,6 +1083,19 @@ xfs_buf_rele(
 		xfs_buf_free(bp);
 }
 
+/*
+ * Release a hold on the specified buffer.
+ */
+void
+xfs_buf_rele(
+	struct xfs_buf		*bp)
+{
+	trace_xfs_buf_rele(bp, _RET_IP_);
+	if (xfs_buf_is_uncached(bp))
+		xfs_buf_rele_uncached(bp);
+	else
+		xfs_buf_rele_cached(bp);
+}
 
 /*
  *	Lock a buffer object, if it is not already locked.

