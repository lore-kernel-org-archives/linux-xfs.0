Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC15912BF3D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998989; cv=none; b=Qi9rrNUKrPHKVAi6LKS/4PnLiZANpZSIC0MobglvnZUSEHZP5CzBDNVd9iykl/t61lpxV/NHzkDwg1HO/fnb4t1rVPqp8uta2eoKGDIvKpZS7JQUaO8dXAGUf8MEkcp6gD86HnRe3yq1iZqFlQUY1UwKgyrSAQUeSmnp9YYvAh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998989; c=relaxed/simple;
	bh=upNxpAC6a9CxfIzP/Focb5P46yMPD/5h1nRmmHgCHfk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFSTnIpQ5oG97CY/fHte6HuaYVho+VGuxp1SQS0sPfEmGH0dQ/3H5AdkHilShEG8wnDAWRblm7KxfJeroAuHDloan6UTMi6Nno8un7ng9Pcf+bqMU/FWp9+kS+2G3FHQLKpbCVX1YEJcyJwfOPy4UPIP8Zlb5Wnu2byHY1AjGT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZCiAowe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZCiAowe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1498FC433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998989;
	bh=upNxpAC6a9CxfIzP/Focb5P46yMPD/5h1nRmmHgCHfk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=tZCiAowedXOXg0zvd9trMOwpJsP+gahLsU6ID4PYWttCftReNy0Q1pH4KaCRmKtZq
	 kmftufPSzUg4HSyXUypcfjm05nexbxFdfI2OJInrANT+jhilM+Hc2WIvzO015hg/GC
	 ZzsDhxC1NBevlGHBAikrcDwF7Wtp4U+m4cqbXXYC0WenyCuGBXgkc0dL0HlBqxhqwE
	 sItvv6q8JvH0bwUM0Q2NHtHz8mTJpUrntVYDmVwNQZvM3VuLwWFzqYOODKdbEONCnj
	 mUgbn2QpVny/vWH0biICjImNH5ap4zeVAtwXW3MKxbGG+ozWA51xW2YUzfun9rRSed
	 o4Qn8AmDIe34w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 32/35] xfs: factor out xfs_defer_pending_abort
Date: Thu, 15 Feb 2024 13:08:44 +0100
Message-ID: <20240215120907.1542854-33-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: 2a5db859c6825b5d50377dda9c3cc729c20cad43

Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
not use transaction parameter, so it can be used after the transaction
life cycle.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 77a94f58f..16060ef88 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -240,21 +240,18 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-/* Abort all the intents that were committed. */
 STATIC void
-xfs_defer_trans_abort(
-	struct xfs_trans		*tp,
-	struct list_head		*dop_pending)
+xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
 	const struct xfs_defer_op_type	*ops;
 
-	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_pending, dfp_list) {
+	list_for_each_entry(dfp, dop_list, dfp_list) {
 		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
+		trace_xfs_defer_pending_abort(mp, dfp);
 		if (dfp->dfp_intent && !dfp->dfp_done) {
 			ops->abort_intent(dfp->dfp_intent);
 			dfp->dfp_intent = NULL;
@@ -262,6 +259,16 @@ xfs_defer_trans_abort(
 	}
 }
 
+/* Abort all the intents that were committed. */
+STATIC void
+xfs_defer_trans_abort(
+	struct xfs_trans		*tp,
+	struct list_head		*dop_pending)
+{
+	trace_xfs_defer_trans_abort(tp, _RET_IP_);
+	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+}
+
 /*
  * Capture resources that the caller said not to release ("held") when the
  * transaction commits.  Caller is responsible for zero-initializing @dres.
-- 
2.43.0

