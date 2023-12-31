Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C24BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ylog1p4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C993C433C7;
	Sun, 31 Dec 2023 20:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056101;
	bh=PVOD6VsNJh2HLiLwvJjKBI4W8e7g8wP3BcFNHRYVrYI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ylog1p4urLUTm++RgYiPgJDppSmXXsc60eaea47e3me2FTwrJQCabNHNB7JalWC7G
	 N8bx7LbF9IeAD+Cu2cKbCRY277b8ME3uHLWeVAQxnrVWEukJzyRBU985JuOtCYiqOF
	 Duoc0JmqeuwdHkvyTzillLOMg3aG0hZPp2uDk7D8rK9I17uDe0xb6HOoh4Vbi+sz7b
	 K+maSUIQI3BgQv/ms+xvyaSV5GtHtOVWm3xttI3+QjNqC5yRBt0w/8yvTBB4MvCnYJ
	 SGOzjZ1DjxocmwIRE/ACDC3yFkbKx5qol6S9ULn/kF/j6P+EEV115mTAt0FRSdjGSI
	 1/bBJwZTCno0A==
Date: Sun, 31 Dec 2023 12:55:01 -0800
Subject: [PATCH 07/22] xfs: add raw parent pointer apis to support repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841860.1757392.15083095858894465536.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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
index 51eed639f2dfe..525b23a3800b6 100644
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
index f99788a1f3e63..ca1949ed4f5e8 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -55,7 +55,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
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

