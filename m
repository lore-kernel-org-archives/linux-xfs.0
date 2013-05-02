Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8410C7F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 02:45:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FD778F804B
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 00:45:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	h2El18Vst3LhCtMa for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 00:45:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXoCY-0002DM-6f
	for xfs@oss.sgi.com; Thu, 02 May 2013 17:45:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXoCT-0006CU-22
	for xfs@oss.sgi.com; Thu, 02 May 2013 17:45:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix sub-page blocksize data integrity writes
Date: Thu,  2 May 2013 17:45:09 +1000
Message-Id: <1367480709-23804-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

FSX on 512 byte block size filesystems has been failing for some
time with corrupted data. The fault dates back to the change in
the writeback data integrity algorithm that uses a mark-and-sweep
approach to avoid data writeback livelocks.

Unfortunately, a side effect of this mark-and-sweep approach is that
each page will only be written once for a data integrity sync, and
there is a condition in writeback in XFS where a page may require
two writeback attempts to be fully written. As a result of the high
level change, we now only get a partial page writeback during the
integrity sync because the first pass through writeback clears the
mark left on the page index to tell writeback that the page needs
writeback....

The cause is writing a partial page in the clustering code. This can
happen when a mapping boundary falls in the middle of a page - we
end up writing back the first part of the page that the mapping
covers, but then never revisit the page to have the remainder mapped
and written.

The fix is simple - if the mapping boundary falls inside a page,
then simple abort clustering without touching the page. This means
that the next ->writepage entry that write_cache_pages() will make
is the page we aborted on, and xfs_vm_writepage() will map all
sections of the page correctly. This behaviour is also optimal for
non-data integrity writes, as it results in contiguous sequential
writeback of the file rather than missing small holes and having to
write them a "random" writes in a future pass.

With this fix, all the fsx tests in xfstests now pass on a 512 byte
block size filesystem on a 4k page machine.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c     |   21 +++++++++++++++++++++
 fs/xfs/xfs_vnodeops.c |    4 ++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3244c98..72d08b6 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -439,6 +439,7 @@ xfs_start_page_writeback(
 	int			clear_dirty,
 	int			buffers)
 {
+	trace_xfs_writepage(page->mapping->host, page, 0);
 	ASSERT(PageLocked(page));
 	ASSERT(!PageWriteback(page));
 	if (clear_dirty)
@@ -724,12 +725,32 @@ xfs_convert_page(
 			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
 			i_size_read(inode));
 
+	/*
+	 * If the current map does not span the entire page we are about to try
+	 * to write, then give up. The only way we can write a page that spans
+	 * multiple mappings in a single writeback iteration is via the
+	 * xfs_vm_writepage() function. Data integrity writeback requires the
+	 * entire page to be written in a single attempt, otherwise the part of
+	 * the page we don't write here doesn't get written as part of the data
+	 * integrity sync.
+	 *
+	 * For normal writeback, we also don't attempt to write partial pages
+	 * here as it simply means that write_cache_pages() will see it under
+	 * writeback and ignore the page until some pointin the future, at which
+	 * time this will be the only page inteh file that needs writeback.
+	 * Hence for more optimal IO patterns, we should always avoid partial
+	 * page writeback due to multiple mappings on a page here.
+	 */
+	if (!xfs_imap_valid(inode, imap, end_offset))
+		goto fail_unlock_page;
+
 	len = 1 << inode->i_blkbits;
 	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
 					PAGE_CACHE_SIZE);
 	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
 	page_dirty = p_offset / len;
 
+
 	bh = head = page_buffers(page);
 	do {
 		if (offset >= end_offset)
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 1501f4f..0176bb2 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1453,7 +1453,7 @@ xfs_free_file_space(
 	xfs_mount_t		*mp;
 	int			nimap;
 	uint			resblks;
-	uint			rounding;
+	xfs_off_t		rounding;
 	int			rt;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_trans_t		*tp;
@@ -1482,7 +1482,7 @@ xfs_free_file_space(
 		inode_dio_wait(VFS_I(ip));
 	}
 
-	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
 	ioffset = offset & ~(rounding - 1);
 	error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
 					      ioffset, -1);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
