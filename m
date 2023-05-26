Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F181C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbjEZAaQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbjEZAaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5041AC
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F5364C02
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10FFC433D2;
        Fri, 26 May 2023 00:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685060998;
        bh=jKNWk1hzfERO0Tz9tTaguOyZBu+02yRMtwStpWZ4OtE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dGDwu4z6aKbAtot2hN2dMKGPXDyScKnlJpZEUI9HW53VOvHsDBO8NU5/Jw8dQ0ONz
         UgeK1JYavPevGX+TkPstGsayA8ulQUOsHl5E0hTvRMTAhVycHYQK/1cevBpiNxLB+r
         AfzNKUgMCfa4wEKNl92EZrmmX00TqVCGkjmTgVy8/ujajU2EAc7x0moiUmZH0ZT5I7
         pB/LX2MzJY8T7g3Hu0pKKn/3YNxgzTxL2aNkS20CFdC/vQLa4ti2b/PDQzjf2+IrmR
         dBRoGI+KBdlAD0x/cxmNXtv2YYcVjQ4PyK92iZ5hBL9U4d5asO4Kld79MPeR4/qeuK
         2xVJIWUp2R03g==
Date:   Thu, 25 May 2023 17:29:58 -0700
Subject: [PATCHSET v25.0 0/5] xfs: online repair of AG btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've spent a lot of time reworking common code in online fsck,
we're ready to start rebuilding the AG space btrees.  This series
implements repair functions for the free space, inode, and refcount
btrees.  Rebuilding the reverse mapping btree is much more intense and
is left for a subsequent patchset.  The fstests counterpart of this
patchset implements stress testing of repair.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-ag-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-ag-btrees

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-ag-btrees
---
 fs/xfs/Makefile                    |    3 
 fs/xfs/libxfs/xfs_ag.h             |   10 
 fs/xfs/libxfs/xfs_ag_resv.c        |    2 
 fs/xfs/libxfs/xfs_alloc.c          |   18 -
 fs/xfs/libxfs/xfs_alloc.h          |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |   13 -
 fs/xfs/libxfs/xfs_btree.c          |   26 +
 fs/xfs/libxfs/xfs_btree.h          |    2 
 fs/xfs/libxfs/xfs_ialloc.c         |   41 +-
 fs/xfs/libxfs/xfs_ialloc.h         |    3 
 fs/xfs/libxfs/xfs_refcount.c       |   18 -
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 -
 fs/xfs/libxfs/xfs_types.h          |    7 
 fs/xfs/scrub/agheader_repair.c     |    5 
 fs/xfs/scrub/alloc.c               |   14 -
 fs/xfs/scrub/alloc_repair.c        |  910 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c              |    1 
 fs/xfs/scrub/common.h              |   13 +
 fs/xfs/scrub/ialloc_repair.c       |  872 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c               |   44 ++
 fs/xfs/scrub/newbt.h               |    6 
 fs/xfs/scrub/reap.c                |   17 +
 fs/xfs/scrub/refcount_repair.c     |  791 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c              |  128 +++++
 fs/xfs/scrub/repair.h              |   43 ++
 fs/xfs/scrub/scrub.c               |   22 +
 fs/xfs/scrub/scrub.h               |    9 
 fs/xfs/scrub/trace.h               |  112 +++-
 fs/xfs/scrub/xfarray.h             |   22 +
 fs/xfs/xfs_extent_busy.c           |   13 +
 fs/xfs/xfs_extent_busy.h           |    2 
 fs/xfs/xfs_icache.c                |  127 ++++-
 fs/xfs/xfs_trace.h                 |   22 +
 34 files changed, 3223 insertions(+), 110 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c
 create mode 100644 fs/xfs/scrub/ialloc_repair.c
 create mode 100644 fs/xfs/scrub/refcount_repair.c

