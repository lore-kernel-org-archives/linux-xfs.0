Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219A3C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E988E22D73
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391783AbhALAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404075AbhAKXYE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA88B22D05;
        Mon, 11 Jan 2021 23:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407395;
        bh=tYx9pdxWXZtJ/DgF68i3k/LzEluiPIxlVBWXC5EsO/Q=;
        h=Subject:From:To:Cc:Date:From;
        b=SMgJ8/4Kma69s0IIBhy+HBGm6g01Rkd6+eCh5d4fDkYcqiJ5RcaDEc00bHcup+GB4
         YRkQgnes1pzVkIHsq4eAaJPXbDyca9i5OBAGeBDiCMMW+JV2mxBq3C0DgwqySit0S7
         8JkmHfNflEC1t+ZAKixBFC7PStU/5LtUea3OoowT0fQyL2YdFjCXpiaPlpNDvPQXsG
         1r8Tv4VP4fiUOc+CcyZvbnhow04SvjHFu8LEAa7dNmLh4iGF6XGiDpVDbIKVz4g7kP
         uYkpyeHr24RdEmRQVWk/va1acCF2/4zXLMJyhyUtveW4v5VogGeQrK9aEDdcz+CclR
         COV/dPAh2kwkw==
Subject: [PATCHSET v2 0/7] xfs: consolidate posteof and cowblocks cleanup
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:15 -0800
Message-ID: <161040739544.1582286.11068012972712089066.stgit@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=eofblocks-consolidation-5.12
---
 fs/xfs/scrub/common.c  |    4 -
 fs/xfs/xfs_bmap_util.c |  109 +++++++++-------------
 fs/xfs/xfs_buf.c       |   34 +++++++
 fs/xfs/xfs_buf.h       |    1 
 fs/xfs/xfs_globals.c   |    7 +
 fs/xfs/xfs_icache.c    |  240 +++++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h    |   13 +--
 fs/xfs/xfs_inode.c     |   36 +++++++
 fs/xfs/xfs_inode.h     |    2 
 fs/xfs/xfs_iwalk.c     |    2 
 fs/xfs/xfs_linux.h     |    3 -
 fs/xfs/xfs_mount.c     |   44 +++++++++
 fs/xfs/xfs_mount.h     |   10 +-
 fs/xfs/xfs_pwork.c     |   17 +--
 fs/xfs/xfs_pwork.h     |    2 
 fs/xfs/xfs_super.c     |   43 ++++++---
 fs/xfs/xfs_sysctl.c    |   15 +--
 fs/xfs/xfs_sysctl.h    |    3 -
 fs/xfs/xfs_trace.h     |    6 -
 19 files changed, 341 insertions(+), 250 deletions(-)

