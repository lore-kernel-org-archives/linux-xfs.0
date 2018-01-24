Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752487AbeAXIrm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 03:47:42 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DBA449036
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 08:47:42 +0000 (UTC)
Received: from odin.usersys.redhat.com (ovpn-204-234.brq.redhat.com [10.40.204.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 632FF17277
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 08:47:41 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH V2 0/3] Buffer's log item refactoring
Date: Wed, 24 Jan 2018 09:47:33 +0100
Message-Id: <20180124084736.17411-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

This is the second version of the patchset to refactor buffer's log item lists.

This new version basically contains coding style fixes, and the code refactoring
suggested by Darrick on the version 1.

The patch to remove xfs_buf typedef has also been discarded, and the remaining
patches rebased accordingly.


A few time ago Christoph suggested to use list_head API to handle buffer's
log_item_list.

This patchset aims to split the current bp->b_fspriv field into a specific field
to hold the xfs_buf_log_item, and another to hold the list of log items attached
to the buffer (3rd patch), and finally replace the singly linked list
implementation by the list_head infra-structure (4th patch).

The first two patches are just a typedef removal of xfs_buf_log_item_t and
xfs_buf_t, I did while studying how all the buffer I/O mechanism works, I
thought since we plan to get rid of the typedefs in future, this might be
useful.

I can rebase the 3rd and 4th patch on top of current xfs tree if the typedef
removal patches are useless, you guys call.

This patchset survived several xfstests runs.

Cheers.

Carlos Maiolino (3):
  Get rid of xfs_buf_log_item_t typedef
  Split buffer's b_fspriv field
  Use list_head infra-structure for buffer's log items list

 fs/xfs/libxfs/xfs_alloc.c          |   8 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |   2 +-
 fs/xfs/libxfs/xfs_btree.c          |   4 +-
 fs/xfs/libxfs/xfs_da_btree.c       |   2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |   2 +-
 fs/xfs/libxfs/xfs_dir2_data.c      |   2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |   4 +-
 fs/xfs/libxfs/xfs_sb.c             |   2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |   2 +-
 fs/xfs/xfs_buf.c                   |   1 +
 fs/xfs/xfs_buf.h                   |   3 +-
 fs/xfs/xfs_buf_item.c              | 158 ++++++++++++++++++++-----------------
 fs/xfs/xfs_buf_item.h              |   7 +-
 fs/xfs/xfs_dquot_item.c            |   2 +-
 fs/xfs/xfs_inode.c                 |   8 +-
 fs/xfs/xfs_inode_item.c            |  41 +++-------
 fs/xfs/xfs_log.c                   |   9 ++-
 fs/xfs/xfs_log_recover.c           |   6 +-
 fs/xfs/xfs_trans.h                 |   2 +-
 fs/xfs/xfs_trans_buf.c             |  98 ++++++++++++-----------
 22 files changed, 182 insertions(+), 185 deletions(-)

-- 
2.14.3

