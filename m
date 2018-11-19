Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:34563 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbeKTHnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:43:18 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] iomap: FUA is wrong for DIO O_DSYNC writes into unwritten extents
Date: Tue, 20 Nov 2018 08:17:38 +1100
Message-Id: <20181119211742.8824-2-david@fromorbit.com>
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

When we write into an unwritten extent via direct IO, we dirty
metadata on IO completion to convert the unwritten extent to
written. However, when we do the FUA optimisation checks, the inode
may be clean and so we issue a FUA write into the unwritten extent.
This means we then bypass the generic_write_sync() call after
unwritten extent conversion has ben done and we don't force the
modified metadata to stable storage.

This violates O_DSYNC semantics. The window of exposure is a single
IO, as the next DIO write will see the inode has dirty metadata and
hence will not use the FUA optimisation. Calling
generic_write_sync() after completion of the second IO will also
sync the first write and it's metadata.

Fix this by avoiding the FUA optimisation when writing to unwritten
extents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 64ce240217a1..72f3864a2e6b 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1596,12 +1596,13 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 
 	if (iomap->flags & IOMAP_F_NEW) {
 		need_zeroout = true;
-	} else {
+	} else if (iomap->type == IOMAP_MAPPED) {
 		/*
-		 * Use a FUA write if we need datasync semantics, this
-		 * is a pure data IO that doesn't require any metadata
-		 * updates and the underlying device supports FUA. This
-		 * allows us to avoid cache flushes on IO completion.
+		 * Use a FUA write if we need datasync semantics, this is a pure
+		 * data IO that doesn't require any metadata updates (including
+		 * after IO completion such as unwritten extent conversion) and
+		 * the underlying device supports FUA. This allows us to avoid
+		 * cache flushes on IO completion.
 		 */
 		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
 		    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
-- 
2.19.1
