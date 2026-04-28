Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E7033970F;
	Tue, 28 Apr 2026 08:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365235; cv=none; b=M55UwRbvvQ5lDpEIk57XTOckP/9LyeMNbNn4fec88cwEhrZQiRVSJkqj7mbINt+FOZTXz8IwpPHJReD5st12A7mZ48U8sl0c3wLx7L8ZcsNWKo2CsN6HbrjJEgzz1WEtnY4bU08XwXQ42fN+yGhwBC0Elj/ZkyJk7EMAAIlt/kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365235; c=relaxed/simple;
	bh=I1UFcAoYPGscbLBDLHC78A2Zf+xSyTiiDK0UcAySV9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aQVoS3STaji3MbkEO/R3NlHayLzKsDouz/fmnKGQBWPYnNEwDHSWRWxBDer/TSPwD0jjfPtjLcKu3tJOaqgfT5R+rJBkA/NWpXOVLkMBf7aGTPdWAaETdn2TVgQA7vNn3NBrXBolTCz+sSATFKLtu1jv3AcgTFwREzwJ6zz10x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNYcjbPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNYcjbPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C662C2BCAF;
	Tue, 28 Apr 2026 08:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365234;
	bh=I1UFcAoYPGscbLBDLHC78A2Zf+xSyTiiDK0UcAySV9Q=;
	h=From:To:Cc:Subject:Date:From;
	b=DNYcjbPzHmVQdZDUtktJ+m/39yVknK7pRSSqKQUEk97ss4zpD1X2RGr3OE+YQ+2/x
	 YWJA9Y5UX6Da8PXXPMAid+G8aiRiObM+a72ymh/zLZozUL3qPX++Ity5wYkYd3QrBc
	 lhTIH6t2wlTgf8ZbC0aPmTAE8BKQasicrfft19WMtka3QFSnXoZh7u7mJVwOqmCLhT
	 87VFw6sWodHLru2yx72DPc0uAB+kV6DB+cEJOToWg/STM2WlvIZ6xnJEn11Q2ExUa0
	 1DiwehTEb5vzEVPbqg/nJY+kcK5zhODi9KnxQanctVaQd42uGC0HMwurTSTQ24x+hR
	 5kYMQMuzNL+jA==
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
Subject: [PATCH v9 00/22] fs-verity support for XFS with post EOF merkle tree
Date: Tue, 28 Apr 2026 10:33:06 +0200
Message-ID: <20260428083332.768693-1-aalbersh@kernel.org>
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
fsverity. Also, overlay/080 overlay/089 with XFS as base.

This series based on v7.0 with Christoph's read ioends patchset [1].

Darrick, Christoph, I left your Reviewed-by tags on the commits which
have fixes for issues found by sashiko.dev. I've attached diff of
the v8 vs v9 below. Let me know if this a problem or you have more
comments for these changes.

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

--- >8 ---
ss (cb5e0282a061) fsverity: generate and store zero-block hash
diff --git a/left/include/linux/fsverity.h b/right/include/linux/fsverity.h
index e4503312d114..3c3250f6f272 100644
--- a/left/include/linux/fsverity.h
+++ b/right/include/linux/fsverity.h
@@ -201,8 +201,8 @@ bool fsverity_verify_blocks(struct fsverity_info *vi, struct folio *folio,
 			    size_t len, size_t offset);
 void fsverity_verify_bio(struct fsverity_info *vi, struct bio *bio);
 void fsverity_enqueue_verify_work(struct work_struct *work);
-void fsverity_fill_zerohash(struct folio *folio, size_t poff, size_t plen,
-			      struct fsverity_info *vi);
+void fsverity_fill_zerohash(struct folio *folio, size_t offset, size_t len,
+			    struct fsverity_info *vi);

 #else /* !CONFIG_FS_VERITY */

@@ -283,8 +283,8 @@ static inline void fsverity_enqueue_verify_work(struct work_struct *work)
 	WARN_ON_ONCE(1);
 }

-static inline void fsverity_fill_zerohash(struct folio *folio, size_t poff,
-		size_t plen, struct fsverity_info *vi)
+static inline void fsverity_fill_zerohash(struct folio *folio, size_t offset,
+		size_t len, struct fsverity_info *vi)
 {
 	WARN_ON_ONCE(1);
 }

wr (aebd19f490d9) xfs: add fs-verity support
diff --git a/left/fs/xfs/xfs_fsverity.c b/right/fs/xfs/xfs_fsverity.c
index 68d9736d19d9..a505616636f9 100644
--- a/left/fs/xfs/xfs_fsverity.c
+++ b/right/fs/xfs/xfs_fsverity.c
@@ -111,7 +111,7 @@ xfs_fsverity_write_descriptor(
 	int			error;
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
-	unsigned int		blksize = ip->i_mount->m_attr_geo->blksize;
+	unsigned int		blksize = ip->i_mount->m_bsize;
 	u64			tree_last_block =
 			xfs_fsverity_metadata_offset(ip) + merkle_tree_size;
 	u64			desc_pos =
@@ -161,8 +161,6 @@ xfs_fsverity_delete_metadata(
 		goto err_cancel;

 	error = xfs_trans_commit(tp);
-	if (error)
-		goto err_cancel;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);

 	return error;
@@ -231,8 +229,10 @@ xfs_fsverity_end_enable(
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);

 	/* fs-verity failed, just cleanup */
-	if (desc == NULL)
+	if (desc == NULL) {
+		error = xfs_fsverity_delete_metadata(ip);
 		goto out;
+	}

 	error = xfs_fsverity_write_descriptor(file, desc, desc_size,
 			merkle_tree_size);

zv (191b86b3216b) xfs: remove unwritten extents after preallocations in fsverity metadata
diff --git a/left/fs/xfs/xfs_fsverity.c b/right/fs/xfs/xfs_fsverity.c
index 0def83aba712..1a5948d372b6 100644
--- a/left/fs/xfs/xfs_fsverity.c
+++ b/right/fs/xfs/xfs_fsverity.c
@@ -176,8 +176,8 @@ err_cancel:
 static int
 xfs_fsverity_cancel_unwritten(
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		start,
-	xfs_fileoff_t		end)
+	loff_t			start,
+	loff_t			end)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
@@ -215,6 +215,8 @@ xfs_fsverity_cancel_unwritten(
 				goto out_cancel;

 			error = xfs_trans_commit(tp);
+			if (error)
+				return error;
 		} else {
 			xfs_trans_cancel(tp);
 		}

--- >8 ---

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
 41 files changed, 1019 insertions(+), 107 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

-- 
2.51.2

