Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:1838 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbeKGQBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:14 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/16] iomap: enable zero-around for iomap_zero_range()
Date: Wed,  7 Nov 2018 17:31:21 +1100
Message-Id: <20181107063127.3902-11-david@fromorbit.com>
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

iomap_zero_range() is used to zero the range between the old EOF
and the new EOF when the file is truncated up or written beyond the
existing EOF. With block size larger than page size, we can't assume
that because we've mapped a hole or an unwritten extent that there
is no data needing to be written in the portion of the block inside
the old EOF. Hence we need to zero to closer of the end of the block
or the new EOF so that subsequent reads of the range between the old
and new EOF are do not expose stale data.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 56f40177ed17..d572e57c5caa 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -780,7 +780,14 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 	if (status)
 		return status;
 
-	zero_user(page, offset, bytes);
+	/*
+	 * zero-around is conditional on whether the page we found already
+	 * contains data or not. If it's up to date, it contains data and we
+	 * should not zero it. We still need to mark it dirty to get that data
+	 * written, however.
+	 */
+	if (!(iomap->flags & IOMAP_F_ZERO_AROUND) || !PageUptodate(page))
+		zero_user(page, offset, bytes);
 	mark_page_accessed(page);
 
 	return iomap_write_end(inode, pos, bytes, bytes, page, iomap);
@@ -877,11 +884,41 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 {
 	bool *did_zero = data;
 	loff_t written = 0;
+	loff_t old_count = 0;
 	int status;
 
 	/* already zeroed?  we're done. */
-	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
-		return count;
+	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN) {
+
+		if (!iomap_need_zero_around(iomap))
+			return count;
+
+		/*
+		 * Because we landed in a hole, we only need to zero to the end
+		 * of this block. We'll do that by the loop below, but we need
+		 * to trim count here so the zero-around only acts on this
+		 * block, too.
+		 *
+		 * The magic "pos + 1" is needed because we want the offset of
+		 * the next block after pos. If pos is already aligned to the
+		 * block size, the round_up() returns the same value, not that
+		 * of the next highest multiple. Hence we have to add 1 to pos
+		 * to get round_up() to behave as we want.
+		 */
+		old_count = count;
+		if (pos + count > round_up(pos + 1, i_blocksize(inode)))
+			count = round_up(pos + 1, i_blocksize(inode)) - pos;
+
+		status = iomap_zero_around(inode, pos, count, iomap);
+		if (status)
+			return status;
+
+		/*
+		 * now clear the zero-around flag so that the range requested
+		 * in this block will be unconditionally zeroed.
+		 */
+		iomap->flags &= ~IOMAP_F_ZERO_AROUND;
+	}
 
 	do {
 		unsigned offset, bytes;
@@ -903,7 +940,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 			*did_zero = true;
 	} while (count > 0);
 
-	return written;
+	return old_count ? old_count : written;
 }
 
 int
-- 
2.19.1
