Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C915381C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803954; cv=none; b=JtYo8LCFwRuSAEpClB0Dney9SWI+uIN87TKa2/Iwh0Rwj7V+FSDOdwZ1i0Elq/4BRGvY8qyXD8x/rM/oRNenhKJeV78udmkZilsGIoLAgbyQTvcoSINu10v2ukoF5wOtbLi+u+6Zp2A2A9kDuOjf9sjagWbaPK3A8jpYS2imZm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803954; c=relaxed/simple;
	bh=u3TZZTy0oaeA8NEEOdJrtE4yIYbcKdNv3fLD3k+f/lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/rU0TSH9sVUjFO0aQR1MPmyhLPTglRbjpX5JBmnxm5NP+jHExppHXs6OgTQsaggMhLeSnMAc/UtpGEyCO6l3+RJsJNalDX11D7nAmXpwhcdaGfMwW/uDk+TgPhMSR4Ft5N+qaXiLq6vlZMfsCn1Hn+OBE2nn0OaJfblXz5Q1uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mzem7R8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mzem7R8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20469C116B1;
	Mon, 22 Apr 2024 16:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803954;
	bh=u3TZZTy0oaeA8NEEOdJrtE4yIYbcKdNv3fLD3k+f/lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mzem7R8nKpoOM4OL8yRjOedoUau54z7yB6MNQffE9FRWyjPSIQ9xByG4rm2eeCTGl
	 1M++1oUfCXBKQt54ZwEs6oXh71kmiS3mT4zbuitsJguA5tcgFv2B/Ylf0Q772pROx4
	 rF6qSncJE9WftRR4jPKkbnicvbkES4zjZNqKUg2YSaexPwrLego1zFPwjqluaGfKqN
	 kK4rZ7RRYLmoUViCMsx+QBPEtzI2AONoz1bbZFlBiRAEMcBPerdFUCsaLkXpf5IyN0
	 5MMs/w4PAVG7uH9hkYVGb+2rSL7RFJnTD4OYvQjmpP2vl+HupEymHJr+/v4j7/A8Rm
	 FE4UxbF8lLJaQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 04/67] xfs: move ->iop_recover to xfs_defer_op_type
Date: Mon, 22 Apr 2024 18:25:26 +0200
Message-ID: <20240422163832.858420-6-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: db7ccc0bac2add5a41b66578e376b49328fc99d0

Finish off the series by moving the intent item recovery function
pointer to the xfs_defer_op_type struct, since this is really a deferred
work function now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/xfs_trace.h |  2 ++
 libxfs/xfs_defer.c  | 17 +++++++++++++++++
 libxfs/xfs_defer.h  |  4 ++++
 3 files changed, 23 insertions(+)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 7fd446ad4..c79a4bd74 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -336,4 +336,6 @@
 
 #define trace_xfs_fs_mark_healthy(a,b)		((void) 0)
 
+#define trace_xlog_intent_recovery_failed(...)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4ef9867cc..54865b73b 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -708,6 +708,23 @@ xfs_defer_cancel_recovery(
 	xfs_defer_pending_cancel_work(mp, dfp);
 }
 
+/* Replay the deferred work item created from a recovered log intent item. */
+int
+xfs_defer_finish_recovery(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	int				error;
+
+	error = ops->recover_work(dfp, capture_list);
+	if (error)
+		trace_xlog_intent_recovery_failed(mp, error,
+				ops->recover_work);
+	return error;
+}
+
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index c1a648e99..ef86a7f9b 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -57,6 +57,8 @@ struct xfs_defer_op_type {
 	void (*finish_cleanup)(struct xfs_trans *tp,
 			struct xfs_btree_cur *state, int error);
 	void (*cancel_item)(struct list_head *item);
+	int (*recover_work)(struct xfs_defer_pending *dfp,
+			    struct list_head *capture_list);
 	unsigned int		max_items;
 };
 
@@ -130,6 +132,8 @@ void xfs_defer_start_recovery(struct xfs_log_item *lip,
 		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
 void xfs_defer_cancel_recovery(struct xfs_mount *mp,
 		struct xfs_defer_pending *dfp);
+int xfs_defer_finish_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp, struct list_head *capture_list);
 
 static inline void
 xfs_defer_add_item(
-- 
2.44.0

