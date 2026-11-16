Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871035;
	b=C5GoBSm1tgqnhXQHaBk95exBOhnHXRnTA2+qN6iCCSyg54C0GqQS7VWTCc05AJuxW0Rh
	 IEvBmty9GbISU/ASirDzEpBV1OkzbG35OHgMqTi8pti5doNp4GOGxA5CIeVz5D8qHmrF3
	 d7X0swMO+0S3eq0lR81RljHcT5G8usHlyPQhkRYG20nj6DAxRjksr/qSN4uYxelh+kXSt
	 nG1yO+7bIHx+U/k2KmZIgFwaZRyFTgWuK/pew36FXeg2U8cklTaZ4e6XjHmKBrmzCMCt4
	 pY7vrKXwetfkoXx7Ak/xv+vhCwrw3ixYlGInZnQWu4HYkvdUHD7EFwHpLF1oqWppTjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B9pEv1EZ1h/uX6rMG7A1ud96GVcCta0AA70//BoGJkI=;
	b=2wKw/fHozJ1JDY8deJV9WXtfkU8+z0h62336oZE7BXe5DEUNzUiq9YONzuQje0jYb7Bs
	 kVOIKSG4ulIJO9kY0gRZ7YcwL00y/cblzTj0BdbOmQd57uJQq2vUSMiZ7Hg134gO5YJm3
	 ++V46XZ+Aoc48f1GtdFrONhjLEtOrenSuAZxEQxp98Ivj4kfAiBvCc7/25kTSs6O9wrVa
	 jw17EAxIrMHK1AKPUzKuzj4KHtu7WjmYzP6FwTMSOkDsdiEu64YIbxE7a09opCdf2A+X5
	 d0NYzYEn4asQS30dnmAM4C3pa9W+HDDD7uEWlaa0jibFqKlQ04vP+2Ftl6bCzhrDyRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qw9X8TMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C02606A31C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qw9X8TMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83031F000C4;
	Mon, 16 Nov 2026 23:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871034;
	bh=B9pEv1EZ1h/uX6rMG7A1ud96GVcCta0AA70//BoGJkI=;
	h=From:To:Cc:Subject:Date;
	b=Qw9X8TMssNOoMhh1Xvzw+yKwFjP9PMkXOj5nc/zR+l7TuylEhetFKLLjhudY+lllh
	 jLgYYKeLMoo/RV7gb5I4qf2JeJzKAvgJapZEBdsABFoeFeosVFsmbADCnThLRmaPfg
	 VweOBn/1KHRJoPi2hBhSGm1C2qpgfd7a0uNU6cUHyN4p3HwbP1Rpb/CUufFizpa0q9
	 QfhiDlDKN4r8CQsQWUX6G84pVT2/S6FCYdksqJHB/Voi2EiiSzpswIT4j9rdE7kmPe
	 JHwDptad+4vPMdUYNqPd4O0NH9tdyIOISnJD07HOHUi0adQw2zAijtxzsWkIh4QyE8
	 cvkHsFn24o10w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [V2 PATCH 00/59] Validate journal log items during log recovery.
Date: Tue, 17 Nov 2026 10:14:17 +1100
Message-ID: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
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

Log recovery reads log items straight from the journal and acts on
them with very little checking. Validation of each item type is
scattered and much of it runs only as the item is being applied to
the filesystem. Corrupt or malicious log contents can therefore be
partially acted on before anything notices they are wrong, and the
checks that do exist are inconsistent from one item type to the
next.

This series makes log item validation a first-class, up-front step.
As each item is decoded from the journal it is fully validated
before any recovery code acts on it, so downstream recovery can
trust the item's structure and contents. Existing validation is
scattered through the commit handlers, and is largely ad hoc in
nature.

This version starts with fixes for existing bugs. Exact validation
exposed them, or depends on the state they leave behind. They carry
Fixes tags and do not depend on the validation patches. Of note:

- Several btree root level checks were off by one. The bmap btree
  maximum height calculation was one level short, and the rt rmap
  and rt refcount root checks allowed a root one level too deep.
  Validation bounds logged roots by these heights, so they must be
  exact, and they should be consistent across all btree types.  The
  minimum log size calculation keeps using the old bmap btree
  height, so existing filesystems still mount.

- Growfs, and recovery of a growfs, leave mount state derived from
  the superblock geometry stale. This includes the rt btree heights,
  the transaction reservations, the realtime extent geometry and the
  mount features. Recovery validates and replays items against that
  state, so it is recomputed when growfs runs, when a superblock
  change is replayed, and after the log has been recovered. The
  mount's own superblock updates are applied after the post-recovery
  superblock re-read, so recovery no longer discards them.

- Changing max_atomic_write on remount ran the minimum log size
  calculation on a live filesystem, which temporarily changes
  mount-wide btree heights. It is replaced with a check of the
  atomic write reservation against what the current log can hold.
  Mount teardown after a failed growfs, or a failed growfs recovery,
  could also try to free groups that were never set up.

The new validation is driven by per-region and per-item-type
callbacks on the recovery item operations, so every operation
header, region and item type is checked the same way. First we
validate the ophdr based record framing, then we reassemble whole
regions, and finally we validate whole items.

The scope is the on-disk log format and the in-core structures
recovery builds from it. Every log item type is covered. The
validation is what can be checked from the log item alone together
with stable mount and superblock geometry.

Some checks cannot be made at decode time and are deliberately left
to the first runtime access after recovery. Realtime group bounds
are not available because the realtime inodes are not set up until
after recovery. Filesystem block number bounds cannot be trusted at
decode time because a growfs superblock update is not replayed into
the in-core superblock until pass two. Hence extent and pointer block
range validation will need to be reworked before it can be relied
on.

More detail on these issues can be found under known issues in
the version 1 changelog. Version 2 does not address them; the
changes in V2 are a result of LLM reviews uncovering pre-existing
bugs and issues in the initial validation code that needed to be
fixed first.

The known issues will take a little time to be addressed, so I'd
prefer to get feedback on the rest of the patchset before I spend
time reworking that aspect of it.  Early(-ish) feedback on the
structure and implementation as it currently stands is more
important right now.

The patchset passes all of fstests on 1k and 4k block sizes (except
for the couple of growfs/recovery stress tests) without regressions,
so it largely works for known good journals.  Anyone who has been
fuzzing journal structures with LLMs and/or modified syzbots are
welcome to try it and see what holes they can find in it.

The entire series can be pulled from here:

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git log-verification-2


Known Issues:

1. Validation runs repeatedly on every recovery pass

Except for the CRC validation pass.

Pass 1 needs to validate all the transaction/checkpoint structures
as we walk the entire active journal to find cancellation items. We
also need to validate buffer and quotaoff items as they are recorded
in cancelation tables.

Pass 2 readahead needs items that are read ahead to be validated
sufficiently to ensure the location being read from disk is likely
to be OK.

Pass 2 needs to fully validate all the items being recovered, before
they are recovered.

Some of the item recovery also reformats the items being recovered;
things like 32bit vs 64bit incore structure differences are being
resolved at item validation time so they don't need to be handled
differently by validation or recovery code. This means that
validation needs to run on those items on every pass that they will
have something run against them. This needs more thought; inodes are
the main issue here, and largely they are only parsed in pass 2.

Hence we might be able to split up validation into pass-1 + pass-2
variants. pass-1 needs to validate the number and size of regions
matches the format header to ensure checkpoint decoding is always
valid. pass-2 can then do the full item validation.


2. Geometry validation versus growfs and shrink

This is an extension of issue 1, in that validation occurs before
replay.  The geometry items validate against is the geometry in
effect at the start of recovery. A geometry change only takes effect
when the primary superblock buffer is replayed, which happens during
transaction recovery in the second pass, not during checkpoint
region decoding.

A growfs operation logs the superblock geometry change ahead of any
metadata that uses the new geometry. A shrink also logs the
superblock geometry change after relevant internal metadata has been
updated and/or invalidated. Hence if the superblock geometry changes
during recovery, item validation at region decode time will fail to
validate geometry-based fields correctly.

This affects any item that carries a type that encodes geometry
information, such as inode numbers, disk addresses, and extents,
including the realtime variants.  Structural validation that does
not depend on geometry is unaffected.

As the geometry change only takes effect during transaction
recovery, any validation that depends on it must run after the
superblock buffer has been replayed.

This causes issues for readahead validation, which decodes
addresses and submits IO, potentially for addresses outside the
range of the initial superblock geometry. Readahead silently
discards reads beyond the end of the filesystem, but we shouldn't
issue them in the first place.

Even in pass 2, the checkpoint where the geometry change is
recorded cannot be validated until recovery even though items in the
checkpoint are correctly ordered either side of the change.

Hence it is likely that we need two layers of item validation for
pass 2 - the decode time validation of everything except disk
addresses, and recovery time validation of addresses. This will
order all disk address based validation correctly against
grow/shrink operations.

3. fold ->complete() into ->validate_item()

The xlog_recover_item_ops ->complete() callback was added early on,
when it was not entirely clear how item validation would end up
looking. In the end, it is used by only one special item type:
the transaction header.

->validate_item() already runs on every item at that same point, so
->complete() probably should be folded into it. ->validate_item()
would perform the header copy and signal that the item is consumed,
removing the need for ->complete() altogether.


Changelog:

Version 2:
- New patch: fix the off-by-one rt rmap btree maximum level checks in
  the root loader, block verifier and inode repair, allowing an empty
  level zero root before growfs adds the first realtime volume.
- New patch: allow an empty level zero rt refcount btree root before
  growfs adds the first realtime volume, and make inode repair use the
  same root level rules as the loader.
- New patch: recompute m_rtbtree_maxlevels wherever growfs recomputes
  the rt btree maximum heights.
- New patch: re-derive the mount features and recompute the rt btree
  maximum heights when the primary superblock is replayed, and abort
  recovery if it adds a realtime volume without a realtime device.
- New patch: move the post-recovery superblock re-read out of log
  recovery into the mount code, and reinitialise the mount geometry
  state derived from it after a dirty log has been recovered.
- New patch: apply the mount's in-core superblock updates after the
  post-recovery superblock re-read so they are not discarded on mounts
  that recover the log.
- Metadata btree root validation now uses the same root level and record
  count rules as the runtime loaders, accepting the empty level zero
  root growfs creates before the first realtime volume, and gates each
  root on the btree feature.
- New patch: reject logged btree fork roots whose compact on-disk form
  does not fit within the inode fork, matching the runtime root
  loaders.
- New patch: fix the bmap btree maximum height calculation to include
  the inode root level, change the bmap btree root level checks to
  match, and keep the legacy calculation only for the minimum log
  size.
- New patch: check the remount max_atomic_write reservation against the
  largest reservation the current log can hold, instead of running the
  minimum log size calculation on a live filesystem
- New patch: recompute the transaction reservations after growfs changes
  the rt btree heights, keeping a configured atomic ioend reservation
- check for a missing realtime device before updating the in-core
  superblock during superblock recovery, so a failed mount does not free
  rtgroups that were never created
- update the mount features before setting up new rtgroups during
  superblock recovery, so the first rtgroup excludes the realtime
  superblock
- recompute the realtime extent size geometry when recovering a
  superblock change
- recompute the realtime extent size geometry when reinitialising the
  filesystem geometry after log recovery
- compute the minimum log size attr reservation with the legacy bmap
  btree height, so the bmap btree height fix does not change the minimum
  log size, and set up the legacy btree heights for the whole minimum
  log size calculation
- new patch: skip group indexes with no instantiated group when freeing
  groups, so teardown after a failed growfs or growfs recovery does not
  dereference a NULL group
- document that full item validation bounds the realtime btree inode
  fork root level by the largest height any geometry allows until the
  recovery geometry problem is solved
- bound logged realtime btree inode fork root levels by the largest
  height any geometry allows, so recovery of a growfs that adds the
  first realtime volume is not rejected against the pre-recovery
  geometry
- noted the pre-existing growfs vs max_atomic_write remount race in the
  trans resv recalc patch header and comment
- added a Fixes tag to the rt geometry superblock recovery patch
- Restored the XMI ->validate_region()/->validate_item() wiring and
  commit handler cleanup that were dropped from the mapping exchange
  intent patch when v1 was rebased.
- Fail recovery when a commit record arrives while a log item is still
  being assembled, instead of silently dropping the incomplete item.
- The unmount record check during the head and tail scan no longer fails
  the mount: a record that fails validation leaves the log dirty for
  head verification and recovery, validation there is quiet, and the
  unmount magic is accepted in either byte order.
- Zero the buffers allocated for EFI and EFD host format conversion so
  structure padding is not left uninitialised.
- Check the logged dquot buffer offset against the location fixed by the
  dquot ID, and bound the dqblk within the cluster buffer without
  arithmetic that can wrap on 32-bit.
- Zero the buffer allocated for inode log format host conversion so the
  padding field is not left uninitialised.
- Check the logged inode buffer block and offset against the location
  fixed by the inode number for all inode chunk geometries, and bound
  the inode within the cluster buffer.
- Report bad logged extent records against the validated format header
  inode number rather than reading di_ino, which is beyond the end of a
  V2 log dinode.
- Buffer item validation now accepts an unknown buffer type on non-CRC
  filesystems, rejects a non-cancelled buffer with no dirty regions, and
  the header notes that split page-boundary regions are no longer
  accepted.
- The redundant buffer replay checks patch header now notes that the
  removed handling for split page-boundary regions is rejected by
  validation.
- Only read the dquot buffer data region after checking the item has
  exactly two regions.
- Logged bmap btree root validation now bounds the root level at one
  less than the corrected maximum height, matching the root loader.
- rebased onto v7.4-rc1; __xfs_inode_fork_size() uses the new
  XFS_FORKOFF_TO_B() conversion macro
- rewrote the headers of the documentation and transaction header
  refactoring patches to remove stale AI prompt tags and add Assisted-by
  and Signed-off-by tags
- rewrote the log recovery validation design document to describe the
  implemented four layer design and the open growfs geometry problem,
  removed the implementation plan, and folded all later doc changes into
  the doc patch
- reject a zero length op header that opens any region other than the
  checkpoint transaction header, or that completes a region
- fail recovery with -EFSCORRUPTED on an unmount record inside an open
  checkpoint instead of warning and discarding the checkpoint
- dropped the redundant host format size comparison from the EFI region
  length check
- use SHUTDOWN_LOG_IO_ERROR for the unmount record op header length
  check shutdown so it does not force the log and deadlock against the
  CIL push that called it
- corrected the design doc commit message (four layers, no
  implementation plan)
- design doc: quota off regions must be 160 or 88 bytes with valid quota
  off flags, and inode/dquot buffers may be logged without their type
  flag
- quota off recovery now accepts the 160 and 88 byte regions that v5.14
  kernels logged, and checks the quota off flags
- buffer item recovery accepts inode and dquot buffers logged without
  their type flag (V4 inode allocation, online repair), and the repair
  code explains why it doesn't set the flag
- dquot buffer recovery comment and commit message account for online
  repair logging dquot buffers without the type flag

Version 1:

- Initial version.
- https://lore.kernel.org/linux-xfs/20261013060204.3138690-1-dgc@kernel.org/
- https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git log-verification-1


Commits:
45b1d70066c7   xfs: set the unmount record operation header length
f1199ef01d51   xfs: fix the rt rmap btree maximum level checks
b42451a39759   xfs: allow an empty rt refcount btree root before the rt volume exists
0bc1f0d3a14d   xfs: recompute the rt btree maxlevels when growfs changes them
1051b2bb4bbd   xfs: recompute the transaction reservations after growfs
01eb31903a63   xfs: skip missing groups when freeing them
8a62f4b00eac   xfs: update the rt geometry when recovering a superblock change
7216d4a64759   xfs: reinitialise the filesystem geometry after log recovery
afaf768b097a   xfs: apply mount superblock updates after log recovery
ed3fc2f8a765   xfs: check the atomic write reservation against the current log size
298f54b2ce69   xfs: fix the bmap btree maximum height calculation
b03a3941bad5   xfs: add log recovery item validation design document
bc1fea813fb1   xfs: lift transaction header parsing out of the region assembly
a20a7f77bd02   xfs: track transaction header decode state explicitly
1347f4fe9f5a   xfs: track the log item being rebuilt with an explicit pointer
fb996aa82b19   xfs: complete log items explicitly during recovery
1296a786754f   xfs: add log item validation infrastructure to log recovery
250789ccb8c2   xfs: recover the transaction header as a validated item type
0673f7673082   xfs: factor out xlog_recover_validate_ophdr()
edeb9a121555   xfs: validate operation header length and alignment during recovery
4baf15d9e2b9   xfs: validate the operation header padding during recovery
7e57a8976e19   xfs: validate the operation header flags during recovery
55c3a57b62f6   xfs: enforce zero length control records during recovery
8cf887589d89   xfs: validate the unmount record during recovery
73ea77f87940   xfs: handle zero length continuation op headers during recovery
bedc12862c52   xfs: bound the assembled region size during recovery
13c7907b8278   xfs: dump the corrupt region when log item validation fails
1fb1b54316f9   xfs: validate inode create and quota off log items during recovery
cd26dbdbe15b   xfs: validate extent free log items during recovery
9daa54c92774   xfs: validate and convert extent free intents during recovery
b8519bbce522   xfs: validate and convert extent free done items during recovery
c5b15f11306c   xfs: validate rmap update intents during recovery
09207a252d5a   xfs: validate rmap update done items during recovery
518a2de12579   xfs: validate refcount update intents during recovery
f281914d5bc3   xfs: validate refcount update done items during recovery
6bdd8d8b39ae   xfs: validate bmap update intents during recovery
89f9f006ca26   xfs: validate bmap update done items during recovery
b9237a533bb1   xfs: validate mapping exchange intents during recovery
371b3d5b8955   xfs: validate mapping exchange done items during recovery
2def519ac4b5   xfs: validate dquot items during recovery
905a22386578   xfs: validate attr done items during recovery
d6446ad17c86   xfs: validate attr intents during recovery
e83627742991   xfs: convert inode items to host format during recovery
88ad40085e34   xfs: allow xfs_imap() to map without an inode btree lookup
c5e34f4114f2   xfs: validate the inode item format header during recovery
99fdd487b959   xfs: validate the logged inode core during recovery
a4e13d066360   xfs: validate the logged inode forks during recovery
c911386a0470   xfs: validate logged local fork contents during recovery
0a931c845ded   xfs: validate logged extent fork contents during recovery
f5a8d1d9ddf3   xfs: allow a long format btree root to be checked without a cursor
0a1a37173833   xfs: validate logged btree fork roots during recovery
6a8381aee121   xfs: validate logged metadata btree fork roots during recovery
391dd3bf9056   xfs: check logged btree fork roots fit in the inode fork during recovery
0caea84f2127   xfs: validate buffer item region count during recovery
93759056d8d4   xfs: validate buffer item regions during recovery
dec0ab7ab4f5   xfs: validate the whole buffer item during recovery
70209b185ac5   xfs: remove redundant buffer checks from recovery replay
99549fb7954f   xfs: fail recovery on a buffer type mismatch
0d3a450a0106   xfs: validate logged dquot buffers during recovery

Diffstat:
 Documentation/filesystems/xfs/index.rst                              |    1 +-
 Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst |  672 ++++-
 fs/xfs/libxfs/xfs_bmap.c                                             |   96 +-
 fs/xfs/libxfs/xfs_bmap.h                                             |   10 +-
 fs/xfs/libxfs/xfs_bmap_btree.c                                       |    2 +-
 fs/xfs/libxfs/xfs_btree.c                                            |   50 +-
 fs/xfs/libxfs/xfs_btree.h                                            |    4 +-
 fs/xfs/libxfs/xfs_dquot_buf.c                                        |   64 +-
 fs/xfs/libxfs/xfs_format.h                                           |    8 +-
 fs/xfs/libxfs/xfs_group.c                                            |    9 +-
 fs/xfs/libxfs/xfs_ialloc.c                                           |    7 +-
 fs/xfs/libxfs/xfs_inode_buf.c                                        |   19 +-
 fs/xfs/libxfs/xfs_inode_buf.h                                        |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c                                       |   27 +-
 fs/xfs/libxfs/xfs_log_format.h                                       |    8 +-
 fs/xfs/libxfs/xfs_log_recover.h                                      |   64 +-
 fs/xfs/libxfs/xfs_log_rlimit.c                                       |  111 +-
 fs/xfs/libxfs/xfs_quota_defs.h                                       |    2 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c                                 |   27 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c                                     |   29 +-
 fs/xfs/libxfs/xfs_shared.h                                           |    1 +-
 fs/xfs/libxfs/xfs_trans_resv.c                                       |   72 +-
 fs/xfs/libxfs/xfs_trans_resv.h                                       |    1 +-
 fs/xfs/scrub/inode_repair.c                                          |   44 +-
 fs/xfs/scrub/quota_repair.c                                          |    7 +-
 fs/xfs/xfs_attr_item.c                                               |  283 +-
 fs/xfs/xfs_bmap_item.c                                               |  109 +-
 fs/xfs/xfs_buf_item_recover.c                                        |  422 ++-
 fs/xfs/xfs_dquot_item_recover.c                                      |  157 +-
 fs/xfs/xfs_exchmaps_item.c                                           |   96 +-
 fs/xfs/xfs_extfree_item.c                                            |  367 +-
 fs/xfs/xfs_fsops.c                                                   |    7 +-
 fs/xfs/xfs_icache.h                                                  |    2 +-
 fs/xfs/xfs_icreate_item.c                                            |   18 +-
 fs/xfs/xfs_inode.h                                                   |   43 +-
 fs/xfs/xfs_inode_item_recover.c                                      | 1089 ++++++-
 fs/xfs/xfs_log.c                                                     |   16 +-
 fs/xfs/xfs_log_recover.c                                             |  857 ++++--
 fs/xfs/xfs_mount.c                                                   |  139 +-
 fs/xfs/xfs_mount.h                                                   |    9 +-
 fs/xfs/xfs_refcount_item.c                                           |  163 +-
 fs/xfs/xfs_rmap_item.c                                               |  163 +-
 fs/xfs/xfs_rtalloc.c                                                 |   15 +-
 fs/xfs/xfs_trace.h                                                   |   34 +-
 44 files changed, 4340 insertions(+), 986 deletions(-)
