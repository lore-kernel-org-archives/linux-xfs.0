Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFETPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:17 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/24] xfs: remove the no-op spinlock_destroy stub
Date: Wed,  5 Jun 2019 21:14:48 +0200
Message-Id: <20190605191511.32695-2-hch@lst.de>
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_linux.h | 2 --
 fs/xfs/xfs_log.c   | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..b78287666309 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -110,8 +110,6 @@ typedef __u32			xfs_nlink_t;
 #define current_restore_flags_nested(sp, f)	\
 		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
-#define spinlock_destroy(lock)
-
 #define NBBY		8		/* number of bits per byte */
 
 /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 457ced3ee3e1..a2048e46be4e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1580,7 +1580,6 @@ xlog_alloc_log(
 			xfs_buf_free(iclog->ic_bp);
 		kmem_free(iclog);
 	}
-	spinlock_destroy(&log->l_icloglock);
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
@@ -2027,7 +2026,6 @@ xlog_dealloc_log(
 		kmem_free(iclog);
 		iclog = next_iclog;
 	}
-	spinlock_destroy(&log->l_icloglock);
 
 	log->l_mp->m_log = NULL;
 	kmem_free(log);
-- 
2.20.1
