Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D5858230
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798402; cv=none; b=i8Y0XLQ1xPg65M7BunsrtrKmbFn4gAzOxzjWucIKU/c8/UmdDsP+ZlOnio3WqcsiRizN5lvFHOiRZkuzL9truXRGcHdWiCP8pL2jEFghOL2lA0OMuMYESszO1TfqLz5V3iHf34B/h+wzJz5uRRBiFjJn8w2djLQbwBMkH0kj3Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798402; c=relaxed/simple;
	bh=paNnZXd0n0wUZOMheq3FtP2o/Xy+TyO/Tmcsoql7kaM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VuNTxyE3ky/JGGQtj4thXJmgyOvsKJbHTeGOJPkJ14qHPTlWXyUe9cMZCanloDss3eOBlURaZRuXIQDB2b5VXYOdMxOOuSCIpWIlBMFuhdvX+kFAUWEBeEqJAm2AMjYRt4JmdkgepAR8l5TayM+8ljuQqSvEEeaIbnQCjZQbsI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlO4dmND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlO4dmND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A65C433C7;
	Mon, 18 Mar 2024 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798402;
	bh=paNnZXd0n0wUZOMheq3FtP2o/Xy+TyO/Tmcsoql7kaM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IlO4dmNDkE2oFmp+8lF4nuamexAp70vtwKq+A/M80PpH5ipiGxBh1sXeQJOjjHS3p
	 5f2CNl+e2+DnV4RB3QIkIo1Hj4zCp1ELBwPOfl2thyAAIG+aApRauAYGXWJ+njkmaW
	 QOXnQnmmZW9dBI19XN+bwnBVLZeSHybthemjEHHqYoXtn09hbBAys80rgK6a5S97fO
	 AHToPt8CmoTRL2sOax1p29D0vQBim7eL0Md6tB5elCvfbupVWmHD9xtwI+7bFTeA6M
	 CAvaXwraiw0lTKiEzxGsx4+DkqltN+OxfgS+A7NlIyRXpgz3aaMVfAQQ2vnwNa24Eh
	 bAJwTKm6hDF+Q==
Date: Mon, 18 Mar 2024 14:46:41 -0700
Subject: [PATCH 18/23] xfs: don't remove the attr fork when parent pointers
 are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802167.3806377.2275796484801033097.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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
index 78a6d4411d2a0..af9e712216ea4 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -877,7 +877,8 @@ xfs_attr_sf_removename(
 	 */
 	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -886,7 +887,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}

