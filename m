Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E033EC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299997; cv=none; b=aTKdvwN1nUaGSb7/z3jM6hTJ8F/xMzoWqVUMsLdLMKfx2KZ7gAAfIvzdLYjPrES+RLNq4fhcZMuI7sRZDHdGmK6z594J6W0Vqnj91qOXx8RtD9uzL08fkPuFpPLVEVQkwtjGQ6R9w3VugS6sqQUuvWpM2FanEWy94puY9dOytOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299997; c=relaxed/simple;
	bh=LNp8BwzqxFwdFQ9SQbaKdudfu13qBmQTaNPzM/+M/f8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eaS72/W1Nq/LQPe32Zzyq9rcdJqmn0GktTGOEMzpkQlNlqjfw3tIow1JXSU+iFSURXQKtIHaMMYZnKkM3zhe12QI+nHzXCM00dG2c0u9BXvwqxgZ4Z/13mIzbUM7/9ayRFfTtHn2b4YQQ5FtgbqCLhfvBzD4WkMC99vgxgwmyEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpIu/XFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpIu/XFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D9CC4AF07;
	Tue, 30 Jul 2024 00:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299997;
	bh=LNp8BwzqxFwdFQ9SQbaKdudfu13qBmQTaNPzM/+M/f8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jpIu/XFEjJmKeYle8V9q9sn8TcUosYdjXVKXIetXgQ93WvPqKhfglXkP1ki3MoPSb
	 r8btuRKekmXJBUQYgUnXIaKw/s2wK0hHCn3etKA7r31hp+dmrbUg/JmOAssOWW2+Nc
	 6lY/X1dc67rgApi8r3vYdKzDNKzPBqsQGOXiHQaXIo5OtpWMM3xJy48EMpC/ZJmLu3
	 wxQBK4lNhgeMOzAcaec8eTlecVztqnHyzkM7JNy87/9qHWjHKyP50an9aJez/I8zhD
	 BuSzH4E8UerAjnPlFNQUmiiRBMJwpiYjoBW/iYsGuc0VEfkgNeEPm+AJ9bdNpvOZK3
	 XkNLD0MPY2nYQ==
Date: Mon, 29 Jul 2024 17:39:56 -0700
Subject: [PATCH 062/115] xfs: create a hashname function for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843317.1338752.1319753630890554158.stgit@frogsfrogsfrogs>
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

Source kernel commit: fb102fe7fe02e70f8a49cc7f74bc0769cdab2912

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
 libxfs/libxfs_priv.h |   18 ++++++++++++++++++
 libxfs/xfs_attr.c    |    3 +++
 libxfs/xfs_parent.c  |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h  |    5 +++++
 4 files changed, 73 insertions(+)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 4136b277f..023444082 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -618,4 +618,22 @@ int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 /* xfs_inode.h */
 #define xfs_iflags_set(ip, flags)	do { } while (0)
 
+/* linux/wordpart.h */
+
+/**
+ * upper_32_bits - return bits 32-63 of a number
+ * @n: the number we're accessing
+ *
+ * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
+ * the "right shift count >= width of type" warning when that quantity is
+ * 32-bits.
+ */
+#define upper_32_bits(n) ((uint32_t)(((n) >> 16) >> 16))
+
+/**
+ * lower_32_bits - return bits 0-31 of a number
+ * @n: the number we're accessing
+ */
+#define lower_32_bits(n) ((uint32_t)((n) & 0xffffffff))
+
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 345132921..344b34aa4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -436,6 +436,9 @@ xfs_attr_hashval(
 {
 	ASSERT(xfs_attr_check_namespace(attr_flags));
 
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_parent_hashattr(mp, name, namelen, value, valuelen);
+
 	return xfs_attr_hashname(name, namelen);
 }
 
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 50da527b6..7447acc2c 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -87,3 +87,50 @@ xfs_parent_valuecheck(
 
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index ef8aff860..6a4028871 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -12,4 +12,9 @@ bool xfs_parent_namecheck(unsigned int attr_flags, const void *name,
 bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
 		size_t valuelen);
 
+xfs_dahash_t xfs_parent_hashval(struct xfs_mount *mp, const uint8_t *name,
+		int namelen, xfs_ino_t parent_ino);
+xfs_dahash_t xfs_parent_hashattr(struct xfs_mount *mp, const uint8_t *name,
+		int namelen, const void *value, int valuelen);
+
 #endif /* __XFS_PARENT_H__ */

