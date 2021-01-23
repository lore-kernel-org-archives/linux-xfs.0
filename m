Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E149C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF8022DBF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbhAWSyE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:54:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbhAWSyB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:54:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6809B23331;
        Sat, 23 Jan 2021 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611428000;
        bh=nEWnkS4lI84TuJVdyYBWnPgaifAbasNv1s9xWcD18XY=;
        h=Subject:From:To:Cc:Date:From;
        b=YQWgSxC4R6y5I/5Sqtdq28dQ+7Afz5ao98u67mddjdxYCWU4gF3vwSMTMafasCWsZ
         1pX6TGv2s4fNMwQWiud+C9GHM603lHzFiuBB3eqYVyeMBcmv8G5D9zKnu8qu8/7RO+
         aPLyXvTwXp01ae7HplxFvgjRKixek0C2z1ITg+cmKkTT53nHp5ZaKIWBSaynKLZBx0
         942nLB+VyLwO7Pe6bkMIwZsYIAqnCVybQcxxLJRvDaaECcbvYd2GDvBNVKjYZeNcv9
         fQyX07auucR9U9+GIu/w2uhhEufwjDRB9oHe0Jm95dXJHGoqL88o03cl68CcWiU8Do
         4KlbpjuXX40nQ==
Subject: [PATCHSET v4 0/9] xfs: consolidate posteof and cowblocks cleanup
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:22 -0800
Message-ID: <161142800187.2173480.17415824680111946713.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Currently, we treat the garbage collection of post-EOF preallocations
and copy-on-write preallocations as totally separate tasks -- different
incore inode tags, different workqueues, etc.  This is wasteful of radix
tree tags and workqueue resources since we effectively have parallel
code paths to do the same thing.

Therefore, consolidate both functions under one radix tree bit and one
workqueue function that scans an inode for both things at the same time.
At the end of the series we make the scanning per-AG instead of per-fs
so that the scanning can run in parallel.  This reduces locking
contention from background threads and will free up a radix tree bit for
the deferred inode inactivation series.

v2: clean up and rebase against 5.11.
v3: various streamlining as part of restructuring the space reclaim series
v4: move the workqueue parallelism bits to their own series

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=eofblocks-consolidation-5.12
---
 fs/xfs/scrub/common.c |    4 -
 fs/xfs/xfs_globals.c  |    7 +
 fs/xfs/xfs_icache.c   |  258 +++++++++++++++++++++----------------------------
 fs/xfs/xfs_icache.h   |   16 +--
 fs/xfs/xfs_ioctl.c    |    2 
 fs/xfs/xfs_linux.h    |    3 -
 fs/xfs/xfs_mount.c    |    5 +
 fs/xfs/xfs_mount.h    |    9 +-
 fs/xfs/xfs_super.c    |   25 ++---
 fs/xfs/xfs_sysctl.c   |   15 +--
 fs/xfs/xfs_sysctl.h   |    3 -
 fs/xfs/xfs_trace.h    |    6 -
 12 files changed, 150 insertions(+), 203 deletions(-)

