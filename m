Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752942AbdBITgm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 14:36:42 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D5967F771
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2017 19:34:55 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v19JYt1C027236
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2017 14:34:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/4] buffered write and indlen fixes
Date: Thu,  9 Feb 2017 14:34:49 -0500
Message-Id: <1486668893-44633-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is v2 of the indlen split fixup series. The indlen patches are
mostly the same except for changes to use do_div() rather than built-in
division, which causes problems on 32-bit arches.

Patches 1-2 are new and facilitate testing. Patch 1 fixes a couple
issues in buffered write failure handling that I ran into. Patch 2
reintroduces the "fail writes" mechanism as a "drop writes" mechanism to
re-enable the ability to test the indlen code from userspace. I will
follow up with xfstests patches shortly that use this mechanism to
reproduce both issues fixed by patches 3 and 4. Thoughts, reviews,
flames appreciated.

Brian

v2:
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

