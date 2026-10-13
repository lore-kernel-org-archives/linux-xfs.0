Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E513ABD88
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871331; cv=none; b=R5HfVET6uom0dMjgnYUr+e2SkCpP0LAW/nHas6JwlI9FWoR7TaaEghXPcDin9ltfCwABddtJH7SZSiK0ah/cTCSYsxrGoUS+lR1CMREuV4251tGI1dCct1ewhxouIAZuMYLNzW1xxi3j6Se15Hd+AQtC+9fAFY3bVjESx/vzYhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871331; c=relaxed/simple;
	bh=LnyHsrYON9+CrjiigGSjJ/OkYwCnheP0gxQPSBPTXBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bvumnO7JLViWCfIyL4O/9Yg+DCVjOB4XdAKNGEVk+wkemIqmLwW+xoaxEdUyfUc+EFAJ4TkHCchB2GOM4GGJKH77BgDC0t8RmBPq23eifud/YxkUwFTBsNllRIz7u06/p92ThvVyKicLBIGDTOn8HrVhFu+IGXudtAsnIm65eZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFHlY9zE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFHlY9zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051991F000FF;
	Tue, 13 Oct 2026 06:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871329;
	bh=NbxUxu1cKSRxfxIra9gTapvdZAGTFtXPnsBKPzEyCH4=;
	h=From:To:Cc:Subject:Date;
	b=XFHlY9zELAeNbyuAXaa/Ucl5FMvS6p0JC1YNoAyKVOelJf4+JdA3Gakb/l9yqLonN
	 +SRd65XjZt2gC0InpyNbVT9MP9WoHG+J09aF7hPBktolDPHCJO03+RBADqmyWNRl4J
	 vPm2gcUMaC74NuMlMBeLireI3t91avisOeUsn2sM5rJkh2UcbOwqp9csLi4c/1KT79
	 2bjBAmjEUWPICIyrMqMAAbJ+CUTdVaRlFSD2NhoWw6zf43w0SlFt2jf7GSAW1EjaPs
	 lfO2u5R/X2KvWAUE4Jq6nkSd0R+HVQK2aaDsedgDxUTdTsPpdRye8TLWXN1Z8OQRxu
	 jz14r7CLQKRJA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [RFC] [PATCH 00/48] Validate journal log items during log recovery.
Date: Tue, 13 Oct 2026 17:00:50 +1100
Message-ID: <20261013060204.3138690-1-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
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
trust the item's structure and contents. The validation is driven by
per-item-type callbacks on the recovery item operations, so every
item type is checked the same way: the region count is checked
against what the item type and its logged fields require, each
region is bounds checked, and the whole item is checked for internal
consistency. Existing validation that was scattered through the
commit handlers is brought forward into these callbacks, and the
now-redundant checks are removed so the commit handlers are left to
do only replay.

The operation header decode and the transaction header are validated
the same way, so the record framing is checked before the items
within it are assembled.

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
on. More detail is below under known issues.

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

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git log-verification-1

Known issues:

1. Validation runs repeatedly on every recovery pass

Except for the CRC validation pass.

Pass 1 needs to validate all the transaction/checkpoint structures
as we walk the entire active journal to find cancellation items. We
also need to validate buffer and quotaoff items as tehy are recorded
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
when it was not entirely clear how item validation would end u
plooking. In the end, it is used by only one special item type:
the transaction header.

->validate_item() already runs on every item at that same point, so
->complete() probably should be folded into it. ->validate_item()
would perform the header copy and signal that the item is consumed,
removing the need for ->complete() altogether.

Commits:
28f113a   xfs: set the unmount record operation header length
a61b098   xfs: add log recovery item validation design document
06c7593   xfs: lift transaction header parsing out of the region assembly
a68100c   xfs: track transaction header decode state explicitly
24e21ca   xfs: track the log item being rebuilt with an explicit pointer
d91765d   xfs: complete log items explicitly during recovery
1927333   xfs: add log item validation infrastructure to log recovery
cacb405   xfs: recover the transaction header as a validated item type
0703ad7   xfs: factor out xlog_recover_validate_ophdr()
fc50f95   xfs: validate operation header length and alignment during recovery
3d16b7b   xfs: validate the operation header padding during recovery
fe25cc9   xfs: validate the operation header flags during recovery
c2268a5   xfs: enforce zero length control records during recovery
7ea3fb8   xfs: validate the unmount record during recovery
dfd687d   xfs: handle zero length continuation op headers during recovery
74f2613   xfs: bound the assembled region size during recovery
1de7ba8   xfs: dump the corrupt region when log item validation fails
3c87e627   xfs: validate fixed size log items during recovery
8a79bbf   xfs: validate extent free log items during recovery
1bb8381   xfs: validate and convert extent free intents during recovery
426c695   xfs: validate and convert extent free done items during recovery
425e959   xfs: validate rmap update intents during recovery
2549fef   xfs: validate rmap update done items during recovery
80bb17f   xfs: validate refcount update intents during recovery
d10d3f8   xfs: validate refcount update done items during recovery
6061b3b   xfs: validate bmap update intents during recovery
aa3c496   xfs: validate bmap update done items during recovery
27521ef   xfs: validate mapping exchange intents during recovery
3773819   xfs: validate mapping exchange done items during recovery
e3b1f31   xfs: validate dquot items during recovery
96008da   xfs: validate attr done items during recovery
b21e835   xfs: validate attr intents during recovery
e91bfa9   xfs: convert inode items to host format during recovery
2a6df3a   xfs: allow xfs_imap() to map without an inode btree lookup
c661e55   xfs: validate the inode item format header during recovery
71dd594   xfs: validate the logged inode core during recovery
0a30aae   xfs: validate the logged inode forks during recovery
e1d4af6   xfs: validate logged local fork contents during recovery
88362e8   xfs: validate logged extent fork contents during recovery
1f1bb06   xfs: allow a long format btree root to be checked without a cursor
7e1242f   xfs: validate logged btree fork roots during recovery
34f073c   xfs: validate logged metadata btree fork roots during recovery
4a383f7   xfs: validate buffer item region count during recovery
9503237   xfs: validate buffer item regions during recovery
cc5eed7   xfs: validate the whole buffer item during recovery
f5855c0   xfs: remove redundant buffer checks from recovery replay
e0a8bd9   xfs: fail recovery on a buffer type mismatch
44cad35   xfs: validate logged dquot buffers during recovery

Diffstat:
 Documentation/filesystems/xfs/index.rst                              |   1 +-
 Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst | 514 ++++-
 fs/xfs/libxfs/xfs_bmap.c                                             |  48 +-
 fs/xfs/libxfs/xfs_bmap.h                                             |   8 +-
 fs/xfs/libxfs/xfs_btree.c                                            |  50 +-
 fs/xfs/libxfs/xfs_btree.h                                            |   4 +-
 fs/xfs/libxfs/xfs_dquot_buf.c                                        |  64 +-
 fs/xfs/libxfs/xfs_format.h                                           |   8 +-
 fs/xfs/libxfs/xfs_ialloc.c                                           |   7 +-
 fs/xfs/libxfs/xfs_inode_buf.c                                        |  19 +-
 fs/xfs/libxfs/xfs_inode_buf.h                                        |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c                                       |  25 +-
 fs/xfs/libxfs/xfs_log_format.h                                       |   8 +-
 fs/xfs/libxfs/xfs_log_recover.h                                      |  64 +-
 fs/xfs/libxfs/xfs_quota_defs.h                                       |   2 +-
 fs/xfs/scrub/inode_repair.c                                          |  14 +-
 fs/xfs/xfs_attr_item.c                                               | 283 +-
 fs/xfs/xfs_bmap_item.c                                               | 109 +-
 fs/xfs/xfs_buf_item_recover.c                                        | 349 +-
 fs/xfs/xfs_dquot_item_recover.c                                      | 118 +-
 fs/xfs/xfs_exchmaps_item.c                                           |  46 +-
 fs/xfs/xfs_extfree_item.c                                            | 368 ++-
 fs/xfs/xfs_icache.h                                                  |   2 +-
 fs/xfs/xfs_icreate_item.c                                            |  18 +-
 fs/xfs/xfs_inode.h                                                   |  43 +-
 fs/xfs/xfs_inode_item_recover.c                                      | 979 +++++--
 fs/xfs/xfs_log.c                                                     |  16 +-
 fs/xfs/xfs_log_recover.c                                             | 764 ++++-
 fs/xfs/xfs_refcount_item.c                                           | 163 +-
 fs/xfs/xfs_rmap_item.c                                               | 163 +-
 30 files changed, 3410 insertions(+), 849 deletions(-)
