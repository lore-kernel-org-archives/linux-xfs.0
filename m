Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A42BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6pgYpIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56824C433C7;
	Sun, 31 Dec 2023 20:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055616;
	bh=qHPzHP/VBKsiOvPfix4ETGU5CR9hDwk7DXT31XjJO3Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W6pgYpIcx6Yg/GDgx2tt3J1coamS+hvosoy77ERVRK9QYCz9ARVQ3ILrviDtI2CAv
	 MJWApkm9sNCCMun0Jbp4mGN/nAU7pCHlucvo94r7O435PoABYdFz7WC91uIo2gHZ1W
	 AuwFuVyXKuRjvIkTtsBsOPNdKEpuGI2s3+Xqym79yRN0cQrlZm86mqfHo8ikiRrInh
	 bGoMikZpfGk5/7s6do0Ij8qtc+JGxJmndOX1/BCCHNeALXMQbqjCe73exsVW/W7paK
	 VlXrQzG1Xy0k5WYN/p+oxtSs8zROpSl2Sgxw7GZ7DDW66h83nTUGuwYInliZ7tZplH
	 bbW/89+RL1Hxg==
Date: Sun, 31 Dec 2023 12:46:55 -0800
Subject: [PATCH 08/14] xfs: use helpers to extract xattr op from opflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840530.1756514.990886282012645041.stgit@frogsfrogsfrogs>
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

Create helper functions to extract the xattr op from the ondisk xattri
log item and the incore attr intent item.  These will get more use in
the patches that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h |    5 +++++
 fs/xfs/xfs_attr_item.c   |   16 ++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 273e8dff76c07..ca51b93873bb9 100644
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
index b6b558f4501ad..80499811a9f72 100644
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
 
 	if (!xfs_sb_version_haslogxattrs(&mp->m_sb) &&
 	    !xfs_attri_can_use_without_log_assistance(mp))
@@ -524,8 +529,7 @@ xfs_attri_recover_work(
 	args = (struct xfs_da_args *)(attr + 1);
 
 	attr->xattri_da_args = args;
-	attr->xattri_op_flags = attrp->alfi_op_flags &
-						XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	attr->xattri_op_flags = xfs_attr_log_item_op(attrp);
 
 	/*
 	 * We're reconstructing the deferred work state structure from the
@@ -546,7 +550,7 @@ xfs_attri_recover_work(
 			 XFS_DA_OP_LOGGED;
 	args->owner = args->dp->i_ino;
 
-	switch (attr->xattri_op_flags) {
+	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->value = nv->value.i_addr;
@@ -728,7 +732,7 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	/* Check the number of log iovecs makes sense for the op code. */
-	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:

