Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5879AC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE8B619F8
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCZAYx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhCZAY2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E26760C41;
        Fri, 26 Mar 2021 00:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718268;
        bh=mTPCLZn1nZI6ah0pYSRDEqqh0+YkyyWJ4ZXDT8hVRiU=;
        h=Date:From:To:Cc:Subject:From;
        b=pB2rflHkAFYe2a5kzPc934swwFR/N1/gzft0mDQTK8fkxbI/9wxgyfwSiK+GWtxjr
         +KPdfZay3dWXw1IQn1saKsKMKnQxSrabHlx0p1JIuPQSXmNyjvvbERHLp2vouhpGKi
         u25785deAui0tO+LP4gYSkMsveuw5E9X3178f27NxCDVtBhTmAzIYEsYOFdPuuDsfB
         G0x3z3TieKQ0XCMlqwcixTQk3XB61JDG/Cv7s8xQkFZ4KlTBGS+17eHOUuwwvcHUn8
         5tGnXaY6/7QSFg1lNxund3GP/vCVSf656vUDz0yvyvArZbXYY+8fqX+L0dKWkU9xqR
         0a81ETb20CQMQ==
Date:   Thu, 25 Mar 2021 17:24:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 25dfa65f8149
Message-ID: <20210326002427.GO4090233@magnolia>
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

The new head of the for-next branch is commit:

25dfa65f8149 xfs: fix xfs_trans slab cache name

New Commits:

Anthony Iliopoulos (1):
      [25dfa65f8149] xfs: fix xfs_trans slab cache name

Bhaskar Chowdhury (3):
      [bd24a4f5f7fd] xfs: Rudimentary typo fixes
      [0145225e353e] xfs: Rudimentary spelling fix
      [f9dd7ba4308c] xfs: Fix a typo

Darrick J. Wong (10):
      [e424aa5f547d] xfs: drop freeze protection when running GETFSMAP
      [1aa26707ebd6] xfs: fix uninitialized variables in xrep_calc_ag_resblks
      [05237032fdec] xfs: fix dquot scrub loop cancellation
      [7716ee54cb88] xfs: bail out of scrub immediately if scan incomplete
      [9de4b514494a] xfs: mark a data structure sick if there are cross-referencing errors
      [de9d2a78add1] xfs: set the scrub AG number in xchk_ag_read_headers
      [f53acface7a9] xfs: remove return value from xchk_ag_btcur_init
      [973975b72a36] xfs: validate ag btree levels using the precomputed values
      [383e32b0d0db] xfs: prevent metadata files from being inactivated
      [3fef46fc43ca] xfs: rename the blockgc workqueue

Dave Chinner (8):
      [e6a688c33238] xfs: initialise attr fork on inode create
      [accc661bf99a] xfs: reduce buffer log item shadow allocations
      [c81ea11e0332] xfs: xfs_buf_item_size_segment() needs to pass segment offset
      [929f8b0deb83] xfs: optimise xfs_buf_item_size/format for contiguous regions
      [ec08c14ba28c] xfs: type verification is expensive
      [39d3c0b5968b] xfs: No need for inode number error injection in __xfs_dir3_data_check
      [1fea323ff005] xfs: reduce debug overhead of dir leaf/node checks
      [5825bea05265] xfs: __percpu_counter_compare() inode count debug too expensive

Gao Xiang (6):
      [b2c2974b8cdf] xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
      [014695c0a78e] xfs: update lazy sb counters immediately for resizefs
      [c789c83c7ef8] xfs: hoist out xfs_resizefs_init_new_ags()
      [46141dc891f7] xfs: introduce xfs_ag_shrink_space()
      [fb2fc1720185] xfs: support shrinking unused space in the last AG
      [2b92faed5511] xfs: add error injection for per-AG resv failure

Pavel Reichl (2):
      [0f98b4ece18d] xfs: rename variable mp to parsing_mp
      [92cf7d36384b] xfs: Skip repetitive warnings about mount options


Code Diffstat:

 Documentation/admin-guide/xfs.rst |   2 +-
 fs/xfs/libxfs/xfs_ag.c            | 115 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h            |   2 +
 fs/xfs/libxfs/xfs_ag_resv.c       |   6 +-
 fs/xfs/libxfs/xfs_alloc.c         |   8 +-
 fs/xfs/libxfs/xfs_bmap.c          |   9 +-
 fs/xfs/libxfs/xfs_dir2_data.c     |   2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c     |  10 +-
 fs/xfs/libxfs/xfs_dir2_node.c     |   2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h     |   3 +-
 fs/xfs/libxfs/xfs_errortag.h      |   4 +-
 fs/xfs/libxfs/xfs_ialloc.c        |   4 +-
 fs/xfs/libxfs/xfs_iext_tree.c     |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c    |  22 +++--
 fs/xfs/libxfs/xfs_inode_fork.h    |   2 +
 fs/xfs/libxfs/xfs_types.c         |  18 ++--
 fs/xfs/scrub/agheader.c           |  33 ++-----
 fs/xfs/scrub/common.c             |  23 ++---
 fs/xfs/scrub/common.h             |   5 +-
 fs/xfs/scrub/health.c             |   3 +-
 fs/xfs/scrub/quota.c              |   6 +-
 fs/xfs/scrub/repair.c             |   6 +-
 fs/xfs/scrub/scrub.c              |   2 +-
 fs/xfs/xfs_aops.c                 |   2 +-
 fs/xfs/xfs_buf_item.c             | 141 +++++++++++++++++++++------
 fs/xfs/xfs_error.c                |   5 +
 fs/xfs/xfs_fsmap.c                |  14 +--
 fs/xfs/xfs_fsops.c                | 195 ++++++++++++++++++++++++--------------
 fs/xfs/xfs_icache.c               |   2 +-
 fs/xfs/xfs_inode.c                |  30 +++++-
 fs/xfs/xfs_inode.h                |  14 ++-
 fs/xfs/xfs_iops.c                 |  34 ++++++-
 fs/xfs/xfs_log_recover.c          |   4 +-
 fs/xfs/xfs_mount.h                |   2 +-
 fs/xfs/xfs_qm.c                   |   2 +-
 fs/xfs/xfs_super.c                | 128 ++++++++++++++-----------
 fs/xfs/xfs_symlink.c              |   2 +-
 fs/xfs/xfs_trans.c                |  12 +--
 fs/xfs/xfs_xattr.c                |   2 +
 39 files changed, 608 insertions(+), 270 deletions(-)
