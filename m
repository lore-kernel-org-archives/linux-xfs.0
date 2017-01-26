Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28741 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdAZDxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 22:53:34 -0500
Date: Wed, 25 Jan 2017 19:53:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: clear _XBF_PAGES from buffers when readahead page
 allocation fails
Message-ID: <20170126035330.GU9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

If we try to allocate memory pages to back an xfs_buf that we're trying
to read, it's possible that we'll be so short on memory that the page
allocation fails.  For a blocking read we'll just wait, but for
readahead we simply dump all the pages we've collected so far.

Unfortunately, after dumping the pages we neglect to clear the
_XBF_PAGES state, which means that the subsequent call to xfs_buf_free
thinks that b_pages still points to pages we own.  It then double-frees
the b_pages pages.

This results in screaming about negative page refcounts from the memory
manager, which xfs oughtn't be triggering.  To reproduce this case,
mount a filesystem where the size of the inodes far outweighs the
availalble memory (a ~500M inode filesystem on a VM with 300MB memory
did the trick here) and run bulkstat in parallel with other memory
eating processes to put a huge load on the system.  The "check summary"
phase of xfs_scrub also works for this purpose.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7f0a01f..ac3b4db 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -422,6 +422,7 @@ xfs_buf_allocate_memory(
 out_free_pages:
 	for (i = 0; i < bp->b_page_count; i++)
 		__free_page(bp->b_pages[i]);
+	bp->b_flags &= ~_XBF_PAGES;
 	return error;
 }
 
