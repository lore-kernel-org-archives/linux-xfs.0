Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B6741760
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816678; cv=none; b=uRq+jbph3ZBlbHLHsCWe9LqEWgaaRqqbIUAkdurDwbVbWgMT2VeGyMQAy1jWb2AkeOUBHQGUbrInRDSLQmtx/XPISVniuuozQhe0uJdljYsx/634qQTm0xAGDjHrhJmMqAii4B9jsTD24J+cwClsKaTefZEThkbmg8N41fQaUJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816678; c=relaxed/simple;
	bh=TTjiiLn2aWuhlJGFfpUvWSBy0NX3jHGwe3LtmgTDNs8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bGaigbWTpQpGQd6ZDAwszCGEA24sfGtqx2c4zrzlWXS1FwsfHpfwW98rP8QJSo3apgCz1dc5GoKBzQxcoNBCiGid4WMI0v6tm7Yk3XzdKsYfphOUgNKVbr2LDXR9r15I6IVdiXiU2TtQSl9WazqzvCkG2H6XSdiN3pHHv0idV9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9JSDa87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9JSDa87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C99C433F1;
	Thu,  1 Feb 2024 19:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816677;
	bh=TTjiiLn2aWuhlJGFfpUvWSBy0NX3jHGwe3LtmgTDNs8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T9JSDa87ndDUli+4QVk4r2Y//78XQmQJSNW5dq/IsJ55WmZl2CyWaOx/hK6iBnpSc
	 UwaF4nVAsg6bezRa8aEmabrfFfxWZliP0x2ofWbQgqaNn9mmSByjhp9KQHfBJMp8eJ
	 lRexgRlv0jUc7K/O0bqgxpOhR/BfiRGtBBgJYfYQi/yUdRmTh3/ivukrtzIv6SwJ8B
	 x8EjekSVq9hz54h1Or+RYM2/gUid1UqBdX0KWYnUdZ3nCmbNKGqlUvu+6zkPyM9qUi
	 KZo/rpMbWQChXDZwPzonLoKjeTe3c1ccGCi8zHWK5jh9o3GvQeq85ifvmupjDhv2yF
	 JrPeG5isET2+w==
Date: Thu, 01 Feb 2024 11:44:37 -0800
Subject: [PATCH 19/23] xfs: factor out a btree block owner check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334249.1604831.389334053004368592.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Hoist the btree block owner check into a separate helper so that we
don't have an ugly multiline if statement.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 95d9bd436e342..447573e4215ec 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1777,6 +1777,33 @@ xfs_btree_decrement(
 	return error;
 }
 
+/*
+ * Check the btree block owner now that we have the context to know who the
+ * real owner is.
+ */
+static inline xfs_failaddr_t
+xfs_btree_check_block_owner(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block)
+{
+	__u64			owner;
+
+	if (!xfs_has_crc(cur->bc_mp) ||
+	    (cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER))
+		return NULL;
+
+	owner = xfs_btree_owner(cur);
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+		if (be64_to_cpu(block->bb_u.l.bb_owner) != owner)
+			return __this_address;
+	} else {
+		if (be32_to_cpu(block->bb_u.s.bb_owner) != owner)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur		*cur,	/* btree cursor */
@@ -1815,11 +1842,7 @@ xfs_btree_lookup_get_block(
 		return error;
 
 	/* Check the inode owner since the verifiers don't. */
-	if (xfs_has_crc(cur->bc_mp) &&
-	    !(cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER) &&
-	    (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) &&
-	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
-			cur->bc_ino.ip->i_ino)
+	if (xfs_btree_check_block_owner(cur, *blkp) != NULL)
 		goto out_bad;
 
 	/* Did we get the level we were looking for? */

