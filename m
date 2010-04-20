Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K3c9jF258772 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 22:38:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED90012D298B
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 20:40:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	EC3i2uYSD41E0cxj for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 20:40:07 -0700 (PDT)
Date: Tue, 20 Apr 2010 13:40:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/4] writeback: limit write_cache_pages integrity scanning
	to current EOF
Message-ID: <20100420034005.GA15130@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271731314-5893-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com


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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/page-writeback.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e22af84..4ba2728 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -852,7 +852,22 @@ int write_cache_pages(struct address_space *mapping,
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
