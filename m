Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 01:57:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q8uvU5031587
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:56:57 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93DA51AF433D
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:58:31 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id GfmO9mtnnJspxTq3 for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:58:31 -0700 (PDT)
Subject: [PATCH 5/10] gfs2: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080926175821t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:58:21 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Changed write_super_lockfs so that it returns an error in case of an failure.
unlockfs always returns 0.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 ops_super.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-reiserfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-reiserfs/fs/gfs2/ops_super
.c linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c
--- linux-2.6.27-rc7-lockfs-reiserfs/fs/gfs2/ops_super.c	2008-09-26 12:24:01.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c	2008-09-26 17:02:06.000000000 +0900
@@ -161,18 +161,18 @@ static int gfs2_sync_fs(struct super_blo
 }
 
 /**
- * gfs2_write_super_lockfs - prevent further writes to the filesystem
+ * gfs2_freeze - prevent further writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static void gfs2_write_super_lockfs(struct super_block *sb)
+static int gfs2_freeze(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
 
 	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return;
+		return -EINVAL;
 
 	for (;;) {
 		error = gfs2_freeze_fs(sdp);
@@ -192,17 +192,19 @@ static void gfs2_write_super_lockfs(stru
 		fs_err(sdp, "retrying...\n");
 		msleep(1000);
 	}
+	return 0;
 }
 
 /**
- * gfs2_unlockfs - reallow writes to the filesystem
+ * gfs2_unfreeze - reallow writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static void gfs2_unlockfs(struct super_block *sb)
+static int gfs2_unfreeze(struct super_block *sb)
 {
 	gfs2_unfreeze_fs(sb->s_fs_info);
+	return 0;
 }
 
 /**
@@ -505,8 +507,8 @@ const struct super_operations gfs2_super
 	.put_super		= gfs2_put_super,
 	.write_super		= gfs2_write_super,
 	.sync_fs		= gfs2_sync_fs,
-	.write_super_lockfs 	= gfs2_write_super_lockfs,
-	.unlockfs		= gfs2_unlockfs,
+	.freeze_fs 		= gfs2_freeze,
+	.unfreeze_fs		= gfs2_unfreeze,
 	.statfs			= gfs2_statfs,
 	.remount_fs		= gfs2_remount_fs,
 	.clear_inode		= gfs2_clear_inode,
