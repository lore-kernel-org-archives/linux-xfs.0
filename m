Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E4733D8
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230982; cv=none; b=I+t38XIoydLRjgvG0ztiZsF/TQN/Wz5NSYhhsdS/8b4BWn+D+qhAvpSWTKQlJECtIxbDVmfmzMMPgZ9O3sbrl0zPj8iqL5UugsB8Q8c1Kb0SvLt/HbhHHDB77jJdUlgO5MQ8CNwKYW+9Kkj9+wvwaf6cjM0NRMFYoMOv3+U2TMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230982; c=relaxed/simple;
	bh=w5LRgZlNSFM3MloyLT6AWqGuWvrVuhJHMI0exjIPn+k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COAA5FEPG+exsAvSAE8vS9QWrVcmfmXpE26nYB63f8tl1YKk5jzcypHhpL7GR0I7pgabggx9uU0l/L0j/dAsoiJMwDH+2XPD1E8u8TCq9ZlH3HTqB2oB1x2mVh7ApZvIGN3FIbbJXioapdowmw7Nk7V9PCGmkk1AC7qqUvyPZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDJRx3dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDJRx3dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC76C113CC;
	Tue, 16 Apr 2024 01:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230982;
	bh=w5LRgZlNSFM3MloyLT6AWqGuWvrVuhJHMI0exjIPn+k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bDJRx3dwQX4FLjJRNidP4jNlDLRUBjHUbBwUvQs1fUBAMbUGcqYi2XD1m9tH5uUfe
	 oHYUz9HKQVblw1QXyC1sXaGfey+vBdf0S4EXKUBN//O08Ix03XcCWJEiECfWZ4n32V
	 qfN94D5pz3exiaQz8DEnpsTyKwP/1uhFFJ/+z/3Bv8wMUL/1EKjDe2nIGI6Nm129en
	 uVesIeJab6UzGZFDfb48nau+JhSCDd+U1Vq9yNdQyf/3T1DtCgzL0Gfc9ZddQBZFkH
	 v0JGzCG8/QhmeHFEarOQ8kTv9lTselzXrjiaL+hcn1VT6Ci38hVSHxmEcdVdBAyD6q
	 wxpKT7o2lSESg==
Date: Mon, 15 Apr 2024 18:29:41 -0700
Subject: [PATCH 14/31] xfs: create a hashname function for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028013.251715.2767871821524411117.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

Although directory entry and parent pointer recordsets look very similar
(name -> ino), there's one major difference between them: a file can be
hardlinked from multiple parent directories with the same filename.
This is common in shared container environments where a base directory
tree might be hardlink-copied multiple times.  IOWs the same 'ls'
program might be hardlinked to multiple /srv/*/bin/ls paths.

We don't want parent pointer operations to bog down on hash collisions
between the same dirent name, so create a special hash function that
mixes in the parent directory inode number.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c   |    3 +++
 fs/xfs/libxfs/xfs_parent.c |   47 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |    5 +++++
 fs/xfs/scrub/attr.c        |    4 ++++
 4 files changed, 59 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 93524efa6e56c..8c283e5c24702 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -437,6 +437,9 @@ xfs_attr_hashval(
 {
 	ASSERT(xfs_attr_check_namespace(attr_flags));
 
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_parent_hashattr(mp, name, namelen, value, valuelen);
+
 	return xfs_attr_hashname(name, namelen);
 }
 
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 5961fa8c85615..d564baf2549c5 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -90,3 +90,50 @@ xfs_parent_valuecheck(
 
 	return true;
 }
+
+/* Compute the attribute name hash for a parent pointer. */
+xfs_dahash_t
+xfs_parent_hashval(
+	struct xfs_mount		*mp,
+	const uint8_t			*name,
+	int				namelen,
+	xfs_ino_t			parent_ino)
+{
+	struct xfs_name			xname = {
+		.name			= name,
+		.len			= namelen,
+	};
+
+	/*
+	 * Use the same dirent name hash as would be used on the directory, but
+	 * mix in the parent inode number to avoid collisions on hardlinked
+	 * files with identical names but different parents.
+	 */
+	return xfs_dir2_hashname(mp, &xname) ^
+		upper_32_bits(parent_ino) ^ lower_32_bits(parent_ino);
+}
+
+/* Compute the attribute name hash from the xattr components. */
+xfs_dahash_t
+xfs_parent_hashattr(
+	struct xfs_mount		*mp,
+	const uint8_t			*name,
+	int				namelen,
+	const void			*value,
+	int				valuelen)
+{
+	const struct xfs_parent_rec	*rec = value;
+
+	/* Requires a local attr value in xfs_parent_rec format */
+	if (valuelen != sizeof(struct xfs_parent_rec)) {
+		ASSERT(valuelen == sizeof(struct xfs_parent_rec));
+		return 0;
+	}
+
+	if (!value) {
+		ASSERT(value != NULL);
+		return 0;
+	}
+
+	return xfs_parent_hashval(mp, name, namelen, be64_to_cpu(rec->p_ino));
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index ef8aff8607801..6a4028871b72a 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -12,4 +12,9 @@ bool xfs_parent_namecheck(unsigned int attr_flags, const void *name,
 bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
 		size_t valuelen);
 
+xfs_dahash_t xfs_parent_hashval(struct xfs_mount *mp, const uint8_t *name,
+		int namelen, xfs_ino_t parent_ino);
+xfs_dahash_t xfs_parent_hashattr(struct xfs_mount *mp, const uint8_t *name,
+		int namelen, const void *value, int valuelen);
+
 #endif /* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 22d7ef4df1699..c07d050b39b2e 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -536,6 +536,10 @@ xchk_xattr_rec(
 			xchk_da_set_corrupt(ds, level);
 			goto out;
 		}
+		if (ent->flags & XFS_ATTR_PARENT) {
+			xchk_da_set_corrupt(ds, level);
+			goto out;
+		}
 		calc_hash = xfs_attr_hashval(mp, ent->flags, rentry->name,
 					     rentry->namelen, NULL,
 					     be32_to_cpu(rentry->valuelen));

