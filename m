Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961903FD4
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230669; cv=none; b=EM0tZipCSOE+92jEDZ0xSdjPSGrfOaQiMOtCEfkaQyK9fBpfBACLGad9W2o+y/W1GkBFhGFmWNQAFV3zj4ZVCKDR3PvDKkR1uFe+O28mLffGXT7yhOPL0bWVg95ie5AM6rHrNzB3COSAfW7mcpeB0KDYURtzL5z+bQb3Z5ZS7wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230669; c=relaxed/simple;
	bh=HHbJ9i5Lj/wcWcc0cf5g6SJKqhXTVbbjuleRggtSUA8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/6cPBAyD3SXCmhKlKPRGfcXNGGnzE2GBJLGRcm6RjNUnVP1i1Uj0xZJHVe90QRqQjJRg5lr/OEXMpq8Yf1gz9Yeif5QCv1DOCxUyz2Zo6l2UNSv6pnvyaAajntXfeoXDFYU3nFG8wM6PbZxB14GkA1OiEaHB8XV3h/kZDHtE48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mft6Q9YY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mft6Q9YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218E5C113CC;
	Tue, 16 Apr 2024 01:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230669;
	bh=HHbJ9i5Lj/wcWcc0cf5g6SJKqhXTVbbjuleRggtSUA8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Mft6Q9YYc3nRk2VT8quLv1waqmcUMfUpA6RivX5LB2UYZPYs4I668DgbUY+FTJIlB
	 2tSqQ//tQFPl3lfZKva17D4YOM8Tfjelq6jkoRjjVlHHAd39u4ihFu6Ne/TGDntn8O
	 gMvJ6cj3mN7sg8KiKGgQWQKce0SLIs7N072l08VaWoNKmqlqavGnr6uY8LNqF/iYbR
	 RijFdI2yBCXPSHAJTip9nyUmvSkf5s6q4eJz0G/U1brUKbHmg7r3YO/vie6uFLctYl
	 5fBqYbhQhE6sdSEDlsgGKU4D3fSKbz6qQ9vx8X5TRR/uL44Wjdo5uOiM/Bss8sK/5l
	 ciKfQRvGobFZg==
Date: Mon, 15 Apr 2024 18:24:28 -0700
Subject: [PATCH 08/14] xfs: use helpers to extract xattr op from opflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027201.251201.1193429969611085856.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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

Create helper functions to extract the xattr op from the ondisk xattri
log item and the incore attr intent item.  These will get more use in
the patches that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h |    5 +++++
 fs/xfs/xfs_attr_item.c   |   16 ++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index c8005f52102ad..79b457adb7bda 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -529,6 +529,11 @@ struct xfs_attr_intent {
 	struct xfs_bmbt_irec		xattri_map;
 };
 
+static inline unsigned int
+xfs_attr_intent_op(const struct xfs_attr_intent *attr)
+{
+	return attr->xattri_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
 
 /*========================================================================
  * Function prototypes for the kernel.
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index d3559e6b24b7d..b4c2dcb4581bc 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -308,6 +308,12 @@ xfs_attrd_item_intent(
 	return &ATTRD_ITEM(lip)->attrd_attrip->attri_item;
 }
 
+static inline unsigned int
+xfs_attr_log_item_op(const struct xfs_attri_log_format *attrp)
+{
+	return attrp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
+
 /* Log an attr to the intent item. */
 STATIC void
 xfs_attr_log_item(
@@ -466,8 +472,7 @@ xfs_attri_validate(
 	struct xfs_mount		*mp,
 	struct xfs_attri_log_format	*attrp)
 {
-	unsigned int			op = attrp->alfi_op_flags &
-					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	unsigned int			op = xfs_attr_log_item_op(attrp);
 
 	if (!xfs_is_using_logged_xattrs(mp))
 		return false;
@@ -551,8 +556,7 @@ xfs_attri_recover_work(
 	args = (struct xfs_da_args *)(attr + 1);
 
 	attr->xattri_da_args = args;
-	attr->xattri_op_flags = attrp->alfi_op_flags &
-						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	attr->xattri_op_flags = xfs_attr_log_item_op(attrp);
 
 	/*
 	 * We're reconstructing the deferred work state structure from the
@@ -573,7 +577,7 @@ xfs_attri_recover_work(
 			 XFS_DA_OP_LOGGED;
 	args->owner = args->dp->i_ino;
 
-	switch (attr->xattri_op_flags) {
+	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->value = nv->value.i_addr;
@@ -757,7 +761,7 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	/* Check the number of log iovecs makes sense for the op code. */
-	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:

