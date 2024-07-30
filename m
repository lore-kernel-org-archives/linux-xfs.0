Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2587C4A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300154; cv=none; b=dj6IWZpfPwKmg3BEzNV+//OqYjZHzVdGsPb+2f7BY8CHupyWDq/Vdc6HfZLI6aufByazGeCQO8QVf5R2nI/I0j4ki1yka9tNPNtemzbijRgcizy33K9scmq8RRcF/KnTvbQd7MAZqsd5LqYvFw4Gf91oJMqYdks7HbvtEZWWkp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300154; c=relaxed/simple;
	bh=o7edboGEz5g2Uf1wb5v4DBKuljeQhgBD3sfedaTrGJA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FNSdXSOf3J0ThnG+q1IzqOD90rN3BQ27N6B3zyUXVgrts8khtyRbI9V1tNuuaE0gKso1TcJ9JT4oLWbFyRFW06rnfnaE+RsVVQF9cv2j7WtpYK2nwha/O52Bawj0z/fE8mPRluzz5VjDohObHcv6LNThMI8ezd63BprIk6qJuzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q54bncWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q54bncWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03A6C32786;
	Tue, 30 Jul 2024 00:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300154;
	bh=o7edboGEz5g2Uf1wb5v4DBKuljeQhgBD3sfedaTrGJA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q54bncWph/JNTBDJhFNfFgVXOPiYAzWQXaztf4wkg+yjaon1WxJbBCSCZTXjMSaw+
	 AAtCWeZqUEo3NdbdFNrmmXV7Sr40JaJaPQKPbI2CbQUz0qLrGwUF+9rn5si1LqyP4O
	 I9iJGmGKL/OS+K36SCWXHPWZC3fX9LiIZgaZ6eXNj7cXrc7WYqiU3d7MkPUobZEfZA
	 8vv0aDDz6OcfLIuOlwr86+TqItTi57bUHJ8Xdq7B+RJ7bB9+BGFhyvutIxNBoKK6Yq
	 m2z3haGSYb7QDgsSB2Kr14Tt9Llox8+xaFnkx9pK1flPHBfRpuO1498WJjNXwveiHC
	 Dujy6z22oRr1Q==
Date: Mon, 29 Jul 2024 17:42:33 -0700
Subject: [PATCH 072/115] xfs: don't remove the attr fork when parent pointers
 are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843454.1338752.7271500182319070310.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 7dafb449b7922c1eec6fee3ed85b679d51f0f431

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
 libxfs/xfs_attr_leaf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index faa357f15..ce20d81a4 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -888,7 +888,8 @@ xfs_attr_sf_removename(
 	 */
 	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -897,7 +898,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}

