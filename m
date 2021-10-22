Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F8BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Oct 2021 23:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10996023F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Oct 2021 23:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhJVX3k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Oct 2021 19:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhJVX3i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Oct 2021 19:29:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A0F16023F
        for <linux-xfs@vger.kernel.org>; Fri, 22 Oct 2021 23:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634945240;
        bh=G4ztGAXHKj6lXfZeKX/T+INyY6Uoh1hycCPd13Lr94Y=;
        h=Date:From:To:Subject:From;
        b=GRLsYKKCBtn2HkM7RzMaZgNNlatMy7mg7+zBwe969gJM0C9dO6RQcx9qdQ8SFthYH
         tJAqFtPg74pRoONoUDqb1bmPuwGFCawsoVvJZUdatSuFsWEryT3bgxu00M2XgQcQrI
         s5yQCaOxSA8daykKOWSU/IJ8ob1SLuI2kGglh8TgyJZfHTueZYv1JQa7smrrUbGfpb
         7t/F3lXwJd9orL2CYs7cL7iitLcemJwokfdnlp14KgWR5asXuWKKDNZXSnDqEkR0a6
         T91vy2faLQzqo9Y0AAjcRqYRqKWzYTynopYGgfTiSPvwg0TkO35m/P4I5XxfzkCwL/
         Ozp3+olKCfz1Q==
Date:   Fri, 22 Oct 2021 16:27:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5ca5916b6bc9
Message-ID: <20211022232719.GZ24307@magnolia>
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
the next update.  I think this is it for 5.16, though.

The new head of the for-next branch is commit:

5ca5916b6bc9 xfs: punch out data fork delalloc blocks on COW writeback failure

New Commits:

Brian Foster (5):
      [bf2307b19513] xfs: fold perag loop iteration logic into helper function
      [f1788b5e5ee2] xfs: rename the next_agno perag iteration variable
      [8ed004eb9d07] xfs: terminate perag iteration reliably on agcount
      [892a666fafa1] xfs: fix perag reference leak on iteration race with growfs
      [5ca5916b6bc9] xfs: punch out data fork delalloc blocks on COW writeback failure

Christoph Hellwig (3):
      [de38db7239c4] xfs: remove the xfs_dinode_t typedef
      [ed67ebfd7c40] xfs: remove the xfs_dsb_t typedef
      [11a83f4c3930] xfs: remove the xfs_dqblk_t typedef

Darrick J. Wong (32):
      [c5db9f937b29] xfs: formalize the process of holding onto resources across a defer roll
      [512edfac85d2] xfs: port the defer ops capture and continue to resource capture
      [78e8ec83a404] xfs: fix maxlevels comparisons in the btree staging code
      [ae127f087dc2] xfs: remove xfs_btree_cur_t typedef
      [510a28e195cd] xfs: don't allocate scrub contexts on the stack
      [f4585e82340b] xfs: stricter btree height checking when looking for errors
      [1ba6fd34ca63] xfs: stricter btree height checking when scanning for btree roots
      [4c175af2ccd3] xfs: check that bc_nlevels never overflows
      [94a14cfd3b6e] xfs: fix incorrect decoding in xchk_btree_cur_fsbno
      [cc411740472d] xfs: remove xfs_btree_cur.bc_blocklog
      [efb79ea31067] xfs: reduce the size of nr_ops for refcount btree cursors
      [d47fef9342d0] xfs: don't track firstrec/firstkey separately in xchk_btree
      [eae5db476f9d] xfs: dynamically allocate btree scrub context structure
      [6ca444cfd663] xfs: prepare xfs_btree_cur for dynamic cursor heights
      [69724d920e7c] xfs: rearrange xfs_btree_cur fields for better packing
      [56370ea6e5fe] xfs: refactor btree cursor allocation function
      [c0643f6fdd6d] xfs: encode the max btree height in the cursor
      [c940a0c54a2e] xfs: dynamically allocate cursors based on maxlevels
      [7cb3efb4cfdd] xfs: rename m_ag_maxlevels to m_allocbt_maxlevels
      [b74e15d720d0] xfs: compute maximum AG btree height for critical reservation calculation
      [1b236ad7ba80] xfs: clean up xfs_btree_{calc_size,compute_maxlevels}
      [9ec691205e7d] xfs: compute the maximum height of the rmap btree when reflink enabled
      [bc8883eb775d] xfs: kill XFS_BTREE_MAXLEVELS
      [0ed5f7356dae] xfs: compute absolute maximum nlevels for each btree type
      [9fa47bdcd33b] xfs: use separate btree cursor cache for each btree type
      [e7720afad068] xfs: remove kmem_zone typedef
      [182696fb021f] xfs: rename _zone variables to _cache
      [9e253954acf5] xfs: compact deferred intent item structures
      [f3c799c22c66] xfs: create slab caches for frequently-used deferred items
      [c201d9ca5392] xfs: rename xfs_bmap_add_free to xfs_free_extent_later
      [b3b5ff412ab0] xfs: reduce the size of struct xfs_extent_free_item
      [c04c51c52469] xfs: remove unused parameter from refcount code

Gustavo A. R. Silva (1):
      [a785fba7df9a] xfs: Use kvcalloc() instead of kvzalloc()

Qing Wang (1):
      [53eb47b491c8] xfs: replace snprintf in show functions with sysfs_emit

Rustam Kovhaev (1):
      [c30a0cbd07ec] xfs: use kmem_cache_free() for kmem_cache objects


Code Diffstat:

 fs/xfs/kmem.h                      |   4 -
 fs/xfs/libxfs/xfs_ag.c             |   2 +-
 fs/xfs/libxfs/xfs_ag.h             |  36 ++--
 fs/xfs/libxfs/xfs_ag_resv.c        |   3 +-
 fs/xfs/libxfs/xfs_alloc.c          | 120 ++++++++++---
 fs/xfs/libxfs/xfs_alloc.h          |  38 ++++-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  63 +++++--
 fs/xfs/libxfs/xfs_alloc_btree.h    |   5 +
 fs/xfs/libxfs/xfs_attr_leaf.c      |   2 +-
 fs/xfs/libxfs/xfs_bmap.c           | 101 ++++-------
 fs/xfs/libxfs/xfs_bmap.h           |  35 +---
 fs/xfs/libxfs/xfs_bmap_btree.c     |  62 +++++--
 fs/xfs/libxfs/xfs_bmap_btree.h     |   5 +
 fs/xfs/libxfs/xfs_btree.c          | 333 +++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_btree.h          |  99 ++++++++---
 fs/xfs/libxfs/xfs_btree_staging.c  |   8 +-
 fs/xfs/libxfs/xfs_da_btree.c       |   6 +-
 fs/xfs/libxfs/xfs_da_btree.h       |   3 +-
 fs/xfs/libxfs/xfs_defer.c          | 241 ++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_defer.h          |  41 ++++-
 fs/xfs/libxfs/xfs_dquot_buf.c      |   4 +-
 fs/xfs/libxfs/xfs_format.h         |  12 +-
 fs/xfs/libxfs/xfs_fs.h             |   2 +
 fs/xfs/libxfs/xfs_ialloc.c         |   5 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  90 +++++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h   |   5 +
 fs/xfs/libxfs/xfs_inode_buf.c      |   6 +-
 fs/xfs/libxfs/xfs_inode_fork.c     |  24 +--
 fs/xfs/libxfs/xfs_inode_fork.h     |   2 +-
 fs/xfs/libxfs/xfs_refcount.c       |  46 +++--
 fs/xfs/libxfs/xfs_refcount.h       |   7 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  73 ++++++--
 fs/xfs/libxfs/xfs_refcount_btree.h |   5 +
 fs/xfs/libxfs/xfs_rmap.c           |  21 ++-
 fs/xfs/libxfs/xfs_rmap.h           |   7 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     | 116 ++++++++++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |   5 +
 fs/xfs/libxfs/xfs_sb.c             |   4 +-
 fs/xfs/libxfs/xfs_trans_resv.c     |  18 +-
 fs/xfs/libxfs/xfs_trans_space.h    |   9 +-
 fs/xfs/scrub/agheader.c            |  13 +-
 fs/xfs/scrub/agheader_repair.c     |   8 +-
 fs/xfs/scrub/bitmap.c              |  22 +--
 fs/xfs/scrub/bmap.c                |   2 +-
 fs/xfs/scrub/btree.c               | 121 +++++++-------
 fs/xfs/scrub/btree.h               |  17 +-
 fs/xfs/scrub/dabtree.c             |  62 +++----
 fs/xfs/scrub/repair.h              |   3 +
 fs/xfs/scrub/scrub.c               |  64 +++----
 fs/xfs/scrub/trace.c               |  11 +-
 fs/xfs/scrub/trace.h               |  10 +-
 fs/xfs/xfs_aops.c                  |  15 +-
 fs/xfs/xfs_attr_inactive.c         |   2 +-
 fs/xfs/xfs_bmap_item.c             |  18 +-
 fs/xfs/xfs_bmap_item.h             |   6 +-
 fs/xfs/xfs_buf.c                   |  14 +-
 fs/xfs/xfs_buf_item.c              |   8 +-
 fs/xfs/xfs_buf_item.h              |   2 +-
 fs/xfs/xfs_buf_item_recover.c      |   2 +-
 fs/xfs/xfs_dquot.c                 |  28 ++--
 fs/xfs/xfs_extfree_item.c          |  33 ++--
 fs/xfs/xfs_extfree_item.h          |   6 +-
 fs/xfs/xfs_icache.c                |  10 +-
 fs/xfs/xfs_icreate_item.c          |   6 +-
 fs/xfs/xfs_icreate_item.h          |   2 +-
 fs/xfs/xfs_inode.c                 |   2 +-
 fs/xfs/xfs_inode.h                 |   2 +-
 fs/xfs/xfs_inode_item.c            |   6 +-
 fs/xfs/xfs_inode_item.h            |   2 +-
 fs/xfs/xfs_ioctl.c                 |   6 +-
 fs/xfs/xfs_log.c                   |   6 +-
 fs/xfs/xfs_log_priv.h              |   2 +-
 fs/xfs/xfs_log_recover.c           |  12 +-
 fs/xfs/xfs_mount.c                 |  14 ++
 fs/xfs/xfs_mount.h                 |   5 +-
 fs/xfs/xfs_mru_cache.c             |   2 +-
 fs/xfs/xfs_qm.c                    |   2 +-
 fs/xfs/xfs_qm.h                    |   2 +-
 fs/xfs/xfs_refcount_item.c         |  18 +-
 fs/xfs/xfs_refcount_item.h         |   6 +-
 fs/xfs/xfs_reflink.c               |   2 +-
 fs/xfs/xfs_rmap_item.c             |  18 +-
 fs/xfs/xfs_rmap_item.h             |   6 +-
 fs/xfs/xfs_super.c                 | 234 +++++++++++++-------------
 fs/xfs/xfs_sysfs.c                 |  24 +--
 fs/xfs/xfs_trace.h                 |   2 +-
 fs/xfs/xfs_trans.c                 |  16 +-
 fs/xfs/xfs_trans.h                 |   8 +-
 fs/xfs/xfs_trans_dquot.c           |   4 +-
 89 files changed, 1655 insertions(+), 899 deletions(-)
