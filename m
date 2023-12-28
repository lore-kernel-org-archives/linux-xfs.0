Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B564426
	for <linux-xfs@vger.kernel.org>; Thu, 28 Dec 2023 06:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QrQWA8ee"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=yThukTKJ/Zuz6ZYmX17KHaF/1DkpuOUrq9FkXCUAf/k=; b=QrQWA8ee9RPf8kxeJw9Xo6QsyX
	fX9xDd0F1qFzynv0REfSvCe2Xc7ltSXGwbjofRHvsoTvyB/igEiWit7pRSyCERBDEmnDz76a9YsDq
	QNvLNNne7SJFBEhcWTk/Z+9/7MDZJ3P5WH3lqFr+mqwBulL4Sz9YbOQ1B/reB03fNYKiBNgu1q0TJ
	hqTycyDeVaukWkVHGzpjbU2VsGq+HlAtM4Q956hnZCyIeopDWfx0usqwvNNOQfY3gr+AJNTw+tURX
	09qfuWtQmURBcBHC8rpIx4En9LrkL+GZoySlqiqpB3Lq/MQQ9LPb9Djk4XxqmwCXBr2KNNonkgaZ4
	zREZ+RZw==;
Received: from 128.red-83-57-75.dynamicip.rima-tde.net ([83.57.75.128] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIjiq-00GDhr-06;
	Thu, 28 Dec 2023 06:18:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: use the op name in trace_xlog_intent_recovery_failed
Date: Thu, 28 Dec 2023 06:18:21 +0000
Message-Id: <20231228061821.337263-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Instead of tracing the address of the recovery handler, use the name
in the defer op, similar to other defer ops related tracepoints.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c |  3 +--
 fs/xfs/xfs_trace.h        | 14 ++++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 785c92d2acaa73..e99d7890e614e1 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -920,8 +920,7 @@ xfs_defer_finish_recovery(
 
 	error = ops->recover_work(dfp, capture_list);
 	if (error)
-		trace_xlog_intent_recovery_failed(mp, error,
-				ops->recover_work);
+		trace_xlog_intent_recovery_failed(mp, ops, error);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0efcdb79d10e51..a986c52ff466bc 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -145,21 +145,23 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
 
 TRACE_EVENT(xlog_intent_recovery_failed,
-	TP_PROTO(struct xfs_mount *mp, int error, void *function),
-	TP_ARGS(mp, error, function),
+	TP_PROTO(struct xfs_mount *mp, const struct xfs_defer_op_type *ops,
+		 int error),
+	TP_ARGS(mp, ops, error),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__string(name, ops->name)
 		__field(int, error)
-		__field(void *, function)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
+		__assign_str(name, ops->name);
 		__entry->error = error;
-		__entry->function = function;
 	),
-	TP_printk("dev %d:%d error %d function %pS",
+	TP_printk("dev %d:%d optype %s error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->error, __entry->function)
+		  __get_str(name),
+		  __entry->error)
 );
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
-- 
2.39.2

