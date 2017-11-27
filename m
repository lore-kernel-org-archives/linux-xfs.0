Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751773AbdK0UYg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 15:24:36 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB502C0587C2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 20:24:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DD665D9C6
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 20:24:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfs: inode transaction reservation fixups
Date: Mon, 27 Nov 2017 15:24:30 -0500
Message-Id: <20171127202434.43125-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This series fixes up a few issues related to the xfs_inactive_ifree()
reservation overruns that have been reported on occasion. Patch 1 is a
small fixup to include a bit more data in overrun dumps, patch 2 fixes
an old inode free reservation bug, patch 3 fixes the actual overrun by
implementing an agfl fixup limit and patch 4 is some refactoring of
inode transactions that fell out of discussions on how to address the
problem [1]. 

Patches 1-3 survive an xfstests run and a couple iterations (so far) of
the workload that has consistently reproduced the overrun. I plan to run
the latter test a bit longer and repeat with patch 4 included. Note that
patch 4 is RFC and compile tested only atm.

Thoughts, reviews, flames appreciated.

Brian

[1] https://marc.info/?l=linux-xfs&m=151127676203410&w=2

Brian Foster (4):
  xfs: print transaction log reservation on overrun
  xfs: include inobt buffers in ifree tx log reservation
  xfs: amortize agfl block frees across multiple transactions
  xfs: include an allocfree res for inobt modifications

 fs/xfs/libxfs/xfs_alloc.c      | 15 ++++---
 fs/xfs/libxfs/xfs_trans_resv.c | 93 +++++++++++++++++++++---------------------
 fs/xfs/xfs_log.c               |  4 +-
 3 files changed, 60 insertions(+), 52 deletions(-)

-- 
2.13.6

