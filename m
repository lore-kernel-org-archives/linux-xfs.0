Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D17621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710849; cv=none; b=lH7H8cKwlrlFuRN/XiCJKEZkooSaBubs3/3bYjrQd8pxqssNJHRLsq3poX5xjSfqOGhKT3wyvFCIFYq/6aKIN0/hvSv/1xCzVCgR4sYwyp9tGHTqRkxJ57NvBXIBXRrOIg3qwcGo0i+4ZIVhx7AjtmRWYAqofdHHEf6N4vmuAL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710849; c=relaxed/simple;
	bh=sRGy5TXm0DI8xYkUG5BchEFCO1aUNgmK43P3tXWw4UI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eUMd3lUhtUR9JPBO3qhdQj3rPXu1+orj08NJtiI519yyNzQJJtD6rARwOqAgX8nmpX7Is/Ddv0F9QDfpcQbRayhJn8Ty9Jf0hW/XzqdXzVMG8Mpn1vTNje1GmZmANoL2bpwv08Z2e+wzGqLnFEqoe5OrFxxnRQ4vS8RKCegd7mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6WzOLsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6WzOLsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55464C433F1;
	Wed, 10 Apr 2024 01:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710849;
	bh=sRGy5TXm0DI8xYkUG5BchEFCO1aUNgmK43P3tXWw4UI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I6WzOLsDZ32jZ3fcxB1u9MU4fyGr0O9f3PGHmZsvWSq05N5pSjscJF2Im/alaFsxU
	 JMveCczERNCssC7wGUD8C0szZYn70SMm/EL5XxOcyJmuVW1lCdBr0qMtbeNaIMwZiH
	 KdDf4dRRKq/tnvWAZPYB4EYijIwLaufPyYelXYCoFENcov5yI8i5UOfKhyup8FtQW+
	 q3Z6xxzg+0fUa7JU886l40j9NBc0BolbzRrvjw1fpYxLDv8sWd5MCKN2pX4ecIr7aL
	 8q38Ru+TjfCOOT1jS3IQXjIHZOFkUorITSgtHYI/a8sVval+U94LYEqqUvnm2RplEW
	 +EG4A8TiW0dmA==
Date: Tue, 09 Apr 2024 18:00:48 -0700
Subject: [PATCH 28/32] xfs: don't remove the attr fork when parent pointers
 are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970025.3631889.12207478353485734181.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 7d74ade47d8f1..6eacf3cb7ca0b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -887,7 +887,8 @@ xfs_attr_sf_removename(
 	 */
 	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -896,7 +897,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}

