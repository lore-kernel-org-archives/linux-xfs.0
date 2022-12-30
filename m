Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FD7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbiLaBBg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:01:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813801DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:01:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F3DCB81E34
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35CBC433EF;
        Sat, 31 Dec 2022 01:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448490;
        bh=JMhjaRlbOrtHM8UWjzf2/qE3uTX0oQH2U5O6CyLlwMw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EewXNjKo0DIjMp86P7Z9XXeHH5N1eLoUQeI5DLNzHzc10ZoWEwdIxI3GdLKP5/wCN
         d1s/Ck17tUqFkCBPiu+JBiG64el3sQdwJ0iWtRbLll1wFCABTtBptdssiukCUazewI
         Lp90Au8XyxSWQsvA7pAujQVUqGDw2XtS7hYFAlXNiZZKDpmbAfo+iqlNI2N64zR7RK
         92OM/mipo0Megg+CdJOVjWa0GpyeaKkFrtiedjDg3ewtdHeSV8orKEK0vHJUwkMrKp
         IsEus7CsayfxFpzmnqxU1l3deLp+qx13yDB+1LQrYTPXK4QVVRx81t0rt4xkMQMAFj
         HqcRSwP5SFB2w==
Subject: [PATCHSET v1.0 00/45] libxfs: shard the realtime section
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:43 -0800
Message-ID: <167243878346.731133.14642166452774753637.stgit@magnolia>
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
 db/Makefile               |    2 
 db/bit.c                  |   24 ++
 db/bit.h                  |    1 
 db/check.c                |   58 ++++-
 db/command.c              |    2 
 db/convert.c              |   46 +++-
 db/field.c                |   18 +
 db/field.h                |   11 +
 db/fprint.c               |   11 +
 db/inode.c                |    9 +
 db/metadump.c             |   51 ++++
 db/rtgroup.c              |  169 ++++++++++++++
 db/rtgroup.h              |   21 ++
 db/sb.c                   |  136 ++++++++++-
 db/type.c                 |   16 +
 db/type.h                 |   32 ++-
 db/xfs_metadump.sh        |    5 
 include/libxfs.h          |    1 
 include/xfs_arch.h        |    6 
 include/xfs_mount.h       |   12 +
 include/xfs_trace.h       |    5 
 include/xfs_trans.h       |    1 
 io/Makefile               |    2 
 io/aginfo.c               |  215 ++++++++++++++++++
 io/bmap.c                 |   30 ++
 io/fsmap.c                |   23 ++
 io/init.c                 |    1 
 io/io.h                   |    1 
 io/scrub.c                |   15 +
 libfrog/div64.h           |    6 
 libfrog/fsgeom.c          |   24 ++
 libfrog/fsgeom.h          |   23 ++
 libfrog/scrub.c           |   10 +
 libfrog/scrub.h           |    1 
 libfrog/util.c            |   26 ++
 libfrog/util.h            |    3 
 libxfs/Makefile           |    2 
 libxfs/defer_item.c       |   17 +
 libxfs/init.c             |   21 ++
 libxfs/libxfs_api_defs.h  |    6 
 libxfs/libxfs_io.h        |    1 
 libxfs/libxfs_priv.h      |   25 ++
 libxfs/rdwr.c             |   17 +
 libxfs/topology.c         |   42 +++
 libxfs/topology.h         |    3 
 libxfs/trans.c            |   29 ++
 libxfs/util.c             |    7 +
 libxfs/xfs_bmap.h         |    5 
 libxfs/xfs_format.h       |   94 ++++++++
 libxfs/xfs_fs.h           |   24 ++
 libxfs/xfs_health.h       |   30 ++
 libxfs/xfs_rtbitmap.c     |  126 +++++++++-
 libxfs/xfs_rtbitmap.h     |   46 ++++
 libxfs/xfs_rtgroup.c      |  545 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h      |  241 ++++++++++++++++++++
 libxfs/xfs_sb.c           |  124 ++++++++++
 libxfs/xfs_shared.h       |    4 
 libxfs/xfs_types.c        |   46 ++++
 libxfs/xfs_types.h        |    4 
 man/man8/mkfs.xfs.8.in    |   44 ++++
 man/man8/xfs_db.8         |   17 +
 man/man8/xfs_io.8         |   23 ++
 man/man8/xfs_mdrestore.8  |    7 +
 man/man8/xfs_metadump.8   |   12 +
 man/man8/xfs_spaceman.8   |    5 
 mdrestore/xfs_mdrestore.c |   30 ++
 mkfs/proto.c              |  104 +++++++++
 mkfs/xfs_mkfs.c           |  279 +++++++++++++++++++++++
 repair/agheader.c         |    2 
 repair/incore.c           |   22 ++
 repair/phase3.c           |    3 
 repair/phase6.c           |   39 +++
 repair/rt.c               |  153 ++++++++++++-
 repair/rt.h               |    3 
 repair/sb.c               |   46 ++++
 repair/xfs_repair.c       |   11 +
 scrub/phase2.c            |   97 ++++++++
 scrub/phase8.c            |   46 ++++
 scrub/repair.c            |    2 
 scrub/scrub.c             |    4 
 scrub/scrub.h             |    9 +
 spaceman/health.c         |   59 +++++
 82 files changed, 3361 insertions(+), 132 deletions(-)
 create mode 100644 db/rtgroup.c
 create mode 100644 db/rtgroup.h
 create mode 100644 io/aginfo.c
 create mode 100644 libxfs/xfs_rtgroup.c
 create mode 100644 libxfs/xfs_rtgroup.h

