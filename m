Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72671FC7E9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191172; cv=none; b=GJzTtkqVgk8qao50uqqNM96pr3Ma8dxWfKuXPiUs7uPScCS4JE8Fs2Bxx3NtphzSw1xhT8mrrjaBjzSnTMBaDIOzEKW/V3HRAU7rMGEObT1sfqDP96SvwuYxQcqIMttYBi2pfVh5yHxakXCjd/j5pQcEmbRvpmcNZe3IifJq1Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191172; c=relaxed/simple;
	bh=odVXwCply6rMC7ianLYecw+et/woILpCNx64HsRIUKE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQMOwcGEXRp15i60MMFyld0aeMos6ItTRcoEhsnvj5B+c+QJJgfvXOErOwTOIxWzV8ku9EHdvUMzChqpz42fRWVi1JtA1eBfRX5vPAtRnA5tjDOvun4LdQNQa1IqiUlw35ps70PDM9LaeyZO6qP0tPYHPNeva4n7reZK64Wd6mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vc5Cr1gX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vc5Cr1gX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B03EC4CECD;
	Thu, 17 Oct 2024 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191172;
	bh=odVXwCply6rMC7ianLYecw+et/woILpCNx64HsRIUKE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vc5Cr1gXAGAm6LPJfpSBWGU8ofX2jcNsTrZd9cjQ7BNvbA6l2OK70vTxNwKhJw4ku
	 56jWle1ATEmwalghXYeTeeBeKIINGFlzDycRwIWxNcMArRMWmJee0sKxv4LYdtHTtC
	 vXrK40q+4f+PafRTYbScAgPA2RMfh9TIvc1C4r+gT1O3v6sHZZli0fqf++Y72mghbS
	 35Xkfw/RI01yf+k0iK6xcoyl0PR7v3LVOlJKe7NDrokW+zMx3BGw6ojfFnIhibNmy+
	 rr2is7EK/zrhUOV0l4zzDTgVPRMi3WjhCzq2s6OHk6hyzIR84hsDJldZbc/mMKxS9t
	 rR/yjMTlesFMg==
Date: Thu, 17 Oct 2024 11:52:52 -0700
Subject: [PATCH 06/16] xfs: mark xfs_perag_intent_{hold,rele} static
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068778.3450737.11065999801913453722.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

These two functions are only used inside of xfs_drain.c, so mark them
static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_drain.c |   42 +++++++++++++++++++++---------------------
 fs/xfs/xfs_drain.h |    6 ------
 2 files changed, 21 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 7bdb9688c0f5e3..3f280971b498b8 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -93,6 +93,27 @@ static inline int xfs_defer_drain_wait(struct xfs_defer_drain *dr)
 	return wait_event_killable(dr->dr_waiters, !xfs_defer_drain_busy(dr));
 }
 
+/*
+ * Declare an intent to update AG metadata.  Other threads that need exclusive
+ * access can decide to back off if they see declared intentions.
+ */
+static void
+xfs_perag_intent_hold(
+	struct xfs_perag	*pag)
+{
+	trace_xfs_perag_intent_hold(pag, __return_address);
+	xfs_defer_drain_grab(&pag->pag_intents_drain);
+}
+
+/* Release our intent to update this AG's metadata. */
+static void
+xfs_perag_intent_rele(
+	struct xfs_perag	*pag)
+{
+	trace_xfs_perag_intent_rele(pag, __return_address);
+	xfs_defer_drain_rele(&pag->pag_intents_drain);
+}
+
 /*
  * Get a passive reference to the AG that contains a fsbno and declare an intent
  * to update its metadata.
@@ -124,27 +145,6 @@ xfs_perag_intent_put(
 	xfs_perag_put(pag);
 }
 
-/*
- * Declare an intent to update AG metadata.  Other threads that need exclusive
- * access can decide to back off if they see declared intentions.
- */
-void
-xfs_perag_intent_hold(
-	struct xfs_perag	*pag)
-{
-	trace_xfs_perag_intent_hold(pag, __return_address);
-	xfs_defer_drain_grab(&pag->pag_intents_drain);
-}
-
-/* Release our intent to update this AG's metadata. */
-void
-xfs_perag_intent_rele(
-	struct xfs_perag	*pag)
-{
-	trace_xfs_perag_intent_rele(pag, __return_address);
-	xfs_defer_drain_rele(&pag->pag_intents_drain);
-}
-
 /*
  * Wait for the intent update count for this AG to hit zero.
  * Callers must not hold any AG header buffers.
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
index 775164f54ea6de..f39c90946ab71f 100644
--- a/fs/xfs/xfs_drain.h
+++ b/fs/xfs/xfs_drain.h
@@ -65,9 +65,6 @@ struct xfs_perag *xfs_perag_intent_get(struct xfs_mount *mp,
 		xfs_fsblock_t fsbno);
 void xfs_perag_intent_put(struct xfs_perag *pag);
 
-void xfs_perag_intent_hold(struct xfs_perag *pag);
-void xfs_perag_intent_rele(struct xfs_perag *pag);
-
 int xfs_perag_intent_drain(struct xfs_perag *pag);
 bool xfs_perag_intent_busy(struct xfs_perag *pag);
 #else
@@ -80,9 +77,6 @@ struct xfs_defer_drain { /* empty */ };
 	xfs_perag_get((mp), XFS_FSB_TO_AGNO(mp, fsbno))
 #define xfs_perag_intent_put(pag)		xfs_perag_put(pag)
 
-static inline void xfs_perag_intent_hold(struct xfs_perag *pag) { }
-static inline void xfs_perag_intent_rele(struct xfs_perag *pag) { }
-
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 
 #endif /* XFS_DRAIN_H_ */

