Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39900 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbeJICqX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 22:46:23 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 2/3] ext4: hard fail dax mount on unsupported devices
Date: Mon,  8 Oct 2018 14:32:48 -0500
Message-Id: <1539027169-23332-3-git-send-email-sandeen@sandeen.net>
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
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5863fd2..bf0bea5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3821,12 +3821,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		if (ext4_has_feature_inline_data(sb)) {
 			ext4_msg(sb, KERN_ERR, "Cannot use DAX on a filesystem"
 					" that may contain inline data");
-			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
+			goto failed_mount;
 		}
 		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
 			ext4_msg(sb, KERN_ERR,
-				"DAX unsupported by block device. Turning off DAX.");
-			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
+				"DAX unsupported by block device.");
+			goto failed_mount;
 		}
 	}
 
-- 
1.8.3.1
