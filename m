Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D604F53BE
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299715; cv=none; b=pFXjyIxYht1UKqIXMaGB36ADUOOwx5VGHG6c4+UU65UyPUBgxgWUT5R0ZsYZfcM2IkPfBdLzeyo4ARggpy2IFWFBGuiYArtskQvIRc4SISHXBh+fz7A6YqHgpFP6xTV5uFaqgCrf9CUHJp/l/luyubtvy/LNuEQpYBlqqY/QHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299715; c=relaxed/simple;
	bh=2yvtfnTK5mdPnkTegL8/mStxPKxCZE3YQABcvMEQHT0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JpEdcl0O9dEQ3CBLhFx7YB5Q6rksTGCWSMBmW7n9yTPjhdVy/dPolFx99+V4s1hxLKdapCgT2nn77bqF04p8Odc/h7x4x2vknpubHJHiw4aG/TR4osIVgr7yX5nZb/ekxawZbphae7I3Dq4mDxph1f3n55nXEujGmaHMwmBsF24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfGnSX8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfGnSX8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B5EC4AF0B;
	Tue, 30 Jul 2024 00:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299715;
	bh=2yvtfnTK5mdPnkTegL8/mStxPKxCZE3YQABcvMEQHT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OfGnSX8MU3XDFgWe9ghTFb4tH6tSiCDWg93FI8zUJsgPlWdTb+HwFDajKlM9QqYH+
	 SVIp/28wBrGXp9e1VpqrQgn1IGHMrkKHyMGn8tfJuJFtBWr+8KpMnZMh2qJi9ulME0
	 Iv3i7ZBv/5ZWHspfkzpRlYZAo0Nw3uM5P77DOVn4IoozsXK6wkRB9auASOGGlZ26fW
	 vPgTau4XwOZ76bSrgAOEh/Hf7vzkFYhkwkxY29SbC9nfxasTE0KmxNaD+CVbKngpH2
	 P4XERNgIBHGE0KWWRmVB6DubmZRntOdZIlYl/haJ/O5FuFWzO73K9UWnEmT4EfbhPO
	 350xPtPDcpSVw==
Date: Mon, 29 Jul 2024 17:35:14 -0700
Subject: [PATCH 044/115] xfs: make attr removal an explicit operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843062.1338752.7951983944435816559.stgit@frogsfrogsfrogs>
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

Source kernel commit: c27411d4c640037d70e2fa5751616e175e52ca5e

Parent pointers match attrs on name+value, unlike everything else which
matches on only the name.  Therefore, we cannot keep using the heuristic
that !value means remove.  Make this an explicit operation code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c      |    4 ++--
 libxfs/xfs_attr.c |   19 ++++++++++---------
 libxfs/xfs_attr.h |    3 ++-
 3 files changed, 14 insertions(+), 12 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 736482fea..a59d5473e 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -69,7 +69,7 @@ attr_set_f(
 {
 	struct xfs_da_args	args = { };
 	char			*sp;
-	enum xfs_attr_update	op = XFS_ATTRUPDATE_UPSERTR;
+	enum xfs_attr_update	op = XFS_ATTRUPDATE_UPSERT;
 	int			c;
 
 	if (cur_typ == NULL) {
@@ -247,7 +247,7 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(&args, XFS_ATTRUPDATE_UPSERTR)) {
+	if (libxfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			(unsigned char *)args.name,
 			(unsigned long long)iocur_top->ino);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9a6787624..5249f9be0 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -914,10 +914,6 @@ xfs_attr_defer_add(
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 }
 
-/*
- * Note: If args->value is NULL the attribute will be removed, just like the
- * Linux ->setattr API.
- */
 int
 xfs_attr_set(
 	struct xfs_da_args	*args,
@@ -953,7 +949,10 @@ xfs_attr_set(
 	args->op_flags = XFS_DA_OP_OKNOENT |
 					(args->op_flags & XFS_DA_OP_LOGGED);
 
-	if (args->value) {
+	switch (op) {
+	case XFS_ATTRUPDATE_UPSERT:
+	case XFS_ATTRUPDATE_CREATE:
+	case XFS_ATTRUPDATE_REPLACE:
 		XFS_STATS_INC(mp, xs_attr_set);
 		args->total = xfs_attr_calc_size(args, &local);
 
@@ -973,9 +972,11 @@ xfs_attr_set(
 
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
-	} else {
+		break;
+	case XFS_ATTRUPDATE_REMOVE:
 		XFS_STATS_INC(mp, xs_attr_remove);
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+		break;
 	}
 
 	/*
@@ -987,7 +988,7 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	if (args->value || xfs_inode_hasattr(dp)) {
+	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error == -EFBIG)
@@ -1000,7 +1001,7 @@ xfs_attr_set(
 	error = xfs_attr_lookup(args);
 	switch (error) {
 	case -EEXIST:
-		if (!args->value) {
+		if (op == XFS_ATTRUPDATE_REMOVE) {
 			/* if no value, we are performing a remove operation */
 			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
 			break;
@@ -1013,7 +1014,7 @@ xfs_attr_set(
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
-		if (!args->value)
+		if (op == XFS_ATTRUPDATE_REMOVE)
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 228360f7c..c8005f521 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -546,7 +546,8 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 
 enum xfs_attr_update {
-	XFS_ATTRUPDATE_UPSERTR,	/* set/remove value, replace any existing attr */
+	XFS_ATTRUPDATE_REMOVE,	/* remove attr */
+	XFS_ATTRUPDATE_UPSERT,	/* set value, replace any existing attr */
 	XFS_ATTRUPDATE_CREATE,	/* set value, fail if attr already exists */
 	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
 };

