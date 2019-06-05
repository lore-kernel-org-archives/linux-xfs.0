Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:35 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/24] xfs: reformat xlog_get_lowest_lsn
Date: Wed,  5 Jun 2019 21:14:54 +0200
Message-Id: <20190605191511.32695-8-hch@lst.de>
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>

Reformat xlog_get_lowest_lsn to our usual style.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3e7b046e04b5..eececb847f8d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2632,27 +2632,23 @@ xlog_state_clean_log(
 
 STATIC xfs_lsn_t
 xlog_get_lowest_lsn(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	xlog_in_core_t  *lsn_log;
-	xfs_lsn_t	lowest_lsn, lsn;
+	struct xlog_in_core	*iclog = log->l_iclog;
+	xfs_lsn_t		lowest_lsn = 0, lsn;
 
-	lsn_log = log->l_iclog;
-	lowest_lsn = 0;
 	do {
-	    if (!(lsn_log->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY))) {
-		lsn = be64_to_cpu(lsn_log->ic_header.h_lsn);
-		if ((lsn && !lowest_lsn) ||
-		    (XFS_LSN_CMP(lsn, lowest_lsn) < 0)) {
+		if (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))
+			continue;
+
+		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+		if ((lsn && !lowest_lsn) || XFS_LSN_CMP(lsn, lowest_lsn) < 0)
 			lowest_lsn = lsn;
-		}
-	    }
-	    lsn_log = lsn_log->ic_next;
-	} while (lsn_log != log->l_iclog);
+	} while ((iclog = iclog->ic_next) != log->l_iclog);
+
 	return lowest_lsn;
 }
 
-
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log,
-- 
2.20.1
