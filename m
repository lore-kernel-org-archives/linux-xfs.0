Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73KnJ9M179518 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 15:49:19 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E82914A6830
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 13:49:17 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2BNpz5GrWbzy1hun for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 13:49:17 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] vfs: Create filemap_flush_range()
Date: Wed,  3 Aug 2011 22:49:04 +0200
Message-Id: <1312404545-15400-2-git-send-email-jack@suse.cz>
In-Reply-To: <1312404545-15400-1-git-send-email-jack@suse.cz>
References: <1312404545-15400-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Create a version of filemap_flush() function which can take a range.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |    2 ++
 mm/filemap.c       |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 786b3b1..091cf90 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2177,6 +2177,8 @@ extern int invalidate_inode_pages2_range(struct address_space *mapping,
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
+extern int filemap_flush_range(struct address_space *mapping, loff_t start,
+				loff_t end);
 extern int filemap_fdatawait(struct address_space *);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
diff --git a/mm/filemap.c b/mm/filemap.c
index 867d402..8fd2347 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -253,6 +253,22 @@ int filemap_flush(struct address_space *mapping)
 EXPORT_SYMBOL(filemap_flush);
 
 /**
+ * filemap_flush_range - mostly a non-blocking flush of a mapping range
+ * @mapping:	target address_space
+ * @start:	offset in bytes where the range starts
+ * @end:	offset in bytes where the range ends (inclusive)
+ *
+ * This is a mostly non-blocking flush.  Not suitable for data-integrity
+ * purposes - I/O may not be started against all dirty pages.
+ */
+int filemap_flush_range(struct address_space *mapping, loff_t start,
+			loff_t end)
+{
+	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_NONE);
+}
+EXPORT_SYMBOL(filemap_flush_range);
+
+/**
  * filemap_fdatawait_range - wait for writeback to complete
  * @mapping:		address space structure to wait for
  * @start_byte:		offset in bytes where the range starts
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
