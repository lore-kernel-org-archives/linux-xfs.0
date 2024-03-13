Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47CEB652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295439; cv=none; b=HZA13MrtaTuTVKutnu/VjMUbpaxmxuzCWj47PecGZmTxQFoeHUodVh7k87kqZ4MnRA7Wi217r3YE0HO56oM0q4j3rQZ+haDlJ3G3MsfTrmcSXllI9Zb8XBMCfdjoJopu3lgn9Rlq9L0jdOoQFMbZHwEn7FHlQTni1VM/reEKYvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295439; c=relaxed/simple;
	bh=kfEd/p39tnm36M9e1MwkD9Sd+S05rXxL6FQnec9v/1w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3eaiWc1+qHoD/xPuqIHOk4Y3QBVrTFB4FZtP47yvXWH8Q2Spnuo0roWmjEXGP/X9gncBK69B8YZkdweT8KhyQNQE3p7GJCBmtHgrtH+3AdxlFWT4oXQKyDno8N9lmJ2J4NVj3QC5UsBlrqO1v/9+B/txGShKo24mDPCxkadEVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XESKkdzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XESKkdzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2750C433C7;
	Wed, 13 Mar 2024 02:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295439;
	bh=kfEd/p39tnm36M9e1MwkD9Sd+S05rXxL6FQnec9v/1w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XESKkdzPr5PriTZMarlBczrCucO5qxVZaAD4B5YLXapnpQQAK7lq75aF4gY1B8xaW
	 RHoQnA9Wh157ELgkE8GsCwrvPTpLUnH/obKq64l362MvfBFU4NXP+YxKUezCvYTela
	 ooMAsUXtMoTpio8r0v0BgWW/7E2gnxlAjmYL27QCEJZ+WhWuTrNgwzSwRO7SmeUKey
	 nWLz/y1qvZ8Ryz48JObv2HOp24FiL6tz/wY54cYuPS/rQrxyKcUzX/oc4UaKvyjeJE
	 7Iw6BWNDTGBni+QeF6rAnyu22nCPWglMjCdK8Ots0Qo4Vovg1uG3D89mT7FowZQs57
	 WC8Xnh9KueJrg==
Date: Tue, 12 Mar 2024 19:03:59 -0700
Subject: [PATCH 42/67] xfs: create a new inode fork block unmap helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431799.2061787.16604578276243163129.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: a59eb5fc21b2a6dc160ee6cdf77f20bc186a88fd

Create a new helper to unmap blocks from an inode's fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_bmap.h |    5 ++---
 2 files changed, 42 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 534a516b59ba..3520235b58af 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5233,7 +5233,7 @@ xfs_bmap_del_extent_real(
  * that value.  If not all extents in the block range can be removed then
  * *done is set.
  */
-int						/* error */
+static int
 __xfs_bunmapi(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode */
@@ -6214,3 +6214,42 @@ xfs_bmap_validate_extent(
 	return xfs_bmap_validate_extent_raw(ip->i_mount,
 			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
 }
+
+/*
+ * Used in xfs_itruncate_extents().  This is the maximum number of extents
+ * freed from a file in a single transaction.
+ */
+#define	XFS_ITRUNC_MAX_EXTENTS	2
+
+/*
+ * Unmap every extent in part of an inode's fork.  We don't do any higher level
+ * invalidation work at all.
+ */
+int
+xfs_bunmapi_range(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	uint32_t		flags,
+	xfs_fileoff_t		startoff,
+	xfs_fileoff_t		endoff)
+{
+	xfs_filblks_t		unmap_len = endoff - startoff + 1;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	while (unmap_len > 0) {
+		ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
+		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len, flags,
+				XFS_ITRUNC_MAX_EXTENTS);
+		if (error)
+			goto out;
+
+		/* free the just unmapped extents */
+		error = xfs_defer_finish(tpp);
+		if (error)
+			goto out;
+	}
+out:
+	return error;
+}
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 8518324db285..4b83f6148e00 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -190,9 +190,6 @@ int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
-int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
-		xfs_fileoff_t bno, xfs_filblks_t *rlen, uint32_t flags,
-		xfs_extnum_t nexts);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extnum_t nexts, int *done);
@@ -273,6 +270,8 @@ int xfs_bmap_complain_bad_rec(struct xfs_inode *ip, int whichfork,
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
 		uint32_t flags);
+int	xfs_bunmapi_range(struct xfs_trans **tpp, struct xfs_inode *ip,
+		uint32_t flags, xfs_fileoff_t startoff, xfs_fileoff_t endoff);
 
 extern struct kmem_cache	*xfs_bmap_intent_cache;
 

