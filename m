Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91BA3438BA;
	Wed, 20 May 2026 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280650; cv=none; b=PEgH/dIeeNR2V4Cs/bXUQXic046rYbW0OtFgMPIek5oNVD1c5sOT6gP4ntgrIfrQE1J6AO0h7XkNxmQafjVfvNZeEBxJXqoeGbxH0h4HGhyYsbMujoiHwb9PkYFnKoUVQHZQ4QNDgyYC5ITw/PYRtplj/cxvgR8QuiIYoBPXhh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280650; c=relaxed/simple;
	bh=ZVRa+HkX4dyX4eLIuQX9X/xIIS5Xfq0MAUbxkOgscz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oCGEX72Mrmr5aQCtQ10D+Yc3x8+dW+qU1ZRIUbiqmqWU3vwt9hA5TwNyotjhcWc/ovjm9Pyz9CwmmXEj4lEcGjZS24ui6ftds354S9jE1fDXvJIdu5HmCSklR5kARH2a4o+od0iVujJ7dpMeNAandl5WBYKL+50KFCNC+4ynhcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAxExD7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAxExD7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A7D1F00893;
	Wed, 20 May 2026 12:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280648;
	bh=3GEIHKF35JluvQOpy9exSQmpcaZLR5m4pwZg7r97tXw=;
	h=From:To:Cc:Subject:Date;
	b=IAxExD7+7FxSjfV/43Ze9wsfKzGC2J00jnfaPFNhvksvf60HxSPEvBVZy7v4z8F4D
	 hyjZ/MxSj1r3/NEL0C9ZIQHyZqTheRKcDeeFcyrMQNq6+07Rwc+c64j0rFRkQHPXn7
	 MI1ECaQyjx942yP2MJyN2qiKMtQvhplsyzkbbTAK69DLyId1Fej2zj7aE6TcHofPv1
	 JdMulII63ee6if39G4Od/cSdmB/BxJ7xIHmL7yN+k2fGV/Al85Y4atLmHofN073zt1
	 BRfBgCWpmdyRiFAqPxpbOJYLb64EKe+7zgu+s7XpSiXnrXNqg1NwXq7YvNZF8ZLxkY
	 4I7D+hCwRb5Aw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org,
	david@fromorbit.com
Subject: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle tree
Date: Wed, 20 May 2026 14:36:58 +0200
Message-ID: <20260520123722.405752-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This patch series adds fs-verity support for XFS. This version stores
merkle tree beyond end of the file, the same way as ext4 does it. The
difference is that verity descriptor is stored at the next aligned 64k
block after the merkle tree last block. This is done due to sparse
merkle tree which doesn't store hashes of zero data blocks.

The patchset starts with a few fs-verity preparation patches. Then, a
few patches to allow iomap to work in post EOF region. The XFS fs-verity
implementation follows.

The tree is read by iomap into page cache at offset of next largest
folio past end of file. The same offset is used for on-disk.

This patchsets also synthesizes merkle tree block full of hashes of
zeroed data blocks. This merkle blocks are not stored on disk, they are
holes in the tree.

Testing. The -g verity is passing for 1k, 8k and 4k with/without quota
on 4k and 64k page size systems. Tested -g quick for enabled/disabled
fsverity. Also, overlay/080 overlay/089 with XFS as base. Compile test
for FSVERITY=no/yes.

This series based on v7.1-rc4.

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=b4/fsverity

xfsprogs:
https://github.com/alberand/xfsprogs/tree/b4/fsverity

xfstests:
https://github.com/alberand/xfstests/tree/b4/fsverity

Cc: fsverity@lists.linux.dev
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org

Cc: david@fromorbit.com
Cc: djwong@kernel.org
Cc: ebiggers@kernel.org
Cc: hch@lst.de

1: https://lore.kernel.org/linux-xfs/20260223132021.292832-1-hch@lst.de/

---
Changes in v10:
- Rebase to v7.1-rc3 with relevant adjustments
- Initialize ioend->io_vi to NULL to not get write work onto verity wq
- Range diff below
Changes in v9:
- Fix fsverity_fill_zerohash() parameter names
- A few fixes found by sashiko.dev:
	- Replace ip->i_mount->m_attr_geo->blksize with m_sb.sb_blocksize
	- Don't call xfs_trans_cancel() after xfs_trans_commit() in
	  xfs_fsverity_end_enable()
	- Call xfs_fsverity_delete_metadata() if verity enable failed
	- Change start/end type from xfs_fileoff_t to loff_t
	- Return xfs_trans_commit() error from
	  xfs_fsverity_cancel_unwritten()
Changes in v8:
- Return fsverity_ensure_verity_info() errors from
  ovl_ensure_verity_loaded()
Changes in v7:
- Move kerneldoc to fsverity_ensure_verity_info() definition
- Drop patch adding XFS traces
- Fix overly long line in the comment
- Make order of fserror and fsverity_error consistent
- Add overlay patch converting to fsverity_ensure_verity_info()
Changes in v6:
- Removed stub for fsverity_ensure_verity_info() as it's optimized out
- Rename fsverity_folio_zero_hash() to fsverify_fill_zerohash()
- Merge patches 8 to 10 into one
- Merge patch gerating zero_hash and fsverity_fill_zerohash() into one
- Add kerneldoc to fsverity_ensure_verity_info()
- Add comments to iomap_block_needs_zeroing()
Changes in v5:
- Add fserror_report_data_lost() for data blocks in page spanning EOF
- Issue fsverity metadata readahead in data readahead
- iomap_fsverity_write() return type fix
- Use of S_ISREG(mode)
- Make 65536 #define instead of open-coded
- Use transaction per unwritten extent removal
- Fetch fsverity_info for all fsverity metadata
- Revert fsverity_folio_zero_hash() stub as used in iomap
- Extend cancel_unwritten to whole file range to remove cow leftovers
- Drop delayed allocation on the COW fork on fsverity completion
Changes in v4:
- Use fserror interface in fsverity instead of fs callback
- Hoist pagecache_read from f2fs/ext4 to fsverity
- Refactor iomap code
- Fetch fsverity_info only for file data and merkle tree holes
- Do not disable preallocation, remove unwritten extents instead
- Offload fsverity hash I/O to fsverity workqueue in read path
- Store merkle tree at round_up(i_size, 64k)
- Add a spacing between merkle tree and fsverity descriptor as next 64k
  aligned block
- Squash helpers into first user commits
- Squash on-disk format changes into single commit
- Drop different offset for pagecache/on-disk
- Don't zero out pages in higher order folios in write path
- Link to v3: https://lore.kernel.org/fsverity/20260217231937.1183679-1-aalbersh@kernel.org/T/#t
Changes in v3:
- Different on-disk and pagecache offset
- Use read path ioends
- Switch to hashtable fsverity info
- Synthesize merkle tree blocks full of zeroes
- Other minor refactors
- Link to v2: https://lore.kernel.org/fsverity/20260114164210.GO15583@frogsfrogsfrogs/T/#t
Changes in v2:
- Move to VFS interface for merkle tree block reading
- Drop patchset for per filesystem workqueues
- Change how offsets of the descriptor and tree metadata is calculated
- Store fs-verity descriptor in data fork side by side with merkle tree
- Simplify iomap changes, remove interface for post eof read/write
- Get rid of extended attribute implementation
- Link to v1: https://lore.kernel.org/r/20250728-fsverity-v1-0-9e5443af0e34@kernel.org

-- >8 --

 1:  aabd8b112385 <  -:  ------------ fs-verity support for XFS with post EOF merkle tree
 -:  ------------ >  1:  ec15fda2f683 fs-verity support for XFS with post EOF merkle tree
 2:  f3a3cc5b6ab2 =  2:  97d22944e17f fsverity: report validation errors through fserror to fsnotify
 3:  c8155669bdff =  3:  f717e55c313c fsverity: expose ensure_fsverity_info()
 4:  83262640936a !  4:  38381b5ec63e ovl: use core fsverity ensure info interface
    @@ fs/overlayfs/util.c: char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const stru
        struct inode *inode = d_inode(datapath->dentry);
     -  struct file *filp;

    --  if (IS_VERITY(inode) && fsverity_get_info(inode) == NULL) {
    +-  if (!fsverity_active(inode) && IS_VERITY(inode)) {
     -          /*
     -           * If this inode was not yet opened, the verity info hasn't been
     -           * loaded yet, so we need to do that here to force it into memory.
 5:  6d63f3ee7604 =  5:  b4b86f757eaa fsverity: generate and store zero-block hash
 6:  800753879b5c =  6:  f9d2eaf0fdcd fsverity: pass digest size and hash of the all-zeroes block to ->write
 7:  c4e06f9d9c08 =  7:  87d8f4495aa5 fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
 8:  34be1a25ffd2 =  8:  2da572c7a3bf iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle fsverity
 9:  728df1f13e31 !  9:  3669ecfb610e iomap: teach iomap to read files with fsverity
    @@ fs/iomap/buffered-io.c: void iomap_readahead(const struct iomap_ops *ops,
                iter.status = iomap_readahead_iter(&iter, ctx,
                                        &cur_bytes_submitted);

    - ## fs/iomap/ioend.c ##
    -@@ fs/iomap/ioend.c: struct iomap_ioend *iomap_init_ioend(struct inode *inode,
    -   ioend->io_offset = file_offset;
    -   ioend->io_size = bio->bi_iter.bi_size;
    -   ioend->io_sector = bio->bi_iter.bi_sector;
    -+  ioend->io_vi = NULL;
    -   ioend->io_private = NULL;
    -   return ioend;
    - }
    -
      ## include/linux/iomap.h ##
     @@ include/linux/iomap.h: struct iomap_ioend {
        loff_t                  io_offset;      /* offset in the file */
10:  9eb9dd92b762 = 10:  a8989fbd29f1 iomap: introduce iomap_fsverity_write() for writing fsverity metadata
11:  27602df28674 = 11:  04b23426b5cf xfs: introduce fsverity on-disk changes
12:  544c81d26e7c = 12:  ba69a8817d13 xfs: initialize fs-verity on file open
13:  6158f03b2ad4 = 13:  e2b59e6cd4da xfs: don't allow to enable DAX on fs-verity sealed inode
14:  03b1f44c53b2 = 14:  9e2628f17346 xfs: disable direct read path for fs-verity files
15:  96c9f90ade98 = 15:  3dea5f7e5481 xfs: handle fsverity I/O in write/read path
16:  e864ce49e5b3 = 16:  ff837a33e8f5 xfs: use read ioend for fsverity data verification
17:  b06bb3eefa38 = 17:  5c79a1e5f6ff xfs: add fs-verity support
18:  567d5190bfd9 = 18:  af3c36498d1c xfs: remove unwritten extents after preallocations in fsverity metadata
19:  b952307f139d = 19:  744cf7ec0842 xfs: add fs-verity ioctls
20:  3f5382888801 = 20:  d47aac1643a7 xfs: advertise fs-verity being available on filesystem
21:  b87668403694 = 21:  48e83ac7e6c2 xfs: check and repair the verity inode flag state
22:  eec854161680 = 22:  2a9f58d29909 xfs: introduce health state for corrupted fsverity metadata
23:  9ddc2cf10f52 = 23:  b5bf49f2e750 xfs: enable ro-compat fs-verity flag

Andrey Albershteyn (20):
  fsverity: report validation errors through fserror to fsnotify
  fsverity: expose ensure_fsverity_info()
  ovl: use core fsverity ensure info interface
  fsverity: generate and store zero-block hash
  fsverity: pass digest size and hash of the all-zeroes block to ->write
  fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
  iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle
    fsverity
  iomap: teach iomap to read files with fsverity
  iomap: introduce iomap_fsverity_write() for writing fsverity metadata
  xfs: introduce fsverity on-disk changes
  xfs: initialize fs-verity on file open
  xfs: don't allow to enable DAX on fs-verity sealed inode
  xfs: disable direct read path for fs-verity files
  xfs: handle fsverity I/O in write/read path
  xfs: use read ioend for fsverity data verification
  xfs: add fs-verity support
  xfs: remove unwritten extents after preallocations in fsverity
    metadata
  xfs: add fs-verity ioctls
  xfs: introduce health state for corrupted fsverity metadata
  xfs: enable ro-compat fs-verity flag

Darrick J. Wong (2):
  xfs: advertise fs-verity being available on filesystem
  xfs: check and repair the verity inode flag state

 fs/btrfs/verity.c              |   6 +-
 fs/ext4/verity.c               |  36 +--
 fs/f2fs/verity.c               |  34 +--
 fs/iomap/buffered-io.c         | 109 +++++++-
 fs/iomap/ioend.c               |   1 +
 fs/iomap/trace.h               |   3 +-
 fs/overlayfs/util.c            |  14 +-
 fs/verity/enable.c             |   4 +-
 fs/verity/fsverity_private.h   |   3 +
 fs/verity/measure.c            |   4 +-
 fs/verity/open.c               |  25 +-
 fs/verity/pagecache.c          |  55 ++++
 fs/verity/verify.c             |   4 +
 fs/xfs/Makefile                |   1 +
 fs/xfs/libxfs/xfs_bmap.c       |   7 +
 fs/xfs/libxfs/xfs_format.h     |  35 ++-
 fs/xfs/libxfs/xfs_fs.h         |   2 +
 fs/xfs/libxfs/xfs_health.h     |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |   8 +
 fs/xfs/libxfs/xfs_inode_util.c |   2 +
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/scrub/attr.c            |   7 +
 fs/xfs/scrub/common.c          |  53 ++++
 fs/xfs/scrub/common.h          |   2 +
 fs/xfs/scrub/inode.c           |   7 +
 fs/xfs/scrub/inode_repair.c    |  36 +++
 fs/xfs/xfs_aops.c              |  62 ++++-
 fs/xfs/xfs_bmap_util.c         |   8 +
 fs/xfs/xfs_file.c              |  19 +-
 fs/xfs/xfs_fsverity.c          | 457 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h          |  28 ++
 fs/xfs/xfs_health.c            |   1 +
 fs/xfs/xfs_inode.h             |   6 +
 fs/xfs/xfs_ioctl.c             |  14 +
 fs/xfs/xfs_iomap.c             |  15 +-
 fs/xfs/xfs_iops.c              |   4 +
 fs/xfs/xfs_message.c           |   4 +
 fs/xfs/xfs_message.h           |   1 +
 fs/xfs/xfs_mount.h             |   4 +
 fs/xfs/xfs_super.c             |   7 +
 include/linux/fsverity.h       |  18 +-
 include/linux/iomap.h          |  13 +
 42 files changed, 1020 insertions(+), 107 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

-- 
2.51.2

