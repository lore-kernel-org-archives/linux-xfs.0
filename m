Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63GK2dA105747 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 11:20:02 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PUxboyFUaYtEyCK4 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 09:20:01 -0700 (PDT)
Date: Tue, 3 Jul 2012 12:20:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: handle EOF correctly in xfs_vm_writepage
Message-ID: <20120703162000.GA13016@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>

We need to zero out part of a page which beyond EOF before setting uptodate,
otherwise, mapread or write will see non-zero data beyond EOF.

Based on the code in fs/buffer.c and the following ext4 commit:

  ext4: handle EOF correctly in ext4_bio_write_page()

And yes, I wish we had a good test case for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_aops.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2012-06-26 23:20:22.286407388 +0200
+++ xfs/fs/xfs/xfs_aops.c	2012-06-26 23:21:49.323073534 +0200
@@ -927,11 +927,26 @@ xfs_vm_writepage(
 	end_index = offset >> PAGE_CACHE_SHIFT;
 	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
 	if (page->index >= end_index) {
-		if ((page->index >= end_index + 1) ||
-		    !(i_size_read(inode) & (PAGE_CACHE_SIZE - 1))) {
+		unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
+
+		/*
+		 * Just skip the page if it is fully outside i_size, e.g. due
+		 * to a truncate operation that is in progress.
+		 */
+		if (page->index >= end_index + 1 || offset_into_page == 0) {
 			unlock_page(page);
 			return 0;
 		}
+
+		/*
+		 * The page straddles i_size.  It must be zeroed out on each
+		 * and every writepage invocation because it may be mmapped.
+		 * "A file is mapped in multiples of the page size.  For a file
+		 * that is not a multiple of the  page size, the remaining
+		 * memory is zeroed when mapped, and writes to that region are
+		 * not written out to the file."
+		 */
+		zero_user_segment(page, offset_into_page, PAGE_CACHE_SIZE);
 	}
 
 	end_offset = min_t(unsigned long long,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
