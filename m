Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541F5197A81
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416638; cv=none; b=QH9l3JFnbY8bXXXSAQI447VO702opu0/NXB4ozKstNIBwuRq8v1QXPN1NP4u/KOLnreuEbcjyI8K8R/2if8Po9g7IVO3t5e8ryRoLieypMVEbvwrdDxRyA1g7sPmThF1C5fEDjmhScueXztcEk6Gw/78tGrqojKcE/fp5Ba/7bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416638; c=relaxed/simple;
	bh=CX0zA8QDeUJtuMzKPiMQjrlq4wtusGGSrqsuxGS/RQE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/0ZESTR7/SRPH7auvsMSh04saP2mEVIWdPnqwDe7MYk1ZZSm12s6aWmNAtCZ9F96t6MzANfirkNlBQYfAASX0Wm/FJDxS6LOqNWlINvfzLEHNYsWMdqQJ65iaoAAGqmHr+85OhjhNYfuKstkvD7/AdntFpY0H8sgC7VcSI8zTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tiAbyQnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tiAbyQnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F11FC4CEC3;
	Thu, 31 Oct 2024 23:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416638;
	bh=CX0zA8QDeUJtuMzKPiMQjrlq4wtusGGSrqsuxGS/RQE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tiAbyQnkDA31mDjiKncknHp8GH4xhIB7z/TLdRrnHm8Do4wXkp+XFB+SxxU2/jJJu
	 hF0rr8sUF0y2GNfrO4bSvHiQN3ftFO8s7Hca5oZek4LsGJyi9/cTvDJLhoEJevtxLO
	 FxHA7I3UGy9+K0/rVOy84HOyc3D2V3VjGj+G0YNPZA0Q3pn5acUWgDAmQkHzFpfPS0
	 Uisdaoik8LYdBWdeXt4oeCkEh34uXkswbxDrW4ntVmWXu8p18xglJuwz4DgZz7KDPn
	 kWzxsfOlBw9bBwe0S9de9oHr5uSXVHTqBSxx8ye02+a0ZL1zX/Nq/tXENz4Dube3Ux
	 1D7jwdAqC+aWA==
Date: Thu, 31 Oct 2024 16:17:17 -0700
Subject: [PATCH 33/41] xfs: distinguish extra split from real ENOSPC from
 xfs_attr_node_try_addname
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566421.962545.10997599089245855400.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b3f4e84e2f438a119b7ca8684a25452b3e57c0f0

Just like xfs_attr3_leaf_split, xfs_attr_node_try_addname can return
-ENOSPC both for an actual failure to allocate a disk block, but also
to signal the caller to convert the format of the attr fork.  Use magic
1 to ask for the conversion here as well.

Note that unlike the similar issue in xfs_attr3_leaf_split, this one was
only found by code review.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9ac7124b0a7bc1..150aaddf7f9fed 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -596,7 +596,7 @@ xfs_attr_node_addname(
 		return error;
 
 	error = xfs_attr_node_try_addname(attr);
-	if (error == -ENOSPC) {
+	if (error == 1) {
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
@@ -1385,9 +1385,12 @@ xfs_attr_node_addname_find_attr(
 /*
  * Add a name to a Btree-format attribute list.
  *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
+ * This will involve walking down the Btree, and may involve splitting leaf
+ * nodes and even splitting intermediate nodes up to and including the root
+ * node (a special case of an intermediate node).
+ *
+ * If the tree was still in single leaf format and needs to converted to
+ * real node format return 1 and let the caller handle that.
  */
 static int
 xfs_attr_node_try_addname(
@@ -1409,7 +1412,7 @@ xfs_attr_node_try_addname(
 			 * out-of-line values so it looked like it *might*
 			 * have been a b-tree. Let the caller deal with this.
 			 */
-			error = -ENOSPC;
+			error = 1;
 			goto out;
 		}
 

