Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB47CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiL3XCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiL3XCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:02:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F410815FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1FABB81D95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B584C433D2;
        Fri, 30 Dec 2022 23:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441320;
        bh=iwjUy+ojJJaEtH6qhoYb25bKG8TUIvU1dskAGZoInpI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J/HNO0S8AzY09qKxudUbWH8XLFhGMpOsMgQ17dKu+JKQGW+yj7SzIJoS8q7YSjAel
         M7LovhfYAF5uiRi7jxD++AztQUiXojYtzG7PW5j+6Q/U5aVV0uH7pr0ok4gk/Z9/3H
         72gGmBQRwMacQXd1A0mkt1ax1b2Nn16IWTBY97QT3nlgb+BOu49rI0MUQdTOd40mTN
         IOBpBBVuLgBhzti7lpBsQcnyRKxIQXlHJInEe2eglBxsEZ1Zc03yWuuq551OO0g4d2
         qLw5sXbTm4NjOhk3bv7mz10pbRK9KrHRbu6S0dn7uvbqmRRKHxZAeiENGsL7kGlkg2
         WX+ewp4NPAr0w==
Subject: [PATCHSET v24.0 0/5] xfs: online repair of file fork mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:56 -0800
Message-ID: <167243837619.694993.4421999845289107494.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
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
 fs/xfs/libxfs/xfs_bmap_btree.c    |  112 +++++
 fs/xfs/libxfs/xfs_bmap_btree.h    |    5 
 fs/xfs/libxfs/xfs_btree_staging.c |   11 -
 fs/xfs/libxfs/xfs_btree_staging.h |    2 
 fs/xfs/libxfs/xfs_iext_tree.c     |   23 +
 fs/xfs/libxfs/xfs_inode_fork.c    |    1 
 fs/xfs/libxfs/xfs_inode_fork.h    |    3 
 fs/xfs/libxfs/xfs_refcount.c      |   41 ++
 fs/xfs/libxfs/xfs_refcount.h      |   10 
 fs/xfs/scrub/bitmap.h             |   28 +
 fs/xfs/scrub/bmap.c               |   18 +
 fs/xfs/scrub/bmap_repair.c        |  776 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/cow_repair.c         |  661 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.c               |  145 +++++++
 fs/xfs/scrub/reap.h               |    2 
 fs/xfs/scrub/repair.c             |   47 ++
 fs/xfs/scrub/repair.h             |   11 +
 fs/xfs/scrub/scrub.c              |   20 -
 fs/xfs/scrub/trace.h              |  115 +++++
 fs/xfs/xfs_trans.c                |   95 +++++
 fs/xfs/xfs_trans.h                |    4 
 22 files changed, 2087 insertions(+), 45 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c
 create mode 100644 fs/xfs/scrub/cow_repair.c

