Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:36949 "EHLO
        lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdJSHDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:03:30 -0400
From: Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v2 0/4] Fix false positives by cross-release feature
Date: Thu, 19 Oct 2017 16:03:23 +0900
Message-Id: <1508396607-25362-1-git-send-email-byungchul.park@lge.com>
In-Reply-To: <1508392531-11284-1-git-send-email-byungchul.park@lge.com>
References: <1508392531-11284-1-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: peterz@infradead.org, mingo@kernel.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com

I attached this patchset into another thread for patches fixing a
performance regression by cross-release, so that the cross-release can
be re-enabled easily as the last, after fixing false positives as well.

Changes from v1
- Separate a patch removing white space

Byungchul Park (4):
  completion: Add support for initializing completion with lockdep_map
  lockdep: Remove unnecessary acquisitions wrt workqueue flush
  genhd.h: Remove trailing white space
  lockdep: Assign a lock_class per gendisk used for
    wait_for_completion()

 block/bio.c                |  2 +-
 block/genhd.c              | 13 +++++--------
 include/linux/completion.h |  8 ++++++++
 include/linux/genhd.h      | 26 ++++++++++++++++++++++----
 include/linux/workqueue.h  |  4 ++--
 kernel/workqueue.c         | 20 ++++----------------
 6 files changed, 42 insertions(+), 31 deletions(-)

-- 
1.9.1

