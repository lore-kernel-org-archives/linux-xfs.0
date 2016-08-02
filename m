Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 635A47CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 18:41:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 27EF18F8033
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 16:41:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IiFWAWn1tWPHui2j for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 16:41:12 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't invalidate whole file on DAX read/write
Date: Wed,  3 Aug 2016 09:40:26 +1000
Message-Id: <1470181226-20935-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com
Cc: jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

When we do DAX IO, we try to invalidate the entire page cache held
on the file. This is incorrect as it will trash the entire mapping
tree that now tracks dirty state in exceptional entries in the radix
tree slots.

What we are trying to do is remove cached pages (e.g from reads
into holes) that sit in the radix tree over the range we are about
to write to. Hence we should just limit the invalidation to the
range we are about to overwrite.

Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ed95e5b..e612a02 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -741,9 +741,20 @@ xfs_file_dax_write(
 	 * page is inserted into the pagecache when we have to serve a write
 	 * fault on a hole.  It should never be dirtied and can simply be
 	 * dropped from the pagecache once we get real data for the page.
+	 *
+	 * XXX: This is racy against mmap, and there's nothing we can do about
+	 * it. dax_do_io() should really do this invalidation internally as
+	 * it will know if we've allocated over a holei for this specific IO and
+	 * if so it needs to update the mapping tree and invalidate existing
+	 * PTEs over the newly allocated range. Remove this invalidation when
+	 * dax_do_io() is fixed up.
 	 */
 	if (mapping->nrpages) {
-		ret = invalidate_inode_pages2(mapping);
+		loff_t end = iocb->ki_pos + iov_iter_count(from) - 1;
+
+		ret = invalidate_inode_pages2_range(mapping,
+						    iocb->ki_pos >> PAGE_SHIFT,
+						    end >> PAGE_SHIFT);
 		WARN_ON_ONCE(ret);
 	}
 
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
