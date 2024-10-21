Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1702CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548453; cv=none; b=rTG08ja331Q3zU5yEPl3kH7lxpuv+UNDQE62BWfI7xxpfTsbXAdHWaEj21jzj4yCfxx6veQ08P8DNP7w9A+ic84xXA8Eb62o30y5ZLgP2DSc+PrbTop6v7/YZVrzFaFCMBreCLHc78UrY+MdaP/2FxNd57zCLPiMWP1lSwfXTts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548453; c=relaxed/simple;
	bh=CX0zA8QDeUJtuMzKPiMQjrlq4wtusGGSrqsuxGS/RQE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RHoCTDwLacP/GA5YSox1CBWw9nUH5B3SM5DWLIazgsnrLZ2vSpWGdPUAQFpOyDtjhBN0Ht1QEr2osKijEu9UMK3zdTho6fUPESV0cAzShGNThNvFMzLWJmat87kI96+YK67LLlvAZIrAHeWurSeq8XeWM8lat59GZzP8hY86e2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqCpyz69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqCpyz69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B586C4CEC3;
	Mon, 21 Oct 2024 22:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548452;
	bh=CX0zA8QDeUJtuMzKPiMQjrlq4wtusGGSrqsuxGS/RQE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UqCpyz69EuLlkPbtuHfmF4rJDB4cIQGB90a/2/6AXAe70TUiUm0HS1mpla/S63J12
	 30MYi7/Tk4eUkBBqwA2BCmcsuar0nu6CGkYh+4ZcuTg7eE1f1Kkg4uqmWwh20xC1Hq
	 Rv+Xu1smi/NJuUsWjlWgHX84n/v9B4fzlDrc9buXLu1AZuEk9jdpgLhQpAUA3aq2OQ
	 XlDzq9gSEkahbjo2BtZiC0JpUNecUAKCGoLs58iYZJrgqh595hiAAER1qnDzq3MWBL
	 ZKF2bB3lql3mJUZ9vdQ0vHEJTQ9/Bf88G+wuOoQRcDkKIRmsEvyBofILb1s9J5oJM0
	 yOrwwNg9tn9Qg==
Date: Mon, 21 Oct 2024 15:07:32 -0700
Subject: [PATCH 33/37] xfs: distinguish extra split from real ENOSPC from
 xfs_attr_node_try_addname
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783970.34558.12079523515599805667.stgit@frogsfrogsfrogs>
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
 

