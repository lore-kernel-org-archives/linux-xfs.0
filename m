Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3CFBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIn+RTei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BB0C433C7;
	Sun, 31 Dec 2023 20:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055694;
	bh=YSzGMFxTSiyvf+obCV5+JTweXQYF9mB2fyqjpTYAFSc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FIn+RTeiSSCYZbQyiwf8IexDYFxiSN7JB8Y30+1PJaJ22YigagwLZHF+fXewOOaND
	 lxahmlaBwAEhDpA4RrpTNViOt0NEw6ZmL9Ya1rH7PDVVf5Vwk/ftWzmPI6yz/gzshR
	 nM8/9t1e/9cQJ+DDDgSseeVzE21ft4059CqI+aBy6zdn9Of/E1NPLJIj3sfEV7s+3o
	 cothUtbs63jfTMR788uaRDeb62ZQoaik1qzrIgf3DwX6NMFskY2vR9lOPUU/AEIVbz
	 OsWEomhx/lgtUeY23ZG2iCJttHe7zj375GwuwmJnZ1cD1gCxJ/tB3WGe30wnmtgeIN
	 +hvfwB7S1w1pg==
Date: Sun, 31 Dec 2023 12:48:14 -0800
Subject: [PATCH 13/14] xfs: log NVLOOKUP xattr setting operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840608.1756514.7767173987831825386.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
References: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr set operation with the
NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    2 ++
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |    8 +++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 76cc9753cb116..a900e184f6566 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -898,6 +898,8 @@ xfs_attr_defer_add(
 
 	switch (op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
+		if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+			new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_NVSET;
 		new->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index bf648b75194ef..2ac520a18e909 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1044,6 +1044,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVSET	5	/* Set attr with w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index bd4bb931da2ae..1ae2ecfe780c2 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -493,6 +493,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 		break;
 	default:
 		return false;
@@ -554,6 +555,9 @@ xfs_attri_recover_work(
 	args->owner = args->dp->i_ino;
 
 	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
+		args->op_flags |= XFS_DA_OP_NVLOOKUP;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->total = xfs_attr_calc_size(args, &local);
@@ -738,6 +742,7 @@ xlog_recover_attri_commit_pass2(
 	/* Check the number of log iovecs makes sense for the op code. */
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		/* Log item, attr name, optional attr value */
 		if (item->ri_total != 3 && item->ri_total != 2) {
@@ -822,6 +827,7 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_NVSET:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -830,7 +836,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 *
-		 * Name-value remove operations must have a name, do not
+		 * Name-value set/remove operations must have a name, do not
 		 * take a newname, and can take a value.
 		 */
 		if (attr_name == NULL || name_len == 0) {

