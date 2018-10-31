Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbeJaXAG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 19:00:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 446D1307DAC2
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 14:01:57 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D77A7A47AC
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 14:01:56 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: don't preempt writeback sequence on single page wb error
Date: Wed, 31 Oct 2018 10:01:55 -0400
Message-Id: <20181031140155.17996-3-bfoster@redhat.com>
In-Reply-To: <20181031140155.17996-1-bfoster@redhat.com>
References: <20181031140155.17996-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_do_writepage() currently returns errors directly regardless of
whether it is called via ->writepages() or ->writepage(). In the
case of ->writepages(), an xfs_do_writepage() error return breaks
the current writeback sequence in write_cache_pages(). This means
that an integrity writeback (i.e., sync), for example, returns
before all associated pages have been processed.

This can be problematic in cases like unmount. If the writeback
doesn't process all delalloc pages before unmounting, we end up
reclaiming inodes with non-zero delalloc block counts. In turn, this
breaks block accounting and leaves the fs inconsistent.

XFS explicitly discards delalloc blocks on such writepage failures
to avoid this problem. This isn't terribly useful if we allow an
integrity writeback to complete (and thus a filesystem to unmount)
without addressing the entire set of dirty pages on an inode.
Therefore, change ->writepage[s]() to track high level error state
in the xfs_writepage_ctx structure and return it from the higher
level operation callout rather than xfs_do_writepage(). This ensures
that write_cache_pages() does not exit prematurely when called via
->writepages(), but both ->writepage() and ->writepages() still
ultimately return an error for the higher level operation.

This patch introduces a subtle change in the behavior of background
writeback in the event of persistent errors. The current behavior of
returning an error preempts the background writeback. Writeback
eventually comes around again and repeats the process for a few more
pages (in practice) before it once again fails. This repeats over
and over until the entire set of dirty pages is cleaned. This
behavior results in a somewhat slower stream of "page discard"
errors in the system log and dictates that many repeated fsync calls
may be required before the entire data set is processed and mapping
error consumed. With this change in place, background writeback
executes on as many pages as necessary as if each page writeback
were successful. The pages are cleaned immediately and significantly
more page discard errors can be observed at once.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3feae3691467..438cfc66a40e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -32,6 +32,7 @@ struct xfs_writepage_ctx {
 	unsigned int		io_type;
 	unsigned int		cow_seq;
 	struct xfs_ioend	*ioend;
+	int			error;
 };
 
 struct block_device *
@@ -798,7 +799,9 @@ xfs_writepage_map(
 		end_page_writeback(page);
 done:
 	mapping_set_error(page->mapping, error);
-	return error;
+	if (!wpc->error)
+		wpc->error = error;
+	return 0;
 }
 
 /*
@@ -929,8 +932,8 @@ xfs_vm_writepage(
 
 	ret = xfs_do_writepage(page, wbc, &wpc);
 	if (wpc.ioend)
-		ret = xfs_submit_ioend(wbc, wpc.ioend, ret);
-	return ret;
+		ret = xfs_submit_ioend(wbc, wpc.ioend, wpc.error);
+	return ret ? ret : wpc.error;
 }
 
 STATIC int
@@ -946,8 +949,8 @@ xfs_vm_writepages(
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
 	if (wpc.ioend)
-		ret = xfs_submit_ioend(wbc, wpc.ioend, ret);
-	return ret;
+		ret = xfs_submit_ioend(wbc, wpc.ioend, wpc.error);
+	return ret ? ret : wpc.error;
 }
 
 STATIC int
-- 
2.17.2
