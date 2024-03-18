Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA9B5A4C2
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798590; cv=none; b=Wt4bByX2TB6Wv+7wy2n05WwP1mjZQHPQQxV1jhG2PJ6ZHvYHNrDvLNSpoEAv0UgzFewGSWNgGtitk7bfb2h2CZ57Jz/BLNhxgXl4Ns0MjiS9FwO6vNyFtq7g/1c1Att6NTdKxLFI1y3GEVauvJ5jwvHOUn5+Drn7gXazO8Lp5kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798590; c=relaxed/simple;
	bh=2mcC/YXw22BAeaTR4IAzGO2A2D2P978XDpb8NTX1iUs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DPfbzJRMqWfnzHMTvNVDzv3XfIJx7dL/dQTdBVcU35fiko/VYtuwPmS6gbCV19ANPLbRFoIyGH5Jq3jOmdiwL5scJaZvvejHfykKwPfZ9EPaKvbjVV6piS+GMEZ2tsU9MkZCUHzoxfutaK6o7kqbciiDSQnPVt7+Bmas/VHQn/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxB5Rs83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxB5Rs83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61B8C433F1;
	Mon, 18 Mar 2024 21:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798589;
	bh=2mcC/YXw22BAeaTR4IAzGO2A2D2P978XDpb8NTX1iUs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GxB5Rs83OKD7gIV0F8hZW3B+0Ug4/NkT4hFF7W8G0VP4Ix7w33xJcEpbD2C6B96ep
	 HO3accypRXRxl4iqB/MsKreCeIpXh/Q+5E78Cp5o65/fe9xakYAI/97x+hRvKH0e8J
	 KwalA8FYp55mPIaJdqXY0YiKY8vcM2WwDLRu2kGKbGs5oQh8ZFYm0iPN5FzRZRz4Zs
	 +AgCuVUp2EHddK5M25XanW3gdiH7/TtEEK9UvqW7CZGKb8senUfpBvGPwRYMcxfZty
	 uEc/t944e0scNrvKWrFrDtJH/brBbBX/NbftdoTTL83Q0rwOLp2ET1WO/sN4RdccBf
	 6Ckl55rQaoZPg==
Date: Mon, 18 Mar 2024 14:49:49 -0700
Subject: [PATCH 07/23] xfs: add raw parent pointer apis to support repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802808.3808642.11078626234871866883.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

Add a couple of utility functions to set or remove parent pointers from
a file.  These functions will be used by repair code, hence they skip
the xattr logging that regular parent pointer updates use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c   |    2 +-
 fs/xfs/libxfs/xfs_dir2.h   |    2 +-
 fs/xfs/libxfs/xfs_parent.c |   46 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |    8 ++++++++
 4 files changed, 56 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 654583b5190a9..eb9210bd1ae99 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -440,7 +440,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index eb3a5c35025b5..b580a78bcf4fc 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -58,7 +58,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 09495eb368e2b..3c31c04dd9a20 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -420,3 +420,49 @@ xfs_parent_lookup(
 
 	return xfs_attr_get_ilocked(&scr->args);
 }
+
+/*
+ * Attach the parent pointer (@pptr -> @name) to @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  This is for specialized repair
+ * functions only.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_set(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	if (XFS_IS_CORRUPT(ip->i_mount,
+			!xfs_parent_verify_irec(ip->i_mount, pptr))) {
+		return -EFSCORRUPTED;
+	}
+
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_LOGGED;
+
+	return xfs_attr_set(&scr->args);
+}
+
+/*
+ * Remove the parent pointer (@rec -> @name) from @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  This is for specialized repair
+ * functions only.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_unset(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	if (XFS_IS_CORRUPT(ip->i_mount,
+			!xfs_parent_verify_irec(ip->i_mount, pptr))) {
+		return -EFSCORRUPTED;
+	}
+
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_LOGGED | XFS_DA_OP_REMOVE;
+
+	return xfs_attr_set(&scr->args);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index e4443da1d86f2..58e59af818bd2 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -162,4 +162,12 @@ int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
+int xfs_parent_set(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
+int xfs_parent_unset(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *rec,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */

