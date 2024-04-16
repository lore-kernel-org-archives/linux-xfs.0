Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA50B4C7E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230872; cv=none; b=L6PNyH0AaUJXV1y6OVOQzWQ2LPC+m4CpI2o3Hit7tWDQCnPhYKWBG0mInzW86j9ouDDTpzBkQLnUoFNoGU64HTvUX8U93/EDUEmViN4dlpjBVJgKDDfkZENR8woDOj8CR0NxIZZN4W9RbGBkGjSnvWR81ykoU8yoz+TH1bg3dAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230872; c=relaxed/simple;
	bh=AI7R7epW4bJUZlUIHlTLY+cGBYjRXfOB4JZ+F4qbX0A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTwb2RDYtL7bmzyqEXN8eUor7PxOBaxkzCUd//o+AcP9wUmphp/4c/AsXclX0ThACUgmIZRzn8TzyRV37BvNUf8Dqx+sWU7vL0VrQbeGyUBfttn6y0QnLQTMz5peonUfOKUhc0MPOMKOD0cUG7nGTUk5KOma2FBh0TFdl52V9Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VOCXZ3ZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOCXZ3ZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4461C113CC;
	Tue, 16 Apr 2024 01:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230872;
	bh=AI7R7epW4bJUZlUIHlTLY+cGBYjRXfOB4JZ+F4qbX0A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VOCXZ3ZDo06QyHlc6bGtoBFxxcpOkRzg7UEQfS/FKz4xmMTxz8H+4L2ZR5maXdPG7
	 p5LHYEj2Hk8sEES1OA0dGk1I/Z9cLXxmPFSOZtrtcB3N1wYEJeGh8/ev569BjPJc/c
	 mbtBDw18ZI0S3nxH5pJ2qlFy4pA68XBITCSwt6WWY5Ogh0cuU6XSgs3DHjgOpWSxXr
	 BC15rZKcUKjbYeu502HGSu+d5QRWNBqoDswux3Iz7UHJmFhkGFmUscI0hfyV0nc5oo
	 R+6mScnibaLxSkkjHHZdmOfoh6VZQnba61TBWt8wlJ7bxGOWiThu58qvirxy9T1Lul
	 Guaui9TJN1ftg==
Date: Mon, 15 Apr 2024 18:27:52 -0700
Subject: [PATCH 07/31] xfs: allow xattr matching on name and value for parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323027900.251715.3096786344013738685.stgit@frogsfrogsfrogs>
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

If a file is hardlinked with the same name but from multiple parents,
the parent pointers will all have the same dirent name (== attr name)
but with different parent_ino/parent_gen values.  To disambiguate, we
need to be able to match on both the attr name and the attr value.  This
is in contrast to regular xattrs, which are matchtg edit
d only on name.

Therefore, plumb in the ability to match shortform and local attrs on
name and value in the XFS_ATTR_PARENT namespace.  Parent pointer attr
values are never large enough to be stored in a remote attr, so we need
can reject these cases as corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   48 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e54a8372a30a4..e81cd48eb0000 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -514,12 +514,33 @@ static inline unsigned int xfs_attr_match_mask(const struct xfs_da_args *args)
 	return XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE;
 }
 
+static inline bool
+xfs_attr_parent_match(
+	const struct xfs_da_args	*args,
+	const void			*value,
+	unsigned int			valuelen)
+{
+	ASSERT(args->value != NULL);
+
+	/* Parent pointers do not use remote values */
+	if (!value)
+		return false;
+
+	/* The only value we support is a parent rec. */
+	if (valuelen != sizeof(struct xfs_parent_rec))
+		return false;
+
+	return memcmp(args->value, value, valuelen) == 0;
+}
+
 static bool
 xfs_attr_match(
 	struct xfs_da_args	*args,
 	unsigned int		attr_flags,
 	const unsigned char	*name,
-	unsigned int		namelen)
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen)
 {
 	unsigned int		mask = xfs_attr_match_mask(args);
 
@@ -530,6 +551,9 @@ xfs_attr_match(
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
 
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_attr_parent_match(args, value, valuelen);
+
 	return true;
 }
 
@@ -539,6 +563,13 @@ xfs_attr_copy_value(
 	unsigned char		*value,
 	int			valuelen)
 {
+	/*
+	 * Parent pointer lookups require the caller to specify the name and
+	 * value, so don't copy anything.
+	 */
+	if (args->attr_filter & XFS_ATTR_PARENT)
+		return 0;
+
 	/*
 	 * No copy if all we have to do is get the length
 	 */
@@ -748,7 +779,8 @@ xfs_attr_sf_findname(
 	     sfe < xfs_attr_sf_endptr(sf);
 	     sfe = xfs_attr_sf_nextentry(sfe)) {
 		if (xfs_attr_match(args, sfe->flags, sfe->nameval,
-					sfe->namelen))
+				sfe->namelen, &sfe->nameval[sfe->namelen],
+				sfe->valuelen))
 			return sfe;
 	}
 
@@ -2444,18 +2476,22 @@ xfs_attr3_leaf_lookup_int(
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
 			if (!xfs_attr_match(args, entry->flags,
-						name_loc->nameval,
-						name_loc->namelen))
+					name_loc->nameval, name_loc->namelen,
+					&name_loc->nameval[name_loc->namelen],
+					be16_to_cpu(name_loc->valuelen)))
 				continue;
 			args->index = probe;
 			return -EEXIST;
 		} else {
+			unsigned int	valuelen;
+
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
+			valuelen = be32_to_cpu(name_rmt->valuelen);
 			if (!xfs_attr_match(args, entry->flags, name_rmt->name,
-						name_rmt->namelen))
+					name_rmt->namelen, NULL, valuelen))
 				continue;
 			args->index = probe;
-			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
+			args->rmtvaluelen = valuelen;
 			args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
 			args->rmtblkcnt = xfs_attr3_rmt_blocks(
 							args->dp->i_mount,

