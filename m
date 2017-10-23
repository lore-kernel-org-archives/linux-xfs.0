Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751282AbdJWOqs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Oct 2017 10:46:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F6BFC070133
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3289478DF2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfs: miscellaneous log recovery fixes
Date: Mon, 23 Oct 2017 10:46:42 -0400
Message-Id: <20171023144646.50107-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

These are several minor fixes that fell out of both Zorro's[1] and
Darrick's[2] recent reports. Patches 1 and 2 address the log cycle
underflow problem on filesystems with logs that are sized too small by
mfks. Patch 3 drains the lru after log recovery to prevent buffers from
lingering with NULL verifier ops after log recovery completes (on v4
fs'). Patch 4 adds a mount time check to enforce that the total log
buffer size does not exceed 1/2 the physical log size, as suggested by
Dave[3].

Note that patch 4 is RFC for a couple reasons. First, I don't quite grok
where the 1/2 log size restriction comes from, so I'd like to be able to
at least include a more descriptive commit log on that. Second, this
patch causes a couple xfstests failures (xfs/030, xfs/057) when testing
with larger log buf sizes on filesystems that otherwise have
sufficiently sized logs (i.e., logbufs=8,logbsize=256k w/ a 3MB log), so
I'm not totally convinced this restriction is necessary (or 50% is the
right restriction) without some further feedback on that. For example,
should we always enforce this restriction as the current patch does, or
only when the log happens to be under the (expected) minimum size?

Thoughts, reviews, flames appreciated.

Brian

[1] https://marc.info/?l=linux-xfs&m=150674214217044&w=2
[2] https://marc.info/?l=linux-xfs&m=150792056128414&w=2
[3] https://marc.info/?l=linux-xfs&m=150819276824933&w=2

Brian Foster (4):
  xfs: sanity check log record range parameters
  xfs: fix log block underflow during recovery cycle verification
  xfs: drain the buffer LRU on mount
  xfs: enforce a maximum total iclog buffer size

 fs/xfs/xfs_log.c         | 21 +++++++++++++++++++++
 fs/xfs/xfs_log_recover.c | 13 ++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

-- 
2.9.5

