Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55557 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751737AbdCAA6c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 19:58:32 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 4/8] nowait aio: Introduce IOMAP_NOWAIT
Date: Tue, 28 Feb 2017 17:36:06 -0600
Message-Id: <20170228233610.25456-5-rgoldwyn@suse.de>
In-Reply-To: <20170228233610.25456-1-rgoldwyn@suse.de>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

IOCB_NOWAIT translates to IOMAP_NOWAIT for iomaps.
This is used by XFS in the XFS patch.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/iomap.c            | 2 ++
 include/linux/iomap.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index a51cb4c..3fb68d2 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -883,6 +883,8 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, struct iomap_ops *ops,
 	} else {
 		dio->flags |= IOMAP_DIO_WRITE;
 		flags |= IOMAP_WRITE;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			flags |= IOMAP_NOWAIT;
 	}
 
 	if (mapping->nrpages) {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index a4c94b8..d1c33ef 100644
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
2.10.2

