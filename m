Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A62B7CCB
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 14:14:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4436AC001
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 12:14:10 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id 36xDuAEIGnZfGrX9 for
	<xfs@oss.sgi.com>; Sat, 23 Apr 2016 12:14:09 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 7/7] dax: fix a comment in dax_zero_page_range and
	dax_truncate_page
Date: Sat, 23 Apr 2016 13:13:42 -0600
Message-Id: <1461438822-3592-8-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1461438822-3592-1-git-send-email-vishal.l.verma@intel.com>
References: <1461438822-3592-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>

The distinction between PAGE_SIZE and PAGE_CACHE_SIZE was removed in

09cbfea mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release}
macros

The comments for the above functions described a distinction between
those, that is now redundant, so remove those paragraphs

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 fs/dax.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d8c974e..b8fa85a 100644
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
@@ -1279,12 +1273,6 @@ EXPORT_SYMBOL_GPL(dax_zero_page_range);
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
