Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1ADF77F3F
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DE251304059
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id kCWuLrZPtxHfFMfu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcG-000093-7l
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:00 +0000
Message-Id: <20131129084000.123386171@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/10] xfs: remove duplicate code in
	xlog_cil_insert_format_items
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0001-xfs-remove-duplicate-code-in-xlog_cil_insert_format_.patch
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

Share code that was previously duplicated in two branches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5eb51fc..0a7a8ce 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -254,29 +254,22 @@ xlog_cil_insert_format_items(
 			 */
 			*diff_iovecs -= lv->lv_niovecs;
 			*diff_len -= lv->lv_buf_len;
-
-			/* Ensure the lv is set up according to ->iop_size */
-			lv->lv_niovecs = niovecs;
-			lv->lv_buf = (char *)lv + buf_size - nbytes;
-
-			lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
-			goto insert;
+		} else {
+			/* allocate new data chunk */
+			lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
+			lv->lv_item = lip;
+			lv->lv_size = buf_size;
+			if (ordered) {
+				/* track as an ordered logvec */
+				ASSERT(lip->li_lv == NULL);
+				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
+				goto insert;
+			}
+			lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
 		}
 
-		/* allocate new data chunk */
-		lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
-		lv->lv_item = lip;
-		lv->lv_size = buf_size;
+		/* Ensure the lv is set up according to ->iop_size */
 		lv->lv_niovecs = niovecs;
-		if (ordered) {
-			/* track as an ordered logvec */
-			ASSERT(lip->li_lv == NULL);
-			lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
-			goto insert;
-		}
-
-		/* The allocated iovec region lies beyond the log vector. */
-		lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
 
 		/* The allocated data region lies beyond the iovec region */
 		lv->lv_buf = (char *)lv + buf_size - nbytes;
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
