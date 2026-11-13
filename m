Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571210;
	b=ldkdEBvv0EA3sU0b4qsf73PhYFJgxts9wQSJw5Pc6rJeqOFrB0DUtN3aAueW8yDQnjLF
	 1PK97R7gQWS8F/BLdXTLtHhqyaVmMTkjs4FxQ99XpQia/pfYp68pYTy1UsLw4L4/QpO7T
	 e153SCf7aAiD3emKY/kFzpeUa1JKdeBCslrVorYF2hrN9uN+0Lx4fKNcDpJG5+HnTDkvM
	 dEK9ejV3u+YIIqJ/c17w/4IfWE79g1/moBUegNFupjOq2zj2v/qxG0FxEL55hE1IYRjIN
	 VHaHceDkZNcf3imozO2XRZfBrvIlLrwsla7uiIuwILzPp8rJE/QQyrmCjOnwP0J3T4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571210;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=IWprbPwkQqPxXeS+kMxX8OuNnd1sijR3CtNVlcmSiAs=;
	b=YN7clzfgMG/ezQ/neVFqib3lzVMjdbayyPf1DmSLbYAFREYFSVGn36/Fcg55Lhse1Xq6
	 ss6zYfYev/FmqHubyP1uLtTJZjhwVucoji5UfU9Ix8Ss41oJswd6YhbzdZ5LMVguFyLdu
	 /oxW3AYwP4jRNTJN5UZ1bSaJI6mEcAPsfjDFAXRiSP3YYxNRR59N7zDOBBMTOfFO/J1Yt
	 NTEeOn1emfeDZrNlPfT1n6kCnSZ67CPkmGTul1gbYrNTfM3oEkXfVux57XWl88+pYy+x9
	 9yHtJuYTraR4+YmtTcjXyE4ENZH7rPVC8ZX7vOsJdDRQInpoW0HCQzQt+CTBA+apZ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TtipzD2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D349A606A32D;
	Fri, 13 Nov 2026 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TtipzD2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6D61F000C4;
	Fri, 13 Nov 2026 12:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571210;
	bh=IWprbPwkQqPxXeS+kMxX8OuNnd1sijR3CtNVlcmSiAs=;
	h=From:Subject:Date:To:Cc;
	b=TtipzD2D57k1FaW7n2aOXcsxOQUyGAOFQPuLkxWB/5ZUic2Hz/TevGioOwz5c3EuN
	 NwaWt1gjqJGSexamWcb6bAq3Z8exNSlhzD9AQ7q66hhnvKJN+1HZ3dyo7OqGD2sA53
	 8aSINs6GoSWacnPVC6xi3kaLoTU1vt0DKCbsEJUdOqFdPJq+pJtJpIcFeSQs1sd39M
	 Rzd30imuRd3XwgbgmO6sHxmbx55hp/aU2LE+X2e9NmKt+v9XnWz5PJ+c+KosXPx5WM
	 wxIR8TEp1vev9awx7oYI6VmTkVUVe3lifU0I9D36XpzXnY09txOBr5yN70nO69RSZt
	 Syt7IdyqiZBnA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v3 00/33] fs: don't set SB_RDONLY after filesystem errors
Date: Fri, 13 Nov 2026 12:58:56 +0100
Message-Id: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23OQQrCMBAF0KtI1qYkkxLRlfcQkSad2KgkMqNVk
 d7dRlEUXP7hz+PfBSNFZLGY3AVhHznmNAYznQjfNWmLMrZjFqDAaqW1vGTay8CS3YbanA43GeY
 GLVjXKg9i/DsShnh9mqv1K/PZ7dCfClQarmGUjprku3IqZBW4+pBVKZRiF/mU6fZc1+sCvofAn
 yG9lkpaNatNY1pvwC73SAkPVaatKEt6+CJg/o+AkYBQ18HWQTn7SwzD8ADWvmBZMQEAAA==
X-Change-ID: 20261011-work-fs-sb_rdonly-f93e626bd0c2
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Farhad Alemi <farhad.alemi@berkeley.edu>, Tyler Hicks <code@tyhicks.com>, 
 Jan Kara <jack@suse.cz>, Karl Mehltretter <kmehltretter@gmail.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=17051; i=brauner@kernel.org;
 h=from:subject:message-id; bh=99RT7ELH83mPhcnOk5YHQ3hDMsPWvJyllxxqXgpc3bE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z3z6+nZG49N+tZyTNT/xfHXCRZf3R82LA5vZJFWr
 FZaIVwwr6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiQmsY/pecPa36feWsd3/d
 fiUw1FyTiNFKLO5o8o88n8XqttV6bTsjw1/mCgWv6erPrk5KVg1i52jwWHV7g28Hx+w629z78pU
 /WAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

A lot of filesystems handle errors by setting SB_RDONLY from whatever
context found the error and without holding s_umount. SB_RDONLY is
supposed to only change under s_umount through a proper remount. So
that races with everyone else writing sb->s_flags and it breaks
freezing: freeze_super() and thaw_super() decide from sb_rdonly()
whether the s_writers rwsems need to be taken or released. An error
while frozen makes thaw_super() leave them write-locked, every writer
after that hangs in sb_start_write() and umount warns. jfs even oopses.

Karl proposed teaching thaw_super() to remember what the freeze took
(cf. [1]). Jan preferred fixing the filesystems like ext4 and f2fs
already did (cf. [2]) and I agree. v1 did that and every filesystem
grew the same checks in ->open, ->setattr, ->fsync and friends, so Jan
suggested a generic flag in the superblock instead (cf. [3]):

- sb->s_state gets SB_STATE_EMERGENCY_RO. It's only ever set and never
  cleared and SB_RDONLY stays untouched so freezing keeps working.
- a filesystem calls sb_set_emergency_ro() where it used to set
  SB_RDONLY
- the VFS refuses modifications with EROFS wherever sb_rdonly() does,
  also for files opened before the error, refuses the remount to
  read-write and a new freeze, and doesn't sync the superblock anymore:
  syncfs(2) and Q_SYNC fail with EROFS, sync(2) and umount skip it (Jan)
- /proc/mounts, statmount() and statfs() show it read-only and a
  remount to read-only works, so sysrq u doesn't WARN anymore, and
  doesn't mark the filesystem clean

Writeback isn't stopped. The flusher and the block device flushes in
sync(2) and kill_block_super() keep writing, so what ends up on disk is
what it is on mainline today and every filesystem decides what its
writeback still writes. The same goes for what doesn't pass through the
VFS: allocators, journals, the deletion of unlinked inodes and the xattr
and ACL setters that ecryptfs calls without write access on the lower
mount. That's about a third of the checks v1 had.

The stable fixes stay self-contained, a follow-up patch converts each of
exfat, hfs, ntfs, zonefs and ext4 to the generic state. fat, exfat, hpfs
and ntfs still set SB_RDONLY for errors during mount, nothing can freeze
before SB_BORN. A few patches make the read-only remount work in the
first place: exfat and ocfs2 didn't inherit their mount options on
remount, gfs2 BUG()s when remounted read-only during a withdraw, and
ext4 in its emergency state and a shut down xfs refused to go read-only
at all, so sysrq u WARNed for them. ecryptfs gets a read-only fallback
for its lower files, otherwise every lookup on top of an errored
filesystem fails with EROFS and leaks the inode.

The first two patches are jfs fixes for mainline: umount after an error
BUG()s because nothing commits the anonymous tlocks of allocations
writeback didn't get to, and slow symlinks read from disk didn't get
jfs_setattr().

There are user-visible changes but I think they're all fine. "mount -o
remount,rw" doesn't make the filesystem writable again after an error,
like ext4 since commit d3476f3dad4a ("ext4: don't set SB_RDONLY after
filesystem errors"). Writes through file descriptors opened before the
error, fsync(), syncfs() and Q_SYNC fail with EROFS and stores through
shared mappings get SIGBUS. FIFREEZE and dm suspend with lockfs fail
with EROFS like they already did for ext4, and the shutdown ioctls of
ext4, exfat, ntfs and btrfs skip the freeze after an error. A second
read-only mount of the device fails with EBUSY. And ext4 shows "ro" in
/proc/mounts and reports ST_RDONLY again after an error.

This has dependencies on vfs-7.5.super (cf. [4]). With this no
filesystem changes SB_RDONLY outside of mount and remount anymore.

[1]: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
[2]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf
[3]: https://lore.kernel.org/r/my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyocp3yxbnj@aphfqdiej2hs
[4]: https://lore.kernel.org/r/20261011-work-super-fixes-core-v1-0-c727176c5b53@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v3:
- New first patch: jfs frees the anonymous tlocks of an evicted inode
  instead of BUG()ing on umount after an error. That's a mainline bug,
  Cc stable.
- sync_filesystem() and sync(2) skip a superblock in the emergency
  state, syncfs(2) and Q_SYNC fail with EROFS. That's the VFS patch from
  the v1 thread after all, the jfs fix takes care of the BUG (Jan).
- freeze_super() refuses a new freeze in the emergency state with EROFS,
  the exfat, ntfs, btrfs and ext4 shutdown ioctls skip the freeze after
  an error.
- ext2, fat, affs, ufs and hfs don't refuse ->write_inode() anymore. The
  flusher wrote data and bitmaps but no inodes and new files were lost
  (sashiko).
- The ->sync_fs() checks of ext2, jfs, nilfs2, ocfs2 and ubifs are gone,
  the VFS doesn't call them in that state.
- ext2: ext2_freeze() doesn't check the emergency state anymore (Jan).
- jfs: refuse a resize after an error, keep FM_DIRTY with nointegrity
  when the error hit while frozen (sashiko).
- ntfs: ntfs_drop_big_inode() leaves unlinked inodes to chkdsk in the
  emergency state like ntfs_evict_big_inode() (sashiko).
- btrfs_force_shutdown() sets BTRFS_FS_STATE_RO too (Qu).
- ubifs: always use the emergency state, don't sync the write-buffers
  or the master node on a remount to read-only after an error, drop
  dirty folios and inodes after an error (Zhihao, sashiko).
- ecryptfs doesn't try to write the header through a read-only lower
  file when opening an empty file (sashiko).
- Dropped the selftests, fstests is the place for them (Christoph).
- The jfs symlink inode operations fix is a patch of its own.
- sb_rdonly_any() for the checks that need the read-only mount and the
  emergency state instead of open-coding the pair.
- Picked up the review tags. The ones for hfs, ntfs, ocfs2, nilfs2
  and the ext4 conversion are kept although those patches changed a
  bit (a ->sync_fs() or ->write_inode() hunk less, the shutdown ioctls
  skip the freeze). Jan's tag on the VFS patch isn't, it changed too
  much.
- Link to v2: https://patch.msgid.link/20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org

Changes in v2:
- Generic SB_STATE_EMERGENCY_RO in the superblock, the VFS refuses
  modifications. The checks at the VFS entry points of every filesystem
  are gone (Jan).
- The VFS patch from the v1 thread also hooked write_inode() and
  sync_filesystem(). Dropped, jfs still has to commit queued allocations
  after the error.
- /proc/mounts shows "ro" and statfs() reports ST_RDONLY again in the
  emergency state.
- The stable-tagged fixes stay self-contained, follow-up patches convert
  exfat, hfs, ntfs, zonefs and ext4 to the generic state.
- hfsplus checks the b-tree map records in hfsplus_fill_super() (Slava).
- Selftests expect ST_RDONLY and EROFS from fsync() on jfs too.
- ecryptfs refuses writes through a read-only lower file with EROFS.
  truncate(2) and creating a file ran into the WARN_ON_ONCE() in
  __kernel_write_iter() (sashiko).
- gfs2: bail out of the freeze loop when the filesystem withdrew in the
  meantime, keep the EIO from gfs2_make_fs_rw() for a remount to
  read-write and don't show "withdrawn" in the mount options (Andreas).
- Don't show "emergency_ro" and "ro_ops" in the mount options. Remount
  helpers that pass the shown options back trip over them. ext4 keeps
  showing "emergency_ro" like it does now (Andreas).
- Rebased onto current mainline. ntfs persists its error state itself
  since commit 521978c4f444, the error work uses that now, and the new
  named stream paths refuse modifications in the emergency state too.
- statmount() reports the emergency state as read-only too and
  remap_verify_area() refuses FICLONE and friends in that state.
- nilfs2 refuses going read-write in the emergency state itself because
  nilfs_get_tree() reconfigures the superblock without
  reconfigure_super(). zonefs keeps its check in ->write_iter() because
  the loop driver and others call it without rw_verify_area().
- ntfs runs a pending error work before umount persists the error
  state, hfsplus says which b-tree header node it couldn't load again.
- The reproducers moved out of the commit messages into git notes.
- Link to v1: https://patch.msgid.link/20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org

---
Christian Brauner (33):
      jfs: free uncommitted anonymous tlocks when evicting an inode
      jfs: use jfs_symlink_inode_operations in jfs_iget()
      ecryptfs: don't leak the inode when a lookup can't open the lower file
      ecryptfs: fall back to a read-only lower file
      fs: add a generic emergency read-only state
      ext2: don't set SB_RDONLY after filesystem errors
      jfs: don't set SB_RDONLY after filesystem errors
      nilfs2: don't set SB_RDONLY after filesystem errors
      fat: don't set SB_RDONLY after filesystem errors
      exfat: keep the current mount options on remount
      exfat: don't set SB_RDONLY after filesystem errors
      exfat: use the generic emergency read-only state
      hfs: don't set SB_RDONLY after MDB write errors
      hfs: use the generic emergency read-only state
      hfsplus: don't set SB_RDONLY when creating the attributes tree
      affs: don't set SB_RDONLY after filesystem errors
      ufs: don't set SB_RDONLY after filesystem errors
      hpfs: don't set SB_RDONLY after filesystem errors
      ntfs: don't set SB_RDONLY after filesystem errors
      ntfs: use the generic emergency read-only state
      ocfs2: keep the current mount options on remount
      ocfs2: don't set SB_RDONLY after filesystem errors
      zonefs: don't set SB_RDONLY after I/O errors
      zonefs: use the generic emergency read-only state
      btrfs: check BTRFS_FS_STATE_RO instead of SB_RDONLY at runtime
      btrfs: don't set SB_RDONLY after filesystem errors
      gfs2: wait for a pending withdraw before remounting read-only
      gfs2: don't set SB_RDONLY on withdraw
      efivarfs: stop using SB_RDONLY for read-only efivar ops
      ubifs: don't set SB_RDONLY after errors
      ext4: allow remounting read-only in the emergency state
      ext4: use the generic emergency read-only state
      xfs: allow remounting read-only after a shutdown

 Documentation/filesystems/porting.rst | 20 +++++++++++
 Documentation/filesystems/zonefs.rst  |  4 +--
 fs/affs/amigaffs.c                    |  4 +--
 fs/affs/super.c                       | 14 +++++---
 fs/attr.c                             |  4 +++
 fs/btrfs/acl.c                        |  3 +-
 fs/btrfs/bio.c                        |  2 +-
 fs/btrfs/block-group.c                |  2 +-
 fs/btrfs/dev-replace.c                |  2 +-
 fs/btrfs/discard.c                    |  2 +-
 fs/btrfs/disk-io.c                    |  4 +--
 fs/btrfs/fs.h                         | 20 +++++++----
 fs/btrfs/inode.c                      |  8 ++---
 fs/btrfs/ioctl.c                      | 13 ++++---
 fs/btrfs/messages.c                   | 16 +++++----
 fs/btrfs/qgroup.c                     |  4 +--
 fs/btrfs/reflink.c                    |  3 +-
 fs/btrfs/super.c                      | 35 +++++++++++++++---
 fs/btrfs/sysfs.c                      |  4 +--
 fs/btrfs/tree-checker.c               |  2 +-
 fs/btrfs/volumes.c                    |  4 +--
 fs/btrfs/xattr.c                      |  8 +++--
 fs/ecryptfs/file.c                    |  4 ++-
 fs/ecryptfs/inode.c                   | 13 ++++++-
 fs/ecryptfs/kthread.c                 | 15 ++++++--
 fs/ecryptfs/read_write.c              |  3 ++
 fs/efivarfs/file.c                    |  6 ++++
 fs/efivarfs/inode.c                   | 15 ++++++++
 fs/efivarfs/internal.h                | 14 +++++++-
 fs/efivarfs/super.c                   | 26 +++++++++-----
 fs/exfat/exfat_fs.h                   | 10 ++++++
 fs/exfat/file.c                       | 54 ++++++++++++++++++++--------
 fs/exfat/inode.c                      | 11 +++---
 fs/exfat/misc.c                       | 16 ++++++---
 fs/exfat/namei.c                      | 27 ++++++++------
 fs/exfat/super.c                      | 41 +++++++++++++--------
 fs/ext2/balloc.c                      |  5 +++
 fs/ext2/ialloc.c                      |  2 ++
 fs/ext2/inode.c                       |  4 ++-
 fs/ext2/super.c                       | 13 ++++---
 fs/ext2/xattr.c                       |  2 ++
 fs/ext4/ioctl.c                       |  4 +++
 fs/ext4/super.c                       | 19 ++++++----
 fs/fat/dir.c                          |  3 ++
 fs/fat/fatent.c                       | 11 +++++-
 fs/fat/file.c                         |  4 +++
 fs/fat/inode.c                        | 13 +++++--
 fs/fat/misc.c                         | 19 ++++++----
 fs/gfs2/quota.c                       |  2 +-
 fs/gfs2/super.c                       | 40 +++++++++++++++++----
 fs/gfs2/util.c                        |  7 ++--
 fs/hfs/attr.c                         |  3 ++
 fs/hfs/extent.c                       |  5 +++
 fs/hfs/inode.c                        |  7 ++++
 fs/hfs/mdb.c                          | 16 +++++----
 fs/hfs/super.c                        |  2 +-
 fs/hfsplus/btree.c                    | 42 ++++++++++++++--------
 fs/hfsplus/hfsplus_fs.h               |  1 +
 fs/hfsplus/super.c                    |  5 +++
 fs/hpfs/alloc.c                       |  4 +--
 fs/hpfs/dir.c                         |  2 +-
 fs/hpfs/map.c                         |  3 +-
 fs/hpfs/super.c                       | 11 ++++--
 fs/jfs/acl.c                          |  3 ++
 fs/jfs/inode.c                        | 15 +++++++-
 fs/jfs/ioctl.c                        |  4 +++
 fs/jfs/jfs_dtree.c                    |  3 +-
 fs/jfs/jfs_extent.c                   | 10 ++++++
 fs/jfs/jfs_incore.h                   |  6 ++++
 fs/jfs/jfs_inode.c                    |  3 ++
 fs/jfs/jfs_txnmgr.c                   | 68 +++++++++++++++++++++++++++++++++++
 fs/jfs/jfs_txnmgr.h                   |  1 +
 fs/jfs/super.c                        | 36 ++++++++++++++++---
 fs/jfs/xattr.c                        |  3 ++
 fs/namei.c                            |  3 +-
 fs/namespace.c                        |  5 ++-
 fs/nilfs2/inode.c                     |  4 +--
 fs/nilfs2/ioctl.c                     |  4 +++
 fs/nilfs2/mdt.c                       |  2 +-
 fs/nilfs2/page.c                      |  2 +-
 fs/nilfs2/segment.c                   | 13 ++++---
 fs/nilfs2/sufile.h                    |  2 +-
 fs/nilfs2/super.c                     | 25 +++++++++----
 fs/ntfs/aops.c                        |  5 +--
 fs/ntfs/dir.c                         |  5 +--
 fs/ntfs/ea.c                          | 10 ++++--
 fs/ntfs/file.c                        | 63 +++++++++++++++++++++++---------
 fs/ntfs/inode.c                       | 18 +++++++---
 fs/ntfs/iomap.c                       |  6 ++--
 fs/ntfs/mft.c                         | 10 ++++--
 fs/ntfs/named_stream.c                | 43 +++++++++++-----------
 fs/ntfs/namei.c                       | 40 ++++++++++++---------
 fs/ntfs/super.c                       | 56 +++++++++++++++++++++++++----
 fs/ntfs/volume.h                      | 13 +++++++
 fs/ocfs2/acl.c                        |  3 ++
 fs/ocfs2/super.c                      | 27 +++++++++++---
 fs/ocfs2/xattr.c                      |  8 +++++
 fs/open.c                             |  4 +++
 fs/proc_namespace.c                   |  2 +-
 fs/quota/dquot.c                      | 27 ++++++++++----
 fs/quota/quota.c                      | 13 +++++++
 fs/read_write.c                       |  5 +++
 fs/remap_range.c                      |  4 +++
 fs/statfs.c                           |  9 +++--
 fs/super.c                            | 17 +++++++++
 fs/sync.c                             | 14 ++++++--
 fs/ubifs/file.c                       | 12 +++++++
 fs/ubifs/io.c                         |  6 +++-
 fs/ubifs/super.c                      | 40 +++++++++++++--------
 fs/ubifs/xattr.c                      |  6 ++++
 fs/ufs/cylinder.c                     | 12 ++++---
 fs/ufs/super.c                        | 56 ++++++++++++++++++++---------
 fs/xfs/xfs_super.c                    | 13 +++++--
 fs/zonefs/file.c                      | 13 ++++---
 fs/zonefs/super.c                     | 25 ++++++++-----
 fs/zonefs/zonefs.h                    |  1 +
 include/linux/fs/super.h              | 23 ++++++++++++
 include/linux/fs/super_types.h        | 19 ++++++++++
 mm/memory.c                           |  6 ++++
 119 files changed, 1185 insertions(+), 343 deletions(-)
---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261011-work-fs-sb_rdonly-f93e626bd0c2

