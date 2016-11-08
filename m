Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752818AbcKHU1h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Nov 2016 15:27:37 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 565325A5D
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2016 20:27:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uA8KRbSd006634
        for <linux-xfs@vger.kernel.org>; Tue, 8 Nov 2016 15:27:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 0/4] xfs: basic cow fork speculative preallocation
Date: Tue,  8 Nov 2016 15:27:32 -0500
Message-Id: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is an experiment based on an idea for COW fork speculative
preallocation. This is experimental, lightly/barely tested and sent in
RFC form to solicit thoughts, ideas or flames before I spend time taking
it further.

Patch 1 probably stands on its own. Patches 2 and 3 are some refactoring
and patch 4 implements the basic idea, which is described in the commit
log description. The testing I've done so far is basically similar to
how one would test the effects of traditional speculative preallocation:
write to multiple reflinked files in parallel and examine the resulting
fragmentation. Specifically, I wrote sequentially to 16 different
reflinked files of the same 8GB original (which has two data extents,
completely shared). Without preallocation, the test results in ~248
extents across the 16 files. With preallocation, the test results in 32
extents across the 16 files (i.e., 2 extents per file, same as the
source file).

An obvious tradeoff is the unnecessarily aggressive allocation that
might occur in the event of random writes to a large file (such as in
the cloned VM disk image use case), but my thinking is that the
cowblocks tagging and reclaim infrastructure should manage that
sufficiently (lack of testing notwithstanding). In any event, I'm
interested in any thoughts along the lines of whether this is useful at
all, alternative algorithm ideas, etc.

Brian

Brian Foster (4):
  xfs: clean up cow fork reservation and tag inodes correctly
  xfs: logically separate iomap range from allocation range
  xfs: reuse xfs_file_iomap_begin_delay() for cow fork delalloc
  xfs: implement basic COW fork speculative preallocation

 fs/xfs/xfs_iomap.c   | 132 +++++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_reflink.c |  28 ++---------
 2 files changed, 111 insertions(+), 49 deletions(-)

-- 
2.7.4

