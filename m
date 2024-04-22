Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D54153BC1
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803972; cv=none; b=paDIAIuiT1Z5PHBUZ9eh7kFIziBIk6cLWEb1yU/YEgJsfwUMyk4fv5lWWR5MxNhTWnrboL01GcJ6LUZEFbmtmVGz3cR+9+IqmPw7s/co00UO5FO/aLhGXA4dlcW/QgUzlLJF3o6SOd0FpDYJ37cB2uzPQLY4Eue21uIneAaHgAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803972; c=relaxed/simple;
	bh=0PdgUgl89r6jvvmF9cdoUhVzmZCeluXFWjgFeNVrlYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2j5WRkqc/IA0gcM+a2Q2CZy6UBhj1ho2QmHQX5NsZp4kkxtY2CAMW91bbmganLcgJDNqOq6HcrymGYuw0KADkQz8wZgGegUKBAcwUX4AiiSQhphiUxqN4/nc7bfSUhK5z5+1eVu2HY5h6viU2+PUBwbqDQF2+dRFyjEtjvnmFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NefK33q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NefK33q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E239BC113CC;
	Mon, 22 Apr 2024 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803970;
	bh=0PdgUgl89r6jvvmF9cdoUhVzmZCeluXFWjgFeNVrlYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NefK33q17/fO3Y1MWqrqzT9t7fxkw477CfdUmuCvsnwq2G3fqk9/p3zwtgiuCtW8r
	 N51ga/1ki5lSpnkLiUIs/I++nel2hHXtF3puhOzzn22txMwGJhwuz33mkLDV8V/py+
	 ltaYfkzD+yvbriTVweA1MHZYVw+kUEKCFV3qsI48nKKE9hHeV1TxSOo5lpQYIQwWeH
	 tI13ivB6Zg6V9kYj6NZCTZW6RGlxtPKOOFLkzZWRc3TBWyLEEHOZU3dRZI49lpR8mB
	 gZE/ES1Ivy5uylKOThe2evlRN7fp81FN8DlziZbSmQefH41eDwjwWNfSmHonHIo0kl
	 FtW7Heo9jNoLA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 15/67] xfs: don't append work items to logged xfs_defer_pending objects
Date: Mon, 22 Apr 2024 18:25:37 +0200
Message-ID: <20240422163832.858420-17-cem@kernel.org>
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

Source kernel commit: 6b126139401a2284402d7c38fe3168d5a26da41d

When someone tries to add a deferred work item to xfs_defer_add, it will
try to attach the work item to the most recently added xfs_defer_pending
object attached to the transaction.  However, it doesn't check if the
pending object has a log intent item attached to it.  This is incorrect
behavior because we cannot add more work to an object that has already
been committed to the ondisk log.

Therefore, change the behavior not to append to pending items with a non
null dfp_intent.  In practice this has not been an issue because the
only way xfs_defer_add gets called after log intent items have been
the @dop_pending isolation in xfs_defer_finish_noroll protects the
pending items that have already been logged.

However, the next patch will add the ability to pause a deferred extent
free object during online btree rebuilding, and any new extfree work
items need to have their own pending event.

While we're at it, hoist the predicate to its own static inline function
for readability.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 61 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 722ff6a77..200d1b300 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -689,6 +689,51 @@ xfs_defer_cancel(
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
+/*
+ * Return the last pending work item attached to this transaction if it matches
+ * the deferred op type.
+ */
+static inline struct xfs_defer_pending *
+xfs_defer_find_last(
+	struct xfs_trans		*tp,
+	enum xfs_defer_ops_type		type,
+	const struct xfs_defer_op_type	*ops)
+{
+	struct xfs_defer_pending	*dfp = NULL;
+
+	/* No dfops at all? */
+	if (list_empty(&tp->t_dfops))
+		return NULL;
+
+	dfp = list_last_entry(&tp->t_dfops, struct xfs_defer_pending,
+			dfp_list);
+
+	/* Wrong type? */
+	if (dfp->dfp_type != type)
+		return NULL;
+	return dfp;
+}
+
+/*
+ * Decide if we can add a deferred work item to the last dfops item attached
+ * to the transaction.
+ */
+static inline bool
+xfs_defer_can_append(
+	struct xfs_defer_pending	*dfp,
+	const struct xfs_defer_op_type	*ops)
+{
+	/* Already logged? */
+	if (dfp->dfp_intent)
+		return false;
+
+	/* Already full? */
+	if (ops->max_items && dfp->dfp_count >= ops->max_items)
+		return false;
+
+	return true;
+}
+
 /* Add an item for later deferred processing. */
 void
 xfs_defer_add(
@@ -702,19 +747,9 @@ xfs_defer_add(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
-	/*
-	 * Add the item to a pending item at the end of the intake list.
-	 * If the last pending item has the same type, reuse it.  Else,
-	 * create a new pending item at the end of the intake list.
-	 */
-	if (!list_empty(&tp->t_dfops)) {
-		dfp = list_last_entry(&tp->t_dfops,
-				struct xfs_defer_pending, dfp_list);
-		if (dfp->dfp_type != type ||
-		    (ops->max_items && dfp->dfp_count >= ops->max_items))
-			dfp = NULL;
-	}
-	if (!dfp) {
+	dfp = xfs_defer_find_last(tp, type, ops);
+	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
+		/* Create a new pending item at the end of the intake list. */
 		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 				GFP_NOFS | __GFP_NOFAIL);
 		dfp->dfp_type = type;
-- 
2.44.0

