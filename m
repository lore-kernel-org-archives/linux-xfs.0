Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14B8C77B60
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 23:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346285AbjD1XRE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Apr 2023 19:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjD1XRD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2023 19:17:03 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB5F49D5
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 16:17:01 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-52091c58109so356383a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 16:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682723820; x=1685315820;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lY7UKzZ/brLv6IXdA/N8HnGqq4e/VoboJMhx+LWfOF4=;
        b=AYSa4Y7xtUju7k7HQ2lDFrbnHnMGs2R3HIdLSuf942WKAeKOZfCfr7jwKKucSY0bca
         YXUssJ8faott4pmpiwMIpdwfttJo0mA5yO+H6g+JsLdeO7GOfmxCxXn7mMqYs/cK5bly
         cTDmDQvW56m4s+aubOd3QJzWU+GoV/pARQF065G+tVLvZyv6FWR/iC3Vd+cURo2y5De1
         AOesldcYcASSGl1tBTh//EWXiK6ibQrmLIetAwsIXpsNUW5ocnjKia9V57nrrT7gIfUU
         0dhtW/fTgUagVizlNi4k9+IY6JBJkPFY4hTO/UFZxDV5ktKjK7i2h3vN7AbCpHTvocbG
         4Etg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682723820; x=1685315820;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lY7UKzZ/brLv6IXdA/N8HnGqq4e/VoboJMhx+LWfOF4=;
        b=VAluqDsZ3e6tqdSnuk7okiYuJ1lpZr/hXzbWp99340/5q+a9gCrAKKUtUEAIzXjTHT
         SUh2VxauQBm8LJL7bK4Et37aYq2K+W2qROFKjdXIMquH4R/OVv86MAQ70VcKkwDoDx+2
         rfe/mxi/P5BFi0aBHrOoMmPELaHJnQI7YAiCNkFQrsd9ZbGIZuzQgC11wegQFrIXthRX
         mhUOobP6b6dJ6B5fzSwaZZx+wyDHNUyc4w2PGtUkCAUhAvXFbw0EfcBTprWEoDLmM1Ag
         E2OVQoX26JCliOEOT7rPXxadInWQwLeCqyJh0RzbWmpdkyzNgIqtIcC8fJTxA66paDeb
         i9Uw==
X-Gm-Message-State: AC+VfDxbuqvnhJyNVLFWoFohfyySce07Y1+Lp88gGfvMk1Wulg6EyHgt
        82OFm7ldVfuAyD09BDFGoJ6aagyqLSIfDxz81io=
X-Google-Smtp-Source: ACHHUZ7abEbW5WRGKbzoqof/SJB0A4TdFZX1o3EfowDnKRgvNMCfBR9yQyB1odzn98p2kzy802Q2MQ==
X-Received: by 2002:a05:6a21:3a48:b0:f0:ac6b:379f with SMTP id zu8-20020a056a213a4800b000f0ac6b379fmr7125039pzb.15.1682723820417;
        Fri, 28 Apr 2023 16:17:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id k27-20020aa79d1b000000b0063b6451cd01sm15635346pfp.121.2023.04.28.16.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 16:16:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psXKh-0093Td-Vx; Sat, 29 Apr 2023 09:16:56 +1000
Date:   Sat, 29 Apr 2023 09:16:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     torvalds@linux-foundation.org
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: new code for 6.4
Message-ID: <20230428231655.GW3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Can you please pull the changes for XFS from the tag below? I
apologise for not sending this rather large update much earlier in
the merge window; we had a late regression report which uncovered a
serious omission from our regular test matrix. Determining the
seriousness of the problems that followup testing then uncovered
delayed the pull request. The most likely problem that anyone would
see was the original regression that was reported, and that is fixed
in this pull request.

That said, we know that there are still unfixed regressions that
this addition testing has uncovered, but they are all in relatively
niche configurations so shouldn't impact the majority of people
running 6.3 kernels. I will follow up with another pull request to
address these issues either late in the remaining merge window
period or soon after -rc1 is released.

This tree consists mainly of online scrub functionality and the
design documentation for the upcoming online repair functionality
built on top of the scrub code. I explicitly choose to use fine
grained merges for that series to retain all the context/cover
letter information for each part of the series that Darrick had
included in the tags for his pull requests. While it means there are
lots of merge commits, it also means the context and some of the
reasoning behind the series of changes is kept in the git tree with
the rest of the code history.

The tree at the tag below merges cleanly with your tree as of a few
minutes ago (head commit f20730efbd30), but results in a slightly
different diffstat to the pull request below. i.e.

pull-req:
 85 files changed, 10520 insertions(+), 1890 deletions(-)

merge into your tree:
 85 files changed, 10550 insertions(+), 1920 deletions(-)

I have confirmed that the resultant merge into your tree ends up
with identical code in fs/xfs after ignoring the few changes to the
XFS code that are already in your tree (mm_account_reclaimed_pages,
FMODE_DIO_PARALLEL_WRITE, sysctl table cleanup, .filemap update and
posix acl changes), so it doesn't look like the difference in the
diffstat is anything to worry about. If you see anything different,
please let me know!

-Dave.


The following changes since commit 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d:

  Linux 6.3-rc6 (2023-04-09 11:15:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-merge-1

for you to fetch changes up to 9419092fb2630c30e4ffeb9ef61007ef0c61827a:

  xfs: fix livelock in delayed allocation at ENOSPC (2023-04-27 09:02:11 +1000)

----------------------------------------------------------------
xfs: New code for 6.4

o Added detailed design documentation for the upcoming online repair feature
o major update to online scrub to complete the reverse mapping cross-referencing
  infrastructure enabling us to fully validate allocated metadata against owner
  records. This is the last piece of scrub infrastructure needed before we can
  start merging online repair functionality.
o Fixes for the ascii-ci hashing issues
o deprecation of the ascii-ci functionality
o on-disk format verification bug fixes
o various random bug fixes for syzbot and other bug reports

Signed-off-by: Dave Chinner <david@fromorbit.com>

----------------------------------------------------------------
Bagas Sanjaya (1):
      xfs: Extend table marker on deprecated mount options table

Darrick J. Wong (101):
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
      xfs: hoist rmap record flag checks from scrub
      xfs: complain about bad file mapping records in the ondisk bmbt
      xfs: hoist rmap record flag checks from scrub
      xfs: hoist inode record alignment checks from scrub
      xfs: fix rm_offset flag handling in rmap keys
      xfs: detect unwritten bit set in rmapbt node block keys
      xfs: check btree keys reflect the child block
      xfs: refactor converting btree irec to btree key
      xfs: always scrub record/key order of interior records
      xfs: refactor ->diff_two_keys callsites
      xfs: replace xfs_btree_has_record with a general keyspace scanner
      xfs: implement masked btree key comparisons for _has_records scans
      xfs: check the reference counts of gaps in the refcount btree
      xfs: ensure that all metadata and data blocks are not cow staging extents
      xfs: remove pointless shadow variable from xfs_difree_inobt
      xfs: clean up broken eearly-exit code in the inode btree scrubber
      xfs: directly cross-reference the inode btrees with each other
      xfs: teach scrub to check for sole ownership of metadata objects
      xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results
      xfs: use the directory name hash function for dir scrubbing
      xfs: ensure that single-owner file blocks are not owned by others
      xfs: streamline the directory iteration code for scrub
      xfs: xfs_iget in the directory scrubber needs to use UNTRUSTED
      xfs: always check the existence of a dirent's child inode
      xfs: remove xchk_parent_count_parent_dentries
      xfs: simplify xchk_parent_validate
      xfs: manage inode DONTCACHE status at irele time
      xfs: fix parent pointer scrub racing with subdirectory reparenting
      xfs: fix an inode lookup race in xchk_get_inode
      xfs: rename xchk_get_inode -> xchk_iget_for_scrubbing
      xfs: retain the AGI when we can't iget an inode to scrub the core
      xfs: don't take the MMAPLOCK when scrubbing file metadata
      xfs: change bmap scrubber to store the previous mapping
      xfs: accumulate iextent records when checking bmap
      xfs: split xchk_bmap_xref_rmap into two functions
      xfs: alert the user about data/attr fork mappings that could be merged
      xfs: split the xchk_bmap_check_rmaps into a predicate
      xfs: flag free space btree records that could be merged
      xfs: don't call xchk_bmap_check_rmaps for btree-format file forks
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
      xfs: remove the for_each_xbitmap_ helpers
      xfs: don't load local xattr values during scrub
      xfs: drop the _safe behavior from the xbitmap foreach macro
      xfs: convert xbitmap to interval tree
      xfs: introduce bitmap type for AG blocks
      xfs: cross-reference rmap records with ag btrees
      xfs: cross-reference rmap records with free space btrees
      xfs: cross-reference rmap records with inode btrees
      xfs: cross-reference rmap records with refcount btrees
      xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation
      xfs: test the ascii case-insensitive hash
      xfs: deprecate the ascii-ci feature
      xfs: _{attr,data}_map_shared should take ILOCK_EXCL until iread_extents is completely done
      xfs: verify buffer contents when we skip log replay

Dave Chinner (25):
      xfs: don't consider future format versions valid
      xfs: remove WARN when dquot cache insertion fails
      Merge tag 'online-fsck-design-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'intents-perag-refs-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'pass-perag-refs-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-fix-legalese-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-drain-intents-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'btree-complain-bad-records-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'btree-hoist-scrub-checks-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'rmap-btree-fix-key-handling-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-btree-key-enhancements-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-detect-refcount-gaps-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-detect-inobt-gaps-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-detect-rmapbt-gaps-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-dir-iget-fixes-6.4_2023-04-12' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-parent-fixes-6.4_2023-04-12' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-iget-fixes-6.4_2023-04-12' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-merge-bmap-records-6.4_2023-04-12' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-detect-mergeable-records-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-fix-xattr-memory-mgmt-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'repair-bitmap-rework-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'scrub-strengthen-rmap-checking-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      Merge tag 'fix-asciici-bugs-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next
      xfs: fix duplicate includes
      xfs: fix livelock in delayed allocation at ENOSPC

Ye Bin (1):
      xfs: fix BUG_ON in xfs_getbmap()

 Documentation/admin-guide/xfs.rst                          |    7 +-
 Documentation/filesystems/index.rst                        |    1 +
 Documentation/filesystems/xfs-online-fsck-design.rst       | 5315 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/filesystems/xfs-self-describing-metadata.rst |    1 +
 fs/xfs/Kconfig                                             |   32 +
 fs/xfs/Makefile                                            |    5 +-
 fs/xfs/libxfs/xfs_ag.c                                     |   23 +-
 fs/xfs/libxfs/xfs_ag.h                                     |    9 +
 fs/xfs/libxfs/xfs_alloc.c                                  |  115 +-
 fs/xfs/libxfs/xfs_alloc.h                                  |   22 +-
 fs/xfs/libxfs/xfs_alloc_btree.c                            |   32 +-
 fs/xfs/libxfs/xfs_bmap.c                                   |   39 +-
 fs/xfs/libxfs/xfs_bmap.h                                   |    8 +-
 fs/xfs/libxfs/xfs_bmap_btree.c                             |   19 +-
 fs/xfs/libxfs/xfs_btree.c                                  |  204 +++-
 fs/xfs/libxfs/xfs_btree.h                                  |  141 ++-
 fs/xfs/libxfs/xfs_defer.c                                  |    6 +-
 fs/xfs/libxfs/xfs_dir2.c                                   |    5 +-
 fs/xfs/libxfs/xfs_dir2.h                                   |   31 +
 fs/xfs/libxfs/xfs_ialloc.c                                 |  165 +--
 fs/xfs/libxfs/xfs_ialloc.h                                 |    7 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                           |   35 +-
 fs/xfs/libxfs/xfs_ialloc_btree.h                           |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c                             |   19 +-
 fs/xfs/libxfs/xfs_inode_fork.h                             |    6 +-
 fs/xfs/libxfs/xfs_refcount.c                               |  117 ++-
 fs/xfs/libxfs/xfs_refcount.h                               |   10 +-
 fs/xfs/libxfs/xfs_refcount_btree.c                         |   31 +-
 fs/xfs/libxfs/xfs_rmap.c                                   |  358 +++++--
 fs/xfs/libxfs/xfs_rmap.h                                   |   38 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                             |  102 +-
 fs/xfs/libxfs/xfs_sb.c                                     |   11 +-
 fs/xfs/libxfs/xfs_types.h                                  |   12 +
 fs/xfs/scrub/agheader.c                                    |   30 +-
 fs/xfs/scrub/agheader_repair.c                             |  105 +-
 fs/xfs/scrub/alloc.c                                       |   69 +-
 fs/xfs/scrub/attr.c                                        |  312 ++++--
 fs/xfs/scrub/attr.h                                        |   64 +-
 fs/xfs/scrub/bitmap.c                                      |  428 +++++---
 fs/xfs/scrub/bitmap.h                                      |  111 +-
 fs/xfs/scrub/bmap.c                                        |  420 +++++---
 fs/xfs/scrub/btree.c                                       |  102 +-
 fs/xfs/scrub/btree.h                                       |   16 +-
 fs/xfs/scrub/common.c                                      |  465 ++++++--
 fs/xfs/scrub/common.h                                      |   32 +-
 fs/xfs/scrub/dabtree.c                                     |    7 +-
 fs/xfs/scrub/dabtree.h                                     |    6 +-
 fs/xfs/scrub/dir.c                                         |  246 ++---
 fs/xfs/scrub/fscounters.c                                  |   11 +-
 fs/xfs/scrub/health.c                                      |    8 +-
 fs/xfs/scrub/health.h                                      |    6 +-
 fs/xfs/scrub/ialloc.c                                      |  304 ++++--
 fs/xfs/scrub/inode.c                                       |  189 +++-
 fs/xfs/scrub/parent.c                                      |  300 ++----
 fs/xfs/scrub/quota.c                                       |    9 +-
 fs/xfs/scrub/readdir.c                                     |  375 +++++++
 fs/xfs/scrub/readdir.h                                     |   19 +
 fs/xfs/scrub/refcount.c                                    |  197 +++-
 fs/xfs/scrub/repair.c                                      |  112 +-
 fs/xfs/scrub/repair.h                                      |    7 +-
 fs/xfs/scrub/rmap.c                                        |  570 ++++++++--
 fs/xfs/scrub/rtbitmap.c                                    |    6 +-
 fs/xfs/scrub/scrub.c                                       |   74 +-
 fs/xfs/scrub/scrub.h                                       |   32 +-
 fs/xfs/scrub/symlink.c                                     |    6 +-
 fs/xfs/scrub/trace.c                                       |    6 +-
 fs/xfs/scrub/trace.h                                       |   75 +-
 fs/xfs/scrub/xfs_scrub.h                                   |    6 +-
 fs/xfs/xfs_bmap_item.c                                     |   37 +-
 fs/xfs/xfs_bmap_util.c                                     |   14 +-
 fs/xfs/xfs_buf_item_recover.c                              |   10 +
 fs/xfs/xfs_dahash_test.c                                   |  211 ++--
 fs/xfs/xfs_dquot.c                                         |    1 -
 fs/xfs/xfs_drain.c                                         |  166 +++
 fs/xfs/xfs_drain.h                                         |   87 ++
 fs/xfs/xfs_extfree_item.c                                  |   54 +-
 fs/xfs/xfs_icache.c                                        |    3 +-
 fs/xfs/xfs_icache.h                                        |   11 +-
 fs/xfs/xfs_iunlink_item.c                                  |    4 +-
 fs/xfs/xfs_iwalk.c                                         |    5 +-
 fs/xfs/xfs_linux.h                                         |    1 +
 fs/xfs/xfs_refcount_item.c                                 |   36 +-
 fs/xfs/xfs_rmap_item.c                                     |   32 +-
 fs/xfs/xfs_super.c                                         |   13 +
 fs/xfs/xfs_trace.h                                         |   72 ++
 85 files changed, 10520 insertions(+), 1890 deletions(-)
 create mode 100644 Documentation/filesystems/xfs-online-fsck-design.rst
 create mode 100644 fs/xfs/scrub/readdir.c
 create mode 100644 fs/xfs/scrub/readdir.h
 create mode 100644 fs/xfs/xfs_drain.c
 create mode 100644 fs/xfs/xfs_drain.h


-- 
Dave Chinner
david@fromorbit.com
