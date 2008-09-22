Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 03:56:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MAuMmf015483
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:56:23 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2333E1280124
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:57:56 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id L5ioLmRhf1AFYW1M for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:57:56 -0700 (PDT)
Subject: [PATCH 7/10] jfs: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080922195742t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 22 Sep 2008 19:57:42 +0900
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
 super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-gfs2/Documentation/dontdiff linux-2.6.27-rc7-lockfs-gfs2/fs/jfs/super.c linux-2.6.
27-rc7-lockfs-jfs/fs/jfs/super.c
--- linux-2.6.27-rc7-lockfs-gfs2/fs/jfs/super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-jfs/fs/jfs/super.c	2008-09-22 11:02:34.000000000 +0900
@@ -543,7 +543,7 @@ out_kfree:
 	return ret;
 }
 
-static void jfs_write_super_lockfs(struct super_block *sb)
+static int jfs_write_super_lockfs(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
@@ -553,9 +553,10 @@ static void jfs_write_super_lockfs(struc
 		lmLogShutdown(log);
 		updateSuper(sb, FM_CLEAN);
 	}
+	return 0;
 }
 
-static void jfs_unlockfs(struct super_block *sb)
+static int jfs_unlockfs(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
@@ -568,6 +569,7 @@ static void jfs_unlockfs(struct super_bl
 		else
 			txResume(sb);
 	}
+	return 0;
 }
 
 static int jfs_get_sb(struct file_system_type *fs_type,
