Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DFE3C4555;
	Fri,  2 Oct 2026 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980635; cv=none; b=ATIxdCxN0QPyeGb8QzcPeDihLxZtgZ5/GALFlEVnlqwQu0KNNVkUhzJtIxdBLVIaB0Cd0z/F6W+5IJHyZaMnboyzExmoBY7pQjyv0kTuqBZIQDlsiXOUJ8mQ6kpLBMzqdSVW/W+xC0/TzPFlJRKY8lS16ekKaG1UeLylt8fz/bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980635; c=relaxed/simple;
	bh=qW9VRRlslzZMOx0yF4s7cRC3DDVt2fsH6fbwhDipO9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SP3d9M5kKgp1Li3mBAXb2UUeaxFUfQxVHIZGmoUIWWh0IuvRCtDIBqee0aiZ07kR5mli0vZ72BmYvAfe2abJ0PSgc56cCMQFKC8A0fugjRT2uXnIiFOYw31rcL2g5zlK4cYu2YDT/+gzdJ8NxBfL12UG1cR5Setw6UT9IaWRFdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNAm+nJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNAm+nJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943D51F000FF;
	Fri,  2 Oct 2026 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980632;
	bh=ag0fKNGNJYPVEDcYmcKYNuVVuCdOSV4Qh8HP1KCmFqg=;
	h=From:To:Cc:Subject:Date;
	b=QNAm+nJfbO6hac1AnVs1iUuZJu7XaJTQSvW8JC83RpeLphulhR/qr+wJIxowOxg4K
	 cXloXE5b2RFAi3sPpRH3RsCMB3Z/2yCpwamFfJmkSdoX3a3M0T8IFNPzPlCMHuQ41m
	 mp8mkqf6Vj3DUwNNKe1epzAlt8LBISQ3wnERt6RiirYmZsdnOlTmkvLJbBg+6LA6bh
	 AR0pxR5dhT5D7PF5yZZ9p2IIlv2PEoDct2w7Gp7U0gNuVO8dht4Zs7SssCItdPx0TJ
	 S/ifepKg1xDpIWHTZcZasrqK844qWW/BSRYjfA8bu1ws/+pJ67A1YR2rFF13zZFJm8
	 UjDtf4D1PL8Ug==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 00/21] fs-verity support for XFS with post EOF merkle tree
Date: Sat,  3 Oct 2026 00:36:41 +0200
Message-ID: <20261002223705.2175542-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is next revision of fsverity for XFS.

Patches without review:
[PATCH v17 12/21] xfs: use read ioend for fsverity data verification

This series based on block/for-next (has lazy-bounce series)

block/for-next:
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=for-next

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=fsverity

xfsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git/log/?h=fsverity

xfstests:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfstests-dev.git/log/?h=fsverity

v16:
https://lore.kernel.org/fsverity/arJC542mXklAeswE@aalbersh-thinkpadx1carbongen13.rmtcz.csb/T/#t

v15:
https://lore.kernel.org/fsverity/20260817070240.GA17371@lst.de/T/#t

v14:
https://lore.kernel.org/fsverity/anmFWhPNOqe4uyht@aalbersh-thinkpadx1carbongen13.rmtcz.csb/T/#t

v13:
https://lore.kernel.org/fsverity/20260721184346.416657-1-aalbersh@kernel.org/T/#t

v12:
https://lore.kernel.org/fsverity/al8xgOwueDOzGakK@aalbersh-thinkpadx1carbongen13.rmtcz.csb/T/#t

v11:
https://lore.kernel.org/all/20260710085256.3464201-1-aalbersh@kernel.org/

v10:
https://lore.kernel.org/fsverity/20260520123722.405752-1-aalbersh@kernel.org/#r

v9:
https://lore.kernel.org/fsverity/20260428083332.768693-1-aalbersh@kernel.org/#r

To: djwong@kernel.org
To: ebiggers@kernel.org
To: hch@lst.de
To: Carlos Maiolino <cem@kernel.org>

Cc: fsverity@lists.linux.dev
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-btrfs@vger.kernel.org

Cc: david@fromorbit.com

---
Changes in v17:
- Add mempool for fsverity ioends cache
- Add xfs_fsverity_reset_inode() as a common clean up function
- Changed ILOCK_SHARED to ILOCK_EXCL for xfs_bmap_last_extent()
- Swap order of truncate_inode_pages() and ilock() due to ABBA
- Add xfs_fsverity_is_hashes_of_zeroed_blocks() helper
- Removed EINVAL and EFBIG from scrub as ambiguous
Changes in v16:
- Rebase to block/for-next
- Removed work_struct from ioend in favor of kmem_cache structs
- Minor adjustments from v15 review
- Skip written extents in lower level of __xfs_bunmapi()
Changes in v15:
- Pull BIO in task context patches
- Drop flag argument in xfs_free_eofblocks()
- Call xfs_free_eofblocks() on fsverity inodes
- Comments and commit messages updates
- Rebased to v7.2-rc7
- Dropped patch for fsverity_fill_zerohash() with highmem optimization
Changes in v14:
- Rebase to lazy-bounce@hch-misc
- Adjust read ioends to BIO in task context flow
- MMAPLOCK/sb_internal deadlock fix reported by sashiko
- Add missing delalloc clean up in verity_end_enable
- Use xfs_free_eofblocks() instead of writing own clean up routine
- Modify xfs_free_eofblocks() to be able to clean unwritten only
- Dropped fix patch for truncate/set_size check
- Various minor code and #include rearrangements for bisecting
Changes in v13:
- Hoisted statx reporting to common code
- Added read ioend sorted for worker self-deadlock fix
- Adjusted fsverity flags in zoned write path
Changes in v12:
- Refactored xfs_fsverity_cancel_unwritten()
- Switched to using inode_set_flags()
- Add a lock for COW fork reading
- Add pagecache truncation in cleanup path
- Added ERANGE and EBADMSG to fsverity scrub handling
- Add missing XFS_FSVERITY_CONSTRUCTION in various xfs_iomap
- Rebase to -rc3
Changes in v11:
- Drop wrong overlayfs patch
- Drop already merged iomap and fsverity patches
- Update to I_INO() use instead of ip->i_ino
- Sashiko.dev fixes. See list of issues below.
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

Andrey Albershteyn (19):
  fsverity: report validation errors through fserror to fsnotify
  fsverity: expose ensure_fsverity_info()
  fsverity: pass digest size and hash of the all-zeroes block to ->write
  fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
  fsverity: don't allow setting DAX file attribute on fsverity files
  fsverity: hoist statx reporting of fs-verity flag
  xfs: introduce fsverity on-disk changes
  xfs: don't allow to enable DAX on fs-verity sealed inode
  xfs: disable direct read path for fs-verity files
  xfs: don't report dio_mem_align and dio_offset_align for fsverity
    files
  xfs: handle fsverity I/O in write/read path
  xfs: use read ioend for fsverity data verification
  xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in
    __xfs_bunmapi()
  xfs: don't remove written extents past EOF on fsverity inodes
  xfs: add fs-verity support
  xfs: initialize fs-verity on file open
  xfs: add fs-verity ioctls
  xfs: introduce health state for corrupted fsverity metadata
  xfs: enable ro-compat fs-verity flag

Darrick J. Wong (2):
  xfs: advertise fs-verity being available on filesystem
  xfs: check and repair the verity inode flag state

 fs/btrfs/inode.c               |   3 -
 fs/btrfs/verity.c              |   6 +-
 fs/ext4/inode.c                |   5 +-
 fs/ext4/verity.c               |  36 +--
 fs/f2fs/file.c                 |   5 +-
 fs/f2fs/verity.c               |  34 +--
 fs/file_attr.c                 |  11 +-
 fs/stat.c                      |   6 +-
 fs/verity/enable.c             |   4 +-
 fs/verity/open.c               |  26 +-
 fs/verity/pagecache.c          |  33 +++
 fs/verity/verify.c             |   4 +
 fs/xfs/Makefile                |   1 +
 fs/xfs/libxfs/xfs_bmap.c       |  15 +-
 fs/xfs/libxfs/xfs_bmap.h       |   6 +-
 fs/xfs/libxfs/xfs_format.h     |  35 ++-
 fs/xfs/libxfs/xfs_fs.h         |   2 +
 fs/xfs/libxfs/xfs_health.h     |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |   8 +
 fs/xfs/libxfs/xfs_inode_util.c |   5 +-
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/scrub/common.c          |  53 ++++
 fs/xfs/scrub/common.h          |   2 +
 fs/xfs/scrub/inode.c           |   7 +
 fs/xfs/scrub/inode_repair.c    |  36 +++
 fs/xfs/xfs_aops.c              |  49 +++-
 fs/xfs/xfs_bmap_util.c         |  31 ++-
 fs/xfs/xfs_file.c              |  71 +++--
 fs/xfs/xfs_fsverity.c          | 489 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h          |  47 ++++
 fs/xfs/xfs_health.c            |   1 +
 fs/xfs/xfs_inode.h             |   6 +
 fs/xfs/xfs_ioctl.c             |  14 +
 fs/xfs/xfs_ioend.c             |  53 +++-
 fs/xfs/xfs_ioend.h             |   4 +-
 fs/xfs/xfs_iomap.c             |  37 ++-
 fs/xfs/xfs_iomap.h             |   5 +-
 fs/xfs/xfs_iops.c              |  12 +-
 fs/xfs/xfs_message.c           |   4 +
 fs/xfs/xfs_message.h           |   1 +
 fs/xfs/xfs_mount.h             |   4 +
 fs/xfs/xfs_super.c             |  31 ++-
 include/linux/fsverity.h       |  10 +-
 43 files changed, 1079 insertions(+), 141 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

Range-diff against v16:
 -:  ------------ >  1:  c14aea60fb61 fsverity: report validation errors through fserror to fsnotify
 1:  d234049f2fc6 !  2:  ba2ec9993a12 fsverity: expose ensure_fsverity_info()
    @@ Commit message
     
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Acked-by: Eric Biggers <ebiggers@kernel.org>
    -    Reviewed-by: Christoph Hellwig <hch@lst.de>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/verity/open.c ##
     @@ fs/verity/open.c: int fsverity_get_descriptor(struct inode *inode,
 2:  ce8681774085 !  3:  68694ea8ba0d fsverity: pass digest size and hash of the all-zeroes block to ->write
    @@ Commit message
         hashes of zeroed data blocks. XFS will use this to decide if it want to
         store tree block full of these hashes.
     
    +    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
         Acked-by: Eric Biggers <ebiggers@kernel.org>
         Acked-by: David Sterba <dsterba@suse.com>
    -    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
      ## fs/btrfs/verity.c ##
     @@ fs/btrfs/verity.c: static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 3:  363bb4311e70 =  4:  5732f007e676 fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
 4:  159c890b697c !  5:  9928ceefe211 fsverity: don't allow setting DAX file attribute on fsverity files
    @@ Commit message
         Note, that the only other filesystem supporting DAX and fsverity is
         ext4, and ext4 does check for this case.
     
    +    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>
         Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
         Reviewed-by: Eric Biggers <ebiggers@kernel.org>
    -    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
      ## fs/file_attr.c ##
     @@ fs/file_attr.c: static int fileattr_set_prepare(struct inode *inode,
 5:  4989457dc89c !  6:  8f866da8730c fsverity: hoist statx reporting of fs-verity flag
    @@ Commit message
     
         Fixes: 146054090b08 ("btrfs: initial fsverity support")
         Cc: stable@vger.kernel.org
    +    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Acked-by: Eric Biggers <ebiggers@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>
         Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
    -    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
      ## fs/btrfs/inode.c ##
     @@ fs/btrfs/inode.c: static int btrfs_getattr(struct mnt_idmap *idmap,
 6:  95e50d365df7 =  7:  d93e466c36fd xfs: introduce fsverity on-disk changes
 7:  bf0fbecea27a =  8:  4bcf1275fa38 xfs: don't allow to enable DAX on fs-verity sealed inode
 8:  ac7fa296202d !  9:  082d5f39ae5a xfs: disable direct read path for fs-verity files
    @@ Commit message
         through the DIO path.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    -    Reviewed-by: Christoph Hellwig <hch@lst.de>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_file.c ##
     @@
 9:  67aeb55c4031 ! 10:  21b92f51fd5e xfs: don't report dio_mem_align and dio_offset_align for fsverity files
    @@ Commit message
         to the buffered IO is used in this case. The zero alignment values also
         mean that DIO is not supported on this file, see statx(2).
     
    +    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Acked-by: Eric Biggers <ebiggers@kernel.org>
         Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
    -    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
      ## fs/xfs/xfs_iops.c ##
     @@
10:  4dae04bdd7f3 ! 11:  929a7172c341 xfs: handle fsverity I/O in write/read path
    @@ Commit message
         Introduce a new inode flag meaning that merkle tree is being build on
         the inode.
     
    +    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>
    -    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
      ## fs/xfs/Makefile ##
     @@ fs/xfs/Makefile: xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmapi_convert_one_delalloc(
      	 */
      	if (!isnullstartblock(bma.got.br_startblock)) {
     +		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
    -+		    XFS_FSB_TO_B(mp, bma.got.br_startoff) >=
    -+			    xfs_fsverity_metadata_offset(ip))
    ++		    offset >= xfs_fsverity_metadata_offset(ip))
     +			flags |= IOMAP_F_FSVERITY;
      		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
      				xfs_iomap_inode_sequence(ip, flags));
    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmapi_convert_one_delalloc(
      	XFS_STATS_INC(mp, xs_xstrat_quick);
      
     +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
    -+	    XFS_FSB_TO_B(mp, bma.got.br_startoff) >=
    -+		    xfs_fsverity_metadata_offset(ip))
    ++	    offset >= xfs_fsverity_metadata_offset(ip))
     +		flags |= IOMAP_F_FSVERITY;
     +
      	ASSERT(!isnullstartblock(bma.got.br_startblock));
    @@ fs/xfs/xfs_iomap.c: xfs_direct_write_iomap_begin(
      	/*
      	 * COW writes may allocate delalloc space or convert unwritten COW
      	 * extents, so we need to make sure to take the lock exclusively here.
    +@@ fs/xfs/xfs_iomap.c: xfs_direct_write_iomap_begin(
    + 	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
    + 	if (imap.br_startblock != HOLESTARTBLOCK) {
    + 		seq = xfs_iomap_inode_sequence(ip, 0);
    +-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
    ++		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags,
    ++				iomap_flags & IOMAP_F_FSVERITY, seq);
    + 		if (error)
    + 			goto out_unlock;
    + 	}
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_direct_write_iomap_begin(
      			return error;
      	}
    @@ fs/xfs/xfs_iomap.c: xfs_buffered_write_iomap_begin(
      
      	/* we can't use delayed allocations when using extent size hints */
      	if (xfs_get_extsz_hint(ip))
    +@@ fs/xfs/xfs_iomap.c: xfs_buffered_write_iomap_begin(
    + 
    + found_cow:
    + 	if (imap.br_startoff <= offset_fsb) {
    +-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0,
    ++		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags,
    ++				iomap_flags & IOMAP_F_FSVERITY,
    + 				xfs_iomap_inode_sequence(ip, 0));
    + 		if (error)
    + 			goto out_unlock;
     @@ fs/xfs/xfs_iomap.c: xfs_read_iomap_begin(
      	bool			shared = false;
      	unsigned int		lockmode = XFS_ILOCK_SHARED;
11:  79f81266cd22 ! 12:  db144b392a91 xfs: use read ioend for fsverity data verification
    @@ Commit message
         Add a simple helper to check that this is not fsverity metadata but file
         data that needs verification.
     
    -    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
      ## fs/xfs/xfs_aops.c ##
    @@ fs/xfs/xfs_fsverity.c
      #include <linux/iomap.h>
      
     +struct kmem_cache *xfs_fsverity_ioend_cache;
    ++mempool_t xfs_fsverity_ioend_pool;
    ++
    ++#define XFS_FSVERITY_IOEND_POOL_MIN	128
    ++
    ++/*
    ++ * Back the fsverity ioend allocations with a mempool so that read I/O
    ++ * completion always makes forward progress and cannot deadlock
    ++ */
    ++int
    ++xfs_fsverity_init(void)
    ++{
    ++	return mempool_init_slab_pool(&xfs_fsverity_ioend_pool,
    ++			XFS_FSVERITY_IOEND_POOL_MIN, xfs_fsverity_ioend_cache);
    ++}
    ++
    ++void
    ++xfs_fsverity_exit(void)
    ++{
    ++	mempool_exit(&xfs_fsverity_ioend_pool);
    ++}
     +
      loff_t
      xfs_fsverity_metadata_offset(
    @@ fs/xfs/xfs_fsverity.h
      
      #include "xfs_platform.h"
     +#include <linux/iomap.h>
    ++#include <linux/mempool.h>
      
      #ifdef CONFIG_FS_VERITY
    ++int xfs_fsverity_init(void);
    ++void xfs_fsverity_exit(void);
      loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
     +bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
      #else
    ++static inline int xfs_fsverity_init(void)
    ++{
    ++	return 0;
    ++}
    ++static inline void xfs_fsverity_exit(void)
    ++{
    ++}
      static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
      {
      	WARN_ON_ONCE(1);
    @@ fs/xfs/xfs_fsverity.h
     +};
     +
     +extern struct kmem_cache *xfs_fsverity_ioend_cache;
    ++extern mempool_t xfs_fsverity_ioend_pool;
     +
      #endif	/* __XFS_FSVERITY_H__ */
     
    @@ fs/xfs/xfs_ioend.c
     +	struct iomap_ioend		*ioend = fsv_ioend->ioend;
     +	struct bio			*bio = &ioend->io_bio;
     +
    -+	kmem_cache_free(xfs_fsverity_ioend_cache, fsv_ioend);
    ++	mempool_free(fsv_ioend, &xfs_fsverity_ioend_pool);
     +
     +	if (!bio->bi_status)
     +		fsverity_verify_bio(ioend->io_vi, bio);
    @@ fs/xfs/xfs_ioend.c: xfs_end_io_read(
      	}
      
     +	/*
    -+	 * If we have fsverity and block device integrity attached to this bio,
    -+	 * we need to run fsverity verification of data folios from a separate
    -+	 * fsverity workqueue. This is necessary to avoid deadlocking due to
    -+	 * fsverity issuing more reads of fsverity metadata which would be
    -+	 * processed by the same worker in the BIO completion workqueue.
    -+	 *
    -+	 * Without block device integrity, fsverity metadata IO will not use
    -+	 * ioends for completion.
    ++	 * If we have fsverity on this bio, we need to run fsverity verification
    ++	 * of data folios from a separate fsverity workqueue. This is necessary
    ++	 * to avoid deadlocking due to fsverity issuing more reads of fsverity
    ++	 * metadata which would be processed by the same worker in the BIO
    ++	 * completion workqueue.
     +	 */
     +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
     +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
    -+		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
    -+			fsv_ioend = kmem_cache_zalloc(xfs_fsverity_ioend_cache,
    -+					GFP_KERNEL);
    -+			if (!fsv_ioend) {
    -+				iomap_finish_ioends(ioend, -ENOMEM);
    -+				return;
    -+			}
    -+			fsv_ioend->ioend = ioend;
    -+			INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
    ++		fsv_ioend = mempool_alloc(&xfs_fsverity_ioend_pool,
    ++				GFP_NOFS);
    ++		fsv_ioend->ioend = ioend;
    ++		INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
     +
    -+			fsverity_enqueue_verify_work(&fsv_ioend->work);
    -+			return;
    -+		}
    -+
    -+		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
    -+		error = blk_status_to_errno(ioend->io_bio.bi_status);
    ++		fsverity_enqueue_verify_work(&fsv_ioend->work);
    ++		return;
     +	}
     +
      	iomap_finish_ioends(ioend, error);
    @@ fs/xfs/xfs_super.c: xfs_init_caches(void)
     +					     sizeof(struct xfs_fsverity_ioend),
     +					     0, 0, NULL);
     +	if (!xfs_fsverity_ioend_cache)
    -+		goto out_destroy_fsverity_ioend_cache;
    ++		goto out_destroy_parent_args_cache;
     +#endif
     +
      	return 0;
      
     +#ifdef CONFIG_FS_VERITY
    -+ out_destroy_fsverity_ioend_cache:
    -+	kmem_cache_destroy(xfs_fsverity_ioend_cache);
    ++ out_destroy_parent_args_cache:
    ++	kmem_cache_destroy(xfs_parent_args_cache);
     +#endif
       out_destroy_xmi_cache:
      	kmem_cache_destroy(xfs_xmi_cache);
    @@ fs/xfs/xfs_super.c: xfs_destroy_caches(void)
      	kmem_cache_destroy(xfs_parent_args_cache);
      	kmem_cache_destroy(xfs_xmd_cache);
      	kmem_cache_destroy(xfs_xmi_cache);
    +@@ fs/xfs/xfs_super.c: init_xfs_fs(void)
    + 	if (error)
    + 		goto out;
    + 
    +-	error = xfs_init_workqueues();
    ++	error = xfs_fsverity_init();
    + 	if (error)
    + 		goto out_destroy_caches;
    + 
    ++	error = xfs_init_workqueues();
    ++	if (error)
    ++		goto out_fsverity_exit;
    ++
    + 	error = xfs_mru_cache_init();
    + 	if (error)
    + 		goto out_destroy_wq;
    +@@ fs/xfs/xfs_super.c: init_xfs_fs(void)
    + 	xfs_mru_cache_uninit();
    +  out_destroy_wq:
    + 	xfs_destroy_workqueues();
    ++ out_fsverity_exit:
    ++	xfs_fsverity_exit();
    +  out_destroy_caches:
    + 	xfs_destroy_caches();
    +  out:
    +@@ fs/xfs/xfs_super.c: exit_xfs_fs(void)
    + 	xfs_cleanup_procfs();
    + 	xfs_mru_cache_uninit();
    + 	xfs_destroy_workqueues();
    ++	xfs_fsverity_exit();
    + 	xfs_destroy_caches();
    + 	xfs_uuid_table_free();
    + }
12:  7b7e33fef0ab ! 13:  5f00c1287b5e xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
    @@ Commit message
         written ones in place. This will be used in following patch to clean up
         unwritten extents on fsverity inodes.
     
    -    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
     
      ## fs/xfs/libxfs/xfs_bmap.c ##
     @@ fs/xfs/libxfs/xfs_bmap.c: __xfs_bunmapi(
    @@ fs/xfs/libxfs/xfs_bmap.c: __xfs_bunmapi(
      			del.br_blockcount = end + 1 - del.br_startoff;
      
     +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
    -+				del.br_state != XFS_EXT_UNWRITTEN)
    ++		    del.br_state != XFS_EXT_UNWRITTEN)
     +			goto skip;
     +
      		if (!isrt || (flags & XFS_BMAPI_REMAP))
13:  44817f70a46b ! 14:  9a82d542d940 xfs: don't remove written extents past EOF on fsverity inodes
    @@ Commit message
         undergoing merkle tree construction need to be skipped in case reclaim
         takes place.
     
    -    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
     
      ## fs/xfs/xfs_bmap_util.c ##
     @@
    @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
      		return false;
      
     +	/*
    -+	 * Don't clean fsverity inodes which have merkle tree being built, the
    ++	 * Don't clean fsverity inodes as they already have been cleaned up and
    ++	 * are read-only. Skip inodes which have merkle tree being built, the
     +	 * merkle tree is written beyond EOF
     +	 */
    -+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    ++	if (fsverity_active(VFS_IC(ip)) ||
    ++	    xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
     +		return false;
     +
      	/*
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      	xfs_ilock(ip, XFS_ILOCK_EXCL);
      	xfs_trans_ijoin(tp, ip, 0);
      
    ++	/*
    ++	 * While fs-verity writes metadata after EOF, it can leave unwritten
    ++	 * preallocations.  Clear all that out.
    ++	 */
     +	if (has_verity)
     +		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
     +
14:  6c1468facf03 ! 15:  420fb1a97664 xfs: add fs-verity support
    @@ Commit message
         Pro-actively remove any unwritten extents as we use last extent to
         locate descriptor.
     
    -    Reviewed-by: Christoph Hellwig <hch@lst.de>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_fsverity.c ##
     @@
    @@ fs/xfs/xfs_fsverity.c
     +#include <linux/pagemap.h>
      
      struct kmem_cache *xfs_fsverity_ioend_cache;
    - 
    + mempool_t xfs_fsverity_ioend_pool;
     @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
      	return fsverity_active(VFS_IC(ip)) &&
      			offset < xfs_fsverity_metadata_offset(ip);
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	uint32_t		blocksize = i_blocksize(VFS_I(ip));
     +	xfs_fileoff_t		last_block_offset;
     +
    -+	ASSERT(inode->i_flags & S_VERITY);
    -+	xfs_ilock(ip, XFS_ILOCK_SHARED);
    ++	xfs_ilock(ip, XFS_ILOCK_EXCL);
    ++	/*
    ++	 * Serialize reading of inode->i_flags with xfs_scrub clearing of this
    ++	 * flag if inode is corrupted.
    ++	 */
    ++	if (!(inode->i_flags & S_VERITY)) {
    ++		xfs_iunlock(ip, XFS_ILOCK_EXCL);
    ++		return -ENODATA;
    ++	}
     +	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &rec, &is_empty);
    -+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
    ++	xfs_iunlock(ip, XFS_ILOCK_EXCL);
     +	if (error)
     +		return error;
     +
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +		return error;
     +	}
     +
    -+	xfs_ilock(ip, XFS_ILOCK_EXCL);
    -+	xfs_trans_ijoin(tp, ip, 0);
    -+
     +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
     +
    ++	xfs_ilock(ip, XFS_ILOCK_EXCL);
    ++	xfs_trans_ijoin(tp, ip, 0);
    ++
     +	/*
     +	 * We remove post EOF data, no need to update i_size as fsverity
     +	 * didn't move i_size in the first place
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	return error;
     +}
     +
    ++static int
    ++xfs_fsverity_reset_inode(
    ++	struct xfs_inode	*ip)
    ++{
    ++	int			error;
    ++	struct xfs_mount	*mp = ip->i_mount;
    ++	struct xfs_trans	*tp;
    ++
    ++	error = xfs_fsverity_delete_metadata(ip);
    ++	if (error)
    ++		return error;
    ++
    ++	/*
    ++	 * First, let's clean in-memory fsverity flag and then reset it on the
    ++	 * disk
    ++	 */
    ++	inode_set_flags(VFS_I(ip), 0, S_VERITY);
    ++
    ++	/*
    ++	 * Set fsverity inode flag
    ++	 */
    ++	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
    ++			0, 0, false, &tp);
    ++	if (error)
    ++		return error;
    ++
    ++	ip->i_diflags2 &= ~XFS_DIFLAG2_VERITY;
    ++
    ++	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
    ++	xfs_trans_set_sync(tp);
    ++
    ++	error = xfs_trans_commit(tp);
    ++	xfs_iunlock(ip, XFS_ILOCK_EXCL);
    ++	return error;
    ++}
     +
     +/*
     + * Prepare to enable fsverity by clearing old metadata.
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	if (IS_DAX(inode) || ip->i_diflags2 & XFS_DIFLAG2_DAX)
     +		return -EINVAL;
     +
    ++	/*
    ++	 * fs-verity stores the Merkle tree past EOF in units of the filesystem
    ++	 * block size, so it cannot support realtime files whose allocation unit
    ++	 * (extent size) is larger than the block size.
    ++	 */
    ++	if (xfs_inode_has_bigrtalloc(ip))
    ++		return -EINVAL;
    ++
     +	if (inode->i_size > XFS_FSVERITY_LARGEST_FILE)
     +		return -EFBIG;
     +
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
     +
     +	/* fs-verity failed, just cleanup */
    -+	if (desc == NULL) {
    -+		error = xfs_fsverity_delete_metadata(ip);
    ++	if (desc == NULL)
     +		goto out;
    -+	}
     +
     +	error = xfs_fsverity_write_descriptor(file, desc, desc_size,
     +			merkle_tree_size);
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	if (error) {
     +		int	error2;
     +
    -+		error2 = xfs_fsverity_delete_metadata(ip);
    ++		error2 = xfs_fsverity_reset_inode(ip);
     +		if (error2)
     +			xfs_alert(ip->i_mount,
     +"ino 0x%llx failed to clean up new fsverity metadata, err %d",
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	generic_readahead_merkle_tree(inode, index, nr_pages);
     +}
     +
    -+/*
    -+ * Write a merkle tree block.
    -+ */
    -+static int
    -+xfs_fsverity_write_merkle(
    -+	struct file		*file,
    ++static inline bool
    ++xfs_fsverity_is_hashes_of_zeroed_blocks(
    ++	struct xfs_inode	*ip,
     +	const void		*buf,
    -+	u64			pos,
     +	unsigned int		size,
     +	const u8		*zero_digest,
     +	unsigned int		digest_size)
     +{
    -+	struct inode		*inode = file_inode(file);
    -+	struct xfs_inode	*ip = XFS_I(inode);
    -+	loff_t			position = pos +
    -+		xfs_fsverity_metadata_offset(ip);
    -+
    -+	if (position + size > inode->i_sb->s_maxbytes)
    -+		return -EFBIG;
    -+
     +	/*
     +	 * If this is a block full of hashes of zeroed blocks, don't bother
     +	 * storing the block. We can synthesize them later.
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	 *
     +	 * Iomap won't know about these empty blocks.
     +	 */
    -+	if (size == ip->i_mount->m_sb.sb_blocksize &&
    -+			/*
    -+			 * First digest is zero_digest
    -+			 */
    -+			memcmp(buf, zero_digest, digest_size) == 0 &&
    -+			/*
    -+			 * Every digest is same as previous, thus all are
    -+			 * zero_digest
    -+			 */
    -+			memcmp(buf + digest_size, buf, size - digest_size) == 0)
    ++	if (size != ip->i_mount->m_sb.sb_blocksize)
    ++		return false;
    ++	/*
    ++	 * First digest is zero_digest
    ++	 */
    ++	if (memcmp(buf, zero_digest, digest_size))
    ++		return false;
    ++	/*
    ++	 * Every digest is same as previous, thus all are
    ++	 * zero_digest
    ++	 */
    ++	return memcmp(buf + digest_size, buf, size - digest_size) == 0;
    ++}
    ++
    ++/*
    ++ * Write a merkle tree block.
    ++ */
    ++static int
    ++xfs_fsverity_write_merkle(
    ++	struct file		*file,
    ++	const void		*buf,
    ++	u64			pos,
    ++	unsigned int		size,
    ++	const u8		*zero_digest,
    ++	unsigned int		digest_size)
    ++{
    ++	struct inode		*inode = file_inode(file);
    ++	struct xfs_inode	*ip = XFS_I(inode);
    ++	loff_t			position = pos +
    ++		xfs_fsverity_metadata_offset(ip);
    ++
    ++	if (position + size > inode->i_sb->s_maxbytes)
    ++		return -EFBIG;
    ++
    ++	if (xfs_fsverity_is_hashes_of_zeroed_blocks(ip, buf, size, zero_digest,
    ++						    digest_size))
     +		return 0;
     +
     +	return iomap_fsverity_write(file, position, size, buf,
    @@ fs/xfs/xfs_fsverity.h
      #include "xfs_platform.h"
      #include <linux/iomap.h>
     +#include <linux/fsverity.h>
    + #include <linux/mempool.h>
      
      #ifdef CONFIG_FS_VERITY
     +extern const struct fsverity_operations xfs_fsverity_ops;
    + int xfs_fsverity_init(void);
    + void xfs_fsverity_exit(void);
      loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
    - bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
    - #else
     
      ## fs/xfs/xfs_message.c ##
     @@ fs/xfs/xfs_message.c: xfs_warn_experimental(
15:  78214f0c18ed = 16:  00314b4a38e2 xfs: initialize fs-verity on file open
16:  1cda98e462f0 = 17:  d37e9d9a991e xfs: add fs-verity ioctls
17:  c772780887b6 = 18:  c21e90b7ac09 xfs: advertise fs-verity being available on filesystem
18:  2a1811e69360 ! 19:  6efa9e6690ee xfs: check and repair the verity inode flag state
    @@ Commit message
         opening the file, so clearing the flag will not compromise that model.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    -    Reviewed-by: Christoph Hellwig <hch@lst.de>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/scrub/common.c ##
     @@
    @@ fs/xfs/scrub/common.c: xchk_inode_count_blocks(
     +		break;
     +	case -ENODATA:
     +	case -EMSGSIZE:
    -+	case -EINVAL:
     +	case -EFSCORRUPTED:
    -+	case -EFBIG:
     +	case -ERANGE:
     +	case -EBADMSG:
     +		/*
19:  942e4a193836 = 20:  e01d0c1aa284 xfs: introduce health state for corrupted fsverity metadata
20:  94fdc1d0ed15 = 21:  0ebd5899bc53 xfs: enable ro-compat fs-verity flag
-- 
2.54.0

