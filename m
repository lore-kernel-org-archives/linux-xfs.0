Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1CDC43334
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jul 2022 22:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiGIWsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jul 2022 18:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGIWsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jul 2022 18:48:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C00AE5C
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 15:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25017B80816
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 22:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35C9C3411C;
        Sat,  9 Jul 2022 22:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657406916;
        bh=TtuT+Poa5D6ZmySJ93Y3Ht+gp7M9gOcYrkG28cJXamY=;
        h=Subject:From:To:Cc:Date:From;
        b=VaPpdSVB4vIXvvL9kxGU3DLEBwObtyJjhIXKCqELZJWl280G2bfUnfKLbstbJSlX9
         GeIzAAyu2cihLYo5U0v1GAqOkeGJCCWi6yTTMSl9w9W2enxRun6vH9zQmRTx38mSxT
         fitROaPMJW1bt6Eqa2YP4K3iYmQa7x25E7L185bkshbylVQDjyhua00YyKKBNLbO/0
         +UIgVg2sOi9sJBZvfBMy47mMhOUOv+wy4cg/dZXaDRQd4p8LAi890AgICuuqXs9nZ1
         RwIGfnrmhrMJ878wM7y8LBdO2uBuDMv12mN4DrqeFH1qX0CH5bD4Fe+39kiWQuXry1
         f0sdz1bxITKUw==
Subject: [PATCHSET v2 0/5] xfs: make attr forks permanent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Date:   Sat, 09 Jul 2022 15:48:36 -0700
Message-ID: <165740691606.73293.12753862498202082021.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes a use-after-free bug that syzbot uncovered.  The UAF
itself is a result of a race condition between getxattr and removexattr
because callers to getxattr do not necessarily take any sort of locks
before calling into the filesystem.

Although the race condition itself can be fixed through clever use of a
memory barrier, further consideration of the use cases of extended
attributes shows that most files always have at least one attribute, so
we might as well make them permanent.

Note: Patch 3 still needs review.

v2: Minor tweaks suggested by Dave, and convert some more macros to
helper functions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=make-attr-fork-permanent-5.20
---
 fs/xfs/libxfs/xfs_attr.c           |   20 ++++-----
 fs/xfs/libxfs/xfs_attr.h           |   10 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c      |   29 ++++++-------
 fs/xfs/libxfs/xfs_bmap.c           |   81 ++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |   10 ++--
 fs/xfs/libxfs/xfs_btree.c          |    4 +-
 fs/xfs/libxfs/xfs_dir2.c           |    2 -
 fs/xfs/libxfs/xfs_dir2_block.c     |    6 +--
 fs/xfs/libxfs/xfs_dir2_sf.c        |    8 ++--
 fs/xfs/libxfs/xfs_inode_buf.c      |    7 +--
 fs/xfs/libxfs/xfs_inode_fork.c     |   65 ++++++++++++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.h     |   27 ++----------
 fs/xfs/libxfs/xfs_symlink_remote.c |    2 -
 fs/xfs/scrub/bmap.c                |   14 +++---
 fs/xfs/scrub/btree.c               |    2 -
 fs/xfs/scrub/dabtree.c             |    2 -
 fs/xfs/scrub/dir.c                 |    2 -
 fs/xfs/scrub/quota.c               |    2 -
 fs/xfs/scrub/symlink.c             |    6 +--
 fs/xfs/xfs_attr_inactive.c         |   16 +++----
 fs/xfs/xfs_attr_list.c             |    9 ++--
 fs/xfs/xfs_bmap_util.c             |   22 +++++-----
 fs/xfs/xfs_dir2_readdir.c          |    2 -
 fs/xfs/xfs_icache.c                |   12 +++--
 fs/xfs/xfs_inode.c                 |   24 +++++------
 fs/xfs/xfs_inode.h                 |   62 +++++++++++++++++++++++++++-
 fs/xfs/xfs_inode_item.c            |   58 +++++++++++++-------------
 fs/xfs/xfs_ioctl.c                 |    2 -
 fs/xfs/xfs_iomap.c                 |    8 ++--
 fs/xfs/xfs_iops.c                  |    2 -
 fs/xfs/xfs_itable.c                |    4 +-
 fs/xfs/xfs_qm.c                    |    2 -
 fs/xfs/xfs_reflink.c               |    6 +--
 fs/xfs/xfs_symlink.c               |    2 -
 fs/xfs/xfs_trace.h                 |    2 -
 35 files changed, 285 insertions(+), 247 deletions(-)

