Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83153E7F148
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjI0AOD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjI0AMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:12:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45250A273
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:30:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CA4C433C7;
        Tue, 26 Sep 2023 23:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771020;
        bh=MW2YBeEuzu3FecG/42WtFpOJCOQgi89ngarfNpyzlSw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=e3pb2vrVsujEez9K8llPCQKq7fO2kdINpRkigps6064suu2O5Qux1lVhtWxPAb0Uf
         Kpzd/WU1B/bqRynarFx2TocpqbyD4tSFDrzfvqFMi+Cf8IviWLwL3kRVMxTt1Ym2K/
         OQFGacwTcZLZpMwU+5fqrk4MeA7t6V9YI7VklpPelL5cs8ndML/lMMqcRA+Sz/uCN6
         0TzMFsD4vK5B0Jemhqa3ff29KFbekIgQjENXhetxZXCxyglwSpdTWtRVqtldIgHAaZ
         hHmCUr9atxo0o/V8m9pVZcCEjCHeWOoPwirlaxr/bl2CUxJ7ubRrQblVLS3uO9leFU
         9XwT8uAX3iYYA==
Date:   Tue, 26 Sep 2023 16:30:20 -0700
Subject: [PATCHSET v27.0 0/5] xfs: online repair of file fork mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577060786.3315318.10585901732742544483.stgit@frogsfrogsfrogs>
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

In this series, online repair gains the ability to rebuild data and attr
fork mappings from the reverse mapping information.  It is at this point
where we reintroduce the ability to reap file extents.

Repair of CoW forks is a little different -- on disk, CoW staging
extents are owned by the refcount btree and cannot be mapped back to
individual files.  Hence we can only detect staging extents that don't
quite look right (missing reverse mappings, shared staging extents) and
replace them with fresh allocations.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-file-mappings

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-file-mappings

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-file-mappings
---
 fs/xfs/Makefile                   |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c    |  112 ++++-
 fs/xfs/libxfs/xfs_bmap_btree.h    |    5 
 fs/xfs/libxfs/xfs_btree_staging.c |   11 
 fs/xfs/libxfs/xfs_btree_staging.h |    2 
 fs/xfs/libxfs/xfs_iext_tree.c     |   23 +
 fs/xfs/libxfs/xfs_inode_fork.c    |    1 
 fs/xfs/libxfs/xfs_inode_fork.h    |    3 
 fs/xfs/libxfs/xfs_refcount.c      |   41 ++
 fs/xfs/libxfs/xfs_refcount.h      |   10 
 fs/xfs/scrub/bitmap.h             |   56 ++
 fs/xfs/scrub/bmap.c               |   18 +
 fs/xfs/scrub/bmap_repair.c        |  846 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h             |    6 
 fs/xfs/scrub/cow_repair.c         |  609 +++++++++++++++++++++++++++
 fs/xfs/scrub/reap.c               |  152 ++++++-
 fs/xfs/scrub/reap.h               |    2 
 fs/xfs/scrub/repair.c             |   50 ++
 fs/xfs/scrub/repair.h             |   11 
 fs/xfs/scrub/scrub.c              |   20 -
 fs/xfs/scrub/trace.h              |  118 +++++
 fs/xfs/xfs_trans.c                |   95 ++++
 fs/xfs/xfs_trans.h                |    4 
 23 files changed, 2151 insertions(+), 46 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c
 create mode 100644 fs/xfs/scrub/cow_repair.c

