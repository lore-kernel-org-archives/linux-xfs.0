Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A14B8825
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231185; cv=none; b=lR1ZnUtnACkqhD7UjPfZTmZBlds2iVYLzFzu2mjTetdmNoEqntHs4YJRGaidnd0bIWp8jJgziPSHFSmn1ZWON64gEgDWO1zBBWRnMY4FeYYfXzErok26dUio9btP8TJd3BDqF43PgY4rYTvfH6B/wi4yMWyuzt7yC4x9mV31PfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231185; c=relaxed/simple;
	bh=TghmnuWsYPX0km0GCzAQfFB4Qe4syDW06GWZ7IaD3GM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8LcIxvw/hB7MzquvVgGFvDvDDjJGz1xFFwiFn32YCcv8lAfPxSZQhQ9+oNgfMDgiENArFCj9GDa5XC88GpnY45p2mL1/quyNkB2oZk2DEMuLnK5I4Kcr5v/UrCr10v2fDTzFzpvlUORHampwlxBqAQk0Gzd38tKajVWz0y+sKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugbX1guK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugbX1guK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56229C113CC;
	Tue, 16 Apr 2024 01:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231185;
	bh=TghmnuWsYPX0km0GCzAQfFB4Qe4syDW06GWZ7IaD3GM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ugbX1guKqy2YLnKQYbBI06BShLClVycR3f5bp+LqEYWmu0aDXjwLYmEIVMFm1oeZ3
	 ikriaujVADd4IH329MHbhMiKP7XyCBQDwfuydoF6aJIcHR+zhymmjDTb+xgq8icvaI
	 1FrVa6rPSQKUufVrYdZyFrRZUouPyUWasTNo2XeZBFmSGkHD7O1z48wPpbdhrKr4Gv
	 Fz8hpw5ibFeQrQ3dI06K/515mUm+3legTmRKr2JkGnK0OucyMVvKz0NMhZqk4ihjyq
	 j3soq9Pk2selWH+Cq3jZiXHT1ROu7Dh9v9onE27iEXnFd8U1xxhKQJ1Lo8qXn+cJSL
	 PF0AP9Yn5SE+Q==
Date: Mon, 15 Apr 2024 18:33:04 -0700
Subject: [PATCH 27/31] xfs: don't remove the attr fork when parent pointers
 are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028228.251715.10163291775181160117.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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
index e81cd48eb0000..69a3b9244b50d 100644
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

