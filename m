Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCEA17D2
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831646; cv=none; b=Ve0+/R/FAhF24rpDKTV5hiLlpXlNszYrwF7qkDCA6rUclidFgalaBUOrAHXn+/euCHega1FzztRJFnPgvUW9RrZuhOrzW49yDYyvXTT/GtpCaPH3x7x+2ScbYl3CFl42qDScwJOo3mbEhmrnr4nob+olfVYf0GFD2JPFLsyMhrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831646; c=relaxed/simple;
	bh=6ay2H/rAhGnx2NZulZGyE2QDUWqh4OyyTppgGH1KkII=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rwCjfQs8S8V9m6L/J2Mifep5ipPFmxnvzPk3s59UzNnOstFmQ3x0z57g3hnXm3oPZsLpZGsvLpVqoNci/vtJUtYj9EQd1qgXlqXSTst7l1pbACTTIWvDdDpzpBYM4GweDW8tHLIbtRYUvi4fntW36a0kZceVZoH+fFK6JMxIygI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNBQGaLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNBQGaLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2E6C4CECD;
	Wed,  2 Oct 2024 01:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831645;
	bh=6ay2H/rAhGnx2NZulZGyE2QDUWqh4OyyTppgGH1KkII=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kNBQGaLfNWzqHOWFZlJ32Y/8IWyck2v23M6XoKY/XlR4RcgvI0r3B4YEEJNPnNbeK
	 GJB/0q4Jcfvog+1gZkf70z5S3/K/slFn/P1z0itzGkIemegqA3REhgbwIUf9PKLi3q
	 ygMxb6Y1sbxjpaEMnO9NMSNy4UTbsJ83Jqc4ufU/anNsep1unYepZmSAvTPC4cZb49
	 udD1BW4kTggP1Jbh7qBiPtTc6eacDLnmu4p4v15k+M9evMs088gW1iyEmEkPkQyFpu
	 aF1utwTOeaNdzMMe7XUMSHVaKnM4AQzNEWAZqFUMdAtlIurnzTck3PvwexXRJxJPeo
	 W+ngQNlhR7XEw==
Date: Tue, 01 Oct 2024 18:14:05 -0700
Subject: [PATCH 24/64] xfs: separate the icreate logic around INIT_XATTRS
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102143.4036371.7542591036447281184.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: b11b11e3b7a72606cfef527255a9467537bcaaa5

INIT_XATTRS is overloaded here -- it's set during the creat process when
we think that we're immediately going to set some ACL xattrs to save
time.  However, it's also used by the parent pointers code to enable the
attr fork in preparation to receive ppptr xattrs.  This results in
xfs_has_parent() branches scattered around the codebase to turn on
INIT_XATTRS.

Linkable files are created far more commonly than unlinkable temporary
files or directory tree roots, so we should centralize this logic in
xfs_inode_init.  For the three callers that don't want parent pointers
(online repiar tempfiles, unlinkable tempfiles, rootdir creation) we
provide an UNLINKABLE flag to skip attr fork initialization.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_util.c |   36 ++++++++++++++++++++++++++----------
 libxfs/xfs_inode_util.h |    1 +
 2 files changed, 27 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 62af002b2..13c32d114 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -231,6 +231,31 @@ xfs_inode_inherit_flags2(
 	}
 }
 
+/*
+ * If we need to create attributes immediately after allocating the inode,
+ * initialise an empty attribute fork right now. We use the default fork offset
+ * for attributes here as we don't know exactly what size or how many
+ * attributes we might be adding. We can do this safely here because we know
+ * the data fork is completely empty and this saves us from needing to run a
+ * separate transaction to set the fork offset in the immediate future.
+ *
+ * If we have parent pointers and the caller hasn't told us that the file will
+ * never be linked into a directory tree, we /must/ create the attr fork.
+ */
+static inline bool
+xfs_icreate_want_attrfork(
+	struct xfs_mount		*mp,
+	const struct xfs_icreate_args	*args)
+{
+	if (args->flags & XFS_ICREATE_INIT_XATTRS)
+		return true;
+
+	if (!(args->flags & XFS_ICREATE_UNLINKABLE) && xfs_has_parent(mp))
+		return true;
+
+	return false;
+}
+
 /* Initialise an inode's attributes. */
 void
 xfs_inode_init(
@@ -323,16 +348,7 @@ xfs_inode_init(
 		ASSERT(0);
 	}
 
-	/*
-	 * If we need to create attributes immediately after allocating the
-	 * inode, initialise an empty attribute fork right now. We use the
-	 * default fork offset for attributes here as we don't know exactly what
-	 * size or how many attributes we might be adding. We can do this
-	 * safely here because we know the data fork is completely empty and
-	 * this saves us from needing to run a separate transaction to set the
-	 * fork offset in the immediate future.
-	 */
-	if (args->flags & XFS_ICREATE_INIT_XATTRS) {
+	if (xfs_icreate_want_attrfork(mp, args)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 50c14ba6c..1c54c3b0c 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -32,6 +32,7 @@ struct xfs_icreate_args {
 
 #define XFS_ICREATE_TMPFILE	(1U << 0)  /* create an unlinked file */
 #define XFS_ICREATE_INIT_XATTRS	(1U << 1)  /* will set xattrs immediately */
+#define XFS_ICREATE_UNLINKABLE	(1U << 2)  /* cannot link into dir tree */
 	uint16_t		flags;
 };
 

