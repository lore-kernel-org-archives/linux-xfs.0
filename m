Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011718F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928763; cv=none; b=EUdN1Fvs8XladSoFPmqqm/H053XicEqYZlBGgjzYLizTUE853aVbo4s21a1aVkdnDPdddFOmuLOXUOs6KMvVZw1rO4f6bY5G72tyiobvk8oUCRFXvIEzOwLyzcQaXY7WemlfVwcj3GdHyKpEIZjqHJsQfRB7n1q4PapcIBDSTRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928763; c=relaxed/simple;
	bh=kHHdFlsn4ZTSIO28q2RnGBYwmJMuTRlCgh7RAU4H93M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9Pozb/LxN6+XOwfV13IbcNdo3+DNN9S8fd4FMCYRBZv2S025xY6MmSv0f8TPZxK/qFRc9XnQrB/EsSWKRY6LuaRRcJAmarfqgx0du1RMpIXMP5Y8qrzXIczmnWigQ04R0wn+hG7ROk/9QrQwrznzLW6FFa5A3BvTR3MmHmDblY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSeE7sik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSeE7sik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6BBC116B1;
	Wed, 24 Apr 2024 03:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928762;
	bh=kHHdFlsn4ZTSIO28q2RnGBYwmJMuTRlCgh7RAU4H93M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RSeE7siknmUwSXRgg0obCrZu1Jeq07zu0vOPIYObAZmjMVWV6xlWCVJIdjWYWbpH9
	 L4Tmk/17KG1EeXGrIUTO2jmQEEz25GfgctdwsEOPBfXKn+W60Vh04TLSCU60ne5Lmy
	 rPDu55a2HPZWrFRR9KkUd98RJd2VjbKXa4KdazWzuBWE2PnsoC5CkASkT1iFnq7wWT
	 gB7JhxogrcZhLTAHjefVwE9Ls4kEnxn4XAg6BhrmD3mqvPToCKfq7HrcLVkks525md
	 /HcnNuWwiwpnxHIFzelFoDnkiUrUORFME+T8rI2oR3CL8aIyRoNwhCs/GiABlMbVXx
	 GA2zou1mMIKuw==
Date: Tue, 23 Apr 2024 20:19:22 -0700
Subject: [PATCH 26/30] xfs: don't remove the attr fork when parent pointers
 are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783709.1905110.755249231522207533.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

When an inode is removed, it may also cause the attribute fork to be
removed if it is the last attribute. This transaction gets flushed to
the log, but if the system goes down before we could inactivate the symlink,
the log recovery tries to inactivate this inode (since it is on the unlinked
list) but the verifier trips over the remote value and leaks it.

Hence we ended up with a file in this odd state on a "clean" mount.  The
"obvious" fix is to prohibit erasure of the attr fork to avoid tripping
over the verifiers when pptrs are enabled.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 1a374c6885d7..b9e98950eb3d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -891,7 +891,8 @@ xfs_attr_sf_removename(
 	 */
 	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -900,7 +901,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}

