Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RvEZ6Wbo"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C86DAB
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 01:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MJgHxAq5FyMJhCso7eMDbhMqGHPrsotpM8diySUqn7o=; b=RvEZ6WboC02lGdZFM4TpDh5T74
	ksuebrQl9V+7hFojSZP+Lpor8rRbMC011xCHq3YKsuqWBA4350VsoRGh32AyccUURE+lTBL8Pv/df
	V2vzzSb3TcTA2Suy3198NthpeFoNZ3UmWeC4yDvRcfzkVPwtpsmq6OMdcnepYWg1Nu/MPgDxUJl8m
	7SOZnV/Chsb1FxjPW0rx4o/WEI4aYDveQ3ZDdpeGwmgAIw+VtcwzKuwEFrauaLjMUUhra9DKzJSmH
	CDuNtm8JJo7IomgBc7S2SRCoCPBsVTn2f/M/lOAj+ujnLnNki01cabz4yLJO4BhJ1dH+FDT4lgJHl
	EYC93cjQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDLCS-00E6d7-0e;
	Wed, 13 Dec 2023 09:06:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 1/5] xfs: consolidate the xfs_attr_defer_* helpers
Date: Wed, 13 Dec 2023 10:06:29 +0100
Message-Id: <20231213090633.231707-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231213090633.231707-1-hch@lst.de>
References: <20231213090633.231707-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Consolidate the xfs_attr_defer_* helpers into a single xfs_attr_defer_add
one that picks the right dela_state based on the passed in operation.
Also move to a single trace point as the actual operation is visible
through the flags in the delta_state passed to the trace point.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 90 ++++++++++------------------------------
 fs/xfs/xfs_trace.h       |  2 -
 2 files changed, 21 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de49..4fed0c87a968ab 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -880,11 +880,10 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
-xfs_attr_intent_init(
+static void
+xfs_attr_defer_add(
 	struct xfs_da_args	*args,
-	unsigned int		op_flags,	/* op flag (set or remove) */
-	struct xfs_attr_intent	**attr)		/* new xfs_attr_intent */
+	unsigned int		op_flags)
 {
 
 	struct xfs_attr_intent	*new;
@@ -893,66 +892,22 @@ xfs_attr_intent_init(
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
 
-	*attr = new;
-	return 0;
-}
-
-/* Sets an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_add(
-	struct xfs_da_args	*args)
-{
-	struct xfs_attr_intent	*new;
-	int			error = 0;
-
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
-	if (error)
-		return error;
+	switch (op_flags) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		new->xattri_dela_state = xfs_attr_init_remove_state(args);
+		break;
+	default:
+		ASSERT(0);
+	}
 
-	new->xattri_dela_state = xfs_attr_init_add_state(args);
 	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
-
-	return 0;
-}
-
-/* Sets an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_replace(
-	struct xfs_da_args	*args)
-{
-	struct xfs_attr_intent	*new;
-	int			error = 0;
-
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
-	if (error)
-		return error;
-
-	new->xattri_dela_state = xfs_attr_init_replace_state(args);
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
-	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
-
-	return 0;
-}
-
-/* Removes an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_remove(
-	struct xfs_da_args	*args)
-{
-
-	struct xfs_attr_intent	*new;
-	int			error;
-
-	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
-	if (error)
-		return error;
-
-	new->xattri_dela_state = xfs_attr_init_remove_state(args);
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
-	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
-
-	return 0;
 }
 
 /*
@@ -1038,16 +993,16 @@ xfs_attr_set(
 	error = xfs_attr_lookup(args);
 	switch (error) {
 	case -EEXIST:
-		/* if no value, we are performing a remove operation */
 		if (!args->value) {
-			error = xfs_attr_defer_remove(args);
+			/* if no value, we are performing a remove operation */
+			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
 			break;
 		}
+
 		/* Pure create fails if the attr already exists */
 		if (args->attr_flags & XATTR_CREATE)
 			goto out_trans_cancel;
-
-		error = xfs_attr_defer_replace(args);
+		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
@@ -1057,14 +1012,11 @@ xfs_attr_set(
 		/* Pure replace fails if no existing attr to replace. */
 		if (args->attr_flags & XATTR_REPLACE)
 			goto out_trans_cancel;
-
-		error = xfs_attr_defer_add(args);
+		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
 		break;
 	default:
 		goto out_trans_cancel;
 	}
-	if (error)
-		goto out_trans_cancel;
 
 	/*
 	 * If this is a synchronous mount, make sure that the
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 514095b6ba2bdb..516529c151ae1c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4408,8 +4408,6 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_alloc);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
-DEFINE_DAS_STATE_EVENT(xfs_attr_defer_replace);
-DEFINE_DAS_STATE_EVENT(xfs_attr_defer_remove);
 
 
 TRACE_EVENT(xfs_force_shutdown,
-- 
2.39.2

