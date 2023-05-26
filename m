Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90503C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjEZAcx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjEZAcw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7585194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CCE464B2A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EC4C433D2;
        Fri, 26 May 2023 00:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061170;
        bh=ne5ofs03hZGDNY+9EITPrPRHoHpUOlLWwhDVTztx4yc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BIKH+LV99vrmx6IM3zzh2354xo8oeR+bBNZv/FrpumcNGVW/YMPgSrfspT7hvkPNC
         PmstRkdyfYh8xYgcD4COjooy67FshQ0tDFYQ6n94bMQnDLkmj3q7Qt3DTbgVHYlDW5
         Ns9m7Ph/5HQ/eSVLN+c4ZalrIjedWpW615HNHCTqCrGGW65eC6RG/Gom5+N1+uxQVo
         ZEooeYISPg8Ixe54CvC/wi5BuI3/liHf9kAFVgwsphNjcdhDgqm89LNfY4C76ZbcS+
         L1EraqOX1aDDqK+ZnZYguJwDWkrmV4mxVNiDS6AUAo0LlxcexVl2xjxfeqOZ2Lmv7L
         69qaNo1CljY5w==
Date:   Thu, 25 May 2023 17:32:50 -0700
Subject: [PATCHSET v25.0 0/4] xfs: online repair of rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062293.3733354.11070133195917318351.stgit@frogsfrogsfrogs>
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

We have now constructed the four tools that we need to scan the
filesystem looking for reverse mappings: an inode scanner, hooks to
receive live updates from other writer threads, the ability to construct
btrees in memory, and a btree bulk loader.

This series glues those three together, enabling us to scan the
filesystem for mappings and keep it up to date while other writers run,
and then commit the new btree to disk atomically.

To reduce the size of each patch, the functionality is left disabled
until the end of the series and broken up into three patches: one to
create the mechanics of scanning the filesystem, a second to transition
to in-memory btrees, and a third to set up the live hooks.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rmap-btree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rmap-btree

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rmap-btree
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_ag.c         |    1 
 fs/xfs/libxfs/xfs_ag.h         |    3 
 fs/xfs/libxfs/xfs_bmap.c       |   49 +
 fs/xfs/libxfs/xfs_bmap.h       |    8 
 fs/xfs/libxfs/xfs_inode_fork.c |    9 
 fs/xfs/libxfs/xfs_inode_fork.h |    1 
 fs/xfs/libxfs/xfs_rmap.c       |  192 +++--
 fs/xfs/libxfs/xfs_rmap.h       |   30 +
 fs/xfs/libxfs/xfs_rmap_btree.c |  136 +++
 fs/xfs/libxfs/xfs_rmap_btree.h |    9 
 fs/xfs/scrub/bitmap.c          |   14 
 fs/xfs/scrub/bitmap.h          |    5 
 fs/xfs/scrub/bmap.c            |    2 
 fs/xfs/scrub/common.c          |    7 
 fs/xfs/scrub/common.h          |    1 
 fs/xfs/scrub/newbt.c           |   12 
 fs/xfs/scrub/newbt.h           |    7 
 fs/xfs/scrub/reap.c            |    6 
 fs/xfs/scrub/repair.c          |   59 +
 fs/xfs/scrub/repair.h          |   12 
 fs/xfs/scrub/rmap.c            |    9 
 fs/xfs/scrub/rmap_repair.c     | 1689 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c           |    6 
 fs/xfs/scrub/scrub.h           |    4 
 fs/xfs/scrub/trace.c           |    1 
 fs/xfs/scrub/trace.h           |   80 ++
 27 files changed, 2285 insertions(+), 68 deletions(-)
 create mode 100644 fs/xfs/scrub/rmap_repair.c

