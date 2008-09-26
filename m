Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 01:56:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q8uQ5m031160
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:56:26 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C26FF486CCA
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:58:00 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id muOh6xtSrCPUWj6v for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:58:00 -0700 (PDT)
Subject: [PATCH 3/10] ext4: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080926175746t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:57:46 +0900
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
 super.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-ext3/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext3/fs/ext4/super.c linux-2.6
.27-rc7-lockfs-ext4/fs/ext4/super.c
--- linux-2.6.27-rc7-lockfs-ext3/fs/ext4/super.c	2008-09-26 11:44:53.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-ext4/fs/ext4/super.c	2008-09-26 16:55:57.000000000 +0900
@@ -49,7 +49,7 @@ static int ext4_load_journal(struct supe
 			     unsigned long journal_devnum);
 static int ext4_create_journal(struct super_block *, struct ext4_super_block *,
 			       unsigned int);
-static void ext4_commit_super(struct super_block *sb,
+static int ext4_commit_super(struct super_block *sb,
 			      struct ext4_super_block *es, int sync);
 static void ext4_mark_recovery_complete(struct super_block *sb,
 					struct ext4_super_block *es);
@@ -60,9 +60,9 @@ static const char *ext4_decode_error(str
 				     char nbuf[16]);
 static int ext4_remount(struct super_block *sb, int *flags, char *data);
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf);
-static void ext4_unlockfs(struct super_block *sb);
+static int ext4_unfreeze(struct super_block *sb);
 static void ext4_write_super(struct super_block *sb);
-static void ext4_write_super_lockfs(struct super_block *sb);
+static int ext4_freeze(struct super_block *sb);
 
 
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
@@ -875,8 +875,8 @@ static const struct super_operations ext
 	.put_super	= ext4_put_super,
 	.write_super	= ext4_write_super,
 	.sync_fs	= ext4_sync_fs,
-	.write_super_lockfs = ext4_write_super_lockfs,
-	.unlockfs	= ext4_unlockfs,
+	.freeze_fs	= ext4_freeze,
+	.unfreeze_fs	= ext4_unfreeze,
 	.statfs		= ext4_statfs,
 	.remount_fs	= ext4_remount,
 	.clear_inode	= ext4_clear_inode,
@@ -2792,20 +2792,22 @@ static int ext4_create_journal(struct su
 	return 0;
 }
 
-static void ext4_commit_super(struct super_block *sb,
+static int ext4_commit_super(struct super_block *sb,
 			      struct ext4_super_block *es, int sync)
 {
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
+	int error = 0;
 
 	if (!sbh)
-		return;
+		return error;
 	es->s_wtime = cpu_to_le32(get_seconds());
 	ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext4_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync)
-		sync_dirty_buffer(sbh);
+		error = sync_dirty_buffer(sbh);
+	return error;
 }
 
 
@@ -2919,28 +2921,39 @@ static int ext4_sync_fs(struct super_blo
  * LVM calls this function before a (read-only) snapshot is created.  This
  * gives us a chance to flush the journal completely and mark the fs clean.
  */
-static void ext4_write_super_lockfs(struct super_block *sb)
+static int ext4_freeze(struct super_block *sb)
 {
+	int error = 0;
+	journal_t *journal;
 	sb->s_dirt = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		journal_t *journal = EXT4_SB(sb)->s_journal;
+		journal = EXT4_SB(sb)->s_journal;
 
 		/* Now we set up the journal barrier. */
 		jbd2_journal_lock_updates(journal);
-		jbd2_journal_flush(journal);
+		error = jbd2_journal_flush(journal);
+		if (error)
+			goto out;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
-		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
+		error = ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
+		if (error)
+			goto out;
 	}
+	return 0;
+
+out:
+	jbd2_journal_unlock_updates(journal);
+	return error;
 }
 
 /*
  * Called by LVM after the snapshot is done.  We need to reset the RECOVER
  * flag here, even though the filesystem is not technically dirty yet.
  */
-static void ext4_unlockfs(struct super_block *sb)
+static int ext4_unfreeze(struct super_block *sb)
 {
 	if (!(sb->s_flags & MS_RDONLY)) {
 		lock_super(sb);
@@ -2950,6 +2963,7 @@ static void ext4_unlockfs(struct super_b
 		unlock_super(sb);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	}
+	return 0;
 }
 
 static int ext4_remount(struct super_block *sb, int *flags, char *data)
