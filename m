Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3095234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346238; cv=none; b=h3lHlODpW0MJBwgsJd4vZU+HWY6tqJhgEJy9CciWp9nx9VSlxCfmb6OZ2QDu+pqsWLpw3L8385N8AEDbfQ7wFawUrahKmIhEeKS6VmFgpMtueopdX+MthdF7McD38O23b0omiqgBu1xFsGAmuisj7b0N6uJOqZmikU7vf0Ixp5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346238; c=relaxed/simple;
	bh=bZyN6lisb9kgp+FpTKWkyfPtO4Wvvx59zvJYE8bgAuI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEm5Zy3iOEZkr76R36auczwKYyXw/QCIP+lBzLsJ9QkX6gkKMgJg/40/Q5Ri/b54m8CRfjfZlGYFLNzZJnNZYLEQJoeIUK43IqjLYJiOvSP+OT/m3sKe1pL/I4SixrH1ILpT9wc2vkIKNHhTarm9YCDGnB24rEjSvmDn8xmcgIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qzTTDc3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzTTDc3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBE2C2BD11;
	Wed, 22 May 2024 02:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346236;
	bh=bZyN6lisb9kgp+FpTKWkyfPtO4Wvvx59zvJYE8bgAuI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qzTTDc3mMYecsfRlWKkpmcnjvyncNgTa4sstMMLZp/NFwL7xdSEOW5ninDe6XBKu1
	 4zUTO0LYa1LKyWDBJngQKZydfNUqRMyfph0GXPMcHJtlfOXZRUOSTK5zTATQizJ3qv
	 A9d6yy/s+W57eUXS46hlCK8z5CyrmjvAZy7LKy2F7lIfWrxZKCKegKBAfVkgpDsnjW
	 /6iouFVVmxtcgGPw9xderHYAgOTwtWceQrIHqf1AxJ0dLixf2DlpjnV6R9V3ayO0wW
	 yA9DxysxTwlTSR0e7Xde6NtMcof7U26PYu8DppS9znC5pJKxY7335dMA8MDCypxQpw
	 jEBsq83lkETTg==
Date: Tue, 21 May 2024 19:50:35 -0700
Subject: [PATCH 007/111] xfs: use xfs_defer_alloc a bit more
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171634531816.2478931.12048817051084162147.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 57b98393b812ddaf9cf33a0d57d70b25cabfed66

Noticed by inspection, simple factoring allows the same allocation
routine to be used for both transaction and recovery contexts.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_defer.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index dae9ad57f..9f960bec4 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -813,7 +813,7 @@ xfs_defer_can_append(
 /* Create a new pending item at the end of the transaction list. */
 static inline struct xfs_defer_pending *
 xfs_defer_alloc(
-	struct xfs_trans		*tp,
+	struct list_head		*dfops,
 	const struct xfs_defer_op_type	*ops)
 {
 	struct xfs_defer_pending	*dfp;
@@ -822,7 +822,7 @@ xfs_defer_alloc(
 			GFP_KERNEL | __GFP_NOFAIL);
 	dfp->dfp_ops = ops;
 	INIT_LIST_HEAD(&dfp->dfp_work);
-	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+	list_add_tail(&dfp->dfp_list, dfops);
 
 	return dfp;
 }
@@ -840,7 +840,7 @@ xfs_defer_add(
 
 	dfp = xfs_defer_find_last(tp, ops);
 	if (!dfp || !xfs_defer_can_append(dfp, ops))
-		dfp = xfs_defer_alloc(tp, ops);
+		dfp = xfs_defer_alloc(&tp->t_dfops, ops);
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
@@ -864,7 +864,7 @@ xfs_defer_add_barrier(
 	if (dfp)
 		return;
 
-	xfs_defer_alloc(tp, &xfs_barrier_defer_type);
+	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
@@ -879,14 +879,9 @@ xfs_defer_start_recovery(
 	struct list_head		*r_dfops,
 	const struct xfs_defer_op_type	*ops)
 {
-	struct xfs_defer_pending	*dfp;
+	struct xfs_defer_pending	*dfp = xfs_defer_alloc(r_dfops, ops);
 
-	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_KERNEL | __GFP_NOFAIL);
-	dfp->dfp_ops = ops;
 	dfp->dfp_intent = lip;
-	INIT_LIST_HEAD(&dfp->dfp_work);
-	list_add_tail(&dfp->dfp_list, r_dfops);
 }
 
 /*

