Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:1838 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728299AbeKGQBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:18 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/16] xfs: align writepages to large block sizes
Date: Wed,  7 Nov 2018 17:31:25 +1100
Message-Id: <20181107063127.3902-15-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

For data integrity purposes, we need to write back the entire
filesystem block when asked to sync a sub-block range of the file.
When the filesystem block size is larger than the page size, this
means we need to convert single page integrity writes into whole
block integrity writes. We do this by extending the writepage range
to filesystem block granularity and alignment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f6ef9e0a7312..5334f16be166 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -900,6 +900,7 @@ xfs_vm_writepages(
 		.io_type = XFS_IO_HOLE,
 	};
 	int			ret;
+	unsigned		bsize =	i_blocksize(mapping->host);
 
 	/*
 	 * Refuse to write pages out if we are called from reclaim context.
@@ -922,6 +923,19 @@ xfs_vm_writepages(
 	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
 		return 0;
 
+	/*
+	 * If the block size is larger than page size, extent the incoming write
+	 * request to fsb granularity and alignment. This is a requirement for
+	 * data integrity operations and it doesn't hurt for other write
+	 * operations, so do it unconditionally.
+	 */
+	if (wbc->range_start)
+		wbc->range_start = round_down(wbc->range_start, bsize);
+	if (wbc->range_end != LLONG_MAX)
+		wbc->range_end = round_up(wbc->range_end, bsize);
+	if (wbc->nr_to_write < wbc->range_end - wbc->range_start)
+		wbc->nr_to_write = round_up(wbc->nr_to_write, bsize);
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
 	if (wpc.ioend)
-- 
2.19.1
