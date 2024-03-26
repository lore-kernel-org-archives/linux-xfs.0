Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83AF86AC1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423814; cv=none; b=W3MBZeLVXfv0ZVUqqIQBsbEQ0HW5J4zeqaxDG3pvmMIl4v5Utn4pQi5wpqEPMCpX9kFZ8fxqQY16nCi4ww36s+COo5pPRcmjDUSpnjLVXGYwV4QINegl+ZNYZArvs5GvFdc0mYdkd+UrdWNoWAlAE6Ob0oX6gKjSraKfaz6fBSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423814; c=relaxed/simple;
	bh=Ok5x4J65kheBDLDtz/bcNR5Tosm1N2gAR8sL/nobBJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tynLDXf/h7af9RYriN7c9pNwz+tjfN1m5mTVIpVCXCpHuW0u4RMn5WQCAxpEXiQDDj07C6iIhdIF47jWjphMe9Cl1FzhpZH9Ad1/KsscJ6VuJOtzfcwwTZC7hkOOvw8di0kb8O92cKys8gxsVsIAKIvun+YJtayDTAVxkD/Dxww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ql32qQLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ql32qQLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931E6C433F1;
	Tue, 26 Mar 2024 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423814;
	bh=Ok5x4J65kheBDLDtz/bcNR5Tosm1N2gAR8sL/nobBJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ql32qQLTxkuoHdzWLBjf3RsEcLwSiBDTYeLbpf/3UpQTZQXQqF32YnbII0He2isDj
	 viS6BIvU9/9ddUXrO7O1POhVxxVdtOPNjbVlqzlbsxwrWU4zqfYhxHUI5qtllsXGkD
	 5i4koHdMOFGbxpr9n7LajKkdM7NZ1gYQc6jq6KG5gwXA6IVSTcmsytzzUEY0P4duI2
	 190Y7SV7TmXBw5rDMnSjMNdY60tyoSR1IfNCCVgJHY7apWYgCTNkTMz5f55M5nqGRv
	 FGcDgaD3HjHv7ENt1eAAyBthnXfnF8t/uXyNjUKjtVuvN1SkRL8ZktR3VmQBBSZnrs
	 vMvm0vJcqdehA==
Date: Mon, 25 Mar 2024 20:30:14 -0700
Subject: [PATCH 007/110] xfs: use xfs_defer_alloc a bit more
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171142131487.2215168.5054242161737299786.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index dae9ad57fb2e..9f960bec48ab 100644
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

