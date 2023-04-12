Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5424C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDLDqJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLDqI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F1530E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BEA362D90
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AF5C433EF;
        Wed, 12 Apr 2023 03:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271166;
        bh=5jjg4cKduQSG67kiQ5yGAwss9+Nb+f522mP4Qh3s/UQ=;
        h=Date:Subject:From:To:Cc:From;
        b=escV3sTcX/AadC/afDEl48vgGMSqzdkU0C9Bw5L1fk6nVjCmxgdASVWzPe5KwHiNh
         1t2+NfEWxALLXtDgVkOVY+7/xWRZ2clRqO0Lo/SrsqJLxNKjTx8ls1nlTlLc63r/O8
         /YGd7HME1d0REXn7w7F63/utggbF1sgOhMuxl3RrhE+TiojXQknIbk5dLihqntEOmf
         +iEc95s0toLu7qJ5rwnRVBUcE2KxW9hvXbOZIW93jmDcNZBKu6bSpm7XXaZhO2AoSm
         25Wd4rka/fGAawpVPw/GyvWT6YxDK7Ev0E5kdl9XiYk2ZoxAFg6py9zaFchelME1OS
         6PCtrXf9Gm51Q==
Date:   Tue, 11 Apr 2023 20:46:06 -0700
Subject: [GIT PULL 5/22] xfs: drain deferred work items when scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094157.417736.10965865343075972034.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ecc73f8a58c7844b04186726f8699ba97cec2ef9:

xfs: update copyright years for scrub/ files (2023-04-11 18:59:57 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-drain-intents-6.4_2023-04-11

for you to fetch changes up to 88accf17226733088923635b580779a3c86b6f23:

xfs: scrub should use ECHRNG to signal that the drain is needed (2023-04-11 19:00:00 -0700)

----------------------------------------------------------------
xfs: drain deferred work items when scrubbing [v24.5]

The design doc for XFS online fsck contains a long discussion of the
eventual consistency models in use for XFS metadata.  In that chapter,
we note that it is possible for scrub to collide with a chain of
deferred space metadata updates, and proposes a lightweight solution:
The use of a pending-intents counter so that scrub can wait for the
system to drain all chains.

This patchset implements that scrub drain.  The first patch implements
the basic mechanism, and the subsequent patches reduce the runtime
overhead by converting the implementation to use sloppy counters and
introducing jump labels to avoid walking into scrub hooks when it isn't
running.  This last paradigm repeats elsewhere in this megaseries.

v23.1: make intent items take an active ref to the perag structure and
document why we bump and drop the intent counts when we do

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: add a tracepoint to report incorrect extent refcounts
xfs: allow queued AG intents to drain before scrubbing
xfs: clean up scrub context if scrub setup returns -EDEADLOCK
xfs: minimize overhead of drain wakeups by using jump labels
xfs: scrub should use ECHRNG to signal that the drain is needed

fs/xfs/Kconfig             |   5 ++
fs/xfs/Makefile            |   2 +
fs/xfs/libxfs/xfs_ag.c     |   4 ++
fs/xfs/libxfs/xfs_ag.h     |   8 +++
fs/xfs/libxfs/xfs_defer.c  |   6 +-
fs/xfs/scrub/agheader.c    |   9 +++
fs/xfs/scrub/alloc.c       |   3 +
fs/xfs/scrub/bmap.c        |   3 +
fs/xfs/scrub/btree.c       |   1 +
fs/xfs/scrub/common.c      | 137 ++++++++++++++++++++++++++++++++++---
fs/xfs/scrub/common.h      |  15 ++++
fs/xfs/scrub/dabtree.c     |   1 +
fs/xfs/scrub/fscounters.c  |   7 ++
fs/xfs/scrub/health.c      |   2 +
fs/xfs/scrub/ialloc.c      |   2 +
fs/xfs/scrub/inode.c       |   3 +
fs/xfs/scrub/quota.c       |   3 +
fs/xfs/scrub/refcount.c    |   9 ++-
fs/xfs/scrub/repair.c      |   3 +
fs/xfs/scrub/rmap.c        |   3 +
fs/xfs/scrub/scrub.c       |  63 ++++++++++++-----
fs/xfs/scrub/scrub.h       |  12 +++-
fs/xfs/scrub/trace.h       |  69 +++++++++++++++++++
fs/xfs/xfs_bmap_item.c     |  12 +++-
fs/xfs/xfs_drain.c         | 166 +++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/xfs_drain.h         |  87 ++++++++++++++++++++++++
fs/xfs/xfs_extfree_item.c  |   4 +-
fs/xfs/xfs_linux.h         |   1 +
fs/xfs/xfs_refcount_item.c |   4 +-
fs/xfs/xfs_rmap_item.c     |   4 +-
fs/xfs/xfs_trace.h         |  71 +++++++++++++++++++
31 files changed, 680 insertions(+), 39 deletions(-)
create mode 100644 fs/xfs/xfs_drain.c
create mode 100644 fs/xfs/xfs_drain.h

