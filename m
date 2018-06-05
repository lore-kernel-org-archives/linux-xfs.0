Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeFEQd1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:33:27 -0400
Date: Tue, 5 Jun 2018 09:33:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] iomap: fsync swap files before iterating mappings
Message-ID: <20180605163304.GH9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Swap files require that all the file mapping metadata be stable on disk.
It is insufficient to flush dirty pages in the page cache because that
won't necessarily result in filesystems pushing all their metadata out
to disk.  Therefore, call fsync from iomap_swapfile_activate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fdatasync semantics, per hch feedback
---
 fs/iomap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 206539d369a8..2bd04f0451f2 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1387,7 +1387,11 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
 	loff_t len = ALIGN_DOWN(i_size_read(inode), PAGE_SIZE);
 	loff_t ret;
 
-	ret = filemap_write_and_wait(inode->i_mapping);
+	/*
+	 * Persist all file mapping metadata so that we won't have any
+	 * IOMAP_F_DIRTY iomaps.
+	 */
+	ret = vfs_fsync(swap_file, 1);
 	if (ret)
 		return ret;
 
