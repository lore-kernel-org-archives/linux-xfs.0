Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C959337688;
	Tue, 16 Jun 2026 14:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618916; cv=none; b=K3hsjxHISjLvKWP+XmAwAqvqPv028C3SmNOF8f3SUo48dQtzoPWl94m4TxE1PWs2hfRhL9gPNdVj9yAjZxoyepzew25EDKYUDw/XuKG3JrcLbbtfHShLL4j9AaP8PSgPtNFEyqi1L4meUd9KtVFKr9ZAmjzxDBEVB/eHoNXxct4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618916; c=relaxed/simple;
	bh=Do5i3EDmjVE1e/AZzgM+lKWOADPulnojqc5162s3uhI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=QOMJmE2h1KF84BcpuEr0DW3+mZEvcKuTxJ55jKegEVeR0AicCatoivj9l6Upi87EqQE4U4qkRvKaULoWuymJKKYh81FOkpsMw2TGa6u+cxRrBN0lkEttBYnnRpOsXFWd3dKUKigvRxJsOPxCaFR40h+VlYTnMqHSUjrbIsMDrLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZugUIHc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZugUIHc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD56D1F000E9;
	Tue, 16 Jun 2026 14:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618915;
	bh=vrChKgbTI+0aqivTF5YP6Yuwbv2q4OzzhaoctlYZpaM=;
	h=From:Subject:Date:To:Cc;
	b=ZugUIHc6Aq2rgs4tUnGQK0fzxOeCN1jy0iKf7Vf80qCDDLK6ylLvc7KuHXyUyhlJo
	 AZ4pjovOvM3AIeDSgPv6PO7A3whILphjqK9LHMVXxNFU1VZF7lkNhlYMB1jOWnB6Sz
	 UhG//CfYLOufFNQ3ZrNvx+91YNRibbLrP0hKQDE9bHZeHr42naAiKqwRFynVRymqLi
	 tthie1w5XTiStq4bfzD81mlkabTxkvEI+0KDgVDwLsuvBOSI4blFtuQ3tL7AkjR3Th
	 e+/ppRyquEfTGTEP7bmj54Wozv4CxsR3CgH6qa1mkKZw9x2vuID8QiTAyb+NUfiPxK
	 UlR6GzLBYJVZg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC v2 00/18] fs: support freeze/thaw/mark_dead/sync with
 shared devices
Date: Tue, 16 Jun 2026 16:08:16 +0200
Message-Id: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANBYMWoC/42OQW6DMBRErxJ5XSPjCIS6ilSpB+i2ipA/HsAJt
 dE3kKYRdw8mF+hyRjNv5iEi2CGK98NDMBYXXfCb0G8H0fTGd5DOblpopUtVKi1vga8yziNYksV
 S92Gw4LobAplBVg2ZAoUm2EJsjJHRut+d/y2+Pj/E+WXGmS5opkROMTIRktj4pk9W2sj2jaxl4
 A+1hb/X8xgnhvlJjd7FKfB9/73kO/6fF5dcKkmkWlvp9liV+ekK9hiywJ04r+v6BAABAjoUAQA
 A
X-Change-ID: 20260602-work-super-bdev_holder_global-8cba5e52bed5
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 syzbot@syzkaller.appspotmail.com, Gao Xiang <xiang@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=7470; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Do5i3EDmjVE1e/AZzgM+lKWOADPulnojqc5162s3uhI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtybLbr8y1c30W0vfldvvn/t+KZpW5xrNywXP/AsY
 8Z9Kb8S3Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJbJ3LyLDwJO/0vkcmKru2
 6XiG/mJda+zzliVE2GuCZfDrg0x9zVUM/1St7sWmptTujS90iCkP2LhzYvzXgFUePaVnmsr+zs5
 +wQMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

This is a generalization of the device number to superblock so it works
for actual block device and anonymous (or even mtd) devices.

fs_holder_ops recovers the affected superblock from bdev->bd_holder. That
forces the holder of a block device to be exactly one superblock and makes
it impossible for several superblocks to share a single device.

erofs does exactly that. It can mount read-only "blob" devices that are
shared between many superblocks: a metadata-only erofs that indexes a set
of per-layer blobs (one filesystem instead of one per OCI layer), or an
incremental image whose base device is shared by several updates. Because
the block layer only tracks a single holder, a freeze, thaw, removal or
sync on such a device is never propagated to all the superblocks using it,
and the current infrastructure has no way to find them.

This series replaces the bd_holder-based lookup with a global, dev_t-keyed
table mapping each block device to the superblock(s) using it. The holder
argument becomes purely the block layer's exclusivity token -- a superblock,
or the file_system_type for a device shared within one filesystem type --
and the fs_holder_ops callbacks look the device up in the table and act on
every superblock registered for it: 1:1 for most filesystems, 1:many for
erofs.

Filesystems claim and release their devices through new
fs_bdev_file_open_by_{dev,path}() and fs_bdev_file_release() helpers; the
per-fs patches convert xfs, btrfs, ext4, f2fs and erofs over to them and
fix cramfs and romfs, which released the registered main device with a
raw bdev_fput().

Since every superblock is registered under its s_dev the table also
replaces the last s_dev-keyed walk of the super_blocks list:
user_get_super() resolves device numbers through it, so ustat() and
quotactl() now work on any device a filesystem claims and no longer
take sb_lock.

The longer-term motivation is to let userspace decide which devices may be
onlined from one central place, without having to teach every filesystem
about it individually.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- super: rework the device-to-superblock table reference counting: each
  (device, superblock) entry carries a single claim count and holds one
  passive reference on its superblock for the entry's lifetime. New prep
  patches convert s_count to refcount_t s_passive and make put_super()
  self-locking.
- super: preallocate the entry in alloc_super() and register it from the
  set callbacks through set_anon_super()/set_bdev_super(); an insert
  failure unwinds exactly like a set callback failure. The superblock
  stashes the entry in sb->s_super_dev and kill_super_notify() drops the
  claim through it.
- super: initialize the table from mnt_init(); the rootfs and shm mounts
  are created long before any initcall runs.
- super: fold the v1 "refuse to claim a frozen block device" patch into
  the registration helper and restore the EBUSY check for the primary
  device in setup_bdev_super(): additional devices (the xfs log, the ext4
  journal, erofs blobs) are now refused while frozen as well, answering
  Jan's question on v1 3/8.
- Split the core patch into table/helpers/switch-over and move the
  xfs/btrfs/ext4 conversions before the fs_holder_ops switch so no
  freeze/mark_dead events are lost mid-series; erofs follows the switch.
- New prep patches: the ext4 KUnit tests allocate anonymous devices and
  ocfs2 stops resetting s_dev on dismount.
- New: convert user_get_super() to the device table, plus a ustat()
  selftest.
- New: fix a pre-existing double release of the realtime device file and
  dangling buftarg pointers in xfs_open_devices()'s error unwind.
- New: convert f2fs's additional devices to the helpers; fix cramfs and
  romfs releasing the registered main device with a raw bdev_fput().
- erofs: drop the .shutdown() and .remove_bdev() implementations and the
  per-device "dead" flag. Immutable filesystems don't need them: the block
  layer sets GD_DEAD before fs_bdev_mark_dead() so in-flight bios fail
  anyway, erofs has no write path or journal to stop, and the read-only
  loop_change_fd() case must not be forced to -EIO. Patch from Gao Xiang,
  applied verbatim - thanks!
- btrfs: fix a general protection fault in close_fs_devices() on a failed
  mount (reported by syzbot). The release path took the superblock from
  device->fs_info, which is still NULL if open_ctree() fails before
  btrfs_init_devices_late(); it now uses bdev_file->private_data.
- erofs: the v1 conversion was sent with a generic boilerplate changelog;
  superseded by Gao's patch above.
- Collect Reviewed-by from Jan Kara and Tested-by from syzbot.
- Rebase onto v7.1-rc1.
- Link to v1: https://patch.msgid.link/20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org

---
Christian Brauner (18):
      xfs: fix the error unwind in xfs_open_devices()
      super: convert s_count to refcount_t s_passive
      super: take lock after last reference count
      fs, block: move blk_mode_t and fop_flags_t into <linux/types.h>
      ext4: use anonymous devices for KUnit test superblocks
      ocfs2: don't reset s_dev on dismount
      fs: maintain a global device-to-superblock table
      fs: add dedicated block device open helpers for filesystems
      xfs: port to fs_bdev_file_open_by_path()
      btrfs: open via dedicated fs bdev helpers
      ext4: open via dedicated fs bdev helpers
      fs: look up superblocks via the device table in fs_holder_ops
      fs: tolerate per-superblock freeze errors on shared devices
      erofs: open via dedicated fs bdev helpers
      f2fs: open via dedicated fs bdev helpers
      super: make fs_holder_ops private
      fs: look up the superblock via the device table in user_get_super()
      selftests/filesystems: add ustat() coverage

 fs/btrfs/volumes.c                               |  31 +-
 fs/cramfs/inode.c                                |   2 +-
 fs/erofs/super.c                                 |  35 +-
 fs/ext4/extents-test.c                           |   9 +-
 fs/ext4/mballoc-test.c                           |   9 +-
 fs/ext4/super.c                                  |  12 +-
 fs/f2fs/super.c                                  |   6 +-
 fs/internal.h                                    |   1 +
 fs/namespace.c                                   |   2 +
 fs/ocfs2/super.c                                 |   1 -
 fs/romfs/super.c                                 |   2 +-
 fs/super.c                                       | 620 ++++++++++++++++-------
 fs/xfs/xfs_buf.c                                 |   2 +-
 fs/xfs/xfs_super.c                               |  13 +-
 include/linux/blkdev.h                           |   9 -
 include/linux/fs.h                               |   2 -
 include/linux/fs/super.h                         |   8 +
 include/linux/fs/super_types.h                   |   4 +-
 include/linux/types.h                            |   2 +
 tools/testing/selftests/filesystems/.gitignore   |   1 +
 tools/testing/selftests/filesystems/Makefile     |   2 +-
 tools/testing/selftests/filesystems/ustat_test.c | 135 +++++
 22 files changed, 647 insertions(+), 261 deletions(-)
---
base-commit: 0c0d974f62e6603d4514e1a8035658edb353c68f
change-id: 20260602-work-super-bdev_holder_global-8cba5e52bed5

