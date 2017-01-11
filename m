Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44071 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755341AbdAKJAe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 04:00:34 -0500
From: Jan Kara <jack@suse.cz>
Subject: [PATCH v2] xfs: Timely free truncated dirty pages
Date: Wed, 11 Jan 2017 10:00:19 +0100
Message-Id: <20170111090019.16837-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Petr Tuma <petr.tuma@d3s.mff.cuni.cz>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Vlastimil Babka <vbabka@suse.cz>

Commit 99579ccec4e2 "xfs: skip dirty pages in ->releasepage()" started
to skip dirty pages in xfs_vm_releasepage() which also has the effect
that if a dirty page is truncated, it does not get freed by
block_invalidatepage() and is lingering in LRU list waiting for reclaim.
So a simple loop like:

while true; do
	dd if=/dev/zero of=file bs=1M count=100
	rm file
done

will keep using more and more memory until we hit low watermarks and
start pagecache reclaim which will eventually reclaim also the truncate
pages. Keeping these truncated (and thus never usable) pages in memory
is just a waste of memory, is unnecessarily stressing page cache
reclaim, and reportedly also leads to anonymous mmap(2) returning ENOMEM
prematurely.

So instead of just skipping dirty pages in xfs_vm_releasepage(), return
to old behavior of skipping them only if they have delalloc or unwritten
buffers and fix the spurious warnings by warning only if the page is
clean.

CC: stable@vger.kernel.org
CC: Brian Foster <bfoster@redhat.com>
CC: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Petr Tůma <petr.tuma@d3s.mff.cuni.cz>
Fixes: 99579ccec4e271c3d4d4e7c946058766812afdab
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_aops.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0f56fcd3a5d5..631e7c0e0a29 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1152,19 +1152,22 @@ xfs_vm_releasepage(
 	 * block_invalidatepage() can send pages that are still marked dirty
 	 * but otherwise have invalidated buffers.
 	 *
-	 * We've historically freed buffers on the latter. Instead, quietly
-	 * filter out all dirty pages to avoid spurious buffer state warnings.
-	 * This can likely be removed once shrink_active_list() is fixed.
+	 * We want to release the latter to avoid unnecessary buildup of the
+	 * LRU, skip the former and warn if we've left any lingering
+	 * delalloc/unwritten buffers on clean pages. Skip pages with delalloc
+	 * or unwritten buffers and warn if the page is not dirty. Otherwise
+	 * try to release the buffers.
 	 */
-	if (PageDirty(page))
-		return 0;
-
 	xfs_count_page_state(page, &delalloc, &unwritten);
 
-	if (WARN_ON_ONCE(delalloc))
+	if (delalloc) {
+		WARN_ON_ONCE(!PageDirty(page));
 		return 0;
-	if (WARN_ON_ONCE(unwritten))
+	}
+	if (unwritten) {
+		WARN_ON_ONCE(!PageDirty(page));
 		return 0;
+	}
 
 	return try_to_free_buffers(page);
 }
-- 
2.10.2

