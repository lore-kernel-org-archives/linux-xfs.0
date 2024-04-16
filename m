Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79422FC1F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231435; cv=none; b=LWl9WgXL5RTd1tLo6XEAAMt6zuf0wwc2/HT3VqQtSaIyq71c/p2lfykUxRVjqnlnR5hZoG5iNpKQIlPXubUIIkmMGUBPMjZ5JAp5R8p84nyYplZfqryRK2kqfFmDyWKRrYZSCAxmT+UoqjYVgIAJHVUK51Nc86WsgN5B+BFUbA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231435; c=relaxed/simple;
	bh=gnU/7fayqT4AJKSUfnkciXEJ0YSijwBo5XMf3kshZ7o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GlX1ROLJWzKjQeOKtMultph4NJMWriedBXXN2eN9Zlv8eH2E+M1YGEzh3aw105/IlXmWJEDodtmDsV4YWZX4bc7UBPlZZ280tHlxfR6a6q7g313me03Fau4THipJ+0nGi7BnZ2yrAxP0AGog/D56URWFIHCXQTM3QsF7y2aiB/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrSoJZZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrSoJZZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ED7C113CC;
	Tue, 16 Apr 2024 01:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231435;
	bh=gnU/7fayqT4AJKSUfnkciXEJ0YSijwBo5XMf3kshZ7o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lrSoJZZiVJCTj9qaIZ7OcUsNlTBDiqFXe/DvPANA+XpEUW+QZ/Rxx3FxYnv/PFdB0
	 caExWs35ZGUnIzlknLS/g6N5bvD+ln/QcNvXyJtD6k3YRL1Rvun+s9GdjT3X58ye/P
	 VFNuKRl1gfgzaSvyC/BIDVw7+yY4xcAA8mE3zXSQKQ4/aajb8B/j6NrEqGipdXwgS/
	 9S2CF/kOpSyBhqyRvfJcuWyuqJn7PHMibLTXVc+yLdUjHiCw6yjgmGCPh6F9xt9Owb
	 RajtnI3T7WgnVJIjYWtRBNmSUT5MttLPg5ZA+AjzD+0fMXjjEWv/mUz8NTPpOVQgah
	 Kwjo7eDTVyMjw==
Date: Mon, 15 Apr 2024 18:37:14 -0700
Subject: [PATCH 05/17] xfs: add raw parent pointer apis to support repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323029266.253068.2220619250735295856.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 381fe57b9124e..04d3ef2a9f330 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -313,3 +313,67 @@ xfs_parent_lookup(
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
+	return xfs_attr_set(scratch, XFS_ATTRUPDATE_UPSERT, false);
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 97788582321a6..b8036527cdc73 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
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

