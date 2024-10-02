Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853F8F54
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831958; cv=none; b=KIP6ZTW2UCEs2jyeMRnQ0pPz2CUECIVwV8F0Y2MdU6XuNzK7oymZz+XhTRakSfPWUNTMsR8K3JY7++c+DCFMpKjw5DNf5QMumBhf3tsmD1a3rJcVlKX394yLJehCEGObdFvuBZ/p5m2b0ohIZkAFf+2JUdNQEeMXMeCSzjfjzxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831958; c=relaxed/simple;
	bh=0kcMj1661Z6D3gMTb2n+uw/UVElE+4ZtVWRxnwLUoRc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mhh9uq96s7bROueFeRYmSjJ0jnjcF43otdp8welAz0TJnm/4PDgo+ulzcMkR1eopjkttskr+emGLXoOwFInjGgJ0fWD1PQnGVKFfMZkFIlNgPVoju/MImtxA/oVbc/x5zAOiY2qVgyL1Q6lYcWzvvki3SQqJDN0Lub/pkfNHJY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6Sm6Jtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6Sm6Jtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40B3C4CEC6;
	Wed,  2 Oct 2024 01:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831957;
	bh=0kcMj1661Z6D3gMTb2n+uw/UVElE+4ZtVWRxnwLUoRc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p6Sm6JtwOMDWnsiFIhd06kOBznfUzNwnwbgzSBLj45Pnlk0jnhrTLpSqR4wJlQ4sx
	 jrgsJoK+n/xlv/FVv+jqt3sXq/2J+YJ4raLeH1XYRbLFHg3Oy5w8B9H0UKyimQb175
	 OOxlAk2s6363p01xyVR1Le7W9amXgxV//jNikpGB5PdYyflJ9MrpwD5OgLz8K7BR71
	 NwEngMkp8j2Y1w6VCkohYAyMb3Q6GN5enQOee7YChTgIXhPwYQeaOxf6moY/zfGA2f
	 eCBTC+pvPZuEMvRl3He5TNgL1snPv8Fsil3tpggZJ15bt6QEwYEkd6StK9fLWjASr+
	 fZwm0xvxkN3dA==
Date: Tue, 01 Oct 2024 18:19:17 -0700
Subject: [PATCH 44/64] xfs: add a ri_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102445.4036371.16980960185858523483.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: f93963779b438a33ca4b13384c070a6864ce2b2b

Add a helper to translate from the item list head to the
rmap_intent_item structure and use it so shorten assignments
and avoid the need for extra local variables.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 2df0ce4e8..013ce0304 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -200,6 +200,11 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 
 /* Reverse Mapping */
 
+static inline struct xfs_rmap_intent *ri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_rmap_intent, ri_list);
+}
+
 /* Sort rmap intents by AG. */
 static int
 xfs_rmap_update_diff_items(
@@ -207,11 +212,8 @@ xfs_rmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	const struct xfs_rmap_intent	*ra;
-	const struct xfs_rmap_intent	*rb;
-
-	ra = container_of(a, struct xfs_rmap_intent, ri_list);
-	rb = container_of(b, struct xfs_rmap_intent, ri_list);
+	struct xfs_rmap_intent		*ra = ri_entry(a);
+	struct xfs_rmap_intent		*rb = ri_entry(b);
 
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
@@ -266,11 +268,9 @@ xfs_rmap_update_finish_item(
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
@@ -290,9 +290,7 @@ STATIC void
 xfs_rmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_rmap_intent		*ri;
-
-	ri = container_of(item, struct xfs_rmap_intent, ri_list);
+	struct xfs_rmap_intent		*ri = ri_entry(item);
 
 	xfs_rmap_update_put_group(ri);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);

