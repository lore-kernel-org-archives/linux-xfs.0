Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EB42CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548437; cv=none; b=Nz2xrLCWLbGPSccU7bxxOPPjc2y4uNGZ6CRL97Me/Q9JczGQcowMIuUU4vsV0IiNoUtvWk5JadNehy6MyXw69JbAyYvdGdsy1RiE11EHNsqWrHKIksWMnfCNKoqS/ljYadC1edh575TMo5IcRmzH4NTEfD6WbDEl7VHy29rQMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548437; c=relaxed/simple;
	bh=QjOsC+90r0vhbovJLIgdY+DUlCwrCsbx6nB5mqkFRV4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t1rAurLEO6fEeBsVKh+baMLioP9CYVM0vo35OnWvHjnxrWAxDNsoM/xJwRl/8Cq19Y7oYJUleS8J/XZtrexIfydMiOzRbhAIeVAeYeNxy/JnEx4jJz+6YN3zSLYC+pMGcv1XDxVG2EWnXdSKppVElVdYWJXl6SOpV//V6lfyVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u7t1wRnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7t1wRnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EE3C4CEC3;
	Mon, 21 Oct 2024 22:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548437;
	bh=QjOsC+90r0vhbovJLIgdY+DUlCwrCsbx6nB5mqkFRV4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u7t1wRnKJrhhFakUYkoG+Jk/yYQuRIaPd0M1afwmFgLM262+6Pj4JGeVZG8mQsp2T
	 XJi73okdCHYc0jNB8Dx30HQpaKpnYH5WtSuOa93EIiROHAZJjstQLkR0uyhV3Lcjin
	 J9Yg8XXRT3MlG/R5cU5GuCFuwx8OBtzUWy4TTS4xlURykOvMgecerDddjPWZZ3IMtz
	 9nvNbn8HxHIVRN6+uW8Trwu6DYadVUI3yeHMighwzHAVMVC7xibso0XY5irYi9wF4r
	 +OCelD0MVgLLdO7+mSMRPyVjyLa6uVPnuzXX0Q7YK3SrbchglGKyPchuxMZbdwXBv6
	 k1EBYDS/OY2Rg==
Date: Mon, 21 Oct 2024 15:07:16 -0700
Subject: [PATCH 32/37] xfs: distinguish extra split from real ENOSPC from
 xfs_attr3_leaf_split
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783955.34558.4456747066669935339.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: a5f73342abe1f796140f6585e43e2aa7bc1b7975

xfs_attr3_leaf_split propagates the need for an extra btree split as
-ENOSPC to it's only caller, but the same return value can also be
returned from xfs_da_grow_inode when it fails to find free space.

Distinguish the two cases by returning 1 for the extra split case instead
of overloading -ENOSPC.

This can be triggered relatively easily with the pending realtime group
support and a file system with a lot of small zones that use metadata
space on the main device.  In this case every about 5-10th run of
xfs/538 runs into the following assert:

ASSERT(oldblk->magic == XFS_ATTR_LEAF_MAGIC);

in xfs_attr3_leaf_split caused by an allocation failure.  Note that
the allocation failure is caused by another bug that will be fixed
subsequently, but this commit at least sorts out the error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr_leaf.c |    5 ++++-
 libxfs/xfs_da_btree.c  |    5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 3028ef0cd3cb2c..01a87b45a6a5c0 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1328,6 +1328,9 @@ xfs_attr3_leaf_create(
 
 /*
  * Split the leaf node, rebalance, then add the new entry.
+ *
+ * Returns 0 if the entry was added, 1 if a further split is needed or a
+ * negative error number otherwise.
  */
 int
 xfs_attr3_leaf_split(
@@ -1384,7 +1387,7 @@ xfs_attr3_leaf_split(
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
 	if (!added)
-		return -ENOSPC;
+		return 1;
 	return 0;
 }
 
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 820e8575246b50..38f345a923c757 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -589,9 +589,8 @@ xfs_da3_split(
 		switch (oldblk->magic) {
 		case XFS_ATTR_LEAF_MAGIC:
 			error = xfs_attr3_leaf_split(state, oldblk, newblk);
-			if ((error != 0) && (error != -ENOSPC)) {
+			if (error < 0)
 				return error;	/* GROT: attr is inconsistent */
-			}
 			if (!error) {
 				addblk = newblk;
 				break;
@@ -613,6 +612,8 @@ xfs_da3_split(
 				error = xfs_attr3_leaf_split(state, newblk,
 							    &state->extrablk);
 			}
+			if (error == 1)
+				return -ENOSPC;
 			if (error)
 				return error;	/* GROT: attr inconsistent */
 			addblk = newblk;

