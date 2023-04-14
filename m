Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863B7C77B70
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Apr 2023 05:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjDNF3a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Apr 2023 01:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjDNF32 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 01:29:28 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A954E4F
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 22:29:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id y11-20020a17090a600b00b0024693e96b58so16538454pji.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 22:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681450153; x=1684042153;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pdCs9tVHhiU+RhFuvQPGZvQ3aVOeuVeHyP7UcaE9SXk=;
        b=lQumGRupdylhxIfZjElW/KIdvFC2b3GHIpQXKe50C0bfkgzekMZjXpTN+DWeD3t5GX
         kdJ2+gpHxYp8SLYLEoUG5quHO4HZFJlzmlrKi0W2U1Q44KGd7KVgiRcJ6HFe+IdW37nl
         z6cyKjqM3y+Vgms/z6VGKTjcyNGPkZtrv3IL2xBy0m34ZnMFTpJQYwA1NRyanrKh/+RZ
         AN0VGNDhuz5HESi/g2QaHxIvDBl1ex1/2v33M7VX8f3mHEFYpSSeV8KTv6PDkTdX3tVJ
         8azsmMoW2hnTKMeyFw8jqzt1U8+JC55Q3a+S+tpZLokK3Y2GFkYokdIE4Xdx0v9ElRuH
         2PcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681450153; x=1684042153;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pdCs9tVHhiU+RhFuvQPGZvQ3aVOeuVeHyP7UcaE9SXk=;
        b=QnyxPE37Rj3HGA/8LD+EzEWTc5+QlmZLd5z5d/Zfq7jyTFXw7VM5PWCIQ7S36uw+vt
         q9wAy32nQQw2CzsKal8MDdipnKw4CP5ecQr16e0I0a2rZ1pgboMl2S9siFdXNng9NThp
         0fWpCObL8fokfG23ad4u2uKoU8FHSGqSup2joyPHhc7+NDG893rNTAQKUzPcDB2MchSg
         EKqkBAa5u0mdgGI0H7dz8AY41cwWcoTF1H73JpyLSQ8Kgsp9/1SAXxlDMVSm2ylEx6II
         mLLfOwqFuut4PrmQhT/EsK4Tz2NYLi1172JvsTQmVA480urJpJT2ijEyG8CAW8t/TY2A
         AbAQ==
X-Gm-Message-State: AAQBX9d86IdYH8RND3U9V7v90bIUJvmIFzZGbLzivfWEFM9nISlaVXwx
        /3K8Fg8ADRmuRTAX92Z6O+ft/z076s9hV/e6rwn3TgrL
X-Google-Smtp-Source: AKy350a2HHq9m+wr4v7bY93uQAwnbeoEpzap/hHqyLgqqJ7w6nyH6nLKFoPXfUKPQAzXjHm5nhT8zg==
X-Received: by 2002:a17:90a:f2c5:b0:247:3e0a:71cd with SMTP id gt5-20020a17090af2c500b002473e0a71cdmr1161717pjb.6.1681450152924;
        Thu, 13 Apr 2023 22:29:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id u24-20020a17090ae01800b002470b5f7112sm2838834pjy.26.2023.04.13.22.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 22:29:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pnBzh-003Agi-11; Fri, 14 Apr 2023 15:29:09 +1000
Date:   Fri, 14 Apr 2023 15:29:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org
Subject: [ANNOUNCE] xfs: for-next updated to 798352cb25d2
Message-ID: <20230414052909.GQ3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just updated the for-next branch with the first set of
Darrick's online repair work. This largely involves merging the
design documentation for how online repair will work as well as all
the pending scrub cross referencing functionality that online repair
depends on. There is no actual online repair code in this update;
that will come at a later date (i.e. future merge window) once
review has been completed.

There are also a few small bug fixes in this update, almost not
worth mentioning :)

I'd appreciate everyone who can taking this kernel for a spin on
their test machines - I haven't found anything of note, but the
sooner we get more people running it the sooner we'll find the
obvious thing we all missed....

Cheers,

Dave.


----------------------------------------------------------------

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

  Head commit: 798352cb25d2c27affbb5c733ed28430057228ca:

  Merge tag 'fix-asciici-bugs-6.4_2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into guilt/xfs-for-next (2023-04-14 07:11:43 +1000)

----------------------------------------------------------------
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

Dave Chinner (23):
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

Ye Bin (1):
      xfs: fix BUG_ON in xfs_getbmap()

 Documentation/admin-guide/xfs.rst                          |    1 +
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
 fs/xfs/libxfs/xfs_bmap.c                                   |   38 +-
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
 fs/xfs/scrub/refcount.c                                    |  193 +++-
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
 85 files changed, 10516 insertions(+), 1883 deletions(-)
 create mode 100644 Documentation/filesystems/xfs-online-fsck-design.rst
 create mode 100644 fs/xfs/scrub/readdir.c
 create mode 100644 fs/xfs/scrub/readdir.h
 create mode 100644 fs/xfs/xfs_drain.c
 create mode 100644 fs/xfs/xfs_drain.h

-- 
Dave Chinner
david@fromorbit.com
