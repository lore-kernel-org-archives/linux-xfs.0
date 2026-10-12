Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BEC3FB07E;
	Mon, 12 Oct 2026 10:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800553; cv=none; b=QV/pt5X6aciLUdsR49CB8W8kRGfoKBQjIMsG0p/vYUzZSr8h+Er5TaGIoi2IYS59/vmitEDNbaneM3MJVWQ+kyJXsXke4aM9WiiJHiq0V6SfE2RmRwNuhfzVQZYZI+pR9BHbYsFLQol+NBEnJ8hVbEKM5GDA7oU3+yiUibIfAOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800553; c=relaxed/simple;
	bh=ueuEaeycyEzoyFbMr/OQmw+9gEdClc2VpoiI+F4Ax14=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GX1QGqadlU+cdQyKyJKVx2u91UNiwGpeIGipb1pUG64uQ+HUMsn5sBNKi2zqKKlE3OK/41oqXALv/fasYi/1zCXgAv+3RRcPVYQdIncyzGCUmwcufAlVT6xLpcrluNLns3VJXS+t2v4CQlfM0QcpUlI2umgXs8wlj2EG9OPWQOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oROk4qqh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oROk4qqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6827D1F0089E;
	Mon, 12 Oct 2026 10:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800532;
	bh=9BYz9YnAmPvu5Zs87JPsk+qjsEggU1Tk/Ms7aUXBx5g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oROk4qqhTf7e+hH5V0ovuE8JpAlRAaIzrMl5j4rUK21yk2jws47xKJjyRl4FdcAqt
	 hLr4c2U1ZriEjDGyHzxhuxggtKjZs/lfSSQRTuXkKmr8Lu40m03dw/k4OvRfTXgKOF
	 dVwstQfKpzmi2UsHYAoZ8SUESjPJ/UrwamM9lq91F/y4CIQxQ0mz/uLT7BCm1iNJD6
	 EVr9KoPI3ais4FfXO04HJOJ+jQmbFXrEkBREyDY/7ddyccLSbm5gTwk0ITVbr4ARcc
	 MdtOeddXN7yXq88M4h5fI1gXa9saYsim/LzHMSLVy4l4sv/BnC6z0RHRDUSuFveXNc
	 hdEOH8CzVN6qg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:59 +0200
Subject: [PATCH RFC 14/28] ntfs: don't set SB_RDONLY after filesystem
 errors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=24261; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ueuEaeycyEzoyFbMr/OQmw+9gEdClc2VpoiI+F4Ax14=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TL5+EvrtysFN+fNsjnux6lqeEdLSfXEjZY9OznSO
 ZrNr6oJd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyksorhf27F/UcT5q7l7uv4
 7DiXIdHA/l4Vc9Qahz1sO9e+fXPpTAQjw2VnCfGvTos/Sl+c6+V6d7O06PztyT82OMcGbdXTcDl
 2hg8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
which sets SB_RDONLY without holding sb->s_umount.

freeze_super() and thaw_super() both look at sb_rdonly() to figure out
whether the s_writers rwsems need to be taken or released. So an error
while the volume is frozen leaves the rwsems write-locked after the
thaw. Writers hang in sb_start_write() and umount warns in
rcu_sync_dtor().

ntfs has no ->freeze_fs(). It is frozen through bdev_freeze(), e.g. by a
device mapper suspend with lockfs which also holds new I/O. But reads of
cached metadata still reach ntfs_error(). If two files share a cached
page of $MFT a stat() of the one whose record has a link count of zero
gets there:

  ntfs: (device dm-0): ntfs_read_locked_inode(): Inode link count is 0!
  ntfs: (device dm-0): Filesystem has been set read-only

After the resume a create blocks forever:

  [<0>] percpu_rwsem_wait+0x203/0x500
  [<0>] mnt_want_write+0x28f/0x2f0
  [<0>] lookup_open+0x135/0x1b20

and umount warns:

  WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0x143/0x190, CPU#2: kworker/2:1/53
  Workqueue: events destroy_super_work
   percpu_free_rwsem+0x38/0xa0
   destroy_super_work+0x133/0x2f0

Follow what ext4 did in commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors") and commit f3054e53c2f3 ("ext4: add
EXT4_FLAGS_EMERGENCY_RO bit"). ntfs_handle_error() now sets NV_Errors
and a new NV_EmergencyRO volume flag instead of SB_RDONLY. While
mounting it keeps setting SB_RDONLY though. The mounter holds s_umount
and nothing can freeze the superblock before SB_BORN. So a non-fatal
error during mount, e.g. a bad $UpCase, still gives a read-only mount
and $LogFile isn't emptied on such a volume.

NV_Errors already means that the volume has errors and must not be
remounted read-write. So the existing NVolErrors() checks give us the
remount behaviour for free. A remount to read-write fails with -EROFS. A
remount to read-only skips clearing VOLUME_IS_DIRTY which also lets
emergency remount (sysrq u) through without a WARN. ntfs_sync_fs() skips
clearing the dirty flag as well but keeps returning 0 so freezing still
works, and ntfs_put_super() leaves the volume marked dirty.

The dirty flag needs a bit more work. VOLUME_IS_DIRTY is set lazily on
the first modification and ntfs_sync_fs() clears it again. So it may
well not be on disk when the error hits and the writeback that would
write it is refused from then on. Before, the flusher still wrote a
dirty $Volume record after the flip. So mark the volume dirty from a
work item once the error is recorded because ntfs_error() may be called
with mft records locked. sb_start_intwrite() makes the work wait for a
frozen volume to be thawed. __ntfs_write_inode() still writes $Volume in
the emergency state, ntfs_reconfigure() flushes the work and
ntfs_put_super() sets the flag if the work didn't get to run. So the
remount to read-only can still write $Volume, plus whatever
sync_filesystem() writes back.

Evicting an unlinked inode frees its mft record with direct bios while
the index and bitmap updates of the deletion sit in the page cache which
can't be written back anymore. The directory entry then points at a free
record on disk. So don't free the on-disk structures of unlinked inodes
in the emergency state and leave them to chkdsk like ext2 does. That
alone isn't enough because the deletion itself can raise the error and
->release() and ->drop_inode() free mft records too when they truncate.
So ntfs_mft_record_free() refuses in that state as well.

The new ntfs_emergency_state() returns -EIO for NV_Shutdown and -EROFS
for NV_EmergencyRO, same as ext4_emergency_state(). Every check on the
write side that honoured NV_Shutdown uses it now, including
__ntfs_write_iomap_begin() for buffered, direct and mmap writes and for
writeback. fallocate, ->set_acl(), FS_IOC_SETFSLABEL and
ntfs_mft_record_free() didn't have a shutdown check at all and get one
now. FITRIM is refused as well. The read side keeps its shutdown-only
checks so reads keep working.

Writing to an encrypted file isn't supported and so far called
ntfs_error(). That would let any user who can write to such a file put
the volume into the emergency state. And since the dirty flag is now
written the next errors=remount-ro mount would be read-only until
chkdsk ran. It isn't a filesystem error anyway so just warn.

Like ext4 we show "emergency_ro" in the mount options. The mount stays
"rw" until a remount to read-only. Opening a file for writing fails
with -EROFS like on ext4, writes through file descriptors opened before
the error fail with -EROFS as well and mmap writes get SIGBUS. Data and
inodes dirtied before the error aren't written back anymore so an
operation that completed shortly before the error can end up
half-applied on disk and needs chkdsk. And the volume now stays marked
dirty so the next errors=remount-ro mount is read-only until chkdsk ran.
Note that ntfs_sync_fs(), ntfs_reconfigure() and ntfs_put_super() check
NVolErrors() without holding $Volume's lock. So an error racing with
them can still end up with a clean volume.

Before, a remount to read-write after the flip was allowed whenever the
volume wasn't marked dirty. Now it's refused until umount. After
FS_IOC_SHUTDOWN fallocate returns -EIO now and unlinked inodes that get
evicted aren't freed anymore.

Reproducer:

  truncate -s 64M ntfs.img; mkntfs -F -f -q ntfs.img
  mount -o loop ntfs.img /mnt; for i in 0 1 2 3 4 5 6 7; do echo $i > /mnt/f$i; done
  stat -c '%i %n' /mnt/f1 /mnt/f2    # 32 and 33 (f0 is 27): one 4k page of $MFT
  umount /mnt
  # link count (offset 0x12) of f2's MFT record -> 0; $MFT starts at LCN 4 (4k clusters)
  printf '\0\0' | dd of=ntfs.img bs=1 seek=$((4 * 4096 + 33 * 1024 + 0x12)) conv=notrunc
  losetup /dev/loop0 ntfs.img
  dmsetup create ntfs --table "0 $(blockdev --getsz /dev/loop0) linear /dev/loop0 0"
  mount -t ntfs -o errors=remount-ro /dev/mapper/ntfs /mnt
  stat /mnt/f1           # reads the $MFT page holding f1 and f2
  dmsetup suspend ntfs   # bdev_freeze() -> freeze_super()
  stat /mnt/f2           # "Inode link count is 0!" -> SB_RDONLY while frozen
  dmsetup resume ntfs    # thaw_super() sees SB_RDONLY and skips sb_freeze_unlock()
  touch /mnt/x           # hangs in sb_start_write()
  # umount instead of touch: WARNING at kernel/rcu/sync.c:177 rcu_sync_dtor()

The dirty flag is at offset 0x0a of the VOLUME_INFORMATION value in mft
record 3. After the error it reads 0x0001 on disk. Before this patch it
stayed 0x0000 until umount and beyond.

Fixes: 6251f0b0de7d ("ntfs: update super block operations")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs/aops.c   |  5 +++--
 fs/ntfs/dir.c    |  5 +++--
 fs/ntfs/ea.c     | 10 ++++++++--
 fs/ntfs/file.c   | 51 ++++++++++++++++++++++++++++++++++++-------------
 fs/ntfs/inode.c  | 22 ++++++++++++++++++---
 fs/ntfs/iomap.c  |  6 ++++--
 fs/ntfs/mft.c    | 10 ++++++++--
 fs/ntfs/namei.c  | 40 ++++++++++++++++++++++----------------
 fs/ntfs/super.c  | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ntfs/volume.h | 22 +++++++++++++++++++++
 10 files changed, 186 insertions(+), 43 deletions(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 517d9a1563e7..dc3aee8a9a4d 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -262,8 +262,9 @@ static int ntfs_writepages(struct address_space *mapping,
 	bool need_iput = false;
 	int ret;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	ret = ntfs_emergency_state(ni->vol);
+	if (ret)
+		return ret;
 
 	if (!NInoNonResident(ni))
 		return 0;
diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index df60138f9b2d..765f5487ba43 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -1121,8 +1121,9 @@ static int ntfs_dir_fsync(struct file *filp, loff_t start, loff_t end,
 
 	ntfs_debug("Entering for inode 0x%llx.", ni->mft_no);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	ctx = ntfs_attr_get_search_ctx(ni, NULL);
 	if (!ctx)
diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index b4fcfbe2da4c..719de82205e0 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -883,8 +883,9 @@ static int ntfs_setxattr(const struct xattr_handler *handler,
 	int err;
 	__le32 fattr;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	if (ntfs_is_reserved_lxattr(name) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1106,6 +1107,11 @@ static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
 int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
+	int err;
+
+	err = ntfs_emergency_state(NTFS_I(d_inode(dentry))->vol);
+	if (err)
+		return err;
 	return ntfs_set_acl_ex(idmap, d_inode(dentry), acl, type, false);
 }
 
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 007d1614b9ac..c05fce282096 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -47,9 +47,14 @@
 static int ntfs_file_open(struct inode *vi, struct file *filp)
 {
 	struct ntfs_inode *ni = NTFS_I(vi);
+	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	if (filp->f_mode & FMODE_WRITE)
+		err = ntfs_emergency_state(ni->vol);
+	else
+		err = NVolShutdown(ni->vol) ? -EIO : 0;
+	if (err)
+		return err;
 
 	if (sizeof(unsigned long) < 8) {
 		if (i_size_read(vi) > MAX_LFS_FILESIZE)
@@ -168,8 +173,9 @@ static int ntfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 
 	ntfs_debug("Entering for inode 0x%llx.", ni->mft_no);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = file_write_and_wait_range(filp, start, end);
 	if (err)
@@ -311,8 +317,9 @@ int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct ntfs_inode *ni = NTFS_I(vi);
 	struct ntfs_volume *vol = ni->vol;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = setattr_prepare(idmap, dentry, attr);
 	if (err)
@@ -589,15 +596,16 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	int err;
 	loff_t old_data_size, old_init_size;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	if (NInoWofCompressed(ni))
 		return -EOPNOTSUPP;
 
 	if (NInoEncrypted(ni)) {
-		ntfs_error(vi->i_sb, "Writing for %s files is not supported yet",
-			   NInoCompressed(ni) ? "Compressed" : "Encrypted");
+		ntfs_warning(vi->i_sb, "Writing for %s files is not supported yet",
+			     NInoCompressed(ni) ? "Compressed" : "Encrypted");
 		return -EOPNOTSUPP;
 	}
 
@@ -708,9 +716,15 @@ static int ntfs_file_mmap_prepare(struct vm_area_desc *desc)
 {
 	struct file *file = desc->file;
 	struct inode *inode = file_inode(file);
+	struct ntfs_volume *vol = NTFS_SB(file->f_mapping->host->i_sb);
+	int ret;
 
-	if (NVolShutdown(NTFS_SB(file->f_mapping->host->i_sb)))
-		return -EIO;
+	if (file->f_mode & FMODE_WRITE)
+		ret = ntfs_emergency_state(vol);
+	else
+		ret = NVolShutdown(vol) ? -EIO : 0;
+	if (ret)
+		return ret;
 
 	if (NInoCompressed(NTFS_I(inode)) || NInoWofCompressed(NTFS_I(inode)))
 		return -EOPNOTSUPP;
@@ -836,7 +850,9 @@ static int ntfs_ioctl_set_volume_label(struct file *filp, unsigned long arg)
 	if (ret)
 		goto out;
 
-	ret = ntfs_write_volume_label(vol, label);
+	ret = ntfs_emergency_state(vol);
+	if (!ret)
+		ret = ntfs_write_volume_label(vol, label);
 	mnt_drop_write_file(filp);
 out:
 	kfree(label);
@@ -853,6 +869,11 @@ static int ntfs_ioctl_fitrim(struct ntfs_volume *vol, unsigned long arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust $Bitmap after an error. */
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	dev = vol->sb->s_bdev;
 	if (!bdev_max_discard_sectors(dev))
 		return -EOPNOTSUPP;
@@ -1136,6 +1157,10 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 	if (mode & ~(NTFS_FALLOC_FL_SUPPORTED))
 		return -EOPNOTSUPP;
 
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	if (NInoCompressed(ni) || NInoEncrypted(ni) || NInoWofCompressed(ni))
 		return -EOPNOTSUPP;
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index a777de8a80c7..ba2b262eec73 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2302,7 +2302,13 @@ void ntfs_evict_big_inode(struct inode *vi)
 
 	truncate_inode_pages_final(&vi->i_data);
 
-	if (!vi->i_nlink) {
+	/*
+	 * After an error don't free the on-disk structures of an unlinked
+	 * inode: the freed mft record would be written right away while the
+	 * rest of the deletion can't be written back anymore. Leave the inode
+	 * to chkdsk and only release it from memory.
+	 */
+	if (!vi->i_nlink && !ntfs_emergency_state(ni->vol)) {
 		if (!NInoAttr(ni)) {
 			/* Never called with extent inodes */
 			WARN_ON(ni->nr_extents == -1);
@@ -2392,6 +2398,8 @@ int ntfs_show_options(struct seq_file *sf, struct dentry *root)
 		if (on_errors_arr[i].val == vol->on_errors)
 			seq_printf(sf, ",errors=%s", on_errors_arr[i].str);
 	}
+	if (NVolEmergencyRO(vol))
+		seq_puts(sf, ",emergency_ro");
 	seq_printf(sf, ",mft_zone_multiplier=%i", vol->mft_zone_multiplier);
 	if (NVolSysImmutable(vol))
 		seq_puts(sf, ",sys_immutable");
@@ -2754,8 +2762,16 @@ int __ntfs_write_inode(struct inode *vi, int sync)
 	ntfs_debug("Entering for %sinode 0x%llx.", NInoAttr(ni) ? "attr " : "",
 			ni->mft_no);
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	/*
+	 * After an error only $Volume is still written: it holds
+	 * VOLUME_IS_DIRTY, see ntfs_error_work().
+	 */
+	err = ntfs_emergency_state(ni->vol);
+	if (err) {
+		if (err != -EROFS || vi != ni->vol->vol_ino)
+			return err;
+		err = 0;
+	}
 
 	/*
 	 * Dirty attribute inodes are written via their real inodes so just
diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index c812d7f19b36..d0fae2712b8f 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -717,9 +717,11 @@ static int __ntfs_write_iomap_begin(struct inode *inode, loff_t offset,
 				    struct iomap *iomap, int ntfs_iomap_flags)
 {
 	struct ntfs_inode *ni = NTFS_I(inode);
+	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	if (!NInoNonResident(ni)) {
 		mutex_lock(&ni->mrec_lock);
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 4b7449495375..bcba19c6ea24 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -2755,6 +2755,11 @@ int ntfs_mft_record_free(struct ntfs_volume *vol, struct ntfs_inode *ni)
 	if (!vol || !ni)
 		return -EINVAL;
 
+	/* The freed record goes out right away, the rest of the deletion can't. */
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	ntfs_debug("Entering for inode 0x%llx.\n", (long long)ni->mft_no);
 
 	ni_mrec = map_mft_record(ni);
@@ -3097,8 +3102,9 @@ int ntfs_mft_writepages(struct address_space *mapping,
 	struct folio *folio = NULL;
 	int error;
 
-	if (NVolShutdown(NTFS_I(mapping->host)->vol))
-		return -EIO;
+	error = ntfs_emergency_state(NTFS_I(mapping->host)->vol);
+	if (error)
+		return error;
 
 	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
 		error = ntfs_write_mft_block(folio, wbc);
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index fdf52fac4329..d577ce274057 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -740,8 +740,9 @@ static int ntfs_create(struct mnt_idmap *idmap, struct inode *dir,
 	__le16 *uname;
 	int uname_len, err;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	uname_len = ntfs_nlstoucs(vol, dentry->d_name.name, dentry->d_name.len,
 				  &uname, NTFS_MAX_NAME_LEN);
@@ -1015,8 +1016,9 @@ static int ntfs_unlink(struct inode *dir, struct dentry *dentry)
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	uname_len = ntfs_nlstoucs(vol, dentry->d_name.name, dentry->d_name.len,
 				  &uname, NTFS_MAX_NAME_LEN);
@@ -1059,8 +1061,9 @@ static struct dentry *ntfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	__le16 *uname;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return ERR_PTR(-EIO);
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return ERR_PTR(err);
 
 	uname_len = ntfs_nlstoucs(vol, dentry->d_name.name, dentry->d_name.len,
 				  &uname, NTFS_MAX_NAME_LEN);
@@ -1100,8 +1103,9 @@ static int ntfs_rmdir(struct inode *dir, struct dentry *dentry)
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	ni = NTFS_I(vi);
 	uname_len = ntfs_nlstoucs(vol, dentry->d_name.name, dentry->d_name.len,
@@ -1265,8 +1269,9 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	struct ntfs_inode *old_dir_ni = NTFS_I(old_dir), *new_dir_ni = NTFS_I(new_dir);
 	bool new_dir_first = false;
 
-	if (NVolShutdown(old_dir_ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	if (flags & (RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
@@ -1411,8 +1416,9 @@ static int ntfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	int usrc_len;
 	int symlen = strlen(symname);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	usrc_len = ntfs_nlstoucs(vol, dentry->d_name.name,
 				 dentry->d_name.len, &usrc, NTFS_MAX_NAME_LEN);
@@ -1457,8 +1463,9 @@ static int ntfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	uname_len = ntfs_nlstoucs(vol, dentry->d_name.name,
 			dentry->d_name.len, &uname, NTFS_MAX_NAME_LEN);
@@ -1510,8 +1517,9 @@ static int ntfs_link(struct dentry *old_dentry, struct inode *dir,
 	int err;
 	struct ntfs_inode *ni = NTFS_I(vi), *dir_ni = NTFS_I(dir);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	uname_len = ntfs_nlstoucs(vol, dentry->d_name.name,
 			dentry->d_name.len, &uname, NTFS_MAX_NAME_LEN);
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 4066bacabe37..12ad2ce938ba 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -269,6 +269,8 @@ static int ntfs_reconfigure(struct fs_context *fc)
 
 	ntfs_debug("Entering with remount");
 
+	/* Mark the volume dirty first if an error made it read-only. */
+	flush_work(&vol->error_work);
 	sync_filesystem(sb);
 
 	/*
@@ -338,7 +340,28 @@ void ntfs_handle_error(struct super_block *sb)
 		return;
 
 	if (vol->on_errors == ON_ERRORS_REMOUNT_RO) {
-		sb->s_flags |= SB_RDONLY;
+		if (!(sb->s_flags & SB_BORN)) {
+			/*
+			 * Still mounting: the mounter holds s_umount and
+			 * nothing can freeze the superblock yet, so make it
+			 * a read-only mount.
+			 */
+			sb->s_flags |= SB_RDONLY;
+		} else {
+			/*
+			 * Don't set SB_RDONLY: that needs sb->s_umount and a
+			 * proper remount, and setting it while the volume is
+			 * frozen makes thaw_super() leave the s_writers rwsems
+			 * locked. NV_EmergencyRO makes the volume refuse
+			 * modifications instead and NV_Errors keeps it from
+			 * being remounted read-write. The error work marks
+			 * the volume dirty on disk.
+			 */
+			NVolSetErrors(vol);
+			if (test_and_set_bit(NV_EmergencyRO, &vol->flags))
+				return;
+			queue_work(ntfs_wq, &vol->error_work);
+		}
 		pr_crit("(device %s): Filesystem has been set read-only\n",
 			sb->s_id);
 	} else if (vol->on_errors == ON_ERRORS_PANIC) {
@@ -423,6 +446,29 @@ int ntfs_set_volume_flags(struct ntfs_volume *vol, __le16 flags)
 	return ntfs_write_volume_flags(vol, vol->vol_flags | flags);
 }
 
+/*
+ * ntfs_error_work - mark the volume dirty on disk after an error
+ * @work:	the error_work of the ntfs volume
+ *
+ * VOLUME_IS_DIRTY makes chkdsk check the volume. It is set lazily on the first
+ * modification and ntfs_sync_fs() clears it again, so it may not be on disk
+ * when an error makes the volume read-only, and the inode writeback that would
+ * write it is refused from then on. __ntfs_write_inode() still writes $Volume
+ * in that state. This runs from a work item because ntfs_error() may be called
+ * with mft records locked. sb_start_intwrite() waits for a frozen volume to be
+ * thawed.
+ */
+static void ntfs_error_work(struct work_struct *work)
+{
+	struct ntfs_volume *vol = container_of(work, struct ntfs_volume,
+					       error_work);
+
+	sb_start_intwrite(vol->sb);
+	if (!ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY))
+		ntfs_commit_inode(vol->vol_ino);
+	sb_end_intwrite(vol->sb);
+}
+
 /*
  * ntfs_clear_volume_flags - clear bits in the volume information flags
  * @vol:	ntfs volume on which to modify the flags
@@ -1716,6 +1762,15 @@ static void ntfs_put_super(struct super_block *sb)
 
 	cancel_work_sync(&vol->precalc_work);
 
+	/*
+	 * If an error made the volume read-only, make sure it is marked dirty
+	 * even if the error work didn't get to run. The commit of $Volume
+	 * below writes it.
+	 */
+	disable_work_sync(&vol->error_work);
+	if (NVolEmergencyRO(vol))
+		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+
 	/*
 	 * Commit all inodes while they are still open in case some of them
 	 * cause others to be dirtied.
@@ -2566,6 +2621,7 @@ static int ntfs_init_fs_context(struct fs_context *fc)
 	init_rwsem(&vol->mftbmp_lock);
 	init_rwsem(&vol->lcnbmp_lock);
 	mutex_init(&vol->volume_label_lock);
+	INIT_WORK(&vol->error_work, ntfs_error_work);
 
 	fc->s_fs_info = vol;
 	fc->ops = &ntfs_context_ops;
diff --git a/fs/ntfs/volume.h b/fs/ntfs/volume.h
index bc85a9592245..4f10457be3dc 100644
--- a/fs/ntfs/volume.h
+++ b/fs/ntfs/volume.h
@@ -90,6 +90,7 @@
  * @sparse_compression_unit: Size of compression/sparse unit in clusters.
  * @lcn_empty_bits_per_page: Number of empty bits per page in the LCN bitmap.
  * @precalc_work: Work structure for background pre-calculation tasks.
+ * @error_work: Marks the volume dirty on disk after an error made it read-only.
  * @preallocated_size: reallocation size (in bytes).
  */
 struct ntfs_volume {
@@ -156,6 +157,7 @@ struct ntfs_volume {
 	u8 sparse_compression_unit;
 	unsigned int *lcn_empty_bits_per_page;
 	struct work_struct precalc_work;
+	struct work_struct error_work;
 	loff_t preallocated_size;
 };
 
@@ -184,6 +186,8 @@ struct ntfs_volume {
  * NV_Discard			Issue discard/TRIM commands for freed clusters.
  * NV_DisableSparse		Disable creation of sparse regions.
  * NV_NativeSymlinkRel		Translate absolute Windows reparse targets (native_symlink=rel).
+ * NV_EmergencyRO		An error made the volume read-only until it is
+ *				unmounted (errors=remount-ro).
  */
 enum {
 	NV_Errors,
@@ -203,6 +207,7 @@ enum {
 	NV_DisableSparse,
 	NV_NativeSymlinkRel,
 	NV_SymlinkNative,
+	NV_EmergencyRO,
 };
 
 /*
@@ -241,6 +246,23 @@ DEFINE_NVOL_BIT_OPS(Discard)
 DEFINE_NVOL_BIT_OPS(DisableSparse)
 DEFINE_NVOL_BIT_OPS(NativeSymlinkRel)
 DEFINE_NVOL_BIT_OPS(SymlinkNative)
+DEFINE_NVOL_BIT_OPS(EmergencyRO)
+
+/*
+ * ntfs_emergency_state - check whether the volume refuses modifications
+ * @vol:	ntfs volume to check
+ *
+ * Return -EIO if the volume was shut down, -EROFS if an error made it
+ * read-only (errors=remount-ro) and 0 otherwise.
+ */
+static inline int ntfs_emergency_state(struct ntfs_volume *vol)
+{
+	if (unlikely(NVolShutdown(vol)))
+		return -EIO;
+	if (unlikely(NVolEmergencyRO(vol)))
+		return -EROFS;
+	return 0;
+}
 
 static inline void ntfs_inc_free_clusters(struct ntfs_volume *vol, s64 nr)
 {

-- 
2.53.0

