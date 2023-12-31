Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A93BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qhjc9tGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62CCC433C7;
	Sun, 31 Dec 2023 20:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055553;
	bh=5n/+CBJR/BY0ICDh02dlIpF/SxkVICMXgzMFknDEu8Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qhjc9tGIoZBO8Bd5Fk4NGi1yOdyXPUQyDbiWN/EbVPGwcUjDpSOow3GkE63PcgKD/
	 gm8fHTiBcgKpqf4PVd8HoP2XNKyYBxgNS4RrSThxQ2HFppERMIYz8v+o3zPRvzOGcF
	 ndf6SNSrAASNdIzt35CDBCmU/5WLD87VIOvTEpXFPw0zcM1JO7DMPS1DYBUDTLEE2/
	 75zZXl0xxef8/u/kOS37jBJgC1dWwtiTCFwS1WNISbF2aU0kHNlIP/rkQ6J093Rtww
	 X5yT+bg7fuugaaZA6kbEBWZSNn5ngWbua0l86hETeVIUzKblmxH4/rcEeywkaveCfV
	 boUjOdwrB/TrA==
Date: Sun, 31 Dec 2023 12:45:53 -0800
Subject: [PATCH 04/14] xfs: make xfs_attr_set require XFS_DA_OP_REMOVE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840467.1756514.8379980610795114039.stgit@frogsfrogsfrogs>
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

Quite a few patches from now, we're going to change the parent pointer
xattr format to encode as much of the dirent name in the xattr name as
fits, and spill the rest of it to the xattr value.  To make this work
correctly, we'll be adding the ability to look up xattrs based on name
/and/ value.

Internally, the xattr data structure supports attributes with a zero
length value, which is how we're going to store parent pointers for
short dirent names.  The parent pointer repair code uses xfs_attr_set to
add missing and remove dangling parent pointers, so that interface must
be capable of setting an xattr with args->value == NULL.

The userspace API doesn't support this, so xfs_attr_set currently treats
a NULL args->value as a request to remove an attr.  However, that's a
quirk of the existing callers and the interface.  Make the callers of
xfs_attr_set to declare explicitly that they want to remove an xattr.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   10 +++++-----
 fs/xfs/xfs_xattr.c       |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2e5550ab1454f..2de3f6ad36601 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -926,6 +926,7 @@ xfs_attr_set(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			is_remove = args->op_flags & XFS_DA_OP_REMOVE;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
@@ -950,7 +951,7 @@ xfs_attr_set(
 	args->op_flags = XFS_DA_OP_OKNOENT |
 					(args->op_flags & XFS_DA_OP_LOGGED);
 
-	if (args->value) {
+	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);
 		args->total = xfs_attr_calc_size(args, &local);
 
@@ -984,7 +985,7 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	if (args->value || xfs_inode_hasattr(dp)) {
+	if (!is_remove || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error == -EFBIG)
@@ -997,8 +998,7 @@ xfs_attr_set(
 	error = xfs_attr_lookup(args);
 	switch (error) {
 	case -EEXIST:
-		if (!args->value) {
-			/* if no value, we are performing a remove operation */
+		if (is_remove) {
 			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
 			break;
 		}
@@ -1010,7 +1010,7 @@ xfs_attr_set(
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
-		if (!args->value)
+		if (is_remove)
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 5246539ad2174..2339e3fcfb384 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -122,6 +122,11 @@ xfs_attr_change(
 		use_logging = true;
 	}
 
+	if (args->value)
+		args->op_flags &= ~XFS_DA_OP_REMOVE;
+	else
+		args->op_flags |= XFS_DA_OP_REMOVE;
+
 	error = xfs_attr_set(args);
 
 	if (use_logging)

