Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAB3C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 05:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiKWF61 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 00:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbiKWF6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 00:58:21 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5F4D2347
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 21:58:19 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id y14-20020a17090a2b4e00b002189a1b84d4so939180pjc.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 21:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SymDsjIxv7azsvcTG0gLBHxZaueppF5VkHFKSnkg/EU=;
        b=BEOd6hIPYCtUi7/43XwnaRgcHZvI5AYE5DMqXgvvwyBaMWcPGAlqPVW2ZWze5QwRd7
         5iayNcib3cjcKX6DxGR7laF2sd7VDYTBLkY8pDAgW4aMqYPVyLL1jaHijcSxceHQGQwj
         kpyLuy3AGX+jc+cDIPnDqohmb7O1NgyIOVRM4qdxmr4hXV5YwMPSOGZHYP2aULn4wrKq
         m5O0wffT5CZD+QXilv4mpovgoMbnCJI8WVXynI+IE8K3kzTGWda7DkhQlUYkCWAZC1Ei
         j+pP1g30pM6YvxPIIWuIN0DWpk0gNXVVB0kfE5EVt/EHfH6tYmLAXQ4pLIjt9e7YNw6t
         sfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SymDsjIxv7azsvcTG0gLBHxZaueppF5VkHFKSnkg/EU=;
        b=eqog4edvrzTrcAVWUnuK/knzzhlX7eb7HQesFTVbmhvNkGqadYGIgeFj/j54PpDZQT
         0dve4y3XNOeLh/nqGD+nwH8LcSenN9xsE+X8sZzTn66HvTNREM3GTL779HoCKTuN98EC
         ULoTLHnAPOFZXw7JKYCCz/mhs5JnY94U5kU+BrWjnYtBgRnpsERyqcKIorJqqDj9MaLQ
         PIBljo3jgp58ytlWzhfKVZbkx0gcN7cL3WK2vIVK8DRzpqzd+g8LHjGRBWNOtqPc/xgM
         7KrWDRD6jQOFLZQMMu9ANy+XE6cL3N0vkKZnFZ3CVKzPOdUB9kWqIwheT7U27XwTad9l
         +t4A==
X-Gm-Message-State: ANoB5pkxnhBsGLeUc12g5fQVHMrwSHFfUv6sWzrx+0S9mdWx3hdVlt2Y
        1UY4hqx90vbkbgqonBcazxP4lQWAqD/mUw==
X-Google-Smtp-Source: AA0mqf6QZTB2uJ6UBRNjDD6HE4HetaEFFpVI/0SZwVEB1wDMqO6LILPPzLtP+8L6AcXZgM+HMI7Alw==
X-Received: by 2002:a17:90a:d598:b0:218:7734:499 with SMTP id v24-20020a17090ad59800b0021877340499mr29113411pju.2.1669183098786;
        Tue, 22 Nov 2022 21:58:18 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id 143-20020a621495000000b0056dde9895e2sm11724232pfu.30.2022.11.22.21.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 21:58:17 -0800 (PST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxily-00HYSV-DP; Wed, 23 Nov 2022 16:58:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1oxily-003A1a-1E;
        Wed, 23 Nov 2022 16:58:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/9] xfs: punching delalloc extents on write failure is racy
Date:   Wed, 23 Nov 2022 16:58:05 +1100
Message-Id: <20221123055812.747923-3-david@fromorbit.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221123055812.747923-1-david@fromorbit.com>
References: <20221123055812.747923-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_buffered_write_iomap_end() has a comment about the safety of
punching delalloc extents based holding the IOLOCK_EXCL. This
comment is wrong, and punching delalloc extents is not race free.

When we punch out a delalloc extent after a write failure in
xfs_buffered_write_iomap_end(), we punch out the page cache with
truncate_pagecache_range() before we punch out the delalloc extents.
At this point, we only hold the IOLOCK_EXCL, so there is nothing
stopping mmap() write faults racing with this cleanup operation,
reinstantiating a folio over the range we are about to punch and
hence requiring the delalloc extent to be kept.

If this race condition is hit, we can end up with a dirty page in
the page cache that has no delalloc extent or space reservation
backing it. This leads to bad things happening at writeback time.

To avoid this race condition, we need the page cache truncation to
be atomic w.r.t. the extent manipulation. We can do this by holding
the mapping->invalidate_lock exclusively across this operation -
this will prevent new pages from being inserted into the page cache
whilst we are removing the pages and the backing extent and space
reservation.

Taking the mapping->invalidate_lock exclusively in the buffered
write IO path is safe - it naturally nests inside the IOLOCK (see
truncate and fallocate paths). iomap_zero_range() can be called from
under the mapping->invalidate_lock (from the truncate path via
either xfs_zero_eof() or xfs_truncate_page(), but iomap_zero_iter()
will not instantiate new delalloc pages (because it skips holes) and
hence will not ever need to punch out delalloc extents on failure.

Fix the locking issue, and clean up the code logic a little to avoid
unnecessary work if we didn't allocate the delalloc extent or wrote
the entire region we allocated.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 5cea069a38b4..a2e45ea1b0cb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1147,6 +1147,10 @@ xfs_buffered_write_iomap_end(
 		written = 0;
 	}
 
+	/* If we didn't reserve the blocks, we're not allowed to punch them. */
+	if (!(iomap->flags & IOMAP_F_NEW))
+		return 0;
+
 	/*
 	 * start_fsb refers to the first unused block after a short write. If
 	 * nothing was written, round offset down to point at the first block in
@@ -1158,27 +1162,28 @@ xfs_buffered_write_iomap_end(
 		start_fsb = XFS_B_TO_FSB(mp, offset + written);
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
+	/* Nothing to do if we've written the entire delalloc extent */
+	if (start_fsb >= end_fsb)
+		return 0;
+
 	/*
-	 * Trim delalloc blocks if they were allocated by this write and we
-	 * didn't manage to write the whole range.
-	 *
-	 * We don't need to care about racing delalloc as we hold i_mutex
-	 * across the reserve/allocate/unreserve calls. If there are delalloc
-	 * blocks in the range, they are ours.
+	 * Lock the mapping to avoid races with page faults re-instantiating
+	 * folios and dirtying them via ->page_mkwrite between the page cache
+	 * truncation and the delalloc extent removal. Failing to do this can
+	 * leave dirty pages with no space reservation in the cache.
 	 */
-	if ((iomap->flags & IOMAP_F_NEW) && start_fsb < end_fsb) {
-		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
-					 XFS_FSB_TO_B(mp, end_fsb) - 1);
-
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-					       end_fsb - start_fsb);
-		if (error && !xfs_is_shutdown(mp)) {
-			xfs_alert(mp, "%s: unable to clean up ino %lld",
-				__func__, ip->i_ino);
-			return error;
-		}
+	filemap_invalidate_lock(inode->i_mapping);
+	truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
+				 XFS_FSB_TO_B(mp, end_fsb) - 1);
+
+	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+				       end_fsb - start_fsb);
+	filemap_invalidate_unlock(inode->i_mapping);
+	if (error && !xfs_is_shutdown(mp)) {
+		xfs_alert(mp, "%s: unable to clean up ino %lld",
+			__func__, ip->i_ino);
+		return error;
 	}
-
 	return 0;
 }
 
-- 
2.37.2

