Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC089C47096
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B609613D4
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhFFR0j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 13:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhFFR0i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 13:26:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 822A56127C
        for <linux-xfs@vger.kernel.org>; Sun,  6 Jun 2021 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623000288;
        bh=DoUobHbeMpCPYfm29HxOxNS6+C/JhizkeHCPghlZC9Y=;
        h=Date:From:To:Subject:From;
        b=jK79CCTTOwpqetFnoeQY4Y0Hm+ch6X4P2wXXhDZJ9UA/DXVFYeuD37TLPlFxO9WeR
         S/VJeKHxxEqEfQKlkHvhtu+HQq7RATqqj+KkYwb9+c01mqUFg/Rp2ux2PVcYQE9tWi
         1QySVfsaGm57lSN/RFF+bxr2ucAT27IsOXgOgOENlscxICQ86Eblg7LtOMF7/anmia
         a/ZMKA/ZO3Igchb1mkaXF6Zvr/KkmBlsR+vg9haVQol0OK+NMKoXCofZ3505qfZsH1
         XCf2WH5wA38RlhQfKMXPPdclVezgSRNDtY2wu6pDAXEejx+sFieT4mIzE4nmxJlVbO
         RiMpdZtEVZ8hQ==
Date:   Sun, 6 Jun 2021 10:24:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6a180b1d35a0
Message-ID: <20210606172448.GD2945738@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

Note: This is the first time that I've ever been sent a pull request for
code, which is why the branch is full of merge commits.  If anyone sees
any serious screwups, please holler now!  I would advise everyone to
hold off on rebasing real dev branches just in case I have to push -f.

Still under consideration are: Allison's delayed xattrs (probably going
in next), Dave's log scalability improvements (bugs, though this could
probably get split into multiple merges), and the last of my inode cache
walk cleanups (about to resend).  If that last part gets reviews in the
next day or two, I'll put out a new revision of deferred inode
inactivation.

The new head of the for-next branch is commit:

6a180b1d35a0 Merge tag 'inode-walk-cleanups-5.14_2021-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge

New Commits:

Christoph Hellwig (3):
      [e48f3211d410] xfs: simplify the b_page_count calculation
      [9f059beac967] xfs: cleanup error handling in xfs_buf_get_map
      [5a981e4ea8ff] xfs: mark xfs_bmap_set_attrforkoff static

Darrick J. Wong (22):
      [a7bcb147fef3] xfs: clean up open-coded fs block unit conversions
      [20bd8e63f30b] xfs: remove unnecessary shifts
      [1ad2cfe0a570] xfs: move the quotaoff dqrele inode walk into xfs_icache.c
      [3ea06d73e3c0] xfs: detach inode dquots at the end of inactivation
      [df60019739d8] xfs: move the inode walk functions further down
      [c1115c0cba2b] xfs: rename xfs_inode_walk functions to xfs_icwalk
      [c809d7e948a1] xfs: pass the goal of the incore inode walk to xfs_inode_walk()
      [b9baaef42f76] xfs: separate the dqrele_all inode grab logic from xfs_inode_walk_ag_grab
      [9d2793ceecb9] xfs: move xfs_inew_wait call into xfs_dqrele_inode
      [7fdff52623b4] xfs: remove iter_flags parameter from xfs_inode_walk_*
      [f427cf5c6236] xfs: remove indirect calls from xfs_inode_walk{,_ag}
      [d20d5edcf941] xfs: clean up inode state flag tests in xfs_blockgc_igrab
      [594ab00b760f] xfs: make the icwalk processing functions clean up the grab state
      [919a4ddb6841] xfs: fix radix tree tag signs
      [9d5ee8375951] xfs: pass struct xfs_eofblocks to the inode scan callback
      [f1bc5c5630f9] xfs: merge xfs_reclaim_inodes_ag into xfs_inode_walk_ag
      [c076ae7a9361] xfs: refactor per-AG inode tagging functions
      [001276036eb8] Merge tag 'xfs-buf-bulk-alloc-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.14-merge
      [7a2d12a18a23] Merge tag 'xfs-perag-conv-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.14-merge
      [946c056fcfb1] Merge tag 'unit-conversion-cleanups-5.14_2021-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge
      [f4736a20733d] Merge tag 'assorted-fixes-5.14-1_2021-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge
      [6a180b1d35a0] Merge tag 'inode-walk-cleanups-5.14_2021-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge

Dave Chinner (32):
      [0a683794ace2] xfs: split up xfs_buf_allocate_memory
      [07b5c5add42a] xfs: use xfs_buf_alloc_pages for uncached buffers
      [c9fa563072e1] xfs: use alloc_pages_bulk_array() for buffers
      [02c511738688] xfs: merge _xfs_buf_get_pages()
      [e7d236a6fe51] xfs: move page freeing into _xfs_buf_free_pages()
      [dc5b5b3f2ee7] xfs: remove ->b_offset handling for page backed buffers
      [01b67cd28ded] xfs: get rid of xb_to_gfp()
      [8bb870dee3c1] xfs: merge xfs_buf_allocate_memory
      [9bbafc71919a] xfs: move xfs_perag_get/put to xfs_ag.[ch]
      [61aa005a5bd7] xfs: prepare for moving perag definitions and support to libxfs
      [07b6403a6873] xfs: move perag structure and setup to libxfs/xfs_ag.[ch]
      [f250eedcf762] xfs: make for_each_perag... a first class citizen
      [934933c3eec9] xfs: convert raw ag walks to use for_each_perag
      [6f4118fc6482] xfs: convert xfs_iwalk to use perag references
      [7f8d3b3ca6fe] xfs: convert secondary superblock walk to use perags
      [45d066211756] xfs: pass perags through to the busy extent code
      [30933120ad79] xfs: push perags through the ag reservation callouts
      [58d43a7e3263] xfs: pass perags around in fsmap data dev functions
      [be9fb17d88f0] xfs: add a perag to the btree cursor
      [fa9c3c197329] xfs: convert rmap btree cursor to using a perag
      [a81a06211fb4] xfs: convert refcount btree cursor to use perags
      [289d38d22cd8] xfs: convert allocbt cursors to use perags
      [7b13c5155182] xfs: use perag for ialloc btree cursors
      [50f02fe3338d] xfs: remove agno from btree cursor
      [4268547305c9] xfs: simplify xfs_dialloc_select_ag() return values
      [89b1f55a2951] xfs: collapse AG selection for inode allocation
      [b652afd93703] xfs: get rid of xfs_dir_ialloc()
      [309161f6603c] xfs: inode allocation can use a single perag instance
      [8237fbf53d6f] xfs: clean up and simplify xfs_dialloc()
      [f40aadb2bb64] xfs: use perag through unlink processing
      [509201163fca] xfs: remove xfs_perag_t
      [977ec4ddf0b7] xfs: don't take a spinlock unconditionally in the DIO fastpath

Jiapeng Chong (1):
      [9673261c32dc] xfs: Remove redundant assignment to busy

Shaokun Zhang (1):
      [5f7fd7508620] xfs: sort variable alphabetically to avoid repeated declaration


Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c             | 273 +++++++++++-
 fs/xfs/libxfs/xfs_ag.h             | 136 ++++++
 fs/xfs/libxfs/xfs_ag_resv.c        |  11 +-
 fs/xfs/libxfs/xfs_ag_resv.h        |  15 +
 fs/xfs/libxfs/xfs_alloc.c          | 111 ++---
 fs/xfs/libxfs/xfs_alloc.h          |   2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  31 +-
 fs/xfs/libxfs/xfs_alloc_btree.h    |   9 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |   1 +
 fs/xfs/libxfs/xfs_bmap.c           |   3 +-
 fs/xfs/libxfs/xfs_bmap.h           |   1 -
 fs/xfs/libxfs/xfs_btree.c          |  15 +-
 fs/xfs/libxfs/xfs_btree.h          |  10 +-
 fs/xfs/libxfs/xfs_ialloc.c         | 612 +++++++++++++-------------
 fs/xfs/libxfs/xfs_ialloc.h         |  40 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  46 +-
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  13 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |   2 +-
 fs/xfs/libxfs/xfs_refcount.c       | 122 +++---
 fs/xfs/libxfs/xfs_refcount.h       |   9 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  39 +-
 fs/xfs/libxfs/xfs_refcount_btree.h |   7 +-
 fs/xfs/libxfs/xfs_rmap.c           | 147 ++++---
 fs/xfs/libxfs/xfs_rmap.h           |   6 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  46 +-
 fs/xfs/libxfs/xfs_rmap_btree.h     |   6 +-
 fs/xfs/libxfs/xfs_sb.c             | 146 +------
 fs/xfs/libxfs/xfs_sb.h             |   9 -
 fs/xfs/libxfs/xfs_shared.h         |  20 +-
 fs/xfs/libxfs/xfs_types.c          |   4 +-
 fs/xfs/scrub/agheader.c            |   1 +
 fs/xfs/scrub/agheader_repair.c     |  33 +-
 fs/xfs/scrub/alloc.c               |   3 +-
 fs/xfs/scrub/bmap.c                |  21 +-
 fs/xfs/scrub/common.c              |  15 +-
 fs/xfs/scrub/fscounters.c          |  42 +-
 fs/xfs/scrub/health.c              |   2 +-
 fs/xfs/scrub/ialloc.c              |   9 +-
 fs/xfs/scrub/refcount.c            |   3 +-
 fs/xfs/scrub/repair.c              |  14 +-
 fs/xfs/scrub/rmap.c                |   3 +-
 fs/xfs/scrub/trace.c               |   3 +-
 fs/xfs/xfs_bmap_util.c             |   6 +-
 fs/xfs/xfs_buf.c                   | 307 +++++--------
 fs/xfs/xfs_buf.h                   |   3 +-
 fs/xfs/xfs_discard.c               |   6 +-
 fs/xfs/xfs_extent_busy.c           |  35 +-
 fs/xfs/xfs_extent_busy.h           |   7 +-
 fs/xfs/xfs_file.c                  |  42 +-
 fs/xfs/xfs_filestream.c            |   2 +-
 fs/xfs/xfs_fsmap.c                 |  80 ++--
 fs/xfs/xfs_fsops.c                 |   8 +-
 fs/xfs/xfs_health.c                |   6 +-
 fs/xfs/xfs_icache.c                | 858 ++++++++++++++++++++-----------------
 fs/xfs/xfs_icache.h                |  25 +-
 fs/xfs/xfs_inode.c                 | 224 +++++-----
 fs/xfs/xfs_inode.h                 |   9 +-
 fs/xfs/xfs_iops.c                  |   4 +-
 fs/xfs/xfs_iwalk.c                 |  84 ++--
 fs/xfs/xfs_log_recover.c           |  56 ++-
 fs/xfs/xfs_mount.c                 | 126 +-----
 fs/xfs/xfs_mount.h                 | 110 +----
 fs/xfs/xfs_qm.c                    |  10 +-
 fs/xfs/xfs_qm.h                    |   1 -
 fs/xfs/xfs_qm_syscalls.c           |  54 +--
 fs/xfs/xfs_reflink.c               |  13 +-
 fs/xfs/xfs_super.c                 |   3 +-
 fs/xfs/xfs_symlink.c               |   9 +-
 fs/xfs/xfs_trace.c                 |   2 +
 fs/xfs/xfs_trace.h                 |  15 +-
 70 files changed, 2076 insertions(+), 2070 deletions(-)
