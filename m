Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 71D7B7F56
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 09:15:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 531308F8039
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 07:15:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id zZXsVlFDNer2i7K7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 07:15:35 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkEvm-0001Pz-5S
	for xfs@oss.sgi.com; Sat, 23 Nov 2013 15:15:34 +0000
Message-Id: <20131123151534.091231676@bombadil.infradead.org>
Date: Sat, 23 Nov 2013 07:11:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] xfs: remove the quotaoff log format from the quotaoff log
	item
References: <20131123151151.716201348@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0004-xfs-remove-the-quotaoff-log-format-from-the-quotaoff.patch
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

No quite as large as the previous ones, but easy enough to decouple.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot_item.c |   16 ++++++++--------
 fs/xfs/xfs_dquot_item.h |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 2df55fe..c1917fd 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -306,16 +306,17 @@ xfs_qm_qoff_logitem_format(
 {
 	struct xfs_qoff_logitem	*qflip = QOFF_ITEM(lip);
 	struct xfs_log_iovec *vec;
-
-	ASSERT(qflip->qql_format.qf_type == XFS_LI_QUOTAOFF);
-
-	qflip->qql_format.qf_size = 1;
+	struct xfs_qoff_logformat *qlf;
 
 	vec = xlog_first_iovec(lv);
-	memcpy(vec->i_addr, &qflip->qql_format, sizeof(xfs_qoff_logitem_t));
-	vec->i_len = sizeof(xfs_qoff_logitem_t);
+	vec->i_len = sizeof(struct xfs_qoff_logitem);
 	vec->i_type = XLOG_REG_TYPE_QUOTAOFF;
 
+	qlf = vec->i_addr;
+	qlf->qf_type = XFS_LI_QUOTAOFF;
+	qlf->qf_size = 1;
+	qlf->qf_flags = qflip->qql_flags;
+
 	xlog_last_iovec(lv, vec);
 }
 
@@ -456,8 +457,7 @@ xfs_qm_qoff_logitem_init(
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
