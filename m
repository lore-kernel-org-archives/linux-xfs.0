Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35087 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752253AbdIRN54 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 09:57:56 -0400
Received: by mail-pg0-f65.google.com with SMTP id j16so287189pga.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 06:57:56 -0700 (PDT)
From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Subject: [PATCH v2] xfs: Output warning message when discard option was enabled even though the device does not support discard
Date: Mon, 18 Sep 2017 22:57:38 +0900
Message-Id: <20170918135738.14642-1-nakayamakenjiro@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com, Kenjiro Nakayama <nakayamakenjiro@gmail.com>

In order to using discard function, it is necessary that not only xfs
is mounted with discard option, but also the discard function is
supported by the device. Current code doesn't output any message when
users mount with discard option on unsupported device, so it is
difficult to notice that it was not enabled actually.

This patch adds the warning message to notice that discard option is
not enabled due to unsupported device when the filesystem is mounted.

Changes in v2 (Suggested by Brian Foster):
  - Move the unsupported device check into xfs_fs_fill_super().
  - Clear the discard flag when device is unsupported.

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
---
 fs/xfs/xfs_super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c996f4ae4a5f..584cf2d573ba 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1654,6 +1654,16 @@ xfs_fs_fill_super(
 		"DAX and reflink have not been tested together!");
 	}
 
+	if (mp->m_flags & XFS_MOUNT_DISCARD) {
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+
+		if (!blk_queue_discard(q)) {
+			xfs_warn(mp, "mounting with \"discard\" option, but "
+					"the device does not support discard");
+			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		}
+	}
+
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
 		if (mp->m_sb.sb_rblocks) {
 			xfs_alert(mp,
-- 
2.13.5

