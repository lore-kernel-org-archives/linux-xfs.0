Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1395C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 16:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbiGNQpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jul 2022 12:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbiGNQox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jul 2022 12:44:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD61626118
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 09:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 743AA62058
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 16:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06DAC3411C
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657817030;
        bh=Wt+nIq18ANdHZUv/e+xJ1g7FwIvsNluvNWag8WOviTk=;
        h=Date:From:To:Subject:From;
        b=Wj1j8QrvS8FqwC1riI8eBpVKGWbiJxduyM31bmIo+qVJgCE9IiiF08ACHvqZp3+2k
         aCalNPj+ZXsfeaYpTLMGE5AF5vNDTWxG2Z5rsf4sRKROzOxTHkYlw3c2DwWLvAGEXF
         GelJ+6yY0bAjhrOpHRQ2tiDWD4IUlxGHsmaknH1vq2ebI4vvnTcLPYtkIHYJpKlEdk
         fNMZL4APz1V25XG5hJ+WS2RDLKEgWKjK3AA3pWmCz5rF5n4tSJNnbQR1aJLJl9tDbm
         7RtEb/zzwqJR1kUEFfr9mPqDWi5YSJtInt1/m4HkyyiqNTHiQrNamXFoVQtVfzU4U6
         x1kLB4h57P0qQ==
Date:   Thu, 14 Jul 2022 09:43:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULL] xfs: make attr forks permanent
Message-ID: <YtBHxsAoYgHikPSu@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi me,

Here's a pull request to fix that attr fork UAF problem and preparing
for a future where files always have xattrs by making the forks
permanent installations.

--D
------
The following changes since commit 0f38063d7a38015a47ca1488406bf21e0effe80e:

  xfs: removed useless condition in function xfs_attr_node_get (2022-07-09 10:56:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/make-attr-fork-permanent-5.20_2022-07-14

for you to fetch changes up to c01147d929899f02a0a8b15e406d12784768ca72:

  xfs: replace inode fork size macros with functions (2022-07-12 11:17:27 -0700)

----------------------------------------------------------------
xfs: make attr forks permanent

This series fixes a use-after-free bug that syzbot uncovered.  The UAF
itself is a result of a race condition between getxattr and removexattr
because callers to getxattr do not necessarily take any sort of locks
before calling into the filesystem.

Although the race condition itself can be fixed through clever use of a
memory barrier, further consideration of the use cases of extended
attributes shows that most files always have at least one attribute, so
we might as well make them permanent.

v2: Minor tweaks suggested by Dave, and convert some more macros to
helper functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
      xfs: convert XFS_IFORK_PTR to a static inline helper
      xfs: make inode attribute forks a permanent part of struct xfs_inode
      xfs: use XFS_IFORK_Q to determine the presence of an xattr fork
      xfs: replace XFS_IFORK_Q with a proper predicate function
      xfs: replace inode fork size macros with functions

 fs/xfs/libxfs/xfs_attr.c           | 20 +++++-----
 fs/xfs/libxfs/xfs_attr.h           | 10 ++---
 fs/xfs/libxfs/xfs_attr_leaf.c      | 29 +++++++-------
 fs/xfs/libxfs/xfs_bmap.c           | 81 +++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_bmap_btree.c     | 10 ++---
 fs/xfs/libxfs/xfs_btree.c          |  4 +-
 fs/xfs/libxfs/xfs_dir2.c           |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |  6 +--
 fs/xfs/libxfs/xfs_dir2_sf.c        |  8 ++--
 fs/xfs/libxfs/xfs_inode_buf.c      |  7 ++--
 fs/xfs/libxfs/xfs_inode_fork.c     | 65 ++++++++++++++++--------------
 fs/xfs/libxfs/xfs_inode_fork.h     | 27 ++-----------
 fs/xfs/libxfs/xfs_symlink_remote.c |  2 +-
 fs/xfs/scrub/bmap.c                | 14 +++----
 fs/xfs/scrub/btree.c               |  2 +-
 fs/xfs/scrub/dabtree.c             |  2 +-
 fs/xfs/scrub/dir.c                 |  2 +-
 fs/xfs/scrub/quota.c               |  2 +-
 fs/xfs/scrub/symlink.c             |  6 +--
 fs/xfs/xfs_attr_inactive.c         | 16 +++-----
 fs/xfs/xfs_attr_list.c             |  9 ++---
 fs/xfs/xfs_bmap_util.c             | 22 +++++------
 fs/xfs/xfs_dir2_readdir.c          |  2 +-
 fs/xfs/xfs_icache.c                | 12 +++---
 fs/xfs/xfs_inode.c                 | 24 +++++------
 fs/xfs/xfs_inode.h                 | 62 ++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode_item.c            | 58 +++++++++++++--------------
 fs/xfs/xfs_ioctl.c                 |  2 +-
 fs/xfs/xfs_iomap.c                 |  8 ++--
 fs/xfs/xfs_iops.c                  |  2 +-
 fs/xfs/xfs_itable.c                |  4 +-
 fs/xfs/xfs_qm.c                    |  2 +-
 fs/xfs/xfs_reflink.c               |  6 +--
 fs/xfs/xfs_symlink.c               |  2 +-
 fs/xfs/xfs_trace.h                 |  2 +-
 35 files changed, 285 insertions(+), 247 deletions(-)
