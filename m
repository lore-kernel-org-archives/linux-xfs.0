Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B293F3CBE8F;
	Mon, 20 Jul 2026 09:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538296; cv=none; b=OCw0cIRD3PwHP7Y3H/lnrL+J3FXdO8TLl5QbnKLfJkd/Fk3FVa/N7eVTj9yRJnwbJDJqAhldr+VV21fjppBc4MlbpIMH7tB6/tuYlAMsMgjw0eRoMK4bdVPwApvjOn7ZheAU/Yzpt4BTksyF0Ghq1/3bq15DMmeWkGZFC+GzkLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538296; c=relaxed/simple;
	bh=gd3WxBaRQ9yNIJGNh9Vec2emKr0DUqfhyAsEPHXZlZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z7A3m9IaVtWPOHneyRhWxx/Eep9uJZgITnXQL6X1EpNGWwnFEy3JkUOqrnks8bHxbdnt3GuV5I3wIK1J4N9I+NaeNvWJnDoQlXS+xDoSIxxUWBxMsha5bs+eZbdebBJODqCFzMQpxjhQgCB5T5apzPsE60FtGDSPryD2HaOI45s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKnCjr/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKnCjr/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F081F000E9;
	Mon, 20 Jul 2026 09:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538294;
	bh=9y6vqO88Q9FivaUQ8DU2Ezp3Y6e+kCObHy+O9geghSQ=;
	h=From:To:Cc:Subject:Date;
	b=CKnCjr/HMv1sA1VHO0l9LCv0cQBetll2XH9sOl8gQW0kLdG/hCoZ0ENEYtJVp5Jeq
	 QRuZ9JqzalTLpU0cOTljnOJSRjP4q/zQJWbO/3Cttz++PhSdnMKUwmsh82FhnpU83T
	 T86n0w6pydPFoWxNlViyfV/a7dQt+lNDRSE8dsoPIBIhNpgslmfNKgK6dcEPL8g9XL
	 aD2WSpFTap3bRhZO/KiWYrZ486ye+zykH4+ptH9sDDkc9pRiqvAVRnj6MkqiCKciMc
	 3Cs40udIBO/ymtgtZZnHvfudL5us5XDxCd+L+ZkLoBQS7F9eF1QFtkdFzKQmexy+M2
	 VEHrDOy/ilDcw==
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
Subject: [PATCH v12 00/21] fs-verity support for XFS with post EOF merkle tree
Date: Mon, 20 Jul 2026 11:03:28 +0200
Message-ID: <20260720090410.3487990-1-aalbersh@kernel.org>
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

Range-diff with v11 also below.

Patches 5, 6, 7, and 11 are new.

Patches without review:
[PATCH v12 05/21] fsverity: improve flushing performance of
[PATCH v12 06/21] fsverity: don't allow setting DAX file attribute on
[PATCH v12 07/21] fs,fsverity: remove check for fsverity being
[PATCH v12 10/21] xfs: disable direct read path for fs-verity files
[PATCH v12 11/21] xfs: don't report dio_mem_align and
[PATCH v12 12/21] xfs: handle fsverity I/O in write/read path
[PATCH v12 14/21] xfs: add fs-verity support
[PATCH v12 15/21] xfs: remove unwritten extents after preallocations

This series based on v7.2-rc4

kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=fsverity

xfsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfsprogs-dev.git/log/?h=fsverity

xfstests:
https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfstests-dev.git/log/?h=fsverity

sashiko review:
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org

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
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=8

> Does calling fsverity_file_open() here trigger a NULL pointer dereference
> on inode->i_sb->s_vop?
> If a crafted XFS image is mounted containing an inode with the
> XFS_DIFLAG2_VERITY flag set, IS_VERITY(inode) will evaluate to true.
> This triggers the following path:
> xfs_file_open()
>   fsverity_file_open()
>     __fsverity_file_open()
>       fsverity_ensure_verity_info()
>         fsverity_get_descriptor()
> In fsverity_get_descriptor(), there is an unconditional dereference:
> fs/verity/open.c:fsverity_get_descriptor() {
>     ...
>     res = inode->i_sb->s_vop->get_verity_descriptor(inode, NULL, 0);
>     ...
> }
> Since the XFS superblock's s_vop pointer does not appear to be
> initialized in this patch, could this result in a panic when attempting
> to open the file?

This will not show up during bisect, but this is fine to move latter in the
series when s_vop is initialized.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=10

> Does XFS actually fall back to buffered I/O for fsverity files?
> Looking at xfs_file_read_iter() in fs/xfs/xfs_file.c, it doesn't appear
> to check fsverity_active() before routing the read to the direct I/O path:
> fs/xfs/xfs_file.c:xfs_file_read_iter() {
>         ...
>         else if (iocb->ki_flags & IOCB_DIRECT)
>                 ret = xfs_file_dio_read(iocb, to);
>         ...
> }
> If an attacker opens an fs-verity protected file with O_DIRECT, won't this
> bypass the page cache and fsverity_verify_folio() entirely, allowing them
> to read unauthenticated data?
> While this patch correctly zeroes out the alignment fields in statx, it
> doesn't seem to stop an application from issuing an O_DIRECT read anyway.

Again miss-ordered patches, swapped them so fallback patch is first one.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=12

> Will this check fail if the newly allocated metadata extent is merged
> with a preceding data extent?
> Since XFS can aggressively merge contiguous extents, the merged br_startoff
> might become the start of the data extent, making it less than the metadata
> offset.
> If the check fails and IOMAP_F_FSVERITY is omitted, won't the generic iomap
> writeback code see a folio past EOF without the verity flag and discard it,
> causing silent loss of the Merkle tree?

I don't think it's the case. The extent merge could only happen when file size
is exactly 64k and merkle tree extent got allocated in the next physical block.
The delayed extent or unwritten extent merge is not the case as data is written
back before building the tree.

Then, if merge happens the read path doesn't care about this as iomap/xfs read
metadata based on file offset.

The merge could probably happen for merkle tree/descriptor but this is also fine
as XFS gets descriptor based on the last block of the extent.

> Does this face the same extent merging issue as the check above?
> If the new metadata extent merges with adjacent data blocks, the offset
> check will fail and drop the flag.

The same as above.

> Should the source mapping in xfs_zoned_buffered_write_iomap_begin() include
> the IOMAP_F_FSVERITY flag instead of hardcoding 0 for the iomap_flags
> argument?
> Looking at the unaligned write fallback later in this function:
> fs/xfs/xfs_iomap.c:xfs_zoned_buffered_write_iomap_begin() {
>     ...
>     if (!IS_ALIGNED(offset, mp->m_sb.sb_blocksize) || ... ) {
>         ...
>         error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
>                 xfs_iomap_inode_sequence(ip, 0));
>     ...
> }
> During an unaligned write, read-modify-write requires the source mapping.
> If the IOMAP_F_FSVERITY flag is missing on the srcmap, the iomap layer
> might assume blocks past EOF should be zeroed.
> Could this unintentionally zero out previously written Merkle tree blocks
> and corrupt the fs-verity metadata?

This one looks valid, pass iomap_flags to xfs_bmbt_to_iomap().

> Does this fallback to xfs_direct_write_iomap_begin() drop the newly
> assigned IOMAP_F_FSVERITY flag?
> If a file has an extent size hint configured, the delegation skips passing
> the iomap_flags variable entirely.
> Without this flag, could the generic iomap write code update i_size when
> appending the Merkle tree past EOF, unintentionally exposing the internal
> fs-verity metadata to userspace?
> [ ... ]

This is actually highlighted the problem that inodes with extent hints won't
correctly build merkle tree. Enabling this will require to implement fsverity in
direct i/o path. So, added a check that fsverity can not be enabled on inode
with extent hints.

> What happens if a read operation (like a large readahead) starts in the
> data region but spans across the boundary into the fs-verity metadata
> region?
> If the starting offset is less than the metadata offset, IOMAP_F_FSVERITY
> won't be set. Because the returned iomap isn't truncated at the metadata
> boundary, it will cover the metadata region without the required flag.
> Will the generic iomap read code then incorrectly zero the folios past
> i_size in the page cache instead of reading the Merkle tree from disk?

Normal readahead will stop at EOF.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=13

> Does this completely bypass verification for merged ioends, causing a
> regression where corrupted data is read as valid?
> When large contiguous reads are split into multiple bios by the block layer,
> xfs_end_io() merges the tail ioends into the head ioend's io_list via
> iomap_ioend_try_merge().
> Since xfs_end_ioend_read() only passes the head's io_bio to
> fsverity_verify_bio(), does it leave the merged tail bios completely
> unverified before iomap_finish_ioends() loops through the entire io_list
> and marks all of their folios as uptodate?

iomap_ioend_can_merge() returns false for read ioends. So, no merge occurs for
these.

> Does this strictly serialize fs-verity verification per-inode, causing a
> severe performance regression?
> Unlike ext4 and f2fs which allocate a work_struct per bio to allow parallel
> hashing across CPUs, this reuses the single ip->i_ioend_work per inode.
> When multiple concurrent reads to the same file complete, they are appended
> to ip->i_ioend_list. A single worker thread running xfs_end_io() iterates
> over them and sequentially calls the CPU-intensive fsverity_verify_bio().
> Could this limit fs-verity throughput for a single file to the hashing
> speed of a single CPU core?

Yes this is true. This could probably be improved for all read path I/O. As far
as I understood, the history is that there was high lock and transaction
reservation usage on random writes. With fsverity ioends we don't need a lock so
that could be improved.

> Can this result in an unresolvable self-deadlock regression when the block
> device has integrity checksums enabled?
> If bdev_has_integrity_csum() is true, xfs_get_iomap_read_ops() forces
> metadata reads to use xfs_iomap_read_ops.
> When a data read completes, it queues the per-inode ip->i_ioend_work. The
> worker calls xfs_end_io() -> xfs_end_ioend_read() -> fsverity_verify_bio().
> If fsverity_verify_bio() synchronously submits a read for a Merkle tree
> page, that metadata read completion will eventually call xfs_end_bio() and
> attempt to queue the exact same ip->i_ioend_work struct while the worker is
> blocked waiting for the folio lock.
> Since the work is already executing, the workqueue subsystem merely marks
> it pending, leaving the worker indefinitely blocked.

If we already got into BIO verification, work item is already executing (the
pending flag cleared). So, the work item can be scheduled again. In pending
case, the item will be added to ioend list.

So, no deadlock.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=14

> Does this leave stale dirty pages in the page cache?
> If fsverity enablement fails after the Merkle tree blocks have been written
> to the page cache, xfs_fsverity_delete_metadata() removes the physical extents
> on disk via xfs_itruncate_extents(). However, it doesn't seem to invalidate
> the corresponding dirty pages in the page cache.
> When writeback later attempts to flush these past-EOF dirty pages, could it
> try to write to extents that no longer exist, causing XFS writeback to fail?

Hmm I added this in previous version but looks like I lost it during squashing.
Added again.

> Does initializing ip->i_cowfp without holding XFS_ILOCK_EXCL introduce a data
> race?
> In xfs_fsverity_end_enable(), xfs_ifork_init_cow() is called without holding
> XFS_ILOCK_EXCL. Background processes like XFS online scrub take
> XFS_ILOCK_SHARED to safely inspect inode forks.
> If scrub runs concurrently, could it see ip->i_cowfp != NULL but read an
> uninitialized if_format due to a lack of memory barriers, resulting in a crash?

This is valid, add a lock.

> Does direct bitwise modification of inode->i_flags create a data race?
> Although XFS_IOLOCK_EXCL is held, other VFS paths might modify or read i_flags
> under inode->i_lock. Modifying the flags using a raw bitwise OR can lead to
> lost flag updates or torn reads. Should this use inode_set_flags() to ensure
> atomicity under the inode lock?

Yes, the inode_set_flags() need to be used to match the fsverity_active().

> Does the error path cause a double-unlock of XFS_ILOCK_EXCL?
> fs/xfs/xfs_fsverity.c:xfs_fsverity_cancel_unwritten() {
>     ...
>     xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>     error = xfs_bunmapi(tp, ip, imap.br_startoff, imap.br_blockcount, 0, 1, &done);
>     if (error)
>         goto out_cancel;
>     ...
> out_cancel:
>     xfs_trans_cancel(tp);
>     xfs_iunlock(ip, XFS_ILOCK_EXCL);
>     ...
> }
> Calling xfs_trans_cancel() automatically unlocks the joined inode, but the code
> then explicitly calls xfs_iunlock(ip, XFS_ILOCK_EXCL). Could this cause a
> kernel panic due to a double-unlock?

Refactored to handle transaction/locking correctly

> Does this unconditionally advance past incomplete unmap operations?
> fs/xfs/xfs_fsverity.c:xfs_fsverity_cancel_unwritten() {
>     ...
>     error = xfs_bunmapi(tp, ip, imap.br_startoff, imap.br_blockcount, 0, 1, &done);
>     ...
>     offset_fsb = imap.br_startoff + imap.br_blockcount;
> }
> xfs_bunmapi() limits the number of blocks it unmaps in a single transaction.
> If it unmaps a partial extent, it sets the done parameter to 0. However, this
> loop seems to ignore the done variable and unconditionally advances offset_fsb.
> If fsverity encounters a large unwritten extent, could this leave garbage
> unwritten metadata blocks on disk?

Added while(!done) loop

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=15

> Does this error path cause a double unlock of the inode if xfs_bunmapi()
> fails?
> If xfs_bmapi_read() fails earlier in the loop, jumping to out_cancel
> works correctly because the transaction doesn't own the lock yet, so the
> explicit xfs_iunlock() correctly drops it.
> However, if xfs_bunmapi() fails, xfs_trans_ijoin() has already been called
> with XFS_ILOCK_EXCL, transferring ownership of the inode lock to the
> transaction.
> When xfs_trans_cancel() runs in this scenario, it aborts the transaction
> and automatically drops any joined locks. Wouldn't the subsequent
> xfs_iunlock() then try to drop the same lock a second time?

Yes, fixed above.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=16

> Does exposing this ioctl introduce a path to a double unlock regression?
> When fsverity_ioctl_enable() is called, it can eventually reach the error path
> in xfs_fsverity_cancel_unwritten() if xfs_bunmapi() fails:
> fs/xfs/xfs_fsverity.c:xfs_fsverity_cancel_unwritten() {
>     ...
> 		if (imap.br_state == XFS_EXT_UNWRITTEN) {
> 			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> 			error = xfs_bunmapi(tp, ip, imap.br_startoff,
> 					imap.br_blockcount, 0, 1, &done);
> 			if (error)
> 				goto out_cancel;
>     ...
> out_cancel:
> 	xfs_trans_cancel(tp);
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	return error;
> }
> Because the inode was already joined to the transaction with XFS_ILOCK_EXCL,
> wouldn't the call to xfs_trans_cancel() automatically release the ILOCK?
> If so, the subsequent unconditional call to xfs_iunlock() would result in a
> double unlock of the rwsem. This could cause an atomic counter underflow,
> leading to lock state corruption or deadlocks.

Yes, the same as above.

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=18

> Does this code handle all metadata corruption errors?
> If a file has a verity descriptor with an invalid size,
> xfs_fsverity_get_descriptor() can return -ERANGE:
> fs/xfs/xfs_fsverity.c:xfs_fsverity_get_descriptor() {
>     ...
>     if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
>         return -ERANGE;
>     ...
> }
> Similarly, if the PKCS#7 signature is invalid, fsverity can return -EBADMSG.
> Without -ERANGE and -EBADMSG in this switch statement, they fall through to the
> default case. This causes the scrub session to abort and propagate the error to
> xchk_prepare_iscrub() instead of flagging the inode for repair. Should these
> codes be added to the list of validation errors?

These two make sense, the other returned by pkcs#7 doesn't seem suitable for
repair (missing key, key rejected).

--------------------------------------------------------------------------------
> Can clearing S_VERITY on a live inode race with VFS open?
> When opening a verity file, fsverity_file_open() evaluates IS_VERITY(inode)
> without holding the inode's IOLOCK. If it evaluates to true, it calls
> fsverity_ensure_verity_info(), which eventually enters
> xfs_fsverity_get_descriptor().
> If xrep_inode_verity() clears the S_VERITY flag concurrently,
> xfs_fsverity_get_descriptor() will trigger an assertion failure:
> fs/xfs/xfs_fsverity.c:xfs_fsverity_get_descriptor() {
>     ...
>     ASSERT(inode->i_flags & S_VERITY);
>     xfs_ilock(ip, XFS_ILOCK_SHARED);
>     ...
> }
> Could this lead to a kernel panic (on debug builds) or use of a
> partially-cleared verity inode?

This is valid, let's use inode_set_flags() to match the fsverity_active().

--------------------------------------------------------------------------------
https://sashiko.dev/#/patchset/20260710085256.3464201-1-aalbersh%40kernel.org?part=20

> Does this unconditional inclusion allow modifying verity files when
> CONFIG_FS_VERITY is disabled?
> When a kernel is built without CONFIG_FS_VERITY, XFS will mount the filesystem
> read-write instead of falling back to read-only mode, because
> XFS_SB_FEAT_RO_COMPAT_VERITY is unconditionally included here.
> If a user with write permissions calls truncate() on a verity file,
> open(O_WRONLY) is blocked by a fallback returning -EOPNOTSUPP, but truncate()
> bypasses this and reaches setattr_prepare().
> Because CONFIG_FS_VERITY is disabled, setattr_prepare() skips the IS_VERITY()
> check. XFS would then proceed with the truncate, freeing all blocks past EOF,
> which could silently destroy the verity Merkle tree and descriptor.

This is valid, addressed with a fix.

--------------------------------------------------------------------------------
 -:  ------------ >  1:  f950c862b409 fs-verity support for XFS with post EOF merkle tree
 1:  c6ec0d36e610 =  2:  c4f1b8cf00c9 fsverity: report validation errors through fserror to fsnotify
 2:  c1bc4e09e99d =  3:  7c2c5311c9f6 fsverity: expose ensure_fsverity_info()
 3:  46fa567c5396 =  4:  8055613f1a4d fsverity: pass digest size and hash of the all-zeroes block to ->write
 4:  bf674d6447c6 =  5:  9545ca3c3399 fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
 5:  881ca13124f5 =  6:  cd46c76fe3b4 fsverity: improve flushing performance of fsverity_fill_zerohash
 6:  70a3a18d0535 =  7:  e8f9dddb89b9 fsverity: don't allow setting DAX file attribute on fsverity files
 -:  ------------ >  8:  3ca252cd6be2 fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
 7:  8985c8159373 =  9:  a0dc2713a247 xfs: introduce fsverity on-disk changes
 9:  f3b835598dfd = 10:  f58409354927 xfs: don't allow to enable DAX on fs-verity sealed inode
11:  a75ae14156a5 = 11:  de88296b352d xfs: disable direct read path for fs-verity files
10:  bfe9d1a76b5d = 12:  d0d20df8ad7c xfs: don't report dio_mem_align and dio_offset_align for fsverity files
12:  873908b75477 ! 13:  a125d7c824f9 xfs: handle fsverity I/O in write/read path
    @@ fs/xfs/xfs_iomap.c

      #define XFS_ALLOC_ALIGN(mp, off) \
      	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
    +@@ fs/xfs/xfs_iomap.c: xfs_direct_write_iomap_begin(
    + 	if (flags & IOMAP_ATOMIC)
    + 		iomap_flags |= IOMAP_F_ATOMIC_BIO;
    +
    ++	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
    ++		iomap_flags |= IOMAP_F_FSVERITY;
    ++
    + 	/*
    + 	 * COW writes may allocate delalloc space or convert unwritten COW
    + 	 * extents, so we need to make sure to take the lock exclusively here.
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
      	loff_t			count,
      	unsigned		flags,
    @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
      	xfs_filblks_t		count_fsb;
      	xfs_extlen_t		indlen;
     @@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    - 	struct xfs_iext_cursor	icur;
    - 	int			error = 0;
    + 				smap.br_startoff + smap.br_blockcount);
    + 			xfs_trim_extent(&smap, offset_fsb,
    + 					end_fsb - offset_fsb);
    +-			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
    ++			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags,
    ++					iomap_flags,
    + 					xfs_iomap_inode_sequence(ip, 0));
    + 			if (error)
    + 				goto out_unlock;
    +@@ fs/xfs/xfs_iomap.c: xfs_zoned_buffered_write_iomap_begin(
    + 	got.br_state = XFS_EXT_NORM;
    + 	xfs_bmap_add_extent_hole_delay(ip, XFS_COW_FORK, &icur, &got);
    + 	ac->reserved_blocks -= count_fsb;
    +-	iomap_flags |= IOMAP_F_NEW;
    ++	iomap_flags |= (IOMAP_F_NEW | IOMAP_F_SHARED);

    -+	iomap_flags = iomap_flags | IOMAP_F_SHARED;
    -+
    - 	ASSERT(!xfs_get_extsz_hint(ip));
    - 	ASSERT(!(flags & IOMAP_UNSHARE));
    - 	ASSERT(ac);
    + 	trace_xfs_iomap_alloc(ip, offset, XFS_FSB_TO_B(mp, count_fsb),
    + 			XFS_COW_FORK, &got);
     @@ fs/xfs/xfs_iomap.c: xfs_buffered_write_iomap_begin(
      	if (xfs_is_shutdown(mp))
      		return -EIO;
13:  9ca0788bde68 = 14:  a65403d233e2 xfs: use read ioend for fsverity data verification
14:  fd0353ac09d5 ! 15:  6ecf7b9bf300 xfs: add fs-verity support
    @@ fs/xfs/xfs_fsverity.c
     +#include "xfs_da_btree.h"
     +#include "xfs_inode.h"
     +#include "xfs_log_format.h"
    -+#include "xfs_bmap_util.h"
     +#include "xfs_trans.h"
     +#include "xfs_trace.h"
     +#include "xfs_quota.h"
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	xfs_ilock(ip, XFS_ILOCK_EXCL);
     +	xfs_trans_ijoin(tp, ip, 0);
     +
    ++	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
    ++
     +	/*
    -+	 * We removing post EOF data, no need to update i_size as fsverity
    ++	 * We remove post EOF data, no need to update i_size as fsverity
     +	 * didn't move i_size in the first place
     +	 */
     +	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, XFS_ISIZE(ip));
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	 * files are read-only
     +	 */
     +	if (xfs_is_cow_inode(ip)) {
    -+		if (!ip->i_cowfp)
    -+			xfs_ifork_init_cow(ip);
    ++		xfs_ilock(ip, XFS_ILOCK_EXCL);
    ++		xfs_ifork_init_cow(ip);
    ++		xfs_iunlock(ip, XFS_ILOCK_EXCL);
     +		xfs_bmap_punch_delalloc_range(ip, XFS_COW_FORK, 0, LLONG_MAX,
     +				NULL);
     +	}
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_is_file_data(
     +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
     +
     +	if (!error)
    -+		inode->i_flags |= S_VERITY;
    ++		inode_set_flags(inode, S_VERITY, S_VERITY);
     +
     +out:
     +	if (error) {
15:  48eb71d0d46f ! 16:  9a5ec524c5db xfs: remove unwritten extents after preallocations in fsverity metadata
    @@ Commit message

      ## fs/xfs/xfs_fsverity.c ##
     @@
    + #include "xfs_inode.h"
    + #include "xfs_log_format.h"
    + #include "xfs_trans.h"
    ++#include "xfs_defer.h"
    + #include "xfs_trace.h"
    + #include "xfs_quota.h"
    + #include "xfs_fsverity.h"
      #include "xfs_iomap.h"
      #include "xfs_error.h"
      #include "xfs_health.h"
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_delete_metadata(
     +{
     +	struct xfs_mount	*mp = ip->i_mount;
     +	struct xfs_trans	*tp;
    -+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSB(mp, start);
    ++	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, start);
     +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end);
     +	struct xfs_bmbt_irec	imap;
     +	int			nimaps;
     +	int			error = 0;
     +	int			done;
     +
    -+
     +	while (offset_fsb < end_fsb) {
     +		nimaps = 1;
     +
    -+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
    -+				0, &tp);
    ++		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
     +		if (error)
     +			return error;
     +
     +		xfs_ilock(ip, XFS_ILOCK_EXCL);
    -+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
    -+				&imap, &nimaps, 0);
    ++		error = xfs_bmapi_read(ip, offset_fsb,
    ++				end_fsb - offset_fsb, &imap, &nimaps,
    ++				0);
     +		if (error)
     +			goto out_cancel;
     +
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_delete_metadata(
     +			goto out_cancel;
     +
     +		if (imap.br_state == XFS_EXT_UNWRITTEN) {
    -+			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
    ++			done = 0;
     +
    -+			error = xfs_bunmapi(tp, ip, imap.br_startoff,
    -+					imap.br_blockcount, 0, 1, &done);
    -+			if (error)
    -+				goto out_cancel;
    ++			xfs_trans_ijoin(tp, ip, 0);
    ++
    ++			while (!done) {
    ++				error = xfs_bunmapi(tp, ip, imap.br_startoff,
    ++						imap.br_blockcount, 0, 1,
    ++						&done);
    ++				if (error)
    ++					goto out_cancel;
    ++
    ++				error = xfs_defer_finish(&tp);
    ++				if (error)
    ++					goto out_cancel;
    ++			}
     +
     +			error = xfs_trans_commit(tp);
     +			if (error)
    -+				return error;
    ++				goto out_unlock;
     +		} else {
     +			xfs_trans_cancel(tp);
    -+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
     +		}
    ++		xfs_iunlock(ip, XFS_ILOCK_EXCL);
     +
     +		offset_fsb = imap.br_startoff + imap.br_blockcount;
     +	}
    @@ fs/xfs/xfs_fsverity.c: xfs_fsverity_delete_metadata(
     +	return error;
     +out_cancel:
     +	xfs_trans_cancel(tp);
    ++out_unlock:
     +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
     +	return error;
     +}
 8:  d782cf032d1d = 17:  9ac4bd88f99a xfs: initialize fs-verity on file open
16:  312d09ecc4e2 = 18:  eff55c20dd50 xfs: add fs-verity ioctls
17:  57d88dcd36dd = 19:  f78ba16752fe xfs: advertise fs-verity being available on filesystem
18:  856c3ff6b1db ! 20:  a283ffc94e16 xfs: check and repair the verity inode flag state
    @@ fs/xfs/scrub/common.c: xchk_inode_count_blocks(
     +	case -EINVAL:
     +	case -EFSCORRUPTED:
     +	case -EFBIG:
    ++	case -ERANGE:
    ++	case -EBADMSG:
     +		/*
     +		 * The nonzero errno codes above are the error codes that can
     +		 * be returned from fsverity on metadata validation errors.
    @@ fs/xfs/scrub/inode_repair.c: xrep_inode_unlinked(
     +
     +	if (xchk_inode_verity_broken(sc->ip)) {
     +		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_VERITY;
    -+		inode->i_flags &= ~S_VERITY;
    ++		inode_set_flags(inode, 0, S_VERITY);
     +
     +		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
     +	}
19:  52de4f439ac7 = 21:  01d4b6059dc8 xfs: introduce health state for corrupted fsverity metadata
20:  ee884674c76c = 22:  cb4acb76a9b3 xfs: enable ro-compat fs-verity flag

Andrey Albershteyn (19):
  fsverity: report validation errors through fserror to fsnotify
  fsverity: expose ensure_fsverity_info()
  fsverity: pass digest size and hash of the all-zeroes block to ->write
  fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
  fsverity: improve flushing performance of fsverity_fill_zerohash
  fsverity: don't allow setting DAX file attribute on fsverity files
  fs,fsverity: remove check for fsverity being enabled in
    setattr_prepare()
  xfs: introduce fsverity on-disk changes
  xfs: don't allow to enable DAX on fs-verity sealed inode
  xfs: disable direct read path for fs-verity files
  xfs: don't report dio_mem_align and dio_offset_align for fsverity
    files
  xfs: handle fsverity I/O in write/read path
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
 fs/btrfs/verity.c              |   6 +-
 fs/ext4/verity.c               |  36 +--
 fs/f2fs/verity.c               |  34 +--
 fs/file_attr.c                 |   5 +
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
 fs/xfs/xfs_aops.c              |  81 +++++-
 fs/xfs/xfs_bmap_util.c         |   8 +
 fs/xfs/xfs_file.c              |  67 +++--
 fs/xfs/xfs_fsverity.c          | 485 +++++++++++++++++++++++++++++++++
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
 36 files changed, 981 insertions(+), 116 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

-- 
2.54.0

