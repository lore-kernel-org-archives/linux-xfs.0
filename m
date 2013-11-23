Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DDE047F53
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 09:15:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CDD978F8039
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 07:15:35 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7bJIgTA6qRX6BlFu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 07:15:34 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkEvm-0001PQ-1k
	for xfs@oss.sgi.com; Sat, 23 Nov 2013 15:15:34 +0000
Message-Id: <20131123151533.956509245@bombadil.infradead.org>
Date: Sat, 23 Nov 2013 07:11:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: remove the dquot log format from the dquot log item
References: <20131123151151.716201348@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0003-xfs-remove-the-dquot-log-format-from-the-dquot-log-i.patch
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
 fs/xfs/xfs_dquot_item.c |   26 ++++++++++----------------
 fs/xfs/xfs_dquot_item.h |    1 -
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 5f446a7..2df55fe 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -60,15 +60,21 @@ xfs_qm_dquot_logitem_format(
 	struct xfs_log_vec	*lv)
 {
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
+	struct xfs_dq_logformat	*qlf;
 	struct xfs_log_iovec	*vec;
 
-	qlip->qli_format.qlf_size = 2;
-
 	vec = xlog_first_iovec(lv);
-	memcpy(vec->i_addr, &qlip->qli_format, sizeof(xfs_dq_logformat_t));
-	vec->i_len = sizeof(xfs_dq_logformat_t);
+	vec->i_len = sizeof(struct xfs_dq_logformat);
 	vec->i_type = XLOG_REG_TYPE_QFORMAT;
 
+	qlf = vec->i_addr;
+	qlf->qlf_type = XFS_LI_DQUOT;
+	qlf->qlf_size = 2;
+	qlf->qlf_id = be32_to_cpu(qlip->qli_dquot->q_core.d_id);
+	qlf->qlf_blkno = qlip->qli_dquot->q_blkno;
+	qlf->qlf_len = 1;
+	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
+
 	vec = xlog_next_iovec(lv, vec);
 	memcpy(vec->i_addr, &qlip->qli_dquot->q_core, sizeof(xfs_disk_dquot_t));
 	vec->i_len = sizeof(xfs_disk_dquot_t);
@@ -261,18 +267,6 @@ xfs_qm_dquot_logitem_init(
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
