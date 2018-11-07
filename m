Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63760 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbeKGQBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:12 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/16] iomap: Don't mark partial pages zeroing uptodate for zero-around
Date: Wed,  7 Nov 2018 17:31:22 +1100
Message-Id: <20181107063127.3902-12-david@fromorbit.com>
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

When zero-around stops short of a full block, such as when zeroing
to a new EOF, iomap_zero() triggers the partial page read code in
__iomap_write_begin.

Because we are over an unmapped range, the code will zero the
portion that we would have read and then marks the page up to date.
Unfortunately, this defeats the zero-around code that looks for
pages that are not up to date for zeroing, and hence the zero-around
fails to zero the "unread" portion of the page and exposes stale
data.

Hence if we are doing read-around and we zero a partial page, do
not mark it up to date so that the zero-around will zero the
remaining section of the page.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d572e57c5caa..41922fc775c4 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -592,7 +592,13 @@ iomap_read_page_sync(struct inode *inode, loff_t block_start, struct page *page,
 
 	if (iomap->type != IOMAP_MAPPED || block_start >= i_size_read(inode)) {
 		zero_user_segments(page, poff, from, to, poff + plen);
-		iomap_set_range_uptodate(page, poff, plen);
+		/*
+		 * if this is zero-around, we don't want to mark the page
+		 * uptodate here  because this is only a partial page zeroing
+		 * and there's still more data to be written into the page.
+		 */
+		if (!(iomap->flags & IOMAP_F_ZERO_AROUND))
+			iomap_set_range_uptodate(page, poff, plen);
 		return 0;
 	}
 
-- 
2.19.1
