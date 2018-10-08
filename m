Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39902 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbeJICqX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 22:46:23 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 3/3] ext2: hard fail dax mount on unsupported devices
Date: Mon,  8 Oct 2018 14:32:49 -0500
Message-Id: <1539027169-23332-4-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

As dax inches closer to production use, an administrator should not
be surprised by silently disabling the feature they asked for.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 fs/ext2/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 73bd58f..b9471c0 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -967,8 +967,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
 		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
 			ext2_msg(sb, KERN_ERR,
-				"DAX unsupported by block device. Turning off DAX.");
-			sbi->s_mount_opt &= ~EXT2_MOUNT_DAX;
+				"DAX unsupported by block device.");
+			goto failed_mount;
 		}
 	}
 
-- 
1.8.3.1
