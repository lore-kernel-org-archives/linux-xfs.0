Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2902FC7EE22
	for <linux-xfs@archiver.kernel.org>; Wed, 10 May 2023 14:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbjEJOQm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237378AbjEJOQk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 10:16:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB7046A2
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 07:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6606496F
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 14:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47960C433EF
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 14:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683728193;
        bh=4yxEYfnz8IbgaDcpfF2DE+YUS279G9O0V8kPRF++j3o=;
        h=Date:From:To:Subject:From;
        b=RpexhddDbjex672SimV7pKgXE3ch8re240GLR9/wUnec9INX3PpDIFqUjgQA3/XRf
         t6rw1GG4ZMT7fLzK6B8qbTXG7L3cbSmpwKwqiOB1wzqnOzEqI1vSwkyqDWXL/VegsL
         t4wepR5xhDOANra62Uml1fmwR38rqXI6BycS/8SBlfyxMRoCeuJlTF6jRaZw0oDfyv
         no526ZYzE9n6fL5t83TqA9CbN8NjNNoChJLpdJZ3h9kRhNSso2OwL1b/IebCL89nC3
         o71lUKwqMB3sQl4uIwRZnmGJg1VxyhPu8b7Ilq5jdbIuZfW/WNdramPZWRw1n4O8Ni
         wQq1KXRE6ZPiQ==
Date:   Wed, 10 May 2023 16:16:29 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 5fda1858a
Message-ID: <20230510141629.z3xwzjxzepv77hcl@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

This update includes a libxfs-sync  to Linux 6.3.

5fda1858ae6c1fd85f4cd87b7beff4588b39fdea

47 new commits:

Darrick J. Wong (14):
      [afe1175ff] xfs: pass the xfs_bmbt_irec directly through the log intent code
      [feee990ce] xfs: fix confusing xfs_extent_item variable names
      [74492d88b] xfs: pass rmap space mapping directly through the log intent code
      [f72f073f3] xfs: pass refcount intent directly through the log intent code
      [36076dc9a] xfs: restore old agirotor behavior
      [fc59ca7ec] xfs: try to idiot-proof the allocators
      [c2337664c] xfs: walk all AGs if TRYLOCK passed to xfs_alloc_vextent_iterate_ags
      [6904abced] xfs: add tracepoints for each of the externally visible allocators
      [b2f12cf35] xfs: clear incore AGFL_RESET state if it's not needed
      [002b5d96f] xfs: fix mismerged tracepoints
      [f4e6c2435] xfs_db: fix broken logic in error path
      [ffb1fbc8e] mkfs: warning about misaligned AGs and RAID stripes is not an error
      [765559644] xfs_repair: estimate per-AG btree slack better
      [5fda1858a] xfs_repair: dont leak buffer when discarding directories

Dave Chinner (33):
      [793910c0c] xfs: don't use BMBT btree split workers for IO completion
      [755477b4d] xfs: fix low space alloc deadlock
      [33f3aac8b] xfs: prefer free inodes at ENOSPC over chunk allocation
      [4442ae959] xfs: block reservation too large for minleft allocation
      [80375d246] xfs: drop firstblock constraints from allocation setup
      [9cdecd7e7] xfs: t_firstblock is tracking AGs not blocks
      [7ab297988] xfs: active perag reference counting
      [35398d0d6] xfs: rework the perag trace points to be perag centric
      [e7722e28b] xfs: convert xfs_imap() to take a perag
      [90e549b5f] xfs: use active perag references for inode allocation
      [87a02c9ee] xfs: inobt can use perags in many more places than it does
      [887a7edd7] xfs: convert xfs_ialloc_next_ag() to an atomic
      [03dc2ef2a] xfs: perags need atomic operational state
      [5cb4ffc83] xfs: introduce xfs_for_each_perag_wrap()
      [0ac70e08c] xfs: rework xfs_alloc_vextent()
      [649442d07] xfs: factor xfs_alloc_vextent_this_ag() for  _iterate_ags()
      [bad76a2c1] xfs: combine __xfs_alloc_vextent_this_ag and  xfs_alloc_ag_vextent
      [04215b9fb] xfs: use xfs_alloc_vextent_this_ag() where appropriate
      [3ed4e682e] xfs: factor xfs_bmap_btalloc()
      [5ba1f9152] xfs: use xfs_alloc_vextent_first_ag() where appropriate
      [1a5a98d5d] xfs: use xfs_alloc_vextent_start_bno() where appropriate
      [156536950] xfs: introduce xfs_alloc_vextent_near_bno()
      [c4e10f2b0] xfs: introduce xfs_alloc_vextent_exact_bno()
      [a74b55021] xfs: introduce xfs_alloc_vextent_prepare()
      [d99d52877] xfs: move allocation accounting to xfs_alloc_vextent_set_fsbno()
      [32cd26bf5] xfs: fold xfs_alloc_ag_vextent() into callers
      [50f6a20b8] xfs: move the minimum agno checks into xfs_alloc_vextent_check_args
      [91cceb740] xfs: convert xfs_alloc_vextent_iterate_ags() to use perag walker
      [451b902f9] xfs: factor out filestreams from xfs_bmap_btalloc_nullfb
      [4ccd9b2fe] xfs: get rid of notinit from xfs_bmap_longest_free_extent
      [c92d30401] xfs: use xfs_bmap_longest_free_extent() in filestreams
      [12ae68187] xfs: move xfs_bmap_btalloc_filestreams() to xfs_filestreams.c
      [c371ca854] xfs: return a referenced perag from filestreams allocator

Code Diffstat:

 db/check.c                  |   2 +-
 db/info.c                   |   2 +-
 include/atomic.h            |   5 +
 include/libxfs.h            |   1 +
 include/xfs_mount.h         |  16 +
 include/xfs_trace.h         |  21 +-
 include/xfs_trans.h         |   2 +-
 libfrog/bitmask.h           |  45 +++
 libxfs/defer_item.c         |  78 ++---
 libxfs/init.c               |  68 ++--
 libxfs/libxfs_api_defs.h    |   4 +
 libxfs/libxfs_priv.h        |  38 +--
 libxfs/rdwr.c               |  10 +-
 libxfs/trans.c              |   4 +-
 libxfs/xfs_ag.c             |  93 +++++-
 libxfs/xfs_ag.h             | 111 ++++++-
 libxfs/xfs_ag_resv.c        |   2 +-
 libxfs/xfs_alloc.c          | 751 ++++++++++++++++++++++++++++----------------
 libxfs/xfs_alloc.h          |  61 ++--
 libxfs/xfs_alloc_btree.c    |   2 +-
 libxfs/xfs_bmap.c           | 696 +++++++++++++++++++---------------------
 libxfs/xfs_bmap.h           |  12 +-
 libxfs/xfs_bmap_btree.c     |  64 ++--
 libxfs/xfs_btree.c          |  18 +-
 libxfs/xfs_ialloc.c         | 242 +++++++-------
 libxfs/xfs_ialloc.h         |   5 +-
 libxfs/xfs_ialloc_btree.c   |  47 ++-
 libxfs/xfs_ialloc_btree.h   |  20 +-
 libxfs/xfs_refcount.c       |  96 +++---
 libxfs/xfs_refcount.h       |   4 +-
 libxfs/xfs_refcount_btree.c |  10 +-
 libxfs/xfs_rmap.c           |  50 ++-
 libxfs/xfs_rmap.h           |   6 +-
 libxfs/xfs_rmap_btree.c     |   2 +-
 libxfs/xfs_sb.c             |   3 +-
 mkfs/xfs_mkfs.c             |   3 +-
 repair/agbtree.c            |  99 +++++-
 repair/agbtree.h            |   3 +
 repair/phase5.c             |  18 +-
 repair/phase6.c             |   6 +-
 repair/rmap.c               |  48 ++-
 repair/rmap.h               |   3 +
 42 files changed, 1625 insertions(+), 1146 deletions(-)
 create mode 100644 libfrog/bitmask.h

-- 
Carlos Maiolino
