Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965835AbcIWUbD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Sep 2016 16:31:03 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68477C7EE3
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2016 20:31:02 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-125.bos.redhat.com [10.18.41.125])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8NKV2eT017441
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2016 16:31:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/5] fix log recovery for v5 superblocks
Date: Fri, 23 Sep 2016 16:30:55 -0400
Message-Id: <1474662660-61550-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the series to fix up log recovery to update metadata LSNs
and handle buffer submission correctly. This is mostly similar to v1.
The primary functional change is a fixup to patch 1, that came out of
the discussion with Dave, to drain queued buffers on LSN changes of
commit log records (as opposed to all LSN changes). Otherwise, fixes
include some light refactoring and comment reworks. Thoughts, reviews,
flames appreciated.

Brian

v2:
- Rebased to for-next.
- Limit LSN change trigger to log commit records.
- Comment rewrite/fixups.
- Refactor buffer validation handling of NULL current lsn callers
  (skipped bufs).
v1: http://oss.sgi.com/pipermail/xfs/2016-August/050840.html

Brian Foster (5):
  xfs: rework log recovery to submit buffers on LSN boundaries
  xfs: pass current lsn to log recovery buffer validation
  xfs: don't warn on buffers not being recovered due to LSN
  xfs: update metadata LSN in buffers during log recovery
  xfs: log recovery tracepoints to track current lsn and buffer
    submission

 fs/xfs/xfs_log_priv.h    |   3 +-
 fs/xfs/xfs_log_recover.c | 191 +++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trace.h       |  31 +++++++-
 3 files changed, 166 insertions(+), 59 deletions(-)

-- 
2.5.5

