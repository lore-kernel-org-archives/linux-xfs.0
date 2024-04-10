Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A3621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710567; cv=none; b=PIrxi102Bd6Zj/Qt2AJMjw5yZ2GFF0B8UWxx21+1F+l+wgoc0niivHFFZDeiJURlecEaUp4uz7fh1N8nIHRlnJtPP7I9fxaDAQ8ytA6GFqt97T40LkYji2wIivTIlpiAwEtWlGk2rrrjmQCB53L8qioGSgrA0CGrAWbkHUFwcDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710567; c=relaxed/simple;
	bh=weXBb7r8Ai7mFkcTsOX1rsmLCTpFVMo9pPlnA30GiYQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bL/NbPbeD3hvPfA5aeSE/PgRO0RNuk3UlM64YJCurIov5RAX0mGvFY7xhhoNNeSltSuBKFojU9vyUj7svBqPXgFY+wcA+mpwayLUwDnaNKHFoLQnavX8703gFYdAYiGSxrw2O0E/wZ+8KMKk8UNILOTX6I8FLrELGh/lpnARCEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmF7tLM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmF7tLM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88898C433F1;
	Wed, 10 Apr 2024 00:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710567;
	bh=weXBb7r8Ai7mFkcTsOX1rsmLCTpFVMo9pPlnA30GiYQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GmF7tLM6IdU17DlH1vt68lwnbhd1BpU06/Lv/z13jhQ1kjpFKkN82aPya7qvBrqc1
	 KTR0wkPp2VF2sTsFWeupNRXlifZLHUza2FeilCKWQ6JapAsIgNj+JWa6shx/0gogPD
	 o/U8AHtzLt3Vby8kBQAGAB2gs8IaaeDgBkMcCUjhb/BLNfexIjAHm7HkhFCSNObreq
	 ES8/XZ/45v8sFFna19w8nraa8D1k3Ep+Ov9BC6Wy3FTJLqpU/dOJwRoKMXuicpjW37
	 ZUN/ifQQ9zcCPiwftAiMJGyAHJOYtaFt4Iafi4ejzzKvH/4+PfMy5xS/AMumhMpWN+
	 aanzMcYopwImA==
Date: Tue, 09 Apr 2024 17:56:07 -0700
Subject: [PATCH 10/32] xfs: log parent pointer xattr setting operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969723.3631889.12419473363106489444.stgit@frogsfrogsfrogs>
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

The parent pointer code needs to do a deferred parent pointer set
operation with the xattr log intent code.  Declare a new logged xattr
opcode and push it through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 52dcee4b3abe6..96732a212507e 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1026,6 +1026,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_PPTR_SET	4	/* Set parent pointer */
 #define XFS_ATTRI_OP_FLAGS_PPTR_REMOVE	5	/* Remove parent pointer */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5cce8a9863862..d89495990f03b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -491,6 +491,7 @@ xfs_attri_validate(
 		return false;
 
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
 	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
 		if (!xfs_has_parent(mp))
 			return false;
@@ -595,6 +596,7 @@ xfs_attri_recover_work(
 	xfs_attr_sethash(args);
 
 	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->total = xfs_attr_calc_size(args, &local);
@@ -778,6 +780,9 @@ xfs_attr_defer_parent(
 
 	switch (op) {
 	case XFS_ATTR_DEFER_SET:
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_PPTR_SET;
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
 	case XFS_ATTR_DEFER_REPLACE:
 		/* will be added in subsequent patches */
 		ASSERT(0);
@@ -841,6 +846,7 @@ xlog_recover_attri_commit_pass2(
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
 		/* Log item, attr name, attr value */
 		if (item->ri_total != 3) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -926,6 +932,7 @@ xlog_recover_attri_commit_pass2(
 		}
 		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/*
@@ -933,7 +940,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 *
-		 * Name-value remove operations must have a name, do not
+		 * Name-value set/remove operations must have a name, do not
 		 * take a newname, and can take a value.
 		 */
 		if (attr_name == NULL || name_len == 0) {

