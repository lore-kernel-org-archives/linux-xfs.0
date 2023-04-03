Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DDDC76196
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Apr 2023 17:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbjDCR4R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Apr 2023 13:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjDCR4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2023 13:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C9A2134
        for <linux-xfs@vger.kernel.org>; Mon,  3 Apr 2023 10:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A34A7623E9
        for <linux-xfs@vger.kernel.org>; Mon,  3 Apr 2023 17:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040A9C433EF;
        Mon,  3 Apr 2023 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680544558;
        bh=i4rmrQC5h8NKRlfWoGShotpwCdeYFG96RAXpbLE4P5g=;
        h=Date:From:To:Cc:Subject:From;
        b=Qj2IH/PBkXn/Nlmtum27kckUtFQO7a/YqkCWykcvZkpAz3m3VNJ7b8+rff5y4pgVe
         nT3yTUGwCwAkjg4MhhoB/e0aR8Xrj3bgE5ZDeEMELBkPjqC7eIPeGr+CKHMKKVj0sT
         4ydrOgtDzlnRKwjxIxKwl4WvpVtqVFHfeSco26JpaEXQYI+DepEfyyAI1qH5PDBccZ
         a9mYopPFDWxnCFEPMbxQlHcpcTv9mmkllTwgBSfH9T+HSZ49X51s9nFf07wyZyfI3x
         bjFhXQhpiK7uM2O0HYmTtcL0YjeTMVYW8dbr2Iyz8l6eZ9X3bCnFcjpM0mh5A7to/z
         Bux0x55yp46Kg==
Date:   Mon, 3 Apr 2023 10:55:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, david@fromorbit.com,
        dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE 1/2] xfs-linux: scrub-strengthen-rmap-checking updated to
 64e6494e1175
Message-ID: <168054442640.1440442.6704636180612529931.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The scrub-strengthen-rmap-checking branch of my xfs-linux repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git

has just been updated for your review.

This code snapshot has been rebased against recent upstream, freshly
QA'd, and is ready for people to examine.  For veteran readers, the new
snapshot can be diffed against the previous snapshot; and for new
readers, this is a reasonable place to begin reading.  For the best
experience, it is recommended to pull this branch and walk the commits
instead of trying to read any patch deluge.

Here's the rebase against 6.3-rc5 of the online fsck design
documentation and all pending scrub fixes.  I've fixed most of the
low-hanging fruit that Dave commented on in #xfs.

(This isn't a true deluge, since I'm only posting this notice, not the
entire patchset.)

--D

The new head of the scrub-strengthen-rmap-checking branch is commit:

64e6494e1175 xfs: cross-reference rmap records with refcount btrees

97 new commits:

Darrick J. Wong (97):
[72fbe354dfdb] xfs: recheck appropriateness of map_shared lock
[c9d1554c0501] xfs: document the motivation for online fsck design
[0dda9d199aa5] xfs: document the general theory underlying online fsck design
[fb4996620b84] xfs: document the testing plan for online fsck
[19c233a7dde3] xfs: document the user interface for online fsck
[4adc468632ad] xfs: document the filesystem metadata checking strategy
[1fa18595ebfd] xfs: document how online fsck deals with eventual consistency
[3418a2028af6] xfs: document pageable kernel memory
[0e9bcebde01f] xfs: document btree bulk loading
[3e7bf1081354] xfs: document online file metadata repair code
[1fe9bb9f8eb4] xfs: document full filesystem scans for online fsck
[26f39fdd02d3] xfs: document metadata file repair
[2c785e1136ae] xfs: document directory tree repairs
[b869e0b422b5] xfs: document the userspace fsck driver program
[e3802ced46b6] xfs: document future directions of online fsck
[0ed6304cde18] xfs: give xfs_bmap_intent its own perag reference
[bdca431554f3] xfs: pass per-ag references to xfs_free_extent
[84ba240b3a29] xfs: give xfs_extfree_intent its own perag reference
[300a03696a71] xfs: give xfs_rmap_intent its own perag reference
[aada647c184e] xfs: give xfs_refcount_intent its own perag reference
[c538f0926008] xfs: create traced helper to get extra perag references
[b447094155ec] xfs: fix author and spdx headers on scrub/ files
[605067183636] xfs: update copyright years for scrub/ files
[d958bdca3735] xfs: add a tracepoint to report incorrect extent refcounts
[508ddbc24d0a] xfs: allow queued AG intents to drain before scrubbing
[5a82c4b24677] xfs: clean up scrub context if scrub setup returns -EDEADLOCK
[029779148faa] xfs: minimize overhead of drain wakeups by using jump labels
[2551eb3a2746] xfs: scrub should use ECHRNG to signal that the drain is needed
[30cf339a533e] xfs: standardize ondisk to incore conversion for free space btrees
[07163f7fd4fd] xfs: standardize ondisk to incore conversion for inode btrees
[4df6f1edec79] xfs: standardize ondisk to incore conversion for refcount btrees
[148298f5f868] xfs: return a failure address from xfs_rmap_irec_offset_unpack
[0c9db3bdc483] xfs: standardize ondisk to incore conversion for rmap btrees
[3a6ffc9ee3fa] xfs: standardize ondisk to incore conversion for bmap btrees
[ae9eac9ce702] xfs: complain about bad records in query_range helpers
[4147f4c60668] xfs: complain about bad file mapping records in the ondisk bmbt
[fdbd84ea2e5e] xfs: hoist rmap record flag checks from scrub
[5e4d750c9ac4] xfs: hoist rmap record flag checks from scrub
[e50e072a525d] xfs: hoist inode record alignment checks from scrub
[310ecc144f61] xfs: fix rm_offset flag handling in rmap keys
[e47472fe7462] xfs: detect unwritten bit set in rmapbt node block keys
[a135f419d21d] xfs: check btree keys reflect the child block
[0fcb7efbc142] xfs: always scrub record/key order of interior records
[29efa3a26c42] xfs: refactor converting btree irec to btree key
[b90558e2ccff] xfs: refactor ->diff_two_keys callsites
[cddb89edabdc] xfs: replace xfs_btree_has_record with a general keyspace scanner
[167f52f5ca7d] xfs: implement masked btree key comparisons for _has_records scans
[1bc7e251ac96] xfs: check the reference counts of gaps in the refcount btree
[caeb0aaef3c3] xfs: ensure that all metadata and data blocks are not cow staging extents
[684b9d2f2a81] xfs: remove pointless shadow variable from xfs_difree_inobt
[e42473f15ace] xfs: clean up broken eearly-exit code in the inode btree scrubber
[71c1b5031031] xfs: directly cross-reference the inode btrees with each other
[20c2edb12081] xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results
[6e44ba864c2a] xfs: teach scrub to check for sole ownership of metadata objects
[2ff244fb361b] xfs: ensure that single-owner file blocks are not owned by others
[f32305443791] xfs: use the directory name hash function for dir scrubbing
[11768fd3f603] xfs: streamline the directory iteration code for scrub
[703c77196f31] xfs: xfs_iget in the directory scrubber needs to use UNTRUSTED
[a17d01d367d2] xfs: always check the existence of a dirent's child inode
[3c1ac389a5f6] xfs: remove xchk_parent_count_parent_dentries
[01bb203da1e9] xfs: simplify xchk_parent_validate
[a7add111aed0] xfs: fix parent pointer scrub racing with subdirectory reparenting
[49c2cac1107b] xfs: manage inode DONTCACHE status at irele time
[40f492c70956] xfs: fix an inode lookup race in xchk_get_inode
[30f6ee067c58] xfs: rename xchk_get_inode -> xchk_iget_for_scrubbing
[8feaa56c4265] xfs: retain the AGI when we can't iget an inode to scrub the core
[72b784b1cf0e] xfs: don't take the MMAPLOCK when scrubbing file metadata
[4d18439b35bf] xfs: change bmap scrubber to store the previous mapping
[2ef761994c57] xfs: accumulate iextent records when checking bmap
[5b34b7f8d76a] xfs: split xchk_bmap_xref_rmap into two functions
[147691608399] xfs: alert the user about data/attr fork mappings that could be merged
[8b710c34d386] xfs: split the xchk_bmap_check_rmaps into a predicate
[ddb9cc650dbe] xfs: don't call xchk_bmap_check_rmaps for btree-format file forks
[2941cfdc5931] xfs: flag free space btree records that could be merged
[8459648bab9d] xfs: flag refcount btree records that could be merged
[5449f5039ccf] xfs: check overlapping rmap btree records
[05121c793bc8] xfs: check for reverse mapping records that could be merged
[39180c555d14] xfs: xattr scrub should ensure one namespace bit per name
[080fa570391c] xfs: don't shadow @leaf in xchk_xattr_block
[11cb9a2a781b] xfs: remove unnecessary dstmap in xattr scrubber
[7f2ddb3b3822] xfs: split freemap from xchk_xattr_buf.buf
[d246347d5dd3] xfs: split usedmap from xchk_xattr_buf.buf
[2d3fed6908c9] xfs: split valuebuf from xchk_xattr_buf.buf
[362cbc9b193a] xfs: remove flags argument from xchk_setup_xattr_buf
[23ec63d1de61] xfs: move xattr scrub buffer allocation to top level function
[f4e22450808f] xfs: check used space of shortform xattr structures
[717dd0d4a6aa] xfs: clean up xattr scrub initialization
[d50daa5387bf] xfs: only allocate free space bitmap for xattr scrub if needed
[870c933db4ee] xfs: don't load local xattr values during scrub
[a05df63c99cb] xfs: remove the for_each_xbitmap_ helpers
[b6fb3e30b78f] xfs: drop the _safe behavior from the xbitmap foreach macro
[c4b5e6881b57] xfs: convert xbitmap to interval tree
[2e707cecc4ba] xfs: introduce bitmap type for AG blocks
[c4d61ae4a08e] xfs: cross-reference rmap records with ag btrees
[47a3c70862d3] xfs: cross-reference rmap records with free space btrees
[90fd11721cd4] xfs: cross-reference rmap records with inode btrees
[64e6494e1175] xfs: cross-reference rmap records with refcount btrees

Code Diffstat:

Documentation/filesystems/index.rst                |    1 +
.../filesystems/xfs-online-fsck-design.rst         | 5315 ++++++++++++++++++++
.../filesystems/xfs-self-describing-metadata.rst   |    1 +
fs/xfs/Kconfig                                     |    5 +
fs/xfs/Makefile                                    |    5 +-
fs/xfs/libxfs/xfs_ag.c                             |   23 +-
fs/xfs/libxfs/xfs_ag.h                             |    9 +
fs/xfs/libxfs/xfs_alloc.c                          |  115 +-
fs/xfs/libxfs/xfs_alloc.h                          |   22 +-
fs/xfs/libxfs/xfs_alloc_btree.c                    |   32 +-
fs/xfs/libxfs/xfs_bmap.c                           |   32 +-
fs/xfs/libxfs/xfs_bmap.h                           |    8 +-
fs/xfs/libxfs/xfs_bmap_btree.c                     |   19 +-
fs/xfs/libxfs/xfs_btree.c                          |  208 +-
fs/xfs/libxfs/xfs_btree.h                          |  141 +-
fs/xfs/libxfs/xfs_defer.c                          |    6 +-
fs/xfs/libxfs/xfs_ialloc.c                         |  165 +-
fs/xfs/libxfs/xfs_ialloc.h                         |    7 +-
fs/xfs/libxfs/xfs_ialloc_btree.c                   |   35 +-
fs/xfs/libxfs/xfs_ialloc_btree.h                   |    2 +-
fs/xfs/libxfs/xfs_inode_fork.c                     |    3 +-
fs/xfs/libxfs/xfs_refcount.c                       |  117 +-
fs/xfs/libxfs/xfs_refcount.h                       |   10 +-
fs/xfs/libxfs/xfs_refcount_btree.c                 |   31 +-
fs/xfs/libxfs/xfs_rmap.c                           |  364 +-
fs/xfs/libxfs/xfs_rmap.h                           |   38 +-
fs/xfs/libxfs/xfs_rmap_btree.c                     |  102 +-
fs/xfs/libxfs/xfs_types.h                          |   12 +
fs/xfs/scrub/agheader.c                            |   30 +-
fs/xfs/scrub/agheader_repair.c                     |  105 +-
fs/xfs/scrub/alloc.c                               |   69 +-
fs/xfs/scrub/attr.c                                |  312 +-
fs/xfs/scrub/attr.h                                |   64 +-
fs/xfs/scrub/bitmap.c                              |  428 +-
fs/xfs/scrub/bitmap.h                              |  109 +-
fs/xfs/scrub/bmap.c                                |  426 +-
fs/xfs/scrub/btree.c                               |  102 +-
fs/xfs/scrub/btree.h                               |   16 +-
fs/xfs/scrub/common.c                              |  454 +-
fs/xfs/scrub/common.h                              |   32 +-
fs/xfs/scrub/dabtree.c                             |    7 +-
fs/xfs/scrub/dabtree.h                             |    6 +-
fs/xfs/scrub/dir.c                                 |  246 +-
fs/xfs/scrub/fscounters.c                          |   11 +-
fs/xfs/scrub/health.c                              |    8 +-
fs/xfs/scrub/health.h                              |    6 +-
fs/xfs/scrub/ialloc.c                              |  304 +-
fs/xfs/scrub/inode.c                               |  197 +-
fs/xfs/scrub/parent.c                              |  314 +-
fs/xfs/scrub/quota.c                               |    9 +-
fs/xfs/scrub/readdir.c                             |  375 ++
fs/xfs/scrub/readdir.h                             |   19 +
fs/xfs/scrub/refcount.c                            |  193 +-
fs/xfs/scrub/repair.c                              |  112 +-
fs/xfs/scrub/repair.h                              |    7 +-
fs/xfs/scrub/rmap.c                                |  586 ++-
fs/xfs/scrub/rtbitmap.c                            |    6 +-
fs/xfs/scrub/scrub.c                               |   74 +-
fs/xfs/scrub/scrub.h                               |   32 +-
fs/xfs/scrub/symlink.c                             |    6 +-
fs/xfs/scrub/trace.c                               |    6 +-
fs/xfs/scrub/trace.h                               |   75 +-
fs/xfs/scrub/xfs_scrub.h                           |    6 +-
fs/xfs/xfs_bmap_item.c                             |   39 +-
fs/xfs/xfs_drain.c                                 |  135 +
fs/xfs/xfs_drain.h                                 |   80 +
fs/xfs/xfs_extfree_item.c                          |   56 +-
fs/xfs/xfs_icache.c                                |    3 +-
fs/xfs/xfs_icache.h                                |   11 +-
fs/xfs/xfs_inode.c                                 |   29 +
fs/xfs/xfs_iunlink_item.c                          |    4 +-
fs/xfs/xfs_iwalk.c                                 |    5 +-
fs/xfs/xfs_linux.h                                 |    1 +
fs/xfs/xfs_refcount_item.c                         |   38 +-
fs/xfs/xfs_rmap_item.c                             |   34 +-
fs/xfs/xfs_trace.h                                 |   72 +
76 files changed, 10293 insertions(+), 1794 deletions(-)
create mode 100644 Documentation/filesystems/xfs-online-fsck-design.rst
create mode 100644 fs/xfs/scrub/readdir.c
create mode 100644 fs/xfs/scrub/readdir.h
create mode 100644 fs/xfs/xfs_drain.c
create mode 100644 fs/xfs/xfs_drain.h
