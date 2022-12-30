Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F39C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiL3XEZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiL3XEY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:04:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C8215FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:04:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0841B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D84C433EF;
        Fri, 30 Dec 2022 23:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441461;
        bh=apLc8JEvdMFIKS6hEJLNqqZi8d+7SPev0dv5Oljmtgg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oeE5Ymvvm8OY/H3bLw/CUVu9c+A9pmHmhfRzf/Nmni9RksaM2puZ/Msi+wIdrQC8i
         +mB1A8SqP4OuagecfSPpEIhJLzviLZ9AaITFFviLf8Y/Pw/R6KnbB5w9Y3LljKtcCZ
         98gvI9vJYaCcjAvNQCRpXBqfpNQaFN0UIQdxnyuJH8SESdHQ7+DwAfxyREujfhKrC4
         vRe6f9t8kFv869xwMrY0YVQD3uDo6LdToJkeB9aRZHq2/a5B/dWfaPxrBezOlFe5Db
         5Xx7Br0PK7pQzUWrU0OAumo9bjmdS5m+pJrtbhAGFcOVbogqxwrHh9WP/Ieb3wUKQU
         T1u4yxNPunUlg==
Subject: [PATCHSET v24.0 0/4] xfs: online repair of rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:30 -0800
Message-ID: <167243840997.696748.11741067698987523110.stgit@magnolia>
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
 fs/xfs/scrub/bmap.c            |    4 
 fs/xfs/scrub/common.c          |    7 
 fs/xfs/scrub/common.h          |    1 
 fs/xfs/scrub/newbt.c           |    5 
 fs/xfs/scrub/newbt.h           |    6 
 fs/xfs/scrub/reap.c            |    6 
 fs/xfs/scrub/repair.c          |   64 +-
 fs/xfs/scrub/repair.h          |   12 
 fs/xfs/scrub/rmap.c            |    9 
 fs/xfs/scrub/rmap_repair.c     | 1651 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c           |    6 
 fs/xfs/scrub/scrub.h           |    4 
 fs/xfs/scrub/trace.c           |    1 
 fs/xfs/scrub/trace.h           |   80 ++
 27 files changed, 2246 insertions(+), 68 deletions(-)
 create mode 100644 fs/xfs/scrub/rmap_repair.c

