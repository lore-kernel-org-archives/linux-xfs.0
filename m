Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCED1366
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299700; cv=none; b=aRidJtrl0LRAcXVY4E3AtWgA9Xtm2RN6X7vLGdTZKGthlh554hWo68NQ0+v/MDOutm8SRihjzUsZ2eUWaDLXG1lfwr+NGQBf5eFhy2x6+Wh3S3LyeJ5SqX3Hn7lM7q/Vj9iTQT0VCrRTDs647Gl3+9fSxhL9ncnh0BJ/6bInciY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299700; c=relaxed/simple;
	bh=2LPiZOx4ROQuJdHKgjDCdDVCrUX5P8fIKLnGqQEZY8Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MrCnQis3bURAgbFS211PfED1rBkTbMUhCG8HsJ1iW0Ky/2Wb3mBjNLvtUrKtvHhBUy5S+rV6r2RCiIEfBc7oLEgqnrWriIH9KY9J6B76SUk3UY8wv45iGtPl+d3HGuOOVdXYZvS7xqkOyp2dXZQT1p/wrf9RzSLuCS+g27J1L0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRgp4BTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRgp4BTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D2CC32786;
	Tue, 30 Jul 2024 00:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299699;
	bh=2LPiZOx4ROQuJdHKgjDCdDVCrUX5P8fIKLnGqQEZY8Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hRgp4BTNSbFVnbix2yJc2tLy75AtFfzb46dUY+TrvPwCu2ByyQJ9GVcTMdsAJabxS
	 U2/XNJV1BFWwgjq5PslqvQT1KB1nrVGoCWwHFiF39MstBLCYQb8UAddFo8t2b5JZat
	 K9lMlXnSogpFFjhCrckAH4ROHXBlPKZP4e0YZQhxoxBP0x13L+HRIdO9NAmH10t+aV
	 Wv3pcO0xG6bCkFK0KP1Mob8vcEQMIZrga7u9Dfp0jzB4FA635uJiFFv7MZDdEOGvw5
	 Xjs08qDnqNEz6T3TAxWDCzm0ntL2OveowHkkKPo+arAGQQYIrJGyx+JZRqNE4x9x91
	 scEc6Oagt95mA==
Date: Mon, 29 Jul 2024 17:34:59 -0700
Subject: [PATCH 043/115] xfs: remove xfs_da_args.attr_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843049.1338752.16393745334288034377.stgit@frogsfrogsfrogs>
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

Source kernel commit: 54275d8496f3e4764302cebc0e9517d950ba6589

This field only ever contains XATTR_{CREATE,REPLACE}, and it only goes
as deep as xfs_attr_set.  Remove the field from the structure and
replace it with an enum specifying exactly what kind of change we want
to make to the xattr structure.  Upsert is the name that we'll give to
the flags==0 operation, because we're either updating an existing value
or inserting it, and the caller doesn't care.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c          |   11 +++++------
 libxfs/xfs_attr.c     |    7 ++++---
 libxfs/xfs_attr.h     |    9 ++++++++-
 libxfs/xfs_da_btree.h |    1 -
 4 files changed, 17 insertions(+), 11 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 0d8d70a84..736482fea 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -69,6 +69,7 @@ attr_set_f(
 {
 	struct xfs_da_args	args = { };
 	char			*sp;
+	enum xfs_attr_update	op = XFS_ATTRUPDATE_UPSERTR;
 	int			c;
 
 	if (cur_typ == NULL) {
@@ -98,12 +99,10 @@ attr_set_f(
 
 		/* modifiers */
 		case 'C':
-			args.attr_flags |= XATTR_CREATE;
-			args.attr_flags &= ~XATTR_REPLACE;
+			op = XFS_ATTRUPDATE_CREATE;
 			break;
 		case 'R':
-			args.attr_flags |= XATTR_REPLACE;
-			args.attr_flags &= ~XATTR_CREATE;
+			op = XFS_ATTRUPDATE_REPLACE;
 			break;
 
 		case 'n':
@@ -162,7 +161,7 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(&args)) {
+	if (libxfs_attr_set(&args, op)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			args.name, (unsigned long long)iocur_top->ino);
 		goto out;
@@ -248,7 +247,7 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(&args)) {
+	if (libxfs_attr_set(&args, XFS_ATTRUPDATE_UPSERTR)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			(unsigned char *)args.name,
 			(unsigned long long)iocur_top->ino);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 958c6d720..9a6787624 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -920,7 +920,8 @@ xfs_attr_defer_add(
  */
 int
 xfs_attr_set(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	enum xfs_attr_update	op)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1006,7 +1007,7 @@ xfs_attr_set(
 		}
 
 		/* Pure create fails if the attr already exists */
-		if (args->attr_flags & XATTR_CREATE)
+		if (op == XFS_ATTRUPDATE_CREATE)
 			goto out_trans_cancel;
 		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
 		break;
@@ -1016,7 +1017,7 @@ xfs_attr_set(
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
-		if (args->attr_flags & XATTR_REPLACE)
+		if (op == XFS_ATTRUPDATE_REPLACE)
 			goto out_trans_cancel;
 		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
 		break;
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 670ab2a61..228360f7c 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -544,7 +544,14 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
-int xfs_attr_set(struct xfs_da_args *args);
+
+enum xfs_attr_update {
+	XFS_ATTRUPDATE_UPSERTR,	/* set/remove value, replace any existing attr */
+	XFS_ATTRUPDATE_CREATE,	/* set value, fail if attr already exists */
+	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
+};
+
+int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index b04a3290f..706b529a8 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -60,7 +60,6 @@ typedef struct xfs_da_args {
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
-	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */

