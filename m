Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F410CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Dec 2022 10:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiLWKn7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Dec 2022 05:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiLWKn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Dec 2022 05:43:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960E213CCB
        for <linux-xfs@vger.kernel.org>; Fri, 23 Dec 2022 02:43:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24C3D61EF3
        for <linux-xfs@vger.kernel.org>; Fri, 23 Dec 2022 10:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B7AC433D2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Dec 2022 10:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671792235;
        bh=y5GeGyUlnqV4Q352rWhXxFAv1919AJ0c4L2S3Q+XpQk=;
        h=Date:From:To:Subject:From;
        b=ZrbaNXKR+SmOaLFNRbRy0mG394SeB2pkqgeLsed0xomAodgGDViLWxPLK48v70zAx
         /tdHDl1ZMelEwX170N0vUqzwUCLd+DXT1wvc34Kl4ynGFKpR5QcegPvgls4zN3BxBj
         0KqrSLagvKEbxr8JIRgrN+QPcvC7EOuZ+2WXCQZqk5WMdJ6OjvsaAYEHq5Sz/68lQ7
         l987whxOCA323gwPMaSYQU2+KBE/rgPxlf2v+ULjWmWPL5OYV/UInTq9IC6vY2E2fB
         6fDvsqVsK41L9k8br+gj6R8AU9wdlsN/LEDbCeYojqkExzkp8/vMA/VUhG15qs2Gdw
         MKQwvBOW96kJw==
Date:   Fri, 23 Dec 2022 11:43:51 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs-6.1.0 released
Message-ID: <20221223104351.gwi7qyns7eww6gel@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

If you were expecting your patch to be in this version, and for some reason it
is not, please let me know.

The commit log and diffstat are described below...


Happy Holidays everyone!


The new head of the master branch is commit:

37e6e80a6 xfsprogs: Release v6.1.0

New Commits:

Allison Henderson (1):
      [227bc97f1] xfs: increase rename inode reservation

Carlos Maiolino (3):
      [fbd9b2363] xfs_repair: Fix check_refcount() error path
      [2dac91b3d] xfs_repair: Fix rmaps_verify_btree() error path
      [37e6e80a6] xfsprogs: Release v6.1.0

Darrick J. Wong (26):
      [d267ac6a0] xfs: fix memcpy fortify errors in EFI log format copying
      [4b69afdc4] xfs: refactor all the EFI/EFD log item sizeof logic
      [2d5166b9d] xfs: make sure aglen never goes negative in xfs_refcount_adjust_extents
      [b3f9ae08e] xfs: create a predicate to verify per-AG extents
      [7ccbdec2b] xfs: check deferred refcount op continuation parameters
      [bec88ec72] xfs: move _irec structs to xfs_types.h
      [6b2f464dd] xfs: track cow/shared record domains explicitly in xfs_refcount_irec
      [8160aeff0] xfs: report refcount domain in tracepoints
      [cc2a3c2ad] xfs: refactor domain and refcount checking
      [f275d70e8] xfs: remove XFS_FIND_RCEXT_SHARED and _COW
      [817ea9f0f] xfs: check record domain when accessing refcount records
      [8b2b27581] xfs: fix agblocks check in the cow leftover recovery function
      [7accbcd00] xfs: fix uninitialized list head in struct xfs_refcount_recovery
      [7257eb3ed] xfs: rename XFS_REFC_COW_START to _COWFLAG
      [60066f61c] libxfs: consume the xfs_warn mountpoint argument
      [b6fef47a8] misc: add static to various sourcefile-local functions
      [a946664de] misc: add missing includes
      [b84d0823d] xfs_db: fix octal conversion logic
      [e9dea7eff] xfs_db: fix printing of reverse mapping record blockcounts
      [978c3087b] xfs_repair: don't crash on unknown inode parents in dry run mode
      [945c7341d] xfs_repair: retain superblock buffer to avoid write hook deadlock
      [2b9d6f15b] xfs_{db,repair}: fix XFS_REFC_COW_START usage
      [765809a0d] mkfs.xfs: add mkfs config file for the 6.1 LTS kernel
      [f6fb1c078] xfs_io: don't display stripe alignment flags for realtime files
      [e229a59f0] xfs_db: create separate struct and field definitions for finobts
      [7374f58bf] xfs_db: fix dir3 block magic check

Guo Xuenan (1):
      [20798cc06] xfs: fix exception caused by unexpected illegal bestcount in leaf dir

Jason A. Donenfeld (2):
      [4947ac5b3] treewide: use prandom_u32_max() when possible, part 1
      [11d2f5afc] treewide: use get_random_u32() when possible

Long Li (1):
      [b827e2318] xfs: fix sb write verify for lazysbcount

Shida Zhang (2):
      [04d4c27af] xfs: trim the mapp array accordingly in xfs_da_grow_inode_int
      [1a3bfffee] xfs: rearrange the logic and remove the broken comment for xfs_dir2_isxx

Srikanth C S (1):
      [79ba1e15d] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair

Zeng Heng (1):
      [be98db856] xfs: clean up "%Ld/%Lu" which doesn't meet C standard

ye xingchen (1):
      [e8dbbca18] xfs: Remove the unneeded result variable


Code Diffstat:

 VERSION                     |   2 +-
 configure.ac                |   2 +-
 db/btblock.c                |  72 +++++++++++++++++-
 db/btblock.h                |   6 ++
 db/check.c                  |   6 +-
 db/field.c                  |   8 ++
 db/field.h                  |   4 +
 db/namei.c                  |   4 +-
 db/type.c                   |   6 +-
 db/write.c                  |   4 +-
 debian/changelog            |   6 ++
 doc/CHANGES                 |  18 +++++
 fsck/xfs_fsck.sh            |  31 +++++++-
 include/kmem.h              |  10 +++
 io/fsmap.c                  |   4 +-
 io/pread.c                  |   2 +-
 libfrog/linux.c             |   1 +
 libxfs/libxfs_api_defs.h    |   2 +
 libxfs/libxfs_io.h          |   1 +
 libxfs/libxfs_priv.h        |   8 +-
 libxfs/rdwr.c               |   8 ++
 libxfs/util.c               |   1 +
 libxfs/xfs_ag.h             |  15 ++++
 libxfs/xfs_alloc.c          |   8 +-
 libxfs/xfs_bmap.c           |   2 +-
 libxfs/xfs_da_btree.c       |   2 +-
 libxfs/xfs_dir2.c           |  50 ++++++++-----
 libxfs/xfs_dir2.h           |   4 +-
 libxfs/xfs_dir2_leaf.c      |   9 ++-
 libxfs/xfs_dir2_sf.c        |   4 +-
 libxfs/xfs_format.h         |  22 +-----
 libxfs/xfs_ialloc.c         |   4 +-
 libxfs/xfs_inode_fork.c     |   4 +-
 libxfs/xfs_log_format.h     |  60 +++++++++++++--
 libxfs/xfs_refcount.c       | 286
+++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 libxfs/xfs_refcount.h       |  40 +++++++++-
 libxfs/xfs_refcount_btree.c |  15 +++-
 libxfs/xfs_rmap.c           |   9 +--
 libxfs/xfs_sb.c             |   4 +-
 libxfs/xfs_trans_resv.c     |   4 +-
 libxfs/xfs_types.h          |  30 ++++++++
 logprint/log_redo.c         |  12 +--
 mkfs/Makefile               |   3 +-
 mkfs/lts_6.1.conf           |  14 ++++
 mkfs/xfs_mkfs.c             |   2 +-
 repair/phase2.c             |   8 ++
 repair/phase6.c             |  15 +++-
 repair/protos.h             |   1 +
 repair/rmap.c               |  61 ++++++++-------
 repair/scan.c               |  22 ++++--
 repair/xfs_repair.c         |  77 ++++++++++++++++---
 scrub/inodes.c              |   2 +-
 52 files changed, 747 insertions(+), 248 deletions(-)
 create mode 100644 mkfs/lts_6.1.conf

-- 
Carlos Maiolino
