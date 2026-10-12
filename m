Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5AB3A783F;
	Mon, 12 Oct 2026 10:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800494; cv=none; b=BljvYKpUMfCTOO9NhKbkcVT70h5OwmZLG7kqLw2Sp2jsWvlJN5VZm/mwtMiKE2iiPOi011DxGQ/nlyP3KsjOG92NTxBNFiOMTxHQf7CQzTMbwSdwldbZO7s6Tcteh1INZIwG+hMGrfRuIw03upmr8NKKwYJtiSBDOX/3IhDbl+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800494; c=relaxed/simple;
	bh=6AhU3x0Rtr+v1hynbuYFK/eQo62lYffxM8xmBfNctF0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=pnVtsTryyIk7Q2BgdLJQjofUcIhWrSpvsrrh2sbAQLhxjGt4QNFSM0ztDjcJLYByIgNQnOBSu6qAud6jKNzoFecshHKc46iFP53JQTP9Mbrgz5VnvbrjNtM1AF41YKUOxI1zF3L5QejQvXxfjw2jSiheyytiXS1c+1iDsPclZw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8N0YyT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8N0YyT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791881F0089B;
	Mon, 12 Oct 2026 10:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800474;
	bh=sGKpoGj+G3U3TdVRgcDQb+hr4OJpMswZvqZ0tDZEHpE=;
	h=From:Subject:Date:To:Cc;
	b=l8N0YyT9w7CeNCJ6AqW4uuYHubBjTlmxG2nhvtqug+M5LWP7chDWcgJ8Q4qp1A7a7
	 aP3ZE4yhy1mZHIFrbB1XNsKhGGkG45gUb4vTZcsTaJg1fYx7Pypr+p8QgXMnegZN1l
	 469PJbjDPZc3pgqL4+TQX1LlYti9wPvox9fLoqKBjbdoDfq0tkK+T+oKsDTRS5qYr+
	 y/x1ri+Ut7zt0D590edRyrTGt11FDZ4RSwg1T13C+i6T/nYbn7SYDT8KdH+A48NmFN
	 nKohtXc9DZiuN1And3uHh3hyXmX0REdTqNpqP137PajjZmbeubh8xCPeOLE8svlex8
	 bz4B3JmQ64IAA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 00/28] fs: don't set SB_RDONLY after filesystem errors
Date: Mon, 12 Oct 2026 12:20:45 +0200
Message-Id: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z2MSwoCMRAFrzL02g6TCAHdCh7ArYjk03Gikgxpv
 wxzdxMFl1W8VxMwlUgM626CQo/IMacKctGBG0w6EUZfGVSvtOylxGcuFwyMbI/F53R9Y1gtSSt
 tfe8U1N9YKMTXt7mH3XYDh5/kuz2Tu7Vam1nDhLaY5IamWlcEFv+uaAOY5w8ehgKHowAAAA==
X-Change-ID: 20261011-work-fs-sb_rdonly-f93e626bd0c2
To: Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=16145; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6AhU3x0Rtr+v1hynbuYFK/eQo62lYffxM8xmBfNctF0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJpu4b/8nkWd9lZt616NzfOLkK1Mmi69+UkVX4Fj
 ZXr82t8OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbi/5mRYdtxt09Lw899PNYX
 6LhVp0hZopHvbZQ0S1zaDEbFeP/rPxgZjlo5FE2LnDt5welLrE2efmvNwl7e8Ow/EMjGd3bXvSW
 N3AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

A lot of filesystems handle errors by setting SB_RDONLY on the
superblock. They do that from whatever context found the error and
without holding s_umount. That's never been okay. SB_RDONLY is supposed
to only change under s_umount through a proper remount.

And it breaks freezing. freeze_super() and thaw_super() both look at
sb_rdonly() to figure out whether the s_writers rwsems need to be taken
or released. So if an error sets SB_RDONLY while the filesystem is
frozen thaw_super() takes the read-only shortcut, leaves the rwsems
write-locked and marks the superblock unfrozen. Every writer after that
hangs in sb_start_write() and umount warns when it frees the locked
rwsems. jfs even oopses on umount. And the unlocked update of
sb->s_flags races with everyone else who writes it.

Karl noticed and proposed teaching thaw_super() to remember whether the
freeze took the rwsems (cf. [1]). But a filesystem changing SB_RDONLY
behind the VFS' back causes more problems than just confused freezing.
Jan preferred fixing the filesystems instead (cf. [2]) and I agree. ext4
and f2fs already stopped doing it. So this converts all the others to
what ext4 does:

- the error is recorded in filesystem private state and the filesystem
  refuses modifications with EROFS itself
- the superblock stays read-write and "emergency_ro" is shown in the
  mount options ("withdrawn" for gfs2, "ro_ops" for efivarfs)
- a remount to read-write fails with EROFS until umount
- a remount to read-only works so emergency remount (sysrq u) doesn't
  WARN, and it doesn't mark the filesystem clean

That's ext2, jfs, nilfs2, fat, exfat, hfs, affs, ufs, hpfs, ntfs, ocfs2,
zonefs, btrfs, gfs2, efivarfs and ubifs. For gfs2 it's the withdraw and
for efivarfs it's the notifier that flips SB_RDONLY when the efivar ops
switch between ops that can and can't set variables. ubifs can't be
frozen but it flips SB_RDONLY from any context all the same. hfsplus
only did it when it created the attributes tree, where it can't trigger,
so that check is simply limited to mount.

fat, exfat, hpfs, ntfs and ubifs keep setting SB_RDONLY for errors while
the filesystem is still being mounted. Until SB_BORN the mounter holds
s_umount and nothing can freeze the superblock so that's fine.

A few patches make the read-only remount work in the first place. exfat
and ocfs2 didn't inherit their mount options on remount so emergency
remount, which passes none, could fail on them. And gfs2 has a BUG_ON()
when it's remounted read-only while a withdraw is still pending that
this makes easier to hit. Those come before the conversion of the
respective filesystem. ext4 and xfs have the same problem with their own
error states. ext4 refused to go read-only in its emergency state at all
and a shut down xfs couldn't be remounted read-only either. So sysrq u
WARNed for every ext4 that hit an error and for every shut down xfs.
Both are fixed at the end of the series.

ecryptfs opens its lower files read-write unless the lower superblock is
read-only. On top of one of these filesystems every lookup of a regular
file would fail with EROFS after an error and leak the inode. umount
then reports busy inodes. ext4 already behaves like that and so does a
read-only bind mount underneath. The first two patches make ecryptfs
fall back to a read-only lower file and plug the leak.

There are user-visible changes but I think they're all fine. The big one
is that "mount -o remount,rw" doesn't make the filesystem writable again
after an error anymore. That's how ext4 behaves since
commit d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem
errors"). statfs() doesn't report ST_RDONLY after an error and a second
read-only mount of the device fails with EBUSY. Writes through file
descriptors opened before the error fail with EROFS now where they used
to succeed. ext2, fat, hfs, affs, ufs and ubifs fail fsync() with EROFS
after an error. Writeback drops what they can't write anymore so fsync()
would report success otherwise. And remount helpers that pass the shown
options back, busybox mount for example, trip over "emergency_ro".
That's already the case on ext4.

Every patch has a reproducer in the commit message. I ran all of them
in a VM against the unpatched and the patched kernel, the latter with
KASAN and kmemleak. There are selftests for ext2, jfs, nilfs2, gfs2 and
the ext4 and xfs remount changes.

This depends on three fixes that aren't upstream yet:

  super: don't put the remount context under s_umount
  super: keep the read-only state if a reconfiguration doesn't change it
  nilfs2: don't reconfigure a frozen superblock on mount

The first one matters most. This series makes errored filesystems
reachable for sysrq u and without it a concurrent umount deadlocks on
s_umount. The second one makes fc->sb_flags carry the current read-only
state for fspick() reconfigurations, which ->reconfigure() of fat, affs,
hfs, ufs, hpfs and btrfs rely on. The third one closes the last way
nilfs2 changes SB_RDONLY on a frozen superblock, through a mount that
reconfigures it.

With this no filesystem changes SB_RDONLY outside of mount and remount
anymore.

[1]: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
[2]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (28):
      ecryptfs: don't leak the inode when a lookup can't open the lower file
      ecryptfs: fall back to a read-only lower file
      ext2: don't set SB_RDONLY after filesystem errors
      jfs: don't set SB_RDONLY after filesystem errors
      nilfs2: don't set SB_RDONLY after filesystem errors
      fat: don't set SB_RDONLY after filesystem errors
      exfat: keep the current mount options on remount
      exfat: don't set SB_RDONLY after filesystem errors
      hfs: don't set SB_RDONLY after MDB write errors
      hfsplus: don't set SB_RDONLY when creating the attributes tree
      affs: don't set SB_RDONLY after filesystem errors
      ufs: don't set SB_RDONLY after filesystem errors
      hpfs: don't set SB_RDONLY after filesystem errors
      ntfs: don't set SB_RDONLY after filesystem errors
      ocfs2: keep options that can't change on remount
      ocfs2: don't set SB_RDONLY after filesystem errors
      zonefs: don't set SB_RDONLY after I/O errors
      btrfs: check BTRFS_FS_STATE_RO instead of SB_RDONLY at runtime
      btrfs: don't set SB_RDONLY after filesystem errors
      gfs2: wait for a pending withdraw before remounting read-only
      gfs2: don't set SB_RDONLY on withdraw
      efivarfs: stop using SB_RDONLY for read-only efivar ops
      ubifs: don't set SB_RDONLY after errors
      selftests/filesystems: test filesystem errors while frozen
      ext4: allow remounting read-only in the emergency state
      selftests/filesystems: test ext4 remounts in the emergency state
      xfs: allow remounting read-only after a shutdown
      selftests/filesystems: test xfs remounts after a shutdown

 Documentation/filesystems/zonefs.rst               |   5 +-
 fs/affs/affs.h                                     |   9 +
 fs/affs/amigaffs.c                                 |  10 +-
 fs/affs/file.c                                     |  16 +-
 fs/affs/inode.c                                    |   5 +
 fs/affs/namei.c                                    |  18 +
 fs/affs/super.c                                    |  24 +-
 fs/btrfs/acl.c                                     |   3 +-
 fs/btrfs/bio.c                                     |   2 +-
 fs/btrfs/block-group.c                             |   2 +-
 fs/btrfs/dev-replace.c                             |   2 +-
 fs/btrfs/discard.c                                 |   2 +-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/fs.h                                      |  14 +
 fs/btrfs/inode.c                                   |   8 +-
 fs/btrfs/ioctl.c                                   |   8 +-
 fs/btrfs/messages.c                                |  21 +-
 fs/btrfs/qgroup.c                                  |   4 +-
 fs/btrfs/reflink.c                                 |   3 +-
 fs/btrfs/super.c                                   |  45 +-
 fs/btrfs/sysfs.c                                   |   6 +-
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/btrfs/volumes.c                                 |   4 +-
 fs/btrfs/xattr.c                                   |   8 +-
 fs/ecryptfs/inode.c                                |   5 +-
 fs/ecryptfs/kthread.c                              |  19 +-
 fs/efivarfs/file.c                                 |   6 +
 fs/efivarfs/inode.c                                |  15 +
 fs/efivarfs/internal.h                             |  14 +-
 fs/efivarfs/super.c                                |  31 +-
 fs/exfat/exfat_fs.h                                |  19 +
 fs/exfat/file.c                                    |  54 +-
 fs/exfat/inode.c                                   |  11 +-
 fs/exfat/misc.c                                    |  24 +-
 fs/exfat/namei.c                                   |  27 +-
 fs/exfat/super.c                                   |  49 +-
 fs/ext2/balloc.c                                   |   5 +
 fs/ext2/dir.c                                      |   5 +-
 fs/ext2/ext2.h                                     |  14 +
 fs/ext2/file.c                                     |  16 +-
 fs/ext2/ialloc.c                                   |   2 +
 fs/ext2/inode.c                                    |  13 +-
 fs/ext2/ioctl.c                                    |   7 +
 fs/ext2/namei.c                                    |  10 +
 fs/ext2/super.c                                    |  62 ++-
 fs/ext2/xattr.c                                    |   2 +
 fs/ext4/super.c                                    |  20 +-
 fs/fat/dir.c                                       |   3 +
 fs/fat/fat.h                                       |  13 +
 fs/fat/fatent.c                                    |  11 +-
 fs/fat/file.c                                      |  19 +
 fs/fat/inode.c                                     |  26 +-
 fs/fat/misc.c                                      |  29 +-
 fs/fat/namei_msdos.c                               |   9 +
 fs/fat/namei_vfat.c                                |   9 +
 fs/gfs2/ops_fstype.c                               |   6 +-
 fs/gfs2/quota.c                                    |   2 +-
 fs/gfs2/super.c                                    |  41 +-
 fs/gfs2/util.c                                     |   8 +-
 fs/hfs/attr.c                                      |   3 +
 fs/hfs/dir.c                                       |  12 +
 fs/hfs/extent.c                                    |   5 +
 fs/hfs/hfs_fs.h                                    |  11 +
 fs/hfs/inode.c                                     |  30 +
 fs/hfs/mdb.c                                       |  18 +-
 fs/hfs/super.c                                     |   7 +-
 fs/hfsplus/btree.c                                 |   7 +-
 fs/hpfs/alloc.c                                    |   4 +-
 fs/hpfs/dir.c                                      |   3 +-
 fs/hpfs/file.c                                     |  17 +-
 fs/hpfs/hpfs_fn.h                                  |   9 +
 fs/hpfs/inode.c                                    |   2 +
 fs/hpfs/map.c                                      |   3 +-
 fs/hpfs/namei.c                                    |  14 +
 fs/hpfs/super.c                                    |  22 +-
 fs/jfs/acl.c                                       |   3 +
 fs/jfs/file.c                                      |  16 +-
 fs/jfs/inode.c                                     |   6 +-
 fs/jfs/ioctl.c                                     |   7 +
 fs/jfs/jfs_dtree.c                                 |   3 +-
 fs/jfs/jfs_extent.c                                |  10 +
 fs/jfs/jfs_incore.h                                |  12 +
 fs/jfs/jfs_inode.c                                 |   3 +
 fs/jfs/namei.c                                     |  12 +
 fs/jfs/super.c                                     |  69 ++-
 fs/jfs/xattr.c                                     |   3 +
 fs/nilfs2/file.c                                   |  15 +-
 fs/nilfs2/inode.c                                  |  13 +-
 fs/nilfs2/ioctl.c                                  |  36 +-
 fs/nilfs2/mdt.c                                    |   2 +-
 fs/nilfs2/namei.c                                  |   1 +
 fs/nilfs2/page.c                                   |   2 +-
 fs/nilfs2/segment.c                                |  13 +-
 fs/nilfs2/sufile.h                                 |   2 +-
 fs/nilfs2/super.c                                  |  35 +-
 fs/nilfs2/the_nilfs.h                              |   8 +
 fs/ntfs/aops.c                                     |   5 +-
 fs/ntfs/dir.c                                      |   5 +-
 fs/ntfs/ea.c                                       |  10 +-
 fs/ntfs/file.c                                     |  51 +-
 fs/ntfs/inode.c                                    |  22 +-
 fs/ntfs/iomap.c                                    |   6 +-
 fs/ntfs/mft.c                                      |  10 +-
 fs/ntfs/namei.c                                    |  40 +-
 fs/ntfs/super.c                                    |  58 +-
 fs/ntfs/volume.h                                   |  22 +
 fs/ocfs2/acl.c                                     |   3 +
 fs/ocfs2/file.c                                    |   8 +
 fs/ocfs2/ioctl.c                                   |   3 +
 fs/ocfs2/mmap.c                                    |   3 +
 fs/ocfs2/namei.c                                   |  21 +
 fs/ocfs2/ocfs2.h                                   |  12 +
 fs/ocfs2/refcounttree.c                            |   3 +
 fs/ocfs2/super.c                                   |  77 ++-
 fs/ocfs2/xattr.c                                   |   8 +
 fs/ubifs/dir.c                                     |   1 +
 fs/ubifs/file.c                                    |  24 +
 fs/ubifs/io.c                                      |   7 +-
 fs/ubifs/ioctl.c                                   |   4 +
 fs/ubifs/super.c                                   |   8 +-
 fs/ubifs/ubifs.h                                   |   1 +
 fs/ubifs/xattr.c                                   |   6 +
 fs/ufs/cylinder.c                                  |  12 +-
 fs/ufs/dir.c                                       |   5 +-
 fs/ufs/file.c                                      |  28 +-
 fs/ufs/inode.c                                     |   5 +
 fs/ufs/namei.c                                     |  22 +
 fs/ufs/super.c                                     |  74 ++-
 fs/ufs/ufs.h                                       |  10 +
 fs/xfs/xfs_super.c                                 |  15 +-
 fs/zonefs/file.c                                   |  17 +-
 fs/zonefs/super.c                                  |  37 +-
 fs/zonefs/zonefs.h                                 |  16 +
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/filesystems/sb_rdonly/.gitignore     |   5 +
 .../selftests/filesystems/sb_rdonly/Makefile       |   7 +
 .../testing/selftests/filesystems/sb_rdonly/config |   7 +
 .../filesystems/sb_rdonly/emergency_ro_test.c      | 612 +++++++++++++++++++++
 .../sb_rdonly/ext4_emergency_remount_test.c        | 312 +++++++++++
 .../filesystems/sb_rdonly/gfs2_withdraw_test.c     | 330 +++++++++++
 .../selftests/filesystems/sb_rdonly/settings       |   1 +
 .../sb_rdonly/xfs_shutdown_remount_test.c          | 307 +++++++++++
 142 files changed, 3216 insertions(+), 294 deletions(-)
---
base-commit: a5ebb76233b79db01e82e061173cb73c6d2b5c6b
change-id: 20261011-work-fs-sb_rdonly-f93e626bd0c2

