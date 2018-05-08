Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755366AbeEHRWc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 13:22:32 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8921330BEA6D
        for <linux-xfs@vger.kernel.org>; Tue,  8 May 2018 17:22:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AB2D9EDE9
        for <linux-xfs@vger.kernel.org>; Tue,  8 May 2018 17:22:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] xfs: skip unnecessary discards
Date: Tue,  8 May 2018 13:22:28 -0400
Message-Id: <20180508172231.53570-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the skip discards series. The only difference from the
previous version is some factoring cleanups. This has since passed more
(online discard enabled) xfstests runs without exploding.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Minor cleanups.
- Dropped the eofblocks unwritten extent rfc.
v1: https://marc.info/?l=linux-xfs&m=152571670220480&w=2
- Define and use bmapi flag for eofblocks trims.
- Separate patch to skip discards of unwritten extents.
- Various factoring cleanups.
rfc: https://marc.info/?l=linux-xfs&m=152476598825563&w=2

Brian Foster (3):
  xfs: add bmapi nodiscard flag
  xfs: skip online discard during eofblocks trims
  xfs: don't discard on free of unwritten extents

 fs/xfs/libxfs/xfs_alloc.c  | 10 +++++++---
 fs/xfs/libxfs/xfs_alloc.h  | 27 +++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.c   | 18 ++++++++++++++----
 fs/xfs/libxfs/xfs_bmap.h   | 30 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_bmap_util.c     |  4 ++--
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_inode.c         | 19 +++++++++++--------
 fs/xfs/xfs_inode.h         | 24 ++++++++++++++++++++++--
 fs/xfs/xfs_trans.h         |  3 ++-
 fs/xfs/xfs_trans_extfree.c | 13 +++++++++----
 10 files changed, 121 insertions(+), 29 deletions(-)

-- 
2.14.3

