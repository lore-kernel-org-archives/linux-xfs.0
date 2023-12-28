Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98E663B1
	for <linux-xfs@vger.kernel.org>; Thu, 28 Dec 2023 07:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cVsGUbGE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yx+571wiRf4XPK35tNQV8nJDTiL6Nyab43vpDyix8Hs=; b=cVsGUbGE81G2zEF4KrPlA298n6
	MEfmrUZMVz381a0pf/MGzTRH+c0c8qy9iheOJnd+9bCgioNeAVYlb47ro0SbynakXKjuvscBvN4kj
	87+Okk2tuf7vt+1xg7XSX3D2TOFF294lZNCJDy6kHe26EKmTIZmcXSYk5rCeztI5O+eB+lGlGQDRw
	6N6bHW361/SLUTpked56N0xvvt8z64HUVZaTOhoY/ejwNUcdKGqIokvkk+Q3Uqrs77Lhav0IVu7Z2
	zT7+wmRuaBsxed5e0gUKWqlWKiu+64cDhuYhhh1TY7n8yPVbTWwQ+r/Bh6ibyQjxyhHdU6NdkLBXM
	g3FTjqoA==;
Received: from 128.red-83-57-75.dynamicip.rima-tde.net ([83.57.75.128] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIkkb-00GKjJ-02;
	Thu, 28 Dec 2023 07:24:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: use the op name in trace_xlog_intent_recovery_failed
Date: Thu, 28 Dec 2023 07:24:10 +0000
Message-Id: <20231228072410.359908-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231228072410.359908-1-hch@lst.de>
References: <20231228072410.359908-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |  3 +--
 fs/xfs/xfs_trace.h        | 15 +++++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 75c5b3a2c2cba4..66a17910d02194 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -921,8 +921,7 @@ xfs_defer_finish_recovery(
 	/* dfp is freed by recover_work and must not be accessed afterwards */
 	error = ops->recover_work(dfp, capture_list);
 	if (error)
-		trace_xlog_intent_recovery_failed(mp, error,
-				ops->recover_work);
+		trace_xlog_intent_recovery_failed(mp, ops, error);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0efcdb79d10e51..0984a1c884c742 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -67,6 +67,7 @@ struct xfs_buf_log_format;
 struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
 struct xfs_btree_cur;
+struct xfs_defer_op_type;
 struct xfs_refcount_irec;
 struct xfs_fsmap;
 struct xfs_rmap_irec;
@@ -145,21 +146,23 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
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

