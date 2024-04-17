Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B2365190
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389565; cv=none; b=d/5NpgQePwXJ3RPrE81EZlpOJf1Ldv95qUr186ImTUvTxrEWKyB6M8hJuc+vR3ZfKTpc5WqzeCj43SAUIbv4HL25xe+2ApuVDndeAGci6ZgMaMGaCfnIpUNftagVm7xE7I4kdVQug+sG+dwYEskDpspUf7Hf/VtffJookFXhPwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389565; c=relaxed/simple;
	bh=Xngaf9OChoYYL96OCenFtr9+YTz62DQmPv7bG9oHJVQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RWooHzZLNCcKLpelxvIG/V6rONxcIAazKW6MFx5/SobRypsZvNxnwpAmGQPAANFgjtVfs5jonS2uzYioEcwaKN6ZaEEvrYxMBh3dX4LuxZvaKWby6cYHWJZVhv82k78z8JzCCm4J/SjWVvy59qC2l/UrBMrTpnyU82LmY2LkBdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXVLwgE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXVLwgE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79714C072AA;
	Wed, 17 Apr 2024 21:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389564;
	bh=Xngaf9OChoYYL96OCenFtr9+YTz62DQmPv7bG9oHJVQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PXVLwgE/FJw0s3HJIZ1tni+Xd8Los7wGALaDX69T0osO4u3UMBU82eV+2nKq7WeZw
	 MfyoNhPhP06oFy1Ty3Vjs0J220dVGCmULg+piaQ+60cNZBR3Bl3EMHv5+TbF2ZVd+u
	 7LAPZMRBnA+zONQmeStPZUq5NQRqudoiMV7WarL5IymyLS/CxZkcUfLXsJBWsLcBpA
	 Clovw3f1KT+HreviUiuJJPn4aqa0y4x2PW+EwUbYr7Q44jXbQ4rGvXL6XAOcfVPN7K
	 MCozlOVojS8cRwkrHycGA4qSnh+R+0wdqB1wEfjYL/hcNsl+2oItYAYtY9XjNH1sT/
	 bAdlP0WbbFJKQ==
Date: Wed, 17 Apr 2024 14:32:44 -0700
Subject: [PATCH 42/67] xfs: create a new inode fork block unmap helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842970.1853449.10492373904248970387.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_bmap.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_bmap.h |    5 ++---
 2 files changed, 42 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 534a516b5..3520235b5 100644
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
index 8518324db..4b83f6148 100644
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
 

