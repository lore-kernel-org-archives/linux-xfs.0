Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D85CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiL3WY6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3WY5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:24:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D8E1D0CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDFA6B81B91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD0BC433EF;
        Fri, 30 Dec 2022 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439093;
        bh=1FOFsmAl5aNn+uYljG2iARb0cu1qyruVzT8NFpgOXdc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mzRYWFY+nYkCvEjw6FJ3hQDg2mseYIh/yzL1z+j5UdJ9wWYhoHh9JwNefE+2ihQ/4
         VuAvVa32/Y9qHbyVKrBvqpf5JSY6Zf612wtAUXueCdJVoQDbw2Z2Djeu4cZ5b1YVGq
         ZYhjM7ZUx05zFGI3KOqDPL2YO5bNMGlYxVjVjU87YM/GS20Jrnp/fB/QVJtM8EuOTS
         VhM9iBV3UxMvLQZTXqMbzgQ71ovbQSQI6jK+f9eIC+vyHSnD6kDMxcDxHFms5vctM5
         QibbtezpwdEBp77dv+Iw4Lu1RRJ7qnvZv25gPBbwiD6Te6q9jnogJAEaPN9xfN8jdm
         1O5Hj6o7JqweQ==
Subject: [PATCHSET v24.0 0/5] xfs: drain deferred work items when scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:07 -0800
Message-ID: <167243826744.683691.2061427880010614570.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
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

v23.1: make intent items take an active ref to the perag structure and
       document why we bump and drop the intent counts when we do

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
 fs/xfs/Makefile            |    2 +
 fs/xfs/libxfs/xfs_ag.c     |    4 +
 fs/xfs/libxfs/xfs_ag.h     |    8 +++
 fs/xfs/libxfs/xfs_defer.c  |    6 +-
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
 fs/xfs/scrub/refcount.c    |    9 +++
 fs/xfs/scrub/repair.c      |    3 +
 fs/xfs/scrub/rmap.c        |    3 +
 fs/xfs/scrub/scrub.c       |   63 ++++++++++++++++-----
 fs/xfs/scrub/scrub.h       |    6 ++
 fs/xfs/scrub/trace.h       |   69 ++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.c     |   10 +++
 fs/xfs/xfs_drain.c         |  121 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_drain.h         |   80 +++++++++++++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |    2 +
 fs/xfs/xfs_linux.h         |    1 
 fs/xfs/xfs_refcount_item.c |    2 +
 fs/xfs/xfs_rmap_item.c     |    2 +
 fs/xfs/xfs_trace.h         |   71 ++++++++++++++++++++++++
 31 files changed, 614 insertions(+), 31 deletions(-)
 create mode 100644 fs/xfs/xfs_drain.c
 create mode 100644 fs/xfs/xfs_drain.h

