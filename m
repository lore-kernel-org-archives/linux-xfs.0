Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911ED8BE8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299919; cv=none; b=qA29r6zRIu9zKkFR2vpQ1KqUj5V0cdk1A83N2aMeU9/2F6V75YAUjpE5etIsfFYLPdHbforOZ17MiqO6RsKeA0XYHwnyIrSjBsxIrQIM/Lrjh0QWZGptLNhdDVnlBwhEnLBTVEt5k8NfLC+mqH6zzV+N3Nt+/0/ZItbOjtOuxKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299919; c=relaxed/simple;
	bh=wTovikacywMZ6yZbvy4tUoJndCl8FQI5q9+btLPw1N8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyKUPuqt+GKAMrJeWsGa2PA5S3TO/zv3dHPjH/3HUluWeYuSQnysCyjQbJ57lWb1zIYf7Q8qmoH/2NWmuBaxOp5nVjzLBKlxw3lN1UuoU8MedRD7LsJ3GSYhC7gxZUuCQo8Gn7L8kICqQ8w9PCIP9nkY0I82hEePbS959n6Z7to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGDuSGtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGDuSGtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8ABC32786;
	Tue, 30 Jul 2024 00:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299919;
	bh=wTovikacywMZ6yZbvy4tUoJndCl8FQI5q9+btLPw1N8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gGDuSGtZPDG4zmFXqLePtRgM6oEHulHLvoNQzz/zDZ/H1zo7W6Cpy2isliNIrqwVk
	 VvY2q41hQ4mBWztCGORqtHLG5f3XfLgSP3dzyyFUPCRua36zKWBATJZ8RkWOtNyCUZ
	 wtc9xLM/hXAf6uTvIku5A3HO9jDDYke+Dq9utjsCz6CBQaUtWPE6hJYoD4LQroZgYH
	 nPCoCsAq/L32t5GXniiK8LTc6d81zrIitwjYa6lbEN8n5qoxhDH47ZMXMVI8pq24mo
	 JOl7tplaUIheyz2p4+2tAO9lx9+oHvIfRKRoeziGAlhqjVrlnHCo6RZO4uS+SKgmco
	 ce4wm3Xt/gbug==
Date: Mon, 29 Jul 2024 17:38:38 -0700
Subject: [PATCH 057/115] xfs: allow xattr matching on name and value for
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843245.1338752.14701764237875926851.stgit@frogsfrogsfrogs>
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

Source kernel commit: f041455eb5773eda3291903ad6d1f33d4798e9a2

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
 libxfs/xfs_attr_leaf.c |   52 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 212347bc3..faa357f15 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -511,12 +511,37 @@ static inline unsigned int xfs_attr_match_mask(const struct xfs_da_args *args)
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
 
@@ -527,6 +552,9 @@ xfs_attr_match(
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
 
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_attr_parent_match(args, value, valuelen);
+
 	return true;
 }
 
@@ -536,6 +564,13 @@ xfs_attr_copy_value(
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
@@ -745,7 +780,8 @@ xfs_attr_sf_findname(
 	     sfe < xfs_attr_sf_endptr(sf);
 	     sfe = xfs_attr_sf_nextentry(sfe)) {
 		if (xfs_attr_match(args, sfe->flags, sfe->nameval,
-					sfe->namelen))
+				sfe->namelen, &sfe->nameval[sfe->namelen],
+				sfe->valuelen))
 			return sfe;
 	}
 
@@ -2441,18 +2477,22 @@ xfs_attr3_leaf_lookup_int(
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

