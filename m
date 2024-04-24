Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E474339A1
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928261; cv=none; b=WHDRRMjJ18F8PvJD0oiz+TmEGMDd7pGkAHuHCMiHXhAVo0QbxDqjElKT9az2QBIOA9xX0qL2O14OxEJlgVSJlOOnL88UBw1wV6cdtLBe5xE9cTmDw5W03AUJu2o6ploKh/TDgbtEnvni0iUSL9XwLW6BGBbW3AyKLX9cOl4RyVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928261; c=relaxed/simple;
	bh=7DR4/lZrYd5SRuD1KQzBjImYkvUT2tlUeO/boeuzSf8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gbo1bTrTCDLXYsGNgqDSAXR4mtPcNGj5RwLpJ39E/O/Yqczed1m79QimGdcjuXZlXWrH0eBh+lzJnEerRE5AmjOU/iz44l07U6/T0KHTm/pTf/K1DxaMKaKcRz11M2knFielXoQOis6buNR2mTkT0LU+ckNdn9D1qwfhcAUtgLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slfiisZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slfiisZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BA7C116B1;
	Wed, 24 Apr 2024 03:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928261;
	bh=7DR4/lZrYd5SRuD1KQzBjImYkvUT2tlUeO/boeuzSf8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=slfiisZ8Q7fYEzr6gk1wpn5gsvJacFqG2S1fInWnrWlXVTzhoYgpZVvYtNM6Ti4rR
	 EoHLyF8qOEs+zTBpjMWIysowcWVHDreLv33GvHmFUBsNnbkmrIks12/XWFt5UlbGsi
	 dCOTw2ZUFnI6hJ7W9rRx/2bx4tMLGn7nDBaSKkGQRLIghoMxqI69b9GXSlEGgkWf4d
	 rhWqwCreFffdFjM++PKQrJKn1dPz+IZBhJyXKOas9bjhZVg6zV2tdkwScQQY4pweM6
	 zenzJvPAoZYhY/DPR+oUh/E+ROR0+ryfPMCJFtOjVJy9jBsOkRAwvI3R59n4e4sjB7
	 T/qYR0RhbQALw==
Date: Tue, 23 Apr 2024 20:11:00 -0700
Subject: [PATCH 08/14] xfs: use helpers to extract xattr op from opflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782708.1904599.6393068733927151899.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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
index c8005f52102a..79b457adb7bd 100644
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
index d3559e6b24b7..b4c2dcb4581b 100644
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

