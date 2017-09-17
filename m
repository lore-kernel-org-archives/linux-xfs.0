Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdIQVHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:17 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/47] xfs: free cowblocks and retry on buffered write ENOSPC
Date: Sun, 17 Sep 2017 14:06:34 -0700
Message-Id: <20170917210712.10804-10-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit cf2cb7845d6e101cb17bd62f8aa08cd514fc8988 upstream.

XFS runs an eofblocks reclaim scan before returning an ENOSPC error to
userspace for buffered writes. This facilitates aggressive speculative
preallocation without causing user visible side effects such as
premature ENOSPC.

Run a cowblocks scan in the same situation to reclaim lingering COW fork
preallocation throughout the filesystem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 2e04b1cdb0d2..586b398f268d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -729,6 +729,7 @@ xfs_file_buffered_aio_write(
 		xfs_rw_iunlock(ip, iolock);
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
 		goto write_retry;
 	}
 
-- 
2.14.1

