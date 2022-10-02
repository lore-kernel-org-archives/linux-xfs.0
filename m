Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF260C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiJBSXu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJBSXs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:23:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14002528C
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F8DB80D81
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C35C433C1;
        Sun,  2 Oct 2022 18:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735025;
        bh=bLuPAMJoqYxBy24oVV+mSScqjYnDbop6rUYw0qzNh6o=;
        h=Subject:From:To:Cc:Date:From;
        b=ABUy9gEfVtxz53CbRoymAubXx6Dj9JVvdfBn5hXh6+/4rfDy6/9Ah+Mh+L8zLw1rY
         +YYSFWTppEVa60Zkwcu78mElfnCClFtfxlPaycWkzKRITTS9pYNmLNhex5LcD93wK2
         3MUXOMU+IqcgNMS73q9MvE0TlKLZpNaMRS0Cin7HFEDQ0p6xX+7zTeIKJTOEPZtiG5
         nJXNEqBEoTxDMwIBVsU9aT1g8wWAIpVEPlP1oKuAr+4yae2gzdYx3XZpN2/d4NlMEH
         Mpx466IJtpdLp4zFG8jOOVixMK85m54yiLZfxqOjuiI/k25iopFgbYDQ6V4RrGJRLd
         buhI3g8t4WQxA==
Subject: [PATCHSET v23.1 0/5] xfs: drain deferred work items when scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:58 -0700
Message-ID: <166473479864.1083534.16821762305468128245.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-drain-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-drain-intents
---
 fs/xfs/Kconfig             |    5 ++
 fs/xfs/libxfs/xfs_ag.c     |    6 ++
 fs/xfs/libxfs/xfs_ag.h     |    8 +++
 fs/xfs/libxfs/xfs_defer.c  |   10 ++-
 fs/xfs/libxfs/xfs_defer.h  |    3 +
 fs/xfs/scrub/agheader.c    |    9 +++
 fs/xfs/scrub/alloc.c       |    3 +
 fs/xfs/scrub/bmap.c        |    3 +
 fs/xfs/scrub/btree.c       |    1 
 fs/xfs/scrub/common.c      |  129 ++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/common.h      |   15 +++++
 fs/xfs/scrub/dabtree.c     |    1 
 fs/xfs/scrub/fscounters.c  |    7 ++
 fs/xfs/scrub/health.c      |    2 +
 fs/xfs/scrub/ialloc.c      |    2 +
 fs/xfs/scrub/inode.c       |    3 +
 fs/xfs/scrub/quota.c       |    3 +
 fs/xfs/scrub/refcount.c    |    4 +
 fs/xfs/scrub/repair.c      |    3 +
 fs/xfs/scrub/rmap.c        |    3 +
 fs/xfs/scrub/scrub.c       |   63 ++++++++++++++++-----
 fs/xfs/scrub/scrub.h       |    6 ++
 fs/xfs/scrub/trace.h       |   34 ++++++++++++
 fs/xfs/xfs_attr_item.c     |    1 
 fs/xfs/xfs_bmap_item.c     |   48 ++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |   30 ++++++++++
 fs/xfs/xfs_mount.c         |  105 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h         |   64 ++++++++++++++++++++++
 fs/xfs/xfs_refcount_item.c |   25 +++++++++
 fs/xfs/xfs_rmap_item.c     |   18 ++++++
 fs/xfs/xfs_trace.h         |   71 ++++++++++++++++++++++++
 31 files changed, 652 insertions(+), 33 deletions(-)

