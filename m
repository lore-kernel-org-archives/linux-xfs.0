Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbfBDQyi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 11:54:38 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 09/10] xfs: fix PAGE_MASK usage in xfs_free_file_space
Date: Mon,  4 Feb 2019 08:54:26 -0800
Message-Id: <20190204165427.23607-10-mcgrof@kernel.org>
In-Reply-To: <20190204165427.23607-1-mcgrof@kernel.org>
References: <20190204165427.23607-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a579121f94aba4e8bad1a121a0fad050d6925296 upstream.

In commit e53c4b598, I *tried* to teach xfs to force writeback when we
fzero/fpunch right up to EOF so that if EOF is in the middle of a page,
the post-EOF part of the page gets zeroed before we return to userspace.
Unfortunately, I missed the part where PAGE_MASK is ~(PAGE_SIZE - 1),
which means that we totally fail to zero if we're fpunching and EOF is
within the first page.  Worse yet, the same PAGE_MASK thinko plagues the
filemap_write_and_wait_range call, so we'd initiate writeback of the
entire file, which (mostly) masked the thinko.

Drop the tricky PAGE_MASK and replace it with correct usage of PAGE_SIZE
and the proper rounding macros.

Fixes: e53c4b598 ("xfs: ensure post-EOF zeroing happens after zeroing part of a file")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9d1e5c3a661e..211b06e4702e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1175,9 +1175,9 @@ xfs_free_file_space(
 	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
 	 * Writeback of the eof page will do this, albeit clumsily.
 	 */
-	if (offset + len >= XFS_ISIZE(ip) && ((offset + len) & PAGE_MASK)) {
+	if (offset + len >= XFS_ISIZE(ip) && offset_in_page(offset + len) > 0) {
 		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-				(offset + len) & ~PAGE_MASK, LLONG_MAX);
+				round_down(offset + len, PAGE_SIZE), LLONG_MAX);
 	}
 
 	return error;
-- 
2.18.0
