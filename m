Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5FED47F52
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D1358F8068
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id BYAf2SJ9leBbMQnL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcH-0000Mo-QF
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:01 +0000
Message-Id: <20131129084001.650006317@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/10] xfs: remove the dquot log format from the dquot log item
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0009-xfs-remove-the-dquot-log-format-from-the-dquot-log-i.patch
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

No need to keep the dquot log format around all the time, we can easily
generate it at iop_format time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot_item.c |   25 +++++++++----------------
 fs/xfs/xfs_dquot_item.h |    1 -
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 946d588..d4fffa9 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -61,12 +61,17 @@ xfs_qm_dquot_logitem_format(
 {
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 	struct xfs_log_iovec	*vecp = NULL;
+	struct xfs_dq_logformat	*qlf;
 
-	qlip->qli_format.qlf_size = 2;
+	qlf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_QFORMAT);
+	qlf->qlf_type = XFS_LI_DQUOT;
+	qlf->qlf_size = 2;
+	qlf->qlf_id = be32_to_cpu(qlip->qli_dquot->q_core.d_id);
+	qlf->qlf_blkno = qlip->qli_dquot->q_blkno;
+	qlf->qlf_len = 1;
+	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
+	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_dq_logformat));
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_QFORMAT,
-			&qlip->qli_format,
-			sizeof(struct xfs_dq_logformat));
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT,
 			&qlip->qli_dquot->q_core,
 			sizeof(struct xfs_disk_dquot));
@@ -256,18 +261,6 @@ xfs_qm_dquot_logitem_init(
 	xfs_log_item_init(dqp->q_mount, &lp->qli_item, XFS_LI_DQUOT,
 					&xfs_dquot_item_ops);
 	lp->qli_dquot = dqp;
-	lp->qli_format.qlf_type = XFS_LI_DQUOT;
-	lp->qli_format.qlf_id = be32_to_cpu(dqp->q_core.d_id);
-	lp->qli_format.qlf_blkno = dqp->q_blkno;
-	lp->qli_format.qlf_len = 1;
-	/*
-	 * This is just the offset of this dquot within its buffer
-	 * (which is currently 1 FSB and probably won't change).
-	 * Hence 32 bits for this offset should be just fine.
-	 * Alternatively, we can store (bufoffset / sizeof(xfs_dqblk_t))
-	 * here, and recompute it at recovery time.
-	 */
-	lp->qli_format.qlf_boffset = (__uint32_t)dqp->q_bufoffset;
 }
 
 /*------------------  QUOTAOFF LOG ITEMS  -------------------*/
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 5acae2a..925cbe9 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -27,7 +27,6 @@ typedef struct xfs_dq_logitem {
 	xfs_log_item_t		 qli_item;	   /* common portion */
 	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
 	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
-	xfs_dq_logformat_t	 qli_format;	   /* logged structure */
 } xfs_dq_logitem_t;
 
 typedef struct xfs_qoff_logitem {
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
