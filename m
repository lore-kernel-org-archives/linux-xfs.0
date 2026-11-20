Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190295;
	b=Y+VWLQxAJSMU8MUl5HXWags/HwG57dre5FY9fG0vXk/VpYFuZLo1x8x1YrGjOs3jkl79
	 xNMjJEf1XL7qDZh55ZTbpZh25VBc4+3OSfF13Zc9yE712VDVphX8HoF4ruU3bPb3JAGK/
	 6V3Uc9cfPnCrEvA+6DYqp0ndfnMAMDD9tejalXCbvDtLZl+OAnDvlIp5pWFQwy3qSD/7p
	 7/tclsECMYEH8m6kX5mEl5JqNmGuNqV7KHvxl//4s0ySZBie/DVAHsVVb6D94pSzOEI6q
	 AzKYesCOlfgInVtYITBsiPuh9UEa5vUsQ7wdIlGzqYI7s2Cc92Ec/65/riy9mAQ7Ysw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TWS2pLdpge8ciSGdt5mWmJIYXeN+FVIeVTRaV1wlC2A=;
	b=cjPsAusC8zxTnh1mvJ099J7Xm657v0TZE+b3PuUfiivWWH7xlfNJJDDgM/yEVKEYgqLf
	 ThlnzX5QtOLW2JSX0G7KyHLDx7pwP58NoYHlgeVBAZpHpucQtlTLcXfxVSSAoMTBCQ1+G
	 ceo6blRtKysSAiDyVN1V3h84AiB04uUnwpMyKhrCChL1M9hasJKCqJxsaZnU8FdyGoOxP
	 fKLuStd/3VrXt3YeI+T3CzO2kA0vaCdWSsxgYUoLMIHi+pmgHK4Dd2POGPYtHLPr6Ah28
	 RwTDW+Yjv1/TxBVO0PzC+/NRMezls/D/gaKP31F+LXQZme+HASZV0q7dVOLUGHSdE4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPl7iJv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8354606A339;
	Fri, 20 Nov 2026 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPl7iJv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B15E1F000C4;
	Fri, 20 Nov 2026 15:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190295;
	bh=TWS2pLdpge8ciSGdt5mWmJIYXeN+FVIeVTRaV1wlC2A=;
	h=From:To:Cc:Subject:Date;
	b=LPl7iJv+de4nG7rPo5ETiVV5Db0FqhW2UIc85xaR4SfkzqRI//NlwjjTXBdHJQexz
	 OUVg+SYkTGvC/5b/Rk03zcdbuJN/yh8BSjNb0Z1E1zp3A63ruC7F8MLa12LNIg5Pn9
	 nm0ecrvOZ+3o0VkFN4bBZUW+JL6m5D9pE54LZdnusmyJD5WeFLucAmqy372KkkxVNa
	 jx1hQAJ0NAXxlEn9Pk45pjNoOVZHPiFzgt0jRQDMtVwXrr+jYp4Uu48EKF4MA51cGo
	 IhL/W8J4hfXwAjQcHBR7oZx6B9U7kLSZLA76etVxjjP0iLp9K74ngWSVDcNTTf0sQz
	 /FaVpn7x5wPrQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com
Subject: [PATCH v19 00/15] fs-verity support for XFS with post EOF merkle tree
Date: Fri, 20 Nov 2026 16:57:34 +0100
Message-ID: <20261120155752.192025-1-aalbersh@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

This is next revision of fsverity for XFS. Changes:
- Add guard to forbid use on Zoned devices
- Add a guard against using with LBS (compound pages no-go for fsverity)
- move IOMAP_F_FSVERITY to xfs_bmbt_to_iomap()
- Use I_VERITY_BUILDING instead of XFS inode flag
- Add guard against DAX during fsverity enable
- Change XFS_FSVERITY_LARGEST_FILE to macro for 32-bit kernel check
- Forbid opening too large fsverity files on 32-bit kernels
- xfs_free_eofblocks() doesn't depend on I_VERITY (disk flag instead)
- Keep EOF cleanup tag on inode if fsverity build failed
- Invalidate past EOF page cache in scrub on corrupted inodes
- Remove past EOF extents in scrub on corrupted inodes

Patches without review:
[PATCH v19 05/15] xfs: handle fsverity I/O in write/read path
[PATCH v19 09/15] xfs: add fs-verity support
[PATCH v19 13/15] xfs: check and repair the verity inode flag state

The RO_COMPAT with CONFIG_FS_VERITY=n should be fine as fsverity inode
won't open (this is same for all fs).

This series based on v7.4-rc3 and my series adding I_VERITY_BUILDING [1]

1: https://lore.kernel.org/linux-xfs/20261120155032.187246-1-aalbersh@kernel.org

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=fsverity

xfsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git/log/?h=fsverity

xfstests:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfstests-dev.git/log/?h=fsverity

v18:
https://lore.kernel.org/fsverity/20261102144147.2393369-1-aalbersh@kernel.org/T/#t

v17:
https://lore.kernel.org/fsverity/20261002223705.2175542-1-aalbersh@kernel.org/T/#u

v16:
https://lore.kernel.org/fsverity/arJC542mXklAeswE@aalbersh-thinkpadx1carbongen13.rmtcz.csb/T/#t

v15:
https://lore.kernel.org/fsverity/20260817070240.GA17371@lst.de/T/#t

To: ebiggers@kernel.org
To: hch@lst.de
To: Carlos Maiolino <cem@kernel.org>
To: fsverity@lists.linux.dev
To: linux-xfs@vger.kernel.org

Cc: linux-fsdevel@vger.kernel.org
Cc: david@fromorbit.com

---
Changes in v19:
- Add guard to forbid use on Zoned devices
- Add a guard against using with LBS (compound pages no-go for fsverity)
- move IOMAP_F_FSVERITY to xfs_bmbt_to_iomap()
- Use I_VERITY_BUILDING instead of XFS inode flag
- Add guard against DAX during fsverity enable
- Change XFS_FSVERITY_LARGEST_FILE to macro for 32-bit kernel check
- Forbid opening too large fsverity files on 32-bit kernels
- xfs_free_eofblocks() doesn't depend on I_VERITY (disk flag instead)
- Keep EOF cleanup tag on inode if fsverity build failed
- Invalidate past EOF page cache in scrub on corrupted inodes
- Remove past EOF extents in scrub on corrupted inodes
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
 fs/xfs/libxfs/xfs_bmap.c       |  26 +-
 fs/xfs/libxfs/xfs_bmap.h       |   6 +-
 fs/xfs/libxfs/xfs_format.h     |  31 +-
 fs/xfs/libxfs/xfs_fs.h         |   2 +
 fs/xfs/libxfs/xfs_health.h     |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |  19 ++
 fs/xfs/libxfs/xfs_inode_util.c |   5 +-
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/libxfs/xfs_verity.c     |  20 ++
 fs/xfs/libxfs/xfs_verity.h     |  13 +
 fs/xfs/scrub/common.c          |  53 ++++
 fs/xfs/scrub/common.h          |   2 +
 fs/xfs/scrub/inode.c           |  22 ++
 fs/xfs/scrub/inode_repair.c    |  49 ++++
 fs/xfs/xfs_aops.c              |  19 +-
 fs/xfs/xfs_bmap_util.c         |  32 ++-
 fs/xfs/xfs_file.c              |  71 +++--
 fs/xfs/xfs_fsverity.c          | 509 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h          |  42 +++
 fs/xfs/xfs_health.c            |   1 +
 fs/xfs/xfs_icache.c            |  11 +-
 fs/xfs/xfs_ioctl.c             |  33 +++
 fs/xfs/xfs_ioend.c             |  53 +++-
 fs/xfs/xfs_ioend.h             |   4 +-
 fs/xfs/xfs_iomap.c             |  61 ++--
 fs/xfs/xfs_iomap.h             |   5 +-
 fs/xfs/xfs_iops.c              |  20 +-
 fs/xfs/xfs_message.c           |   4 +
 fs/xfs/xfs_message.h           |   1 +
 fs/xfs/xfs_mount.h             |   4 +
 fs/xfs/xfs_pnfs.c              |   2 +-
 fs/xfs/xfs_super.c             |  32 ++-
 33 files changed, 1093 insertions(+), 69 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_verity.c
 create mode 100644 fs/xfs/libxfs/xfs_verity.h
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

Range-diff against v18:
 1:  78f9766b0f03 !  1:  ca9aa48fa04b xfs: introduce fsverity on-disk changes
    @@ fs/xfs/libxfs/xfs_format.h: struct xfs_acl {
      #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
      
     +/*
    -+ * At maximum of 8 levels with 128 hashes per block (32 bytes SHA-256) maximum
    -+ * tree size is ((128^8 − 1)/(128 − 1)) = 567*10^12 blocks. This should fit in
    -+ * 53 bits address space.
    -+ *
    -+ * At this Merkle tree size we can cover 295EB large file. This is much larger
    -+ * than the currently supported file size.
    -+ *
    -+ * For sha512 the largest file we can cover ends at 1 << 50 offset, this is also
    -+ * good.
    ++ * fs-verity stores the Merkle tree in the data fork past EOF, so the file data
    ++ * blocks and the tree blocks share the inode's xfs_fileoff_t address space.
    ++ * Cap a verity file at half of the addressable file-offset range (in filesystem
    ++ * blocks) so the Merkle tree always fits in the other half.
     + */
    -+#define XFS_FSVERITY_LARGEST_FILE	((loff_t)1ULL << 53)
    ++#define XFS_FSVERITY_LARGEST_FILE_FSB(mp) \
    ++	(XFS_B_TO_FSBT((mp), MAX_LFS_FILESIZE) >> 1)
     +
     +/*
     + * Alignment of the fsverity metadata placement. This is largest supported PAGE
 2:  8617a78e7332 =  2:  a019dc4ec4b8 xfs: don't allow to enable DAX on fs-verity sealed inode
 3:  a4cb44a90ad7 !  3:  b8f1466cf632 xfs: disable direct read path for fs-verity files
    @@ fs/xfs/xfs_file.c: xfs_file_dio_read(
     +		return xfs_file_buffered_read(iocb, to);
     +	}
      	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
    - 		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
    + 		ret = iomap_dio_rw(iocb, to, xfs_read_iomap_next,
      				&xfs_dio_read_bounce_ops, 0, NULL, 0);
     @@ fs/xfs/xfs_file.c: xfs_file_dax_read(
      	struct kiocb		*iocb,
 4:  91dc30941faf !  4:  d7810bcef90a xfs: don't report dio_mem_align and dio_offset_align for fsverity files
    @@ Commit message
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Acked-by: Eric Biggers <ebiggers@kernel.org>
         Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_iops.c ##
     @@
    @@ fs/xfs/xfs_iops.c: xfs_report_dioalign(
      
      	stat->result_mask |= STATX_DIOALIGN | STATX_DIO_READ_ALIGN;
     +
    ++	/*
    ++	 * The STATX_DIOALIGN | STATX_DIO_READ_ALIGN flags are used to
    ++	 * explicitly report if DIO is supported or not. They can not indicate
    ++	 * that fallback to the buffered IO is used for fsverity.
    ++	 *
    ++	 * Return zero alignment values which also mean that DIO is not
    ++	 * supported on this file, see statx(2).
    ++	 */
     +	if (fsverity_active(VFS_I(ip)))
     +		return;
     +
 5:  b1afe722c692 !  5:  30fa010febff xfs: handle fsverity I/O in write/read path
    @@ Commit message
         treat holes in the tree as request to synthesize tree blocks and hole
         after descriptor as end of the fsverity region.
     
    -    Introduce a new inode flag meaning that merkle tree is being build on
    -    the inode.
    -
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    -    Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
    -    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/Makefile ##
     @@ fs/xfs/Makefile: xfs-y				+= $(addprefix libxfs/, \
    @@ fs/xfs/Makefile: xfs-y				+= $(addprefix libxfs/, \
      xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
     
      ## fs/xfs/libxfs/xfs_bmap.c ##
    -@@
    - #include "xfs_inode_util.h"
    - #include "xfs_rtgroup.h"
    - #include "xfs_zone_alloc.h"
    -+#include "xfs_verity.h"
    - 
    - struct kmem_cache		*xfs_bmap_intent_cache;
    - 
     @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmapi_convert_one_delalloc(
      	 * the extent.  Just return the real extent at this offset.
      	 */
      	if (!isnullstartblock(bma.got.br_startblock)) {
    -+		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
    -+		    offset >= xfs_fsverity_metadata_offset(ip))
    -+			flags |= IOMAP_F_FSVERITY;
    - 		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
    +-		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
    ++		xfs_bmbt_to_iomap(ip, iomap, &bma.got, offset, 0, flags,
      				xfs_iomap_inode_sequence(ip, flags));
      		if (seq)
    + 			*seq = READ_ONCE(ifp->if_seq);
     @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmapi_convert_one_delalloc(
    - 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
      	XFS_STATS_INC(mp, xs_xstrat_quick);
      
    -+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
    -+	    offset >= xfs_fsverity_metadata_offset(ip))
    -+		flags |= IOMAP_F_FSVERITY;
    -+
      	ASSERT(!isnullstartblock(bma.got.br_startblock));
    - 	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
    +-	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
    ++	xfs_bmbt_to_iomap(ip, iomap, &bma.got, offset, 0, flags,
      				xfs_iomap_inode_sequence(ip, flags));
    + 	if (seq)
    + 		*seq = READ_ONCE(ifp->if_seq);
     
      ## fs/xfs/libxfs/xfs_verity.c (new) ##
     @@
    @@ fs/xfs/libxfs/xfs_verity.h (new)
     +#define __XFS_VERITY_H__
     +
     +#include "xfs_platform.h"
    ++#include <linux/fsverity.h>
     +
     +loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
     +
    @@ fs/xfs/xfs_aops.c
      #include "xfs_ioend.h"
      #include "xfs_zone_alloc.h"
      #include "xfs_rtgroup.h"
    -+#include "xfs_fsverity.h"
    ++#include "xfs_verity.h"
      
      struct xfs_writepage_ctx {
      	struct iomap_writepage_ctx ctx;
    -@@ fs/xfs/xfs_aops.c: xfs_map_blocks(
    - 	int			retries = 0;
    - 	int			error = 0;
    - 	unsigned int		*seq;
    -+	unsigned int		iomap_flags = 0;
    - 
    - 	if (xfs_is_shutdown(mp))
    - 		return -EIO;
    - 
    - 	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
    - 
    -+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    -+		iomap_flags |= IOMAP_F_FSVERITY;
    -+
    - 	/*
    - 	 * COW fork blocks can overlap data fork blocks even if the blocks
    - 	 * aren't shared.  COW I/O always takes precedent, so we must always
     @@ fs/xfs/xfs_aops.c: xfs_map_blocks(
      	    isnullstartblock(imap.br_startblock))
      		goto allocate_blocks;
      
     -	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
    -+	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags,
    ++	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, offset, 0, 0,
     +			  XFS_WPC(wpc)->data_seq);
      	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
      	return 0;
      allocate_blocks:
    -@@ fs/xfs/xfs_aops.c: xfs_zoned_map_blocks(
    - 	xfs_filblks_t		count_fsb;
    - 	struct xfs_bmbt_irec	imap, del;
    - 	struct xfs_iext_cursor	icur;
    -+	u16			iomap_flags = 0;
    - 
    - 	if (xfs_is_shutdown(mp))
    - 		return -EIO;
    - 
    - 	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
    - 
    -+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    -+		iomap_flags |= IOMAP_F_FSVERITY;
    -+
    - 	/*
    - 	 * All dirty data must be covered by delalloc extents.  But truncate can
    - 	 * remove delalloc extents underneath us or reduce their size.
     @@ fs/xfs/xfs_aops.c: xfs_zoned_map_blocks(
      		imap.br_startblock = HOLESTARTBLOCK;
      		imap.br_state = XFS_EXT_NORM;
      		xfs_iunlock(ip, XFS_ILOCK_EXCL);
     -		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, 0);
    -+		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags, 0);
    ++		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, offset, 0, 0, 0);
      		return 0;
      	}
      	end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
    -@@ fs/xfs/xfs_aops.c: xfs_zoned_map_blocks(
    - 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
    - 
    - 	xfs_iomap_set_anon_write(ip, &wpc->iomap, offset,
    --			XFS_FSB_TO_B(mp, count_fsb));
    -+			XFS_FSB_TO_B(mp, count_fsb), iomap_flags);
    - 	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
    - 	return 0;
    - }
    -@@ fs/xfs/xfs_aops.c: static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
    - 	.writeback_submit	= xfs_zoned_writeback_submit,
    - };
    - 
    -+static int
    -+xfs_iomap_writepages(
    -+	struct xfs_inode		*ip,
    -+	struct iomap_writepage_ctx	*ctx)
    -+{
    -+	/*
    -+	 * Writeback does not work for folios past EOF, let it know that
    -+	 * I/O happens for fsverity metadata and this restriction need
    -+	 * to be skipped
    -+	 */
    -+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    -+		ctx->iomap.flags |= IOMAP_F_FSVERITY;
    -+
    -+	return iomap_writepages(ctx);
    -+}
    -+
    - STATIC int
    - xfs_vm_writepages(
    - 	struct address_space	*mapping,
    -@@ fs/xfs/xfs_aops.c: xfs_vm_writepages(
    - 		};
    - 		int				error;
    - 
    --		error = iomap_writepages(&xc.ctx);
    -+		error = xfs_iomap_writepages(ip, &xc.ctx);
    - 		if (xc.open_zone)
    - 			xfs_open_zone_put(xc.open_zone);
    - 		return error;
    -@@ fs/xfs/xfs_aops.c: xfs_vm_writepages(
    - 			},
    - 		};
    - 
    --		return iomap_writepages(&wpc.ctx);
    -+		return xfs_iomap_writepages(ip, &wpc.ctx);
    - 	}
    - }
    - 
    -
    - ## fs/xfs/xfs_inode.h ##
    -@@ fs/xfs/xfs_inode.h: static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
    -  */
    - #define XFS_IREMAPPING		(1U << 15)
    - 
    -+/*
    -+ * fs-verity's Merkle tree is under construction. The file is read-only, the
    -+ * only writes happening are for the fsverity metadata.
    -+ */
    -+#define XFS_VERITY_CONSTRUCTION	(1U << 16)
    -+
    - /* All inode state flags related to inode reclaim. */
    - #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
    - 				 XFS_IRECLAIM | \
     
      ## fs/xfs/xfs_iomap.c ##
     @@
    @@ fs/xfs/xfs_iomap.c
      
      #define XFS_ALLOC_ALIGN(mp, off) \
      	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
    -@@ fs/xfs/xfs_iomap.c: xfs_direct_write_iomap_begin(
    - 	if (flags & IOMAP_ATOMIC)
    - 		iomap_flags |= IOMAP_F_ATOMIC_BIO;
    +@@ fs/xfs/xfs_iomap.c: xfs_alert_fsblock_zero(
    + 	return -EFSCORRUPTED;
    + }
      
    -+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    -+		iomap_flags |= IOMAP_F_FSVERITY;
    ++static bool
    ++xfs_iomap_is_fsverity_metadata(
    ++	struct xfs_inode	*ip,
    ++	loff_t			offset)
    ++{
    ++	return offset >= xfs_fsverity_metadata_offset(ip) &&
    ++	       (fsverity_is_building(VFS_I(ip)) || fsverity_active(VFS_I(ip)));
    ++}
    ++
    + u64
    + xfs_iomap_inode_sequence(
    + 	struct xfs_inode	*ip,
    +@@ fs/xfs/xfs_iomap.c: xfs_bmbt_to_iomap(
    + 	struct xfs_inode	*ip,
    + 	struct iomap		*iomap,
    + 	struct xfs_bmbt_irec	*imap,
    ++	loff_t			offset,
    + 	unsigned int		mapping_flags,
    + 	u16			iomap_flags,
    + 	u64			sequence_cookie)
    +@@ fs/xfs/xfs_iomap.c: xfs_bmbt_to_iomap(
    + 			iomap->flags |= IOMAP_F_INTEGRITY;
    + 	}
    + 
    ++	/*
    ++	 * Tell iomap when this I/O covers fs-verity metadata so it handles size
    ++	 * updates and post-EOF folios correctly.  The attr fork uses a separate
    ++	 * offset space, so exclude it.
    ++	 */
    ++	if (!(iomap_flags & IOMAP_F_XATTR) &&
    ++	    xfs_iomap_is_fsverity_metadata(ip, offset))
    ++		iomap->flags |= IOMAP_F_FSVERITY;
     +
      	/*
    - 	 * COW writes may allocate delalloc space or convert unwritten COW
    - 	 * extents, so we need to make sure to take the lock exclusively here.
    + 	 * If the inode is dirty for datasync purposes, let iomap know so it
    + 	 * doesn't elide the IO completion journal flushes on O_DSYNC IO.
    +@@ fs/xfs/xfs_iomap.c: xfs_direct_write_iomap_begin(
    + 	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
    + 	xfs_iunlock(ip, lockmode);
    + 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
    +-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
    ++	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags, iomap_flags,
    ++			seq);
    + 
    + allocate_blocks:
    + 	error = -EAGAIN;
    +@@ fs/xfs/xfs_iomap.c: xfs_direct_write_iomap_begin(
    + 		return error;
    + 
    + 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
    +-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
    ++	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags,
    + 				 iomap_flags | IOMAP_F_NEW, seq);
    + 
    + out_found_cow:
     @@ fs/xfs/xfs_iomap.c: xfs_direct_write_iomap_begin(
      	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
      	if (imap.br_startblock != HOLESTARTBLOCK) {
      		seq = xfs_iomap_inode_sequence(ip, 0);
     -		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
    -+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags,
    -+				iomap_flags & IOMAP_F_FSVERITY, seq);
    ++		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, offset, flags,
    ++				0, seq);
      		if (error)
      			goto out_unlock;
      	}
    -@@ fs/xfs/xfs_iomap.c: xfs_zoned_direct_write_iomap_begin(
    - 			return error;
    - 	}
    + 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
    + 	xfs_iunlock(ip, lockmode);
    +-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
    ++	return xfs_bmbt_to_iomap(ip, iomap, &cmap, offset, flags,
    ++			IOMAP_F_SHARED, seq);
      
    --	xfs_iomap_set_anon_write(ip, iomap, offset, length);
    -+	xfs_iomap_set_anon_write(ip, iomap, offset, length, 0);
    - 	return 0;
    - }
    + out_unlock:
    + 	if (lockmode)
    +@@ fs/xfs/xfs_iomap.c: xfs_atomic_write_cow_iomap_begin(
    + 	trace_xfs_iomap_found(ip, offset, length, XFS_COW_FORK, &cmap);
    + 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
    + 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
    +-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
    ++	return xfs_bmbt_to_iomap(ip, iomap, &cmap, offset, flags,
    ++			IOMAP_F_SHARED, seq);
      
    -@@ fs/xfs/xfs_iomap.c: xfs_zoned_fill_srcmap(
    - 	xfs_fileoff_t		offset_fsb,
    - 	xfs_fileoff_t		*end_fsb,
    - 	unsigned		flags,
    --	struct iomap		*srcmap)
    -+	struct iomap		*srcmap,
    -+	u16			iomap_flags)
    - {
    - 	struct xfs_bmbt_irec	smap;
    - 	struct xfs_iext_cursor	scur;
    + convert_delay:
    + 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_fill_srcmap(
      	 */
      	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
      	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
     -	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
    -+	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, iomap_flags,
    - 			xfs_iomap_inode_sequence(ip, 0));
    +-			xfs_iomap_inode_sequence(ip, 0));
    ++	return xfs_bmbt_to_iomap(ip, srcmap, &smap,
    ++			XFS_FSB_TO_B(ip->i_mount, offset_fsb), flags,
    ++			0, xfs_iomap_inode_sequence(ip, 0));
      }
      
    -@@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    - 	loff_t			count,
    - 	unsigned		flags,
    - 	struct iomap		*iomap,
    --	struct iomap		*srcmap)
    -+	struct iomap		*srcmap,
    -+	u16			iomap_flags)
    - {
    - 	struct iomap_iter	*iter =
    - 		container_of(iomap, struct iomap_iter, iomap);
    -@@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    - 	struct xfs_mount	*mp = ip->i_mount;
    - 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
    - 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
    --	u16			iomap_flags = IOMAP_F_SHARED;
    - 	unsigned int		lockmode = XFS_ILOCK_EXCL;
    - 	xfs_filblks_t		count_fsb;
    - 	xfs_extlen_t		indlen;
    -@@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    - 	    !IS_ALIGNED(offset + count, mp->m_sb.sb_blocksize) ||
    - 	    (flags & IOMAP_ZERO)) {
    - 		error = xfs_zoned_fill_srcmap(ip, offset_fsb, &end_fsb, flags,
    --				srcmap);
    -+				srcmap, iomap_flags);
    - 		if (error)
    - 			goto out_unlock;
    - 	}
    -@@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    - 	if (!ip->i_cowfp)
    - 		xfs_ifork_init_cow(ip);
    - 
    -+	iomap_flags |= IOMAP_F_SHARED;
    -+
    - 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
    - 		got.br_startoff = end_fsb;
    - 	if (got.br_startoff <= offset_fsb) {
    + static int
    +@@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    + 	trace_xfs_iomap_alloc(ip, offset, XFS_FSB_TO_B(mp, count_fsb),
    + 			XFS_COW_FORK, &got);
    + done:
    +-	error = xfs_bmbt_to_iomap(ip, iomap, &got, flags, iomap_flags,
    ++	error = xfs_bmbt_to_iomap(ip, iomap, &got, offset, flags, iomap_flags,
    + 			xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED));
    + out_unlock:
    + 	xfs_iunlock(ip, lockmode);
     @@ fs/xfs/xfs_iomap.c: xfs_buffered_write_iomap_begin(
    - 	if (xfs_is_shutdown(mp))
    - 		return -EIO;
    + found_imap:
    + 	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
    + 	xfs_iunlock(ip, lockmode);
    +-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
    ++	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags, iomap_flags,
    ++			seq);
      
    -+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    -+		iomap_flags |= IOMAP_F_FSVERITY;
    -+
    - 	if (xfs_is_zoned_inode(ip))
    - 		return xfs_zoned_buffered_write_iomap_begin(inode, offset,
    --				count, flags, iomap, srcmap);
    -+				count, flags, iomap, srcmap, iomap_flags);
    - 
    - 	/* we can't use delayed allocations when using extent size hints */
    - 	if (xfs_get_extsz_hint(ip))
    + convert_delay:
    + 	xfs_iunlock(ip, lockmode);
     @@ fs/xfs/xfs_iomap.c: xfs_buffered_write_iomap_begin(
      
      found_cow:
      	if (imap.br_startoff <= offset_fsb) {
     -		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0,
    -+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags,
    -+				iomap_flags & IOMAP_F_FSVERITY,
    - 				xfs_iomap_inode_sequence(ip, 0));
    +-				xfs_iomap_inode_sequence(ip, 0));
    ++		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, offset, flags,
    ++				0, xfs_iomap_inode_sequence(ip, 0));
      		if (error)
      			goto out_unlock;
    -@@ fs/xfs/xfs_iomap.c: xfs_read_iomap_begin(
    - 	bool			shared = false;
    - 	unsigned int		lockmode = XFS_ILOCK_SHARED;
    - 	u64			seq;
    -+	unsigned int		iomap_flags = 0;
    + 	} else {
    +@@ fs/xfs/xfs_iomap.c: xfs_buffered_write_iomap_begin(
    + 	iomap_flags |= IOMAP_F_SHARED;
    + 	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
    + 	xfs_iunlock(ip, lockmode);
    +-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, iomap_flags, seq);
    ++	return xfs_bmbt_to_iomap(ip, iomap, &cmap, offset, flags, iomap_flags,
    ++			seq);
      
    - 	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)));
    - 
    - 	if (xfs_is_shutdown(mp))
    - 		return -EIO;
    - 
    -+	if (fsverity_active(inode) &&
    -+	    (offset >= xfs_fsverity_metadata_offset(ip)))
    -+		iomap_flags |= IOMAP_F_FSVERITY;
    -+
    - 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
    - 	if (error)
    - 		return error;
    + out_unlock:
    + 	xfs_iunlock(ip, lockmode);
     @@ fs/xfs/xfs_iomap.c: xfs_read_iomap_begin(
      	if (error)
      		return error;
      	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
     -	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
    --				 shared ? IOMAP_F_SHARED : 0, seq);
    -+	iomap_flags |= shared ? IOMAP_F_SHARED : 0;
    -+
    -+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
    ++	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags,
    + 				 shared ? IOMAP_F_SHARED : 0, seq);
      }
      
    - static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
    +@@ fs/xfs/xfs_iomap.c: xfs_seek_iomap_begin(
    + 			end_fsb = min(end_fsb, data_fsb);
    + 		xfs_trim_extent(&cmap, offset_fsb, end_fsb - offset_fsb);
    + 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
    +-		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
    ++		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, offset, flags,
    + 				IOMAP_F_SHARED, seq);
    + 		/*
    + 		 * This is a COW extent, so we must probe the page cache
    +@@ fs/xfs/xfs_iomap.c: xfs_seek_iomap_begin(
    + done:
    + 	seq = xfs_iomap_inode_sequence(ip, 0);
    + 	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
    +-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
    ++	error = xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags, 0, seq);
    + out_unlock:
    + 	xfs_iunlock(ip, lockmode);
    + 	return error;
    +@@ fs/xfs/xfs_iomap.c: xfs_xattr_iomap_begin(
    + 	if (error)
    + 		return error;
    + 	ASSERT(nimaps);
    +-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
    ++	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags,
    ++			IOMAP_F_XATTR, seq);
    + }
    + 
    + DEFINE_IOMAP_ITER_NEXT(xfs_xattr_iomap_next, xfs_xattr_iomap_begin);
     
      ## fs/xfs/xfs_iomap.h ##
    -@@ fs/xfs/xfs_iomap.h: xfs_iomap_set_anon_write(
    - 	struct xfs_inode		*ip,
    - 	struct iomap			*iomap,
    - 	loff_t				offset,
    --	loff_t				length)
    -+	loff_t				length,
    -+	u16				iomap_flags)
    - {
    - 	iomap->type = IOMAP_MAPPED;
    - 	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
    - 	iomap->offset = offset;
    - 	iomap->length = length;
    --	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
    -+	iomap->flags = iomap_flags | IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
    - 	if (bdev_has_integrity_csum(iomap->bdev))
    - 		iomap->flags |= IOMAP_F_INTEGRITY;
    - }
    +@@ fs/xfs/xfs_iomap.h: xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
    + 
    + u64 xfs_iomap_inode_sequence(struct xfs_inode *ip, u16 iomap_flags);
    + int xfs_bmbt_to_iomap(struct xfs_inode *ip, struct iomap *iomap,
    +-		struct xfs_bmbt_irec *imap, unsigned int mapping_flags,
    +-		u16 iomap_flags, u64 sequence_cookie);
    ++		struct xfs_bmbt_irec *imap, loff_t offset,
    ++		unsigned int mapping_flags, u16 iomap_flags,
    ++		u64 sequence_cookie);
    + 
    + int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
    + 		struct xfs_zone_alloc_ctx *ac, bool *did_zero);
    +
    + ## fs/xfs/xfs_pnfs.c ##
    +@@ fs/xfs/xfs_pnfs.c: xfs_fs_map_blocks(
    + 	}
    + 	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
    + 
    +-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
    ++	error = xfs_bmbt_to_iomap(ip, iomap, &imap, offset, 0, 0, seq);
    + 	*device_generation = mp->m_generation;
    + 	return error;
    + out_unlock:
 6:  b3a0bdad384a !  6:  fe7a17bb65c6 xfs: use read ioend for fsverity data verification
    @@ Commit message
         data that needs verification.
     
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/Makefile ##
     @@ fs/xfs/Makefile: xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
    @@ fs/xfs/Makefile: xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
      ifeq ($(CONFIG_MEMORY_FAILURE),y)
     
      ## fs/xfs/xfs_aops.c ##
    +@@
    + #include "xfs_zone_alloc.h"
    + #include "xfs_rtgroup.h"
    + #include "xfs_verity.h"
    ++#include "xfs_fsverity.h"
    + 
    + struct xfs_writepage_ctx {
    + 	struct iomap_writepage_ctx ctx;
     @@ fs/xfs/xfs_aops.c: xfs_bio_submit_read(
      {
      	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
    @@ fs/xfs/xfs_aops.c: xfs_vm_read_folio(
      
     -	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
     +	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
    - 	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
    + 	iomap_read_folio(xfs_read_iomap_next, &ctx, NULL);
      	return 0;
      }
     @@ fs/xfs/xfs_aops.c: xfs_vm_readahead(
    @@ fs/xfs/xfs_aops.c: xfs_vm_readahead(
      
     -	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
     +	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
    - 	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
    + 	iomap_readahead(xfs_read_iomap_next, &ctx, NULL);
      }
      
     
    @@ fs/xfs/xfs_ioend.h: static inline bool xfs_ioend_is_append(struct iomap_ioend *i
      #endif /* __XFS_IOEND_H */
     
      ## fs/xfs/xfs_super.c ##
    +@@
    + #include "xfs_rtalloc.h"
    + #include "xfs_zone_alloc.h"
    + #include "xfs_healthmon.h"
    ++#include "xfs_fsverity.h"
    + #include "scrub/stats.h"
    + #include "scrub/rcbag_btree.h"
    + 
     @@ fs/xfs/xfs_super.c: xfs_init_caches(void)
      	if (!xfs_parent_args_cache)
      		goto out_destroy_xmi_cache;
 7:  e41f43b1f4dd !  7:  c428bb5ceba4 xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
    @@ Commit message
         Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
     
      ## fs/xfs/libxfs/xfs_bmap.c ##
    +@@ fs/xfs/libxfs/xfs_bmap.c: __xfs_bunmapi(
    + 	ASSERT(len > 0);
    + 	ASSERT(nexts >= 0);
    + 
    ++	/*
    ++	 * XFS_BMAPI_UNWRITTEN is only used by fs-verity to drop unwritten
    ++	 * blocks past EOF while keeping written ones (fsverity metadata).
    ++	 *
    ++	 * The XFS_BMAPI_UNWRITTEN could not be used with realtime inodes with
    ++	 * realtime extent larger than 1 filesystem block. This is because the
    ++	 * realtime inode with larger extents could have EOF in the middle of
    ++	 * the extent. Removing these unwritten extent beyond EOF could lead to
    ++	 * removal of data before EOF.
    ++	 *
    ++	 * fs-verity is not allowed to be enabled on realtime files whose
    ++	 * extent size is larger than 1.
    ++	 */
    ++	ASSERT(!((flags & XFS_BMAPI_UNWRITTEN) &&
    ++		 xfs_inode_has_bigrtalloc(ip)));
    ++
    + 	error = xfs_iread_extents(tp, ip, whichfork);
    + 	if (error)
    + 		return error;
     @@ fs/xfs/libxfs/xfs_bmap.c: __xfs_bunmapi(
      		if (del.br_startoff + del.br_blockcount > end + 1)
      			del.br_blockcount = end + 1 - del.br_startoff;
    @@ fs/xfs/libxfs/xfs_bmap.c: __xfs_bunmapi(
     
      ## fs/xfs/libxfs/xfs_bmap.h ##
     @@ fs/xfs/libxfs/xfs_bmap.h: struct xfs_bmalloca {
    - /* Try to align allocations to the extent size hint */
    - #define XFS_BMAPI_EXTSZALIGN	(1u << 11)
    +  */
    + #define XFS_BMAPI_CONVERT_ONLY	(1u << 12)
      
     +/* Process unwritten extents only. Used for unmapping */
    -+#define XFS_BMAPI_UNWRITTEN	(1u << 12)
    ++#define XFS_BMAPI_UNWRITTEN	(1u << 13)
     +
      #define XFS_BMAPI_FLAGS \
      	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
      	{ XFS_BMAPI_METADATA,	"METADATA" }, \
     @@ fs/xfs/libxfs/xfs_bmap.h: struct xfs_bmalloca {
    - 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
      	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
      	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
    --	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
    -+	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
    + 	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
    +-	{ XFS_BMAPI_CONVERT_ONLY,	"CONVERT_ONLY" }
    ++	{ XFS_BMAPI_CONVERT_ONLY,	"CONVERT_ONLY" }, \
     +	{ XFS_BMAPI_UNWRITTEN,	"UNWRITTEN" }
      
      
 8:  8a033752cc2e !  8:  f62ffd5f8991 xfs: don't remove written extents past EOF on fsverity inodes
    @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
     +	/*
     +	 * Don't clean fsverity inodes as they already have been cleaned up and
     +	 * are read-only. Skip inodes which have merkle tree being built, the
    -+	 * merkle tree is written beyond EOF
    ++	 * merkle tree is written beyond EOF. Skip inodes which have
    ++	 * XFS_DIFLAG2_VERITY in case this kernel has fsverity disabled.
     +	 */
     +	if (fsverity_active(VFS_IC(ip)) ||
    -+	    xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    ++	    fsverity_is_building(VFS_I(ip)) ||
    ++	    ip->i_diflags2 & XFS_DIFLAG2_VERITY)
     +		return false;
     +
      	/*
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      	struct xfs_mount	*mp = ip->i_mount;
      	int			error;
     +	int			bmapi_flags = XFS_BMAPI_NODISCARD;
    -+	bool			has_verity =
    -+			ip->i_diflags2 & XFS_DIFLAG2_VERITY;
    ++	bool			verity = fsverity_is_building(VFS_I(ip));
      
      	/* Attach the dquots to the inode up front. */
      	error = xfs_qm_dqattach(ip);
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      	 */
     -	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
     +	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND) ||
    -+			has_verity) {
    ++			verity) {
      		if (ip->i_delayed_blks) {
      			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
      				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      		}
      		xfs_inode_clear_eofblocks_tag(ip);
     -		return 0;
    -+		if (!has_verity)
    ++		if (!verity)
     +			return 0;
      	}
      
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
     +	 * While fs-verity writes metadata after EOF, it can leave unwritten
     +	 * preallocations.  Clear all that out.
     +	 */
    -+	if (has_verity)
    ++	if (verity)
     +		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
     +
      	/*
    @@ fs/xfs/xfs_bmap_util.c: xfs_free_eofblocks(
      	if (error)
      		goto err_cancel;
      
    +
    + ## fs/xfs/xfs_icache.c ##
    +@@
    + #include "xfs_da_format.h"
    + #include "xfs_dir2.h"
    + #include "xfs_metafile.h"
    +-
    ++#include <linux/fsverity.h>
    + #include <linux/iversion.h>
    + 
    + /* Radix tree tags for incore inode tree. */
    +@@ fs/xfs/xfs_icache.c: xfs_inode_free_eofblocks(
    + 	if (xfs_can_free_eofblocks(ip))
    + 		return xfs_free_eofblocks(ip);
    + 
    ++	/*
    ++	 * The above xfs_free_eofblocks() is skipped for inodes with fsverity
    ++	 * tree is being built. However, we don't want to clear EOF tag in this
    ++	 * case. If building the tree fails, inode will have EOF blocks which
    ++	 * needs removal.
    ++	 */
    ++	if (fsverity_is_building(VFS_IC(ip)))
    ++		return 0;
    ++
    + 	/* inode could be preallocated */
    + 	trace_xfs_inode_free_eofblocks_invalid(ip);
    + 	xfs_inode_clear_eofblocks_tag(ip);
 9:  f528fd0329d9 !  9:  5f6f04fde6e4 xfs: add fs-verity support
    @@ Commit message
         locate descriptor.
     
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    -    Reviewed-by: Christoph Hellwig <hch@lst.de>
    +
    + ## fs/xfs/libxfs/xfs_inode_buf.c ##
    +@@ fs/xfs/libxfs/xfs_inode_buf.c: xfs_dinode_verify(
    + 			return __this_address;
    + 		if (!S_ISREG(mode))
    + 			return __this_address;
    ++		/*
    ++		 * fs-verity stores the Merkle tree past EOF, so it cannot
    ++		 * coexist with a realtime allocation unit larger than a single
    ++		 * filesystem block. This is because we remove any unwritten
    ++		 * extents beyond EOF for fs-verity inodes. The realtime inode
    ++		 * with larger extents could have EOF in the middle of the
    ++		 * extent. Enabling fsverity on such inode could lead to removal
    ++		 * of data before EOF.
    ++		 */
    ++		if ((flags & XFS_DIFLAG_REALTIME) && mp->m_sb.sb_rextsize > 1)
    ++			return __this_address;
    + 	}
    + 
    + 	if (xfs_has_zoned(mp) &&
     
      ## fs/xfs/xfs_fsverity.c ##
     @@
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	uint32_t		blocksize = i_blocksize(VFS_I(ip));
     +	xfs_fileoff_t		last_block_offset;
     +
    ++	/*
    ++	 * fs-verity cannot be used when the filesystem block size exceeds the
    ++	 * page size, as the Merkle tree folios are compound and PG_checked is
    ++	 * not supported on compound folios.  Reject such inodes so that they
    ++	 * cannot be opened and read as verity files.
    ++	 */
    ++	if (mp->m_sb.sb_blocksize > PAGE_SIZE)
    ++		return -EOPNOTSUPP;
    ++
     +	xfs_ilock(ip, XFS_ILOCK_EXCL);
     +	/*
     +	 * Serialize reading of inode->i_flags with xfs_scrub clearing of this
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	if (is_empty)
     +		return -ENODATA;
     +
    ++	/*
    ++	 * Make sure we can open large file on a 32-bit kernel
    ++	 */
    ++	if (rec.br_startoff + rec.br_blockcount >
    ++			XFS_B_TO_FSB(mp, inode->i_sb->s_maxbytes))
    ++		return -EFBIG;
    ++
     +	last_block_offset =
     +		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
     +	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +			round_up(desc_end + sizeof(desc_size_disk), blksize) -
     +			sizeof(desc_size_disk);
     +
    ++	if (desc_size_pos + sizeof(desc_size_disk) > inode->i_sb->s_maxbytes)
    ++		return -EFBIG;
    ++
     +	error = iomap_fsverity_write(file, desc_size_pos, sizeof(__be32),
     +			(const void *)&desc_size_disk,
    -+			&xfs_buffered_write_iomap_ops,
    ++			xfs_buffered_write_iomap_next,
     +			&xfs_iomap_write_ops);
     +	if (error)
     +		return error;
     +
     +	return iomap_fsverity_write(file, desc_pos, desc_size, desc,
    -+			&xfs_buffered_write_iomap_ops,
    ++			xfs_buffered_write_iomap_next,
     +			&xfs_iomap_write_ops);
     +}
     +
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +		return -EINVAL;
     +
     +	/*
    ++	 * fs-verity tracks verified Merkle tree pages using PG_checked, which
    ++	 * is only valid on single-page (non-compound) folios.  When the
    ++	 * filesystem block size is larger than the page size, the page cache
    ++	 * enforces a minimum folio order > 0, so all Merkle tree folios are
    ++	 * compound. fs-verity cannot be used on such filesystems.
    ++	 */
    ++	if (ip->i_mount->m_sb.sb_blocksize > PAGE_SIZE)
    ++		return -EOPNOTSUPP;
    ++
    ++	/*
    ++	 * fs-verity doesn't work on zoned
    ++	 */
    ++	if (xfs_is_zoned_inode(ip))
    ++		return -EOPNOTSUPP;
    ++
    ++	/*
     +	 * fs-verity stores the Merkle tree past EOF in units of the filesystem
     +	 * block size, so it cannot support realtime files whose allocation unit
     +	 * (extent size) is larger than the block size.
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	if (xfs_inode_has_bigrtalloc(ip))
     +		return -EINVAL;
     +
    -+	if (inode->i_size > XFS_FSVERITY_LARGEST_FILE)
    ++	if (XFS_B_TO_FSB(ip->i_mount, inode->i_size) >
    ++			XFS_FSVERITY_LARGEST_FILE_FSB(ip->i_mount))
     +		return -EFBIG;
     +
     +	/*
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	if (error)
     +		return error;
     +
    -+	if (xfs_iflags_test_and_set(ip, XFS_VERITY_CONSTRUCTION))
    -+		return -EBUSY;
    -+
     +	error = xfs_qm_dqattach(ip);
     +	if (error)
    -+		goto out_clear;
    ++		return error;
     +
    -+	error = xfs_fsverity_delete_metadata(ip);
    -+	if (error)
    -+		goto out_clear;
    -+	return error;
    -+out_clear:
    -+	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
    -+	return error;
    ++	return xfs_fsverity_delete_metadata(ip);
     +}
     +
     +/*
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	struct xfs_mount	*mp = ip->i_mount;
     +	struct xfs_trans	*tp;
     +	int			error = 0;
    ++	int			error2;
     +	loff_t			range_start = xfs_fsverity_metadata_offset(ip);
     +
     +	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +
     +	/*
     +	 * Wait for Merkle tree get written to disk before setting on-disk inode
    -+	 * flag and clearing XFS_VERITY_CONSTRUCTION
    ++	 * flag and clearing I_VERITY_BUILDING
     +	 */
     +	error = filemap_write_and_wait_range(inode->i_mapping, range_start,
     +			LLONG_MAX);
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +		goto out;
     +
     +	/*
    -+	 * Set fsverity inode flag
    -+	 */
    -+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
    -+			0, 0, false, &tp);
    -+	if (error)
    -+		goto out;
    -+
    -+	/*
    -+	 * Ensure that we've persisted the verity information before we enable
    -+	 * it on the inode and tell the caller we have sealed the inode.
    -+	 */
    -+	ip->i_diflags2 |= XFS_DIFLAG2_VERITY;
    -+
    -+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
    -+	xfs_trans_set_sync(tp);
    -+
    -+	error = xfs_trans_commit(tp);
    -+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
    -+	if (error)
    -+		goto out;
    -+
    -+	inode_set_flags(inode, S_VERITY, S_VERITY);
    -+
    -+	/*
     +	 * Proactively remove unwritten extents left by COW preallocations and
     +	 * write preallocation in the merkle tree holes and past descriptor,
     +	 * and any delayed preallocations
     +	 */
     +	error = xfs_free_eofblocks(ip);
    ++	if (error)
    ++		goto out;
    ++
    ++	/*
    ++	 * Set fsverity inode flag
    ++	 */
    ++	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
    ++			0, 0, false, &tp);
    ++	if (error)
    ++		goto out;
    ++
    ++	/*
    ++	 * Ensure that we've persisted the verity information before we enable
    ++	 * it on the inode and tell the caller we have sealed the inode.
    ++	 */
    ++	ip->i_diflags2 |= XFS_DIFLAG2_VERITY;
    ++
    ++	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
    ++	xfs_trans_set_sync(tp);
    ++
    ++	error = xfs_trans_commit(tp);
    ++	xfs_iunlock(ip, XFS_ILOCK_EXCL);
    ++	if (error)
    ++		goto out;
    ++
    ++	inode_set_flags(inode, S_VERITY, S_VERITY);
    ++	return error;
    ++
     +out:
    -+	if (error) {
    -+		int	error2;
    -+
    -+		error2 = xfs_fsverity_reset_inode(ip);
    -+		if (error2)
    -+			xfs_alert(ip->i_mount,
    ++	error2 = xfs_fsverity_reset_inode(ip);
    ++	if (error2)
    ++		xfs_alert(ip->i_mount,
     +"ino 0x%llx failed to clean up new fsverity metadata, err %d",
    -+					I_INO(ip), error2);
    -+	}
    ++				I_INO(ip), error2);
     +
    -+	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
     +	return error;
     +}
     +
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +		return 0;
     +
     +	return iomap_fsverity_write(file, position, size, buf,
    -+			&xfs_buffered_write_iomap_ops,
    ++			xfs_buffered_write_iomap_next,
     +			&xfs_iomap_write_ops);
     +}
     +
    @@ fs/xfs/xfs_fsverity.h
      void xfs_fsverity_exit(void);
      bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
     
    + ## fs/xfs/xfs_ioctl.c ##
    +@@ fs/xfs/xfs_ioctl.c: xfs_ioctl_setattr_xflags(
    + 		if (xfs_inode_has_filedata(ip))
    + 			return -EINVAL;
    + 
    ++		/*
    ++		 * fs-verity is incompatible with a realtime allocation unit
    ++		 * larger than a single filesystem block, so don't let a file be
    ++		 * converted to realtime while verity is being enabled.
    ++		 */
    ++		if (fsverity_is_building(VFS_IC(ip)))
    ++			return -EINVAL;
    ++
    + 		/*
    + 		 * If S_DAX is enabled on this file, we can only switch the
    + 		 * device if both support fsdax.  We can't update S_DAX because
    +@@ fs/xfs/xfs_ioctl.c: xfs_ioctl_setattr_xflags(
    + 			return -EINVAL;
    + 	}
    + 
    ++	/*
    ++	 * fs-verity is incompatible with DAX, and xfs_fsverity_begin_enable()
    ++	 * verified the inode was not DAX under the inode lock.  That lock is
    ++	 * dropped while the Merkle tree is built, so reject enabling DAX while
    ++	 * verity is being enabled.
    ++	 */
    ++	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
    ++	    !(ip->i_diflags2 & XFS_DIFLAG2_DAX) &&
    ++	    fsverity_is_building(VFS_IC(ip)))
    ++		return -EINVAL;
    ++
    + 	if (rtflag) {
    + 		/* If realtime flag is set then must have realtime device */
    + 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
    +
      ## fs/xfs/xfs_message.c ##
     @@ fs/xfs/xfs_message.c: xfs_warn_experimental(
      			.opstate	= XFS_OPSTATE_WARNED_LARP,
10:  827908e045f1 = 10:  9206c4a644f1 xfs: initialize fs-verity on file open
11:  d13b62d8ce52 = 11:  856483dbd534 xfs: add fs-verity ioctls
12:  69d2733475a1 = 12:  31f7e8a2669e xfs: advertise fs-verity being available on filesystem
13:  3b40328cc8e2 ! 13:  dfabd8df8c89 xfs: check and repair the verity inode flag state
    @@ Commit message
     
         If an inode has the incore verity iflag set, make sure that we can
         actually activate fsverity on that inode.  If activation fails due to
    -    a fsverity metadata validation error, clear the flag.  The usage model
    -    for fsverity requires that any program that cares about verity state is
    -    required to call statx/getflags to check that the flag is set after
    -    opening the file, so clearing the flag will not compromise that model.
    +    a fsverity metadata validation error, clear the flag and delete
    +    fs-verity metadata. The usage model for fsverity requires that any
    +    program that cares about verity state is required to call statx/getflags
    +    to check that the flag is set after opening the file, so clearing the
    +    flag will not compromise that model.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
    -    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/scrub/common.c ##
     @@
    @@ fs/xfs/scrub/common.h: int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_agi
     
      ## fs/xfs/scrub/inode.c ##
     @@ fs/xfs/scrub/inode.c: xchk_prepare_iscrub(
    + 	struct xfs_scrub	*sc)
    + {
    + 	int			error;
    ++	struct xfs_inode	*ip = sc->ip;
      
      	xchk_ilock(sc, XFS_IOLOCK_EXCL);
      
     +	error = xchk_inode_setup_verity(sc);
     +	if (error)
     +		return error;
    ++
    ++	/*
    ++	 * If we're going to repair a file whose fsverity descriptor cannot be
    ++	 * activated, drop the stale Merkle tree folios. Once the
    ++	 * post-EOF Merkle extents are freed during repair, those uptodate
    ++	 * folios would otherwise sit over a hole and could be exposed as file
    ++	 * data by a later extending write or truncate.
    ++	 *
    ++	 * The lock would be unlocked by global scrub machinery.
    ++	 */
    ++	if (xchk_could_repair(sc) && xchk_inode_verity_broken(ip)) {
    ++		xchk_ilock(sc, XFS_MMAPLOCK_EXCL);
    ++		truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
    ++	}
     +
      	error = xchk_trans_alloc(sc, 0);
      	if (error)
    @@ fs/xfs/scrub/inode_repair.c: xrep_inode_reset_dquots(
     +/*
     + * If this file is a fsverity file, xchk_prepare_iscrub or xrep_dinode_core
     + * should have activated it.  If it's still not active, then there's something
    -+ * wrong with the verity descriptor and we should turn it off.
    ++ * wrong with the verity descriptor, so turn verity off and free the orphaned
    ++ * Merkle tree that XFS keeps in extents beyond EOF.
     + */
     +STATIC int
     +xrep_inode_verity(
     +	struct xfs_scrub	*sc)
     +{
     +	struct inode		*inode = VFS_I(sc->ip);
    ++	struct xfs_mount	*mp = sc->mp;
    ++	int			error;
     +
    -+	if (xchk_inode_verity_broken(sc->ip)) {
    -+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_VERITY;
    -+		inode_set_flags(inode, 0, S_VERITY);
    ++	if (!xchk_inode_verity_broken(sc->ip))
    ++		return 0;
     +
    -+		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
    -+	}
    ++	/*
    ++	 * The fsverity descriptor cannot be activated, so disable verity and
    ++	 * free the Merkle tree, which XFS stores in beyond EOF. The stale
    ++	 * Merkle tree page cache was already dropped during scrub setup.
    ++	 */
    ++	error = xfs_bunmapi_range(&sc->tp, sc->ip, 0,
    ++			XFS_B_TO_FSB(mp, XFS_ISIZE(sc->ip)), XFS_MAX_FILEOFF);
    ++	if (error)
    ++		return error;
     +
    ++	sc->ip->i_diflags2 &= ~XFS_DIFLAG2_VERITY;
    ++	inode_set_flags(inode, 0, S_VERITY);
    ++
    ++	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
     +	return 0;
     +}
     +
14:  7ae522f75fbd ! 14:  6e4fdcf643b6 xfs: introduce health state for corrupted fsverity metadata
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_get_descriptor(
      		return -ENODATA;
     +	}
      
    + 	/*
    + 	 * Make sure we can open large file on a 32-bit kernel
    +@@ fs/xfs/xfs_fsverity.c: xfs_fsverity_get_descriptor(
    + 
      	last_block_offset =
      		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
     -	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
15:  e2034d8bdff1 = 15:  28c74513a1bf xfs: enable ro-compat fs-verity flag
-- 
2.54.0

