Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:44246 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751760AbeGCELj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 00:11:39 -0400
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: [PATCH 2/2] fs: xfs: use BUG_ON if writepage call comes from direct reclaim
Date: Tue,  3 Jul 2018 12:11:19 +0800
Message-Id: <1530591079-33813-2-git-send-email-yang.shi@linux.alibaba.com>
In-Reply-To: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
References: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mgorman@techsingularity.net, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, dchinner@redhat.com, akpm@linux-foundation.org
Cc: yang.shi@linux.alibaba.com, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

direct reclaim doesn't write out filesystem page, only kswapd could do
this. So, if it is called from direct relaim, it is definitely a bug.

And, Mel Gorman mentioned "Ultimately, this will be a BUG_ON." in commit
94054fa3fca1fd78db02cb3d68d5627120f0a1d4 ("xfs: warn if direct reclaim
tries to writeback pages"),

It has been many years since that commit, so it should be safe to
elevate WARN_ON to BUG_ON now.

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
---
 fs/xfs/xfs_aops.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8eb3ba3..7efc2d2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1080,11 +1080,9 @@ static inline int xfs_bio_add_buffer(struct bio *bio, struct buffer_head *bh)
 	 * allow reclaim from kswapd as the stack usage there is relatively low.
 	 *
 	 * This should never happen except in the case of a VM regression so
-	 * warn about it.
+	 * BUG about it.
 	 */
-	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
-			PF_MEMALLOC))
-		goto redirty;
+	BUG_ON((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC);
 
 	/*
 	 * Given that we do not allow direct reclaim to call us, we should
-- 
1.8.3.1

