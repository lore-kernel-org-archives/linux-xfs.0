Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 01:57:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q8vVot031973
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:57:32 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A2ED1AF4374
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:59:05 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id jo98N9PQ6l0GckiF for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:59:05 -0700 (PDT)
Subject: [PATCH 7/10] reiserfs: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080926175854t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:58:54 +0900
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
 super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-xfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-xfs/fs/reiserfs/super.c linux-2
.6.27-rc7-lockfs-reiserfs/fs/reiserfs/super.c
--- linux-2.6.27-rc7-lockfs-xfs/fs/reiserfs/super.c	2008-09-26 12:19:24.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-reiserfs/fs/reiserfs/super.c	2008-09-26 17:00:18.000000000 +0900
@@ -83,7 +83,7 @@ static void reiserfs_write_super(struct 
 	reiserfs_sync_fs(s, 1);
 }
 
-static void reiserfs_write_super_lockfs(struct super_block *s)
+static int reiserfs_freeze(struct super_block *s)
 {
 	struct reiserfs_transaction_handle th;
 	reiserfs_write_lock(s);
@@ -101,11 +101,13 @@ static void reiserfs_write_super_lockfs(
 	}
 	s->s_dirt = 0;
 	reiserfs_write_unlock(s);
+	return 0;
 }
 
-static void reiserfs_unlockfs(struct super_block *s)
+static int reiserfs_unfreeze(struct super_block *s)
 {
 	reiserfs_allow_writes(s);
+	return 0;
 }
 
 extern const struct in_core_key MAX_IN_CORE_KEY;
@@ -613,8 +615,8 @@ static const struct super_operations rei
 	.put_super = reiserfs_put_super,
 	.write_super = reiserfs_write_super,
 	.sync_fs = reiserfs_sync_fs,
-	.write_super_lockfs = reiserfs_write_super_lockfs,
-	.unlockfs = reiserfs_unlockfs,
+	.freeze_fs = reiserfs_freeze,
+	.unfreeze_fs = reiserfs_unfreeze,
 	.statfs = reiserfs_statfs,
 	.remount_fs = reiserfs_remount,
 	.show_options = generic_show_options,
