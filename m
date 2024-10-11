Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B1E33E7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607546; cv=none; b=K+wNU2aBFwcQazY09TgPDa4ppOVECaBUkENVhPYxjzTraF6jsryyb7Lso/0oslo/51m9aY3TOljaT+UuMhnF1bSFAuI7/+STQ3MWmw7GsqHfXjiGyoSXnMXaPkizEc+qesAtBlv5C+4WP3CCXn5Ctafm08JCEq3CUacHgmWgRQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607546; c=relaxed/simple;
	bh=odVXwCply6rMC7ianLYecw+et/woILpCNx64HsRIUKE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cg6WKMWTcsmb1CDk/i6Xpa2mzhdmW0QGoI2TOfUzLvitwnbaMFDgMbZZfMMBk3KCZAekCRm+KSIPp2edT1SiGiKJZzINkY9kKFRZqsxCsyfWCsMq6xrlVV1lawtUW62W7K41XEc475tBiwd2UzMFs3xsbFhg+cdyZ1vMTm25S5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEbAPgL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEbAPgL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99993C4CEC5;
	Fri, 11 Oct 2024 00:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607545;
	bh=odVXwCply6rMC7ianLYecw+et/woILpCNx64HsRIUKE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dEbAPgL98um/4cCJYWrW7LE7FWqW2/lAhE/Yj0U2w2z/MGUimR/ukYqYPjvacys7q
	 WHXhq38wmDOCVB60dSh8hlkIoEZfhgw7i5tPUEPtdssQ8x+18gjjJuy66xzSw5qBUI
	 scY+/h94BR5NDXlP2pHn7CA2obI8MRKtXQGq/YF4+eplipXEUk3Z9IHdgGdR0VaFut
	 hK+suypOHyEKJr3kjUyxjVw7btfg+P1tseMvT4JZOgRe2jhjuGILEs1cZFpMIfDLMT
	 D5DwdMzhwO+EWYebb2eZIWCpmoCqVeMsgNfwss97Kv/Fp/mC4LNkh4nzpFSWrtbyJ3
	 7fDliV630wXzw==
Date: Thu, 10 Oct 2024 17:45:45 -0700
Subject: [PATCH 06/16] xfs: mark xfs_perag_intent_{hold,rele} static
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641365.4176300.7718939742935533748.stgit@frogsfrogsfrogs>
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

