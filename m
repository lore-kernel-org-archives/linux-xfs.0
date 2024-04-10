Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71308BF0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710474; cv=none; b=mxO8TYE0szY+Umzciidnhtzm3W+kxJlGi36QiHj67BJSFK669D5YVGapilEoeTnzcbZ+AkCa/7ceNbipXKsoDqjcFc69GPhcg9BCgZrQqFiPrUyxvw8UqirB+CHZ0k2NrrIkAbBArL7V8RZNIvKklsTHDfadSKKN7dCOduYDEnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710474; c=relaxed/simple;
	bh=NcGt2vDXoWvdIvQulI3vvCgdtOp2uh3QZuQZ4mSa2Qc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y/BNlbkiiC+Sj6xhDK9IwBw20aOtGatTSHpSO6Im++/AYoJ5B0HSCQlkkI2ROvLt31pTkK3qkgGrQeG2l0EaBG9vDg/tIiwQrZ3isQkxhrQcSsKooOFJ8bbDNfPy7vL6u802m6z/+z2Xi8WeLIa/Fmd1aKjNCosEwAc9bVqTR4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjM1KZbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjM1KZbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10F6C433F1;
	Wed, 10 Apr 2024 00:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710473;
	bh=NcGt2vDXoWvdIvQulI3vvCgdtOp2uh3QZuQZ4mSa2Qc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WjM1KZbP/fah/LJRst8TG+s2GkG/kYKmcPEl4tZqbeaTJnH61WaHwyfDPT+Tt7fFX
	 iEdodYhw19uuEDlLvGdsJSSJOwOCJWkY6vt5s80E2rsejnjTnpAZrXUh8++zfHRlKy
	 /dUSgpPPueL/R1iYv+D0fV0CIjzX6ZzObHZlRfpluJEjP7ciqGkDFEXfNx5R187c3M
	 HthDxi5kocwqMdM7U56JM32dX1/SkdiihEd6jOYtJeUFz2bEs0U+yvncylureWrffF
	 I5ZY7JJR1QhKdigoQLj69YGWgtgRC5zNY5nJEuw5Sq2gMiIM94NDf+NkXGTULvm9QR
	 UECrO1zcrdS/A==
Date: Tue, 09 Apr 2024 17:54:33 -0700
Subject: [PATCH 04/32] xfs: create a separate hashname function for extended
 attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969624.3631889.1427903658559985496.stgit@frogsfrogsfrogs>
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

Create a separate function to compute name hashvalues for extended
attributes.  When we get to parent pointers we'll be altering the rules
so that metadump obfuscation doesn't turn heinous.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      |   28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr.h      |   14 ++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c |    3 +--
 fs/xfs/scrub/attr.c           |   11 ++++++++---
 fs/xfs/xfs_attr_item.c        |    2 +-
 fs/xfs/xfs_attr_list.c        |    5 ++++-
 6 files changed, 54 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 03df79f63f674..30988d60162c7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -282,7 +282,7 @@ xfs_attr_get(
 		args->owner = args->dp->i_ino;
 	args->geo = args->dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	xfs_attr_sethash(args);
 
 	/* Entirely possible to look up a name which doesn't exist */
 	args->op_flags = XFS_DA_OP_OKNOENT;
@@ -417,6 +417,30 @@ xfs_attr_sf_addname(
 	return error;
 }
 
+/* Compute the hash value for a user/root/secure extended attribute */
+xfs_dahash_t
+xfs_attr_hashname(
+	const uint8_t		*name,
+	int			namelen)
+{
+	return xfs_da_hashname(name, namelen);
+}
+
+/* Compute the hash value for any extended attribute from any namespace. */
+xfs_dahash_t
+xfs_attr_hashval(
+	struct xfs_mount	*mp,
+	unsigned int		attr_flags,
+	const uint8_t		*name,
+	int			namelen,
+	const void		*value,
+	int			valuelen)
+{
+	ASSERT(xfs_attr_check_namespace(attr_flags));
+
+	return xfs_attr_hashname(name, namelen);
+}
+
 /*
  * Handle the state change on completion of a multi-state attr operation.
  *
@@ -932,7 +956,7 @@ xfs_attr_set(
 		args->owner = args->dp->i_ino;
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	xfs_attr_sethash(args);
 
 	/*
 	 * We have no control over the attribute names that userspace passes us
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3813f7ae626a2..df91c94d5bf5c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -620,6 +620,20 @@ xfs_attr_init_replace_state(struct xfs_da_args *args)
 	return xfs_attr_init_add_state(args);
 }
 
+xfs_dahash_t xfs_attr_hashname(const uint8_t *name, int namelen);
+
+xfs_dahash_t xfs_attr_hashval(struct xfs_mount *mp, unsigned int attr_flags,
+		const uint8_t *name, int namelen, const void *value,
+		int valuelen);
+
+/* Set the hash value for any extended attribute from any namespace. */
+static inline void xfs_attr_sethash(struct xfs_da_args *args)
+{
+	args->hashval = xfs_attr_hashval(args->dp->i_mount, args->attr_filter,
+					 args->name, args->namelen,
+					 args->value, args->valuelen);
+}
+
 extern struct kmem_cache *xfs_attr_intent_cache;
 int __init xfs_attr_intent_init_cache(void);
 void xfs_attr_intent_destroy_cache(void);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 9cb3a5d1c07d1..490608bbed7ad 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -947,14 +947,13 @@ xfs_attr_shortform_to_leaf(
 		nargs.namelen = sfe->namelen;
 		nargs.value = &sfe->nameval[nargs.namelen];
 		nargs.valuelen = sfe->valuelen;
-		nargs.hashval = xfs_da_hashname(sfe->nameval,
-						sfe->namelen);
 		nargs.attr_filter = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
 		if (!xfs_attr_check_namespace(sfe->flags)) {
 			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
+		xfs_attr_sethash(&nargs);
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index fdff9be408186..d5c2e73be8623 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -179,7 +179,6 @@ xchk_xattr_actor(
 		.dp			= ip,
 		.name			= name,
 		.namelen		= namelen,
-		.hashval		= xfs_da_hashname(name, namelen),
 		.trans			= sc->tp,
 		.valuelen		= valuelen,
 		.owner			= ip->i_ino,
@@ -230,6 +229,7 @@ xchk_xattr_actor(
 
 	args.value = ab->value;
 
+	xfs_attr_sethash(&args);
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */
 	if (error == -ENODATA)
@@ -525,7 +525,10 @@ xchk_xattr_rec(
 			xchk_da_set_corrupt(ds, level);
 			goto out;
 		}
-		calc_hash = xfs_da_hashname(lentry->nameval, lentry->namelen);
+		calc_hash = xfs_attr_hashval(mp, ent->flags, lentry->nameval,
+					     lentry->namelen,
+					     lentry->nameval + lentry->namelen,
+					     be16_to_cpu(lentry->valuelen));
 	} else {
 		rentry = (struct xfs_attr_leaf_name_remote *)
 				(((char *)bp->b_addr) + nameidx);
@@ -533,7 +536,9 @@ xchk_xattr_rec(
 			xchk_da_set_corrupt(ds, level);
 			goto out;
 		}
-		calc_hash = xfs_da_hashname(rentry->name, rentry->namelen);
+		calc_hash = xfs_attr_hashval(mp, ent->flags, rentry->name,
+					     rentry->namelen, NULL,
+					     be32_to_cpu(rentry->valuelen));
 	}
 	if (calc_hash != hash)
 		xchk_da_set_corrupt(ds, level);
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 04aa2c68d5e56..8f91016fc3cf8 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -578,13 +578,13 @@ xfs_attri_recover_work(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->value = nv->value.i_addr;
 	args->valuelen = nv->value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
 	args->owner = args->dp->i_ino;
+	xfs_attr_sethash(args);
 
 	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 903ed46c68872..9bc4b5322539a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -135,12 +135,15 @@ xfs_attr_shortform_list(
 		}
 
 		sbp->entno = i;
-		sbp->hash = xfs_da_hashname(sfe->nameval, sfe->namelen);
 		sbp->name = sfe->nameval;
 		sbp->namelen = sfe->namelen;
 		/* These are bytes, and both on-disk, don't endian-flip */
 		sbp->valuelen = sfe->valuelen;
 		sbp->flags = sfe->flags;
+		sbp->hash = xfs_attr_hashval(dp->i_mount, sfe->flags,
+					     sfe->nameval, sfe->namelen,
+					     sfe->nameval + sfe->namelen,
+					     sfe->valuelen);
 		sfe = xfs_attr_sf_nextentry(sfe);
 		sbp++;
 		nsbuf++;

