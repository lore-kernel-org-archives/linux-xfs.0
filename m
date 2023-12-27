Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C7638B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opDQZCXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB80C433C8;
	Mon,  1 Jan 2024 00:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067784;
	bh=PleTMzUg2BgAjO0KcsHT8FuREoSZ4eFvygNkdcgYdWU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=opDQZCXSrQlPNacnldINp6DyQXYZwwyGhete+Pv2D2C72HFRlfHu+EYpUbedFQ7lu
	 dhp+nYmvq8VlOFIiqFhJr7N6Nt8OnYVe9aMB9GdCVQPAuawN4VU44d69W8W5g3Gfz5
	 BLWocYnmZG6Q1QeD2rLbrYV44vwVVFOBi8AynYBErJIvdf2JDxXUQnneHRidGXQDVy
	 3sT+eNgbyjNHFgZYC39isJsXam/rKsPhaSz9K28XUKDsxKuCWtJi3IELjSxrygoGUh
	 TcKdd+TQRMZ+Mt/XkWG+6kiJ9h5RsBTXYP+aj50R717qejRKDb9C3ylWBvNIKaOdNo
	 U9boRZz0hP9zA==
Date: Sun, 31 Dec 2023 16:09:44 +9900
Subject: [PATCH 6/9] xfs: reuse xfs_rmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014897.1815232.859570840654002099.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
References: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
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

Reuse xfs_rmap_update_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 8fc27e9efd4..e7277b54532 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -335,6 +335,17 @@ xfs_rmap_update_put_group(
 	xfs_perag_intent_put(ri->ri_pag);
 }
 
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_rmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_rmap_intent		*ri = ri_entry(item);
+
+	xfs_rmap_update_put_group(ri);
+	kmem_cache_free(xfs_rmap_intent_cache, ri);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_rmap_update_finish_item(
@@ -348,8 +359,7 @@ xfs_rmap_update_finish_item(
 
 	error = xfs_rmap_finish_one(tp, ri, state);
 
-	xfs_rmap_update_put_group(ri);
-	kmem_cache_free(xfs_rmap_intent_cache, ri);
+	xfs_rmap_update_cancel_item(item);
 	return error;
 }
 
@@ -360,17 +370,6 @@ xfs_rmap_update_abort_intent(
 {
 }
 
-/* Cancel a deferred rmap update. */
-STATIC void
-xfs_rmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_rmap_intent		*ri = ri_entry(item);
-
-	xfs_rmap_update_put_group(ri);
-	kmem_cache_free(xfs_rmap_intent_cache, ri);
-}
-
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.name		= "rmap",
 	.create_intent	= xfs_rmap_update_create_intent,

