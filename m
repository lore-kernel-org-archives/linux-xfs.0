Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625F21E5022
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844983; cv=none; b=OJu8dK01JLJhcVq0JRyCjF7CplCNwb7h/lFLbil+62n3gwdT6VN5p3I5vauRKEqdyTNJiS4lkcWzF20zLb2TWgXN6dd5eliieC2HUUw+O4Mccp2SXpKil8b8xAZOFrVCocmNynIGEwiXcVDhH0Fqxu/YRz8/4pdEM1ossnDEbXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844983; c=relaxed/simple;
	bh=EDO4OYcQrMAaIyf2Y3ZlWO1EckiVk+A0KqU7Wd3e5Us=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W5dAI+lbsneAp+nOllDt45N1iYU8X2+0xYZP7mvssDDnOSQECZlJrvPT189TShkW2mPYnzTcwQxVkqcwLR6WC2xh3PjNQuc6TrQVwo8Hti12JGK7q7oATV0rQzJ5dnwSyiHBxxCCjKDJd08Y3NYxP5x5X+sBMqlwndVVxjm5VXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYrW0yak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYrW0yak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F97C4CECF;
	Tue,  5 Nov 2024 22:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844982;
	bh=EDO4OYcQrMAaIyf2Y3ZlWO1EckiVk+A0KqU7Wd3e5Us=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KYrW0yakeQLs5zFNtPwJxWZUL5OWVCsAbZZTtf8u1m8kNOhH3NuF54fzj8gwdepCX
	 NpVz/9PXHppWT2KlEpaME1WmOwG+fksdSiNdPxXWs5QJaw/rtZW1+5pMgrL7AGCjXI
	 Uo1T5cuYJewnoMaANEGNu+rVYWsDaV4JTgNmIwhWIuiih6e//WUWfzW5sqQr3beeLB
	 iYTfCKeKO/iU9D163bSXx5Dgw11oIse9pd+6mqaMBoHbu0zzcGu/7rA4vudV26Y3Uy
	 T3YhB/6Yp8e4NnZnH6nkXnwUcvSIjxc4STn55I6a6GJMmDDD9hLV7cTmGwaugCvDle
	 kloofHNyMakZw==
Date: Tue, 05 Nov 2024 14:16:22 -0800
Subject: [PATCH 15/16] xfs: remove xfs_group_intent_hold and
 xfs_group_intent_rele
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084395527.1869491.6553959744827461856.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
References: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
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
index a72d08947d6d10..7a728a04f7a6b1 100644
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
 
-	xfs_group_intent_hold(pag_group(pag));
+	trace_xfs_group_intent_hold(pag_group(pag), __return_address);
+	xfs_defer_drain_grab(pag_group(pag).xg_intents_drain);
 	return pag;
 }
 
@@ -143,7 +124,8 @@ void
 xfs_perag_intent_put(
 	struct xfs_perag	*pag)
 {
-	xfs_group_intent_rele(pag_group(pag));
+	trace_xfs_group_intent_rele(pag_group(pag), __return_address);
+	xfs_defer_drain_rele(pag_group(pag).xg_intents_drain);
 	xfs_perag_put(pag);
 }
 

