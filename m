Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F271178F44
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741016031; cv=none; b=K/KdMFJxuT1dWAtS7cj2AA1ELyIwwUBw3Fa4LU9JtaMaVhHsXVJ0e45FEQTUaFr1vZyn+5PGbUmjtBYEo4BfBdCnZ090Ey+yJvMKXSuw6njfmk239lmBmcAgUBbhzF4iECIp/FskcxIJ5tClptE6WTWPUEPv7OiuJTRt9TElHR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741016031; c=relaxed/simple;
	bh=i+XUYHwvWqb8hYBEB9OSyqdm6eP85TIA0BMcmD3RyEo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cMuQqI7vqGpXqGeG5qmt6tRZR6Lqk7rTwlGyQe8CmOk1ytkFrOdWfGmUdh2abJ2qtXv1l6jtG3DMwVsFVrzwSkvJ7ajvHyIOk7pSpp5RoBaD43VAyOQ1sme6rli7ij4Lq2hSPHovqhJ04LY9/0HE4auhZIN0YxDTbFuA0NwTNYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bKWKDZGq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bKWKDZGq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=R6OFbI++yG6Eh8qt1VZFT/isY+vjuJ35Ci2F2fziHSg=; b=bKWKDZGq2TFGKqlug7tC0s8Cio
	pn+MvOEwjkgYEwHnb7PnzmQivxBVNSZaf8GPjHz170ezXgI9Hmiafgy47LZWuUWZB0oKgU6fmBSl4
	5m6bYZX7XEEEkZeR5RiFljY7hinG+0xt85ot1X8adA0wRzRthA5e/5+BhdtoILLeTKHBjncSNxFDg
	JZboNP53Vili9O9Em0oBh24pfd/Mz7/Kpvn+L7Ebm1e46hfnkgF1k3aWCSkaHXf9X1lO1C6TgiYnx
	IqMaosITAr2V8VtT/pfbo6yYil9+IwoZoE7Q4QvsY+L7mPuLkPK/yUILikYOXGHtsQ/D8v0I3bA5a
	Jjp7RRmQ==;
Received: from [50.204.211.212] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tp7nh-00000001Kjv-2fzd;
	Mon, 03 Mar 2025 15:33:49 +0000
Date: Mon, 3 Mar 2025 08:33:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: add support for zoned devices
Message-ID: <Z8XL3ZduUCceA4hJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The following changes since commit 0a1fd78080c8c9a5582e82100bd91b87ae5ac57c:

  Merge branch 'vfs-6.15.iomap' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs into xfs-6.15-merge (2025-03-03 13:01:06 +0100)

are available in the Git repository at:

  git://git.infradead.org/users/hch/xfs.git tags/xfs-zoned-allocator-2025-03-03

for you to fetch changes up to 9c477912b2f58da71751f244aceecf5f8cc549ed:

  xfs: export max_open_zones in sysfs (2025-03-03 08:17:10 -0700)

----------------------------------------------------------------
xfs: add support for zoned devices

Add support for the new zoned space allocator and thus for zoned devices:

    https://zonedstorage.io/docs/introduction/zoned-storage

to XFS. This has been developed for and tested on both SMR hard drives,
which are the oldest and most common class of zoned devices:

   https://zonedstorage.io/docs/introduction/smr

and ZNS SSDs:

   https://zonedstorage.io/docs/introduction/zns

It has not been tested with zoned UFS devices, as their current capacity
points and performance characteristics aren't too interesting for XFS
use cases (but never say never).

Sequential write only zones are only supported for data using a new
allocator for the RT device, which maps each zone to a rtgroup which
is written sequentially.  All metadata and (for now) the log require
using randomly writable space. This means a realtime device is required
to support zoned storage, but for the common case of SMR hard drives
that contain random writable zones and sequential write required zones
on the same block device, the concept of an internal RT device is added
which means using XFS on a SMR HDD is as simple as:

$ mkfs.xfs /dev/sda
$ mount /dev/sda /mnt

When using NVMe ZNS SSDs that do not support conventional zones, the
traditional multi-device RT configuration is required.  E.g. for an
SSD with a conventional namespace 1 and a zoned namespace 2:

$ mkfs.xfs /dev/nvme0n1 -o rtdev=/dev/nvme0n2
$ mount -o rtdev=/dev/nvme0n2 /dev/nvme0n1 /mnt

The zoned allocator can also be used on conventional block devices, or
on conventional zones (e.g. when using an SMR HDD as the external RT
device).  For example using zoned XFS on normal SSDs shows very nice
performance advantages and write amplification reduction for intelligent
workloads like RocksDB.

Some work is still in progress or planned, but should not affect the
integration with the rest of XFS or the on-disk format:

 - support for quotas
 - support for reflinks

Note that the I/O path already supports reflink, but garbage collection
isn't refcount aware yet and would unshare shared blocks, thus rendering
the feature useless.

----------------------------------------------------------------
Christoph Hellwig (42):
      xfs: reflow xfs_dec_freecounter
      xfs: generalize the freespace and reserved blocks handling
      xfs: support reserved blocks for the rt extent counter
      xfs: trace in-memory freecounter reservations
      xfs: fixup the metabtree reservation in xrep_reap_metadir_fsblocks
      xfs: make metabtree reservations global
      xfs: reduce metafile reservations
      xfs: factor out a xfs_rt_check_size helper
      xfs: add a rtg_blocks helper
      xfs: move xfs_bmapi_reserve_delalloc to xfs_iomap.c
      xfs: skip always_cow inodes in xfs_reflink_trim_around_shared
      xfs: refine the unaligned check for always COW inodes in xfs_file_dio_write
      xfs: support XFS_BMAPI_REMAP in xfs_bmap_del_extent_delay
      xfs: add a xfs_rtrmap_highest_rgbno helper
      xfs: define the zoned on-disk format
      xfs: allow internal RT devices for zoned mode
      xfs: export zoned geometry via XFS_FSOP_GEOM
      xfs: disable sb_frextents for zoned file systems
      xfs: disable FITRIM for zoned RT devices
      xfs: don't call xfs_can_free_eofblocks from ->release for zoned inodes
      xfs: skip zoned RT inodes in xfs_inodegc_want_queue_rt_file
      xfs: parse and validate hardware zone information
      xfs: add the zoned space allocator
      xfs: add support for zoned space reservations
      xfs: implement zoned garbage collection
      xfs: implement buffered writes to zoned RT devices
      xfs: implement direct writes to zoned RT devices
      xfs: wire up zoned block freeing in xfs_rtextent_free_finish_item
      xfs: hide reserved RT blocks from statfs
      xfs: support growfs on zoned file systems
      xfs: allow COW forks on zoned file systems in xchk_bmap
      xfs: support xchk_xref_is_used_rt_space on zoned file systems
      xfs: support xrep_require_rtext_inuse on zoned file systems
      xfs: enable fsmap reporting for internal RT devices
      xfs: disable reflink for zoned file systems
      xfs: disable rt quotas for zoned file systems
      xfs: enable the zoned RT device feature
      xfs: support zone gaps
      xfs: add a max_open_zones mount option
      xfs: wire up the show_stats super operation
      xfs: contain more sysfs code in xfs_sysfs.c
      xfs: export max_open_zones in sysfs

Hans Holmberg (2):
      xfs: support write life time based data placement
      xfs: export zone stats in /proc/*/mountstats

 fs/xfs/Makefile                  |    7 +-
 fs/xfs/libxfs/xfs_bmap.c         |  316 +---------
 fs/xfs/libxfs/xfs_bmap.h         |    7 +-
 fs/xfs/libxfs/xfs_format.h       |   20 +-
 fs/xfs/libxfs/xfs_fs.h           |   14 +-
 fs/xfs/libxfs/xfs_group.h        |   31 +-
 fs/xfs/libxfs/xfs_ialloc.c       |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c    |   21 +-
 fs/xfs/libxfs/xfs_inode_util.c   |    1 +
 fs/xfs/libxfs/xfs_log_format.h   |    7 +-
 fs/xfs/libxfs/xfs_metafile.c     |  167 ++++--
 fs/xfs/libxfs/xfs_metafile.h     |    6 +-
 fs/xfs/libxfs/xfs_ondisk.h       |    6 +-
 fs/xfs/libxfs/xfs_rtbitmap.c     |   11 +
 fs/xfs/libxfs/xfs_rtgroup.c      |   39 +-
 fs/xfs/libxfs/xfs_rtgroup.h      |   50 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   19 +
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    2 +
 fs/xfs/libxfs/xfs_sb.c           |   82 ++-
 fs/xfs/libxfs/xfs_types.h        |   28 +
 fs/xfs/libxfs/xfs_zones.c        |  186 ++++++
 fs/xfs/libxfs/xfs_zones.h        |   35 ++
 fs/xfs/scrub/agheader.c          |    2 +
 fs/xfs/scrub/bmap.c              |    4 +-
 fs/xfs/scrub/fscounters.c        |   22 +-
 fs/xfs/scrub/fscounters_repair.c |   12 +-
 fs/xfs/scrub/inode.c             |    7 +
 fs/xfs/scrub/inode_repair.c      |    4 +-
 fs/xfs/scrub/newbt.c             |    2 +-
 fs/xfs/scrub/reap.c              |    9 +-
 fs/xfs/scrub/repair.c            |   37 +-
 fs/xfs/scrub/rtbitmap.c          |   11 +-
 fs/xfs/scrub/rtrefcount_repair.c |   34 +-
 fs/xfs/scrub/rtrmap_repair.c     |   29 +-
 fs/xfs/scrub/scrub.c             |    2 +
 fs/xfs/xfs_aops.c                |  171 +++++-
 fs/xfs/xfs_aops.h                |    3 +-
 fs/xfs/xfs_bmap_util.c           |   32 +-
 fs/xfs/xfs_bmap_util.h           |   12 +-
 fs/xfs/xfs_discard.c             |    3 +-
 fs/xfs/xfs_extent_busy.c         |    2 +-
 fs/xfs/xfs_extfree_item.c        |   35 +-
 fs/xfs/xfs_file.c                |  347 +++++++++--
 fs/xfs/xfs_fsmap.c               |   86 ++-
 fs/xfs/xfs_fsops.c               |   50 +-
 fs/xfs/xfs_fsops.h               |    3 +-
 fs/xfs/xfs_icache.c              |    6 +-
 fs/xfs/xfs_inode.c               |    3 +-
 fs/xfs/xfs_inode.h               |   28 +-
 fs/xfs/xfs_inode_item.c          |    1 +
 fs/xfs/xfs_inode_item_recover.c  |    1 +
 fs/xfs/xfs_ioctl.c               |   12 +-
 fs/xfs/xfs_iomap.c               |  528 ++++++++++++++++-
 fs/xfs/xfs_iomap.h               |    7 +-
 fs/xfs/xfs_iops.c                |   31 +-
 fs/xfs/xfs_log.c                 |    4 +
 fs/xfs/xfs_message.c             |    4 +
 fs/xfs/xfs_message.h             |    1 +
 fs/xfs/xfs_mount.c               |  206 ++++---
 fs/xfs/xfs_mount.h               |  131 ++++-
 fs/xfs/xfs_qm.c                  |    3 +-
 fs/xfs/xfs_reflink.c             |   18 +-
 fs/xfs/xfs_rtalloc.c             |  237 +++++---
 fs/xfs/xfs_rtalloc.h             |    5 -
 fs/xfs/xfs_super.c               |  165 ++++--
 fs/xfs/xfs_sysfs.c               |   75 ++-
 fs/xfs/xfs_sysfs.h               |    5 +-
 fs/xfs/xfs_trace.c               |    2 +
 fs/xfs/xfs_trace.h               |  214 ++++++-
 fs/xfs/xfs_zone_alloc.c          | 1211 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_zone_alloc.h          |   70 +++
 fs/xfs/xfs_zone_gc.c             | 1165 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_zone_info.c           |  105 ++++
 fs/xfs/xfs_zone_priv.h           |  119 ++++
 fs/xfs/xfs_zone_space_resv.c     |  253 ++++++++
 75 files changed, 5649 insertions(+), 937 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_zones.c
 create mode 100644 fs/xfs/libxfs/xfs_zones.h
 create mode 100644 fs/xfs/xfs_zone_alloc.c
 create mode 100644 fs/xfs/xfs_zone_alloc.h
 create mode 100644 fs/xfs/xfs_zone_gc.c
 create mode 100644 fs/xfs/xfs_zone_info.c
 create mode 100644 fs/xfs/xfs_zone_priv.h
 create mode 100644 fs/xfs/xfs_zone_space_resv.c
