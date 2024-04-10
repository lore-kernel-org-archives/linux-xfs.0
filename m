Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD1E621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710552; cv=none; b=kAEQt36aI77fo9B6BESaKEaEaD7w3IJMn7MR/IxG2X4PvJWwTGyXIu/xruWaODfOiNSyTHipYVMN8XMZgrkev9UsAeNamvMaYdWmEfIel70xdQ78kgrhtpV8APBCeHOWfUltuRrAWc3LQn/bqB1mV2UN2w/mxfPX8kfVv2vgjqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710552; c=relaxed/simple;
	bh=p9uE3cAjrG/nn65nIeZJup3hr53VH+SqUDXyiscFqLg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MO4Zkeq8QrP5RznZ9HiRh9rWiWlIVH+GOQWHrfjpNcE+965OqCOJclAcc/xWKv5DT0SEW99QRIhsWveqTtiE3aCRvbHg4VWS4tYQRBwl57sqRGa/wVPlg5wy5o1c9lHQuUEiKZvWJ9Plo3AQi6+KVeK8cA2XpyVmDtufqPPIDe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ww9OP0dq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ww9OP0dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0777C433F1;
	Wed, 10 Apr 2024 00:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710552;
	bh=p9uE3cAjrG/nn65nIeZJup3hr53VH+SqUDXyiscFqLg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ww9OP0dq/iaEBkQ1edHG1KYGFXbbcBBqiz0Cxuues+FpvpvW25zIrN0k6N9RCJHcC
	 JR0PCig3gtrVux3X6hcO+N8IsZGeCajcXPovILcALygwjU8fzCrBXa7lWRQwor/9WF
	 PIY2Dd1LuB0BJrcjRXEQ8zcIn5K+hBmKk63JPJoFzjiB8EmbVqqf4Ka2v0Pknv07jf
	 r9IXAdgpynA1SOgZ+9PEvRTJXz7zClJTe3BdERDcgoepfxUIjSchIUqiP4/QjIL1Iq
	 wN7RCGoBCqV+PnNNPuPhZ9QvvBfPOFi0okXSQ16fIZ3jISRqNxmxWkRZhOaPcSA8EL
	 K79Aj+zIAgfjQ==
Date: Tue, 09 Apr 2024 17:55:51 -0700
Subject: [PATCH 09/32] xfs: log parent pointer xattr removal operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969707.3631889.13730441376936994688.stgit@frogsfrogsfrogs>
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

The parent pointer code needs to do a deferred parent pointer remove
operation with the xattr log intent code.  Declare a new logged xattr
opcode and push it through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |   53 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h         |    2 ++
 3 files changed, 56 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 020aebd101432..52dcee4b3abe6 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1026,6 +1026,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_PPTR_REMOVE	5	/* Remove parent pointer */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c509bf841949f..5cce8a9863862 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -491,6 +491,14 @@ xfs_attri_validate(
 		return false;
 
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+		if (!xfs_has_parent(mp))
+			return false;
+		if (attrp->alfi_value_len == 0)
+			return false;
+		if (!(attrp->alfi_attr_filter & XFS_ATTR_PARENT))
+			return false;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
@@ -595,6 +603,7 @@ xfs_attri_recover_work(
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
@@ -753,6 +762,36 @@ xfs_attr_defer_add(
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 }
 
+void
+xfs_attr_defer_parent(
+	struct xfs_da_args	*args,
+	enum xfs_attr_defer_op	op)
+{
+	struct xfs_attr_intent	*new;
+
+	ASSERT(xfs_has_parent(args->dp->i_mount));
+	ASSERT(args->attr_filter & XFS_ATTR_PARENT);
+	ASSERT(args->op_flags & XFS_DA_OP_LOGGED);
+
+	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	new->xattri_da_args = args;
+
+	switch (op) {
+	case XFS_ATTR_DEFER_SET:
+	case XFS_ATTR_DEFER_REPLACE:
+		/* will be added in subsequent patches */
+		ASSERT(0);
+		break;
+	case XFS_ATTR_DEFER_REMOVE:
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_PPTR_REMOVE;
+		new->xattri_dela_state = xfs_attr_init_remove_state(args);
+		break;
+	}
+
+	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
+	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
+}
+
 const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.name		= "attr",
 	.max_items	= 1,
@@ -801,6 +840,16 @@ xlog_recover_attri_commit_pass2(
 	/* Check the number of log iovecs makes sense for the op code. */
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
+		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/* Log item, attr name, attr value */
@@ -876,12 +925,16 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/*
 		 * Regular xattr set/remove/replace operations require a name
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
+		 *
+		 * Name-value remove operations must have a name, do not
+		 * take a newname, and can take a value.
 		 */
 		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index c32b669b0e16a..f9efd674fd062 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -58,5 +58,7 @@ enum xfs_attr_defer_op {
 };
 
 void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
+void xfs_attr_defer_parent(struct xfs_da_args *args,
+		enum xfs_attr_defer_op op);
 
 #endif	/* __XFS_ATTR_ITEM_H__ */

