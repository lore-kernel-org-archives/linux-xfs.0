Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1224AC41621
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3AB92074D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCYBmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 21:42:08 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55232 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727189AbgCYBmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 21:42:07 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A47783A3A4A
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:42:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-0006H3-IQ
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-00035k-8T
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/8] xfs: various fixes and cleanups
Date:   Wed, 25 Mar 2020 12:41:57 +1100
Message-Id: <20200325014205.11843-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=SS2py6AdgQ4A:10 a=sXs1YXpSkZNGG69wFtgA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These are the fixes and cleanups that are part of the non-blocking
inode reclaim series I've (slowly) been working on. These fixes and
cleanups stand alone, many have already been reviewed, and getting
them out of the non-blocking reclaim patchset makes that a much
smaller and easier to digest set of patches.

The changes in this patchset are for:

- limiting the size of checkpoints that the CIL builds to reduce the
  memory it pins and the latency of commits.
- cleaning up the AIL item removal code so we can reduce the number
  of tail LSN updates to prevent unnecessary thundering herd wakeups
- account for reclaimable slab caches in XFS correctly
- account for reclaimed pages from buffers correctly
- avoiding log IO priority inversions
- factoring the inode cluster deletion code to make it more readable
  and easier to modify for the non-blocking inode reclaim mods.

Thoughts, comments and improvemnts welcome.

-Dave.


Dave Chinner (8):
  xfs: Lower CIL flush limit for large logs
  xfs: Throttle commits on delayed background CIL push
  xfs: don't allow log IO to be throttled
  xfs: Improve metadata buffer reclaim accountability
  xfs: correctly acount for reclaimable slabs
  xfs: factor common AIL item deletion code
  xfs: tail updates only need to occur when LSN changes
  xfs: factor inode lookup from xfs_ifree_cluster

 fs/xfs/xfs_buf.c        |  11 ++-
 fs/xfs/xfs_inode.c      | 152 ++++++++++++++++++++++------------------
 fs/xfs/xfs_inode_item.c |  28 ++++----
 fs/xfs/xfs_log.c        |  10 ++-
 fs/xfs/xfs_log_cil.c    |  37 ++++++++--
 fs/xfs/xfs_log_priv.h   |  53 ++++++++++++--
 fs/xfs/xfs_super.c      |   3 +-
 fs/xfs/xfs_trace.h      |   1 +
 fs/xfs/xfs_trans_ail.c  |  88 ++++++++++++++---------
 fs/xfs/xfs_trans_priv.h |   6 +-
 10 files changed, 257 insertions(+), 132 deletions(-)

-- 
2.26.0.rc2

