Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9499 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbeJaXAF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 19:00:05 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 721B3C0669BF
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 14:01:56 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC0166A059
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 14:01:55 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: don't preempt writeback on page errors
Date: Wed, 31 Oct 2018 10:01:53 -0400
Message-Id: <20181031140155.17996-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's a stab at a fix for the issue demonstrated by the previously
posted xfstest [1]. This basically just filters out error returns to
write_cache_pages() and returns the first encountered error from the
higher level ->writepage[s]() call. AFAICT the end result should be the
same as today in the event of a persistent writeback error.

I'm not totally sure if this is the best solution, but it's the simplest
that comes to mind. FWIW, this patch changes error return behavior
unconditionally. A slightly modified approach might be to only filter
errors as such on integrity writeback so background writeback will
presumably behave as it always has, while allowing fsync/unmount to
process the address space in one writeback job.

If there's a reason we want to preserve the current writeback behavior
in general, I suppose we could consider more involved options like tag
any inode that preempts writeback due to error and then make sure we
process/scan/clear such inodes of delalloc blocks before we unmount
(and/or on fsync). Either way, we may also want to consider rate
limiting the "page discard" errors if it's more likely we dump a bunch
at once.

Thoughts?

Brian

[1] https://marc.info/?l=linux-xfs&m=154031860122440&w=2

Brian Foster (2):
  xfs: add writepage map error tag
  xfs: don't preempt writeback sequence on single page wb error

 fs/xfs/libxfs/xfs_errortag.h |  4 +++-
 fs/xfs/xfs_aops.c            | 19 ++++++++++++++-----
 fs/xfs/xfs_error.c           |  3 +++
 3 files changed, 20 insertions(+), 6 deletions(-)

-- 
2.17.2
