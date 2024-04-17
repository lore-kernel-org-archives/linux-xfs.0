Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52D318C19
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389392; cv=none; b=Dy8hf4LjHA9MqcaQSs1CvhPpLoOd91qgiiHkMIkJQRe/EhnEeTqCClojCRNM5gTkZMS7NpR6z4TSbT8+2u/EA08P7fRqLSDtpK2P4sS54cjanbH1gqE5xNHRA9dLr1OsCVWHDMrjXyoeXKBSsDSMGmg2Iy3qFGWvjECmt/Vml08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389392; c=relaxed/simple;
	bh=K8TjSdboKR9mslJYOuocASjdZzKxUhVH7/0M/XxMKKw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KCi3nFbbiNdDTPvYKlfobNXBXBkvyG5CIjQQaG2o7XFFf+u471KIhAggflFeJGtfxVXOF3R/hstslLthTf2pZpTyElRXsz4hrOWbRp5zdugV9HQp4S7RtZvn/ldm8P4EEtJqjz9iibSdATPZxPhTHKZRQtrlDnZSmIsdyki2XGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=daBZqYS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="daBZqYS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4F8C072AA;
	Wed, 17 Apr 2024 21:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389392;
	bh=K8TjSdboKR9mslJYOuocASjdZzKxUhVH7/0M/XxMKKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=daBZqYS7jfuoJlfiN9+SzxXRTjCtGgtZkExl9xJGmSSPIENsZANCYRofNS1LvxPCV
	 ZEZfj+03MxmsKqfSfhT3t05QDxCZsA+1htx4/xPQKrRS+Qm703rz6PIAb/WWAjmmVl
	 gRDduva9DjPRhp9S6Z46voj/wGBqAOf8YJCb7FKz21a3rHkW9RD8eaKodjNNDI1ohx
	 dUgrCI9ldWA6Et/N3JEDcLO3TBMtz3WpPqnEUfohk0bylRwycy9QXeqTpzjw7ORPwR
	 A/LR8/FEj9MS5F1vUZua71pPWTGzgc2pzl5Qz4Vlku4oIQXsQunx6TfuBpfShRs9RS
	 v5/TE4cJk+qBQ==
Date: Wed, 17 Apr 2024 14:29:51 -0700
Subject: [PATCH 31/67] xfs: read leaf blocks when computing keys for
 bulkloading into node blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842805.1853449.10398280839757396531.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 26de64629d8b439a03bce243f14a46f7440729f3

When constructing a new btree, xfs_btree_bload_node needs to read the
btree blocks for level N to compute the keyptrs for the blocks that will
be loaded into level N+1.  The level N blocks must be formatted at that
point.

A subsequent patch will change the btree bulkloader to write new btree
blocks in 256K chunks to moderate memory consumption if the new btree is
very large.  As a consequence of that, it's possible that the buffers
for lower level blocks might have been reclaimed by the time the node
builder comes back to the block.

Therefore, change xfs_btree_bload_node to read the lower level blocks
to handle the reclaimed buffer case.  As a side effect, the read will
increase the LRU refs, which will bias towards keeping new btree buffers
in memory after the new btree commits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_btree.c         |    2 +-
 libxfs/xfs_btree.h         |    3 +++
 libxfs/xfs_btree_staging.c |    7 ++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 85f8bef06..97962fc16 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1327,7 +1327,7 @@ xfs_btree_get_buf_block(
  * Read in the buffer at the given ptr and return the buffer and
  * the block pointer within the buffer.
  */
-STATIC int
+int
 xfs_btree_read_buf_block(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 4d68a58be..e0875cec4 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -700,6 +700,9 @@ void xfs_btree_set_ptr_null(struct xfs_btree_cur *cur,
 int xfs_btree_get_buf_block(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, struct xfs_btree_block **block,
 		struct xfs_buf **bpp);
+int xfs_btree_read_buf_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, int flags,
+		struct xfs_btree_block **block, struct xfs_buf **bpp);
 void xfs_btree_set_sibling(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, const union xfs_btree_ptr *ptr,
 		int lr);
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index ae2d9c63f..be0b43e45 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -489,7 +489,12 @@ xfs_btree_bload_node(
 
 		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
 
-		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
+		/*
+		 * Read the lower-level block in case the buffer for it has
+		 * been reclaimed.  LRU refs will be set on the block, which is
+		 * desirable if the new btree commits.
+		 */
+		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
 				&child_bp);
 		if (ret)
 			return ret;

