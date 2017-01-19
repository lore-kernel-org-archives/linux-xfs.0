Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754226AbdASTAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jan 2017 14:00:13 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 436D27E9C5
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 19:00:14 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0JJ0DJ4020354
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 14:00:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] xfs: eofblocks serialization fixes
Date: Thu, 19 Jan 2017 14:00:08 -0500
Message-Id: <1484852411-1137-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here is v2 of the xfs_free_eofblocks() i_size fix. Patch 1 is new and
kills off the need_iolock parameter as suggested by Christoph. Patch 2
is also new and fixes a separate bug I ran into during testing where
multiple threads crash into ENOSPC, run eofb scans in parallel and
livelock against eachother because inode iolocks are held across entire
eofb scans. Patch 3 is roughly the same as v1: serialize
xfs_free_eofblocks() against file-extending async dio writes via
inode_dio_wait().

Thoughts, reviews, flames appreciated.

Brian

v2:
- Kill off the xfs_free_eofblocks() need_iolock parameter. All callers
  must acquire IOLOCK_EXCL.
- Drop iolock across internal low free space scans to avoid livelock.
v1: http://www.spinics.net/lists/linux-xfs/msg03437.html

Brian Foster (3):
  xfs: pull up iolock from xfs_free_eofblocks()
  xfs: sync eofblocks scans under iolock are livelock prone
  xfs: fix eofblocks race with file extending async dio writes

 fs/xfs/xfs_bmap_util.c | 42 +++++++++++++++--------------------
 fs/xfs/xfs_bmap_util.h |  3 +--
 fs/xfs/xfs_file.c      | 13 +++++++----
 fs/xfs/xfs_icache.c    | 59 +++++++++++++++-----------------------------------
 fs/xfs/xfs_icache.h    |  2 --
 fs/xfs/xfs_inode.c     | 51 +++++++++++++++++++++++--------------------
 6 files changed, 73 insertions(+), 97 deletions(-)

-- 
2.7.4

