Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258B01361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299872; cv=none; b=RztQCnEVdK8AWCV+G0EmMi/IQ8s9HoGY5Gfb+/yVF6RoOlKV1nVkn4Odft/q/hsxV1+H5JGLujkk9caNsANwNC02BwLzXZ9Z9gVEfhBcaWlf7E/7+wZgHm0KvMHEBRIt6JCRlHe8tcZQVmcN4WOeOMv7nWkhTSJkuniiNEjKa3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299872; c=relaxed/simple;
	bh=kcN9N7hUoFackDZ7SfFUoTbWScuCFSHxDSRTCrwFWRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KQgncTQtB8w5ig8GzzFLX3AEuzwlvu2zWURQd2dFD+boh7PJ6iI5prqJr5ciSBP5r3Poasgjbv/1yFguQ+UMpJ3SBE69C5iToKx8yzsKjB/2Io6hCGcQxgWrrktH2z8nicoCeIxG/LzVt2hq3osQEbsSNcx6NoUM/fQN9ET3tLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjNDt6h9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjNDt6h9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4EFC32786;
	Tue, 30 Jul 2024 00:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299872;
	bh=kcN9N7hUoFackDZ7SfFUoTbWScuCFSHxDSRTCrwFWRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hjNDt6h96BlmEHuJa/+Bl/g/H+tWd42qy4m5aqctkoq0+ai5yTLoIAlMvr4Emqrpb
	 UO3S4p+d3f2tz1t0GufqjripzBDnRsCoOw72EIVCCgOG9cSH+HQth8m3CCH6ObEpIs
	 0LcuFTY357nazq910vBgS2mngFxMZ4LkyYD/gvQVbSd6vvy5GwkZeQ0Ai5vjuA/r+L
	 hlJhzsmUa4+/fmzxlNxevRcNWW2X26T8F6/UrehyZIozSC2MVA8KaZNxrLodfMQcWA
	 3kpGDbMamn6vAzyYZFsK0XuedCT67Z+bss+bZeoQXO/wSeDyKXiKpXW2NZe19c1x0g
	 pOKK93evvLkiw==
Date: Mon, 29 Jul 2024 17:37:51 -0700
Subject: [PATCH 054/115] xfs: create a separate hashname function for extended
 attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843202.1338752.2387705314321279846.stgit@frogsfrogsfrogs>
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

Source kernel commit: a64e0134754bf88021e937aa34f1fbb5b524e585

Create a separate function to compute name hashvalues for extended
attributes.  When we get to parent pointers we'll be altering the rules
so that metadump obfuscation doesn't turn heinous.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c      |   28 ++++++++++++++++++++++++++--
 libxfs/xfs_attr.h      |   14 ++++++++++++++
 libxfs/xfs_attr_leaf.c |    3 +--
 3 files changed, 41 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7f64d8a2e..91e7961c2 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -279,7 +279,7 @@ xfs_attr_get(
 		args->owner = args->dp->i_ino;
 	args->geo = args->dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	xfs_attr_sethash(args);
 
 	/* Entirely possible to look up a name which doesn't exist */
 	args->op_flags = XFS_DA_OP_OKNOENT;
@@ -414,6 +414,30 @@ xfs_attr_sf_addname(
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
@@ -924,7 +948,7 @@ xfs_attr_set(
 		args->owner = args->dp->i_ino;
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	xfs_attr_sethash(args);
 
 	/*
 	 * We have no control over the attribute names that userspace passes us
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index cd106b0a4..c63b1d610 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index c6322fbd2..212347bc3 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -945,14 +945,13 @@ xfs_attr_shortform_to_leaf(
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

