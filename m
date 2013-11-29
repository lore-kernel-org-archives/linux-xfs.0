Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 252807F51
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BECF3AC002
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id trHgAUQ5m2QYxvfe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcI-0000QP-0Z
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:02 +0000
Message-Id: <20131129084001.876552429@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/10] xfs: remove the quotaoff log format from the quotaoff
	log item
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0010-xfs-remove-the-quotaoff-log-format-from-the-quotaoff.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This one doesn't save a whole lot of memory, but still makes the code
simpler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot_item.c |   22 +++++++---------------
 fs/xfs/xfs_dquot_item.h |    2 +-
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d4fffa9..f33fbaa 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -286,13 +286,6 @@ xfs_qm_qoff_logitem_size(
 	*nbytes += sizeof(struct xfs_qoff_logitem);
 }
 
-/*
- * This is called to fill in the vector of log iovecs for the
- * given quotaoff log item. We use only 1 iovec, and we point that
- * at the quotaoff_log_format structure embedded in the quotaoff item.
- * It is at this point that we assert that all of the extent
- * slots in the quotaoff item have been filled.
- */
 STATIC void
 xfs_qm_qoff_logitem_format(
 	struct xfs_log_item	*lip,
@@ -300,13 +293,13 @@ xfs_qm_qoff_logitem_format(
 {
 	struct xfs_qoff_logitem	*qflip = QOFF_ITEM(lip);
 	struct xfs_log_iovec	*vecp = NULL;
+	struct xfs_qoff_logformat *qlf;
 
-	ASSERT(qflip->qql_format.qf_type == XFS_LI_QUOTAOFF);
-	qflip->qql_format.qf_size = 1;
-
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_QUOTAOFF,
-			&qflip->qql_format,
-			sizeof(struct xfs_qoff_logitem));
+	qlf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_QUOTAOFF);
+	qlf->qf_type = XFS_LI_QUOTAOFF;
+	qlf->qf_size = 1;
+	qlf->qf_flags = qflip->qql_flags;
+	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_qoff_logitem));
 }
 
 /*
@@ -446,8 +439,7 @@ xfs_qm_qoff_logitem_init(
 	xfs_log_item_init(mp, &qf->qql_item, XFS_LI_QUOTAOFF, start ?
 			&xfs_qm_qoffend_logitem_ops : &xfs_qm_qoff_logitem_ops);
 	qf->qql_item.li_mountp = mp;
-	qf->qql_format.qf_type = XFS_LI_QUOTAOFF;
-	qf->qql_format.qf_flags = flags;
 	qf->qql_start_lip = start;
+	qf->qql_flags = flags;
 	return qf;
 }
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 925cbe9..502e946 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -32,7 +32,7 @@ typedef struct xfs_dq_logitem {
 typedef struct xfs_qoff_logitem {
 	xfs_log_item_t		 qql_item;	/* common portion */
 	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
-	xfs_qoff_logformat_t	 qql_format;	/* logged structure */
+	unsigned int		qql_flags;
 } xfs_qoff_logitem_t;
 
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
