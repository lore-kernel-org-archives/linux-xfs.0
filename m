Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753662AbdEIMWh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 08:22:37 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 4/8] nowait-aio: Introduce IOMAP_NOWAIT
Date: Tue,  9 May 2017 07:22:15 -0500
Message-Id: <20170509122219.31756-5-rgoldwyn@suse.de>
In-Reply-To: <20170509122219.31756-1-rgoldwyn@suse.de>
References: <20170509122219.31756-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

IOCB_NOWAIT translates to IOMAP_NOWAIT for iomaps.
This is used by XFS in the XFS patch.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            | 2 ++
 include/linux/iomap.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 141c3cd55a8b..d1c81753d411 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -885,6 +885,8 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	} else {
 		dio->flags |= IOMAP_DIO_WRITE;
 		flags |= IOMAP_WRITE;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			flags |= IOMAP_NOWAIT;
 	}
 
 	if (mapping->nrpages) {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 7291810067eb..53f6af89c625 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -51,6 +51,7 @@ struct iomap {
 #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
 #define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
 #define IOMAP_DIRECT		(1 << 4) /* direct I/O */
+#define IOMAP_NOWAIT		(1 << 5) /* Don't wait for writeback */
 
 struct iomap_ops {
 	/*
-- 
2.12.0

