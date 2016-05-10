Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B4DC17CB8
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 13:49:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25CEDAC007
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 11:49:45 -0700 (PDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id YLJBu4FQtxhnm89b for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 11:49:43 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v6 5/5] dax: fix a comment in dax_zero_page_range and
	dax_truncate_page
Date: Tue, 10 May 2016 12:49:16 -0600
Message-Id: <1462906156-22303-6-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
References: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

The distinction between PAGE_SIZE and PAGE_CACHE_SIZE was removed in

09cbfea mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release}
macros

The comments for the above functions described a distinction between
those, that is now redundant, so remove those paragraphs

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 fs/dax.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 0167cde..afa289c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1221,12 +1221,6 @@ static bool dax_range_is_aligned(struct block_device *bdev,
  * page in a DAX file.  This is intended for hole-punch operations.  If
  * you are truncating a file, the helper function dax_truncate_page() may be
  * more convenient.
- *
- * We work in terms of PAGE_SIZE here for commonality with
- * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
- * took care of disposing of the unnecessary blocks.  Even if the filesystem
- * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmapped.
  */
 int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 							get_block_t get_block)
@@ -1278,12 +1272,6 @@ EXPORT_SYMBOL_GPL(dax_zero_page_range);
  *
  * Similar to block_truncate_page(), this function can be called by a
  * filesystem when it is truncating a DAX file to handle the partial page.
- *
- * We work in terms of PAGE_SIZE here for commonality with
- * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
- * took care of disposing of the unnecessary blocks.  Even if the filesystem
- * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmapped.
  */
 int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 {
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
