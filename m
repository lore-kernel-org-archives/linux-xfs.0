Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35602 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbeEPQqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 12:46:02 -0400
Received: by mail-pl0-f67.google.com with SMTP id i5-v6so758791plt.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 09:46:01 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 2/2] iomap: don't allow holes in swapfiles
Date: Wed, 16 May 2018 09:45:51 -0700
Message-Id: <c481d763f5c6e6705c0b75b539cba81f90025d40.1526488995.git.osandov@fb.com>
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

generic_swapfile_activate() doesn't allow holes, so we should be
consistent here. This is also a bit safer: if the user creates a
swapfile with, say, truncate -s $SIZE followed by mkswap, they should
really get an error and not much less swap space than they expected.
swapon(8) will error out before calling swapon(2) if the file has holes,
anyways.

Fixes: 9d93388b0afe ("iomap: add a swapfile activation function")
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/iomap.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 318724375ffe..5a1099d935c3 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1214,10 +1214,6 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
 	struct iomap_swapfile_info *isi = data;
 	int error;
 
-	/* Skip holes. */
-	if (iomap->type == IOMAP_HOLE)
-		goto out;
-
 	/* Only real or unwritten extents. */
 	if ((iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN) ||
 	    iomap->addr == IOMAP_NULL_ADDR) {
@@ -1258,7 +1254,6 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
 			return error;
 		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
 	}
-out:
 	return count;
 }
 
-- 
2.17.0

