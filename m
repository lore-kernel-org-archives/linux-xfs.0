Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2054AC4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6F0320707
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732974AbhARWOO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388009AbhARWNn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E8E22E02;
        Mon, 18 Jan 2021 22:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007981;
        bh=RxzAwvRKdPDlMKds7LXRjTfk5oiUebk0zYsZi5j4qXw=;
        h=Subject:From:To:Cc:Date:From;
        b=aBwy6/f5OpxyOklQUS8oFPB9syfJKbOO51+23z4y0P9I13XJprMZ6T/nTvZ2nfuI9
         oUAWIRwbxuMwSZB4Q0WACmYJpht2EoK/adtIeww6JBTqvz/YQvwQK+tEitisAZZXKh
         dUZUS9th6VxHv3TsStxEdpVVh7gUtcRCYvOlxeIOcQ4Bw6+NadxHVpP/z8jSDuZnQH
         y2//CUa4dLOTg2IQY5+ojye0po4O0fXgm4la1LMN6QVjZPH+Z8ITxrUYRst04uWP2X
         A7IHK1hElvBJfQlLi33jzen7sRePqqlbDtZYqOyr99ho1+AFUiFClZXFOJAdNDFTLv
         y5IHuj8vAEcLA==
Subject: [PATCHSET v3 00/10] xfs: consolidate posteof and cowblocks cleanup
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:13:01 -0800
Message-ID: <161100798100.90204.7839064495063223590.stgit@magnolia>
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
 fs/xfs/xfs_iwalk.c    |    2 
 fs/xfs/xfs_linux.h    |    3 -
 fs/xfs/xfs_mount.c    |    5 +
 fs/xfs/xfs_mount.h    |    9 +-
 fs/xfs/xfs_pwork.c    |   80 ++++++++++++++-
 fs/xfs/xfs_pwork.h    |    3 -
 fs/xfs/xfs_super.c    |   51 +++++++---
 fs/xfs/xfs_sysctl.c   |   15 +--
 fs/xfs/xfs_sysctl.h   |    3 -
 fs/xfs/xfs_trace.h    |    6 -
 15 files changed, 253 insertions(+), 211 deletions(-)

