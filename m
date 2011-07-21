Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LGTD29035816 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 11:29:13 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D82828B652
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 09:29:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Sq0o2hWYInp0pMaO for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2011 09:29:12 -0700 (PDT)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/8] btrfs: Warn if direct reclaim tries to writeback pages
Date: Thu, 21 Jul 2011 17:28:46 +0100
Message-Id: <1311265730-5324-5-git-send-email-mgorman@suse.de>
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

Direct reclaim should never writeback pages. Warn if an attempt is
made. By rights, btrfs should be allowing writepage from kswapd if
it is failing to reclaim pages by any other means but it's outside
the scope of this patch.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/btrfs/disk-io.c |    2 ++
 fs/btrfs/inode.c   |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ac8db5d..cc9c9cf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -829,6 +829,8 @@ static int btree_writepage(struct page *page, struct writeback_control *wbc)
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	if (!(current->flags & PF_MEMALLOC)) {
+		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+								PF_MEMALLOC);
 		return extent_write_full_page(tree, page,
 					      btree_get_extent, wbc);
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3601f0a..07d6c27 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6259,6 +6259,8 @@ static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 
 
 	if (current->flags & PF_MEMALLOC) {
+		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+								PF_MEMALLOC);
 		redirty_page_for_writepage(wbc, page);
 		unlock_page(page);
 		return 0;
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
