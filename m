Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69D0C8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmoDyaRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32248C433C8;
	Sun, 31 Dec 2023 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063766;
	bh=O2vcq3eYCAu7zclmaYJ/r3w3g5IXbw/ApWWFArZxY6w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PmoDyaRzA7Aa+ziuzv8yMiuvjR7xsfn2ZLUZWefgp1SWTTU7YlrHp5xRtIEhf6cQS
	 pD9sYPvSrznkhKWkjuESgDTwLZnOGQkziNBbEdg6eofZMs78L/mlg/Xd8GeUp/OX8U
	 ovbWt0H/Czl0yB7d5LiRzX0xy6i6lIFSIG//x5gyH9yDWuMm//FAFZAIenA3efCaMi
	 u110/dc+pS7rO28Sc2pwee9j/BU4nYg1cYioXcMxhcg2PZxuCZbwopcX9KN7Y8hYkF
	 65cx6UIyzUfL4TosEqiHxkXuYyxBzD23SFI15OrR+iDhBfBL5fJ0KvySpSKtmGP8Qy
	 +Ysg9/xNy5+oQ==
Date: Sun, 31 Dec 2023 15:02:45 -0800
Subject: [PATCH 02/11] xfs: make xfs_attr_set require XFS_DA_OP_REMOVE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005624.1804370.17201026045399486819.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
References: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
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
 db/attrset.c      |    4 +++-
 libxfs/xfs_attr.c |   10 +++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 2b6cdb5f5c3..123bdff1b62 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -185,7 +185,9 @@ attr_remove_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_da_args	args = { };
+	struct xfs_da_args	args = {
+		.op_flags	= XFS_DA_OP_REMOVE,
+	};
 	int			c;
 
 	if (cur_typ == NULL) {
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8958434247f..ca6cfb1ee8a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -924,6 +924,7 @@ xfs_attr_set(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			is_remove = args->op_flags & XFS_DA_OP_REMOVE;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
@@ -948,7 +949,7 @@ xfs_attr_set(
 	args->op_flags = XFS_DA_OP_OKNOENT |
 					(args->op_flags & XFS_DA_OP_LOGGED);
 
-	if (args->value) {
+	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);
 		args->total = xfs_attr_calc_size(args, &local);
 
@@ -982,7 +983,7 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	if (args->value || xfs_inode_hasattr(dp)) {
+	if (!is_remove || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error == -EFBIG)
@@ -995,8 +996,7 @@ xfs_attr_set(
 	error = xfs_attr_lookup(args);
 	switch (error) {
 	case -EEXIST:
-		if (!args->value) {
-			/* if no value, we are performing a remove operation */
+		if (is_remove) {
 			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
 			break;
 		}
@@ -1008,7 +1008,7 @@ xfs_attr_set(
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
-		if (!args->value)
+		if (is_remove)
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */

