Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387992AbeGWOFX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:05:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44DA44059FEC
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F10E111AF23
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 00/15] xfs: embed dfops in the transaction
Date: Mon, 23 Jul 2018 09:03:59 -0400
Message-Id: <20180723130414.47980-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here is v2 of the series to embed dfops in the transaction. This is
rebased onto Darrick's recently posted[1] xfs_defer_finish() patch to
ensure the associated function returns with a clean transaction. A new
patch is appended to the series to avoid that extra roll when
xfs_defer_finish() is called via the transaction commit path. Otherwise
this has minor updates based on feedback to v1.

Note that, as discussed, I'm working on some changes to further condense
xfs_defer_ops with the transaction structure (such as automatic dfops
relogging). Those changes will be part of a separate series.

Thoughts, reviews, flames appreciated.

Brian

[1] https://marc.info/?l=linux-xfs&m=153192905211637&w=2

v2:
- Rebase on djwong xfs_defer_finish() final tx roll patch.
- Added patch to skip extra roll on dfops finish via tx commit.
- Split up assert in xfs_reflink_cancel_cow_blocks().
- Use memset()/memcpy() rather than open-coded reset/copy.
- Relocated struct xfs_defer_ops and xfs_defer_cancel() defs to avoid
  header file include mess.
v1: https://marc.info/?l=linux-xfs&m=153200816200883&w=2

Brian Foster (15):
  xfs: pull up dfops from xfs_itruncate_extents()
  xfs: use ->t_dfops in log recovery intent processing
  xfs: fix transaction leak on remote attr set/remove failure
  xfs: make deferred processing safe for embedded dfops
  xfs: remove unused deferred ops committed field
  xfs: reset dfops to initial state after finish
  xfs: pack holes in xfs_defer_ops and xfs_trans
  xfs: support embedded dfops in transaction
  xfs: use internal dfops in cow blocks cancel
  xfs: use internal dfops in attr code
  xfs: use internal dfops during [b|c]ui recovery
  xfs: remove all boilerplate defer init/finish code
  xfs: remove unnecessary dfops init calls in xattr code
  xfs: drop unnecessary xfs_defer_finish() dfops parameter
  xfs: bypass final dfops roll in trans commit path

 fs/xfs/libxfs/xfs_attr.c        | 49 ++++++-----------
 fs/xfs/libxfs/xfs_attr_remote.c | 13 ++---
 fs/xfs/libxfs/xfs_bmap.c        | 16 +-----
 fs/xfs/libxfs/xfs_defer.c       | 97 +++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_defer.h       | 21 ++-----
 fs/xfs/libxfs/xfs_refcount.c    | 10 +---
 fs/xfs/xfs_attr_inactive.c      |  1 +
 fs/xfs/xfs_bmap_item.c          | 21 +++----
 fs/xfs/xfs_bmap_util.c          | 45 +++------------
 fs/xfs/xfs_dquot.c              |  8 +--
 fs/xfs/xfs_inode.c              | 87 ++++++-----------------------
 fs/xfs/xfs_iomap.c              | 26 +--------
 fs/xfs/xfs_iops.c               |  1 +
 fs/xfs/xfs_log_recover.c        | 12 +---
 fs/xfs/xfs_qm_syscalls.c        |  1 +
 fs/xfs/xfs_refcount_item.c      | 30 +++++-----
 fs/xfs/xfs_reflink.c            | 51 ++++++-----------
 fs/xfs/xfs_rtalloc.c            |  9 +--
 fs/xfs/xfs_symlink.c            | 38 +++----------
 fs/xfs/xfs_trace.h              |  8 +--
 fs/xfs/xfs_trans.c              | 37 +++++++++++--
 fs/xfs/xfs_trans.h              | 22 +++++++-
 22 files changed, 240 insertions(+), 363 deletions(-)

-- 
2.17.1

