Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC23391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711053; cv=none; b=J8ozwSRTu7unGKtCWVmR3ND8IF9xwX9MU7XM/VOkdJk7J9ZhixsIy2OVv0Id7kyhVIaCWVO9bQCly/ta0ozBj84U/LbXt8Lur6BARcFYP4x3EXSqYZncYmXCQg6kqQbPfgDtUK+jlzTe9lbzovXNhr7d7q451NhaKJbXIf/lgDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711053; c=relaxed/simple;
	bh=88ee3moJGqPlFQ2Q2hldTnLAxQ+OqDcEvWUB0Jvl1WE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oB+/B/TJOciPx7eIQ7WUu+h3j89dSiJUNWRSM06jGfSYG+nw2dBl8Iky5Lh/ZTcCOpx+i/W/k8CnqCXBLKoxqHRQRrsYUK5FzoEYQHYktMXgWzeEdGVKcfKBrqN42MMXsGKb+UkwP0D2o8FqibOzvV3T9WpKFfGgvfNGMlnuv7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rmdny3sA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rmdny3sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B70C433C7;
	Wed, 10 Apr 2024 01:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711052;
	bh=88ee3moJGqPlFQ2Q2hldTnLAxQ+OqDcEvWUB0Jvl1WE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rmdny3sAg2bb0HR9FEGHXCMyFhs/j4qOT42YubzYr1YHMlRLVFVyPKSJQ8wpVb5Db
	 tWweq675LycwzlbTUE+e4fpriegPw3L1RYylbxFmJPb5IE4Diq2pH/DR6pxyRQY/K6
	 pI94CSA4p0sX3l2Yegk0sNgiUcvreONo682esqUwHIQLrrn/bkHYYqgwexZcm2c8y6
	 wQAwWGRczRZbXQkxMZG7mVktEsyRMluJ4dU3o9+r/6WeOQSHIvcDxn5Iud8ExYhNKP
	 kFUEcU2dPDFD8tGPdQGU1/BmGQKsZThUMmFK+HiWYUozwGUxW+Bs1REk7J0OEk9qju
	 7bLCE3zF0HlaA==
Date: Tue, 09 Apr 2024 18:04:12 -0700
Subject: [PATCH 02/14] xfs: add raw parent pointer apis to support repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971021.3632937.6862433314181408424.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_dir2.c   |    2 +
 fs/xfs/libxfs/xfs_dir2.h   |    2 +
 fs/xfs/libxfs/xfs_parent.c |   64 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |    6 ++++
 4 files changed, 72 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 9da99fa20c759..7634344dc5153 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -434,7 +434,7 @@ int
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
index 5898dc1ebff02..2b6ed8c1ee152 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -316,3 +316,67 @@ xfs_parent_lookup(
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
+	return xfs_attr_setname(scratch, true);
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
+	return xfs_attr_removename(scratch, true);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index b063312a61acb..0312f70217fb5 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -100,5 +100,11 @@ int xfs_parent_from_xattr(struct xfs_mount *mp, unsigned int attr_flags,
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

