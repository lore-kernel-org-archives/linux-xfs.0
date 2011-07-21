Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LGT7iR035787 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 11:29:07 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D6088B647
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 09:29:06 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id IvWKDbikmMJGfIYi for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2011 09:29:06 -0700 (PDT)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/8] ext4: Warn if direct reclaim tries to writeback pages
Date: Thu, 21 Jul 2011 17:28:45 +0100
Message-Id: <1311265730-5324-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1311265730-5324-1-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
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
To: Linux-MM <linux-mm@kvack.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>

Direct reclaim should never writeback pages. Warn if an attempt
is made.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/ext4/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e3126c0..95bb179 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2663,8 +2663,12 @@ static int ext4_writepage(struct page *page,
 		 * We don't want to do block allocation, so redirty
 		 * the page and return.  We may reach here when we do
 		 * a journal commit via journal_submit_inode_data_buffers.
-		 * We can also reach here via shrink_page_list
+		 * We can also reach here via shrink_page_list but it
+		 * should never be for direct reclaim so warn if that
+		 * happens
 		 */
+		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+								PF_MEMALLOC);
 		goto redirty_page;
 	}
 	if (commit_write)
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
