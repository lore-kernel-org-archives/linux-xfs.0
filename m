Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:32911 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728500AbfHACSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 22:18:04 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/24] xfs: eagerly free shadow buffers to reduce CIL footprint
Date: Thu,  1 Aug 2019 12:17:43 +1000
Message-Id: <20190801021752.4986-16-david@fromorbit.com>
In-Reply-To: <20190801021752.4986-1-david@fromorbit.com>
References: <20190801021752.4986-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The CIL can pin a lot of memory and effectively defines the lower
free memory boundary of operation for XFS. The way we hang onto
log item shadow buffers "just in case" effectively doubles the
memory footprint of the CIL for dubious reasons.

That is, we hang onto the old shadow buffer in case the next time
we log the item it will fit into the shadow buffer and we won't have
to allocate a new one. However, we only ever tend to grow dirty
objects in the CIL through relogging, so once we've allocated a
larger buffer the old buffer we set as a shadow buffer will never
get reused as the amount we log never decreases until the item is
clean. And then for buffer items we free the log item and the shadow
buffers, anyway. Inode items will hold onto their shadow buffer
until they are reclaimed - this could double the inode's memory
footprint for it's lifetime...

Hence we should just free the old log item buffer when we replace it
with a new shadow buffer rather than storing it for later use. It's
not useful, get rid of it as early as possible.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index fa5602d0fd7f..1863a9bdf4a9 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -238,9 +238,7 @@ xfs_cil_prepare_item(
 	/*
 	 * If there is no old LV, this is the first time we've seen the item in
 	 * this CIL context and so we need to pin it. If we are replacing the
-	 * old_lv, then remove the space it accounts for and make it the shadow
-	 * buffer for later freeing. In both cases we are now switching to the
-	 * shadow buffer, so update the the pointer to it appropriately.
+	 * old_lv, then remove the space it accounts for and free it.
 	 */
 	if (!old_lv) {
 		if (lv->lv_item->li_ops->iop_pin)
@@ -251,7 +249,8 @@ xfs_cil_prepare_item(
 
 		*diff_len -= old_lv->lv_bytes;
 		*diff_iovecs -= old_lv->lv_niovecs;
-		lv->lv_item->li_lv_shadow = old_lv;
+		kmem_free(old_lv);
+		lv->lv_item->li_lv_shadow = NULL;
 	}
 
 	/* attach new log vector to log item */
-- 
2.22.0
