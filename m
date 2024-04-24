Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F488F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928465; cv=none; b=l5nDXqTwLTmyyYPLTlX6JrYrfmKTU5J+VDxZrsOkHa3pUTqF576pItQrj5zHuNb1XGqQRrRXi1PYAFclqZ6lWA6cXrZAgg4OlPE/bp6bsrDebueAV6HYyGopeJOnb8OtRMmVEEedg0oggG8UoW43Uu2CS3ZCX/MKfubxJXnDWMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928465; c=relaxed/simple;
	bh=IO2VHsYkfM91QsefTNr21QyCOFopWa+i028yHS0PXmc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qB8KC9hkK2s1Zg2ZPEBF6poraFiTEHcsPmJvwyG4ukfABlPNsWHMKVsHc4Xl3uWJ75g1wG6JtwD1+Uy96YqGlIc7j0orAIaugGtJKN4JT2o+EqtwpxBR3szonLufaPFNFAmy7zi7Hl5STnwJ783UTfpNNWoBBDYaxsJETCxLOo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYBqrOXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYBqrOXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135A6C116B1;
	Wed, 24 Apr 2024 03:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928465;
	bh=IO2VHsYkfM91QsefTNr21QyCOFopWa+i028yHS0PXmc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CYBqrOXNoxHaEhYWCfecsUulnZhnY44/wxWphMHW6YKBlYPH0fMQSADscJMUaaONW
	 qdOOVJnzykUMspg03ZDVhX+qDzLmvvJcQI+jnyAHJs30Tf2b7JwtsgsfhbPxqaGxbu
	 YUOIoDRqMSCseNXk5n38Mt/yISMnqX56IJsgqNlQPz6s6Gw1LgPGvJ9MgJXDtmbVwx
	 ijNaFNyUpz8Y8v3KSFMnDxjx/cKH5bg+oUq2bY3oxkZGxqdzWxxyEWXQ0ZqaiTF8Kb
	 i6/Wm+3v2XhYkBfLVlHQgR4toJ8djynMgpcLPqrlT0lvssLZuLQiZClQ5LqtCri9TJ
	 HQgeqz4IHFtWg==
Date: Tue, 23 Apr 2024 20:14:24 -0700
Subject: [PATCH 07/30] xfs: allow xattr matching on name and value for parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783384.1905110.166027987253562347.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr_leaf.c |   52 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e54a8372a30a..1a374c6885d7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -514,12 +514,37 @@ static inline unsigned int xfs_attr_match_mask(const struct xfs_da_args *args)
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
+	/*
+	 * The only value we support is a parent rec.  However, we'll accept
+	 * any valuelen so that offline repair can delete ATTR_PARENT values
+	 * that are not parent pointers.
+	 */
+	if (valuelen != args->valuelen)
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
 
@@ -530,6 +555,9 @@ xfs_attr_match(
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
 
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_attr_parent_match(args, value, valuelen);
+
 	return true;
 }
 
@@ -539,6 +567,13 @@ xfs_attr_copy_value(
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
@@ -748,7 +783,8 @@ xfs_attr_sf_findname(
 	     sfe < xfs_attr_sf_endptr(sf);
 	     sfe = xfs_attr_sf_nextentry(sfe)) {
 		if (xfs_attr_match(args, sfe->flags, sfe->nameval,
-					sfe->namelen))
+				sfe->namelen, &sfe->nameval[sfe->namelen],
+				sfe->valuelen))
 			return sfe;
 	}
 
@@ -2444,18 +2480,22 @@ xfs_attr3_leaf_lookup_int(
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

