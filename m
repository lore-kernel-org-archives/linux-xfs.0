Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934674AbeFROwp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jun 2018 10:52:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs_buf_submit[_wait]() cleanups
Date: Mon, 18 Jun 2018 10:52:42 -0400
Message-Id: <20180618145244.30393-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>

These are just a couple cleanups for buffer I/O submission based on
suggestions from Christoph. This applies on top of the previously posted
delwri queue fix [1].

The combination of both slightly circuitously condenses the buf
submission path back into a single helper, but we end up in the same
place either way. I'm sending this separately because review of the
value of this interface refactor is independent of the internal refactor
required to implement the aforementioned bug fix.

Thoughts, reviews, flames appreciated.

[1] https://marc.info/?l=linux-xfs&m=152908593803756&w=2

Brian

Brian Foster (2):
  xfs: combine [a]sync buffer submission apis
  xfs: kill __xfs_buf_submit_common()

 fs/xfs/xfs_buf.c         | 125 +++++++++++++--------------------------
 fs/xfs/xfs_buf.h         |  10 +++-
 fs/xfs/xfs_log_recover.c |   4 +-
 3 files changed, 52 insertions(+), 87 deletions(-)

-- 
2.17.1

