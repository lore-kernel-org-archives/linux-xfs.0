Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D56C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiL3XLP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:11:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E783DDE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:11:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A656EB81DA9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565CEC433D2;
        Fri, 30 Dec 2022 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441870;
        bh=g4hKdeQF9Q39Kdk8XLaBWTf4GcnEPtbXj8go44pV8kk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L+tM9IlTLXbmZm3BCI7a1IgL9Fr4uqUqI7k1BabfOK3WbO0lXVEYwGM4IeSYOwRj/
         YvrsCR9biKnviQ5lpA5Eh/nNoiCozBYsr3XeCG4MtpwzEAd7MyWtVv8OJLnsyoQWWo
         TS3yVCivT0YURlK2NoJ9QnuSqTwid5jtPeiMwG9lrTOm/tnDfOK8XxcLE1B1uLULmk
         YnzvmgYoL/LqXJDFxE/r1fBnSbx9EQ7SA4lgaWa4puQBOvUZi1Hjq6NH9cvh9OUbfI
         qxtYBw+7hE1XroSh1X3gmPrAwrgUeSsGUE5fPKxdq+5fcwNHrQAOsU696P8Bm4lfXM
         Zuf0QECTtpnMQ==
Subject: [PATCHSET v24.0 0/5] libxfs: online repair of rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:45 -0800
Message-ID: <167243866562.712315.18184440339100962213.stgit@magnolia>
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
 include/xfs_mount.h     |    6 +
 libxfs/xfs_ag.c         |    1 
 libxfs/xfs_ag.h         |    3 +
 libxfs/xfs_bmap.c       |   49 +++++++++++-
 libxfs/xfs_bmap.h       |    8 ++
 libxfs/xfs_inode_fork.c |    9 ++
 libxfs/xfs_inode_fork.h |    1 
 libxfs/xfs_rmap.c       |  192 +++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_rmap.h       |   30 +++++++
 libxfs/xfs_rmap_btree.c |  136 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |    9 ++
 man/man8/mkfs.xfs.8.in  |    4 -
 mkfs/xfs_mkfs.c         |    2 
 13 files changed, 392 insertions(+), 58 deletions(-)

