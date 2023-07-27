Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327AAEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjG0WV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjG0WV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:21:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E33B187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A707F61F6A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110AEC433C7;
        Thu, 27 Jul 2023 22:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496485;
        bh=N+cMAPOIY1ppLuMLKcei14xYTKg57AFgCA3fFhd3aow=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=N8aTg6iZpbwgCOFsNje3DVqHdIn1mFkw289RN1LeZsCu10MV9ZPCJFDfHsqcJa24J
         xGUr56U6dUSTcdspOYCMJ4I+FgsascwR83ZwXtqHt3S+el0Uv8UVNU1PTyu6dBgdFr
         wyOO4bKnIGBF86+JkbYZT6mM0jj5GDuBq0Hhm2UVOcohHMI74nhlPxOwS0f1HMQPv2
         FmIgc294+7bm9OM1fRrCxEMH4OY+lWVr49xz4MyeWO6ihShn+UJBzWMgrmkP/sEYFf
         broB3Gwpeu5GYXNnNY49c0CQILIyRZBcCS7h3yBvQ+zRsZZP5yt6+W7k4uCFgfHsS4
         /k/4HaY6+JBYw==
Date:   Thu, 27 Jul 2023 15:21:24 -0700
Subject: [PATCHSET v26.0 0/5] xfs: online repair of file fork mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626854.922742.12128926563525648849.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap_btree.c    |  112 ++++-
 fs/xfs/libxfs/xfs_bmap_btree.h    |    5 
 fs/xfs/libxfs/xfs_btree_staging.c |   11 
 fs/xfs/libxfs/xfs_btree_staging.h |    2 
 fs/xfs/libxfs/xfs_iext_tree.c     |   23 +
 fs/xfs/libxfs/xfs_inode_fork.c    |    1 
 fs/xfs/libxfs/xfs_inode_fork.h    |    3 
 fs/xfs/libxfs/xfs_refcount.c      |   41 ++
 fs/xfs/libxfs/xfs_refcount.h      |   10 
 fs/xfs/scrub/bitmap.h             |   28 +
 fs/xfs/scrub/bmap.c               |   18 +
 fs/xfs/scrub/bmap_repair.c        |  849 +++++++++++++++++++++++++++++++++++++
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
 23 files changed, 2126 insertions(+), 46 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c
 create mode 100644 fs/xfs/scrub/cow_repair.c

