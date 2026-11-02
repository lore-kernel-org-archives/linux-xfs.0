Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630530;
	b=1cM+zeL96XwnDzbIt0JoofGPn3gdXIjGVcZdQTbxpPWIoIq4V9DtVvtKduQDD5DT9j9L
	 oQmPLQe4TioGKFwGMVt8eB7yvXnpMVCdXAS3AbWiWX7+w+34pNkufDou1+xUTXl7xjr1Y
	 JEtA77xM6v0XKtEcUfajNCAtZrEo7GtBl65YWiYpUzPayAAqJkypLozjZd60CH47rXB1r
	 aGen3zU1mdzU2VLGB3TCKcxr5SJBeE6cgIAQVeiXE8FvpNZdL0HCiMm21AuJF8gTUNHje
	 jHo4OMOL4sKage7u6zw9laCJu2y55Fy8c3pPjxeBN5DdIvbMkOo2WO1Iq9X/cp3OVfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pX4NmFb4LpvHSiRPiNLmtjlbkiB0B89p34OzdQfsUNk=;
	b=Or18SqXQuwtei1Y98bS7VrWjtB+OoakCt4xD+ZQiW17Ch/xtGag6aGEK6YPFNvidytT2
	 C3F0bJdxEvReXyKrtuxszcXNtxgs32f8Hc69oRr6VlEIfrbCxLpcwF/Ejig9k8yAZxxn1
	 /hdMA58QiWKS7gmgS+zNhUaJ9e21aniFd1EH51Oi3hQ0izvfxasC3zKe2ScUDxPtZWjSy
	 u3du0zJTgEENmB5F9Wf6Nzz3l3p5RbMxvqO8RMXlKYYRPVrA381YAtzMeXJxQxrKOAVLb
	 8xKktwuLCFvnwkjOD0zJvSmhq0iB1i/SPJKAgc1Mmbq6qqFjmEUkvuAmCZdYCFGHxsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWtKP5Eo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272B7606A5A7;
	Mon,  2 Nov 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWtKP5Eo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D484B1F00A16;
	Mon,  2 Nov 2026 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630529;
	bh=pX4NmFb4LpvHSiRPiNLmtjlbkiB0B89p34OzdQfsUNk=;
	h=From:To:Cc:Subject:Date;
	b=cWtKP5EogU/qGsW0kfMflsPEZqajdhveancykb77OnRz8S7EL40Akvy26XW0kr2ZN
	 l/8TnVbSrFtpQuPhT3n6mtH+XQbujOc6m70MUVI5/p6FP4EE9r6Norl7DsQZBDYltx
	 Wc5Bn149b6nNTq/IDxCvHgGb4FKeA7eeEnPKx7eLoBeuXhl2dXlRYgzpvSd0MJD+Ci
	 Fu3XsB4vrOSwt6TCeXgA2YLr+0MpQ0QexcU22g2FdmzgPHg4vIlIOutzQkSyT6WZvS
	 2wtbww7rFNKXmolGyIIv5xhZXDGX9Vu3KzW0jGRdWCQCuURAvivxgEM5leQvFulbe9
	 L/H8rroFrIf7A==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v18 00/15] fs-verity support for XFS with post EOF merkle tree
Date: Mon,  2 Nov 2026 15:41:30 +0100
Message-ID: <20261102144147.2393369-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is next revision of fsverity for XFS.

Patches without review:
[PATCH v18 06/15] xfs: use read ioend for fsverity data verification

This series based on v7.4-rc1

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=fsverity

xfsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git/log/?h=fsverity

xfstests:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfstests-dev.git/log/?h=fsverity

v17:
https://lore.kernel.org/fsverity/20261002223705.2175542-1-aalbersh@kernel.org/T/#u

v16:
https://lore.kernel.org/fsverity/arJC542mXklAeswE@aalbersh-thinkpadx1carbongen13.rmtcz.csb/T/#t

v15:
https://lore.kernel.org/fsverity/20260817070240.GA17371@lst.de/T/#t

To: djwong@kernel.org
To: ebiggers@kernel.org
To: hch@lst.de
To: Carlos Maiolino <cem@kernel.org>
To: fsverity@lists.linux.dev
To: linux-xfs@vger.kernel.org

Cc: linux-fsdevel@vger.kernel.org
Cc: david@fromorbit.com

---
Changes in v18:
- Rebase to latest origin/for-next and drop core fsverity patches
- Move truncate_inode_pages() before xfs_trans_alloc()
- Move xfs_fsverity_metadata_offset() to libxfs as used in xfs_bmap.c
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

Andrey Albershteyn (13):
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

 fs/xfs/Makefile                |   2 +
 fs/xfs/libxfs/xfs_bmap.c       |  14 +-
 fs/xfs/libxfs/xfs_bmap.h       |   6 +-
 fs/xfs/libxfs/xfs_format.h     |  35 ++-
 fs/xfs/libxfs/xfs_fs.h         |   2 +
 fs/xfs/libxfs/xfs_health.h     |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |   8 +
 fs/xfs/libxfs/xfs_inode_util.c |   5 +-
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/libxfs/xfs_verity.c     |  20 ++
 fs/xfs/libxfs/xfs_verity.h     |  12 +
 fs/xfs/scrub/common.c          |  53 ++++
 fs/xfs/scrub/common.h          |   2 +
 fs/xfs/scrub/inode.c           |   7 +
 fs/xfs/scrub/inode_repair.c    |  36 +++
 fs/xfs/xfs_aops.c              |  48 +++-
 fs/xfs/xfs_bmap_util.c         |  31 ++-
 fs/xfs/xfs_file.c              |  71 +++--
 fs/xfs/xfs_fsverity.c          | 482 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h          |  42 +++
 fs/xfs/xfs_health.c            |   1 +
 fs/xfs/xfs_inode.h             |   6 +
 fs/xfs/xfs_ioctl.c             |  14 +
 fs/xfs/xfs_ioend.c             |  53 +++-
 fs/xfs/xfs_ioend.h             |   4 +-
 fs/xfs/xfs_iomap.c             |  41 ++-
 fs/xfs/xfs_iomap.h             |   5 +-
 fs/xfs/xfs_iops.c              |  12 +-
 fs/xfs/xfs_message.c           |   4 +
 fs/xfs/xfs_message.h           |   1 +
 fs/xfs/xfs_mount.h             |   4 +
 fs/xfs/xfs_super.c             |  31 ++-
 32 files changed, 997 insertions(+), 63 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_verity.c
 create mode 100644 fs/xfs/libxfs/xfs_verity.h
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

Range-diff against v17:
 1:  c14aea60fb61 <  -:  ------------ fsverity: report validation errors through fserror to fsnotify
 2:  ba2ec9993a12 <  -:  ------------ fsverity: expose ensure_fsverity_info()
 3:  68694ea8ba0d <  -:  ------------ fsverity: pass digest size and hash of the all-zeroes block to ->write
 4:  5732f007e676 <  -:  ------------ fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
 5:  9928ceefe211 <  -:  ------------ fsverity: don't allow setting DAX file attribute on fsverity files
 6:  8f866da8730c <  -:  ------------ fsverity: hoist statx reporting of fs-verity flag
 7:  d93e466c36fd =  1:  b04517813858 xfs: introduce fsverity on-disk changes
 8:  4bcf1275fa38 =  2:  217a30d22c06 xfs: don't allow to enable DAX on fs-verity sealed inode
 9:  082d5f39ae5a =  3:  ac5bfd8422db xfs: disable direct read path for fs-verity files
10:  21b92f51fd5e =  4:  7a55ff638ffd xfs: don't report dio_mem_align and dio_offset_align for fsverity files
11:  929a7172c341 !  5:  252fd0205997 xfs: handle fsverity I/O in write/read path
    @@ Commit message
         Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/Makefile ##
    -@@ fs/xfs/Makefile: xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
    - xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
    - xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
    - xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
    -+xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
    - 
    - # notify failure
    - ifeq ($(CONFIG_MEMORY_FAILURE),y)
    +@@ fs/xfs/Makefile: xfs-y				+= $(addprefix libxfs/, \
    + 				   xfs_trans_resv.o \
    + 				   xfs_trans_space.o \
    + 				   xfs_types.o \
    ++				   xfs_verity.o \
    + 				   )
    + # xfs_rtbitmap is shared with libxfs
    + xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
     
      ## fs/xfs/libxfs/xfs_bmap.c ##
     @@
      #include "xfs_inode_util.h"
      #include "xfs_rtgroup.h"
      #include "xfs_zone_alloc.h"
    -+#include "xfs_fsverity.h"
    -+#include <linux/fsverity.h>
    ++#include "xfs_verity.h"
      
      struct kmem_cache		*xfs_bmap_intent_cache;
      
    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmapi_convert_one_delalloc(
      	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
      				xfs_iomap_inode_sequence(ip, flags));
     
    + ## fs/xfs/libxfs/xfs_verity.c (new) ##
    +@@
    ++// SPDX-License-Identifier: GPL-2.0
    ++/*
    ++ * Copyright (C) 2026 Red Hat, Inc.
    ++ */
    ++#include "xfs_platform.h"
    ++#include "xfs_fs.h"
    ++#include "xfs_shared.h"
    ++#include "xfs_format.h"
    ++#include "xfs_log_format.h"
    ++#include "xfs_trans_resv.h"
    ++#include "xfs_mount.h"
    ++#include "xfs_inode.h"
    ++#include "xfs_verity.h"
    ++
    ++loff_t
    ++xfs_fsverity_metadata_offset(
    ++	const struct xfs_inode	*ip)
    ++{
    ++	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
    ++}
    +
    + ## fs/xfs/libxfs/xfs_verity.h (new) ##
    +@@
    ++// SPDX-License-Identifier: GPL-2.0
    ++/*
    ++ * Copyright (C) 2026 Red Hat, Inc.
    ++ */
    ++#ifndef __XFS_VERITY_H__
    ++#define __XFS_VERITY_H__
    ++
    ++#include "xfs_platform.h"
    ++
    ++loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
    ++
    ++#endif	/* __XFS_VERITY_H__ */
    +
      ## fs/xfs/xfs_aops.c ##
     @@
      #include "xfs_ioend.h"
    @@ fs/xfs/xfs_aops.c: xfs_vm_writepages(
      }
      
     
    - ## fs/xfs/xfs_fsverity.c (new) ##
    -@@
    -+// SPDX-License-Identifier: GPL-2.0
    -+/*
    -+ * Copyright (C) 2026 Red Hat, Inc.
    -+ */
    -+#include "xfs_platform.h"
    -+#include "xfs_fs.h"
    -+#include "xfs_shared.h"
    -+#include "xfs_format.h"
    -+#include "xfs_log_format.h"
    -+#include "xfs_trans_resv.h"
    -+#include "xfs_mount.h"
    -+#include "xfs_inode.h"
    -+#include "xfs_fsverity.h"
    -+#include <linux/fsverity.h>
    -+#include <linux/iomap.h>
    -+
    -+loff_t
    -+xfs_fsverity_metadata_offset(
    -+	const struct xfs_inode	*ip)
    -+{
    -+	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
    -+}
    -
    - ## fs/xfs/xfs_fsverity.h (new) ##
    -@@
    -+// SPDX-License-Identifier: GPL-2.0
    -+/*
    -+ * Copyright (C) 2026 Red Hat, Inc.
    -+ */
    -+#ifndef __XFS_FSVERITY_H__
    -+#define __XFS_FSVERITY_H__
    -+
    -+#include "xfs_platform.h"
    -+
    -+#ifdef CONFIG_FS_VERITY
    -+loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
    -+#else
    -+static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
    -+{
    -+	WARN_ON_ONCE(1);
    -+	return ULLONG_MAX;
    -+}
    -+#endif	/* CONFIG_FS_VERITY */
    -+
    -+#endif	/* __XFS_FSVERITY_H__ */
    -
      ## fs/xfs/xfs_inode.h ##
     @@ fs/xfs/xfs_inode.h: static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
       */
    @@ fs/xfs/xfs_iomap.c
      #include "xfs_rtbitmap.h"
      #include "xfs_icache.h"
      #include "xfs_zone_alloc.h"
    -+#include "xfs_fsverity.h"
    ++#include "xfs_verity.h"
     +#include <linux/fsverity.h>
      
      #define XFS_ALLOC_ALIGN(mp, off) \
    @@ fs/xfs/xfs_iomap.c: xfs_zoned_direct_write_iomap_begin(
      	return 0;
      }
      
    +@@ fs/xfs/xfs_iomap.c: xfs_zoned_fill_srcmap(
    + 	xfs_fileoff_t		offset_fsb,
    + 	xfs_fileoff_t		*end_fsb,
    + 	unsigned		flags,
    +-	struct iomap		*srcmap)
    ++	struct iomap		*srcmap,
    ++	u16			iomap_flags)
    + {
    + 	struct xfs_bmbt_irec	smap;
    + 	struct xfs_iext_cursor	scur;
    +@@ fs/xfs/xfs_iomap.c: xfs_zoned_fill_srcmap(
    + 	 */
    + 	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
    + 	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
    +-	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
    ++	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, iomap_flags,
    + 			xfs_iomap_inode_sequence(ip, 0));
    + }
    + 
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
      	loff_t			count,
      	unsigned		flags,
    @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
      	xfs_filblks_t		count_fsb;
      	xfs_extlen_t		indlen;
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    - 				smap.br_startoff + smap.br_blockcount);
    - 			xfs_trim_extent(&smap, offset_fsb,
    - 					end_fsb - offset_fsb);
    --			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
    -+			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags,
    -+					iomap_flags,
    - 					xfs_iomap_inode_sequence(ip, 0));
    - 			if (error)
    - 				goto out_unlock;
    + 	    !IS_ALIGNED(offset + count, mp->m_sb.sb_blocksize) ||
    + 	    (flags & IOMAP_ZERO)) {
    + 		error = xfs_zoned_fill_srcmap(ip, offset_fsb, &end_fsb, flags,
    +-				srcmap);
    ++				srcmap, iomap_flags);
    + 		if (error)
    + 			goto out_unlock;
    + 	}
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
      	if (!ip->i_cowfp)
      		xfs_ifork_init_cow(ip);
12:  db144b392a91 !  6:  aea6b162458f xfs: use read ioend for fsverity data verification
    @@ Commit message
     
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
     
    + ## fs/xfs/Makefile ##
    +@@ fs/xfs/Makefile: xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
    + xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
    + xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
    + xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
    ++xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
    + 
    + # notify failure
    + ifeq ($(CONFIG_MEMORY_FAILURE),y)
    +
      ## fs/xfs/xfs_aops.c ##
    -@@
    - #include "xfs_zone_alloc.h"
    - #include "xfs_rtgroup.h"
    - #include "xfs_fsverity.h"
    -+#include <linux/fsverity.h>
    - 
    - struct xfs_writepage_ctx {
    - 	struct iomap_writepage_ctx ctx;
     @@ fs/xfs/xfs_aops.c: xfs_bio_submit_read(
      {
      	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
    @@ fs/xfs/xfs_file.c: xfs_dio_read_bounce_submit_io(
      
      static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
     
    - ## fs/xfs/xfs_fsverity.c ##
    + ## fs/xfs/xfs_fsverity.c (new) ##
     @@
    - #include <linux/fsverity.h>
    - #include <linux/iomap.h>
    - 
    ++// SPDX-License-Identifier: GPL-2.0
    ++/*
    ++ * Copyright (C) 2026 Red Hat, Inc.
    ++ */
    ++#include "xfs_platform.h"
    ++#include "xfs_fs.h"
    ++#include "xfs_shared.h"
    ++#include "xfs_format.h"
    ++#include "xfs_log_format.h"
    ++#include "xfs_trans_resv.h"
    ++#include "xfs_mount.h"
    ++#include "xfs_inode.h"
    ++#include "xfs_fsverity.h"
    ++#include <linux/fsverity.h>
    ++#include <linux/iomap.h>
    ++
     +struct kmem_cache *xfs_fsverity_ioend_cache;
     +mempool_t xfs_fsverity_ioend_pool;
     +
    @@ fs/xfs/xfs_fsverity.c
     +{
     +	mempool_exit(&xfs_fsverity_ioend_pool);
     +}
    -+
    - loff_t
    - xfs_fsverity_metadata_offset(
    - 	const struct xfs_inode	*ip)
    - {
    - 	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
    - }
     +
     +bool
     +xfs_fsverity_is_file_data(
    @@ fs/xfs/xfs_fsverity.c
     +			offset < xfs_fsverity_metadata_offset(ip);
     +}
     
    - ## fs/xfs/xfs_fsverity.h ##
    + ## fs/xfs/xfs_fsverity.h (new) ##
     @@
    - #define __XFS_FSVERITY_H__
    - 
    - #include "xfs_platform.h"
    ++// SPDX-License-Identifier: GPL-2.0
    ++/*
    ++ * Copyright (C) 2026 Red Hat, Inc.
    ++ */
    ++#ifndef __XFS_FSVERITY_H__
    ++#define __XFS_FSVERITY_H__
    ++
    ++#include "xfs_platform.h"
    ++#include "xfs_verity.h"
     +#include <linux/iomap.h>
     +#include <linux/mempool.h>
    - 
    - #ifdef CONFIG_FS_VERITY
    ++
    ++#ifdef CONFIG_FS_VERITY
     +int xfs_fsverity_init(void);
     +void xfs_fsverity_exit(void);
    - loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
     +bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
    - #else
    ++#else
     +static inline int xfs_fsverity_init(void)
     +{
     +	return 0;
    @@ fs/xfs/xfs_fsverity.h
     +static inline void xfs_fsverity_exit(void)
     +{
     +}
    - static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
    - {
    - 	WARN_ON_ONCE(1);
    - 	return ULLONG_MAX;
    - }
     +static inline bool xfs_fsverity_is_file_data(const struct xfs_inode *ip,
     +					    loff_t offset)
     +{
     +	return false;
     +}
    - #endif	/* CONFIG_FS_VERITY */
    - 
    ++#endif	/* CONFIG_FS_VERITY */
    ++
     +struct xfs_fsverity_ioend {
     +	struct iomap_ioend	*ioend;
     +	struct work_struct	work;
    @@ fs/xfs/xfs_fsverity.h
     +extern struct kmem_cache *xfs_fsverity_ioend_cache;
     +extern mempool_t xfs_fsverity_ioend_pool;
     +
    - #endif	/* __XFS_FSVERITY_H__ */
    ++#endif	/* __XFS_FSVERITY_H__ */
     
      ## fs/xfs/xfs_ioend.c ##
     @@
13:  5f00c1287b5e =  7:  234329f5df02 xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
14:  9a82d542d940 =  8:  502c28c54708 xfs: don't remove written extents past EOF on fsverity inodes
15:  420fb1a97664 !  9:  00a5a23c1b4a xfs: add fs-verity support
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	int			error;
     +
     +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
    ++	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
    ++
     +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
     +	if (error) {
     +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
     +		return error;
     +	}
     +
    -+	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
    -+
     +	xfs_ilock(ip, XFS_ILOCK_EXCL);
     +	xfs_trans_ijoin(tp, ip, 0);
     +
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     
      ## fs/xfs/xfs_fsverity.h ##
     @@
    - 
      #include "xfs_platform.h"
    + #include "xfs_verity.h"
      #include <linux/iomap.h>
     +#include <linux/fsverity.h>
      #include <linux/mempool.h>
    @@ fs/xfs/xfs_fsverity.h
     +extern const struct fsverity_operations xfs_fsverity_ops;
      int xfs_fsverity_init(void);
      void xfs_fsverity_exit(void);
    - loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
    + bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
     
      ## fs/xfs/xfs_message.c ##
     @@ fs/xfs/xfs_message.c: xfs_warn_experimental(
16:  00314b4a38e2 = 10:  e6c2e7ef30ae xfs: initialize fs-verity on file open
17:  d37e9d9a991e = 11:  015c18cfb5a4 xfs: add fs-verity ioctls
18:  c21e90b7ac09 = 12:  37b40dc83dff xfs: advertise fs-verity being available on filesystem
19:  6efa9e6690ee ! 13:  f4f2f6cb1db0 xfs: check and repair the verity inode flag state
    @@ fs/xfs/scrub/inode_repair.c: xrep_dinode_core(
      	error = xchk_trans_alloc(sc, 0);
      	if (error)
      		return error;
    -@@ fs/xfs/scrub/inode_repair.c: xrep_inode_unlinked(
    - 	return 0;
    - }
    +@@ fs/xfs/scrub/inode_repair.c: xrep_inode_reset_dquots(
    + # define xrep_inode_reset_dquots(sc)		(0)
    + #endif
      
     +/*
     + * If this file is a fsverity file, xchk_prepare_iscrub or xrep_dinode_core
20:  e01d0c1aa284 = 14:  d7502ab4649b xfs: introduce health state for corrupted fsverity metadata
21:  0ebd5899bc53 = 15:  2181d0402e98 xfs: enable ro-compat fs-verity flag
-- 
2.54.0

