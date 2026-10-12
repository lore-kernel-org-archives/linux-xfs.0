Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8532C45DF68;
	Mon, 12 Oct 2026 10:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800563; cv=none; b=gqbEARf1tMbSqS8UQ/v4Xas+Dl75wVGMDw1vKXUWmpY+Cf2U+Hpl88zEOfG2bg8YqCSmyCnZcCYSEbowK2khCyrQUC1BDvvbbafOfoVQKFImibXVWMGJw6KINqHQt8MUuS4rdxKSNDOtuT8hauvpQx3A+QCuTmDCfQRkPxfA95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800563; c=relaxed/simple;
	bh=JqcOU4hNR76h2J12g3Sc71Y635LG5rvEmOxfDFNsDz0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iuiKymVmiYRmvSufy2FBcZtZOVNS7MgbvZOZKCItGh3hK5gKsJvnKB8z/YD4S+PMGyusqjhFjhsxapMHikjBN/8vl+IucA/GeBtiOlRnKZirKwsVr7K0vljs5LoobDXt4anJnI7eick/JkG5223RqDBr7nbp5kiU2ItQnIxolN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EW2hoFBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EW2hoFBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E031F008A0;
	Mon, 12 Oct 2026 10:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800544;
	bh=KLZLkIiAjJEULoPvbaaMof2Wm7VaculwIYjOa+JEqTo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EW2hoFBe86I1EkLnrP8pS5qeDmrh8bgHnspnlecNoVsMnw98T/im67V3DPUZKCJzA
	 eKuolZDq3dxOyWtrIC3gpYXkAzEIU1Geq+O+eXURkjDoi6envgEz/2IgLc8mCome1A
	 USyLrWsEAqizj48JLovGhLvNM2lHBI9ZlD1OX6qDEdi4Yn8lWHZj0RKbkcJaOb9h9x
	 u9JkZ1hQAVBGbkbcOiZaCmhiEGGY+MiFdyBEi8wjiINze+s4doTkjowVZ2VNgxaPFh
	 ZG3V6ZsdNyg2WlJTuFfDcEe7x9885WbLGzZHcB73ayuwdOoc0z6k9fhNdwKdEXIt0E
	 EYLXcU2nC1/PQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:02 +0200
Subject: [PATCH RFC 17/28] zonefs: don't set SB_RDONLY after I/O errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-17-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
To: Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=11381; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JqcOU4hNR76h2J12g3Sc71Y635LG5rvEmOxfDFNsDz0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TLZYMP/u86XOSacStvJxxH5Y3Yn8/HrC0or/5nMZ
 uN9vG2Nc0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE8pIZGXZkfgpct1YogWXh
 ux36J7dU9u54Y9PyMf/3t/L/2y9I3Opi+CvcVazz5+E24a5Z7LfWvDzx65/y/bVtD+QlLppX/5k
 iGsMJAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

zonefs sets SB_RDONLY from its I/O error handling without holding
sb->s_umount. It does so in three places:

- zonefs_handle_io_error() with errors=remount-ro, which is the default
- __zonefs_io_error() when the zone report fails, for every errors= mode
- zonefs_seq_file_write_close() when closing an explicitly opened zone
  fails

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So after an
error while the filesystem is frozen thaw_super() skips ->unfreeze_fs()
and sb_freeze_unlock() and the rwsems stay write-locked. Writers hang in
sb_start_write(). A remount to read-write makes the filesystem writable
again but the rwsems stay locked. So writers keep hanging and the next
freeze blocks forever in sb_wait_write(). And umount warns in
rcu_sync_dtor().

zonefs has no ->freeze_fs() and is only frozen through bdev_freeze(),
e.g. by a device mapper suspend with lockfs which also holds new I/O.
But an fsync() that finds an earlier writeback error in the mapping runs
the error handling without doing any I/O. For a conventional zone the
zone report is faked so zonefs_handle_io_error() sets SB_RDONLY:

  zonefs (dm-0) WARNING: remounting filesystem read-only
  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190

Do what ext4 did in commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors") and record the error in a new
ZONEFS_SB_EMERGENCY_RO bit instead. All three places call the new
zonefs_set_emergency_ro() which prints the existing "remounting
filesystem read-only" warning once. An error on a read-only mount
doesn't set the bit since there's nothing to refuse there. Write opens,
write_iter and setattr are refused with -EROFS and page_mkwrite fails
with VM_FAULT_SIGBUS. Refusing write opens also avoids a
REQ_OP_ZONE_OPEN with explicit-open.

A remount to read-write fails with -EROFS. A remount to read-only is
allowed, also for emergency remount (sysrq u), and zonefs writes no
metadata on that transition. So far "mount -o remount,rw" re-enabled
writes after a remount-ro error. Now the state lasts until umount and
Documentation/filesystems/zonefs.rst says so.

Like ext4 we show "emergency_ro" in the mount options. The mount stays
"rw". Note that writes through file descriptors opened before the error
failed with -EROFS before as well since zonefs_file_write_iter() already
checked sb_rdonly(). What's new is that ftruncate() through such a file
descriptor, i.e. a zone reset or finish, and write faults on shared
mappings are refused too. fsync and writeback of conventional zone data
dirtied before the error and the zone close on release behave as before
because SB_RDONLY didn't stop those either.

Reproducer:

  modprobe null_blk nr_devices=0
  mkdir /sys/kernel/config/nullb/z && cd /sys/kernel/config/nullb/z
  echo 1 > memory_backed; echo 4096 > blocksize; echo 1 > zoned
  echo 8 > zone_size; echo 4 > zone_nr_conv; echo 128 > size; echo 1 > power
  mkzonefs /dev/z        # the disk is named after the configfs directory
  dmsetup create zfs --table "0 $(blockdev --getsz /dev/z) linear /dev/z 0"
  mount -t zonefs /dev/mapper/zfs /mnt
  echo +16384-16391 > badblocks          # first 4k of zone 1, i.e. cnv/0
  dd if=/dev/zero of=/mnt/cnv/0 bs=4k count=1 conv=notrunc; sync   # writeback fails
  dmsetup suspend zfs
  sync /mnt/cnv/0        # fsync() reports the writeback error -> SB_RDONLY while frozen
  dmsetup resume zfs
  touch /mnt/cnv/1       # hangs in sb_start_write()
  # umount instead of touch: WARNING at kernel/rcu/sync.c:177 rcu_sync_dtor()

Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/zonefs.rst |  5 +++--
 fs/zonefs/file.c                     | 17 +++++++++--------
 fs/zonefs/super.c                    | 37 ++++++++++++++++++++++++++++--------
 fs/zonefs/zonefs.h                   | 16 ++++++++++++++++
 4 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/Documentation/filesystems/zonefs.rst b/Documentation/filesystems/zonefs.rst
index c22124c2213d..2bec05102db4 100644
--- a/Documentation/filesystems/zonefs.rst
+++ b/Documentation/filesystems/zonefs.rst
@@ -285,8 +285,9 @@ Further notes:
 * The "errors=remount-ro" mount option is the default behavior of zonefs I/O
   error processing if no errors mount option is specified.
 * With the "errors=remount-ro" mount option, the change of the file access
-  permissions to read-only applies to all files. The file system is remounted
-  read-only.
+  permissions to read-only applies to all files. A file system mounted
+  read-write refuses all writes until it is unmounted and "emergency_ro" is
+  shown in its mount options.
 * Access permission and file size changes due to the device transitioning zones
   to the offline condition are permanent. Remounting or reformatting the device
   with mkfs.zonefs (mkzonefs) will not change back offline zone files to a good
diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 5b34849be7a2..8959b6b36a83 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -299,7 +299,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	vm_fault_t ret;
 
-	if (unlikely(IS_IMMUTABLE(inode)))
+	if (unlikely(IS_IMMUTABLE(inode) || zonefs_emergency_ro(inode->i_sb)))
 		return VM_FAULT_SIGBUS;
 
 	/*
@@ -601,7 +601,7 @@ static ssize_t zonefs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
-	if (sb_rdonly(inode->i_sb))
+	if (sb_rdonly(inode->i_sb) || zonefs_emergency_ro(inode->i_sb))
 		return -EROFS;
 
 	/* Write operations beyond the zone capacity are not allowed */
@@ -788,6 +788,9 @@ static int zonefs_file_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
+	if ((file->f_mode & FMODE_WRITE) && zonefs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	file->f_mode |= FMODE_CAN_ODIRECT;
 	ret = generic_file_open(inode, file);
 	if (ret)
@@ -825,17 +828,15 @@ static void zonefs_seq_file_write_close(struct inode *inode)
 			/*
 			 * Leaving zones explicitly open may lead to a state
 			 * where most zones cannot be written (zone resources
-			 * exhausted). So take preventive action by remounting
-			 * read-only.
+			 * exhausted). So take preventive action by making the
+			 * file system read-only.
 			 */
 			if (z->z_flags & ZONEFS_ZONE_OPEN &&
-			    !(sb->s_flags & SB_RDONLY)) {
+			    !sb_rdonly(sb) && !zonefs_emergency_ro(sb)) {
 				zonefs_warn(sb,
 					"closing zone at %llu failed %d\n",
 					z->z_sector, ret);
-				zonefs_warn(sb,
-					"remounting filesystem read-only\n");
-				sb->s_flags |= SB_RDONLY;
+				zonefs_set_emergency_ro(sb);
 			}
 			goto unlock;
 		}
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index ff43d6d1ea30..367d657febe5 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -247,6 +247,20 @@ static void zonefs_inode_update_mode(struct inode *inode)
 	z->z_mode = inode->i_mode;
 }
 
+/*
+ * Make the file system refuse writes after an error. Don't set SB_RDONLY:
+ * that needs sb->s_umount and a proper remount, and setting it while the file
+ * system is frozen makes thaw_super() leave the s_writers rwsems locked.
+ */
+void zonefs_set_emergency_ro(struct super_block *sb)
+{
+	if (sb_rdonly(sb) ||
+	    test_and_set_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state))
+		return;
+
+	zonefs_warn(sb, "remounting filesystem read-only\n");
+}
+
 static int zonefs_io_error_cb(struct blk_zone *zone, unsigned int idx,
 			      void *data)
 {
@@ -339,13 +353,11 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 		z->z_flags &= ~ZONEFS_ZONE_OPEN;
 
 	/*
-	 * If error=remount-ro was specified, any error result in remounting
-	 * the volume as read-only.
+	 * If error=remount-ro was specified, any error makes the volume
+	 * read-only.
 	 */
-	if ((sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO) && !sb_rdonly(sb)) {
-		zonefs_warn(sb, "remounting filesystem read-only\n");
-		sb->s_flags |= SB_RDONLY;
-	}
+	if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO)
+		zonefs_set_emergency_ro(sb);
 
 	/*
 	 * Update block usage stats and the inode size  to prevent access to
@@ -404,8 +416,7 @@ void __zonefs_io_error(struct inode *inode, bool write)
 	if (ret != 1) {
 		zonefs_err(sb, "Get inode %llu zone information failed %d\n",
 			   inode->i_ino, ret);
-		zonefs_warn(sb, "remounting filesystem read-only\n");
-		sb->s_flags |= SB_RDONLY;
+		zonefs_set_emergency_ro(sb);
 		return;
 	}
 
@@ -529,6 +540,8 @@ static int zonefs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",errors=zone-offline");
 	if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_REPAIR)
 		seq_puts(seq, ",errors=repair");
+	if (zonefs_emergency_ro(root->d_sb))
+		seq_puts(seq, ",emergency_ro");
 
 	return 0;
 }
@@ -539,6 +552,9 @@ static int zonefs_inode_setattr(struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(dentry);
 	int ret;
 
+	if (unlikely(zonefs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
@@ -1369,6 +1385,11 @@ static int zonefs_reconfigure(struct fs_context *fc)
 	struct super_block *sb = fc->root->d_sb;
 	struct zonefs_sb_info *sbi = sb->s_fs_info;
 
+	/* An error made the file system read-only until it is unmounted. */
+	if (sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY) &&
+	    zonefs_emergency_ro(sb))
+		return -EROFS;
+
 	sync_filesystem(fc->root->d_sb);
 	/* Copy new options from ctx into sbi. */
 	sbi->s_mount_opts = ctx->s_mount_opts;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 8175652241b5..b14822cb9c02 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -241,6 +241,16 @@ struct zonefs_sb_info {
 	bool			s_sysfs_registered;
 	struct kobject		s_kobj;
 	struct completion	s_kobj_unregister;
+
+	unsigned long		s_state;
+};
+
+/*
+ * Super block state bits (s_state).
+ */
+enum {
+	/* An error made the file system read-only until it is unmounted */
+	ZONEFS_SB_EMERGENCY_RO,
 };
 
 static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
@@ -248,6 +258,11 @@ static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline bool zonefs_emergency_ro(struct super_block *sb)
+{
+	return test_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state);
+}
+
 #define zonefs_info(sb, format, args...)	\
 	pr_info("zonefs (%s): " format, sb->s_id, ## args)
 #define zonefs_err(sb, format, args...)		\
@@ -260,6 +275,7 @@ void zonefs_inode_account_active(struct inode *inode);
 int zonefs_inode_zone_mgmt(struct inode *inode, enum req_op op);
 void zonefs_i_size_write(struct inode *inode, loff_t isize);
 void zonefs_update_stats(struct inode *inode, loff_t new_isize);
+void zonefs_set_emergency_ro(struct super_block *sb);
 void __zonefs_io_error(struct inode *inode, bool write);
 
 static inline void zonefs_io_error(struct inode *inode, bool write)

-- 
2.53.0

