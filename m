Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9BC37C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710208; cv=none; b=Xzqedrn0ZgBIyViXHmACF1jFIuuGCawRvhVF5OWGedB4kyKkl+jPsR5UDf63/delVMCJ/jQiguZokrmHGJjBycMtEv46tAIzUDXkQUGLONpiHfYe1KbXzqWbAGwqClRd4hTeYMmk8X+obUmP0D8+AgTZtVZotHBlEAdaoHF8WlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710208; c=relaxed/simple;
	bh=FxZRH7ss6ab7SMjrotLXEyBTA7ftnp3iQ2g8VwGTCYE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XR+eKLkt9XRKaLN40HIQJfkN1GN1W8HS2d1QpeSS3S7DCmylvESgf4mpYuuCjAhFxU3cwMWNAJ06BIxnv8JHHWalbbNbG74ZMiC57kO39f1vpRDtafA433ose/qaodR4j3303lLHYOgwH6Fm2FamIg2C70rxLluHm1jcIQq1KFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rErkYwUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rErkYwUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE280C433F1;
	Wed, 10 Apr 2024 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710207;
	bh=FxZRH7ss6ab7SMjrotLXEyBTA7ftnp3iQ2g8VwGTCYE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rErkYwUgz0WB6eiREPMRQGhsVvDzVs7LvYGFjLYnQO4DMBMSyaxtI+l3icsI39hXo
	 HpA4txTDqqGQF1Dmddp+miglFLlU0UG6LhhGOvw/4h47RDyTOBAFax+7tjKmeSjILZ
	 7lT67lxSPB+riFtAt+/EMq/N1Dlt14uT4VNaFIOmskbaXGaNOkdcuRzG0xeVTxDHmv
	 /1R0DG4uuS2Wa3NZorKQEnC4CnzGrReQ1a6M1l3ogBgNJZ7jacK9RUkHt9h7q0Vyfc
	 n2k41/jvpVC0NmTZm6DNBjuwXh7QY7rXXm8UQDytxkBKeHYso52j5wUBMbwfTL2hLs
	 6AcKlKGV1LNWQ==
Date: Tue, 09 Apr 2024 17:50:07 -0700
Subject: [PATCH 3/4] xfs: rename xfs_da_args.attr_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968435.3631393.4664304714455437765.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
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

This field only ever contains XATTR_{CREATE,REPLACE}, so let's change
the name of the field to make the field and its values consistent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c     |    4 ++--
 fs/xfs/libxfs/xfs_da_btree.h |    2 +-
 fs/xfs/scrub/attr_repair.c   |    2 +-
 fs/xfs/xfs_ioctl.c           |    6 +++---
 fs/xfs/xfs_trace.h           |    6 +++---
 fs/xfs/xfs_xattr.c           |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 30e6084122d8b..5efbbb60f0069 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1008,7 +1008,7 @@ xfs_attr_set(
 		}
 
 		/* Pure create fails if the attr already exists */
-		if (args->attr_flags & XATTR_CREATE)
+		if (args->xattr_flags & XATTR_CREATE)
 			goto out_trans_cancel;
 		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
 		break;
@@ -1018,7 +1018,7 @@ xfs_attr_set(
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
-		if (args->attr_flags & XATTR_REPLACE)
+		if (args->xattr_flags & XATTR_REPLACE)
 			goto out_trans_cancel;
 		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
 		break;
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index b04a3290ffacc..e585d0fa9caea 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -60,7 +60,7 @@ typedef struct xfs_da_args {
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
-	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
+	unsigned int	xattr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 7b4318764d030..8192f9044c4a9 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -557,7 +557,7 @@ xrep_xattr_insert_rec(
 	struct xfs_da_args		args = {
 		.dp			= rx->sc->tempip,
 		.attr_filter		= key->flags,
-		.attr_flags		= XATTR_CREATE,
+		.xattr_flags		= XATTR_CREATE,
 		.namelen		= key->namelen,
 		.valuelen		= key->valuelen,
 		.owner			= rx->sc->ip->i_ino,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d2fc710d2d506..39bdd1034ffab 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -362,7 +362,7 @@ xfs_attr_filter(
 }
 
 static unsigned int
-xfs_attr_flags(
+xfs_xattr_flags(
 	u32			ioc_flags)
 {
 	if (ioc_flags & XFS_IOC_ATTR_CREATE)
@@ -476,7 +476,7 @@ xfs_attrmulti_attr_get(
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= xfs_attr_filter(flags),
-		.attr_flags	= xfs_attr_flags(flags),
+		.xattr_flags	= xfs_xattr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
 		.valuelen	= *len,
@@ -510,7 +510,7 @@ xfs_attrmulti_attr_set(
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= xfs_attr_filter(flags),
-		.attr_flags	= xfs_attr_flags(flags),
+		.xattr_flags	= xfs_xattr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
 	};
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ba7b01a390c00..e9cf9430ce259 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2000,7 +2000,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__field(int, valuelen)
 		__field(xfs_dahash_t, hashval)
 		__field(unsigned int, attr_filter)
-		__field(unsigned int, attr_flags)
+		__field(unsigned int, xattr_flags)
 		__field(uint32_t, op_flags)
 	),
 	TP_fast_assign(
@@ -2012,7 +2012,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__entry->valuelen = args->valuelen;
 		__entry->hashval = args->hashval;
 		__entry->attr_filter = args->attr_filter;
-		__entry->attr_flags = args->attr_flags;
+		__entry->xattr_flags = args->xattr_flags;
 		__entry->op_flags = args->op_flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
@@ -2026,7 +2026,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		  __entry->hashval,
 		  __print_flags(__entry->attr_filter, "|",
 				XFS_ATTR_FILTER_FLAGS),
-		   __print_flags(__entry->attr_flags, "|",
+		   __print_flags(__entry->xattr_flags, "|",
 				{ XATTR_CREATE,		"CREATE" },
 				{ XATTR_REPLACE,	"REPLACE" }),
 		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 4ebf7052eb673..9b29973424b45 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -124,7 +124,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 	struct xfs_da_args	args = {
 		.dp		= XFS_I(inode),
 		.attr_filter	= handler->flags,
-		.attr_flags	= flags,
+		.xattr_flags	= flags,
 		.name		= name,
 		.namelen	= strlen(name),
 		.value		= (void *)value,

