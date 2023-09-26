Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6EAE7F14A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjI0ANH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjI0ALF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:11:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B5B1F35
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:29:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154AFC433C9;
        Tue, 26 Sep 2023 23:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695770958;
        bh=gKZ9iZ1aBcLYmjDBmQo6fA7yLFjTlaA2KzmiJphWmZg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lAMljTgcKHrJGixKXOvUf1hxVRH5+oF94RB5gb/azsEp/bKdr3lwmwC8eU4kNlDOG
         cdTV2Vsq5HGAYcrbgDK6tOP5TdJk5puVhvzAGIiUaBVuyV0v891gcsCMaN9vxyXcG7
         E1Co6g4WkWDm4jzAr7aYPP6psh+P1IVs+2lRD1pQthNWLU56WmgxNaeuoK+bkejYQS
         gr3qAN633kK+OhXnslMuFiE5ARIG4MvmhA0M0+YjBvywQhcuDZvqnp172Y+N1NIK6U
         s664SXcR7jql4PPDV1DGzQVpRtfjiNBcw30/nWSYMOySG/l3R9H3P7yDDUcSGcQgya
         JdVURlbrOzgWg==
Date:   Tue, 26 Sep 2023 16:29:17 -0700
Subject: [PATCHSET v27.0 0/7] xfs: reserve disk space for online repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
In-Reply-To: <20230926231410.GF11439@frogsfrogsfrogs>
References: <20230926231410.GF11439@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Online repair fixes metadata structures by writing a new copy out to
disk and atomically committing the new structure into the filesystem.
For this to work, we need to reserve all the space we're going to need
ahead of time so that the atomic commit transaction is as small as
possible.  We also require the reserved space to be freed if the system
goes down, or if we decide not to commit the repair, or if we reserve
too much space.

To keep the atomic commit transaction as small as possible, we would
like to allocate some space and simultaneously schedule automatic
reaping of the reserved space, even on log recovery.  EFIs are the
mechanism to get us there, but we need to use them in a novel manner.
Once we allocate the space, we want to hold on to the EFI (relogging as
necessary) until we can commit or cancel the repair.  EFIs for written
committed blocks need to go away, but unwritten or uncommitted blocks
can be freed like normal.

Earlier versions of this patchset directly manipulated the log items,
but Dave thought that to be a layering violation.  For v27, I've
modified the defer ops handling code to be capable of pausing a deferred
work item.  Log intent items are created as they always have been, but
paused items are pushed onto a side list when finishing deferred work
items, and pushed back onto the transaction after that.  Log intent done
item are not created for paused work.

The second part adds a "stale" flag to the EFI so that the repair
reservation code can dispose of an EFI the normal way, but without the
space actually being freed.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-auto-reap-space-reservations

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-auto-reap-space-reservations
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_ag.c             |    2 
 fs/xfs/libxfs/xfs_alloc.c          |  102 +++++++
 fs/xfs/libxfs/xfs_alloc.h          |   22 +-
 fs/xfs/libxfs/xfs_bmap.c           |    4 
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 
 fs/xfs/libxfs/xfs_btree_staging.h  |    7 
 fs/xfs/libxfs/xfs_defer.c          |  229 ++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h          |   20 +
 fs/xfs/libxfs/xfs_ialloc.c         |    5 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
 fs/xfs/libxfs/xfs_refcount.c       |    6 
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 
 fs/xfs/scrub/agheader_repair.c     |    1 
 fs/xfs/scrub/common.c              |    1 
 fs/xfs/scrub/newbt.c               |  510 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h               |   65 +++++
 fs/xfs/scrub/reap.c                |    7 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |   37 +++
 fs/xfs/xfs_extfree_item.c          |   13 +
 fs/xfs/xfs_reflink.c               |    2 
 fs/xfs/xfs_trace.h                 |   13 +
 23 files changed, 991 insertions(+), 64 deletions(-)
 create mode 100644 fs/xfs/scrub/newbt.c
 create mode 100644 fs/xfs/scrub/newbt.h

