Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D21A2F22
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607687; cv=none; b=OGUzyN7poIEt0jr8FR9t6bbDFATkJdPhu/cCngTvNe/6fUz6S2Sbrr2DftAildsLCJ79aq8/0P0C4g3G0HE5/THrq5pKgCFxs0RWi/39vvEqTz0kGtMV8KMo0/qkcGBONab9kuXgTf9Uvr6Ky0Diab/maOHktPFd40j0xvQUVD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607687; c=relaxed/simple;
	bh=L4MT07is5lU0vHYQ3f1HA7iVPk9ohj5bQRZckksiYPw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jcxeGvliY1D2B8Tod6BRTk5FlFtpL0QxAK+uLrVbSdTyRKU2sE/C4ODrg0r1rJpo33OEHzemf94AdNV2Xfy2RvJZsw3Tw9cHb/6gFMuxe9lvKn1d+hAweF2dNP033d7Hj0ECeoB/UN5HhnBlZgvzNPC7g6m0r6DcyBDwbQUuodw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVXs7Aj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVXs7Aj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FDEC4CEC5;
	Fri, 11 Oct 2024 00:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607687;
	bh=L4MT07is5lU0vHYQ3f1HA7iVPk9ohj5bQRZckksiYPw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QVXs7Aj+fBNW0iC2Belztl6qjbq13ZJclXY1DrZnjnJO20t0V+XxKGbPW5WN82DIy
	 r+eXTxYhOHTmrMFezvmf5c3HW/EA1fV4dRAKvPr3jXZCwLcG9Yg9zV99n7xsT3HhAU
	 EtMNLr6cXTvBs1H2obr9Q3E5mb41eSK11rKF6ardB2anFMV7K6sXsZ1kP17leCVhGR
	 prBeoDr/8aVqwSOcimbRP/EY6Uc4nGZqBWIpu4eUJ2kFFxCNNN5B9rpFzjAHvptIRo
	 B2qsljkbM2fqNgAD4pL2jGauD/B+MG1myQ9A8NyZLs1EwIobG6zIt/bsS6GjHEJqrf
	 OvPXWUq3+ShOg==
Date: Thu, 10 Oct 2024 17:48:07 -0700
Subject: [PATCH 15/16] xfs: remove xfs_group_intent_hold and
 xfs_group_intent_rele
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641525.4176300.529169402041656435.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
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

Each of them just has a single caller, so fold them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_drain.c |   36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 3d234016c53547..b84109bf7cad51 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -94,31 +94,11 @@ static inline int xfs_defer_drain_wait(struct xfs_defer_drain *dr)
 }
 
 /*
- * Declare an intent to update group metadata.  Other threads that need
- * exclusive access can decide to back off if they see declared intentions.
- */
-static void
-xfs_group_intent_hold(
-	struct xfs_group	*xg)
-{
-	trace_xfs_group_intent_hold(xg, __return_address);
-	xfs_defer_drain_grab(&xg->xg_intents_drain);
-}
-
-/*
- * Release our intent to update this groups metadata.
- */
-static void
-xfs_group_intent_rele(
-	struct xfs_group	*xg)
-{
-	trace_xfs_group_intent_rele(xg, __return_address);
-	xfs_defer_drain_rele(&xg->xg_intents_drain);
-}
-
-/*
- * Get a passive reference to the AG that contains a fsbno and declare an intent
- * to update its metadata.
+ * Get a passive reference to the AG that contains a fsbno and declare an
+ * intent to update its metadata.
+ *
+ * Other threads that need exclusive access can decide to back off if they see
+ * declared intentions.
  */
 struct xfs_perag *
 xfs_perag_intent_get(
@@ -131,7 +111,8 @@ xfs_perag_intent_get(
 	if (!pag)
 		return NULL;
 
-	xfs_group_intent_hold(&pag->pag_group);
+	trace_xfs_group_intent_hold(&pag->pag_group, __return_address);
+	xfs_defer_drain_grab(&pag->pag_group.xg_intents_drain);
 	return pag;
 }
 
@@ -143,7 +124,8 @@ void
 xfs_perag_intent_put(
 	struct xfs_perag	*pag)
 {
-	xfs_group_intent_rele(&pag->pag_group);
+	trace_xfs_group_intent_rele(&pag->pag_group, __return_address);
+	xfs_defer_drain_rele(&pag->pag_group.xg_intents_drain);
 	xfs_perag_put(pag);
 }
 

