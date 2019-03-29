Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729639AbfC2NlA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Mar 2019 09:41:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 237FB369A0
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 13:41:00 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2C47282EE
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 13:40:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: a couple minor shutdown fixes
Date: Fri, 29 Mar 2019 09:40:57 -0400
Message-Id: <20190329134059.12723-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here are a couple of shutdown fixups that fell out of Darrick's recent
report of a deadlock problem via generic/475. I've still not been able
to reproduce the generic/475 deadlock, but Darrick has tested patch 1
and last I heard reported that the deadlock had not reoccurred. Patch 2
fixes up a buffer leak and reorders the shutdown in the
xfs_iflush_cluster() abort codepath.

After making a higher level pass across the codebase, there are still
places where we technically invoke synchronous log forces (or filesystem
shutdowns, which can induce a sync log force) with various object locks
held. This isn't always a problem as some are contexts where a buffer
should never be pinned, etc. That said, if we want to institute a
general policy of never inducing sync log forces or shutdowns from
contexts with held locks then I'd suggest that's something we should
evolve opportunistically over time.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  xfs: wake commit waiters on CIL abort before log item abort
  xfs: shutdown after buf release in iflush cluster abort path

 fs/xfs/xfs_inode.c   |  4 +++-
 fs/xfs/xfs_log_cil.c | 21 +++++++++++++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.17.2
