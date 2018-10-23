Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbeJXCkN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 22:40:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B36F3D967
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 18:15:44 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5405F17791
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 18:15:44 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: add writepage map error tag
Date: Tue, 23 Oct 2018 14:15:43 -0400
Message-Id: <20181023181543.43315-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add an error tag to inject errors in the writeback block mapping
codepath. This facilitates testing of the error path responsible for
discarding delalloc blocks that could not be converted to real
blocks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

I'm sending this along with a quick xfstest to call attention to an
issue I ran into when poking around the writepage error handling path.
The test demonstrates the details, but the short of it is that returning
an error from ->writepages() interrupts a sync writeback and allows us
to unmount a filesystem with dirty+delalloc pages. This behavior can
also be observed with something like the following:

# xfs_io -fc "pwrite 0 64k" /mnt/file
wrote 65536/65536 bytes at offset 0
64 KiB, 16 ops; 0.0000 sec (102.627 MiB/sec and 26272.5780 ops/sec)
# xfs_io -c fsync /mnt/file 
fsync: Input/output error
# xfs_io -c fsync /mnt/file 
fsync: Input/output error
# xfs_io -c fsync /mnt/file 
fsync: Input/output error

... and so on until we finally process every dirty page.

A quick hack to return 0 from xfs_writepage_map() changes the behavior
to process (i.e. toss/discard) all of the dirty pages as if writeback
was successful. I don't necessarily think that is the right approach
since ->writepage() should probably return an error even if
->writepages() doesn't, but it raises the question as to what the
expected behavior should be in this case.

ISTM that we have a bit of an impedence mismatch between what a return
code and mapping error mean vs. what XFS does. XFS essentially tosses
the page by throwing away delalloc blocks, clearing uptodate status on
the page and setting an error on the page/mapping (the latter of which
makes it to userspace on fsync, for example). By also returning an
error, we're telling mm not to continue processing the writeback, but
should we be doing that if we need to process these dirty pages whether
writeback succeeds or fails? For background writeback it might not
matter, it will loop around again until all pages are processed, but for
an integrity sync (or the umount case)?

Further, it also seems we're a bit inconsistent with page states between
writepage failures and I/O errors. The former clears the uptodate status
and thus immediately loses the page content, whereas the latter looks
like it just clears writeback and the content presumably sticks around
if/until the page is reclaimed and the old data is read from disk. This
is somewhat of a separate issue [1], however..

I need to poke around the writeback code some more, but I was thinking
of doing something like filtering out an error return somehow or another
if we're in ->writepages() and doing an integrity writeback. Any high
level thoughts on that? Other ideas?

Brian

[1] I'm mulling over the idea of deferring all such page processing to a
workqueue by setting some kind of an inode flag (a la inode reclaim,
eofblocks processing, etc.) such that we can make page error processing
1.) consistent, 2.) properly serialized with buffered writes and 3.)
perhaps even configurable via something like the metadata error handling
tunables.

 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_aops.c            | 6 ++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 66077a105cbb..97c9eaa72dee 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -54,7 +54,8 @@
 #define XFS_ERRTAG_BUF_LRU_REF				31
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
-#define XFS_ERRTAG_MAX					34
+#define XFS_ERRTAG_WRITEPAGE_MAP			34
+#define XFS_ERRTAG_MAX					35
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -93,5 +94,6 @@
 #define XFS_RANDOM_BUF_LRU_REF				2
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
+#define XFS_RANDOM_WRITEPAGE_MAP			2
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 338b9d9984e0..0b5d41195282 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -21,6 +21,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_errortag.h"
 #include <linux/writeback.h>
 
 /*
@@ -718,6 +719,11 @@ xfs_writepage_map(
 		if (iop && !test_bit(i, iop->uptodate))
 			continue;
 
+		if (XFS_TEST_ERROR(false, XFS_I(inode)->i_mount,
+				   XFS_ERRTAG_WRITEPAGE_MAP)) {
+			error = -EIO;
+			break;
+		}
 		error = xfs_map_blocks(wpc, inode, file_offset);
 		if (error)
 			break;
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9866f542e77b..e15ac398b1da 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -51,6 +51,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BUF_LRU_REF,
 	XFS_RANDOM_FORCE_SCRUB_REPAIR,
 	XFS_RANDOM_FORCE_SUMMARY_RECALC,
+	XFS_RANDOM_WRITEPAGE_MAP,
 };
 
 struct xfs_errortag_attr {
@@ -159,6 +160,7 @@ XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
 XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
+XFS_ERRORTAG_ATTR_RW(writepage_map,	XFS_ERRTAG_WRITEPAGE_MAP);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -195,6 +197,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
 	XFS_ERRORTAG_ATTR_LIST(force_repair),
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
+	XFS_ERRORTAG_ATTR_LIST(writepage_map),
 	NULL,
 };
 
-- 
2.17.2
