Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:34563 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbeKTHnT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:43:19 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] iomap: sub-block dio needs to zeroout beyond EOF
Date: Tue, 20 Nov 2018 08:17:39 +1100
Message-Id: <20181119211742.8824-3-david@fromorbit.com>
In-Reply-To: <20181119211742.8824-1-david@fromorbit.com>
References: <20181119211742.8824-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If we are soing sub-block dio that extends EOF, we need to zero
the unused tail of the block to initialise the data in it it. If we
do not zero the tail of the block, then an immediate mmap read of
the EOF block will expose stale data beyond EOF to userspace. Found
with fsx running sub-block DIO sizes vs MAPREAD/MAPWRITE operations.

Fix this by detecting if the end of the DIO write is beyond EOF
and zeroing the tail if necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 72f3864a2e6b..77c214194edf 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1677,7 +1677,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		dio->submit.cookie = submit_bio(bio);
 	} while (nr_pages);
 
-	if (need_zeroout) {
+	/*
+	 * We need to zeroout the tail of a sub-block write if the extent type
+	 * requires zeroing or the write extends beyond EOF. If we don't zero
+	 * the block tail in the latter case, we can expose stale data via mmap
+	 * reads of the EOF block.
+	 */
+	if (need_zeroout ||
+	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
 		/* zero out from the end of the write to the end of the block */
 		pad = pos & (fs_block_size - 1);
 		if (pad)
-- 
2.19.1
