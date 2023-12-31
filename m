Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59915BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9gSwt7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C781C433C8;
	Sun, 31 Dec 2023 21:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058245;
	bh=tivL8laqZxEzUaInTZLQWhRIZmeJa/d01TBB1I6nUW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N9gSwt7/ECpRlg/zAXEW4291v/IaAl2xvKo134Tod4V/940gkSjVGZusRVWC63kjK
	 WvhJgFOMuF5YHfKXPZ9XPq6yEcD9EczJUAnKxVdYi9axxbctqM6XzLjdyaDsO8ynTz
	 8SUO0FtkZmNnVmINqfSZeYURK2WZ5OOM9c68Hvmpubdg/qQsr0xbZlFa7hhx/giVU3
	 aGpDJb/RjkrZOWblVWv5QZbIIZzuIk3ajgoNxyR9pf7J+LUir+9O0RiyBYABS8EIqV
	 qGpYKmrtpY1Kz/oogHQr+NO0Ex3kKuGOmWkuMctqqh0zNJIoAtpH+BzKtFraRkX0w5
	 YsldbH1GKDZcg==
Date: Sun, 31 Dec 2023 13:30:44 -0800
Subject: [PATCH 06/10] xfs: add a ri_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404849331.1764703.10863385655407554494.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add a helper to translate from the item list head to the
rmap_intent_item structure and use it so shorten assignments
and avoid the need for extra local variables.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 3e67fe2133263..80433d6b2f9a3 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -225,6 +225,11 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
 	.iop_intent	= xfs_rud_item_intent,
 };
 
+static inline struct xfs_rmap_intent *ri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_rmap_intent, ri_list);
+}
+
 /* Sort rmap intents by AG. */
 static int
 xfs_rmap_update_diff_items(
@@ -232,11 +237,8 @@ xfs_rmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_rmap_intent		*ra;
-	struct xfs_rmap_intent		*rb;
-
-	ra = container_of(a, struct xfs_rmap_intent, ri_list);
-	rb = container_of(b, struct xfs_rmap_intent, ri_list);
+	struct xfs_rmap_intent		*ra = ri_entry(a);
+	struct xfs_rmap_intent		*rb = ri_entry(b);
 
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
@@ -363,11 +365,9 @@ xfs_rmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_rmap_intent		*ri;
+	struct xfs_rmap_intent		*ri = ri_entry(item);
 	int				error;
 
-	ri = container_of(item, struct xfs_rmap_intent, ri_list);
-
 	error = xfs_rmap_finish_one(tp, ri, state);
 
 	xfs_rmap_update_put_group(ri);
@@ -388,9 +388,7 @@ STATIC void
 xfs_rmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_rmap_intent		*ri;
-
-	ri = container_of(item, struct xfs_rmap_intent, ri_list);
+	struct xfs_rmap_intent		*ri = ri_entry(item);
 
 	xfs_rmap_update_put_group(ri);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);

