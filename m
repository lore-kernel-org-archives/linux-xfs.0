Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF745DF42;
	Fri, 14 Aug 2026 09:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699537; cv=none; b=UW1J8ux27rfniO5vxLJAcEqeD0tfH4d2PeYI+L8bSj7Na8tRvgBf4dmo4spguXiJDl8jY8ogpjOcQ5XIU3UGoSkxt4T7yjspSnArHhCkuSrRT2tiAOHXo9UzeX+J89mV9zZVCX6oFvS8Fp4R9H2MnkjxQz0IzpMHSZeiXuUmi38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699537; c=relaxed/simple;
	bh=C+Awcl7bV1BnL1cGJm4khEHmm4/z2il0WFJ/2/LNmbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C/PGSuFh6SSz17r+us6iE0f4SIncXfPuXAyJAMIoknMNpPYyqk1XjqEtDdxIrq0XFBfpQrZHpmXC9TvyHcQYmNsiE6Q0cc0/8bAgSVtK6dSK7RAZwBMGF/ZpH0WEC2IfN2TAXam3LpEmgXUmgJoBGCvCtx7ir2MD1IHWVWqVliA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUr4ks8Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUr4ks8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7FC1F000E9;
	Fri, 14 Aug 2026 09:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699535;
	bh=tyZxQduuVss5L6+Edf0qCsv+kYwg/ki/oAAt4G9kffo=;
	h=From:To:Cc:Subject:Date;
	b=eUr4ks8QDIRYEPQKNCwB/9OStqd+SiMIYBuMs/jIBxqGZ0AOqQp3JXc5oo9IAPy6v
	 su1FtBf2QFtK893GTkSTMZQxrMuEXljEjPuKgVV2NudmzcVCV8xKTI4alU3UxHhAcw
	 Dm5hZeaqwMNkDcmVl7Vn00Dam9zIQVXzWnB9NMV1j5DRj/LS26TW7pbSTaE1skq80e
	 oCmhngs6RTl2nmDAMJpAwnpa7v2h0h8SoQ5LWthw7+eOjV0MEJE87MeDnXSpJNALb4
	 yDRIrM+9N8tIxctp/sOKsIloDAviL5pyxaIXB2T9eMWR779tHHhSHz42rqhil7JFoP
	 BQPUt7GiUlgRg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 00/25] fs-verity support for XFS with post EOF merkle tree
Date: Fri, 14 Aug 2026 11:24:17 +0200
Message-ID: <20260814092448.1818082-1-aalbersh@kernel.org>
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

Range-diff with v14 also below.

Patches without review:
[PATCH v15 07/25] block: add task-context bio completion
[PATCH v15 08/25] block: don't delay bio task completions
[PATCH v15 16/25] xfs: handle fsverity I/O in write/read path
[PATCH v15 18/25] xfs: make xfs_free_eofblocks() work with fsverity

The patchset include some patches from lazy-bounce@hch-misc series for
BIO completion in task context

This series based on v7.2-rc7 + zoned xfs fixes updates v2 patchset

zoned xfs updates v2 patchset:
https://lore.kernel.org/all/20260811164912.124416-1-hch@lst.de/

lazy-bounce@hch-misc:
git://git.infradead.org/users/hch/misc.git lazy-bounce

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=fsverity

xfsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git/log/?h=fsverity

xfstests:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfstests-dev.git/log/?h=fsverity

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
To: Jens Axboe <axboe@kernel.dk>
To: Carlos Maiolino <cem@kernel.org>

Cc: fsverity@lists.linux.dev
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-btrfs@vger.kernel.org

Cc: david@fromorbit.com
Cc: Tal Zussman <tz2294@columbia.edu>

---
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

-- >8 --
 1:  9a35a9bfbb20 <  -:  ------------ fs-verity support for XFS with post EOF merkle tree
 2:  de3e03085556 =  1:  c04f12767144 fsverity: report validation errors through fserror to fsnotify
 3:  2f9fdea8d3b7 =  2:  997f474cb22c fsverity: expose ensure_fsverity_info()
 4:  1e1a67fdae40 =  3:  8d798e8f7f08 fsverity: pass digest size and hash of the all-zeroes block to ->write
 5:  8596444f6f80 =  4:  521dddfb26a8 fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
 6:  449a261d1a1c <  -:  ------------ fsverity: improve flushing performance of fsverity_fill_zerohash
 7:  9a822046aa31 !  5:  743a9c7d7066 fsverity: don't allow setting DAX file attribute on fsverity files
    @@ Commit message

         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

      ## fs/file_attr.c ##
     @@ fs/file_attr.c: static int fileattr_set_prepare(struct inode *inode,
    @@ fs/file_attr.c: static int fileattr_set_prepare(struct inode *inode,

      	/* Extent size hints of zero turn off the flags. */
      	if (fa->fsx_extsize == 0)
    -@@ fs/file_attr.c: static int fileattr_set_prepare(struct inode *inode,
    - 	if (fa->fsx_cowextsize == 0)
    - 		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
    -
    -+
    - 	return 0;
    - }
    -
 8:  6383e8cbc124 !  6:  6a22860c67c7 fsverity: hoist statx reporting of fs-verity flag
    @@ Commit message
         Cc: stable@vger.kernel.org
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Acked-by: Eric Biggers <ebiggers@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

      ## fs/btrfs/inode.c ##
     @@ fs/btrfs/inode.c: static int btrfs_getattr(struct mnt_idmap *idmap,
 -:  ------------ >  7:  98f98d4e7db2 block: add task-context bio completion infrastructure
 -:  ------------ >  8:  d34c912c3dcc block: don't delay bio task completions
 -:  ------------ >  9:  5cc63f758f43 iomap: add a iomap_ioend_flags helper
 -:  ------------ > 10:  3703510c8e3a iomap: add a IOMAP_IOEND_INTEGRITY flag
 -:  ------------ > 11:  ff786fe4b35b xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
 9:  5776751c608f = 12:  87a4dad5d9d2 xfs: introduce fsverity on-disk changes
10:  adddd6d2af68 = 13:  d9ac17077d5e xfs: don't allow to enable DAX on fs-verity sealed inode
11:  960ca7aa5e64 ! 14:  e7d2308f5a59 xfs: disable direct read path for fs-verity files
    @@ fs/xfs/xfs_file.c: xfs_file_dio_read(
     +		iocb->ki_flags &= ~IOCB_DIRECT;
     +		return xfs_file_buffered_read(iocb, to);
     +	}
    - 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
    + 	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
      		dio_ops = &xfs_dio_read_bounce_ops;
    - 	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, dio_ops, dio_flags,
    + 		dio_flags |= IOMAP_DIO_BOUNCE;
     @@ fs/xfs/xfs_file.c: xfs_file_dax_read(
      	struct kiocb		*iocb,
      	struct iov_iter		*to)
12:  377df9f28582 ! 15:  6d3c784bba56 xfs: don't report dio_mem_align and dio_offset_align for fsverity files
    @@ Commit message
         buffered IO for Direct I/O, they should not report non-zero values in
         dio_mem_align and dio_offset_align, meaning it's not supported.

    +    The STATX_DIOALIGN | STATX_DIO_READ_ALIGN flags are used to explicitly
    +    report if DIO is supported or not. They can not indicate that fallback
    +    to the buffered IO is used in this case. The zero alignment values also
    +    mean that DIO is not supported on this file, see statx(2).
    +
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Acked-by: Eric Biggers <ebiggers@kernel.org>

      ## fs/xfs/xfs_iops.c ##
     @@
13:  160491ee819d ! 16:  7fec3855f014 xfs: handle fsverity I/O in write/read path
    @@ fs/xfs/xfs_aops.c
      #include "xfs_zone_alloc.h"
      #include "xfs_rtgroup.h"
     +#include "xfs_fsverity.h"
    + #include <linux/bio-integrity.h>

      struct xfs_writepage_ctx {
    - 	struct iomap_writepage_ctx ctx;
     @@ fs/xfs/xfs_aops.c: xfs_map_blocks(
      	int			retries = 0;
      	int			error = 0;
    @@ fs/xfs/xfs_aops.c: xfs_zoned_map_blocks(
     @@ fs/xfs/xfs_aops.c: xfs_zoned_map_blocks(
      	xfs_iunlock(ip, XFS_ILOCK_EXCL);

    - 	wpc->iomap.type = IOMAP_MAPPED;
    --	wpc->iomap.flags = IOMAP_F_DIRTY;
    - 	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
    - 	wpc->iomap.offset = offset;
    - 	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
    --	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
    -+	wpc->iomap.flags = iomap_flags | IOMAP_F_ANON_WRITE;
    -
    + 	xfs_iomap_set_anon_write(ip, &wpc->iomap, offset,
    +-			XFS_FSB_TO_B(mp, count_fsb));
    ++			XFS_FSB_TO_B(mp, count_fsb), iomap_flags);
      	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
      	return 0;
    + }
     @@ fs/xfs/xfs_aops.c: static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
      	.writeback_submit	= xfs_zoned_writeback_submit,
      };
    @@ fs/xfs/xfs_iomap.c: xfs_direct_write_iomap_begin(
      	/*
      	 * COW writes may allocate delalloc space or convert unwritten COW
      	 * extents, so we need to make sure to take the lock exclusively here.
    +@@ fs/xfs/xfs_iomap.c: xfs_zoned_direct_write_iomap_begin(
    + 			return error;
    + 	}
    +
    +-	xfs_iomap_set_anon_write(ip, iomap, offset, length);
    ++	xfs_iomap_set_anon_write(ip, iomap, offset, length, 0);
    + 	return 0;
    + }
    +
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
      	loff_t			count,
      	unsigned		flags,
    @@ fs/xfs/xfs_iomap.c: xfs_read_iomap_begin(
      }

      const struct iomap_ops xfs_read_iomap_ops = {
    +
    + ## fs/xfs/xfs_iomap.h ##
    +@@ fs/xfs/xfs_iomap.h: xfs_iomap_set_anon_write(
    + 	struct xfs_inode		*ip,
    + 	struct iomap			*iomap,
    + 	loff_t				offset,
    +-	loff_t				length)
    ++	loff_t				length,
    ++	u16				iomap_flags)
    + {
    + 	iomap->type = IOMAP_MAPPED;
    + 	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
    + 	iomap->offset = offset;
    + 	iomap->length = length;
    +-	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
    ++	iomap->flags = iomap_flags | IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
    + }
    +
    + static inline xfs_filblks_t
14:  40d50878bddf ! 17:  f9616b40dc41 xfs: use read ioend for fsverity data verification
    @@ Commit message
         data that needs verification.

         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

      ## fs/xfs/xfs_aops.c ##
     @@
    - #include "xfs_zone_alloc.h"
      #include "xfs_rtgroup.h"
      #include "xfs_fsverity.h"
    + #include <linux/bio-integrity.h>
     +#include <linux/fsverity.h>

      struct xfs_writepage_ctx {
    @@ fs/xfs/xfs_fsverity.h

      ## fs/xfs/xfs_ioend.c ##
     @@
    + #include "xfs_reflink.h"
    + #include "xfs_zone_alloc.h"
      #include "xfs_ioend.h"
    - #include "xfs_error.h"
    - #include "xfs_errortag.h"
    ++#include "xfs_error.h"
    ++#include "xfs_errortag.h"
     +#include "xfs_fsverity.h"
      #include <linux/bio-integrity.h>
     +#include <linux/fsverity.h>
    -
    - static void
    - xfs_end_bio_bounced(
    -@@ fs/xfs/xfs_ioend.c: xfs_read_bounce_and_resubmit(
    - 			xfs_bounce_submit_ioend);
    - }
    -
    ++
     +static void
     +xfs_end_fsverity_io_read(
     +	struct work_struct	*work)
     +{
     +	struct iomap_ioend	*ioend =
    -+		container_of(work, struct iomap_ioend, work);
    ++		container_of(work, struct iomap_ioend, io_work);
     +
     +	if (!ioend->io_bio.bi_status)
     +		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
    @@ fs/xfs/xfs_ioend.c: xfs_read_bounce_and_resubmit(
     +	iomap_finish_ioends(
     +		ioend, blk_status_to_errno(ioend->io_bio.bi_status));
     +}
    -+
    +
      static void
      xfs_end_io_read(
      	struct bio		*bio)
    -@@ fs/xfs/xfs_ioend.c: xfs_end_io_read(
    - 		}
    - 	}
    + {
    + 	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
    ++	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
    + 	int			error = blk_status_to_errno(bio->bi_status);

     +	/*
    -+	 * If we don't have block device integrity (IOMAP_IOEND_INTEGRITY),
    -+	 * there won't be any ioends containing fsverity metadata. This means
    -+	 * that those won't get mixed with data ioends causing self-deadlock or
    -+	 * rescuer thread deadlock.
    ++	 * If we have fsverity and block device integrity attached to this bio,
    ++	 * we need to run fsverity verification of data folios from a separate
    ++	 * fsverity workqueue. This is necessary to avoid deadlocking due to
    ++	 * fsverity issuing more reads of fsverity metadata which would be
    ++	 * processed by the same worker in the BIO completion workqueue.
     +	 *
    -+	 * Without offloading the data ioend, verification can be done directly
    -+	 * in this task context.
    ++	 * Without block device integrity, fsverity metadata IO will not use
    ++	 * ioends for completion.
     +	 */
     +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
     +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
     +		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
    -+			fsverity_enqueue_verify_work(&ioend->work);
    ++			fsverity_enqueue_verify_work(&ioend->io_work);
     +			return;
     +		}
     +
    @@ fs/xfs/xfs_ioend.c: xfs_ioend_submit_read(
     +	u16			ioend_flags,
     +	struct fsverity_info	*vi)
      {
    - 	struct xfs_inode	*ip = XFS_I(inode);
    - 	struct xfs_mount	*mp = ip->i_mount;
    - 	struct iomap_ioend	*ioend;
    -
    - 	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
    +-	iomap_init_ioend(inode, bio, file_offset, ioend_flags);
    ++	struct iomap_ioend	*ioend;
    ++
    ++	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
     +	ioend->io_vi = vi;
    -+	INIT_WORK(&ioend->work, xfs_end_fsverity_io_read);
    ++	INIT_WORK(&ioend->io_work, xfs_end_fsverity_io_read);
     +
    - 	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
    - 	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
    - 		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
    + 	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
    + 		fs_bio_integrity_alloc(bio);
    + 	bio->bi_end_io = xfs_end_io_read;

      ## fs/xfs/xfs_ioend.h ##
     @@
    @@ include/linux/iomap.h: struct iomap_ioend {
      	sector_t		io_sector;	/* start sector of ioend */
      	void			*io_private;	/* file system private data */
      	struct fsverity_info	*io_vi;		/* fsverity info */
    -+	struct work_struct	work;		/* fsverity blocking I/O */
    ++	struct work_struct	io_work;	/* fsverity blocking I/O */
      	struct bio		io_bio;		/* MUST BE LAST! */
      };

15:  dab6eef27138 ! 18:  4f71aea8297f xfs: add flags to xfs_free_eofblocks() to pass down to block processing
    @@ Metadata
     Author: Andrey Albershteyn <aalbersh@kernel.org>

      ## Commit message ##
    -    xfs: add flags to xfs_free_eofblocks() to pass down to block processing
    +    xfs: make xfs_free_eofblocks() work with fsverity inodes

    -    Add a flags parameter to xfs_free_eofblocks() to support selective
    -    extent unmapping. Add two flags for unmapping all extents (unwritten and
    -    normal) and fsverity leftover extents (only unwritten ones, leaving
    -    normal in place).
    +    xfs_free_eofblocks() removes any preallocations and unwritten extents
    +    beyond EOF. This is undesired for fsverity as it stores metadata beyond
    +    EOF. However, while merkle tree is being built delayed preallocation and
    +    unwritten extents are used. After metadata construction is done,
    +    fsverity inodes becomes read-only and won't be changed anymore, none of
    +    these unwritten extents or preallocations in post EOF region will be
    +    used.
    +
    +    Add XFS_BMAPI_UNWRITTEN and change xfs_bunmapi_range to remove only
    +    unwritten extents sitting beyond EOF and set it for fsverity inodes.
    +
    +    The xfs_free_eofblocks() will be called on fsverity inode as usual.
    +    However, inodes which are undergoing merkle tree construction need to
    +    be skipped in case reclaim takes place.

         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bunmapi_range(
      	xfs_fileoff_t		endoff)
      {
     -	xfs_filblks_t		unmap_len = endoff - startoff + 1;
    ++	xfs_filblks_t           unmap_len;
      	int			error = 0;
     +	int			nimaps = 1;
     +	int			done = 0;
     +	struct xfs_bmbt_irec	imap;
     +	int			read_flags =
     +			flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE);
    -+	xfs_exntst_t		exntst = XFS_EXT_NORM;

      	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);

    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bunmapi_range(
     -		ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
     -		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len, flags,
     -				XFS_ITRUNC_MAX_EXTENTS);
    -+	if (flags & XFS_BMAPI_UNWRITTEN)
    -+		exntst = XFS_EXT_UNWRITTEN;
    -+
     +	while (startoff < endoff) {
     +		nimaps = 1;
     +
    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bunmapi_range(
      			goto out;
     -		cond_resched();
     +
    -+		if ((exntst == XFS_EXT_UNWRITTEN) &&
    -+				(imap.br_state != exntst)) {
    ++		if ((flags & XFS_BMAPI_UNWRITTEN) &&
    ++				imap.br_state != XFS_EXT_UNWRITTEN) {
     +			startoff = imap.br_startoff + imap.br_blockcount;
     +			continue;
     +		}
     +
    ++		unmap_len = min(endoff - imap.br_startoff + 1,
    ++				imap.br_blockcount);
     +		done = 0;
     +		while (!done) {
     +			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
     +			error = xfs_bunmapi(*tpp, ip, imap.br_startoff,
    -+					imap.br_blockcount, flags, 0, &done);
    ++					unmap_len, flags, nimaps, &done);
     +			if (error)
     +				goto out;
     +
    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bunmapi_range(
     +			cond_resched();
     +		}
     +
    -+		startoff = imap.br_startoff + imap.br_blockcount;
    ++		startoff = imap.br_startoff + unmap_len;
      	}
      out:
      	return error;
    @@ fs/xfs/libxfs/xfs_bmap.h: struct xfs_bmalloca {
      static inline int xfs_bmapi_aflag(int w)

      ## fs/xfs/xfs_bmap_util.c ##
    +@@
    + #include "xfs_rtbitmap.h"
    + #include "xfs_rtgroup.h"
    + #include "xfs_zone_alloc.h"
    ++#include <linux/fsverity.h>
    +
    + /* Kernel only BMAP related definitions and functions */
    +
     @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
    -  */
    - int
    - xfs_free_eofblocks(
    --	struct xfs_inode	*ip)
    -+	struct xfs_inode	*ip,
    -+	int			flags)
    - {
    + 	if (last_fsb <= end_fsb)
    + 		return false;
    +
    ++	/*
    ++	 * Don't clean fsverity inodes which have merkle tree being built, the
    ++	 * merkle tree is written beyond EOF
    ++	 */
    ++	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    ++		return false;
    ++
    + 	/*
    + 	 * Check if there is an post-EOF extent to free.  If there are any
    + 	 * delalloc blocks attached to the inode (data fork delalloc
    +@@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      	struct xfs_trans	*tp;
      	struct xfs_mount	*mp = ip->i_mount;
      	int			error;
     +	int			bmapi_flags = XFS_BMAPI_NODISCARD;
    ++	bool			has_verity =
    ++			ip->i_diflags2 & XFS_DIFLAG2_VERITY;

      	/* Attach the dquots to the inode up front. */
      	error = xfs_qm_dqattach(ip);
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      	 */
     -	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
     +	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND) ||
    -+			(flags & XFS_FREE_FSVERITY)) {
    ++			has_verity) {
      		if (ip->i_delayed_blks) {
      			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
      				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      		}
      		xfs_inode_clear_eofblocks_tag(ip);
     -		return 0;
    -+		if (!(flags & XFS_FREE_FSVERITY))
    ++		if (!has_verity)
     +			return 0;
      	}

    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      	xfs_ilock(ip, XFS_ILOCK_EXCL);
      	xfs_trans_ijoin(tp, ip, 0);

    -+	if (flags & XFS_FREE_FSVERITY)
    ++	if (has_verity)
     +		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
     +
      	/*
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      	if (error)
      		goto err_cancel;

    -@@ fs/xfs/xfs_bmap_util.c: xfs_prepare_shift(
    - 	 * into the accessible region of the file.
    - 	 */
    - 	if (xfs_can_free_eofblocks(ip)) {
    --		error = xfs_free_eofblocks(ip);
    -+		error = xfs_free_eofblocks(ip, XFS_FREE_ALL);
    - 		if (error)
    - 			return error;
    - 	}
    -
    - ## fs/xfs/xfs_bmap_util.h ##
    -@@ fs/xfs/xfs_bmap_util.h: int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
    - int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
    - 		xfs_off_t len);
    -
    -+/*
    -+ * Remove all extents and reservations beyond EOF
    -+ */
    -+#define XFS_FREE_ALL		0
    -+
    -+/*
    -+ * Do the normal post EOF cleaning except don't remove normal extents, in other
    -+ * words, remove unwritten, delayed allocation and cow reservations
    -+ */
    -+#define XFS_FREE_FSVERITY	1
    -+
    - /* EOF block manipulation functions */
    - bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
    --int	xfs_free_eofblocks(struct xfs_inode *ip);
    -+int	xfs_free_eofblocks(struct xfs_inode *ip, int flags);
    -
    - int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
    - 			 struct xfs_swapext *sx);
    -
    - ## fs/xfs/xfs_file.c ##
    -@@ fs/xfs/xfs_file.c: xfs_file_release(
    - 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
    - 		if (xfs_can_free_eofblocks(ip) &&
    - 		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
    --			xfs_free_eofblocks(ip);
    -+			xfs_free_eofblocks(ip, XFS_FREE_ALL);
    - 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
    - 	}
    -
    -
    - ## fs/xfs/xfs_icache.c ##
    -@@ fs/xfs/xfs_icache.c: xfs_inode_free_eofblocks(
    - 	*lockflags |= XFS_IOLOCK_EXCL;
    -
    - 	if (xfs_can_free_eofblocks(ip))
    --		return xfs_free_eofblocks(ip);
    -+		return xfs_free_eofblocks(ip, XFS_FREE_ALL);
    -
    - 	/* inode could be preallocated */
    - 	trace_xfs_inode_free_eofblocks_invalid(ip);
    -
    - ## fs/xfs/xfs_inode.c ##
    -@@ fs/xfs/xfs_inode.c: xfs_inactive(
    - 		 * reference to the inode at this point anyways.
    - 		 */
    - 		if (xfs_can_free_eofblocks(ip))
    --			error = xfs_free_eofblocks(ip);
    -+			error = xfs_free_eofblocks(ip, XFS_FREE_ALL);
    -
    - 		goto out;
    - 	}
16:  ecdaf2c2fe56 ! 19:  3311d1e83ace xfs: add fs-verity support
    @@ Commit message
         Merkle tree block. The size of the descriptor is stored at the end of
         the last descriptor block (descriptor can be multiple blocks).

    -    XFS preallocates spaces during writes. In normal I/O this space, if
    -    unused, is removed by truncate. For files with fsverity, XFS does not use
    -    truncate as fsverity metadata is stored past EOF. We call
    -    xfs_free_eofblocks() explicitly to clean up any unused space as these
    -    files will not change anymore.
    +    Pro-actively remove any unwritten extents as we use last extent to
    +    locate descriptor.

         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>

    - ## fs/xfs/xfs_bmap_util.c ##
    -@@
    - #include "xfs_rtbitmap.h"
    - #include "xfs_rtgroup.h"
    - #include "xfs_zone_alloc.h"
    -+#include <linux/fsverity.h>
    -
    - /* Kernel only BMAP related definitions and functions */
    -
    -@@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
    - 	if (last_fsb <= end_fsb)
    - 		return false;
    -
    -+	/*
    -+	 * Don't clean fsverity inodes as they have metadata store beyond EOF
    -+	 */
    -+	if (fsverity_active(VFS_I(ip)) ||
    -+	    xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    -+		return false;
    -+
    - 	/*
    - 	 * Check if there is an post-EOF extent to free.  If there are any
    - 	 * delalloc blocks attached to the inode (data fork delalloc
    -
      ## fs/xfs/xfs_fsverity.c ##
     @@
      #include "xfs_fs.h"
      #include "xfs_shared.h"
      #include "xfs_format.h"
     -#include "xfs_log_format.h"
    -+#include "xfs_shared.h"
      #include "xfs_trans_resv.h"
      #include "xfs_mount.h"
      #include "xfs_inode.h"
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +		goto out;
     +
     +	/*
    -+	 * Remove unwritten extents left by COW preallocations and write
    -+	 * preallocation in the merkle tree holes and past descriptor, and any
    -+	 * delayed preallocations
    -+	 */
    -+	error = xfs_free_eofblocks(ip, XFS_FREE_FSVERITY);
    -+	if (error)
    -+		goto out;
    -+
    -+	/*
     +	 * Set fsverity inode flag
     +	 */
     +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +
     +	error = xfs_trans_commit(tp);
     +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
    ++	if (error)
    ++		goto out;
     +
    -+	if (!error)
    -+		inode_set_flags(inode, S_VERITY, S_VERITY);
    ++	inode_set_flags(inode, S_VERITY, S_VERITY);
     +
    ++	/*
    ++	 * Proactively remove unwritten extents left by COW preallocations and
    ++	 * write preallocation in the merkle tree holes and past descriptor,
    ++	 * and any delayed preallocations
    ++	 */
    ++	error = xfs_free_eofblocks(ip);
     +out:
     +	if (error) {
     +		int	error2;
17:  b98ab7e0060a = 20:  741e74a16c57 xfs: initialize fs-verity on file open
18:  1c323be103ea = 21:  6222535378d6 xfs: add fs-verity ioctls
19:  2e245a53c9c1 = 22:  280d429a1cb2 xfs: advertise fs-verity being available on filesystem
20:  9209f0eac914 = 23:  3be2ab5d4793 xfs: check and repair the verity inode flag state
21:  f98784743cc6 = 24:  276ccbb68989 xfs: introduce health state for corrupted fsverity metadata
22:  c8b49bd09f7b = 25:  badb5fce3d20 xfs: enable ro-compat fs-verity flag

Andrey Albershteyn (18):
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
  xfs: make xfs_free_eofblocks() work with fsverity inodes
  xfs: add fs-verity support
  xfs: initialize fs-verity on file open
  xfs: add fs-verity ioctls
  xfs: introduce health state for corrupted fsverity metadata
  xfs: enable ro-compat fs-verity flag

Christoph Hellwig (4):
  block: don't delay bio task completions
  iomap: add a iomap_ioend_flags helper
  iomap: add a IOMAP_IOEND_INTEGRITY flag
  xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os

Darrick J. Wong (2):
  xfs: advertise fs-verity being available on filesystem
  xfs: check and repair the verity inode flag state

Tal Zussman (1):
  block: add task-context bio completion infrastructure

 block/bio.c                    | 147 +++++++++++-
 fs/btrfs/inode.c               |   3 -
 fs/btrfs/verity.c              |   6 +-
 fs/ext4/inode.c                |   5 +-
 fs/ext4/verity.c               |  36 +--
 fs/f2fs/file.c                 |   5 +-
 fs/f2fs/verity.c               |  34 +--
 fs/file_attr.c                 |  11 +-
 fs/iomap/ioend.c               |  14 +-
 fs/stat.c                      |   6 +-
 fs/verity/enable.c             |   4 +-
 fs/verity/open.c               |  26 ++-
 fs/verity/pagecache.c          |  33 +++
 fs/verity/verify.c             |   4 +
 fs/xfs/Makefile                |   1 +
 fs/xfs/libxfs/xfs_bmap.c       |  66 ++++--
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
 fs/xfs/xfs_aops.c              |  58 +++--
 fs/xfs/xfs_bmap_util.c         |  25 +-
 fs/xfs/xfs_file.c              |  76 +++++--
 fs/xfs/xfs_fsverity.c          | 405 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h          |  28 +++
 fs/xfs/xfs_health.c            |   1 +
 fs/xfs/xfs_inode.h             |   6 +
 fs/xfs/xfs_ioctl.c             |  14 ++
 fs/xfs/xfs_ioend.c             |  78 ++++++-
 fs/xfs/xfs_ioend.h             |   4 +
 fs/xfs/xfs_iomap.c             |  31 ++-
 fs/xfs/xfs_iomap.h             |   5 +-
 fs/xfs/xfs_iops.c              |  12 +-
 fs/xfs/xfs_message.c           |   4 +
 fs/xfs/xfs_message.h           |   1 +
 fs/xfs/xfs_mount.h             |   4 +
 fs/xfs/xfs_super.c             |   7 +
 include/linux/bio.h            |  32 +++
 include/linux/blk_types.h      |   1 +
 include/linux/fsverity.h       |  10 +-
 include/linux/iomap.h          |  24 +-
 48 files changed, 1222 insertions(+), 169 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

-- 
2.54.0

