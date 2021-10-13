Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B22C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 01:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA55C60EE5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 01:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhJMCBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 22:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230398AbhJMCBU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 22:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD70D60720
        for <linux-xfs@vger.kernel.org>; Wed, 13 Oct 2021 01:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634090357;
        bh=qDR7OJs2rbf94vuB67YhWX9p9dH67B1YW4+k+aJ/4rE=;
        h=Date:From:To:Subject:From;
        b=uW8Dwke9eLp0wUYZm7bcNaLNOXcnxb8Y7iSVG9aVkSbwLsEn1Qp+CZpvbFPS/93C1
         ZdoJRzEvsmd5p0MLfmgn+DctJi1CyP3T39xYSQrXSDtQDOQwcUKCaU8jz+bfeM6kjQ
         9ENUV3rhgvAFu8ujtJs+Ih2g/FuXEntwZKmEPyFpF6oATdeNH0Kyzvsw4L2scypxuF
         bzv5yaWGYqTxqS29wmZuCBmWo2EMz9OltXFqrQO/HQIxDkjTMFzfvCIZqyVk2xgju+
         dTMJHVs1LHjojjJCYZInWv7C+ljWsv3iRD9cq4OPcH8fw3kw3c1bdk1OXc87s3Fc2A
         /mqoS5sUKCqRg==
Date:   Tue, 12 Oct 2021 18:59:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to b06b65cb3f9b
Message-ID: <20211013015917.GT24307@magnolia>
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
the next update.  I think the only ones I know about are Brian's perag
iteration patches, the btree cursor and zone cleanups, and I plan to
start taking a fresh look at Shiyang's DAX patches tomorrow.

The new head of the for-next branch is commit:

b06b65cb3f9b xfs: remove the xfs_dqblk_t typedef

New Commits:

Christoph Hellwig (3):
      [b634a75b3e5a] xfs: remove the xfs_dinode_t typedef
      [c310dcf40cd0] xfs: remove the xfs_dsb_t typedef
      [b06b65cb3f9b] xfs: remove the xfs_dqblk_t typedef

Darrick J. Wong (8):
      [031f1a417e08] xfs: formalize the process of holding onto resources across a defer roll
      [cfe5630bacde] xfs: port the defer ops capture and continue to resource capture
      [af2a15d8d09e] xfs: fix maxlevels comparisons in the btree staging code
      [e3d10ab7037b] xfs: remove xfs_btree_cur_t typedef
      [507d6b151304] xfs: don't allocate scrub contexts on the stack
      [c00bfaba5b1a] xfs: stricter btree height checking when looking for errors
      [708f9938ecfe] xfs: stricter btree height checking when scanning for btree roots
      [b912c7158477] xfs: check that bc_nlevels never overflows

Gustavo A. R. Silva (1):
      [a785fba7df9a] xfs: Use kvcalloc() instead of kvzalloc()

Rustam Kovhaev (1):
      [7a6037cfb70d] xfs: use kmem_cache_free() for kmem_cache objects


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c         |  12 +--
 fs/xfs/libxfs/xfs_bmap.c          |  12 +--
 fs/xfs/libxfs/xfs_btree.c         |  14 ++--
 fs/xfs/libxfs/xfs_btree.h         |  12 +--
 fs/xfs/libxfs/xfs_btree_staging.c |   6 +-
 fs/xfs/libxfs/xfs_defer.c         | 171 ++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_defer.h         |  38 +++++++--
 fs/xfs/libxfs/xfs_dquot_buf.c     |   4 +-
 fs/xfs/libxfs/xfs_format.h        |  12 +--
 fs/xfs/libxfs/xfs_inode_buf.c     |   6 +-
 fs/xfs/libxfs/xfs_inode_fork.c    |  16 ++--
 fs/xfs/libxfs/xfs_sb.c            |   4 +-
 fs/xfs/scrub/agheader.c           |  13 +--
 fs/xfs/scrub/agheader_repair.c    |   8 +-
 fs/xfs/scrub/btree.c              |  54 +++++++-----
 fs/xfs/scrub/dabtree.c            |  62 +++++++-------
 fs/xfs/scrub/repair.h             |   3 +
 fs/xfs/scrub/scrub.c              |  64 +++++++-------
 fs/xfs/xfs_bmap_item.c            |   2 +-
 fs/xfs/xfs_buf_item_recover.c     |   2 +-
 fs/xfs/xfs_dquot.c                |   2 +-
 fs/xfs/xfs_extfree_item.c         |   8 +-
 fs/xfs/xfs_ioctl.c                |   6 +-
 fs/xfs/xfs_log_recover.c          |  12 +--
 fs/xfs/xfs_qm.c                   |   2 +-
 fs/xfs/xfs_refcount_item.c        |   2 +-
 fs/xfs/xfs_rmap_item.c            |   2 +-
 fs/xfs/xfs_trans.c                |   8 +-
 fs/xfs/xfs_trans.h                |   6 --
 mm/slob.c                         |   6 +-
 30 files changed, 341 insertions(+), 228 deletions(-)
