Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1DCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiLaA5A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236010AbiLaA4w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:56:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C6DF03A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:56:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BAE861BCD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9247C433D2;
        Sat, 31 Dec 2022 00:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448210;
        bh=RUKNXalHoi2XXWev9DwFCHky+m3391ew7x3dPgFshws=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rx7hmvLcboRnymp2SZFWMYI+FkPOZOOmysU6zlHOJeNaFa9mTQWFiGD7yX/Xin5JW
         6rEMERVc0dx1xwPOKCznkQx2H3Rs3tEsuc6wuHdXbBl4HleBtYVnKB5bHf16YZkYMv
         3U0qZ0RwQ3VhLZ5chx1x+ITv8RfbkHwwHT/B4kduHiesnZQBBNNc4epdmFcZkmPw+j
         Q89dOW86zvQGIU8fBxPIxk3mlnu5NBgrAFMS3PEXtlxQV0LMjHdpnf1dskq6ODpED0
         CDB69zCTbxxJ2ZsNUP27WxmNpVCAyMzsmEC+vZKpi8dRLQ42GowE3c8JXeNaZinvH1
         5b5rNCG2QkO/g==
Subject: [PATCHSET v1.0 00/22] xfsprogs: shard the realtime section
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:52 -0800
Message-ID: <167243867242.712847.10106105868862621775.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Right now, the realtime section uses a single pair of metadata inodes to
store the free space information.  This presents a scalability problem
since every thread trying to allocate or free rt extents have to lock
these files.  It would be very useful if we could begin to tackle these
problems by sharding the realtime section, so create the notion of
realtime groups, which are similar to allocation groups on the data
section.

While we're at it, define a superblock to be stamped into the start of
each rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and helpfully avoids the situation
where a file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-groups

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-groups
---
 fs/xfs/Makefile                 |    3 
 fs/xfs/libxfs/xfs_bmap.h        |    5 
 fs/xfs/libxfs/xfs_format.h      |   94 ++++++-
 fs/xfs/libxfs/xfs_fs.h          |   24 ++
 fs/xfs/libxfs/xfs_health.h      |   30 ++
 fs/xfs/libxfs/xfs_rtbitmap.c    |  128 ++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.h    |   46 +++
 fs/xfs/libxfs/xfs_rtgroup.c     |  548 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h     |  241 +++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |  124 +++++++++
 fs/xfs/libxfs/xfs_shared.h      |    4 
 fs/xfs/libxfs/xfs_types.c       |   46 +++
 fs/xfs/libxfs/xfs_types.h       |    4 
 fs/xfs/scrub/common.c           |   88 ++++++
 fs/xfs/scrub/common.h           |   52 ++--
 fs/xfs/scrub/health.c           |   25 ++
 fs/xfs/scrub/repair.h           |    3 
 fs/xfs/scrub/rgsuper.c          |   77 +++++
 fs/xfs/scrub/rgsuper_repair.c   |   48 +++
 fs/xfs/scrub/rtbitmap.c         |   73 +++++
 fs/xfs/scrub/rtsummary_repair.c |   15 +
 fs/xfs/scrub/scrub.c            |   27 ++
 fs/xfs/scrub/scrub.h            |   42 +--
 fs/xfs/scrub/trace.h            |    6 
 fs/xfs/xfs_bmap_item.c          |   18 +
 fs/xfs/xfs_buf_item_recover.c   |   43 +++
 fs/xfs/xfs_fsops.c              |    4 
 fs/xfs/xfs_health.c             |  114 ++++++++
 fs/xfs/xfs_ioctl.c              |   35 ++
 fs/xfs/xfs_log_recover.c        |    6 
 fs/xfs/xfs_mount.c              |   12 +
 fs/xfs/xfs_mount.h              |   10 +
 fs/xfs/xfs_ondisk.h             |    2 
 fs/xfs/xfs_rtalloc.c            |  266 +++++++++++++++++--
 fs/xfs/xfs_rtalloc.h            |    5 
 fs/xfs/xfs_super.c              |   18 +
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   60 ++++
 fs/xfs/xfs_trans.c              |   38 ++-
 fs/xfs/xfs_trans.h              |    2 
 fs/xfs/xfs_trans_buf.c          |   25 +-
 41 files changed, 2295 insertions(+), 117 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h
 create mode 100644 fs/xfs/scrub/rgsuper.c
 create mode 100644 fs/xfs/scrub/rgsuper_repair.c

