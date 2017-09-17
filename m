Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34028 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbdIQHdF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 03:33:05 -0400
Received: by mail-pg0-f67.google.com with SMTP id v82so3518666pgb.1
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2017 00:33:05 -0700 (PDT)
From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Subject: [PATCH] xfs: Output warning message when discard option was enabled even though the device does not support discard
Date: Sun, 17 Sep 2017 16:32:52 +0900
Message-Id: <20170917073252.15432-1-nakayamakenjiro@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Kenjiro Nakayama <nakayamakenjiro@gmail.com>

In order to using discard function, it is necessary that not only xfs
is mounted with discard option, but also the discard function is
supported by the device. Current code doesn't output any message when
users mount with discard option on unsupported device, so it is
difficult to notice that it was not enabled actually.

This patch adds the warning message to notice that discard option is
not enabled due to unsupported device when the filesystem is mounted.

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
---
 fs/xfs/xfs_super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c996f4ae4a5f..60397f9cc786 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -407,6 +407,13 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 #endif
+	if (mp->m_flags & XFS_MOUNT_DISCARD) {
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+
+		if (!blk_queue_discard(q))
+			xfs_warn(mp, "mounting with \"discard\" option, but "
+					"the device does not support discard");
+	}
 
 	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
 		xfs_warn(mp, "sunit and swidth must be specified together");
-- 
2.13.5

