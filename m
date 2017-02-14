Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752746AbdBNNDP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Feb 2017 08:03:15 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DC3C8047F
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 13:03:10 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v1ED3AlV032391
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 08:03:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/4] buffered write and indlen fixes
Date: Tue, 14 Feb 2017 08:03:05 -0500
Message-Id: <1487077389-5626-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is just a small update to rebase onto for-next with all previous
debug artifacts removed. No code changes.

Brian

v3:
- Rebase to a clean for-next branch.
v2: http://www.spinics.net/lists/linux-xfs/msg04215.html
- Use do_div() to fix 32-bit builds.
- Prepend patches 1-2 to re-enable indlen testing from xfstests.
v1: http://www.spinics.net/lists/linux-xfs/msg04083.html

Brian Foster (4):
  xfs: clear delalloc and cache on buffered write failure
  xfs: resurrect debug mode drop buffered writes mechanism
  xfs: handle indlen shortage on delalloc extent merge
  xfs: split indlen reservations fairly when under reserved

 fs/xfs/libxfs/xfs_bmap.c | 70 +++++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_iomap.c       |  9 +++++++
 fs/xfs/xfs_mount.h       | 15 ++++++-----
 fs/xfs/xfs_sysfs.c       | 14 +++++-----
 4 files changed, 73 insertions(+), 35 deletions(-)

-- 
2.7.4

