Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757098AbdAIPjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:19 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/32] xfs: don't BUG() on mixed direct and mapped I/O
Date: Mon,  9 Jan 2017 16:38:35 +0100
Message-Id: <1483976343-661-5-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Brian Foster <bfoster@redhat.com>

commit 04197b341f23b908193308b8d63d17ff23232598 upstream.

We've had reports of generic/095 causing XFS to BUG() in
__xfs_get_blocks() due to the existence of delalloc blocks on a
direct I/O read. generic/095 issues a mix of various types of I/O,
including direct and memory mapped I/O to a single file. This is
clearly not supported behavior and is known to lead to such
problems. E.g., the lack of exclusion between the direct I/O and
write fault paths means that a write fault can allocate delalloc
blocks in a region of a file that was previously a hole after the
direct read has attempted to flush/inval the file range, but before
it actually reads the block mapping. In turn, the direct read
discovers a delalloc extent and cannot proceed.

While the appropriate solution here is to not mix direct and memory
mapped I/O to the same regions of the same file, the current
BUG_ON() behavior is probably overkill as it can crash the entire
system.  Instead, localize the failure to the I/O in question by
returning an error for a direct I/O that cannot be handled safely
due to delalloc blocks. Be careful to allow the case of a direct
write to post-eof delalloc blocks. This can occur due to speculative
preallocation and is safe as post-eof blocks are not accompanied by
dirty pages in pagecache (conversely, preallocation within eof must
have been zeroed, and thus dirtied, before the inode size could have
been increased beyond said blocks).

Finally, provide an additional warning if a direct I/O write occurs
while the file is memory mapped. This may not catch all problematic
scenarios, but provides a hint that some known-to-be-problematic I/O
methods are in use.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_aops.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3e57a56..2693ba8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1361,6 +1361,26 @@ __xfs_get_blocks(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * The only time we can ever safely find delalloc blocks on direct I/O
+	 * is a dio write to post-eof speculative preallocation. All other
+	 * scenarios are indicative of a problem or misuse (such as mixing
+	 * direct and mapped I/O).
+	 *
+	 * The file may be unmapped by the time we get here so we cannot
+	 * reliably fail the I/O based on mapping. Instead, fail the I/O if this
+	 * is a read or a write within eof. Otherwise, carry on but warn as a
+	 * precuation if the file happens to be mapped.
+	 */
+	if (direct && imap.br_startblock == DELAYSTARTBLOCK) {
+		if (!create || offset < i_size_read(VFS_I(ip))) {
+			WARN_ON_ONCE(1);
+			error = -EIO;
+			goto out_unlock;
+		}
+		WARN_ON_ONCE(mapping_mapped(VFS_I(ip)->i_mapping));
+	}
+
 	/* for DAX, we convert unwritten extents directly */
 	if (create &&
 	    (!nimaps ||
@@ -1450,8 +1470,6 @@ __xfs_get_blocks(
 	     (new || ISUNWRITTEN(&imap))))
 		set_buffer_new(bh_result);
 
-	BUG_ON(direct && imap.br_startblock == DELAYSTARTBLOCK);
-
 	return 0;
 
 out_unlock:
-- 
2.1.4

