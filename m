Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E343BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXyLP9qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFA4C433C8;
	Sun, 31 Dec 2023 20:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055679;
	bh=6QocOMFXEFIP9pzP7ylG2stYwR/uDuGZigJJWF+AIJI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sXyLP9qbA1Pmnl86zHrVU1D3F/S/C692/s15XF+XA7lKS9zTI2KLJgKLS6HZjf0I9
	 LvT+FwoYk4ju5Fnjs6kENbf0UxgtLDebIq2mM0i0h+a2w1S0dbd+soqd0XAjaJZE0A
	 EZ5PCGhxfvcO2LyGnHFG6zjpYAUHicstJHBhvV83Gw65hQy3afwpKoW/xCc2txhsH9
	 lWtDjSDWFhetPZE1TAipQkFmmb1ywTcAPbh/S3HonIpg0SA6TJ+CAJ2CAdLMG8cWUr
	 BAcdoxVrbZ4CXQ5CxE1tyD7+oaDPyyl5Y0gH/UgxqhukTXatC+1DitCDOZTszCeJIR
	 Dmi7V/xHzYawQ==
Date: Sun, 31 Dec 2023 12:47:58 -0800
Subject: [PATCH 12/14] xfs: log NVLOOKUP xattr removal operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840592.1756514.653929358408643106.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr remove operation with
the NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    2 ++
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_attr_item.c         |   18 ++++++++++++++++++
 3 files changed, 21 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1d4cd8a8ac9ab..76cc9753cb116 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -904,6 +904,8 @@ xfs_attr_defer_add(
 		new->xattri_dela_state = xfs_attr_init_replace_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+			new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_NVREMOVE;
 		new->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index d4531060b6b49..bf648b75194ef 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1043,6 +1043,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 19fc535b4a22b..bd4bb931da2ae 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -492,6 +492,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 		break;
 	default:
 		return false;
@@ -561,6 +562,9 @@ xfs_attri_recover_work(
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+		args->op_flags |= XFS_DA_OP_NVLOOKUP;
+		fallthrough;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
@@ -734,6 +738,16 @@ xlog_recover_attri_commit_pass2(
 	/* Check the number of log iovecs makes sense for the op code. */
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
+		/* Log item, attr name, optional attr value */
+		if (item->ri_total != 3 && item->ri_total != 2) {
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
@@ -808,12 +822,16 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
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

