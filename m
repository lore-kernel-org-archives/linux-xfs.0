Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0BD3D6497;
	Tue,  2 Jun 2026 10:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395030; cv=none; b=RJ/PQbQcE8mjBRf8lQkh8i1OX5LXZkrqRd2KErOUhM22bHVwVbgDWw14gtrHzNOa1mJ58tWhiM567/cI4rCtiHxiEx4hfyEe93yO/WvYj2XmE9z7GSn97LXJwM7wx+kMYS+r4fOWbXzkP+KgSlunWGCrecIoUXOY5oZ/5TLRIMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395030; c=relaxed/simple;
	bh=MYpZz0B6HGCp0PliU5rmIIJhd2BihonSRtJLqed8TeA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aQvRjDBhHmF7cGO3R1AxfeiE1/YLT4Rq9USfgdky7HGRk9S7f+DTeRegkz6l7gnNOPjXDz5cVV2AJw6L09tlUfHtQSS5RnPDa/2YjR8WmV2NYtBA2bIfmEOP1yGp6wXN7doSlEtkD8FlC8TzI98iSbHQytPLC+7ZVlS5yW5LVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVZt3MZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVZt3MZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F491F00893;
	Tue,  2 Jun 2026 10:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395028;
	bh=G3AZrfjKA/1cygwXgkK9tiTHubrtfF5j0AYVS7Y8tws=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dVZt3MZLgDNbSb846tpmPJili/RzE+FsyHAGY6dnXxpKsCmKIHKa0gBRaK9J6b5gD
	 xroBMbMpom2v+WALmANddzahvK1IpsXSlt5RxM+UAEdjLgI4gFG3GRmXlmO+9rHXKK
	 Kp7UAeZFypoz1UR1oDsi5Zh65E2qCXFuNe6yqjWtA/hjL+rM0zZouL71vwAKfDmNIR
	 OAUTpdWSXg0rlGDeoa/Jz6taGfmOwu4opJERymG8aSJmMvPWy+IqrKwUGWiWypuZov
	 wWO4znM86rH8JHAZzlTSH+ccMiIG9Z5/rM8Xdhm1hWf1ktxr+0NWsF6OcFuvCG253g
	 f34VluspHag3Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:08 +0200
Subject: [PATCH RFC 2/8] fs: add a global device to super block hash table
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=20256; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MYpZz0B6HGCp0PliU5rmIIJhd2BihonSRtJLqed8TeA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreGws0xq7DQ/7fpxEQ9jn9Pk8jtBPidK5DbYvXt4Q
 MjmHPuMjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInYvWD4Hx/sFBad8m3JnD4W
 cZ2l6rwaDX4KV36dtWQ3M7g/d5reK0aGy8WNjAWHqv/byRo9DW98cUPJ+0B0+KSZ8TkTNyZlx4n
 wAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
forces the holder to be exactly one superblock and prevents several
superblocks from sharing one block device. That's what erofs is doing.

Introduce a global dev_t-keyed rhltable mapping each block device to the
superblock(s) using it. The holder argument becomes purely the block
layer's exclusivity token (a superblock, or a file_system_type for
shared devices) and is no longer needed by the fs specific callbacks.

Registration keeps one entry per (device, superblock). When a filesystem
claims a device it already uses (xfs with its log on the data device), no
second entry is added, so each superblock is acted on once.

Each table entry holds a passive reference (s_count) on its superblock,
so the struct stays valid for as long as the entry is reachable. The
callbacks look the device up in the table and act on every superblock
using it:

Unlinking an entry is deferred to the last unpin, so a cursor never
resumes from a removed node. After this it's possible to act on all
superblocks that share a given device.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c               | 430 +++++++++++++++++++++++++++++++++--------------
 include/linux/blkdev.h   |   7 -
 include/linux/fs/super.h |   7 +
 3 files changed, 309 insertions(+), 135 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 378e81efe643..e0174d5819a0 100644
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
@@ -1411,186 +1412,234 @@ EXPORT_SYMBOL(sget_dev);
 
 #ifdef CONFIG_BLOCK
 /*
- * Lock the superblock that is holder of the bdev. Returns the superblock
- * pointer if we successfully locked the superblock and it is alive. Otherwise
- * we return NULL and just unlock bdev->bd_holder_lock.
- *
- * The function must be called with bdev->bd_holder_lock and releases it.
+ * Filesystems claim block devices through fs_bdev_file_open_by_{dev,path}(),
+ * which records a {dev_t -> super_block} entry in the global @fs_bdev_supers
+ * table.  The fs_holder_ops callbacks resolve a device event to the
+ * superblock(s) using that device by looking it up there rather than reading
+ * bdev->bd_holder, so several superblocks may share one block device -- the
+ * holder is then only the block layer's exclusivity token.
  */
-static struct super_block *bdev_super_lock(struct block_device *bdev, bool excl)
-	__releases(&bdev->bd_holder_lock)
+struct fs_bdev_holder {
+	dev_t			dev;		/* @fs_bdev_supers key */
+	struct super_block	*sb;
+	refcount_t		fs_bdev_passive;	/* @fs_bdev_active>0 bias + cursor pins */
+	refcount_t		fs_bdev_active;		/* open claims for (dev, sb) */
+	struct rhlist_head	node;
+	struct rcu_head		rcu;
+};
+
+static struct rhltable fs_bdev_supers;
+static const struct rhashtable_params fs_bdev_params = {
+	.key_len	= sizeof(dev_t),
+	.key_offset	= offsetof(struct fs_bdev_holder, dev),
+	.head_offset	= offsetof(struct fs_bdev_holder, node),
+};
+
+static int __init fs_bdev_supers_init(void)
 {
-	struct super_block *sb = bdev->bd_holder;
-	bool locked;
+	if (rhltable_init(&fs_bdev_supers, &fs_bdev_params))
+		panic("VFS: Cannot initialise fs_bdev_supers\n");
+	return 0;
+}
+fs_initcall(fs_bdev_supers_init);
 
-	lockdep_assert_held(&bdev->bd_holder_lock);
-	lockdep_assert_not_held(&sb->s_umount);
-	lockdep_assert_not_held(&bdev->bd_disk->open_mutex);
+static void fs_bdev_holder_put(struct fs_bdev_holder *h)
+{
+	/* Unlink only once unpinned, so a cursor never resumes from a removed node. */
+	if (refcount_dec_and_test(&h->fs_bdev_passive)) {
+		rhltable_remove(&fs_bdev_supers, &h->node, fs_bdev_params);
+		put_super(h->sb);
+		kfree_rcu(h, rcu);
+	}
+}
 
-	/* Make sure sb doesn't go away from under us */
-	spin_lock(&sb_lock);
-	sb->s_count++;
-	spin_unlock(&sb_lock);
+/*
+ * Walk the superblocks sharing a block device the way __iterate_supers() walks
+ * super_blocks: fs_bdev_first()/fs_bdev_next() return each entry with its node
+ * pinned (refcount) so the chain link survives the RCU drop and the sleeping
+ * work the callbacks do between iterations; fs_bdev_next() also unpins the
+ * previous entry.  The entry's fs_bdev_passive ref keeps @h->sb valid; callers
+ * take s_active and/or super_lock_shared() as needed and skip dying superblocks.
+ * A shared per-entry list node can't replace this because mark_dead and sync
+ * are not mutually serialised.
+ */
+static struct fs_bdev_holder *fs_bdev_pin(struct rhlist_head *pos)
+{
+	struct fs_bdev_holder *h;
 
-	mutex_unlock(&bdev->bd_holder_lock);
+	/* Caller holds rcu_read_lock(). */
+	for (; pos; pos = rcu_dereference_all(pos->next)) {
+		h = container_of(pos, struct fs_bdev_holder, node);
+		if (refcount_inc_not_zero(&h->fs_bdev_passive))
+			return h;
+	}
+	return NULL;
+}
 
-	locked = super_lock(sb, excl);
+static struct fs_bdev_holder *fs_bdev_first(dev_t dev)
+{
+	struct fs_bdev_holder *h;
 
-	/*
-	 * If the superblock wasn't already SB_DYING then we hold
-	 * s_umount and can safely drop our temporary reference.
-         */
-	put_super(sb);
+	rcu_read_lock();
+	h = fs_bdev_pin(rhltable_lookup(&fs_bdev_supers, &dev, fs_bdev_params));
+	rcu_read_unlock();
+	return h;
+}
 
-	if (!locked)
-		return NULL;
+static struct fs_bdev_holder *fs_bdev_next(struct fs_bdev_holder *prev)
+{
+	struct fs_bdev_holder *h;
 
-	if (!sb->s_root || !(sb->s_flags & SB_ACTIVE)) {
-		super_unlock(sb, excl);
-		return NULL;
-	}
+	rcu_read_lock();
+	h = fs_bdev_pin(rcu_dereference_all(prev->node.next));
+	rcu_read_unlock();
+
+	fs_bdev_holder_put(prev);
+	return h;
+}
 
-	return sb;
+static int fs_super_freeze(struct super_block *sb)
+{
+	if (sb->s_op->freeze_super)
+		return sb->s_op->freeze_super(sb,
+				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
+	return freeze_super(sb, FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
+}
+
+static int fs_super_thaw(struct super_block *sb)
+{
+	if (sb->s_op->thaw_super)
+		return sb->s_op->thaw_super(sb,
+				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
+	return thaw_super(sb, FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
 }
 
 static void fs_bdev_mark_dead(struct block_device *bdev, bool surprise)
 {
-	struct super_block *sb;
+	struct fs_bdev_holder *h;
+	dev_t dev = bdev->bd_dev;
 
-	sb = bdev_super_lock(bdev, false);
-	if (!sb)
-		return;
+	mutex_unlock(&bdev->bd_holder_lock);
 
-	if (sb->s_op->remove_bdev) {
-		int ret;
+	for (h = fs_bdev_first(dev); h; h = fs_bdev_next(h)) {
+		struct super_block *sb = h->sb;
 
-		ret = sb->s_op->remove_bdev(sb, bdev);
-		if (!ret) {
-			super_unlock_shared(sb);
-			return;
+		if (!super_lock_shared(sb))
+			continue;
+		if (sb->s_root && (sb->s_flags & SB_ACTIVE)) {
+			if (!sb->s_op->remove_bdev ||
+			    sb->s_op->remove_bdev(sb, bdev)) {
+				if (!surprise)
+					sync_filesystem(sb);
+				shrink_dcache_sb(sb);
+				evict_inodes(sb);
+				if (sb->s_op->shutdown)
+					sb->s_op->shutdown(sb);
+			}
 		}
-		/* Fallback to shutdown. */
+		super_unlock_shared(sb);
 	}
-
-	if (!surprise)
-		sync_filesystem(sb);
-	shrink_dcache_sb(sb);
-	evict_inodes(sb);
-	if (sb->s_op->shutdown)
-		sb->s_op->shutdown(sb);
-
-	super_unlock_shared(sb);
 }
 
 static void fs_bdev_sync(struct block_device *bdev)
 {
-	struct super_block *sb;
+	struct fs_bdev_holder *h;
+	dev_t dev = bdev->bd_dev;
 
-	sb = bdev_super_lock(bdev, false);
-	if (!sb)
-		return;
+	mutex_unlock(&bdev->bd_holder_lock);
 
-	sync_filesystem(sb);
-	super_unlock_shared(sb);
-}
+	for (h = fs_bdev_first(dev); h; h = fs_bdev_next(h)) {
+		struct super_block *sb = h->sb;
 
-static struct super_block *get_bdev_super(struct block_device *bdev)
-{
-	bool active = false;
-	struct super_block *sb;
-
-	sb = bdev_super_lock(bdev, true);
-	if (sb) {
-		active = atomic_inc_not_zero(&sb->s_active);
-		super_unlock_excl(sb);
+		if (!super_lock_shared(sb))
+			continue;
+		if (sb->s_root && (sb->s_flags & SB_ACTIVE))
+			sync_filesystem(sb);
+		super_unlock_shared(sb);
 	}
-	if (!active)
-		return NULL;
-	return sb;
 }
 
 /**
- * fs_bdev_freeze - freeze owning filesystem of block device
+ * fs_bdev_freeze - freeze every superblock using a block device
  * @bdev: block device
  *
- * Freeze the filesystem that owns this block device if it is still
- * active.
- *
- * A filesystem that owns multiple block devices may be frozen from each
- * block device and won't be unfrozen until all block devices are
- * unfrozen. Each block device can only freeze the filesystem once as we
- * nest freezes for block devices in the block layer.
+ * Freeze each live superblock using @bdev.  A superblock owning several block
+ * devices is frozen once per device and stays frozen until all are thawed; the
+ * block layer nests these freezes so the count stays balanced.
  *
- * Return: If the freeze was successful zero is returned. If the freeze
- *         failed a negative error code is returned.
+ * Return: 0, or the error from the one superblock on a single-fs device.  When
+ *         several superblocks share @bdev a per-superblock failure is swallowed
+ *         (see below), but a sync_blockdev() failure is always reported.
  */
 static int fs_bdev_freeze(struct block_device *bdev)
 {
-	struct super_block *sb;
-	int error = 0;
+	dev_t dev = bdev->bd_dev;
+	struct fs_bdev_holder *h;
+	unsigned int count = 0;
+	int error = 0, err;
 
 	lockdep_assert_held(&bdev->bd_fsfreeze_mutex);
 
-	sb = get_bdev_super(bdev);
-	if (!sb)
-		return -EINVAL;
+	mutex_unlock(&bdev->bd_holder_lock);
 
-	if (sb->s_op->freeze_super)
-		error = sb->s_op->freeze_super(sb,
-				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
-	else
-		error = freeze_super(sb,
-				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
+	for (h = fs_bdev_first(dev); h; h = fs_bdev_next(h)) {
+		if (!atomic_inc_not_zero(&h->sb->s_active))
+			continue;
+		err = fs_super_freeze(h->sb);
+		if (err && !error)
+			error = err;
+		deactivate_super(h->sb);
+		count++;
+	}
+
+	/*
+	 * When several superblocks share the device, keep it frozen even if some
+	 * of them failed to freeze and swallow the error: rolling the rest back
+	 * via thaw_super() can fail too, so neither is a clear win. A single
+	 * filesystem (count == 1) still reports its error.
+	 */
+	if (error && count > 1)
+		error = 0;
 	if (!error)
 		error = sync_blockdev(bdev);
-	deactivate_super(sb);
 	return error;
 }
 
 /**
- * fs_bdev_thaw - thaw owning filesystem of block device
+ * fs_bdev_thaw - thaw every superblock using a block device
  * @bdev: block device
  *
- * Thaw the filesystem that owns this block device.
+ * The counterpart to fs_bdev_freeze(): thaw each live superblock using @bdev.
+ * A zero return does not imply a superblock is fully unfrozen; it may have been
+ * frozen more than once (by the kernel or via another device).
  *
- * A filesystem that owns multiple block devices may be frozen from each
- * block device and won't be unfrozen until all block devices are
- * unfrozen. Each block device can only freeze the filesystem once as we
- * nest freezes for block devices in the block layer.
- *
- * Return: If the thaw was successful zero is returned. If the thaw
- *         failed a negative error code is returned. If this function
- *         returns zero it doesn't mean that the filesystem is unfrozen
- *         as it may have been frozen multiple times (kernel may hold a
- *         freeze or might be frozen from other block devices).
+ * Return: 0, or the first error on a single-fs device; a shared device swallows
+ *         per-superblock errors, as fs_bdev_freeze() does.
  */
 static int fs_bdev_thaw(struct block_device *bdev)
 {
-	struct super_block *sb;
-	int error;
+	dev_t dev = bdev->bd_dev;
+	struct fs_bdev_holder *h;
+	unsigned int count = 0;
+	int error = 0, err;
 
 	lockdep_assert_held(&bdev->bd_fsfreeze_mutex);
 
-	/*
-	 * The block device may have been frozen before it was claimed by a
-	 * filesystem. Concurrently another process might try to mount that
-	 * frozen block device and has temporarily claimed the block device for
-	 * that purpose causing a concurrent fs_bdev_thaw() to end up here. The
-	 * mounter is already about to abort mounting because they still saw an
-	 * elevanted bdev->bd_fsfreeze_count so get_bdev_super() will return
-	 * NULL in that case.
-	 */
-	sb = get_bdev_super(bdev);
-	if (!sb)
-		return -EINVAL;
+	mutex_unlock(&bdev->bd_holder_lock);
 
-	if (sb->s_op->thaw_super)
-		error = sb->s_op->thaw_super(sb,
-				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
-	else
-		error = thaw_super(sb,
-				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
-	deactivate_super(sb);
+	for (h = fs_bdev_first(dev); h; h = fs_bdev_next(h)) {
+		if (!atomic_inc_not_zero(&h->sb->s_active))
+			continue;
+		err = fs_super_thaw(h->sb);
+		if (err && !error)
+			error = err;
+		deactivate_super(h->sb);
+		count++;
+	}
+
+	/* Shared device: swallow per-superblock errors, like fs_bdev_freeze(). */
+	if (error && count > 1)
+		error = 0;
 	return error;
 }
 
@@ -1602,6 +1651,131 @@ const struct blk_holder_ops fs_holder_ops = {
 };
 EXPORT_SYMBOL_GPL(fs_holder_ops);
 
+static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
+{
+	dev_t dev = file_bdev(bdev_file)->bd_dev;
+	struct rhlist_head *list, *pos;
+	struct fs_bdev_holder *h;
+	int err;
+
+	/*
+	 * A superblock may claim one device more than once (xfs with its log on
+	 * the data device).  Keep a single entry per (device, superblock) and
+	 * count the claims in @fs_bdev_active; the entry lives until the last one
+	 * is released.
+	 */
+	scoped_guard(rcu) {
+		list = rhltable_lookup(&fs_bdev_supers, &dev, fs_bdev_params);
+		rhl_for_each_entry_rcu(h, pos, list, node)
+			if (h->sb == sb && refcount_inc_not_zero(&h->fs_bdev_active))
+				return 0;
+	}
+
+	h = kmalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return -ENOMEM;
+	h->dev = dev;
+	h->sb = sb;
+	refcount_set(&h->fs_bdev_passive, 1);
+	refcount_set(&h->fs_bdev_active, 1);
+
+	err = rhltable_insert(&fs_bdev_supers, &h->node, fs_bdev_params);
+	if (err) {
+		kfree(h);
+		return err;
+	}
+
+	/* The sb->s_count ref keeps @h->sb valid for as long as the entry exists. */
+	spin_lock(&sb_lock);
+	sb->s_count++;
+	spin_unlock(&sb_lock);
+
+	return 0;
+}
+
+/**
+ * fs_bdev_file_open_by_dev - claim a block device on behalf of a superblock
+ * @dev: block device number
+ * @mode: open mode
+ * @holder: block-layer exclusivity token (a superblock, or the file_system_type
+ *          when the device may be shared by several superblocks of that type)
+ * @sb: superblock to drive fs_holder_ops events for
+ *
+ * Open @dev with &fs_holder_ops and register that @sb uses it, so device
+ * removal/sync/freeze/thaw are propagated to @sb (and any other superblock
+ * sharing @dev).  Must be paired with fs_bdev_file_release().
+ *
+ * Return: an opened block-device file or an ERR_PTR().
+ */
+struct file *fs_bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
+				      struct super_block *sb)
+{
+	struct file *bdev_file;
+	int err;
+
+	bdev_file = bdev_file_open_by_dev(dev, mode, holder, &fs_holder_ops);
+	if (IS_ERR(bdev_file))
+		return bdev_file;
+
+	err = fs_bdev_register(bdev_file, sb);
+	if (err) {
+		bdev_fput(bdev_file);
+		return ERR_PTR(err);
+	}
+	return bdev_file;
+}
+EXPORT_SYMBOL_GPL(fs_bdev_file_open_by_dev);
+
+struct file *fs_bdev_file_open_by_path(const char *path, blk_mode_t mode,
+				       void *holder, struct super_block *sb)
+{
+	struct file *bdev_file;
+	int err;
+
+	bdev_file = bdev_file_open_by_path(path, mode, holder, &fs_holder_ops);
+	if (IS_ERR(bdev_file))
+		return bdev_file;
+
+	err = fs_bdev_register(bdev_file, sb);
+	if (err) {
+		bdev_fput(bdev_file);
+		return ERR_PTR(err);
+	}
+	return bdev_file;
+}
+EXPORT_SYMBOL_GPL(fs_bdev_file_open_by_path);
+
+/**
+ * fs_bdev_file_release - release a block device claimed for a superblock
+ * @bdev_file: file returned by fs_bdev_file_open_by_{dev,path}()
+ * @sb: superblock the device was claimed for
+ *
+ * Drop one claim on the {dev, @sb} entry; the last claim unregisters it (a
+ * pinning cursor defers the actual unlink).  Then close the block device.
+ */
+void fs_bdev_file_release(struct file *bdev_file, struct super_block *sb)
+{
+	dev_t dev = file_bdev(bdev_file)->bd_dev;
+	struct fs_bdev_holder *h, *found = NULL;
+	struct rhlist_head *list, *pos;
+
+	rcu_read_lock();
+	list = rhltable_lookup(&fs_bdev_supers, &dev, fs_bdev_params);
+	rhl_for_each_entry_rcu(h, pos, list, node) {
+		if (h->sb != sb)
+			continue;
+		/* At most one entry per (dev, sb); the last claim drops the bias. */
+		if (refcount_dec_and_test(&h->fs_bdev_active))
+			found = h;
+		break;
+	}
+	rcu_read_unlock();
+	if (found)
+		fs_bdev_holder_put(found);
+	bdev_fput(bdev_file);
+}
+EXPORT_SYMBOL_GPL(fs_bdev_file_release);
+
 int setup_bdev_super(struct super_block *sb, int sb_flags,
 		struct fs_context *fc)
 {
@@ -1609,7 +1783,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 	struct file *bdev_file;
 	struct block_device *bdev;
 
-	bdev_file = bdev_file_open_by_dev(sb->s_dev, mode, sb, &fs_holder_ops);
+	bdev_file = fs_bdev_file_open_by_dev(sb->s_dev, mode, sb, sb);
 	if (IS_ERR(bdev_file)) {
 		if (fc)
 			errorf(fc, "%s: Can't open blockdev", fc->source);
@@ -1623,7 +1797,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 	 * writable from userspace even for a read-only block device.
 	 */
 	if ((mode & BLK_OPEN_WRITE) && bdev_read_only(bdev)) {
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, sb);
 		return -EACCES;
 	}
 
@@ -1634,7 +1808,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 	if (atomic_read(&bdev->bd_fsfreeze_count) > 0) {
 		if (fc)
 			warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, sb);
 		return -EBUSY;
 	}
 	spin_lock(&sb_lock);
@@ -1725,7 +1899,7 @@ void kill_block_super(struct super_block *sb)
 	generic_shutdown_super(sb);
 	if (bdev) {
 		sync_blockdev(bdev);
-		bdev_fput(sb->s_bdev_file);
+		fs_bdev_file_release(sb->s_bdev_file, sb);
 	}
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c8494d64a69d..43d37c02febf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1760,13 +1760,6 @@ struct blk_holder_ops {
 	int (*thaw)(struct block_device *bdev);
 };
 
-/*
- * For filesystems using @fs_holder_ops, the @holder argument passed to
- * helpers used to open and claim block devices via
- * bd_prepare_to_claim() must point to a superblock.
- */
-extern const struct blk_holder_ops fs_holder_ops;
-
 /*
  * Return the correct open flags for blkdev_get_by_* for super block flags
  * as stored in sb->s_flags.
diff --git a/include/linux/fs/super.h b/include/linux/fs/super.h
index f21ffbb6dea5..721d842e3b24 100644
--- a/include/linux/fs/super.h
+++ b/include/linux/fs/super.h
@@ -235,4 +235,11 @@ int freeze_super(struct super_block *super, enum freeze_holder who,
 int thaw_super(struct super_block *super, enum freeze_holder who,
 	       const void *freeze_owner);
 
+struct file;
+struct file *fs_bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
+				      struct super_block *sb);
+struct file *fs_bdev_file_open_by_path(const char *path, blk_mode_t mode,
+				       void *holder, struct super_block *sb);
+void fs_bdev_file_release(struct file *bdev_file, struct super_block *sb);
+
 #endif /* _LINUX_FS_SUPER_H */

-- 
2.47.3

