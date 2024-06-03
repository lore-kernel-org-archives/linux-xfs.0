Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B20F23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442507; cv=none; b=fsRhItFZLRAl8R76oOjAwAyMvfhvWWUvPIJYFR5HQcxMFGzM/xMVr8HistK5+kxDZ0Gf323S56Gjg12HuH5fJ7jDS6hROtAaa35SwHP+aIqt20aUmSP0kJXt3WWYMuYM0vL/BNqcaWAblEHkJxLYqRIthq/vIXad1QZ0ngfw01g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442507; c=relaxed/simple;
	bh=FBZsnHOr5AIGIligEInAW7rw/9Eb39Hij/cOw/OLVYI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gwg6W1LB9cJMuG4oALjm11uzEs/nQcRw5eQTkuqC23zjmDZr21LK+g4QnIO9Yn8Ed1JQY7Rl4ee5BFdLyA1dGUi6g6p/MsMQDjduZ43fYBMesYzB/WEksScL5Vw7MHC3O8avONaKlyLNQLh/ggIKBNRzUh12U3BqEjY9NaN3hx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sm7G9v91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sm7G9v91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4F7C2BD10;
	Mon,  3 Jun 2024 19:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442507;
	bh=FBZsnHOr5AIGIligEInAW7rw/9Eb39Hij/cOw/OLVYI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sm7G9v91+hZuZ+9PKqTAv2bWtVCSO3Ch5oRW0wjSlZH+nTqWpP3ADR5+iT2wv5jfc
	 5Q9bNCzSphRvzYuYRv5uRs5vWrQn79sayqclcFnkapBj0MdXsXxu4N+8Cyl1AKN+Sj
	 nQjg+GZOk0dIeqqD0qvCN45Zr5GSvCyO1jaH58CigRmdXUXM/V9q90qokX1TFk309G
	 qyJ40ynzXslNE/O+ZkXfdgQHpvSxnLi93psLPzs7Gn1JaUcN1xoqlHQkUkeesBI5jr
	 7fQAOYbQelTJEkY38eHY7hu2CjT7DeXNcBHsjZEppuHyJiOtaFelJgZpQKcKrL/T22
	 ET/h0VUJysefA==
Date: Mon, 03 Jun 2024 12:21:46 -0700
Subject: [PATCH 3/4] libxfs: reuse xfs_bmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744041399.1447589.16585924367857721398.stgit@frogsfrogsfrogs>
In-Reply-To: <171744041355.1447589.2661742462217465267.stgit@frogsfrogsfrogs>
References: <171744041355.1447589.2661742462217465267.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d19322a0b..36811c7fe 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -522,6 +522,17 @@ xfs_bmap_update_put_group(
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
@@ -539,8 +550,7 @@ xfs_bmap_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_bmap_update_put_group(bi);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
+	xfs_bmap_update_cancel_item(item);
 	return error;
 }
 
@@ -551,17 +561,6 @@ xfs_bmap_update_abort_intent(
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

