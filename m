Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D376BC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 18:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDKSaB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDKSaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 14:30:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA09BD
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 11:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A7EE62AD5
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 18:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974CFC433EF;
        Tue, 11 Apr 2023 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681237798;
        bh=D/OFtA6NunmxwnmZrpRF2zMkZLLAF6CMjUXnL9MbzgI=;
        h=Date:From:To:Cc:Subject:From;
        b=ZgM6HUOWUZCpENqg5byP89jfv8HBkkwYPj6TtC8mxgxBK4wCXgAW/7IGVVGQGfeNS
         nY+xTvdVLfG6H+SO1EyeZAqbNX7QXDgpUK5FUAI9R6rA+xLXwwxsxZDoBTwyP4BZri
         qizWFhT+Yd9RfSRBihDcqiDB6lihTKLN8Eg1zgkdrGkOX7t1oZBjJfE9UkBCUxRoA4
         w+pGr34p+l58fyZ1w26M1n0w0lDg6VJcqmWl+K3ZbGWOFe+bsrkb8hVXZQzDNAv0e6
         pVjbOJtnDDHsVMUWQ4gxzkSnp2DVVxXi4u5OWRWc3Bzk99JgHYaN8EFgAAzZTFAx91
         fFNhfEsvSCLtw==
Date:   Tue, 11 Apr 2023 11:29:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, david@fromorbit.com,
        dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE online fsck 1/2] xfs-linux: scrub-strengthen-rmap-checking
 updated to d95b1fa39fab
Message-ID: <168123761359.4118338.3332729538416597681.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks (mostly Dave),

The scrub-strengthen-rmap-checking branch of the xfs-linux repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git

has just been updated for your review.  These are all the accumulated
fixes for online scrub, as well as the design document for the entire
online fsck effort.

This code snapshot has been rebased against recent upstream, freshly
QA'd, and is ready for people to examine.  For veteran readers, the new
snapshot can be diffed against the previous snapshot; and for new
readers, this is a reasonable place to begin reading.  For the best
experience, it is recommended to pull this branch and walk the commits
instead of trying to read any patch deluge.  Mostly it's tweaks to
naming and APIs that Dave mentioned last week.

The new head of the scrub-strengthen-rmap-checking branch is commit:

d95b1fa39fab xfs: cross-reference rmap records with refcount btrees

97 new commits:

Darrick J. Wong (97):
[46cc5623980c] xfs: _{attr,data}_map_shared should take ILOCK_EXCL until iread_extents is completely done
[fcbbd77deca6] xfs: document the motivation for online fsck design
[e2244df23858] xfs: document the general theory underlying online fsck design
[703fcba9d825] xfs: document the testing plan for online fsck
[63b63c9fc82a] xfs: document the user interface for online fsck
[3e18687d3cc2] xfs: document the filesystem metadata checking strategy
[1a4b9d6941bf] xfs: document how online fsck deals with eventual consistency
[382b3f2109c2] xfs: document pageable kernel memory
[4695d82ba60e] xfs: document btree bulk loading
[deaa3ed7d2ad] xfs: document online file metadata repair code
[b22dcaea693b] xfs: document full filesystem scans for online fsck
[f82c264fe707] xfs: document metadata file repair
[ce43a58ae29c] xfs: document directory tree repairs
[f4509edba38a] xfs: document the userspace fsck driver program
[2d1629d5c42f] xfs: document future directions of online fsck
[6e86b58a88eb] xfs: give xfs_bmap_intent its own perag reference
[96102d0f5bc4] xfs: pass per-ag references to xfs_free_extent
[6936dfa07a14] xfs: give xfs_extfree_intent its own perag reference
[5562fb16d236] xfs: give xfs_rmap_intent its own perag reference
[6e5223d568c1] xfs: give xfs_refcount_intent its own perag reference
[ca7694b2c59a] xfs: create traced helper to get extra perag references
[e5cdb57f3efb] xfs: fix author and spdx headers on scrub/ files
[6c3ead492ee3] xfs: update copyright years for scrub/ files
[004606ee28de] xfs: add a tracepoint to report incorrect extent refcounts
[df9122b13cf7] xfs: allow queued AG intents to drain before scrubbing
[5dd2580252d4] xfs: clean up scrub context if scrub setup returns -EDEADLOCK
[5a1c669ed247] xfs: minimize overhead of drain wakeups by using jump labels
[44effd646390] xfs: scrub should use ECHRNG to signal that the drain is needed
[8f294fb68f9c] xfs: standardize ondisk to incore conversion for free space btrees
[3e41f0317121] xfs: standardize ondisk to incore conversion for inode btrees
[d75397ecdf4f] xfs: standardize ondisk to incore conversion for refcount btrees
[ff819e9ce02a] xfs: return a failure address from xfs_rmap_irec_offset_unpack
[4b1983d6b074] xfs: standardize ondisk to incore conversion for rmap btrees
[e679c6186c86] xfs: standardize ondisk to incore conversion for bmap btrees
[c454716162ac] xfs: complain about bad records in query_range helpers
[b14ac4165505] xfs: complain about bad file mapping records in the ondisk bmbt
[676394879025] xfs: hoist rmap record flag checks from scrub
[88967fb5bb08] xfs: hoist rmap record flag checks from scrub
[1aa5ea47c441] xfs: hoist inode record alignment checks from scrub
[5bdff2267ef2] xfs: fix rm_offset flag handling in rmap keys
[b1663a5cb425] xfs: detect unwritten bit set in rmapbt node block keys
[1e97f5452cf0] xfs: check btree keys reflect the child block
[a9e82b1b3b8c] xfs: always scrub record/key order of interior records
[e07a451c0271] xfs: refactor converting btree irec to btree key
[6baf4fb0423c] xfs: refactor ->diff_two_keys callsites
[e1daacbc820e] xfs: replace xfs_btree_has_record with a general keyspace scanner
[018602fa7133] xfs: implement masked btree key comparisons for _has_records scans
[9f30d09a6fc7] xfs: check the reference counts of gaps in the refcount btree
[9eb03e503666] xfs: ensure that all metadata and data blocks are not cow staging extents
[f29a6fcf81b4] xfs: remove pointless shadow variable from xfs_difree_inobt
[abfc927eb05d] xfs: clean up broken eearly-exit code in the inode btree scrubber
[8549c6d9545d] xfs: directly cross-reference the inode btrees with each other
[26380def44c9] xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results
[8301802485b1] xfs: teach scrub to check for sole ownership of metadata objects
[5691d0588915] xfs: ensure that single-owner file blocks are not owned by others
[fc631f787c50] xfs: use the directory name hash function for dir scrubbing
[4ab77b811207] xfs: streamline the directory iteration code for scrub
[f15614781989] xfs: xfs_iget in the directory scrubber needs to use UNTRUSTED
[415bf74d352c] xfs: always check the existence of a dirent's child inode
[a9121194c25b] xfs: remove xchk_parent_count_parent_dentries
[ef5420f8b67a] xfs: simplify xchk_parent_validate
[db99e87574bd] xfs: fix parent pointer scrub racing with subdirectory reparenting
[0bf9d3ed8af0] xfs: manage inode DONTCACHE status at irele time
[e3edd326587b] xfs: fix an inode lookup race in xchk_get_inode
[6fd405feefcf] xfs: rename xchk_get_inode -> xchk_iget_for_scrubbing
[c7049556a094] xfs: retain the AGI when we can't iget an inode to scrub the core
[aae2b9810277] xfs: don't take the MMAPLOCK when scrubbing file metadata
[d36d93e20afd] xfs: change bmap scrubber to store the previous mapping
[d9b45e5f6604] xfs: accumulate iextent records when checking bmap
[4f97bb30493b] xfs: split xchk_bmap_xref_rmap into two functions
[4d34edb8dc50] xfs: alert the user about data/attr fork mappings that could be merged
[644a276d2bf3] xfs: split the xchk_bmap_check_rmaps into a predicate
[451401a82d4a] xfs: don't call xchk_bmap_check_rmaps for btree-format file forks
[03ef798ef8c0] xfs: flag free space btree records that could be merged
[ee490441ede8] xfs: flag refcount btree records that could be merged
[5c79a83cc6c9] xfs: check overlapping rmap btree records
[5d9fd224ad89] xfs: check for reverse mapping records that could be merged
[271581ee3667] xfs: xattr scrub should ensure one namespace bit per name
[fac5554d4b5d] xfs: don't shadow @leaf in xchk_xattr_block
[694acc802c2d] xfs: remove unnecessary dstmap in xattr scrubber
[f840d62fb8a3] xfs: split freemap from xchk_xattr_buf.buf
[f34960cc244a] xfs: split usedmap from xchk_xattr_buf.buf
[66ab031b6aa8] xfs: split valuebuf from xchk_xattr_buf.buf
[f61edecf84ed] xfs: remove flags argument from xchk_setup_xattr_buf
[cf821fc8a95e] xfs: move xattr scrub buffer allocation to top level function
[5eed7dee3731] xfs: check used space of shortform xattr structures
[6f6a8587daaf] xfs: clean up xattr scrub initialization
[83b7158f5a40] xfs: only allocate free space bitmap for xattr scrub if needed
[6f56666a764d] xfs: don't load local xattr values during scrub
[44fe8a32115d] xfs: remove the for_each_xbitmap_ helpers
[e1e041933e04] xfs: drop the _safe behavior from the xbitmap foreach macro
[9343f41d44bf] xfs: convert xbitmap to interval tree
[e07326e95288] xfs: introduce bitmap type for AG blocks
[05691e62d612] xfs: cross-reference rmap records with ag btrees
[bc5ecccc0e64] xfs: cross-reference rmap records with free space btrees
[b9be44e9cc6a] xfs: cross-reference rmap records with inode btrees
[d95b1fa39fab] xfs: cross-reference rmap records with refcount btrees

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
fs/xfs/libxfs/xfs_bmap.c                           |   33 +-
fs/xfs/libxfs/xfs_bmap.h                           |    8 +-
fs/xfs/libxfs/xfs_bmap_btree.c                     |   19 +-
fs/xfs/libxfs/xfs_btree.c                          |  208 +-
fs/xfs/libxfs/xfs_btree.h                          |  141 +-
fs/xfs/libxfs/xfs_defer.c                          |    6 +-
fs/xfs/libxfs/xfs_ialloc.c                         |  165 +-
fs/xfs/libxfs/xfs_ialloc.h                         |    7 +-
fs/xfs/libxfs/xfs_ialloc_btree.c                   |   35 +-
fs/xfs/libxfs/xfs_ialloc_btree.h                   |    2 +-
fs/xfs/libxfs/xfs_inode_fork.c                     |   14 +-
fs/xfs/libxfs/xfs_inode_fork.h                     |    6 +-
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
fs/xfs/scrub/bitmap.h                              |  111 +-
fs/xfs/scrub/bmap.c                                |  426 +-
fs/xfs/scrub/btree.c                               |  102 +-
fs/xfs/scrub/btree.h                               |   16 +-
fs/xfs/scrub/common.c                              |  471 +-
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
fs/xfs/xfs_bmap_item.c                             |   37 +-
fs/xfs/xfs_drain.c                                 |  166 +
fs/xfs/xfs_drain.h                                 |   87 +
fs/xfs/xfs_extfree_item.c                          |   54 +-
fs/xfs/xfs_icache.c                                |    3 +-
fs/xfs/xfs_icache.h                                |   11 +-
fs/xfs/xfs_iunlink_item.c                          |    4 +-
fs/xfs/xfs_iwalk.c                                 |    5 +-
fs/xfs/xfs_linux.h                                 |    1 +
fs/xfs/xfs_refcount_item.c                         |   36 +-
fs/xfs/xfs_rmap_item.c                             |   32 +-
fs/xfs/xfs_trace.h                                 |   72 +
76 files changed, 10328 insertions(+), 1797 deletions(-)
create mode 100644 Documentation/filesystems/xfs-online-fsck-design.rst
create mode 100644 fs/xfs/scrub/readdir.c
create mode 100644 fs/xfs/scrub/readdir.h
create mode 100644 fs/xfs/xfs_drain.c
create mode 100644 fs/xfs/xfs_drain.h
