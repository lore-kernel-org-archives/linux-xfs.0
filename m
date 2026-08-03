Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348193AD51E;
	Mon,  3 Aug 2026 20:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787746; cv=none; b=uR/oIoTwtTk8QFi1jL+7h48Gj1Np2VMNspN0mlJE+LlbU9wkaOUys6v7Asu+Tsi6ZhNG6dJMk4L+/PRfPhScBIFX6jHOoTU9p50RthZoySU5cOCx/cc9vfM16/9+vxgKfjZ/adBbdWlREcDBGpnNC6t0JEnhjbto/gfNAA4l8XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787746; c=relaxed/simple;
	bh=B0ctkoWXhc/orSmb/8WuZamtIFN/AXUXMseeaqsYilU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rzUTAk7AIyMrFiwQgpBRquH2U1TnFfVh6u8nHpcj2KNhKB9ICxWhdiBcZouQ1BkJXe7o51K2qVsVMU7TNB0/vR2zHkMm+1RswzFvC9Q5cAOLR4/BSfCEvekz1y+6Ob/xmhSeOAXqaPltSz70iqDGX88DfR4iTOLmUzPuT/cccxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfL9Qtt0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfL9Qtt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12581F000E9;
	Mon,  3 Aug 2026 20:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787743;
	bh=fd+6k9iIiFFVaXPBWZu/XtyYg4TgyHFSZ6BL26pu6jo=;
	h=From:To:Cc:Subject:Date;
	b=LfL9Qtt0D5fqbysvxdz8bY4HdkYSP0+9oCvkq/++sfJdz58D0a1HbKVa6zUPq3FmZ
	 P9WhosbrSmTzV0M8h9HBam/fJlP15h9nn0j3tCywl9SSUq30ghNTvViRLznMMfpVN/
	 LrL0TlG8WyosI0C00XfPztwa2PX0wEMLjj3z+JZ8+GWdnyRUqyJe0phMTiLCb9xKLi
	 GP5xvjJVrznGjUdgO1ft2daaZjYhrhSdUKz920m+puYdSJH6VuPa3oRIyMnqtqjl2O
	 qKdYaUCArn+NN/8j5GAzUTClOsTY/XMZ00Fv4HvGnl+czRZmb60iyyPHUIgz6CmEws
	 fwYBLWtIRhF3Q==
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
	djwong@kernel.org,
	linux-unionfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v14 00/21] fs-verity support for XFS with post EOF merkle tree
Date: Mon,  3 Aug 2026 22:07:50 +0200
Message-ID: <20260803200820.393203-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is next revision of fsverity for XFS. This revision includes fixes
for issues found by sashiko.dev (and claude-code scan).

Below are my responses to the sashiko points.

Range-diff with v13 also below.

Patch 14 is new.

Patches without review:
[PATCH v14 05/21] fsverity: improve flushing performance of
[PATCH v14 07/21] fsverity: hoist statx reporting of fs-verity flag
[PATCH v14 11/21] xfs: don't report dio_mem_align and
[PATCH v14 12/21] xfs: handle fsverity I/O in write/read path
[PATCH v14 13/21] xfs: use read ioend for fsverity data verification
[PATCH v14 14/21] xfs: add flags to xfs_free_eofblocks() to pass down

This series based on v7.2-rc4 + lazy-bounce@hch-misc

lazy-bounce:
git://git.infradead.org/users/hch/misc.git lazy-bounce

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=fsverity

xfsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git/log/?h=fsverity

xfstests:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfstests-dev.git/log/?h=fsverity

sashiko review:
https://sashiko.dev/#/patchset/20260721184346.416657-1-aalbersh%40kernel.org

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

Cc: fsverity@lists.linux.dev
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org

Cc: david@fromorbit.com
Cc: djwong@kernel.org
Cc: ebiggers@kernel.org
Cc: hch@lst.de


---
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

-- >8 --

 1:  3126eb1df402 <  -:  ------------ fs-verity support for XFS with post EOF merkle tree
 2:  c43552872333 =  1:  804fe14bc667 fsverity: report validation errors through fserror to fsnotify
 3:  3fa9148aa645 !  2:  c42a21b4fce9 fsverity: expose ensure_fsverity_info()
    @@ fs/verity/open.c: int fsverity_get_descriptor(struct inode *inode,
     + * associated with a file descriptor) reads of the file's data or
     + * fsverity digest, it must call this explicitly before doing so.
     + *
    ++ * In case filesystem supports both fscrypt and fsverity, this should be called
    ++ * after fscrypt's encryption key is set up. Otherwise, the fsverity metadata is
    ++ * still encrypted. See fscrypt_file_open().
    ++ *
     + * Return: 0 on success, -errno on failure
     + */
     +int fsverity_ensure_verity_info(struct inode *inode)
 4:  d71c8e69e03c =  3:  86d9ed19b872 fsverity: pass digest size and hash of the all-zeroes block to ->write
 5:  3bc3f9d0ee91 =  4:  d82c11aab3a1 fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
 6:  d0930e705a9a <  -:  ------------ fsverity: improve flushing performance of fsverity_fill_zerohash
 7:  e62bb284d7fd <  -:  ------------ fsverity: don't allow setting DAX file attribute on fsverity files
 8:  b7933f19da9c <  -:  ------------ fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
 -:  ------------ >  5:  2ec3e6f07ce1 fsverity: improve flushing performance of fsverity_fill_zerohash
 -:  ------------ >  6:  25f07514f00f fsverity: don't allow setting DAX file attribute on fsverity files
 9:  967430abed85 !  7:  ce9dfa64ec13 fsverity: hoist statx reporting of fs-verity flag
    @@ Metadata
      ## Commit message ##
         fsverity: hoist statx reporting of fs-verity flag

    -    All filesystems supporting fsverity report this status by checking inode
    -    flag. Also, BTRFS was missing stat->attributes_mask, which is fixed now.
    +    All filesystems, supporting fsverity, report this status by checking
    +    inode flag. Also, BTRFS was missing stat->attributes_mask, which is
    +    fixed now.

         Fixes: 146054090b08 ("btrfs: initial fsverity support")
    +    Cc: stable@vger.kernel.org
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Acked-by: Eric Biggers <ebiggers@kernel.org>

      ## fs/btrfs/inode.c ##
     @@ fs/btrfs/inode.c: static int btrfs_getattr(struct mnt_idmap *idmap,
10:  905556ca6e2b =  8:  7116fb1bc082 xfs: introduce fsverity on-disk changes
11:  7a1023f3faf3 =  9:  6e988a0ebea7 xfs: don't allow to enable DAX on fs-verity sealed inode
12:  af8a059bd635 ! 10:  190cc5cf57d0 xfs: disable direct read path for fs-verity files
    @@ Commit message

         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>

      ## fs/xfs/xfs_file.c ##
    +@@
    + #include <linux/fadvise.h>
    + #include <linux/mount.h>
    + #include <linux/filelock.h>
    ++#include <linux/fsverity.h>
    +
    + static const struct vm_operations_struct xfs_file_vm_ops;
    +
     @@ fs/xfs/xfs_file.c: static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
      	.bio_set	= &iomap_ioend_bioset,
      };
    @@ fs/xfs/xfs_file.c: xfs_file_dio_read(
      	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
      	if (ret)
      		return ret;
    ++
     +	/*
     +	 * Re-check verity status after acquiring lock. This prevents TOCTOU in
     +	 * xfs_file_read_iter() while falling back from DIO to buffered I/O as
    @@ fs/xfs/xfs_file.c: xfs_file_dio_read(
     +		iocb->ki_flags &= ~IOCB_DIRECT;
     +		return xfs_file_buffered_read(iocb, to);
     +	}
    - 	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
    + 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
      		dio_ops = &xfs_dio_read_bounce_ops;
    - 		dio_flags |= IOMAP_DIO_BOUNCE;
    + 	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, dio_ops, dio_flags,
     @@ fs/xfs/xfs_file.c: xfs_file_dax_read(
      	struct kiocb		*iocb,
      	struct iov_iter		*to)
13:  30cced457045 = 11:  30ec4b4681a8 xfs: don't report dio_mem_align and dio_offset_align for fsverity files
14:  806856fa16fd ! 12:  639b547a84cc xfs: handle fsverity I/O in write/read path
    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmapi_convert_one_delalloc(

      ## fs/xfs/xfs_aops.c ##
     @@
    - #include "xfs_icache.h"
    + #include "xfs_ioend.h"
      #include "xfs_zone_alloc.h"
      #include "xfs_rtgroup.h"
     +#include "xfs_fsverity.h"
    - #include <linux/bio-integrity.h>

      struct xfs_writepage_ctx {
    + 	struct iomap_writepage_ctx ctx;
     @@ fs/xfs/xfs_aops.c: xfs_map_blocks(
      	int			retries = 0;
      	int			error = 0;
    @@ fs/xfs/xfs_fsverity.c (new)
     + * Copyright (C) 2026 Red Hat, Inc.
     + */
     +#include "xfs_platform.h"
    -+#include "xfs_format.h"
    -+#include "xfs_inode.h"
    ++#include "xfs_fs.h"
     +#include "xfs_shared.h"
    ++#include "xfs_format.h"
    ++#include "xfs_log_format.h"
     +#include "xfs_trans_resv.h"
     +#include "xfs_mount.h"
    ++#include "xfs_inode.h"
     +#include "xfs_fsverity.h"
     +#include <linux/fsverity.h>
     +#include <linux/iomap.h>
15:  9dbb76001391 <  -:  ------------ xfs: always prioritize fsverity metadata ioends in ioend completion
16:  3778dd4dd18e <  -:  ------------ xfs: use read ioend for fsverity data verification
 -:  ------------ > 13:  d0ed142a8e48 xfs: use read ioend for fsverity data verification
 -:  ------------ > 14:  2091792f0ba7 xfs: add flags to xfs_free_eofblocks() to pass down to block processing
17:  44fdb9249f8a ! 15:  f54a273b2897 xfs: add fs-verity support
    @@ Commit message
         Merkle tree block. The size of the descriptor is stored at the end of
         the last descriptor block (descriptor can be multiple blocks).

    +    XFS preallocates spaces during writes. In normal I/O this space, if
    +    unused, is removed by truncate. For files with fsverity, XFS does not use
    +    truncate as fsverity metadata is stored past EOF. We call
    +    xfs_free_eofblocks() explicitly to clean up any unused space as these
    +    files will not change anymore.
    +
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>

      ## fs/xfs/xfs_bmap_util.c ##
     @@
    @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
      		return false;

     +	/*
    -+	 * Nothing to clean on fsverity inodes as they don't use prealloc and
    -+	 * there no delalloc as only written data is fsverity metadata
    ++	 * Don't clean fsverity inodes as they have metadata store beyond EOF
     +	 */
    -+	if (IS_VERITY(VFS_I(ip)) ||
    ++	if (fsverity_active(VFS_I(ip)) ||
     +	    xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
     +		return false;
     +
    @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(

      ## fs/xfs/xfs_fsverity.c ##
     @@
    -  */
    - #include "xfs_platform.h"
    - #include "xfs_format.h"
    --#include "xfs_inode.h"
    + #include "xfs_fs.h"
      #include "xfs_shared.h"
    + #include "xfs_format.h"
    +-#include "xfs_log_format.h"
    ++#include "xfs_shared.h"
      #include "xfs_trans_resv.h"
      #include "xfs_mount.h"
    -+#include "xfs_da_format.h"
    -+#include "xfs_da_btree.h"
    -+#include "xfs_inode.h"
    + #include "xfs_inode.h"
     +#include "xfs_log_format.h"
     +#include "xfs_trans.h"
     +#include "xfs_trace.h"
    @@ fs/xfs/xfs_fsverity.c
     +#include "xfs_iomap.h"
     +#include "xfs_error.h"
     +#include "xfs_health.h"
    ++#include "xfs_bmap_util.h"
    ++#include "xfs_icache.h"
      #include <linux/fsverity.h>
      #include <linux/iomap.h>
     +#include <linux/pagemap.h>
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +		return -ERANGE;
     +
     +	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
    -+	if (desc_pos < xfs_fsverity_metadata_offset(ip)) {
    -+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
    ++	if (desc_pos < xfs_fsverity_metadata_offset(ip))
     +		return -ERANGE;
    -+	}
     +
     +	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
     +	if (error)
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	struct xfs_mount	*mp = ip->i_mount;
     +	int			error;
     +
    ++	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
     +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
    -+	if (error)
    ++	if (error) {
    ++		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
     +		return error;
    ++	}
     +
    -+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
    -+	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
    ++	xfs_ilock(ip, XFS_ILOCK_EXCL);
     +	xfs_trans_ijoin(tp, ip, 0);
     +
    ++	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
    ++
     +	/*
     +	 * We remove post EOF data, no need to update i_size as fsverity
     +	 * didn't move i_size in the first place
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +		goto out;
     +
     +	/*
    -+	 * Proactively drop any delayed allocations in COW fork, the fsverity
    -+	 * files are read-only
    ++	 * Remove unwritten extents left by COW preallocations and write
    ++	 * preallocation in the merkle tree holes and past descriptor, and any
    ++	 * delayed preallocations
     +	 */
    -+	if (xfs_is_cow_inode(ip)) {
    -+		xfs_ilock(ip, XFS_ILOCK_EXCL);
    -+		xfs_ifork_init_cow(ip);
    -+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
    -+		xfs_bmap_punch_delalloc_range(ip, XFS_COW_FORK, 0, LLONG_MAX,
    -+				NULL);
    -+	}
    ++	error = xfs_free_eofblocks(ip, XFS_FREE_FSVERITY);
    ++	if (error)
    ++		goto out;
     +
     +	/*
     +	 * Set fsverity inode flag
18:  1d4570c5a493 <  -:  ------------ xfs: remove unwritten extents after preallocations in fsverity metadata
19:  2d0c31956e6d ! 16:  839d1cccfaba xfs: initialize fs-verity on file open
    @@ Commit message
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

      ## fs/xfs/xfs_file.c ##
    -@@
    - #include <linux/fadvise.h>
    - #include <linux/mount.h>
    - #include <linux/filelock.h>
    -+#include <linux/fsverity.h>
    -
    - static const struct vm_operations_struct xfs_file_vm_ops;
    -
     @@ fs/xfs/xfs_file.c: xfs_file_open(
      	struct inode	*inode,
      	struct file	*file)
20:  7a544cc4f5c8 = 17:  f8b1f2e6710f xfs: add fs-verity ioctls
21:  cd4708d77609 = 18:  9de1c4536ce7 xfs: advertise fs-verity being available on filesystem
22:  82a18ac70347 = 19:  011b71fb8764 xfs: check and repair the verity inode flag state
23:  4e34e173abcb ! 20:  13c8938dd8aa xfs: introduce health state for corrupted fsverity metadata
    @@ fs/xfs/libxfs/xfs_health.h: struct xfs_rtgroup;
      				 XFS_SICK_INO_BMBTA_ZAPPED | \

      ## fs/xfs/xfs_fsverity.c ##
    +@@ fs/xfs/xfs_fsverity.c: xfs_fsverity_get_descriptor(
    + 	if (error)
    + 		return error;
    +
    +-	if (is_empty)
    ++	if (is_empty) {
    ++		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
    + 		return -ENODATA;
    ++	}
    +
    + 	last_block_offset =
    + 		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
    +-	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
    ++	if (last_block_offset <= xfs_fsverity_metadata_offset(ip)) {
    ++		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
    + 		return -ENODATA;
    ++	}
    +
    + 	desc_size_pos = last_block_offset - sizeof(__be32);
    + 	error = fsverity_pagecache_read(inode, (char *)&d_desc_size,
     @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_get_descriptor(
      		return error;

    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_get_descriptor(
     +	}

      	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
    - 	if (desc_pos < xfs_fsverity_metadata_offset(ip)) {
    +-	if (desc_pos < xfs_fsverity_metadata_offset(ip))
    ++	if (desc_pos < xfs_fsverity_metadata_offset(ip)) {
    ++		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
    + 		return -ERANGE;
    ++	}
    +
    + 	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
    + 	if (error)

      ## fs/xfs/xfs_health.c ##
     @@ fs/xfs/xfs_health.c: static const struct ioctl_sick_map ino_map[] = {
24:  fcfe485fd924 = 21:  b4f9880f839b xfs: enable ro-compat fs-verity flag

Andrey Albershteyn (19):
  fsverity: report validation errors through fserror to fsnotify
  fsverity: expose ensure_fsverity_info()
  fsverity: pass digest size and hash of the all-zeroes block to ->write
  fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
  fsverity: improve flushing performance of fsverity_fill_zerohash
  fsverity: don't allow setting DAX file attribute on fsverity files
  fsverity: hoist statx reporting of fs-verity flag
  xfs: introduce fsverity on-disk changes
  xfs: don't allow to enable DAX on fs-verity sealed inode
  xfs: disable direct read path for fs-verity files
  xfs: don't report dio_mem_align and dio_offset_align for fsverity
    files
  xfs: handle fsverity I/O in write/read path
  xfs: use read ioend for fsverity data verification
  xfs: add flags to xfs_free_eofblocks() to pass down to block
    processing
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
 fs/file_attr.c                 |  12 +-
 fs/stat.c                      |   6 +-
 fs/verity/enable.c             |   4 +-
 fs/verity/open.c               |  26 ++-
 fs/verity/pagecache.c          |  61 ++++-
 fs/verity/verify.c             |   4 +
 fs/xfs/Makefile                |   1 +
 fs/xfs/libxfs/xfs_bmap.c       |  67 ++++--
 fs/xfs/libxfs/xfs_bmap.h       |   6 +-
 fs/xfs/libxfs/xfs_format.h     |  35 ++-
 fs/xfs/libxfs/xfs_fs.h         |   2 +
 fs/xfs/libxfs/xfs_health.h     |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |   8 +
 fs/xfs/libxfs/xfs_inode_util.c |   5 +-
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/scrub/common.c          |  55 +++++
 fs/xfs/scrub/common.h          |   2 +
 fs/xfs/scrub/inode.c           |   7 +
 fs/xfs/scrub/inode_repair.c    |  36 +++
 fs/xfs/xfs_aops.c              |  50 +++-
 fs/xfs/xfs_bmap_util.c         |  28 ++-
 fs/xfs/xfs_bmap_util.h         |  13 +-
 fs/xfs/xfs_file.c              |  73 ++++--
 fs/xfs/xfs_fsverity.c          | 408 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h          |  28 +++
 fs/xfs/xfs_health.c            |   1 +
 fs/xfs/xfs_icache.c            |   2 +-
 fs/xfs/xfs_inode.c             |   2 +-
 fs/xfs/xfs_inode.h             |   6 +
 fs/xfs/xfs_ioctl.c             |  14 ++
 fs/xfs/xfs_ioend.c             |  42 +++-
 fs/xfs/xfs_ioend.h             |   4 +-
 fs/xfs/xfs_iomap.c             |  29 ++-
 fs/xfs/xfs_iops.c              |  12 +-
 fs/xfs/xfs_message.c           |   4 +
 fs/xfs/xfs_message.h           |   1 +
 fs/xfs/xfs_mount.h             |   4 +
 fs/xfs/xfs_super.c             |   7 +
 include/linux/fsverity.h       |  10 +-
 include/linux/iomap.h          |   1 +
 46 files changed, 1020 insertions(+), 153 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

-- 
2.54.0

