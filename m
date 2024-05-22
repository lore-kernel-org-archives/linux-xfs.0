Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DA573189
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347895; cv=none; b=Cek3JjUEiJS+ZlhV9ChrZzBbl0tFTQzP70FLZghpNxzh12nXqt7K0zkj3LU5q4Maq3VRJBqzoJ25uOwzXZgRW/JW62dXNdMD8S1obBjz3XKt+PcPzuorLlF6xFQYW2hhwepv/IRFSr9fFRp7FYhdsu2Tisz7UAxj53synen9nkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347895; c=relaxed/simple;
	bh=+wHMyfSEtMcKpEz0HGSfcVW3MruNRahdnfkA3CDye0A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Svfy+u2geKZnb7pwk2oJ07BXeqrsiNZaUv8s6x0NAh5miHHLjM/z2hrI4DlOO6KWJQtqJjlu8NhW2aBqM+8XXWg5hZWR8ZSLZcK8yvNxupVEB43lgaLiq77lrtT24VYs1JGQSTivARQAlqsfvqegpH6KcoJcLjtLK1oVhOolX/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nc+CTqM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nc+CTqM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56883C2BD11;
	Wed, 22 May 2024 03:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347895;
	bh=+wHMyfSEtMcKpEz0HGSfcVW3MruNRahdnfkA3CDye0A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nc+CTqM1+Tf4FhG7y34u+bWSqc77NBYXeXwmkE5pD4MwRX/Pvoffb4svyXhVMAma2
	 /WluBGPVVDEUzPAytRfvV1T8lraaB7JSEooW0kYN+Nrqrw8GXTV0hIE6qraULbVa99
	 rM8tow4Y/qdauBlSpNJ0OQiJB4laP3aOOOGf4UJvli1J0e4p62noGNeiCxoYq7rsY+
	 JDsU7ul5slo1KybwV/5BzwNQo1e5bwFcCLmNCxXlhRxz1Ibz1otEhyzm7Dprlg8uIT
	 6kzIc5W/eHKkOHY7g07LJPovYQIJvFfkSii7KZhG6Wk/rEr1+wwCkWhFdzYqh8PfSO
	 YTQaWDLVMG9PQ==
Date: Tue, 21 May 2024 20:18:14 -0700
Subject: [PATCH 2/4] libxfs: add a bi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533726.2482547.3975502822386754001.stgit@frogsfrogsfrogs>
In-Reply-To: <171634533692.2482547.7100831050962784521.stgit@frogsfrogsfrogs>
References: <171634533692.2482547.7100831050962784521.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the bmap_intent
structure and use it so shorten assignments and avoid the need for extra
local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 680a72664..d19322a0b 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -439,6 +439,11 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 
 /* Inode Block Mapping */
 
+static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_bmap_intent, bi_list);
+}
+
 /* Sort bmap intents by inode. */
 static int
 xfs_bmap_update_diff_items(
@@ -446,11 +451,9 @@ xfs_bmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	const struct xfs_bmap_intent	*ba;
-	const struct xfs_bmap_intent	*bb;
+	struct xfs_bmap_intent		*ba = bi_entry(a);
+	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	ba = container_of(a, struct xfs_bmap_intent, bi_list);
-	bb = container_of(b, struct xfs_bmap_intent, bi_list);
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
@@ -527,10 +530,9 @@ xfs_bmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_bmap_intent		*bi;
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 	int				error;
 
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
 	error = xfs_bmap_finish_one(tp, bi);
 	if (!error && bi->bi_bmap.br_blockcount > 0) {
 		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
@@ -554,9 +556,7 @@ STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_bmap_intent		*bi;
-
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 
 	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);

