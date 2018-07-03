Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:50649 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751237AbeGCELi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 00:11:38 -0400
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: [PATCH 1/2] fs: ext4: use BUG_ON if writepage call comes from direct reclaim
Date: Tue,  3 Jul 2018 12:11:18 +0800
Message-Id: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mgorman@techsingularity.net, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, dchinner@redhat.com, akpm@linux-foundation.org
Cc: yang.shi@linux.alibaba.com, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

direct reclaim doesn't write out filesystem page, only kswapd could do
it. So, if the call comes from direct reclaim, it is definitely a bug.

And, Mel Gormane also mentioned "Ultimately, this will be a BUG_ON." In
commit 94054fa3fca1fd78db02cb3d68d5627120f0a1d4 ("xfs: warn if direct
reclaim tries to writeback pages").

Although it is for xfs, ext4 has the similar behavior, so elevate
WARN_ON to BUG_ON.

And, correct the comment accordingly.

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
---
 fs/ext4/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2ea07ef..089e388 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2071,7 +2071,7 @@ static int __ext4_journalled_writepage(struct page *page,
  * This function can get called via...
  *   - ext4_writepages after taking page lock (have journal handle)
  *   - journal_submit_inode_data_buffers (no journal handle)
- *   - shrink_page_list via the kswapd/direct reclaim (no journal handle)
+ *   - shrink_page_list via the kswapd (no journal handle)
  *   - grab_page_cache when doing write_begin (have journal handle)
  *
  * We don't do any block allocation in this function. If we have page with
@@ -2148,10 +2148,10 @@ static int ext4_writepage(struct page *page,
 		    (inode->i_sb->s_blocksize == PAGE_SIZE)) {
 			/*
 			 * For memory cleaning there's no point in writing only
-			 * some buffers. So just bail out. Warn if we came here
-			 * from direct reclaim.
+			 * some buffers. So just bail out. It is a bug if we
+			 * came here from direct reclaim.
 			 */
-			WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD))
+			BUG_ON((current->flags & (PF_MEMALLOC|PF_KSWAPD))
 							== PF_MEMALLOC);
 			unlock_page(page);
 			return 0;
-- 
1.8.3.1

