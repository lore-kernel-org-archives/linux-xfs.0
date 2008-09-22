Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 03:56:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MAttbQ015162
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:55:56 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA66C46AE97
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:57:29 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id LR2iPMG3PJiWYAFJ for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:57:29 -0700 (PDT)
Subject: [PATCH 6/10] gfs2: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080922195718t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 22 Sep 2008 19:57:18 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

I've changed write_super_lockfs/unlockfs so that they always return
0 (success) to keep a current behavior.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 ops_super.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-ext4/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext4/fs/gfs2/ops_super.c linux
-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c
--- linux-2.6.27-rc7-lockfs-ext4/fs/gfs2/ops_super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c	2008-09-22 10:52:16.000000000 +0900
@@ -166,13 +166,13 @@ static int gfs2_sync_fs(struct super_blo
  *
  */
 
-static void gfs2_write_super_lockfs(struct super_block *sb)
+static int gfs2_write_super_lockfs(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
 
 	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return;
+		return 0;
 
 	for (;;) {
 		error = gfs2_freeze_fs(sdp);
@@ -192,6 +192,7 @@ static void gfs2_write_super_lockfs(stru
 		fs_err(sdp, "retrying...\n");
 		msleep(1000);
 	}
+	return 0;
 }
 
 /**
@@ -200,9 +201,10 @@ static void gfs2_write_super_lockfs(stru
  *
  */
 
-static void gfs2_unlockfs(struct super_block *sb)
+static int gfs2_unlockfs(struct super_block *sb)
 {
 	gfs2_unfreeze_fs(sb->s_fs_info);
+	return 0;
 }
 
 /**
