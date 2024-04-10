Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57AB38B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710520; cv=none; b=M/McnGxjzW5sWUzISrn/KgilFqiMyvQ8bNDdkDtg0BrDuNxOc6abhEiq8TlOLvjoJpBgQCBJh2Delvr8ISY1v4qRTJQ74490Vw1MbrZicvt6VX+bnS+GpBwFpo2F+CgL3lItM0ATeQsUJGmQiXmmutDGYPX+COd2mo3Ga0lMy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710520; c=relaxed/simple;
	bh=F59VcJpuVD2ZJpUXnJitBIxnWj6nZyd+6b4/PbddAgk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qcVhOJqOAicD07Oe/O6MZrNJrlh8AZ4VsLGpsdcjC/nnZfypyXVhk57fR56Ggba1j9KRRBdxFpLWhvZzinrV3nez54Kk89IcZ96iae7ZYjLNg/Sly7aFeZ/h2OsEaFvkc+60HlqBzQZRLX4fB2b/T+RTLrYGssGYWMeT5HytuY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gce4elga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gce4elga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A818AC433C7;
	Wed, 10 Apr 2024 00:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710520;
	bh=F59VcJpuVD2ZJpUXnJitBIxnWj6nZyd+6b4/PbddAgk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gce4elgatfXx+sIPwHxVntHxgMZh5c6xuf2v1svFksOZeGkzol+PTPz4Z89fc98wk
	 QMRi3B/8fSk76FPRYwh2GCEqm/4YU5RESo7n9j9Kv8PDW3ha3kvoTVOEijgeyismSk
	 h995NpwXUwv6DvleSGyheia5Tyf1PtruK/mN0EmgMF41pU2C0KN5eGO2Cd5MmBRixu
	 1nc2z/Im36xRXBmmUc4Z349heQno5x37wYtvN96ytNCoYyeuMHJwWNOYNDa937r0I2
	 jeIDyGpX+Ft8gtEfoNFB4o0D6bXWTQc7A6Lm8ErqGnnutU2dIbWy2EfSCj0dFPEO/3
	 +F7+o35c/EICA==
Date: Tue, 09 Apr 2024 17:55:20 -0700
Subject: [PATCH 07/32] xfs: allow xattr matching on name and value for
 local/sf attrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969674.3631889.16669894985199358307.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Add a new XFS_DA_OP_PARENT flag to signal that the caller wants to look
up a parent pointer extended attribute by name and value.  This only
works with shortform and local attributes.  Only parent pointers need
this functionality and parent pointers cannot be remote xattrs, so this
limitation is ok for now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   44 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 490608bbed7ad..7d74ade47d8f1 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -513,12 +513,33 @@ static inline unsigned int xfs_attr_match_mask(const struct xfs_da_args *args)
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
 
@@ -529,6 +550,9 @@ xfs_attr_match(
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
 
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_attr_parent_match(args, value, valuelen);
+
 	return true;
 }
 
@@ -538,6 +562,13 @@ xfs_attr_copy_value(
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
@@ -747,7 +778,9 @@ xfs_attr_sf_findname(
 	     sfe < xfs_attr_sf_endptr(sf);
 	     sfe = xfs_attr_sf_nextentry(sfe)) {
 		if (xfs_attr_match(args, sfe->flags, sfe->nameval,
-					sfe->namelen))
+					sfe->namelen,
+					&sfe->nameval[sfe->namelen],
+					sfe->valuelen))
 			return sfe;
 	}
 
@@ -2444,14 +2477,17 @@ xfs_attr3_leaf_lookup_int(
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
 			if (!xfs_attr_match(args, entry->flags,
 						name_loc->nameval,
-						name_loc->namelen))
+						name_loc->namelen,
+						&name_loc->nameval[name_loc->namelen],
+						be16_to_cpu(name_loc->valuelen)))
 				continue;
 			args->index = probe;
 			return -EEXIST;
 		} else {
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
 			if (!xfs_attr_match(args, entry->flags, name_rmt->name,
-						name_rmt->namelen))
+						name_rmt->namelen, NULL,
+						be32_to_cpu(name_rmt->valuelen)))
 				continue;
 			args->index = probe;
 			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);

