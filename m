Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27B4C388F2
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C27F223FB
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444256AbgJVFPm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 01:15:42 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59135 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2444246AbgJVFPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 01:15:42 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 98D2F3ABE3B
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 16:15:38 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-0034Kl-OR
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-009aoB-G6
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/7] repair: Phase 6 performance improvements
Date:   Thu, 22 Oct 2020 16:15:30 +1100
Message-Id: <20201022051537.2286402-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=l-sH4dQmTrt7G0A92foA:9 a=1T9b15BddVrSr8tc:21
        a=ktkXJtHXQezyTPRX:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks

Phase 6 is single threaded, processing a single AG at a time and a
single directory inode at a time.  Phase 6 if often IO latency bound
despite the prefetching it does, resulting in low disk utilisation
and high runtimes. The solution for this is the same as phase 3 and
4 - scan multiple AGs at once for directory inodes to process. This
patch set enables phase 6 to scan multiple AGS at once, and hence
requires concurrent updates of inode records as tehy can be accessed
and modified by multiple scanning threads now. We also need to
protect the bad inodes list from concurrent access and then we can
enable concurrent processing of directories.

However, directory entry checking and reconstruction can also be CPU
bound - large directories overwhelm the directory name hash
structures because the algorithms have poor scalability - one is O(n
+ n^2), another is O(n^2) when the number of dirents greatly
outsizes the hash table sizes. Hence we need to more than just
parallelise across AGs - we need to parallelise processing within
AGs so that a single large directory doesn't completely serialise
processing within an AG.  This is done by using bound-depth
workqueues to allow inode records to be processed asynchronously as
the inode records are fetched from disk.

Further, we need to fix the bad alogrithmic scalability of the in
memory directory tracking structures. This is done through a
combination of better structures and more appropriate dynamic size
choices.

The results on a filesystem with a single 10 million entry directory
containing 400MB of directory entry data is as follows:

v5.6.0 (Baseline)

       XFS_REPAIR Summary    Thu Oct 22 12:10:52 2020

Phase           Start           End             Duration
Phase 1:        10/22 12:06:41  10/22 12:06:41
Phase 2:        10/22 12:06:41  10/22 12:06:41
Phase 3:        10/22 12:06:41  10/22 12:07:00  19 seconds
Phase 4:        10/22 12:07:00  10/22 12:07:12  12 seconds
Phase 5:        10/22 12:07:12  10/22 12:07:13  1 second
Phase 6:        10/22 12:07:13  10/22 12:10:51  3 minutes, 38 seconds
Phase 7:        10/22 12:10:51  10/22 12:10:51

Total run time: 4 minutes, 10 seconds

real	4m11.151s
user	4m20.083s
sys	0m14.744s


5.9.0-rc1 + patchset:

        XFS_REPAIR Summary    Thu Oct 22 13:19:02 2020

Phase           Start           End             Duration
Phase 1:        10/22 13:18:09  10/22 13:18:09
Phase 2:        10/22 13:18:09  10/22 13:18:09
Phase 3:        10/22 13:18:09  10/22 13:18:31  22 seconds
Phase 4:        10/22 13:18:31  10/22 13:18:45  14 seconds
Phase 5:        10/22 13:18:45  10/22 13:18:45
Phase 6:        10/22 13:18:45  10/22 13:19:00  15 seconds
Phase 7:        10/22 13:19:00  10/22 13:19:00

Total run time: 51 seconds

real	0m52.375s
user	1m3.739s
sys	0m20.346s


Performance improvements on filesystems with small directories and
really fast storage are, at best, modest. The big improvements are
seen with either really large directories and/or relatively slow
devices that are IO latency bound and can benefit from having more
IO in flight at once.

Cheers,

Dave.


Dave Chinner (7):
  workqueue: bound maximum queue depth
  repair: Protect bad inode list with mutex
  repair: protect inode chunk tree records with a mutex
  repair: parallelise phase 6
  repair: don't duplicate names in phase 6
  repair: convert the dir byaddr hash to a radix tree
  repair: scale duplicate name checking in phase 6.

 libfrog/radix-tree.c |  46 +++++
 libfrog/workqueue.c  |  42 ++++-
 libfrog/workqueue.h  |   4 +
 repair/dir2.c        |  32 ++--
 repair/incore.h      |  23 +++
 repair/incore_ino.c  |  15 ++
 repair/phase6.c      | 396 +++++++++++++++++++++----------------------
 7 files changed, 338 insertions(+), 220 deletions(-)

-- 
2.28.0

