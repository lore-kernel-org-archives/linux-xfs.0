Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2C5E7F14D
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjI0AN6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjI0AL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:11:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8771A59F8
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:30:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA6AC433C8;
        Tue, 26 Sep 2023 23:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771005;
        bh=PqOGtODffdlZBhJ5LIZjZJjggyJkNOjenKkhF4y4sss=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CTZjd/nDc77g4BJ3yacWi5/dmmTIGEKpqXnYMrBFdG2h9KEW/yy9xp61C2tgZC8On
         Iv2eursEzTNnNasLcF+0PuVP5SfNphesw5A5t51mIkL1HaWzahRFE1EOFRwNRmeHRF
         D1UY4DZ8iOa4xGi9JoGNBx2tiQl/FdaH9vsKloRWpl1k657XYcSn3HrW2yfjK4D6NV
         RI2c3LCut862IP395PbNVtuw9WASHrBC+zHMjl5Y8Z/lwjVruYHSBkqRbsXLMN/JhI
         SAIZWVWSRzQF0bcmJzkZKIYVH63s5gpQ475Z2ZIB7RXBTiWBWwfhDWH0yawDDByj7v
         F4fu6JaiLStdw==
Date:   Tue, 26 Sep 2023 16:30:04 -0700
Subject: [PATCHSET v27.0 0/7] xfs: online repair of inodes and forks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577060353.3315095.13977747715399477216.stgit@frogsfrogsfrogs>
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

In this series, online repair gains the ability to repair inode records.
To do this, we must repair the ondisk inode and fork information enough
to pass the iget verifiers and hence make the inode igettable again.
Once that's done, we can perform higher level repairs on the incore
inode.  The fstests counterpart of this patchset implements stress
testing of repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inodes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-inodes
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_attr_leaf.c      |   32 -
 fs/xfs/libxfs/xfs_attr_leaf.h      |    2 
 fs/xfs/libxfs/xfs_bmap.c           |   22 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h      |    2 
 fs/xfs/libxfs/xfs_dir2_sf.c        |   29 -
 fs/xfs/libxfs/xfs_format.h         |    3 
 fs/xfs/libxfs/xfs_shared.h         |    1 
 fs/xfs/libxfs/xfs_symlink_remote.c |   21 
 fs/xfs/scrub/bmap.c                |   48 +
 fs/xfs/scrub/common.c              |   26 +
 fs/xfs/scrub/common.h              |    8 
 fs/xfs/scrub/dir.c                 |   21 
 fs/xfs/scrub/inode.c               |   14 
 fs/xfs/scrub/inode_repair.c        | 1650 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c              |   17 
 fs/xfs/scrub/repair.c              |   57 +
 fs/xfs/scrub/repair.h              |   29 +
 fs/xfs/scrub/rtbitmap.c            |    4 
 fs/xfs/scrub/rtsummary.c           |    4 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |  174 ++++
 23 files changed, 2119 insertions(+), 50 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c

