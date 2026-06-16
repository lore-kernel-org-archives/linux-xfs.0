Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC17B36E46F;
	Tue, 16 Jun 2026 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618947; cv=none; b=iGswpRH0zsvsSmR55cQljA9W0w3PGqJZFzfFQCqpHy2EwZsHLhJkxP8Q2MJCWfIQzbm9RFN20wDdaeEADVMea+oerVGi2Q3hrwxYbXQ8L91lQSS6ppu5fQj6sgiU1In1tpvB6yxtXQ2AXLr3/960U04XwfuAFBhB+QFQURJZH4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618947; c=relaxed/simple;
	bh=VbL4Tle8J7ig1J1vW7Q4LDcahS3KzHqARwjgFOGJJvY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P7aO3KSrMhyjq9vWaarxnZjCXH82ydZgSlG+n+wiWuz5zgSCWRq3f/SLugLMP4GV07vPE0X6U5RIQbP0+qhjo5IeoHVr4yce8agnVWsG+ly8Qoqbu+hNfeWHSf1roF7KV3qk+ACYOWTsT3oWNMD4rtekxo9kWac57IYm2WL6230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhq+hq/T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhq+hq/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298481F00ADB;
	Tue, 16 Jun 2026 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618945;
	bh=nP3Udk8iy/Uza/C/ZQOR8nX+IzZC7biDMWzYcgbDqCw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lhq+hq/Tv6VeWQkaOR9t1faUtH19+ZQBODdCRdubau7B2atKbyWt4Ru3CoWzd2JdI
	 pART8OGFb+acXJ10rfRiV3QAeLbiTFGMIdDDy/VFfvP3XFrYXyVjq/NNrPowJiR8sB
	 FQ4UUqJ1jmnZpnB0oVm3Yx8cf8bF1NwzZHrUMr+uYk8lVYfILz2OdizVq/gS2LVVNz
	 3WU+/HulzLSbGPX7b6yd7oRVgdpKOPFd3kbR42RmR21ZxoVTHe0XyaiZt6Cp+iN4mZ
	 rHluZL65N7J7jtDLwFU0kq8Ym1F6hcQnPLoYRipB9kwV0pOF+K9TCx/Hev/OT5oU/h
	 KVd2DOKuwiMsQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:24 +0200
Subject: [PATCH RFC v2 08/18] fs: add dedicated block device open helpers
 for filesystems
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10198; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VbL4Tle8J7ig1J1vW7Q4LDcahS3KzHqARwjgFOGJJvY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtyrvO34XoC1JqOU69KTbX1bZoZFnev3dv5aK3txk
 uCzGydEOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZymZ/hvzfHuhpdhZh339Zv
 N5d7epthidjLgMPMfZtPSTOxyNrs62P4nxgYHNMY2G+kbtuetjbj9ZQjihIbndKfn77rIve06Lw
 2AwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add fs_bdev_file_open_by_{dev,path}() and fs_bdev_file_release(). They
open the device with fs_holder_ops and register a claim in the
device-to-superblock table. Claims on the same (device, superblock)
pair share one entry, so when a filesystem claims a device it already
uses (xfs with its log on the data device), no second entry is added
and each superblock will be acted on once.

The holder argument remains purely the block layer's exclusivity token:
a superblock, or a file_system_type for a device shared by several
superblocks of that type. The shared case only becomes usable once the
fs_holder_ops callbacks resolve superblocks through the table instead
of bdev->bd_holder.

Convert the main device, setup_bdev_super() and kill_block_super(),
over: the open finds the entry registered by sget_fc() and claims it
again. cramfs and romfs bypass kill_block_super() so they can handle
MTD mounts and release the main device with a plain bdev_fput(), which
would leave the claim behind: the (dev, sb) entry would never be
unregistered and the passive reference it holds would keep the
superblock alive forever. Convert their release paths in the same
step.

The frozen-device check stays in setup_bdev_super() for the primary
device and is added to fs_bdev_register() for new claims, i.e. every
additional device a filesystem opens through the helpers. Only a
(device, superblock) pair the superblock claimed earlier may be
reopened while frozen (xfs with its log on the data device): the freeze
already covers that superblock through the existing claim, so nothing
escapes it. Without the setup_bdev_super() check a device frozen before
the mount even started (dm lock_fs, loop) could be mounted and written
to (journal replay) under an active freeze, because the primary open
reuses the entry registered by sget_fc() and never takes the new-claim
path.

Both checks read bd_fsfreeze_count only after the entry is published
(by sget_fc() for the primary, by fs_bdev_register() for new claims)
and pair with bdev_freeze() incrementing the count before walking the
table: either the mount sees the elevated freeze count and fails with
EBUSY, or the freeze finds the published entry and converges once
SB_BORN is set.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/cramfs/inode.c        |   2 +-
 fs/romfs/super.c         |   2 +-
 fs/super.c               | 154 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/fs/super.h |   7 +++
 4 files changed, 155 insertions(+), 10 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 4edbfccd0bbe..d4cd03f4f60d 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -504,7 +504,7 @@ static void cramfs_kill_sb(struct super_block *sb)
 		sb->s_mtd = NULL;
 	} else if (IS_ENABLED(CONFIG_CRAMFS_BLOCKDEV) && sb->s_bdev) {
 		sync_blockdev(sb->s_bdev);
-		bdev_fput(sb->s_bdev_file);
+		fs_bdev_file_release(sb->s_bdev_file, sb);
 	}
 	kfree(sbi);
 }
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index ac55193bf398..43eb897197c0 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -587,7 +587,7 @@ static void romfs_kill_sb(struct super_block *sb)
 #ifdef CONFIG_ROMFS_ON_BLOCK
 	if (sb->s_bdev) {
 		sync_blockdev(sb->s_bdev);
-		bdev_fput(sb->s_bdev_file);
+		fs_bdev_file_release(sb->s_bdev_file, sb);
 	}
 #endif
 }
diff --git a/fs/super.c b/fs/super.c
index ff5e305d0ab4..3d166c7f578a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1633,6 +1633,145 @@ const struct blk_holder_ops fs_holder_ops = {
 };
 EXPORT_SYMBOL_GPL(fs_holder_ops);
 
+static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
+{
+	struct super_dev *it;
+	struct rhlist_head *list, *pos;
+
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "suspicious super_dev_lookup() usage");
+	VFS_WARN_ON_ONCE(!dev);
+	VFS_WARN_ON_ONCE(!sb);
+
+	list = rhltable_lookup(&super_dev_table, &dev, super_dev_params);
+	rhl_for_each_entry_rcu(it, pos, list, sd_node) {
+		if (it->sd_sb == sb)
+			return it;
+	}
+
+	return NULL;
+}
+
+static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
+{
+	struct super_dev *sb_dev __free(kfree) = NULL;
+	dev_t dev = file_bdev(bdev_file)->bd_dev;
+	int err;
+
+	scoped_guard(rcu) {
+		sb_dev = super_dev_lookup(dev, sb);
+		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
+			retain_and_null_ptr(sb_dev);
+			return 0;
+		}
+	}
+
+	sb_dev = super_dev_alloc(dev, sb);
+	if (!sb_dev)
+		return -ENOMEM;
+
+	err = super_dev_insert(sb_dev);
+	if (err)
+		return err;
+
+	/* Publish the entry before reading the count; pairs with bdev_freeze(). */
+	smp_mb();
+	if (atomic_read(&file_bdev(bdev_file)->bd_fsfreeze_count) > 0) {
+		err = -EBUSY;
+		super_dev_put(sb_dev);
+	}
+
+	retain_and_null_ptr(sb_dev);
+	return err;
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
+/**
+ * fs_bdev_file_open_by_path - claim a block device on behalf of a superblock
+ * @path: path to the block device
+ * @mode: open mode
+ * @holder: block-layer exclusivity token (a superblock, or the file_system_type
+ *          when the device may be shared by several superblocks of that type)
+ * @sb: superblock to drive fs_holder_ops events for
+ *
+ * Open the block device at @path with &fs_holder_ops and register that @sb
+ * uses it, so device removal/sync/freeze/thaw are propagated to @sb (and any
+ * other superblock sharing the device).  Must be paired with
+ * fs_bdev_file_release().
+ *
+ * Return: an opened block-device file or an ERR_PTR().
+ */
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
+	struct super_dev *sb_dev;
+
+	rcu_read_lock();
+	sb_dev = super_dev_lookup(dev, sb);
+	rcu_read_unlock();
+	super_dev_put(sb_dev);
+	bdev_fput(bdev_file);
+}
+EXPORT_SYMBOL_GPL(fs_bdev_file_release);
+
 int setup_bdev_super(struct super_block *sb, int sb_flags,
 		struct fs_context *fc)
 {
@@ -1640,7 +1779,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 	struct file *bdev_file;
 	struct block_device *bdev;
 
-	bdev_file = bdev_file_open_by_dev(sb->s_dev, mode, sb, &fs_holder_ops);
+	bdev_file = fs_bdev_file_open_by_dev(sb->s_dev, mode, sb, sb);
 	if (IS_ERR(bdev_file)) {
 		if (fc)
 			errorf(fc, "%s: Can't open blockdev", fc->source);
@@ -1654,20 +1793,19 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
 	 * writable from userspace even for a read-only block device.
 	 */
 	if ((mode & BLK_OPEN_WRITE) && bdev_read_only(bdev)) {
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, sb);
 		return -EACCES;
 	}
 
-	/*
-	 * It is enough to check bdev was not frozen before we set
-	 * s_bdev as freezing will wait until SB_BORN is set.
-	 */
+	/* The sget_fc() entry is already published; pairs with bdev_freeze(). */
+	smp_mb();
 	if (atomic_read(&bdev->bd_fsfreeze_count) > 0) {
 		if (fc)
 			warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, sb);
 		return -EBUSY;
 	}
+
 	spin_lock(&sb_lock);
 	sb->s_bdev_file = bdev_file;
 	sb->s_bdev = bdev;
@@ -1756,7 +1894,7 @@ void kill_block_super(struct super_block *sb)
 	generic_shutdown_super(sb);
 	if (bdev) {
 		sync_blockdev(bdev);
-		bdev_fput(sb->s_bdev_file);
+		fs_bdev_file_release(sb->s_bdev_file, sb);
 	}
 }
 
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

