Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE427F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440833; cv=none; b=LaprOPN/4K7sHunvHjeHpCQpGDAH68yCUNMufdXMX7jhxLAy8FFXDFSovKFFV1XZGXLskXgSomRx0WDrwYeQzo07AxC/nfiPFOump2Ws11PfHmR7hJUgQaen7M7iqzNqt8KPt0MnWB/f+rBG3SeYk8oTXxmPylzuhHqTyLPMaLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440833; c=relaxed/simple;
	bh=j2OGJgrXA0prf6awQXTColt9rgl1VO9/UmR8/IHfCOM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aOuFrpxBzjqnc8m+NsfR9SOsWOms3hy6tUdBO9ouVB3aXrbrklmlgpduYHxA2/7eXMV85lMDOhFWw3+gWwGHfuTdmJAvsEHjYP3p14JKmU7Kmht9JUORVOm/vB3PVD5KUPE5Onj1mlsevFQDoEh3YPfbmSRI47ke32mbdfS1uu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8MQecIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8MQecIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0CDC2BD10;
	Mon,  3 Jun 2024 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440833;
	bh=j2OGJgrXA0prf6awQXTColt9rgl1VO9/UmR8/IHfCOM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B8MQecIEUioEPLDGjgDsNwzAkDiCEYW2IBJwU7dTA9jzCBTWQJ4inG2XF5F6URDz0
	 iSMsrir+a4wOPywmCz7ABiAR8QQpasqrcY44B1lZb+d4UfaB3ikNp59Q2bzPxbrMrw
	 z3vkPRX0er/JMfrDy/lhh/NRERhulMG69DeAU8j7Tj773IDbp9JP21ujBAe5DcNS9A
	 wI/5MPkwDCN735SXx5gxyOXb4hV3ADemivCoq5MR0nd74wlSJLRnlKOxGgt/QECNxw
	 aiL+61oWPsOMxRUoYh5h3wm8qq/xsIdiP6oGGPQX6tCDiNO6CIFGqBAxtoBxwf8mua
	 /1SrHW09vUsZQ==
Date: Mon, 03 Jun 2024 11:53:52 -0700
Subject: [PATCH 007/111] xfs: use xfs_defer_alloc a bit more
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171744039471.1443973.15698982141104088087.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

