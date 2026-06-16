Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C4843E9FE;
	Tue, 16 Jun 2026 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618944; cv=none; b=H2wlJXU46cyV6SZHVR0fNAFDc6xFKTHC+zMpd8FsfidCgGQ6EQxI3RcBfNf+c1Smws4lxJSR+rLhr4GLt+rjwh2xk2weqOn/d03vElY1Zm52BfsfmSblVvupSJAUdyHEqKifqU8olUTlxMMUaksu7mT6acrCIyOcnE5rBUPB+zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618944; c=relaxed/simple;
	bh=aCQpDgovIStdL2twMuU6K5L0JfaSCl14DVz4s/14ctk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s0iM1JtANKErL+8F7i1M3JIfsKZy/cPE3ejwSCmA6VMQezSIwWVEhn2IhqlLpivhk5S7HnHhfg5WWtRQi1ktid48HIbqrBVZWR7pJsKkNON3qbdWLDszGDXZC4b3gpGvz2E88Khx+NCbVX1dbjyl5ifElrq8qpUvf6EN1JqocfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1kG+q+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1kG+q+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6493A1F00ADE;
	Tue, 16 Jun 2026 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618941;
	bh=McE+kxkeDdz+ygzUoOoQSlBlJSu4C5ZVbP/eQgLFN3A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S1kG+q+Sm0gy2xtvtjfOIhCT55nRhAoaWjbEkFsnNJIjq4uPgoVn6/rxz+YE8FKL+
	 75QQxHw3WnV3EahFX0EOx3BxEk5RZY1J+0yXmklLhg806b8auaIX+ooc6yrYFFaqZv
	 uhrxkanWXUw0/JQigsXhGMlap+ie9NNi3uLssz+vAdm3qdyOGoST2sZjI8q1Pgwr2W
	 yhYbD+Mzp4HWlMYcBpTZJA06H1AJgiDPi8+rvYs+qoryCRJgWPb5FRE9hsFvqzZHDG
	 lUURWSe4YaEtrkVQ9g1WYknIgZ3mUhLffVDFqF2Sl6YqY9BVTPrzXocpk254qd8IO9
	 7VYFFRb5IAkQg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:23 +0200
Subject: [PATCH RFC v2 07/18] fs: maintain a global device-to-superblock
 table
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-7-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=9141; i=brauner@kernel.org;
 h=from:subject:message-id; bh=aCQpDgovIStdL2twMuU6K5L0JfaSCl14DVz4s/14ctk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzTmbZFL3r3nd+HQ57+dckpjymYuyo6RiLrxsJ5X
 q9+mba6dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExES4CRYcvv+U1yXyJfO916
 N6+jiamsSz7++sGb74uONavzzrpX38rwPyqwSevGzBMLzmmIGkT6rmOYsFJh8Znz7+fo2EluvcG
 0gx0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
forces the holder to be exactly one superblock and prevents several
superblocks from sharing one block device. That's what erofs is doing.

As a first step introduce a global dev_t-keyed rhltable mapping each
device to the superblock(s) using it. The entry is preallocated in
alloc_super() and registered under sb->s_dev by the set callback through
set_anon_super() and set_bdev_super(), the two helpers every set
callback assigns s_dev through. Registration is the final fallible act
of a set callback, so an insert failure unwinds through sget_fc()'s
existing set-failure path: the fs_context keeps ownership of s_fs_info
and the callers' error paths stay correct. set_anon_super() releases
the anonymous dev it allocated when registration fails. Unwinding
through deactivate_locked_super() instead would run kill_sb() and free
s_fs_info behind the caller's back: nfs and ceph free that object
through a local pointer when sget_fc() fails and would double-free.

The superblock stashes the entry in sb->s_super_dev and
kill_super_notify() drops the claim through it, so teardown doesn't
depend on s_dev staying stable; an entry that was never registered is
freed together with the superblock in destroy_super_work().

Each table entry holds a passive reference (s_passive) on its
superblock, so the struct stays valid for as long as the entry is
reachable. Entries are claim-counted through sd_ref: additional claims
on the same (device, superblock) pair share the entry, and the unlink
is deferred to the last put, so a later iteration cursor never resumes
from a removed node.

The table is initialized from mnt_init(): the first superblocks (the
tmpfs shm mount and rootfs) are created from start_kernel() long before
any initcall runs, so an initcall would be too late.

The table has no readers yet; the fs_holder_ops callbacks are switched
over once all devices a filesystem claims are registered.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/internal.h                  |   1 +
 fs/namespace.c                 |   2 +
 fs/super.c                     | 102 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs/super_types.h |   2 +
 4 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index d77578d66d42..83eb3e2a0f85 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -137,6 +137,7 @@ extern int reconfigure_super(struct fs_context *);
 extern bool super_trylock_shared(struct super_block *sb);
 struct super_block *user_get_super(dev_t, bool excl);
 void put_super(struct super_block *sb);
+void __init super_dev_init(void);
 extern bool mount_capable(struct fs_context *);
 int sb_init_dio_done_wq(struct super_block *sb);
 
diff --git a/fs/namespace.c b/fs/namespace.c
index 3d5cd5bf3b05..7cef6dae0854 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6262,6 +6262,8 @@ void __init mnt_init(void)
 	if (!mount_hashtable || !mountpoint_hashtable)
 		panic("Failed to allocate mount hash table\n");
 
+	super_dev_init();
+
 	kernfs_init();
 
 	err = sysfs_init();
diff --git a/fs/super.c b/fs/super.c
index a771a0ad4c9a..ff5e305d0ab4 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/rhashtable.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/writeback.h>		/* for the emergency remount stuff */
@@ -272,6 +273,8 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 	return total_objects;
 }
 
+static struct super_dev *super_dev_alloc(dev_t dev, struct super_block *sb);
+
 static void destroy_super_work(struct work_struct *work)
 {
 	struct super_block *s = container_of(work, struct super_block,
@@ -279,6 +282,8 @@ static void destroy_super_work(struct work_struct *work)
 	fsnotify_sb_free(s);
 	security_sb_free(s);
 	put_user_ns(s->s_user_ns);
+	/* Only an unregistered entry is still owned by the superblock. */
+	kfree(s->s_super_dev);
 	kfree(s->s_subtype);
 	for (int i = 0; i < SB_FREEZE_LEVELS; i++)
 		percpu_free_rwsem(&s->s_writers.rw_sem[i]);
@@ -392,6 +397,10 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 		goto fail;
 	if (list_lru_init_memcg(&s->s_inode_lru, s->s_shrink))
 		goto fail;
+	s->s_super_dev = super_dev_alloc(0, s);
+	if (!s->s_super_dev)
+		goto fail;
+
 	s->s_min_writeback_pages = MIN_WRITEBACK_PAGES;
 	return s;
 
@@ -421,6 +430,77 @@ void put_super(struct super_block *s)
 	}
 }
 
+struct super_dev {
+	dev_t			sd_dev;
+	struct super_block	*sd_sb;
+	refcount_t		sd_ref;
+	struct rhlist_head	sd_node;
+	struct rcu_head		sd_rcu;
+};
+
+static struct rhltable super_dev_table;
+static const struct rhashtable_params super_dev_params = {
+	.key_len	= sizeof(dev_t),
+	.key_offset	= offsetof(struct super_dev, sd_dev),
+	.head_offset	= offsetof(struct super_dev, sd_node),
+};
+
+static struct super_dev *super_dev_alloc(dev_t dev, struct super_block *sb)
+{
+	struct super_dev *fsd;
+
+	fsd = kzalloc_obj(*fsd);
+	if (!fsd)
+		return NULL;
+	fsd->sd_dev = dev;
+	fsd->sd_sb = sb;
+	refcount_set(&fsd->sd_ref, 1);
+	return fsd;
+}
+
+static void super_dev_put(struct super_dev *fsd)
+{
+	/* Unlink only once unpinned, so a cursor never resumes from a removed node. */
+	if (fsd && refcount_dec_and_test(&fsd->sd_ref)) {
+		rhltable_remove(&super_dev_table, &fsd->sd_node, super_dev_params);
+		put_super(fsd->sd_sb);
+		kfree_rcu(fsd, sd_rcu);
+	}
+}
+
+void __init super_dev_init(void)
+{
+	if (rhltable_init(&super_dev_table, &super_dev_params))
+		panic("VFS: Cannot initialise super_dev_table\n");
+}
+
+static int super_dev_insert(struct super_dev *fsd)
+{
+	int err;
+
+	err = rhltable_insert(&super_dev_table, &fsd->sd_node, super_dev_params);
+	if (!err)
+		refcount_inc(&fsd->sd_sb->s_passive);
+	return err;
+}
+
+/* Register @sb under @sb->s_dev as the final fallible act of a set callback. */
+static int super_dev_register(struct super_block *sb)
+{
+	struct super_dev *fsd = sb->s_super_dev;
+	int err;
+
+	lockdep_assert_held(&sb_lock);
+	VFS_WARN_ON_ONCE(!sb->s_dev);
+	VFS_WARN_ON_ONCE(!fsd || fsd->sd_dev);
+
+	fsd->sd_dev = sb->s_dev;
+	err = super_dev_insert(fsd);
+	if (err)
+		fsd->sd_dev = 0;
+	return err;
+}
+
 static void kill_super_notify(struct super_block *sb)
 {
 	lockdep_assert_not_held(&sb->s_umount);
@@ -440,6 +520,12 @@ static void kill_super_notify(struct super_block *sb)
 	hlist_del_init(&sb->s_instances);
 	spin_unlock(&sb_lock);
 
+	/* Drop sget_fc()'s claim; a never-registered entry stays with the sb. */
+	if (sb->s_super_dev->sd_dev) {
+		super_dev_put(sb->s_super_dev);
+		sb->s_super_dev = NULL;
+	}
+
 	/*
 	 * Let concurrent mounts know that this thing is really dead.
 	 * We don't need @sb->s_umount here as every concurrent caller
@@ -750,6 +836,7 @@ struct super_block *sget_fc(struct fs_context *fc,
 	}
 	if (!s) {
 		spin_unlock(&sb_lock);
+
 		s = alloc_super(fc->fs_type, fc->sb_flags, user_ns);
 		if (!s)
 			return ERR_PTR(-ENOMEM);
@@ -759,11 +846,13 @@ struct super_block *sget_fc(struct fs_context *fc,
 	s->s_fs_info = fc->s_fs_info;
 	err = set(s, fc);
 	if (err) {
+		VFS_WARN_ON_ONCE(s->s_super_dev->sd_dev);
 		s->s_fs_info = NULL;
 		spin_unlock(&sb_lock);
 		destroy_unused_super(s);
 		return ERR_PTR(err);
 	}
+	VFS_WARN_ON_ONCE(!s->s_super_dev->sd_dev);
 	fc->s_fs_info = NULL;
 	s->s_type = fc->fs_type;
 	s->s_iflags |= fc->s_iflags;
@@ -1217,7 +1306,16 @@ EXPORT_SYMBOL(free_anon_bdev);
 
 int set_anon_super(struct super_block *s, void *data)
 {
-	return get_anon_bdev(&s->s_dev);
+	int error;
+
+	error = get_anon_bdev(&s->s_dev);
+	if (error)
+		return error;
+
+	error = super_dev_register(s);
+	if (error)
+		free_anon_bdev(s->s_dev);
+	return error;
 }
 EXPORT_SYMBOL(set_anon_super);
 
@@ -1303,7 +1401,7 @@ EXPORT_SYMBOL(get_tree_keyed);
 static int set_bdev_super(struct super_block *s, void *data)
 {
 	s->s_dev = *(dev_t *)data;
-	return 0;
+	return super_dev_register(s);
 }
 
 static int super_s_dev_set(struct super_block *s, struct fs_context *fc)
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 68747182abf9..c8172558750f 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -30,6 +30,7 @@ struct mount;
 struct mtd_info;
 struct quotactl_ops;
 struct shrinker;
+struct super_dev;
 struct unicode_map;
 struct user_namespace;
 struct workqueue_struct;
@@ -132,6 +133,7 @@ struct super_operations {
 struct super_block {
 	struct list_head			s_list;		/* Keep this first */
 	dev_t					s_dev;		/* search index; _not_ kdev_t */
+	struct super_dev			*s_super_dev;	/* sget_fc()'s device table claim */
 	unsigned char				s_blocksize_bits;
 	unsigned long				s_blocksize;
 	loff_t					s_maxbytes;	/* Max file size */

-- 
2.47.3

