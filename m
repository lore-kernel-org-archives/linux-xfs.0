Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jztmV9Z2"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE8CAB
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 01:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ywiE5TLJ+FVP+lk8Ck4FxcN6FHRObigzmelhxvQA2wk=; b=jztmV9Z220dZ4ke+uTN5KrNP+G
	qXduVwTnS8vhDI36jMsymcwJv4yEyLb9TlQhao/YcaTaTqSVmmukZQDH4gLAnsL59FoS+6koK5r9p
	+ygjZSzwluKP6kpW2agz/iqknjS8MXO/w+uEyOFrER1ae98KZlFLrVIQ5ZjjG012M2IcIaOtHkQWs
	US+uL3v+958FpwkEYBkgdXuedRtg0v03mgdvTcW58GrZxeIP06BeZh5VM7Q1I1WJZKrBq6KfYbWh/
	0WOQPESIrphBIM0vQR4rFvE+MUlinSLL8v6jb0libKe38g9wnaMdGscaLjReYo0Q7I4guDOgZNz4+
	ctgnDY0g==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDLCV-00E6dh-1D;
	Wed, 13 Dec 2023 09:06:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 2/5] xfs: move xfs_attr_defer_type up in xfs_attr_item.c
Date: Wed, 13 Dec 2023 10:06:30 +0100
Message-Id: <20231213090633.231707-3-hch@lst.de>
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

We'll reference it directly in xlog_recover_attri_commit_pass2, so move
it up a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c | 66 +++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 39f2c5a46179f7..4e0eaa2640e0d2 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -654,6 +654,39 @@ xfs_attr_relog_intent(
 	return &new_attrip->attri_item;
 }
 
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attrd_log_item	*attrdp;
+
+	attrip = ATTRI_ITEM(intent);
+
+	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
+
+	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrd_attrip = attrip;
+	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
+
+	return &attrdp->attrd_item;
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+	.recover_work	= xfs_attr_recover_work,
+	.relog_intent	= xfs_attr_relog_intent,
+};
+
 STATIC int
 xlog_recover_attri_commit_pass2(
 	struct xlog                     *log,
@@ -730,39 +763,6 @@ xlog_recover_attri_commit_pass2(
 	return 0;
 }
 
-/* Get an ATTRD so we can process all the attrs. */
-static struct xfs_log_item *
-xfs_attr_create_done(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*intent,
-	unsigned int			count)
-{
-	struct xfs_attri_log_item	*attrip;
-	struct xfs_attrd_log_item	*attrdp;
-
-	attrip = ATTRI_ITEM(intent);
-
-	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
-
-	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
-			  &xfs_attrd_item_ops);
-	attrdp->attrd_attrip = attrip;
-	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
-
-	return &attrdp->attrd_item;
-}
-
-const struct xfs_defer_op_type xfs_attr_defer_type = {
-	.max_items	= 1,
-	.create_intent	= xfs_attr_create_intent,
-	.abort_intent	= xfs_attr_abort_intent,
-	.create_done	= xfs_attr_create_done,
-	.finish_item	= xfs_attr_finish_item,
-	.cancel_item	= xfs_attr_cancel_item,
-	.recover_work	= xfs_attr_recover_work,
-	.relog_intent	= xfs_attr_relog_intent,
-};
-
 /*
  * This routine is called when an ATTRD format structure is found in a committed
  * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
-- 
2.39.2

