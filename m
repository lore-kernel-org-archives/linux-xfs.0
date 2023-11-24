Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C082C86B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NY2o3J9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456ECC433C8;
	Fri, 24 Nov 2023 23:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869630;
	bh=HBA1eE8bA/NoEg+9WJLCkOf30isw2J/hGcyDoU/rfF0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NY2o3J9nLLqVVcJBbcPWQxd+b3Wzuiq4ej+/0n6+e+BxOIiWf9Z72aS3H+18pXqU+
	 Oq/AjCaBEHLhnivMV3K8QnMdPRyKwcog9ME9bIHcwnTmu5/oyFbNjbyoVFUdqFSEJD
	 c2fcTTpj+UbSYSSfH4QLNU35srThIfzWVisDNpYMBoxg5gogbOYzSbhYyNAUhPTUEo
	 eFK8HCj+9QtiWcE+zWReIg9bOGF2+wqfFME1Psvx+yNvo2nJC/k9iEfZ9XSriDDAGV
	 lLi/pqZu/Mu7sHzgrVcZIWukdH0q7qmBcztJjdxwXfeVcOdZ8yYVyvivHJYztH6J5T
	 3f172J+ESu5jg==
Date: Fri, 24 Nov 2023 15:47:09 -0800
Subject: [PATCH 1/7] xfs: don't append work items to logged xfs_defer_pending
 objects
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086926145.2768790.15414309437495285174.stgit@frogsfrogsfrogs>
In-Reply-To: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When someone tries to add a deferred work item to xfs_defer_add, it will
try to attach the work item to the most recently added xfs_defer_pending
object attached to the transaction.  However, it doesn't check if the
pending object has a log intent item attached to it.  This is incorrect
behavior because we cannot add more work to an object that has already
been committed to the ondisk log.

Therefore, change the behavior not to append to pending items with a non
null dfp_intent.  In practice this has not been an issue because the
only way xfs_defer_add gets called after log intent items have been
committed is from the defer ops ->finish_item functions themselves, and
the @dop_pending isolation in xfs_defer_finish_noroll protects the
pending items that have already been logged.

However, the next patch will add the ability to pause a deferred extent
free object during online btree rebuilding, and any new extfree work
items need to have their own pending event.

While we're at it, hoist the predicate to its own static inline function
for readability.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c |   48 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index f71679ce23b95..6c283b30ea054 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -624,6 +624,40 @@ xfs_defer_cancel(
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
+/*
+ * Decide if we can add a deferred work item to the last dfops item attached
+ * to the transaction.
+ */
+static inline struct xfs_defer_pending *
+xfs_defer_try_append(
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
+
+	/* Already logged? */
+	if (dfp->dfp_intent)
+		return NULL;
+
+	/* Already full? */
+	if (ops->max_items && dfp->dfp_count >= ops->max_items)
+		return NULL;
+
+	return dfp;
+}
+
 /* Add an item for later deferred processing. */
 void
 xfs_defer_add(
@@ -637,19 +671,9 @@ xfs_defer_add(
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
+	dfp = xfs_defer_try_append(tp, type, ops);
 	if (!dfp) {
+		/* Create a new pending item at the end of the intake list. */
 		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 				GFP_NOFS | __GFP_NOFAIL);
 		dfp->dfp_type = type;

