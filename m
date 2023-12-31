Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814E3C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jajVRwnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6C7C433C8;
	Sun, 31 Dec 2023 22:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061467;
	bh=FOrzVjwyrBZ4ZRRms2ksb4ntu9oNtY2Mf4s1has9CIg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jajVRwnXVprYMJk0jQ4KnzSZOJy/igdKqtSATtm4fCNe5KERdmLuQ6EWavD/ISTOA
	 IYmDXUHhf0Nyw5sLjIMg3FmvJhygXtVkclRhnXkVpZ+RPoRJIvunzMN/XRvvNffdj4
	 zgMBOR2unVy5UD2AEbQZb97dxN3ID5mKXfnXg3xsd+Q+PWveLb/kE1IdNP7PKiT03V
	 F76+3cPk/vQdEMVlNUL8+jffFIlHbjp7kItFOpQvbkb96IKdEsXz0yzGf6iE92MHq3
	 C8pSGx8YFOtK3dMfVzK7IDTNAsKVCFsZ5Jm0fU8NNATEEMEI+6TSd7W/wzdGBmgmbo
	 LCh25xIUr2SnA==
Date: Sun, 31 Dec 2023 14:24:26 -0800
Subject: [PATCH 3/5] xfs: reuse xfs_bmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994860.1795600.6673888723814376634.stgit@frogsfrogsfrogs>
In-Reply-To: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
References: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
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

Reuse xfs_bmap_update_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 8e3ec056ed7..78de8491bb5 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -509,6 +509,17 @@ xfs_bmap_update_put_group(
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_bmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bi = bi_entry(item);
+
+	xfs_bmap_update_put_group(bi);
+	kmem_cache_free(xfs_bmap_intent_cache, bi);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_bmap_update_finish_item(
@@ -526,8 +537,7 @@ xfs_bmap_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_bmap_update_put_group(bi);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
+	xfs_bmap_update_cancel_item(item);
 	return error;
 }
 
@@ -538,17 +548,6 @@ xfs_bmap_update_abort_intent(
 {
 }
 
-/* Cancel a deferred rmap update. */
-STATIC void
-xfs_bmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_bmap_intent		*bi = bi_entry(item);
-
-	xfs_bmap_update_put_group(bi);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
-}
-
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.name		= "bmap",
 	.create_intent	= xfs_bmap_update_create_intent,

