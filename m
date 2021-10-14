Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2311CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 017E5610D1
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhJNQaG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 12:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231624AbhJNQaF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 12:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6CA4610D1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634228880;
        bh=1HojojUmSuSYw6J1cbY7BCI7wSpsu3CXawPVYkBX/W0=;
        h=Date:From:To:Subject:From;
        b=sQyxBasnqfrSVInPSbEfbG0S1JgzdYVwzzU899xpMJL18agm9Wh91x5spkpc0gz6p
         DJ09YecKJidU7o62Z1XDv1ZiUejDRPK0H4CCCQLpSO266D3kZPSyy0lQE+dxbaa+Kc
         QVbomfFHtSKk8OJ3+wrXbx9J8Sn6C0stxqqJEiFMmS4HS1J+pePYjj1jbNwQBY8VZO
         a3ZEUQSnNRw+ViptTcjwhS/JmWwS0L0w8hth7rrMME/kkDC55T9G4HxDWxrkiniaEi
         SyAJrolvb5Lh6DCwjmXlJ4trBy1pNYuc2DFnYpb42KP3spaUtFMJXs0tbgYD+AMdnm
         6gBsGNgxV854Q==
Date:   Thu, 14 Oct 2021 09:28:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next **REBASED** to 11a83f4c3930
Message-ID: <20211014162800.GB24307@magnolia>
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

Apologies for the rebase -- after looking through the patches a second
time, I noticed that Rustam's patch contained changes to the SLOB code,
decided that wasn't appropriate for an xfs patch, and kicked out that
chunk.

The new head of the for-next branch is commit:

11a83f4c3930 xfs: remove the xfs_dqblk_t typedef

New Commits:

Christoph Hellwig (3):
      [de38db7239c4] xfs: remove the xfs_dinode_t typedef
      [ed67ebfd7c40] xfs: remove the xfs_dsb_t typedef
      [11a83f4c3930] xfs: remove the xfs_dqblk_t typedef

Darrick J. Wong (8):
      [c5db9f937b29] xfs: formalize the process of holding onto resources across a defer roll
      [512edfac85d2] xfs: port the defer ops capture and continue to resource capture
      [78e8ec83a404] xfs: fix maxlevels comparisons in the btree staging code
      [ae127f087dc2] xfs: remove xfs_btree_cur_t typedef
      [510a28e195cd] xfs: don't allocate scrub contexts on the stack
      [f4585e82340b] xfs: stricter btree height checking when looking for errors
      [1ba6fd34ca63] xfs: stricter btree height checking when scanning for btree roots
      [4c175af2ccd3] xfs: check that bc_nlevels never overflows

Gustavo A. R. Silva (1):
      [a785fba7df9a] xfs: Use kvcalloc() instead of kvzalloc()

Rustam Kovhaev (1):
      [c30a0cbd07ec] xfs: use kmem_cache_free() for kmem_cache objects


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
 29 files changed, 337 insertions(+), 226 deletions(-)
