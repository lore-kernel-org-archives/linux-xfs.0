Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B02F621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710333; cv=none; b=KSwJV1DZy5SQMs6pp/g85J2tcHlfYK1IUCCm3Cb5CJdD5QC6+TJvRxQE6kp7TUw51imMTpeeuQBy5+7Jx2PN1JyhxXOwB3BmKWM1qvp1XXVcTmUcVhhnR91tisup4KJ7uFCtX84DU+0enxT8/K4Se01+/I0169Ol8eHG0n3IM8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710333; c=relaxed/simple;
	bh=h7GRCU2J7c+Cu2hyo+tO+3klScn0o+4kg5+KBghTEn8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RjIRR+24w3yUZfvUjg91uMSASHCd0lryPACA8eyimvC/XLTiCdeQ2uDTtBK1V3zwopmr8qRC+BPj9rRCXoY864ZZroCplPPE3ywVpGu3G3j9PjqMYNIUJ9mM9wzXNz5jyckRNgZIUNot8hVcn2ML0FOBthBc2OHnzJrgua6XK7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOEKLNM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOEKLNM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0039FC433F1;
	Wed, 10 Apr 2024 00:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710333;
	bh=h7GRCU2J7c+Cu2hyo+tO+3klScn0o+4kg5+KBghTEn8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uOEKLNM16GzA6dnE8JXSiLsk2OLdUikolf3OtRIZku6YgpAh0CvOEu7fqjwkF8h3r
	 zosHFpFjwHm3iLNXsckGAdYryoOh3+pzaBt7Ejbg8mihPS8g/1CQtAtVyJhL7ikQ1Y
	 5czMf82Zwnw4XX71KEHvFI39JCLghUA9uAQCvA9Dueif+y20jHcDr2+123OPWjNtZd
	 5pjpgTkIfzsvIY6QBnKMJHz9UUX8IUzz17I7apgLKsIhxD1zkY0FVOQShSKbTRs5T6
	 qhJIP/ssTISl2bjQnPciKPngLaN9DGCkvMWfFV/ct4z5cH2/vVj7kUZ6k/ZhdUoSc5
	 18Jgnh8tRqs/w==
Date: Tue, 09 Apr 2024 17:52:12 -0700
Subject: [PATCH 07/12] xfs: use helpers to extract xattr op from opflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968966.3631545.12587444590975333070.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_attr.h |    5 +++++
 fs/xfs/xfs_attr_item.c   |   16 ++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 670ab2a613fc6..04ae01ab9a5d8 100644
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

