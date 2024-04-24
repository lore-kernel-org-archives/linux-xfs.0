Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD4084D24
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928418; cv=none; b=eF3l69ZxWGKeJs4A5+JdBrr1Zm+P+79fQUt59luZIeeRQq/Yl3ngyRaHInBoGc5njn7XGW2TNmLm2YTxUOzMKFZp+/ReaWDHIukfkSNV/3/Z+wIxvpsqTzF8BClGugxffgytIc42QlEeYSH8BeZj/8J5tP72VHqkPNbr8ANASMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928418; c=relaxed/simple;
	bh=JZQuQG8b8X5nFuRP+jGx+8LwdD1gOmu7PdZ9eFkLHAY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BaN97mf7EtSXzridewLhNJuNJ98Kcg/nUdqp6ruI8xigjncUZbDZ5+y08E/h+Xx5SYyeUAgjcN3dmNx94iDwG/0qUK2fAX3bdHT+iH/4wUWQ+BUWoRT3S6l/VS9R3zlDVgqLws2jjxFY8ah+lKXl+Gvoj1Ivon3U0d2l58oMchs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ltzn0HKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ltzn0HKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04009C116B1;
	Wed, 24 Apr 2024 03:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928418;
	bh=JZQuQG8b8X5nFuRP+jGx+8LwdD1gOmu7PdZ9eFkLHAY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ltzn0HKBJMoCmxaTP/Sg6hPVEx7aXGbyQTfXEhAzW1n5oM8OanZ5Sy+9hZDcGfpNZ
	 d8Vpxu1PlK9c2KcjdCtsVqrSu+28brFJFGY5xE+u3sWr60DT2BtYPE3gQMvm9CnqfR
	 OZt4C9XMS/jaEnmHvpgpbEXJaqay9uOcl25vkuRWGzY6eDPttxjtUHlGshOyaFUuvW
	 YBZR5mV6PYGADWTVNbPqfg34vvEDYIK3V9+k3xg8N80d590o57fv49psPKOpKt6zes
	 SwVerwD1AsutognVCsjGMKZvJWy22hMoNUVvpWpOWJ32drSMyS3ZQnRQE6HmDU4eRo
	 2vtVlggMEqOwg==
Date: Tue, 23 Apr 2024 20:13:37 -0700
Subject: [PATCH 04/30] xfs: create a separate hashname function for extended
 attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783332.1905110.3042749097824341681.stgit@frogsfrogsfrogs>
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

Create a separate function to compute name hashvalues for extended
attributes.  When we get to parent pointers we'll be altering the rules
so that metadump obfuscation doesn't turn heinous.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c      |   28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr.h      |   14 ++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c |    3 +--
 fs/xfs/scrub/attr.c           |   11 ++++++++---
 fs/xfs/xfs_attr_item.c        |    2 +-
 fs/xfs/xfs_attr_list.c        |    5 ++++-
 6 files changed, 54 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 50eab63ff3be..8262c263be9d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -280,7 +280,7 @@ xfs_attr_get(
 		args->owner = args->dp->i_ino;
 	args->geo = args->dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	xfs_attr_sethash(args);
 
 	/* Entirely possible to look up a name which doesn't exist */
 	args->op_flags = XFS_DA_OP_OKNOENT;
@@ -415,6 +415,30 @@ xfs_attr_sf_addname(
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
@@ -925,7 +949,7 @@ xfs_attr_set(
 		args->owner = args->dp->i_ino;
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	xfs_attr_sethash(args);
 
 	/*
 	 * We have no control over the attribute names that userspace passes us
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index cd106b0a424f..c63b1d610e53 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -628,6 +628,20 @@ xfs_attr_init_replace_state(struct xfs_da_args *args)
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
index c47fad39744e..e54a8372a30a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -948,14 +948,13 @@ xfs_attr_shortform_to_leaf(
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
index 7789bd2f0950..22d7ef4df169 100644
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
index a7d6c9af47e8..4a57bcff49eb 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -582,13 +582,13 @@ xfs_attri_recover_work(
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
index 903ed46c6887..9bc4b5322539 100644
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

