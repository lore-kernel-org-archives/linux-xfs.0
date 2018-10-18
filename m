Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727680AbeJRVST (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Oct 2018 17:18:19 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] proc: Protect readers of /proc/mounts from remount
Date: Thu, 18 Oct 2018 15:17:09 +0200
Message-Id: <20181018131709.11976-3-jack@suse.cz>
In-Reply-To: <20181018131709.11976-1-jack@suse.cz>
References: <20181018131709.11976-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

Readers of /proc/mounts (and similar files) are currently unprotected
from concurrently running remount on the filesystem they are reporting.
This can not only result in bogus reported information but also in
confusion in filesystems ->show_options callbacks resulting in
use-after-free issues or similar (for example ext4 handling of quota
file names is prone to such races).

Fix the problem by protecting showing of mount information with
sb->s_umount semaphore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/mount.h     |  1 +
 fs/namespace.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index f39bc9da4d73..5ca0a9e714b3 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -134,6 +134,7 @@ struct proc_mounts {
 	void *cached_mount;
 	u64 cached_event;
 	loff_t cached_index;
+	struct super_block *locked_sb;
 };
 
 extern const struct seq_operations mounts_op;
diff --git a/fs/namespace.c b/fs/namespace.c
index 99186556f8d3..31270baa4c0b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1237,26 +1237,68 @@ struct vfsmount *mnt_clone_internal(const struct path *path)
 }
 
 #ifdef CONFIG_PROC_FS
+
+static bool mounts_trylock_super(struct proc_mounts *p, struct super_block *sb)
+{
+	if (p->locked_sb == sb)
+		return true;
+	if (p->locked_sb) {
+		drop_super(p->locked_sb);
+		p->locked_sb = NULL;
+	}
+	if (down_read_trylock(&sb->s_umount)) {
+		hold_sb(sb);
+		p->locked_sb = sb;
+		return true;
+	}
+	return false;
+}
+
 /* iterator; we want it to have access to namespace_sem, thus here... */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_mounts *p = m->private;
+	struct mount *mount;
+	struct super_block *sb;
 
+restart:
 	down_read(&namespace_sem);
 	if (p->cached_event == p->ns->event) {
 		void *v = p->cached_mount;
 		if (*pos == p->cached_index)
-			return v;
+			goto lock_sb;
 		if (*pos == p->cached_index + 1) {
 			v = seq_list_next(v, &p->ns->list, &p->cached_index);
-			return p->cached_mount = v;
+			p->cached_mount = v;
+			goto lock_sb;
 		}
 	}
 
 	p->cached_event = p->ns->event;
 	p->cached_mount = seq_list_start(&p->ns->list, *pos);
 	p->cached_index = *pos;
-	return p->cached_mount;
+lock_sb:
+	if (!p->cached_mount)
+		return NULL;
+	mount = list_entry(p->cached_mount, struct mount, mnt_list);
+	sb = mount->mnt.mnt_sb;
+	if (mounts_trylock_super(p, sb))
+		return p->cached_mount;
+	/*
+	 * Trylock failed. Since namepace_sem ranks below s_umount (through
+	 * sb->s_umount > dir->i_rwsem > namespace_sem in the mount path), we
+	 * have to drop it, wait for s_umount and then try again to guarantee
+	 * forward progress.
+	 */
+	hold_sb(sb);
+	up_read(&namespace_sem);
+	down_read(&sb->s_umount);
+	/*
+	 * Sb may be dead by now but that just means we won't find it in any
+	 * mount and drop lock & reference anyway.
+	 */
+	p->locked_sb = sb;
+	goto restart;
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
@@ -1277,7 +1319,16 @@ static int m_show(struct seq_file *m, void *v)
 {
 	struct proc_mounts *p = m->private;
 	struct mount *r = list_entry(v, struct mount, mnt_list);
-	return p->show(m, &r->mnt);
+	struct super_block *sb = r->mnt.mnt_sb;
+	int ret;
+
+	/* Protect show function against racing remount */
+	if (!mounts_trylock_super(p, sb))
+		return -EAGAIN;
+	ret = p->show(m, &r->mnt);
+	drop_super(sb);
+	p->locked_sb = NULL;
+	return ret;
 }
 
 const struct seq_operations mounts_op = {
-- 
2.16.4
