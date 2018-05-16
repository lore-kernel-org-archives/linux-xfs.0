Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:47093 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752433AbeEPGps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 02:45:48 -0400
Received: by mail-pf0-f194.google.com with SMTP id p12-v6so1291148pff.13
        for <linux-xfs@vger.kernel.org>; Tue, 15 May 2018 23:45:47 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] iomap: don't allow holes in swapfiles
Date: Tue, 15 May 2018 23:45:38 -0700
Message-Id: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>

From: Omar Sandoval <osandov@fb.com>

generic_swapfile_activate() doesn't allow holes, so we should be
consistent here. This is also a bit safer: if the user creates a
swapfile with, say, truncate -s $SIZE followed by mkswap, they should
really get an error and not much less swap space than they expected.
swapon(8) will error out before calling swapon(2) if the file has holes,
anyways.

Fixes: 9d93388b0afe ("iomap: add a swapfile activation function")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Hey, Darrick, I noticed this while writing up a generic xfstest to test
that the Btrfs swap support patches don't allow a swapfile with holes.
It'd be nice if we were all consistent :) This is based on
xfs-linux/for-next. Feel free to fold it in to your patch or apply it
separately as you see fit. Thanks!

 fs/iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d193390a1c20..ba559adaa327 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1214,9 +1214,9 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
 	struct iomap_swapfile_info *isi = data;
 	int error;
 
-	/* Skip holes. */
+	/* No holes. */
 	if (iomap->type == IOMAP_HOLE)
-		goto out;
+		goto err;
 
 	/* Only one bdev per swap file. */
 	if (iomap->bdev != isi->sis->bdev)
-- 
2.17.0

