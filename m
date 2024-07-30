Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E337E6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299809; cv=none; b=DEO7NQrsL4riJ0gsBeQ0x3qBQwJWbVnhCee2qOSFxZzGDw12GMsXCx7NmsfbQsP/X5py4iPRUJqETfQzz/LtoPdhbeLQUrGjaFpbmZ7ve/1hnSW5k9WoMHurFXEb9sXxxRldNHtB4Uh1LYaYB969PVizXb0y9vWFC0DW1QDxFe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299809; c=relaxed/simple;
	bh=kznIQn03GW4iUBzT1SRW8t8Nh3TDd5dtxqsyUsM6rMk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QACRgv3DbDBpr1c3OzmQDt/U1wQlhi2vZ42/6wlZLlRO04OQw3O76xX71ecTmVHQFMw65kSgou2Fn9PYlsnC2k7Q1BWVrZCaYJt9VogU0VH+2SMZ4mFIQMIqS5DiWmyOr4JmpK/mEl7j9bHG0e+w8QRcl2+tarNq1lvjNWXJCTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MAiXKqKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAiXKqKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3E7C32786;
	Tue, 30 Jul 2024 00:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299809;
	bh=kznIQn03GW4iUBzT1SRW8t8Nh3TDd5dtxqsyUsM6rMk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MAiXKqKuBUuaxLYrXG+KEmh8bm3e3lgdg379VBUEzsDEX+68hRnStML9YooYuDl9s
	 pOAiGTDZFonGTX/tsssDgQvsHCbNn/qSvJraZrl48q+ZFJWf+rR+mBpLRi8yNs2X3u
	 WGomIeykZ7a6a25FeAC6eiAf5wrU0kf5viRqmkR9cK1YwrvVdKmUVTFdF+pq+us0Gw
	 lvZUA7d7bPlCl0NvR+UMSKP04S1SwEE+kitoXt2JvAcMC+Y76PR/WiqLOg39oL6dk0
	 TGIIOUEjrLPALAL7zJd5471PhNz+oN97PPLpr6dbMpg3JXPTgKzRPQ8yomsuRAM9AE
	 jahKRxWaP6u7A==
Date: Mon, 29 Jul 2024 17:36:48 -0700
Subject: [PATCH 050/115] xfs: enforce one namespace per attribute
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843146.1338752.1900296936921253423.stgit@frogsfrogsfrogs>
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

Source kernel commit: ea0b3e814741fb64e7785b564ea619578058e0b0

Create a standardized helper function to enforce one namespace bit per
extended attribute, and refactor all the open-coded hweight logic.  This
function is not a static inline to avoid porting hassles in userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c      |   11 +++++++++++
 libxfs/xfs_attr.h      |    4 +++-
 libxfs/xfs_attr_leaf.c |    7 ++++++-
 repair/attr_repair.c   |    7 ++++---
 4 files changed, 24 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 26674116f..e0a3bc702 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1530,12 +1530,23 @@ xfs_attr_node_get(
 	return error;
 }
 
+/* Enforce that there is at most one namespace bit per attr. */
+inline bool xfs_attr_check_namespace(unsigned int attr_flags)
+{
+	return hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) < 2;
+}
+
 /* Returns true if the attribute entry name is valid. */
 bool
 xfs_attr_namecheck(
+	unsigned int	attr_flags,
 	const void	*name,
 	size_t		length)
 {
+	/* Only one namespace bit allowed. */
+	if (!xfs_attr_check_namespace(attr_flags))
+		return false;
+
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 79b457adb..cd106b0a4 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -560,7 +560,9 @@ enum xfs_attr_update {
 int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_check_namespace(unsigned int attr_flags);
+bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
+		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 47f2836fb..346f0127d 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -947,6 +947,11 @@ xfs_attr_shortform_to_leaf(
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
 		nargs.attr_filter = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
+		if (!xfs_attr_check_namespace(sfe->flags)) {
+			xfs_da_mark_sick(args);
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
@@ -1060,7 +1065,7 @@ xfs_attr_shortform_verify(
 		 * one namespace flag per xattr, so we can just count the
 		 * bits (i.e. hweight) here.
 		 */
-		if (hweight8(sfep->flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		if (!xfs_attr_check_namespace(sfep->flags))
 			return __this_address;
 
 		sfep = next_sfep;
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 206a97d66..0f2f7a284 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -292,7 +292,8 @@ process_shortform_attr(
 		}
 
 		/* namecheck checks for null chars in attr names. */
-		if (!libxfs_attr_namecheck(currententry->nameval,
+		if (!libxfs_attr_namecheck(currententry->flags,
+					   currententry->nameval,
 					   currententry->namelen)) {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
@@ -473,7 +474,7 @@ process_leaf_attr_local(
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
 	if (local->namelen == 0 ||
-	    !libxfs_attr_namecheck(local->nameval,
+	    !libxfs_attr_namecheck(entry->flags, local->nameval,
 				   local->namelen)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
@@ -529,7 +530,7 @@ process_leaf_attr_remote(
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
 	if (remotep->namelen == 0 ||
-	    !libxfs_attr_namecheck(remotep->name,
+	    !libxfs_attr_namecheck(entry->flags, remotep->name,
 				   remotep->namelen) ||
 	    be32_to_cpu(entry->hashval) !=
 			libxfs_da_hashname((unsigned char *)&remotep->name[0],

