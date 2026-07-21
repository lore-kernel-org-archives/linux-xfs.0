Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0061E471264;
	Tue, 21 Jul 2026 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659437; cv=none; b=XFsadAd9MrMncmFAnlxyRVVxn7iDdeJdpxnFtNrLz1eM7kO9DiXUHLPngnPD/iZ8LO003KSQnQb8ZWDrnXzO//p0X+d41NIZiM1dapFPOz5tfkrfnveRdaPRsNSCASfg1+yVMyKr5CUqNKLwcy7qc0LbSGpcr7nwpcqr+O1EdjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659437; c=relaxed/simple;
	bh=qruYO+xrnvnlIWK6NwndnkNoKmusbRgZfo3e5Z9CQh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C88hUIEie+g/ZdMIlCSry028nwO4HrQVOg5cxmfiuL+feRpN527v5god1S8uAyRnAkxvVSA2l6BdwecQfrNk5B+v2o6tAeQTq4EJTfj6oQel9oi1AAdrHVQw8b1KXRACsOjMz4ei8vYVlWVxZ7AQ1YbYd22i6xRaWp6w1rhFvmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C35unPAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C35unPAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E661F00A3A;
	Tue, 21 Jul 2026 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659434;
	bh=RY2Vrd2PN1R4vzJ9wqK/4bS3livW0wYL3iU5ncXuVMI=;
	h=From:To:Cc:Subject:Date;
	b=C35unPAAOYRtgq0huq4G15Zs90gvR6wYK9UOYOHuu/RIHCcoipsv2UJG8Q0au4bvB
	 0RyPgNJ8tEuRk6gLtpvaWS29QINZKvMuCtPoBH7x3pU+8rSatHM/GI/z+gC4J9BVkF
	 xaX4xSjaFaEN8qpLIWG8DCGCzlrsHB/1oi8DyzAKEzgqmA4s0iS0jQ/NGtTPoN/2+C
	 TIK1vqYhAb6kvgUMWYHSmoEJY6udkqnfYXKvZ0GmX3Vu8E0ng261ZvwCMl/Ss8RUg5
	 j+U2f6QlN405+64REeXVztMN8+qDhhAoAI/Xosrdw4fJ/kEwcrXD9rtFuVCAS8ZwAr
	 7Nw52isa3Qvmw==
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
Subject: [PATCH v13 00/23] fs-verity support for XFS with post EOF merkle tree
Date: Tue, 21 Jul 2026 20:40:37 +0200
Message-ID: <20260721184346.416657-1-aalbersh@kernel.org>
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

Range-diff with v12 also below.

Patches 5, 6, 7, 8, and 12 are new.

Patches without review:
[PATCH v13 05/23] fsverity: improve flushing performance of
[PATCH v13 06/23] fsverity: don't allow setting DAX file attribute on
[PATCH v13 07/23] fs,fsverity: remove check for fsverity being
[PATCH v13 08/23] fsverity: hoist statx reporting of fs-verity flag
[PATCH v13 11/23] xfs: disable direct read path for fs-verity files
[PATCH v13 12/23] xfs: don't report dio_mem_align and
[PATCH v13 13/23] xfs: handle fsverity I/O in write/read path
[PATCH v13 14/23] xfs: always prioritize fsverity metadata ioends in
[PATCH v13 16/23] xfs: add fs-verity support
[PATCH v13 17/23] xfs: remove unwritten extents after preallocations

This series based on v7.2-rc4

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=fsverity

xfsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git/log/?h=fsverity

xfstests:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfstests-dev.git/log/?h=fsverity

sashiko review:
https://sashiko.dev/#/patchset/20260720090410.3487990-1-aalbersh%40kernel.org

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
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=7

> Should the online scrub and repair utilities also be updated to handle
> XFS_DIFLAG2_VERITY?
> While xfs_dinode_verify() correctly catches invalid verity flags, it appears
> the scrub and repair paths in fs/xfs/scrub/inode_repair.c and
> fs/xfs/scrub/inode.c were not updated.
> If an inode on disk is corrupted with the XFS_DIFLAG2_VERITY bit set when it
> should not be, xfs_dinode_verify() will correctly fail. When online scrub
> attempts to repair this via xrep_dinode_core() calling xrep_dinode_flags(),
> the invalid flag is never cleared because xrep_dinode_flags() lacks the
> clearing logic for XFS_DIFLAG2_VERITY (unlike REFLINK or DAX).
> When the repair finishes and xfs_trans_log_buf() attempts to write the
> repaired inode, xfs_dinode_verify() will trigger again, see the still-present
> invalid verity flag, and reject the write. Can this cause XFS to forcefully
> shut down the filesystem during periodic automated online scrub jobs?

The scrub and repair are updated latter in the series and removes this flag if
fsverity verification of the file fails.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260720090410.3487990-1-aalbersh%40kernel.org?part=8

> This is a pre-existing issue, but does the bitwise operation in
> fs/xfs/scrub/inode_repair.c:xrep_inode_flags() erroneously clear all valid
> flags instead of the junk ones when it uses ~XFS_DIFLAG_ANY and
> ~XFS_DIFLAG2_ANY?
> In xrep_inode_flags(), when an inode has unrecognized flags:
> 	/* Clear junk flags */
> 	if (sc->ip->i_diflags & ~XFS_DIFLAG_ANY)
> 		sc->ip->i_diflags &= ~XFS_DIFLAG_ANY;
> [ ... ]
> 	/* Clear junk flags. */
> 	if (sc->ip->i_diflags2 & ~XFS_DIFLAG2_ANY)
> 		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_ANY;
> Since ~XFS_DIFLAG_ANY and ~XFS_DIFLAG2_ANY evaluate to masks of invalid
> flags, doesn't this operation zero out all legitimate feature flags (like DAX,
> REFLINK, BIGTIME, and now VERITY) while permanently retaining the junk flags
> it intended to remove?
> Could clearing flags like REFLINK on a shared file cause the filesystem to
> overwrite shared blocks directly instead of copying on write, leading to
> severe data corruption?

This seems wrong, it clears invalid flags.

> Since XFS has not yet implemented the fs-verity read verification hooks or
> fsverity_file_open() (which the commit message notes is deferred to a future
> patch), does prematurely mapping XFS_DIFLAG2_VERITY to the VFS S_VERITY flag
> allow bypassing userspace integrity checks?
> Because the read path completely skips Merkle tree verification and
> fsverity_get_info() returns NULL, if an attacker mounts a crafted XFS image
> with the VERITY flag set, wouldn't userspace tools checking STATX_ATTR_VERITY
> be tricked into reading and trusting unverified data?

This is true, but it's fine

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260720090410.3487990-1-aalbersh%40kernel.org?part=11

> If we return early here, dio_offset_align is left as 0. When the legacy
> XFS_IOC_DIOINFO ioctl queries these alignments via vfs_getattr(), it appears
> to blindly use this 0 value:
> fs/xfs/xfs_ioctl.c:xfs_file_ioctl() {
>     case XFS_IOC_DIOINFO: {
>         ...
>         error = vfs_getattr(&filp->f_path, &st, STATX_DIOALIGN, 0);
>         if (error)
>             return error;
>         da.d_mem = roundup(st.dio_mem_align, sizeof(void *));
>         da.d_miniosz = st.dio_offset_align;
>         da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
>         if (copy_to_user(arg, &da, sizeof(da)))
>             return -EFAULT;
>         return 0;
>     }
> }
> Because da.d_miniosz becomes 0, da.d_maxiosz is evaluated as 0 and successfully
> passed to userspace. Could this cause legacy userspace applications expecting
> positive alignment values to crash when performing modulo or division
> calculations?
> Would it make sense for xfs_file_ioctl() to return an error like -ENOTTY or
> -EOPNOTSUPP when direct I/O is unsupported?

This also seems fine, 0 meant unsupported before fsverity.

> As a related getattr issue, does xfs_vn_getattr() need an update to report
> fsverity attributes?
> When populating stat->attributes, xfs_vn_getattr() maps flags like
> XFS_DIFLAG_IMMUTABLE to STATX_ATTR_IMMUTABLE, but it seems to omit checking
> for XFS_DIFLAG2_VERITY and setting STATX_ATTR_VERITY.
> Does this omission prevent userspace utilities like lsattr or fsverity from
> detecting verity protection when querying statx on XFS?

This is valid, updated with a patch to hoist fsverity statx reporting to common
code.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260720090410.3487990-1-aalbersh%40kernel.org?part=12

> Does unconditionally setting IOMAP_F_FSVERITY here (and in
> xfs_iomap_writepages() below) cause a panic on dirty data folios?
> If fsverity is enabled on a file with dirty user data folios in the
> pagecache, writeback will process these folios while
> XFS_VERITY_CONSTRUCTION is active. Because the flag is applied to all
> folios regardless of offset, it can cause a WARN_ON_ONCE to trigger in
> iomap_writeback_handle_eof():
> fs/iomap/buffered-io.c:iomap_writeback_handle_eof() {
>     if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
>         WARN_ON_ONCE(folio_pos(folio) < isize);
>         return true;
>     }
> }
> [ ... ]

There's no dirty data folios when merkle tree gets written. XFS calls
writeback on the whole data range before starting.

> Does this double assignment of wpc->iomap.flags discard IOMAP_F_FSVERITY
> and IOMAP_F_DIRTY?
> It looks like we assign iomap_flags | IOMAP_F_DIRTY but then unconditionally
> overwrite it with IOMAP_F_ANON_WRITE on zoned inodes. This might lead to
> silent writeback failures for fsverity metadata, as generic iomap writeback
> could erroneously skip remaining dirty folios past EOF.
> [ ... ]

This is valid, I haven't noticed there's double assignment.

> Does globally priming the context with IOMAP_F_FSVERITY here break mixed
> data/metadata writeback?
> As mentioned in xfs_map_blocks(), setting this unconditionally across the
> entire writeback context causes iomap_writeback_handle_eof() to evaluate
> WARN_ON_ONCE(folio_pos(folio) < isize) to true for any data folio.
> [ ... ]

No data writeback is happening for fsverity files, everything should be
clean at this point.

> Is IOMAP_F_FSVERITY silently dropped when returning COW extents here?
> When returning a COW extent in xfs_direct_write_iomap_begin(), the
> out_found_cow path calls xfs_bmbt_to_iomap() using a hardcoded
> IOMAP_F_SHARED or 0, discarding the accumulated iomap_flags:
> xfs_direct_write_iomap_begin() {
>     ...
> out_found_cow:
>     if (imap.br_startblock != HOLESTARTBLOCK) {
>         ...
>         error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
>     }
>     ...
>     return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
> }
> If srcmap lacks IOMAP_F_FSVERITY, iomap_block_needs_zeroing() could
> erroneously zero out existing Merkle tree metadata past EOF during fsverity
> construction. The same concern applies to xfs_buffered_write_iomap_begin().
> [ ... ]

I don't think this is the case as either origin file is read-only or
target is writing to new allocation.

> Does passing iomap_flags as an argument drop the initialization of
> IOMAP_F_SHARED for existing COW extents?
> Before this change, iomap_flags was initialized to IOMAP_F_SHARED in
> xfs_zoned_buffered_write_iomap_begin(). Now it is passed in from
> xfs_buffered_write_iomap_begin() initialized to 0.
> If a buffered write on a zoned inode hits an existing COW extent
> (got.br_startoff <= offset_fsb), the code jumps to the done label
> where xfs_bmbt_to_iomap() maps the extent without the shared flag:
> xfs_zoned_buffered_write_iomap_begin() {
>     ...
>     if (got.br_startoff <= offset_fsb) {
>         trace_xfs_reflink_cow_found(ip, &got);
>         goto done;
>     }
>     ...
>     iomap_flags |= (IOMAP_F_NEW | IOMAP_F_SHARED);
>     ...
> done:
>     error = xfs_bmbt_to_iomap(ip, iomap, &got, flags, iomap_flags, ...);
> }
> Could this break copy-on-write invariants and unshare operations?

This is valid, added assignment.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260720090410.3487990-1-aalbersh%40kernel.org?part=13

> Does this multiplexing of fsverity data read and metadata read ioends onto a
> single per-inode work_struct cause a workqueue self-deadlock?
> When the underlying block device has integrity csum support,
> xfs_get_iomap_read_ops() forces fsverity metadata reads to use xfs_end_bio():
> xfs_get_iomap_read_ops() {
>     if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
>             xfs_fsverity_is_file_data(ip, position))
>         return &xfs_iomap_read_ops;
> }
> If a data read and a metadata read on the same file complete concurrently,
> both ioends are appended to ip->i_ioend_list and scheduled via the shared
> ip->i_ioend_work.
> In xfs_end_io(), iomap_sort_ioends() sorts the data read (lower offset)
> before the metadata read. Processing the data read calls
> fsverity_verify_bio(), which synchronously waits for the metadata folio to
> unlock.
> However, the metadata folio is locked by the in-flight metadata read, and
> will only be unlocked when its ioend is processed by iomap_finish_ioends().
> Since the metadata ioend is queued further down the same list, won't the
> worker thread block forever waiting for itself?

Fix by sorting metadata ioends first.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260720090410.3487990-1-aalbersh%40kernel.org?part=14

> Does this logic miss files that are actively constructing their Merkle trees?
> During FS_IOC_ENABLE_VERITY, build_merkle_tree() drops the VFS inode lock
> (XFS_IOLOCK_EXCL) before performing buffered writes past i_size. These writes
> can tag the inode for block garbage collection.
> If xfs_blockgc_worker or a concurrent flush evaluates xfs_can_free_eofblocks()
> during this window, it will invoke xfs_free_eofblocks() because S_VERITY is
> not yet set.
> Could this lead to silent data loss of the Merkle tree blocks by truncating
> them before the verity flag is set? Would checking for
> xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) prevent this regression?

This is valid, fixed

> Is XFS_IS_CORRUPT appropriate for validating data read from the
> unauthenticated data fork?
> The descriptor size is read from the end of the file's data fork. If the disk
> is modified or suffers bit-rot, this condition could evaluate to true.
> Because XFS_IS_CORRUPT triggers internal corruption alerts
> (xfs_corruption_error), it can spam dmesg and panic the kernel if
> xfs_panic_mask is configured.
> Since this is unauthenticated file data and not XFS metadata, xfs_repair
> cannot fix it. Can this simply be a normal range check rather than using
> metadata corruption macros?

This is intentional.

> Does this leave trailing unwritten preallocations past the descriptor?
> fsverity_ioctl_enable() writes the Merkle tree and descriptor via buffered I/O,
> which triggers XFS speculative preallocation (such as EOF preallocation or
> extent size hints).
> Because these unwritten extents are not cancelled here before sealing the
> file, later when xfs_fsverity_get_descriptor() calls xfs_bmap_last_extent(),
> it will find that the end of the last extent includes these trailing unwritten
> blocks.
> This causes the descriptor size read to return zeroes instead of the actual
> size, resulting in an -ERANGE failure and breaking the verity feature for the
> file.
> Should this code remove unwritten preallocations past the descriptor before
> returning?

The extents are canceled in xfs_fsverity_cancel_unwritten().

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260720090410.3487990-1-aalbersh%40kernel.org?part=15

> This isn't a bug introduced by this patch, but looking at the earlier part of
> xfs_fsverity_delete_metadata() in fs/xfs/xfs_fsverity.c:
> 	xfs_ilock(ip, XFS_ILOCK_EXCL);
> 	xfs_trans_ijoin(tp, ip, 0);
> 	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> Could this lock ordering cause an ABBA deadlock?
> If a background writeback thread is flushing dirty folios to disk, it acquires
> the folio lock first, and then xfs_map_blocks() waits to acquire
> XFS_ILOCK_SHARED.
> Concurrently, if a user interrupts the FS_IOC_ENABLE_VERITY ioctl (e.g., via
> SIGINT), the rollback path calls xfs_fsverity_delete_metadata(). This function
> acquires XFS_ILOCK_EXCL first, and then calls truncate_inode_pages(), which
> attempts to lock the same folio held by the writeback thread.
> Does this inversion (XFS_ILOCK -> Folio lock vs Folio lock -> XFS_ILOCK) risk
> hanging both the writeback flusher and the ioctl process?

This is valid, added a lock

--------------------------------------------------------------------------------
 1:  e36baaf10b7c <  -:  ------------ fs-verity support for XFS with post EOF merkle tree
 -:  ------------ >  1:  7b321c0badd4 fs-verity support for XFS with post EOF merkle tree
 2:  ae0ac729dbac =  2:  423cfba80e94 fsverity: report validation errors through fserror to fsnotify
 3:  8542f23822d6 =  3:  222201af793d fsverity: expose ensure_fsverity_info()
 4:  f35ce050d48b !  4:  10e8359b78a6 fsverity: pass digest size and hash of the all-zeroes block to ->write
    @@ Commit message
         Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
         Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
         Acked-by: Eric Biggers <ebiggers@kernel.org>
    +    Acked-by: David Sterba <dsterba@suse.com>

      ## fs/btrfs/verity.c ##
     @@ fs/btrfs/verity.c: static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 5:  90455850d9d4 =  5:  935060e810f0 fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
 6:  308f09618ae7 =  6:  ee0bf7ff0542 fsverity: improve flushing performance of fsverity_fill_zerohash
 7:  d26c08d34716 =  7:  92e026979727 fsverity: don't allow setting DAX file attribute on fsverity files
 8:  6c93f4491e6c =  8:  97d5d4912917 fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
 -:  ------------ >  9:  43a04cc7ec32 fsverity: hoist statx reporting of fs-verity flag
 9:  bc9f3a7b591a ! 10:  e6281ee10ed7 xfs: introduce fsverity on-disk changes
    @@ fs/xfs/libxfs/xfs_format.h: struct xfs_acl {
     + * Alignment of the fsverity metadata placement. This is largest supported PAGE
     + * SIZE for fsverity. This is used to space out data and metadata in page cache.
     + * The spacing is necessary for non-exposure of metadata to userspace and
    -+ * correct merkle tree synethesis in the iomap.
    ++ * correct merkle tree synthesis in the iomap.
     + */
     +#define XFS_FSVERITY_START_ALIGN	(65536)
     +
10:  228250a15e5b = 11:  ee5d12778ef9 xfs: don't allow to enable DAX on fs-verity sealed inode
11:  d0cf7b7ab659 = 12:  9d48956bbca5 xfs: disable direct read path for fs-verity files
12:  ad44db7dbd46 = 13:  ef6da74e5b55 xfs: don't report dio_mem_align and dio_offset_align for fsverity files
13:  4a828733a402 ! 14:  2771bf20cd33 xfs: handle fsverity I/O in write/read path
    @@ fs/xfs/xfs_aops.c: xfs_zoned_map_blocks(

      	wpc->iomap.type = IOMAP_MAPPED;
     -	wpc->iomap.flags = IOMAP_F_DIRTY;
    -+	wpc->iomap.flags = iomap_flags | IOMAP_F_DIRTY;
      	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
      	wpc->iomap.offset = offset;
      	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
    +-	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
    ++	wpc->iomap.flags = iomap_flags | IOMAP_F_ANON_WRITE;
    +
    + 	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
    + 	return 0;
     @@ fs/xfs/xfs_aops.c: static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
      	.writeback_submit	= xfs_zoned_writeback_submit,
      };
    @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
      			if (error)
      				goto out_unlock;
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    - 	got.br_state = XFS_EXT_NORM;
    - 	xfs_bmap_add_extent_hole_delay(ip, XFS_COW_FORK, &icur, &got);
    - 	ac->reserved_blocks -= count_fsb;
    --	iomap_flags |= IOMAP_F_NEW;
    -+	iomap_flags |= (IOMAP_F_NEW | IOMAP_F_SHARED);
    + 	if (!ip->i_cowfp)
    + 		xfs_ifork_init_cow(ip);

    - 	trace_xfs_iomap_alloc(ip, offset, XFS_FSB_TO_B(mp, count_fsb),
    - 			XFS_COW_FORK, &got);
    ++	iomap_flags |= IOMAP_F_SHARED;
    ++
    + 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
    + 		got.br_startoff = end_fsb;
    + 	if (got.br_startoff <= offset_fsb) {
     @@ fs/xfs/xfs_iomap.c: xfs_buffered_write_iomap_begin(
      	if (xfs_is_shutdown(mp))
      		return -EIO;
 -:  ------------ > 15:  fd70b92ffb93 xfs: always prioritize fsverity metadata ioends in ioend completion
14:  14fe33d4dd5f ! 16:  dc69cabdd1c5 xfs: use read ioend for fsverity data verification
    @@ fs/xfs/xfs_aops.c

      struct xfs_writepage_ctx {
      	struct iomap_writepage_ctx ctx;
    -@@ fs/xfs/xfs_aops.c: xfs_end_ioend_write(
    - 	memalloc_nofs_restore(nofs_flag);
    +@@ fs/xfs/xfs_aops.c: xfs_read_ioend_compare(
    + 	return 0;
      }

     +/*
15:  96419b6b1e76 ! 17:  aa91b4a7dc09 xfs: add fs-verity support
    @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
     +	 * Nothing to clean on fsverity inodes as they don't use prealloc and
     +	 * there no delalloc as only written data is fsverity metadata
     +	 */
    -+	if (IS_VERITY(VFS_I(ip)))
    ++	if (IS_VERITY(VFS_I(ip)) ||
    ++	    xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
     +		return false;
     +
      	/*
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	if (error)
     +		return error;
     +
    -+	xfs_ilock(ip, XFS_ILOCK_EXCL);
    -+	xfs_trans_ijoin(tp, ip, 0);
    -+
    ++	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
     +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
    ++	xfs_trans_ijoin(tp, ip, 0);
     +
     +	/*
     +	 * We remove post EOF data, no need to update i_size as fsverity
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +		goto err_cancel;
     +
     +	error = xfs_trans_commit(tp);
    -+	if (error)
    -+		goto out_unlock;
    -+out_unlock:
    -+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
    ++	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
     +	return error;
    -+
     +err_cancel:
     +	xfs_trans_cancel(tp);
    -+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
    ++	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
     +	return error;
     +}
     +
16:  a488a8c9f9c6 = 18:  3d2171c845ae xfs: remove unwritten extents after preallocations in fsverity metadata
17:  81b0f6a6f8f3 = 19:  ec515772b880 xfs: initialize fs-verity on file open
18:  bd9d35559f53 = 20:  0ca349eeac7f xfs: add fs-verity ioctls
19:  873dc8dd4582 = 21:  0e8645a4376d xfs: advertise fs-verity being available on filesystem
20:  afb42c8e4cd4 = 22:  bbcbf3250aaa xfs: check and repair the verity inode flag state
21:  03202b14aef1 = 23:  59a7e2883fde xfs: introduce health state for corrupted fsverity metadata
22:  e53964a4d3e1 = 24:  7c4ef6fe2660 xfs: enable ro-compat fs-verity flag

Andrey Albershteyn (21):
  fsverity: report validation errors through fserror to fsnotify
  fsverity: expose ensure_fsverity_info()
  fsverity: pass digest size and hash of the all-zeroes block to ->write
  fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
  fsverity: improve flushing performance of fsverity_fill_zerohash
  fsverity: don't allow setting DAX file attribute on fsverity files
  fs,fsverity: remove check for fsverity being enabled in
    setattr_prepare()
  fsverity: hoist statx reporting of fs-verity flag
  xfs: introduce fsverity on-disk changes
  xfs: don't allow to enable DAX on fs-verity sealed inode
  xfs: disable direct read path for fs-verity files
  xfs: don't report dio_mem_align and dio_offset_align for fsverity
    files
  xfs: handle fsverity I/O in write/read path
  xfs: always prioritize fsverity metadata ioends in ioend completion
  xfs: use read ioend for fsverity data verification
  xfs: add fs-verity support
  xfs: remove unwritten extents after preallocations in fsverity
    metadata
  xfs: initialize fs-verity on file open
  xfs: add fs-verity ioctls
  xfs: introduce health state for corrupted fsverity metadata
  xfs: enable ro-compat fs-verity flag

Darrick J. Wong (2):
  xfs: advertise fs-verity being available on filesystem
  xfs: check and repair the verity inode flag state

 fs/attr.c                      |   2 +-
 fs/btrfs/inode.c               |   3 -
 fs/btrfs/verity.c              |   6 +-
 fs/ext4/inode.c                |   5 +-
 fs/ext4/verity.c               |  36 +--
 fs/f2fs/file.c                 |   5 +-
 fs/f2fs/verity.c               |  34 +--
 fs/file_attr.c                 |   5 +
 fs/iomap/ioend.c               |   8 +-
 fs/stat.c                      |   6 +-
 fs/verity/enable.c             |   4 +-
 fs/verity/open.c               |  22 +-
 fs/verity/pagecache.c          |  57 +++-
 fs/verity/verify.c             |   4 +
 fs/xfs/Makefile                |   1 +
 fs/xfs/libxfs/xfs_bmap.c       |  11 +
 fs/xfs/libxfs/xfs_format.h     |  35 ++-
 fs/xfs/libxfs/xfs_fs.h         |   2 +
 fs/xfs/libxfs/xfs_health.h     |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |   8 +
 fs/xfs/libxfs/xfs_inode_util.c |   5 +-
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/scrub/common.c          |  55 ++++
 fs/xfs/scrub/common.h          |   2 +
 fs/xfs/scrub/inode.c           |   7 +
 fs/xfs/scrub/inode_repair.c    |  36 +++
 fs/xfs/xfs_aops.c              | 114 ++++++--
 fs/xfs/xfs_bmap_util.c         |   9 +
 fs/xfs/xfs_file.c              |  67 +++--
 fs/xfs/xfs_fsverity.c          | 480 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h          |  28 ++
 fs/xfs/xfs_health.c            |   1 +
 fs/xfs/xfs_inode.h             |   6 +
 fs/xfs/xfs_ioctl.c             |  14 +
 fs/xfs/xfs_iomap.c             |  29 +-
 fs/xfs/xfs_iops.c              |  12 +-
 fs/xfs/xfs_message.c           |   4 +
 fs/xfs/xfs_message.h           |   1 +
 fs/xfs/xfs_mount.h             |   4 +
 fs/xfs/xfs_super.c             |   7 +
 include/linux/fsverity.h       |  10 +-
 include/linux/iomap.h          |   5 +-
 42 files changed, 1024 insertions(+), 134 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

-- 
2.54.0

