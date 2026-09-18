Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073014ACC8B;
	Fri, 18 Sep 2026 11:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730151; cv=none; b=theOsE6Cvh9Q3ZwjzOsLnZR/P36+9xRH0RuxlvWU8eXwMq3SLBncJ3xNmwpHaHXvkF9l3+lLupLoE+IRjcbIgNohCMDIQehyutlw5ZHwqjY1kE4azscSysi9ob1sPuSaTdwWjJMPxvOSxlHj/7kNqqOpG5q2LfrgKFGBheQ6Mpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730151; c=relaxed/simple;
	bh=Wb7Jwx15A2oaORvclQH8psjtsryQVeBc0KZwzaAHKEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N/HP09IrjFJCJk3N0Of65u//BVM1JJ+rwfINFNkQMczBCnnelp2z+qjKaQeEoYAkH6wr+n7RqOy56Mxe5JG6S7CTouviF43/vr4vFhA6DXfg6q//ZPTBKVH2KgPoRlc6Tz1jDh9kXbIZUPrvrGxMK7dngyua1ZriNQHDLHtH+g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDu8v0r3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDu8v0r3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396DC1F000FF;
	Fri, 18 Sep 2026 11:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730147;
	bh=m3Am9ASovUCk7OfkRyhGT2ZJ4m/MwekIttDUdytBpPA=;
	h=From:To:Cc:Subject:Date;
	b=XDu8v0r3McLaA8vp2pbIvzKKohjT0Z9EWMuR4RQki3aOUyohVzmQnu04/QtWIs4dj
	 3b1wXYuoggRabZizEA2v9KvjwwcYIoFpmUHYYVeCPn9AqkcGYlNC40xpY0Vtn9sOAK
	 hKEObwNJUfgtgNWLZUqXgp5lexqEuK9IXleT9qYh5VFy4nVu2KrCAegKZ/Ff9GPFDk
	 8GDJcE3AlcUHY9XBfb85rXw1H+yermOkWZUB+YXTbRoCuCjwgmI/oAUfypY3wcHGpm
	 XXGmk7BLvcKgyLOyb2bWoUQ5Y53q6jgMrCqlDPccmAYapkN/YO8K4F/v+ETjVYcK0m
	 KYPm23jyx1k9w==
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
Subject: [PATCH v16 00/21] fs-verity support for XFS with post EOF merkle tree
Date: Fri, 18 Sep 2026 13:15:12 +0200
Message-ID: <20260918111539.1003439-1-aalbersh@kernel.org>
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

The main change from v15 is addion of kmem cache
xfs_fsverity_ioend_cache instead of adding work_struct to iomap's ioend
struct.

Patches without review:
[PATCH v16 12/21] xfs: use read ioend for fsverity data verification
[PATCH v16 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten
[PATCH v16 14/21] xfs: don't remove written extents past EOF on

This series based on block/for-next (has lazy-bounce series)

block/for-next:
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=for-next

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=fsverity

xfsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git/log/?h=fsverity

xfstests:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfstests-dev.git/log/?h=fsverity

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
 fs/verity/open.c               |  26 ++-
 fs/verity/pagecache.c          |  33 +++
 fs/verity/verify.c             |   4 +
 fs/xfs/Makefile                |   1 +
 fs/xfs/libxfs/xfs_bmap.c       |  17 +-
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
 fs/xfs/xfs_aops.c              |  49 +++-
 fs/xfs/xfs_bmap_util.c         |  25 +-
 fs/xfs/xfs_file.c              |  71 ++++--
 fs/xfs/xfs_fsverity.c          | 407 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h          |  36 +++
 fs/xfs/xfs_health.c            |   1 +
 fs/xfs/xfs_inode.h             |   6 +
 fs/xfs/xfs_ioctl.c             |  14 ++
 fs/xfs/xfs_ioend.c             |  65 +++++-
 fs/xfs/xfs_ioend.h             |   4 +-
 fs/xfs/xfs_iomap.c             |  31 ++-
 fs/xfs/xfs_iomap.h             |   5 +-
 fs/xfs/xfs_iops.c              |  12 +-
 fs/xfs/xfs_message.c           |   4 +
 fs/xfs/xfs_message.h           |   1 +
 fs/xfs/xfs_mount.h             |   4 +
 fs/xfs/xfs_super.c             |  22 ++
 include/linux/fsverity.h       |  10 +-
 43 files changed, 984 insertions(+), 138 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

Range-diff against v15:
 1:  1aec2e239aff =  1:  094627f6c973 fsverity: report validation errors through fserror to fsnotify
 2:  eb9775389956 =  2:  877456f91be2 fsverity: expose ensure_fsverity_info()
 3:  62bc33559c3f =  3:  1ab385e28833 fsverity: pass digest size and hash of the all-zeroes block to ->write
 4:  5d4f63be1694 =  4:  d984a8f7ac2a fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
 5:  4c9bfc9694f6 =  5:  bc529e4308a2 fsverity: don't allow setting DAX file attribute on fsverity files
 6:  4a0f5a07d0b1 =  6:  11b7b6d6b237 fsverity: hoist statx reporting of fs-verity flag
 7:  1695341b674c <  -:  ------------ block: add task-context bio completion infrastructure
 8:  43f924f152af <  -:  ------------ block: don't delay bio task completions
 9:  ab8ed572ce79 <  -:  ------------ iomap: add a iomap_ioend_flags helper
10:  3477d06ae82e <  -:  ------------ iomap: add a IOMAP_IOEND_INTEGRITY flag
12:  d96ffea67314 =  7:  f94348c524e8 xfs: introduce fsverity on-disk changes
13:  d8da1e4acec1 =  8:  6c459e4ba14a xfs: don't allow to enable DAX on fs-verity sealed inode
14:  f2125f58f0d5 !  9:  61dbf3277865 xfs: disable direct read path for fs-verity files
    @@ Commit message
     
      ## fs/xfs/xfs_file.c ##
     @@
    - #include <linux/fadvise.h>
      #include <linux/mount.h>
      #include <linux/filelock.h>
    + #include <linux/bio-integrity.h>
     +#include <linux/fsverity.h>
      
      static const struct vm_operations_struct xfs_file_vm_ops;
    @@ fs/xfs/xfs_file.c: xfs_file_dio_read(
     +		return xfs_file_buffered_read(iocb, to);
     +	}
      	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
    - 		dio_ops = &xfs_dio_read_bounce_ops;
    - 		dio_flags |= IOMAP_DIO_BOUNCE;
    + 		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
    + 				&xfs_dio_read_bounce_ops, 0, NULL, 0);
     @@ fs/xfs/xfs_file.c: xfs_file_dax_read(
      	struct kiocb		*iocb,
      	struct iov_iter		*to)
15:  a30ca3efd40a ! 10:  a915e649b7b5 xfs: don't report dio_mem_align and dio_offset_align for fsverity files
    @@ Commit message
     
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Acked-by: Eric Biggers <ebiggers@kernel.org>
    +    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
     
      ## fs/xfs/xfs_iops.c ##
     @@
16:  0d9385f44edb ! 11:  9920843a040c xfs: handle fsverity I/O in write/read path
    @@ Commit message
         the inode.
     
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/Makefile ##
     @@ fs/xfs/Makefile: xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
    @@ fs/xfs/xfs_aops.c
      #include "xfs_zone_alloc.h"
      #include "xfs_rtgroup.h"
     +#include "xfs_fsverity.h"
    - #include <linux/bio-integrity.h>
      
      struct xfs_writepage_ctx {
    + 	struct iomap_writepage_ctx ctx;
     @@ fs/xfs/xfs_aops.c: xfs_map_blocks(
      	int			retries = 0;
      	int			error = 0;
    @@ fs/xfs/xfs_aops.c: xfs_vm_writepages(
     
      ## fs/xfs/xfs_fsverity.c (new) ##
     @@
    -+/* SPDX-License-Identifier: GPL-2.0 */
    ++// SPDX-License-Identifier: GPL-2.0
     +/*
     + * Copyright (C) 2026 Red Hat, Inc.
     + */
    @@ fs/xfs/xfs_fsverity.c (new)
     
      ## fs/xfs/xfs_fsverity.h (new) ##
     @@
    -+/* SPDX-License-Identifier: GPL-2.0 */
    ++// SPDX-License-Identifier: GPL-2.0
     +/*
     + * Copyright (C) 2026 Red Hat, Inc.
     + */
    @@ fs/xfs/xfs_iomap.c: xfs_read_iomap_begin(
     +	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
      }
      
    - const struct iomap_ops xfs_read_iomap_ops = {
    + static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
     
      ## fs/xfs/xfs_iomap.h ##
     @@ fs/xfs/xfs_iomap.h: xfs_iomap_set_anon_write(
    @@ fs/xfs/xfs_iomap.h: xfs_iomap_set_anon_write(
      	iomap->length = length;
     -	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
     +	iomap->flags = iomap_flags | IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
    + 	if (bdev_has_integrity_csum(iomap->bdev))
    + 		iomap->flags |= IOMAP_F_INTEGRITY;
      }
    - 
    - static inline xfs_filblks_t
17:  ee12fec4a28e ! 12:  7bb9559cd4cb xfs: use read ioend for fsverity data verification
    @@ Commit message
         data that needs verification.
     
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    -    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
     
      ## fs/xfs/xfs_aops.c ##
     @@
    + #include "xfs_zone_alloc.h"
      #include "xfs_rtgroup.h"
      #include "xfs_fsverity.h"
    - #include <linux/bio-integrity.h>
     +#include <linux/fsverity.h>
      
      struct xfs_writepage_ctx {
    @@ fs/xfs/xfs_aops.c: static const struct iomap_read_ops xfs_iomap_read_ops = {
      xfs_get_iomap_read_ops(
     -	const struct address_space	*mapping)
     +	const struct address_space	*mapping,
    -+	loff_t				position)
    ++	loff_t				pos)
      {
      	struct xfs_inode		*ip = XFS_I(mapping->host);
      
     -	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
     +	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
    -+			xfs_fsverity_is_file_data(ip, position))
    ++	    xfs_fsverity_is_file_data(ip, pos))
      		return &xfs_iomap_read_ops;
      	return &iomap_bio_read_ops;
      }
    @@ fs/xfs/xfs_file.c: xfs_dio_read_bounce_submit_io(
      static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
     
      ## fs/xfs/xfs_fsverity.c ##
    -@@ fs/xfs/xfs_fsverity.c: xfs_fsverity_metadata_offset(
    +@@
    + #include <linux/fsverity.h>
    + #include <linux/iomap.h>
    + 
    ++struct kmem_cache *xfs_fsverity_ioend_cache;
    ++
    + loff_t
    + xfs_fsverity_metadata_offset(
    + 	const struct xfs_inode	*ip)
      {
      	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
      }
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_metadata_offset(
     
      ## fs/xfs/xfs_fsverity.h ##
     @@
    + #define __XFS_FSVERITY_H__
    + 
    + #include "xfs_platform.h"
    ++#include <linux/iomap.h>
      
      #ifdef CONFIG_FS_VERITY
      loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
    @@ fs/xfs/xfs_fsverity.h
     +}
      #endif	/* CONFIG_FS_VERITY */
      
    ++struct xfs_fsverity_ioend {
    ++	struct iomap_ioend	*ioend;
    ++	struct work_struct	work;
    ++};
    ++
    ++extern struct kmem_cache *xfs_fsverity_ioend_cache;
    ++
      #endif	/* __XFS_FSVERITY_H__ */
     
      ## fs/xfs/xfs_ioend.c ##
     @@
    - #include "xfs_reflink.h"
    - #include "xfs_zone_alloc.h"
      #include "xfs_ioend.h"
    -+#include "xfs_error.h"
    -+#include "xfs_errortag.h"
    + #include "xfs_error.h"
    + #include "xfs_errortag.h"
     +#include "xfs_fsverity.h"
      #include <linux/bio-integrity.h>
     +#include <linux/fsverity.h>
     +
     +static void
     +xfs_end_fsverity_io_read(
    -+	struct work_struct	*work)
    ++	struct work_struct		*work)
     +{
    -+	struct iomap_ioend	*ioend =
    -+		container_of(work, struct iomap_ioend, io_work);
    ++	struct xfs_fsverity_ioend	*fsv_ioend =
    ++			container_of(work, struct xfs_fsverity_ioend, work);
    ++	struct iomap_ioend		*ioend = fsv_ioend->ioend;
    ++	struct bio			*bio = &ioend->io_bio;
     +
    -+	if (!ioend->io_bio.bi_status)
    -+		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
    ++	kmem_cache_free(xfs_fsverity_ioend_cache, fsv_ioend);
     +
    -+	iomap_finish_ioends(
    -+		ioend, blk_status_to_errno(ioend->io_bio.bi_status));
    ++	if (!bio->bi_status)
    ++		fsverity_verify_bio(ioend->io_vi, bio);
    ++
    ++	iomap_finish_ioends(ioend, blk_status_to_errno(bio->bi_status));
     +}
      
    + static void
    + xfs_dio_bounce_end_io(
    +@@ fs/xfs/xfs_ioend.c: xfs_read_bounce_and_resubmit(
    + 
      static void
      xfs_end_io_read(
    - 	struct bio		*bio)
    +-	struct bio		*bio)
    ++	struct bio			*bio)
      {
    - 	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
    -+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
    - 	int			error = blk_status_to_errno(bio->bi_status);
    +-	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
    +-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
    +-	struct xfs_mount	*mp = ip->i_mount;
    +-	int			error = blk_status_to_errno(bio->bi_status);
    ++	struct iomap_ioend		*ioend = iomap_ioend_from_bio(bio);
    ++	struct xfs_inode		*ip = XFS_I(ioend->io_inode);
    ++	struct xfs_mount		*mp = ip->i_mount;
    ++	int				error =
    ++			blk_status_to_errno(bio->bi_status);
    ++	struct xfs_fsverity_ioend	*fsv_ioend;
    + 
    + 	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY)) {
    + 		error = iomap_ioend_integrity_verify(ioend);
    +@@ fs/xfs/xfs_ioend.c: xfs_end_io_read(
    + 		}
    + 	}
      
     +	/*
     +	 * If we have fsverity and block device integrity attached to this bio,
    @@ fs/xfs/xfs_ioend.c
     +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
     +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
     +		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
    -+			fsverity_enqueue_verify_work(&ioend->io_work);
    ++			fsv_ioend = kmem_cache_zalloc(xfs_fsverity_ioend_cache,
    ++					GFP_KERNEL);
    ++			if (!fsv_ioend) {
    ++				iomap_finish_ioends(ioend, -ENOMEM);
    ++				return;
    ++			}
    ++			fsv_ioend->ioend = ioend;
    ++			INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
    ++
    ++			fsverity_enqueue_verify_work(&fsv_ioend->work);
     +			return;
     +		}
     +
    @@ fs/xfs/xfs_ioend.c: xfs_ioend_submit_read(
     +	u16			ioend_flags,
     +	struct fsverity_info	*vi)
      {
    --	iomap_init_ioend(inode, bio, file_offset, ioend_flags);
    -+	struct iomap_ioend	*ioend;
    -+
    -+	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
    + 	struct xfs_inode	*ip = XFS_I(inode);
    + 	struct xfs_mount	*mp = ip->i_mount;
    + 	struct iomap_ioend	*ioend;
    + 
    + 	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
     +	ioend->io_vi = vi;
    -+	INIT_WORK(&ioend->io_work, xfs_end_fsverity_io_read);
    -+
    - 	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
    - 		fs_bio_integrity_alloc(bio);
    - 	bio->bi_end_io = xfs_end_io_read;
    + 	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
    + 	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
    + 		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
     
      ## fs/xfs/xfs_ioend.h ##
     @@
    @@ fs/xfs/xfs_ioend.h: static inline bool xfs_ioend_is_append(struct iomap_ioend *i
      
      #endif /* __XFS_IOEND_H */
     
    - ## include/linux/iomap.h ##
    -@@ include/linux/iomap.h: struct iomap_ioend {
    - 	sector_t		io_sector;	/* start sector of ioend */
    - 	void			*io_private;	/* file system private data */
    - 	struct fsverity_info	*io_vi;		/* fsverity info */
    -+	struct work_struct	io_work;	/* fsverity blocking I/O */
    - 	struct bio		io_bio;		/* MUST BE LAST! */
    - };
    + ## fs/xfs/xfs_super.c ##
    +@@ fs/xfs/xfs_super.c: xfs_init_caches(void)
    + 	if (!xfs_parent_args_cache)
    + 		goto out_destroy_xmi_cache;
      
    ++#ifdef CONFIG_FS_VERITY
    ++	xfs_fsverity_ioend_cache = kmem_cache_create("xfs_fsverity_ioend",
    ++					     sizeof(struct xfs_fsverity_ioend),
    ++					     0, 0, NULL);
    ++	if (!xfs_fsverity_ioend_cache)
    ++		goto out_destroy_fsverity_ioend_cache;
    ++#endif
    ++
    + 	return 0;
    + 
    ++#ifdef CONFIG_FS_VERITY
    ++ out_destroy_fsverity_ioend_cache:
    ++	kmem_cache_destroy(xfs_fsverity_ioend_cache);
    ++#endif
    +  out_destroy_xmi_cache:
    + 	kmem_cache_destroy(xfs_xmi_cache);
    +  out_destroy_xmd_cache:
    +@@ fs/xfs/xfs_super.c: xfs_destroy_caches(void)
    + 	 * destroy caches.
    + 	 */
    + 	rcu_barrier();
    ++#ifdef CONFIG_FS_VERITY
    ++	kmem_cache_destroy(xfs_fsverity_ioend_cache);
    ++#endif
    + 	kmem_cache_destroy(xfs_parent_args_cache);
    + 	kmem_cache_destroy(xfs_xmd_cache);
    + 	kmem_cache_destroy(xfs_xmi_cache);
11:  881f5c8f286f ! 13:  37c092fa5240 xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
    @@
      ## Metadata ##
    -Author: Christoph Hellwig <hch@lst.de>
    +Author: Andrey Albershteyn <aalbersh@kernel.org>
     
      ## Commit message ##
    -    xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
    +    xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
     
    -    Stop using the xfs per-inode work struct for completing read bios, as
    -    unlike writes we don't want to serialize reads on a single inode as
    -    there is no exclusive resource contention for them.
    +    The __xfs_bunmapi() is used to remove all extents past EOF. Add
    +    XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
    +    written ones in place. This will be used in following patch to clean up
    +    unwritten extents on fsverity inodes.
     
    -    Factor the code for kicking off a read that needs and ioend and the
    -    task context completion into a single helper so that it is split off
    -    the xfs_end_bio machinery, which is not only used for writes.
    +    Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
    -    Signed-off-by: Christoph Hellwig <hch@lst.de>
    -    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
    -
    - ## fs/xfs/xfs_aops.c ##
    -@@ fs/xfs/xfs_aops.c: xfs_bio_submit_read(
    - 	const struct iomap_iter		*iter,
    - 	struct iomap_read_folio_ctx	*ctx)
    - {
    --	struct bio			*bio = ctx->read_ctx;
    + ## fs/xfs/libxfs/xfs_bmap.c ##
    +@@ fs/xfs/libxfs/xfs_bmap.c: __xfs_bunmapi(
    + 		if (del.br_startoff + del.br_blockcount > end + 1)
    + 			del.br_blockcount = end + 1 - del.br_startoff;
    + 
    ++		if ((flags & XFS_BMAPI_UNWRITTEN) &&
    ++				del.br_state != XFS_EXT_UNWRITTEN)
    ++			goto skip;
    ++
    + 		if (!isrt || (flags & XFS_BMAPI_REMAP))
    + 			goto delete;
    + 
    +@@ fs/xfs/libxfs/xfs_bmap.c: __xfs_bunmapi(
    + 			if (error)
    + 				goto error0;
    + 		}
     -
    --	/* defer read completions to the ioend workqueue */
    --	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
    --		iomap_ioend_flags(&iter->iomap));
    --	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
    -+	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
    -+			ctx->read_ctx_file_offset,
    -+			iomap_ioend_flags(&iter->iomap));
    -+	ctx->read_ctx = NULL;
    - }
    - 
    - static const struct iomap_read_ops xfs_iomap_read_ops = {
    ++skip:
    + 		end = del.br_startoff - 1;
    + nodelete:
    + 		/*
     
    - ## fs/xfs/xfs_file.c ##
    -@@ fs/xfs/xfs_file.c: xfs_dio_read_bounce_submit_io(
    - 	struct bio		*bio,
    - 	loff_t			file_offset)
    - {
    --	iomap_init_ioend(iter->inode, bio, file_offset,
    --		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
    --	bio->bi_end_io = xfs_end_bio;
    --	submit_bio(bio);
    -+	xfs_ioend_submit_read(iter->inode, bio, file_offset,
    -+			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
    - }
    + ## fs/xfs/libxfs/xfs_bmap.h ##
    +@@ fs/xfs/libxfs/xfs_bmap.h: struct xfs_bmalloca {
    + /* Try to align allocations to the extent size hint */
    + #define XFS_BMAPI_EXTSZALIGN	(1u << 11)
      
    - static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
    -
    - ## fs/xfs/xfs_ioend.c ##
    -@@
    - #include "xfs_reflink.h"
    - #include "xfs_zone_alloc.h"
    - #include "xfs_ioend.h"
    -+#include <linux/bio-integrity.h>
    -+
    -+static void
    -+xfs_end_io_read(
    -+	struct bio		*bio)
    -+{
    -+	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
    -+	int			error = blk_status_to_errno(bio->bi_status);
    ++/* Process unwritten extents only. Used for unmapping */
    ++#define XFS_BMAPI_UNWRITTEN	(1u << 12)
     +
    -+	iomap_finish_ioends(ioend, error);
    -+}
    -+
    -+void
    -+xfs_ioend_submit_read(
    -+	struct inode		*inode,
    -+	struct bio		*bio,
    -+	loff_t			file_offset,
    -+	u16			ioend_flags)
    -+{
    -+	iomap_init_ioend(inode, bio, file_offset, ioend_flags);
    -+	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
    -+		fs_bio_integrity_alloc(bio);
    -+	bio->bi_end_io = xfs_end_io_read;
    -+	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
    -+	submit_bio(bio);
    -+}
    - 
    - static void
    - xfs_ioend_put_open_zones(
    -@@ fs/xfs/xfs_ioend.c: xfs_end_io(
    - 			io_list))) {
    - 		list_del_init(&ioend->io_list);
    - 		iomap_ioend_try_merge(ioend, &tmp);
    --		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
    --			iomap_finish_ioends(ioend,
    --				blk_status_to_errno(ioend->io_bio.bi_status));
    --		else
    --			xfs_end_ioend_write(ioend);
    -+		xfs_end_ioend_write(ioend);
    - 		cond_resched();
    - 	}
    - }
    -
    - ## fs/xfs/xfs_ioend.h ##
    -@@ fs/xfs/xfs_ioend.h: static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
    - }
    + #define XFS_BMAPI_FLAGS \
    + 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
    + 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
    +@@ fs/xfs/libxfs/xfs_bmap.h: struct xfs_bmalloca {
    + 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
    + 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
    + 	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
    +-	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
    ++	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
    ++	{ XFS_BMAPI_UNWRITTEN,	"UNWRITTEN" }
      
    - void xfs_end_bio(struct bio *bio);
    -+void xfs_ioend_submit_read(struct inode *inode, struct bio *bio,
    -+		loff_t file_offset, u16 ioend_flags);
      
    - #endif /* __XFS_IOEND_H */
    + static inline int xfs_bmapi_aflag(int w)
18:  d9a489488c05 ! 14:  2560cea141e6 xfs: make xfs_free_eofblocks() work with fsverity inodes
    @@ Metadata
     Author: Andrey Albershteyn <aalbersh@kernel.org>
     
      ## Commit message ##
    -    xfs: make xfs_free_eofblocks() work with fsverity inodes
    +    xfs: don't remove written extents past EOF on fsverity inodes
     
    -    xfs_free_eofblocks() removes any preallocations and unwritten extents
    -    beyond EOF. This is undesired for fsverity as it stores metadata beyond
    -    EOF. However, while merkle tree is being built delayed preallocation and
    -    unwritten extents are used. After metadata construction is done,
    -    fsverity inodes becomes read-only and won't be changed anymore, none of
    -    these unwritten extents or preallocations in post EOF region will be
    -    used.
    +    xfs_free_eofblocks() removes all extents past EOF unless the
    +    XFS_DIFLAG_PREALLOC or XFS_DIFLAG_APPEND flags are set. This is
    +    undesired for fsverity as it stores metadata beyond EOF. However, while
    +    merkle tree is being built, delayed preallocation and unwritten extents
    +    are used. After metadata construction is done, fsverity inodes becomes
    +    read-only and won't be changed anymore, none of these unwritten extents
    +    or preallocations in post EOF region will be used.
     
    -    Add XFS_BMAPI_UNWRITTEN and change xfs_bunmapi_range to remove only
    -    unwritten extents sitting beyond EOF and set it for fsverity inodes.
    -
    -    The xfs_free_eofblocks() will be called on fsverity inode as usual.
    -    However, inodes which are undergoing merkle tree construction need to
    -    be skipped in case reclaim takes place.
    +    Let xfs_free_eofblocks() be called on fsverity inode as usual to remove
    +    anything which is not written extent. However, inodes which are
    +    undergoing merkle tree construction need to be skipped in case reclaim
    +    takes place.
     
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
    - ## fs/xfs/libxfs/xfs_bmap.c ##
    -@@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmap_validate_extent(
    - 			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
    - }
    - 
    --/*
    -- * Used in xfs_itruncate_extents().  This is the maximum number of extents
    -- * freed from a file in a single transaction.
    -- */
    --#define	XFS_ITRUNC_MAX_EXTENTS	2
    --
    - /*
    -  * Unmap every extent in part of an inode's fork.  We don't do any higher level
    -  * invalidation work at all.
    -+ *
    -+ * The XFS_BMAPI_UNWRITTEN could be passed to remove only unwritten extents,
    -+ * leaving out normal extents in place.
    -  */
    - int
    - xfs_bunmapi_range(
    -@@ fs/xfs/libxfs/xfs_bmap.c: xfs_bunmapi_range(
    - 	xfs_fileoff_t		startoff,
    - 	xfs_fileoff_t		endoff)
    - {
    --	xfs_filblks_t		unmap_len = endoff - startoff + 1;
    -+	xfs_filblks_t           unmap_len;
    - 	int			error = 0;
    -+	int			nimaps = 1;
    -+	int			done = 0;
    -+	struct xfs_bmbt_irec	imap;
    -+	int			read_flags =
    -+			flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE);
    - 
    - 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
    - 
    --	while (unmap_len > 0) {
    --		ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
    --		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len, flags,
    --				XFS_ITRUNC_MAX_EXTENTS);
    -+	while (startoff < endoff) {
    -+		nimaps = 1;
    -+
    -+		error = xfs_bmapi_read(ip, startoff, endoff - startoff + 1,
    -+				&imap, &nimaps, read_flags);
    - 		if (error)
    - 			goto out;
    - 
    --		/* free the just unmapped extents */
    --		error = xfs_defer_finish(tpp);
    --		if (error)
    -+		if (nimaps == 0)
    - 			goto out;
    --		cond_resched();
    -+
    -+		if ((flags & XFS_BMAPI_UNWRITTEN) &&
    -+				imap.br_state != XFS_EXT_UNWRITTEN) {
    -+			startoff = imap.br_startoff + imap.br_blockcount;
    -+			continue;
    -+		}
    -+
    -+		unmap_len = min(endoff - imap.br_startoff + 1,
    -+				imap.br_blockcount);
    -+		done = 0;
    -+		while (!done) {
    -+			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
    -+			error = xfs_bunmapi(*tpp, ip, imap.br_startoff,
    -+					unmap_len, flags, nimaps, &done);
    -+			if (error)
    -+				goto out;
    -+
    -+			/* free the just unmapped extent */
    -+			error = xfs_defer_finish(tpp);
    -+			if (error)
    -+				goto out;
    -+			cond_resched();
    -+		}
    -+
    -+		startoff = imap.br_startoff + unmap_len;
    - 	}
    - out:
    - 	return error;
    -
    - ## fs/xfs/libxfs/xfs_bmap.h ##
    -@@ fs/xfs/libxfs/xfs_bmap.h: struct xfs_bmalloca {
    - /* Try to align allocations to the extent size hint */
    - #define XFS_BMAPI_EXTSZALIGN	(1u << 11)
    - 
    -+/* Process unwritten extents only. Used for unmapping */
    -+#define XFS_BMAPI_UNWRITTEN	(1u << 12)
    -+
    - #define XFS_BMAPI_FLAGS \
    - 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
    - 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
    -@@ fs/xfs/libxfs/xfs_bmap.h: struct xfs_bmalloca {
    - 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
    - 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
    - 	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
    --	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
    -+	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
    -+	{ XFS_BMAPI_UNWRITTEN,	"UNWRITTEN" }
    - 
    - 
    - static inline int xfs_bmapi_aflag(int w)
    -
      ## fs/xfs/xfs_bmap_util.c ##
     @@
      #include "xfs_rtbitmap.h"
19:  6b085a40ae6f ! 15:  7bb438e1a24e xfs: add fs-verity support
    @@ fs/xfs/xfs_fsverity.c
      #include <linux/iomap.h>
     +#include <linux/pagemap.h>
      
    - loff_t
    - xfs_fsverity_metadata_offset(
    + struct kmem_cache *xfs_fsverity_ioend_cache;
    + 
     @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
      	return fsverity_active(VFS_IC(ip)) &&
      			offset < xfs_fsverity_metadata_offset(ip);
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     
      ## fs/xfs/xfs_fsverity.h ##
     @@
    - #define __XFS_FSVERITY_H__
      
      #include "xfs_platform.h"
    + #include <linux/iomap.h>
     +#include <linux/fsverity.h>
      
      #ifdef CONFIG_FS_VERITY
20:  f5d3e63d22d2 = 16:  6df81706af9b xfs: initialize fs-verity on file open
21:  736650f67ab2 = 17:  055d2c228fcf xfs: add fs-verity ioctls
22:  1a1f26614e69 = 18:  1f93d36e9a35 xfs: advertise fs-verity being available on filesystem
23:  58573cc99930 = 19:  c8496df7ca01 xfs: check and repair the verity inode flag state
24:  a69dadffffe7 = 20:  6009a2eb9a39 xfs: introduce health state for corrupted fsverity metadata
25:  be7cfc3ab7c3 = 21:  ae0ee66fb13a xfs: enable ro-compat fs-verity flag
-- 
2.54.0

