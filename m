Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933498AbeFMLFR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 07:05:17 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B404387A7C
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jun 2018 11:05:16 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D7BC2026987
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jun 2018 11:05:16 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/2] xfs: fix buffer delwri queue state race
Date: Wed, 13 Jun 2018 07:05:14 -0400
Message-Id: <20180613110516.65494-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's a v2 of the patches to fix the buffer delwri queue state race
problem (documented in the patch 2 commit log). This takes a completely
different approach from v1, as suggested by Dave during review of v1.

Patch 1 refactors the buffer submission paths and patch 2 closes the
race by using synchronous buffer I/O for synchronous delwri queues. This
survives a full xfstests run as well as lowmem stress testing of
xfs/305 [1].

Thoughts, reviews, flames appreciated.

Brian

[1] If run long enough, I do eventually hit some presumably unrelated
issues that are not currently reproducible simply due to the fact that
the delwri queue issue is more prevalent.

v2:
- Implement sync buffer I/O for sync delwri queues instead of buffer
  wait list stealing.
v1: https://marc.info/?l=linux-xfs&m=152837528705511&w=2

Brian Foster (2):
  xfs: refactor buffer submission into a common helper
  xfs: use sync buffer I/O for sync delwri queue submission

 fs/xfs/xfs_buf.c | 164 +++++++++++++++++++++++------------------------
 1 file changed, 79 insertions(+), 85 deletions(-)

-- 
2.17.1

