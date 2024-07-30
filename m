Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F4410E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300279; cv=none; b=VAvi32w54Sp5uqkJyg7367rbDPK1BDQi8m2FkoOf0OxUFXG6A8/YsZw2Z1wse+0GafxsSJKdWFB1pQDBTZJkKMG5JrqXKKgdACClNNl9dAUVkFDokVEIAhIKWUy1SWRtv7Rio1LMVKliPIG9lPfMfZEE0UrHheEE7amHx3KBve8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300279; c=relaxed/simple;
	bh=uGx0bxPqynBnfMwmoMiSrDHnBDi7U3fuxD9qvxvAT8A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrLv2EuWqKZf++Q70lUArAnpG8BPDMZxY7W8ceQibxS2R7PWrUkZeNqpBo7RwyeiwCJVOaNFYEcojgkdYIigfnhUDf4o2Lc7qAXrKHBOzJ+kGUl46+DR35lzWxBNgP9wvCLTmbq/8BrZNO0HwWOGzNIYrz+gIjdUlvXc0Lh752U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Up3ghpqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Up3ghpqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442B2C32786;
	Tue, 30 Jul 2024 00:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300279;
	bh=uGx0bxPqynBnfMwmoMiSrDHnBDi7U3fuxD9qvxvAT8A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Up3ghpqb3u3jp+9CPIV8qrB+qfqTzXiIvtDh5MzVWMIpgjbCvcKHPEkANSFwJaMi6
	 B8cxrCUBmf3rvt8uviu/jfTXaGU+iLoK4tSyTpWGfFAHb6QFbnPY2Cu2nZf1mx8Xsf
	 RwSNj2wZtf5dXxqCPFCIlf52PchBpsOF1cZUIhytoyG8KrBv71cfAGLNcsbxRmq766
	 G+4k142cL9ekgDAqMZ0aHZz/IzPKr8apfh3j3GoKkcX3W7M5YWBCLR414PduLh1KIs
	 WYEGOrIk2XufSo4NNy0whsphfL4QZRHM5unCEu2KQ5+sOCmfL/9dZ1YM0fy9xNB43N
	 ACkCdYqht42+g==
Date: Mon, 29 Jul 2024 17:44:38 -0700
Subject: [PATCH 080/115] xfs: add raw parent pointer apis to support repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843576.1338752.435264629744787870.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5769aa41ee34d4d1cc2b35376107b8e9694698f0

Add a couple of utility functions to set or remove parent pointers from
a file.  These functions will be used by repair code, hence they skip
the xattr logging that regular parent pointer updates use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2.c   |    2 +-
 libxfs/xfs_dir2.h   |    2 +-
 libxfs/xfs_parent.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |    6 +++++
 4 files changed, 72 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 803fb82b2..e309e1e58 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -433,7 +433,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index eb3a5c350..b580a78bc 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -58,7 +58,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 8c29ba61c..84220f10a 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -310,3 +310,67 @@ xfs_parent_lookup(
 	xfs_parent_da_args_init(scratch, tp, pptr, ip, ip->i_ino, parent_name);
 	return xfs_attr_get_ilocked(scratch);
 }
+
+/* Sanity-check a parent pointer before we try to perform repairs. */
+static inline bool
+xfs_parent_sanity_check(
+	struct xfs_mount		*mp,
+	const struct xfs_name		*parent_name,
+	const struct xfs_parent_rec	*pptr)
+{
+	if (!xfs_parent_namecheck(XFS_ATTR_PARENT, parent_name->name,
+				parent_name->len))
+		return false;
+
+	if (!xfs_parent_valuecheck(mp, pptr, sizeof(*pptr)))
+		return false;
+
+	return true;
+}
+
+
+/*
+ * Attach the parent pointer (@parent_name -> @pptr) to @ip immediately.
+ * Caller must not have a transaction or hold the ILOCK.  This is for
+ * specialized repair functions only.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_set(
+	struct xfs_inode	*ip,
+	xfs_ino_t		owner,
+	const struct xfs_name	*parent_name,
+	struct xfs_parent_rec	*pptr,
+	struct xfs_da_args	*scratch)
+{
+	if (!xfs_parent_sanity_check(ip->i_mount, parent_name, pptr)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	memset(scratch, 0, sizeof(struct xfs_da_args));
+	xfs_parent_da_args_init(scratch, NULL, pptr, ip, owner, parent_name);
+	return xfs_attr_set(scratch, XFS_ATTRUPDATE_CREATE, false);
+}
+
+/*
+ * Remove the parent pointer (@parent_name -> @pptr) from @ip immediately.
+ * Caller must not have a transaction or hold the ILOCK.  This is for
+ * specialized repair functions only.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_unset(
+	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
+	const struct xfs_name		*parent_name,
+	struct xfs_parent_rec		*pptr,
+	struct xfs_da_args		*scratch)
+{
+	if (!xfs_parent_sanity_check(ip->i_mount, parent_name, pptr)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	memset(scratch, 0, sizeof(struct xfs_da_args));
+	xfs_parent_da_args_init(scratch, NULL, pptr, ip, owner, parent_name);
+	return xfs_attr_set(scratch, XFS_ATTRUPDATE_REMOVE, false);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 977885823..b8036527c 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -100,5 +100,11 @@ int xfs_parent_from_attr(struct xfs_mount *mp, unsigned int attr_flags,
 int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_name *name, struct xfs_parent_rec *pptr,
 		struct xfs_da_args *scratch);
+int xfs_parent_set(struct xfs_inode *ip, xfs_ino_t owner,
+		const struct xfs_name *name, struct xfs_parent_rec *pptr,
+		struct xfs_da_args *scratch);
+int xfs_parent_unset(struct xfs_inode *ip, xfs_ino_t owner,
+		const struct xfs_name *name, struct xfs_parent_rec *pptr,
+		struct xfs_da_args *scratch);
 
 #endif /* __XFS_PARENT_H__ */

