Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB09C6FD1F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 01:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCOBM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 21:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjCOBM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 21:12:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBF823C7C
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 18:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8042D619FD
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 01:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D8FC433D2;
        Wed, 15 Mar 2023 01:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678842744;
        bh=/OqZPaOQlhCbRjWXehP0oMlc1ALV9n0q9H8iQmQ34hU=;
        h=Date:From:To:Cc:Subject:From;
        b=B68mW1Axzg5gPktYjdaPleTnAAaOf4PKQbr1UB/IAd0u2QxcyoHmdvcV/rH9eFGsv
         Dh2bemlDP0IlzvSMo1zdCsmUYMTU5M/EkEl3ZxDwZt5alEsZlXCs00HT/o1C5qSL64
         mN1E/PmMnhq0gVLyed7IyL9Ao9Datq1KgxBoHpwlYJveBV/TbLPHM/hBtS5t3QR01a
         eoajyboZTCp4Z8uu2DYTzRm3pJGRnu2nGXf9Sw+j7oOPlLmrX7nZDy6C+ZkBXXBdMy
         WgP39C54FrktwfH0smclIKhmcy0VFeX96/UIq+d47ndD6P7AJvVUg/tqBUEvxfB1HX
         OLpzcD69Brt9Q==
Date:   Tue, 14 Mar 2023 18:12:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, david@fromorbit.com,
        dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [PIEDAY DELUGE 1/2] xfs: all pending online scrub improvements
Message-ID: <167884232811.2505918.13398436528509703313.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave et. al.,

As promised, here's the rebase against 6.3-rc2 of the online fsck design
documentation and all pending scrub fixes.  I've included all of
Allison's feedback about the design doc, along with the various bits
that Dave commented on in #xfs.

(This isn't a true deluge, since I'm only posting this notice, not the
entire patchset.)

--D

The following changes since commit eeac8ede17557680855031c6f305ece2378af326:

Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-strengthen-rmap-checking_2023-03-14

for you to read changes up to 5023db0fd78213c4d9a5e6c027c6f9b55dc1fdc9:

xfs: cross-reference rmap records with refcount btrees (2023-03-14 17:44:07 -0700)

----------------------------------------------------------------
xfs: strengthen rmapbt scrubbing

This series strengthens space allocation record cross referencing by
using AG block bitmaps to compute the difference between space used
according to the rmap records and the primary metadata, and reports
cross-referencing errors for any discrepancies.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (97):
xfs: try to idiot-proof the allocators
xfs: recheck appropriateness of map_shared lock
xfs: document the motivation for online fsck design
xfs: document the general theory underlying online fsck design
xfs: document the testing plan for online fsck
xfs: document the user interface for online fsck
xfs: document the filesystem metadata checking strategy
xfs: document how online fsck deals with eventual consistency
xfs: document pageable kernel memory
xfs: document btree bulk loading
xfs: document online file metadata repair code
xfs: document full filesystem scans for online fsck
xfs: document metadata file repair
xfs: document directory tree repairs
xfs: document the userspace fsck driver program
xfs: document future directions of online fsck
xfs: give xfs_bmap_intent its own perag reference
xfs: pass per-ag references to xfs_free_extent
xfs: give xfs_extfree_intent its own perag reference
xfs: give xfs_rmap_intent its own perag reference
xfs: give xfs_refcount_intent its own perag reference
xfs: create traced helper to get extra perag references
xfs: fix author and spdx headers on scrub/ files
xfs: update copyright years for scrub/ files
xfs: add a tracepoint to report incorrect extent refcounts
xfs: allow queued AG intents to drain before scrubbing
xfs: clean up scrub context if scrub setup returns -EDEADLOCK
xfs: minimize overhead of drain wakeups by using jump labels
xfs: scrub should use ECHRNG to signal that the drain is needed
xfs: standardize ondisk to incore conversion for free space btrees
xfs: standardize ondisk to incore conversion for inode btrees
xfs: standardize ondisk to incore conversion for refcount btrees
xfs: return a failure address from xfs_rmap_irec_offset_unpack
xfs: standardize ondisk to incore conversion for rmap btrees
xfs: standardize ondisk to incore conversion for bmap btrees
xfs: complain about bad records in query_range helpers
xfs: complain about bad file mapping records in the ondisk bmbt
xfs: hoist rmap record flag checks from scrub
xfs: hoist rmap record flag checks from scrub
xfs: hoist inode record alignment checks from scrub
xfs: fix rm_offset flag handling in rmap keys
xfs: detect unwritten bit set in rmapbt node block keys
xfs: check btree keys reflect the child block
xfs: always scrub record/key order of interior records
xfs: refactor converting btree irec to btree key
xfs: refactor ->diff_two_keys callsites
xfs: replace xfs_btree_has_record with a general keyspace scanner
xfs: implement masked btree key comparisons for _has_records scans
xfs: check the reference counts of gaps in the refcount btree
xfs: ensure that all metadata and data blocks are not cow staging extents
xfs: remove pointless shadow variable from xfs_difree_inobt
xfs: clean up broken eearly-exit code in the inode btree scrubber
xfs: directly cross-reference the inode btrees with each other
xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results
xfs: teach scrub to check for sole ownership of metadata objects
xfs: ensure that single-owner file blocks are not owned by others
xfs: streamline the directory iteration code for scrub
xfs: xfs_iget in the directory scrubber needs to use UNTRUSTED
xfs: always check the existence of a dirent's child inode
xfs: remove xchk_parent_count_parent_dentries
xfs: simplify xchk_parent_validate
xfs: fix parent pointer scrub racing with subdirectory reparenting
xfs: manage inode DONTCACHE status at irele time
xfs: fix an inode lookup race in xchk_get_inode
xfs: rename xchk_get_inode -> xchk_iget_for_scrubbing
xfs: retain the AGI when we can't iget an inode to scrub the core
xfs: don't take the MMAPLOCK when scrubbing file metadata
xfs: change bmap scrubber to store the previous mapping
xfs: accumulate iextent records when checking bmap
xfs: split xchk_bmap_xref_rmap into two functions
xfs: alert the user about data/attr fork mappings that could be merged
xfs: split the xchk_bmap_check_rmaps into a predicate
xfs: don't call xchk_bmap_check_rmaps for btree-format file forks
xfs: flag free space btree records that could be merged
xfs: flag refcount btree records that could be merged
xfs: check overlapping rmap btree records
xfs: check for reverse mapping records that could be merged
xfs: xattr scrub should ensure one namespace bit per name
xfs: don't shadow @leaf in xchk_xattr_block
xfs: remove unnecessary dstmap in xattr scrubber
xfs: split freemap from xchk_xattr_buf.buf
xfs: split usedmap from xchk_xattr_buf.buf
xfs: split valuebuf from xchk_xattr_buf.buf
xfs: remove flags argument from xchk_setup_xattr_buf
xfs: move xattr scrub buffer allocation to top level function
xfs: check used space of shortform xattr structures
xfs: clean up xattr scrub initialization
xfs: only allocate free space bitmap for xattr scrub if needed
xfs: don't load local xattr values during scrub
xfs: remove the for_each_xbitmap_ helpers
xfs: drop the _safe behavior from the xbitmap foreach macro
xfs: convert xbitmap to interval tree
xfs: introduce bitmap type for AG blocks
xfs: cross-reference rmap records with ag btrees
xfs: cross-reference rmap records with free space btrees
xfs: cross-reference rmap records with inode btrees
xfs: cross-reference rmap records with refcount btrees

Documentation/filesystems/index.rst                |    1 +
.../filesystems/xfs-online-fsck-design.rst         | 5315 ++++++++++++++++++++
.../filesystems/xfs-self-describing-metadata.rst   |    1 +
fs/xfs/Kconfig                                     |    5 +
fs/xfs/Makefile                                    |    5 +-
fs/xfs/libxfs/xfs_ag.c                             |   23 +-
fs/xfs/libxfs/xfs_ag.h                             |    9 +
fs/xfs/libxfs/xfs_alloc.c                          |  128 +-
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
fs/xfs/scrub/dir.c                                 |  239 +-
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
76 files changed, 10300 insertions(+), 1793 deletions(-)
create mode 100644 Documentation/filesystems/xfs-online-fsck-design.rst
create mode 100644 fs/xfs/scrub/readdir.c
create mode 100644 fs/xfs/scrub/readdir.h
create mode 100644 fs/xfs/xfs_drain.c
create mode 100644 fs/xfs/xfs_drain.h
