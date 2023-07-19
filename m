Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA9CEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 14:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjGSO3r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 10:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjGSO3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 10:29:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF351D3
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 07:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B4606171C
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 14:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F808C433CD
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689776983;
        bh=RmMfCgMSmPiNXEJvPEgiZ/8o+QTZR0swGVsqlHc9g3c=;
        h=Date:From:To:Subject:From;
        b=GyPX860ZBMwNRggVLh7wjkn4EZpV42NATsajnXq97/GzLv7zKuTpDRI72NgvCVSg6
         Pz7x5vjvVz+CCAaSR1kbHvJLghv3UhpaeF2tSzK2HXh2quJZFT23ovVLBLUy2BRDbe
         kmiWg/oPwuefXA+cws2QrjjO9zAmNqOyJpSunWK5lapgGihgz3ktL+eKlDyCOOMv63
         0T0KGQ9cox+SLMytCJoNRWc01P2z6pknyHCiBw01TnScC7v/hCyfdT9f+dlnY7AYu7
         InT8yEOdKH1tsJeiFusmRA5dIoZYopS/wddJtNFQNtNV6t8FTrOjYDYMZhunC9kyLT
         5tMj7LWwNpVdA==
Date:   Wed, 19 Jul 2023 16:29:39 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: xfsprogs-6.4.0 released
Message-ID: <20230719142939.gewzxvuc2nufotcn@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs repository, located at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to reflect the state of master

I also cleaned up a bit some stale tags that got pushed by accident, by
different people (me included), usually a result of using --tags instead of
--follow-tags.

Any question, let me know


The new head of the master branch is commit:

bacc3981d747ee33c13023426c22bdfb72c5a04d

New Commits:


Carlos Maiolino (2):
      [361001978] libxfs: Finish renaming xfs_extent_item variables
      [bacc3981d] xfsprogs: Release v6.4.0

Darrick J. Wong (51):
      [32debad7c] xfs: give xfs_bmap_intent its own perag reference
      [42c1e5c18] xfs: pass per-ag references to xfs_free_extent
      [7fef0c111] xfs: give xfs_extfree_intent its own perag reference
      [818f0c29d] xfs: give xfs_rmap_intent its own perag reference
      [b2c5c83de] xfs: give xfs_refcount_intent its own perag reference
      [11e716f40] xfs: create traced helper to get extra perag references
      [7cb26322f] xfs: allow queued AG intents to drain before scrubbing
      [c7005aef1] xfs: standardize ondisk to incore conversion for free space btrees
      [349aa6876] xfs: standardize ondisk to incore conversion for inode btrees
      [03d1a8719] xfs: standardize ondisk to incore conversion for refcount btrees
      [8d444a7a7] xfs: return a failure address from xfs_rmap_irec_offset_unpack
      [fd1d74cd6] xfs: standardize ondisk to incore conversion for rmap btrees
      [e70bf9ba9] xfs: complain about bad records in query_range helpers
      [7e7856cee] xfs: hoist rmap record flag checks from scrub
      [830c99b18] xfs: complain about bad file mapping records in the ondisk bmbt
      [b3c8146ec] xfs: hoist rmap record flag checks from scrub
      [71ba9fcca] xfs: hoist inode record alignment checks from scrub
      [c2d269677] xfs: fix rm_offset flag handling in rmap keys
      [98226d914] xfs: refactor converting btree irec to btree key
      [e3b15d883] xfs: refactor ->diff_two_keys callsites
      [9ba4dc828] xfs: replace xfs_btree_has_record with a general keyspace scanner
      [d99b89009] xfs: implement masked btree key comparisons for _has_records scans
      [725589ab4] xfs: remove pointless shadow variable from xfs_difree_inobt
      [54644f251] xfs: teach scrub to check for sole ownership of metadata objects
      [fc78c405d] xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results
      [898c05518] xfs: accumulate iextent records when checking bmap
      [bd970a739] xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation
      [0bf7f8c31] xfs: _{attr,data}_map_shared should take ILOCK_EXCL until iread_extents is completely done
      [2897a1c2f] xfs: don't unconditionally null args->pag in xfs_bmap_btalloc_at_eof
      [7901c8c1a] xfs: set bnobt/cntbt numrecs correctly when formatting new AGs
      [03f97ae49] libxfs: test the ascii case-insensitive hash
      [cb8c70b01] xfs_db: move obfuscate_name assertion to callers
      [10a01bcdd] xfs_db: fix metadump name obfuscation for ascii-ci filesystems
      [5309ddc05] mkfs.xfs.8: warn about the version=ci feature
      [6a5285ec1] mkfs: deprecate the ascii-ci feature
      [2b686ab31] xfs_db: hoist name obfuscation code out of metadump.c
      [c51c8c857] xfs_db: create dirents and xattrs with colliding names
      [47560612f] xfs_db: make the hash command print the dirent hash
      [4d3226b6e] libxfs: deferred items should call xfs_perag_intent_{get,put}
      [c6b593ee4] libxfs: port list_cmp_func_t to userspace
      [05a3a3895] libxfs: port transaction precommit hooks to userspace
      [67f541056] xfs_repair: don't spray correcting imap all by itself
      [2618b37ae] xfs_repair: don't log inode problems without printing resolution
      [d159552bb] xfs_repair: fix messaging when shortform_dir2_junk is called
      [beb78d755] xfs_repair: fix messaging in longform_dir2_entry_check_data
      [1e12a0751] xfs_repair: fix messaging when fixing imap due to sparse cluster
      [aca026248] xfs_repair: don't add junked entries to the rebuilt directory
      [dafa78c9a] xfs_repair: always perform extended xattr checks on uncertain inodes
      [4a16ce683] xfs_repair: check low keys of rmap btrees
      [ad662cc17] xfs_repair: warn about unwritten bits set in rmap btree keys
      [10139046b] xfs_db: expose the unwritten flag in rmapbt keys

Dave Chinner (7):
      [44b2e0dea] xfs: don't consider future format versions valid
      [87ab47e1f] xfs: fix livelock in delayed allocation at ENOSPC
      [8b2a40fff] xfs: restore allocation trylock iteration
      [a565e3456] xfs: fix AGF vs inode cluster buffer deadlock
      [daa2d8205] xfs: fix agf/agfl verification on v4 filesystems
      [629d6b3df] xfs: validity check agbnos on the AGFL
      [cd3e5d3cf] xfs: validate block number being freed before adding to xefi

David Seifert (1):
      [987373623] po: Fix invalid .de translation format string

Pavel Reichl (1):
      [965f91091] mkfs: fix man's default value for sparse option

Weifeng Su (1):
      [0babf94ff] libxcmd: add return value check for dynamic memory function

Code Diffstat:


 VERSION                     |   2 +-
 configure.ac                |   2 +-
 db/Makefile                 |   2 +-
 db/btblock.c                |   4 +
 db/hash.c                   | 418 +++++++++++++++++++++++++++++++++++++++++++-
 db/metadump.c               | 372 +++------------------------------------
 db/obfuscate.c              | 393 +++++++++++++++++++++++++++++++++++++++++
 db/obfuscate.h              |  17 ++
 debian/changelog            |   6 +
 doc/CHANGES                 |  17 ++
 include/atomic.h            | 100 +++++++++++
 include/list.h              |   7 +-
 include/platform_defs.h.in  |  20 +++
 include/xfs_inode.h         |   3 +-
 include/xfs_mount.h         |  11 ++
 include/xfs_trace.h         |   4 +
 include/xfs_trans.h         |   7 +
 libfrog/dahashselftest.h    | 208 +++++++++++-----------
 libfrog/list_sort.c         |  10 +-
 libxcmd/command.c           |   4 +
 libxfs/defer_item.c         | 203 +++++++++++++++------
 libxfs/libxfs_api_defs.h    |   2 +
 libxfs/libxfs_priv.h        |  27 +--
 libxfs/logitem.c            | 165 ++++++++++++++++-
 libxfs/trans.c              |  96 ++++++++++
 libxfs/util.c               |   4 +-
 libxfs/xfs_ag.c             |  47 +++--
 libxfs/xfs_ag.h             |   9 +
 libxfs/xfs_alloc.c          | 206 +++++++++++++++-------
 libxfs/xfs_alloc.h          |  28 ++-
 libxfs/xfs_alloc_btree.c    |  32 +++-
 libxfs/xfs_bmap.c           |  54 +++++-
 libxfs/xfs_bmap.h           |   8 +-
 libxfs/xfs_bmap_btree.c     |  26 ++-
 libxfs/xfs_btree.c          | 204 +++++++++++++++------
 libxfs/xfs_btree.h          | 141 ++++++++++++++-
 libxfs/xfs_defer.c          |   6 +-
 libxfs/xfs_dir2.c           |   5 +-
 libxfs/xfs_dir2.h           |  31 ++++
 libxfs/xfs_ialloc.c         | 189 +++++++++++++-------
 libxfs/xfs_ialloc.h         |   7 +-
 libxfs/xfs_ialloc_btree.c   |  35 +++-
 libxfs/xfs_ialloc_btree.h   |   2 +-
 libxfs/xfs_inode_fork.c     |  19 +-
 libxfs/xfs_inode_fork.h     |   6 +-
 libxfs/xfs_log_format.h     |   9 +-
 libxfs/xfs_refcount.c       | 130 ++++++++------
 libxfs/xfs_refcount.h       |  10 +-
 libxfs/xfs_refcount_btree.c |  31 +++-
 libxfs/xfs_rmap.c           | 358 +++++++++++++++++++++++++------------
 libxfs/xfs_rmap.h           |  38 +++-
 libxfs/xfs_rmap_btree.c     | 102 ++++++++---
 libxfs/xfs_sb.c             |  11 +-
 libxfs/xfs_trans_inode.c    | 113 +-----------
 libxfs/xfs_types.h          |  12 ++
 man/man8/mkfs.xfs.8.in      |  25 ++-
 man/man8/xfs_db.8           |  39 ++++-
 mkfs/xfs_mkfs.c             |  11 ++
 po/de.po                    |   2 +-
 repair/dino_chunks.c        |  14 +-
 repair/phase5.c             |  10 +-
 repair/phase6.c             |  46 +++--
 repair/scan.c               |  60 ++++++-
 scrub/repair.c              |  12 +-
 64 files changed, 3032 insertions(+), 1160 deletions(-)
 create mode 100644 db/obfuscate.c
 create mode 100644 db/obfuscate.h


-- 
Carlos
