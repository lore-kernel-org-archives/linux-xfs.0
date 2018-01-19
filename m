Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753841AbeASOJC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jan 2018 09:09:02 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 484C2A4533
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2018 14:09:02 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8BB95D6B7
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2018 14:09:01 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/4] Buffer's log item refactoring
Date: Fri, 19 Jan 2018 15:08:43 +0100
Message-Id: <20180119140847.22934-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

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

Carlos Maiolino (4):
  Get rid of xfs_buf_log_item_t typedef
  Get rid of xfs_buf_t typedef
  Split buffer's b_fspriv field
  Use list_head infra-structure for buffer's log items list

 fs/xfs/libxfs/xfs_alloc.c          |  36 ++++----
 fs/xfs/libxfs/xfs_attr_leaf.c      |   2 +-
 fs/xfs/libxfs/xfs_bmap.c           |   8 +-
 fs/xfs/libxfs/xfs_btree.c          |  26 +++---
 fs/xfs/libxfs/xfs_btree.h          |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c       |   2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |   2 +-
 fs/xfs/libxfs/xfs_dir2_data.c      |   2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  18 ++--
 fs/xfs/libxfs/xfs_inode_buf.c      |   4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c       |  22 ++---
 fs/xfs/libxfs/xfs_sb.c             |   2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |   2 +-
 fs/xfs/xfs_buf.c                   | 140 +++++++++++++++----------------
 fs/xfs/xfs_buf.h                   |  21 ++---
 fs/xfs/xfs_buf_item.c              | 166 ++++++++++++++++++++-----------------
 fs/xfs/xfs_buf_item.h              |   7 +-
 fs/xfs/xfs_dquot.c                 |  22 ++---
 fs/xfs/xfs_dquot_item.c            |   2 +-
 fs/xfs/xfs_fsops.c                 |   2 +-
 fs/xfs/xfs_inode.c                 |  24 +++---
 fs/xfs/xfs_inode_item.c            |  41 +++------
 fs/xfs/xfs_itable.c                |   2 +-
 fs/xfs/xfs_log.c                   |  26 +++---
 fs/xfs/xfs_log_recover.c           |  46 +++++-----
 fs/xfs/xfs_qm.c                    |   8 +-
 fs/xfs/xfs_rtalloc.c               |  20 ++---
 fs/xfs/xfs_rtalloc.h               |   4 +-
 fs/xfs/xfs_symlink.c               |  22 ++---
 fs/xfs/xfs_trans.c                 |   2 +-
 fs/xfs/xfs_trans.h                 |   4 +-
 fs/xfs/xfs_trans_buf.c             | 104 ++++++++++++-----------
 34 files changed, 397 insertions(+), 398 deletions(-)

-- 
2.14.3

