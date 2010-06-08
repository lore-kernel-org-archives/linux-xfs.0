Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o580adeo179741 for <xfs@oss.sgi.com>; Mon, 7 Jun 2010 19:36:39 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1DB33A05F4
	for <xfs@oss.sgi.com>; Mon,  7 Jun 2010 17:39:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	LOTof8nEjmus1CE7 for <xfs@oss.sgi.com>;
	Mon, 07 Jun 2010 17:39:09 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] writeback: limit write_cache_pages integrity scanning to
	current EOF
Date: Tue,  8 Jun 2010 10:38:07 +1000
Message-Id: <1275957487-23633-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1275957487-23633-1-git-send-email-david@fromorbit.com>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
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
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

sync can currently take a really long time if a concurrent writer is
extending a file. The problem is that the dirty pages on the address
space grow in the same direction as write_cache_pages scans, so if
the writer keeps ahead of writeback, the writeback will not
terminate until the writer stops adding dirty pages.

For a data integrity sync, we only need to write the pages dirty at
the time we start the writeback, so we can stop scanning once we get
to the page that was at the end of the file at the time the scan
started.

This will prevent operations like copying a large file preventing
sync from completing as it will not write back pages that were
dirtied after the sync was started. This does not impact the
existing integrity guarantees, as any dirty page (old or new)
within the EOF range at the start of the scan will still be
captured.

This patch will not prevent sync from blocking on large writes into
holes. That requires more complex intervention while this patch only
addresses the common append-case of this sync holdoff.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/page-writeback.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0acadee..1a361f0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -855,7 +855,22 @@ int write_cache_pages(struct address_space *mapping,
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
 		cycled = 1; /* ignore range_cyclic tests */
+
+		/*
+		 * If this is a data integrity sync, cap the writeback to the
+		 * current end of file. Any extension to the file that occurs
+		 * after this is a new write and we don't need to write those
+		 * pages out to fulfil our data integrity requirements. If we
+		 * try to write them out, we can get stuck in this scan until
+		 * the concurrent writer stops adding dirty pages and extending
+		 * EOF.
+		 */
+		if (wbc->sync_mode == WB_SYNC_ALL &&
+		    wbc->range_end == LLONG_MAX) {
+			end = i_size_read(mapping->host) >> PAGE_CACHE_SHIFT;
+		}
 	}
+
 retry:
 	done_index = index;
 	while (!done && (index <= end)) {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
