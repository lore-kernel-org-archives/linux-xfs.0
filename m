Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:46518 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbeEPQqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 12:46:00 -0400
Received: by mail-pl0-f66.google.com with SMTP id 30-v6so746721pld.13
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 09:46:00 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 1/2] iomap: provide more useful errors for invalid swap files
Date: Wed, 16 May 2018 09:45:50 -0700
Message-Id: <9faf09627cfa469437b76edb73ac7cc822dc33c8.1526488995.git.osandov@fb.com>
In-Reply-To: <cover.1526488995.git.osandov@fb.com>
References: <cover.1526488995.git.osandov@fb.com>
In-Reply-To: <cover.1526488995.git.osandov@fb.com>
References: <cover.1526488995.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

Currently, for an invalid swap file, we print the same error message
regardless of the reason. This isn't very useful for an admin, who will
likely want to know why exactly they can't use their swap file. So,
let's add specific error messages for each reason, and also move the
bdev check after the flags checks, since the latter are more
fundamental.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/iomap.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d193390a1c20..318724375ffe 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1218,22 +1218,32 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
 	if (iomap->type == IOMAP_HOLE)
 		goto out;
 
-	/* Only one bdev per swap file. */
-	if (iomap->bdev != isi->sis->bdev)
-		goto err;
-
 	/* Only real or unwritten extents. */
-	if (iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN)
-		goto err;
+	if ((iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN) ||
+	    iomap->addr == IOMAP_NULL_ADDR) {
+		pr_err("swapon: file has unallocated extents\n");
+		return -EINVAL;
+	}
 
 	/* No uncommitted metadata or shared blocks or inline data. */
-	if (iomap->flags & (IOMAP_F_DIRTY | IOMAP_F_SHARED |
-			    IOMAP_F_DATA_INLINE))
-		goto err;
+	if (iomap->flags & IOMAP_F_DIRTY) {
+		pr_err("swapon: file is not committed\n");
+		return -EINVAL;
+	}
+	if (iomap->flags & IOMAP_F_SHARED) {
+		pr_err("swapon: file has shared extents\n");
+		return -EINVAL;
+	}
+	if (iomap->flags & IOMAP_F_DATA_INLINE) {
+		pr_err("swapon: file is inline\n");
+		return -EINVAL;
+	}
 
-	/* No null physical addresses. */
-	if (iomap->addr == IOMAP_NULL_ADDR)
-		goto err;
+	/* Only one bdev per swap file. */
+	if (iomap->bdev != isi->sis->bdev) {
+		pr_err("swapon: file is on multiple devices\n");
+		return -EINVAL;
+	}
 
 	if (isi->iomap.length == 0) {
 		/* No accumulated extent, so just store it. */
@@ -1250,9 +1260,6 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
 	}
 out:
 	return count;
-err:
-	pr_err("swapon: file cannot be used for swap\n");
-	return -EINVAL;
 }
 
 /*
-- 
2.17.0

