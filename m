Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:27974 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbeKGQBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:18 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/16] xfs: move writepage context warnings to writepages
Date: Wed,  7 Nov 2018 17:31:13 +1100
Message-Id: <20181107063127.3902-3-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Seeing as we don't have ->writepage anymore, we don't need reclaim
context checks on every call to xfs_do_writepage() anymore - we only
need them xfs_vm_writepages() so they are checked per writeback
context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0e1342e359ca..95e67f595f98 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -816,27 +816,6 @@ xfs_do_writepage(
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
-	/*
-	 * Refuse to write the page out if we are called from reclaim context.
-	 *
-	 * This avoids stack overflows when called from deeply used stacks in
-	 * random callers for direct reclaim or memcg reclaim.  We explicitly
-	 * allow reclaim from kswapd as the stack usage there is relatively low.
-	 *
-	 * This should never happen except in the case of a VM regression so
-	 * warn about it.
-	 */
-	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
-			PF_MEMALLOC))
-		goto redirty;
-
-	/*
-	 * Given that we do not allow direct reclaim to call us, we should
-	 * never be called while in a filesystem transaction.
-	 */
-	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
-		goto redirty;
-
 	/*
 	 * Is this page beyond the end of the file?
 	 *
@@ -921,6 +900,27 @@ xfs_vm_writepages(
 	};
 	int			ret;
 
+	/*
+	 * Refuse to write pages out if we are called from reclaim context.
+	 *
+	 * This avoids stack overflows when called from deeply used stacks in
+	 * random callers for direct reclaim or memcg reclaim.  We explicitly
+	 * allow reclaim from kswapd as the stack usage there is relatively low.
+	 *
+	 * This should never happen except in the case of a VM regression so
+	 * warn about it.
+	 */
+	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+			PF_MEMALLOC))
+		return 0;
+
+	/*
+	 * Given that we do not allow direct reclaim to call us, we should
+	 * never be called while in a filesystem transaction.
+	 */
+	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
+		return 0;
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
 	if (wpc.ioend)
-- 
2.19.1
