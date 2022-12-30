Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC770C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbiLaA61 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLaA60 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:58:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CDCF03A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9D1F61D68
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D34FC433D2;
        Sat, 31 Dec 2022 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448304;
        bh=31EXNJzN9fa9yL4SmgzUxmaX6PzymPQzZdKLRs9/RaI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OrHyQ/iEhru1C6VuE8sbJMupZt2GFXZLIwAQqxtTisxidKKveLuoRwdvDzzwrq8wy
         MO5IZAq/fek0F0perCQnO+wAFiGIEKToke9bar1tTAzafkzUjDx5lgFtIm4fXhaVeX
         8PQq9SIgdw2AkHtSoYZ/s0rgD6AGKZ9zTyzSAePRWaBYTKW2JZ5ZXOVVOpA7d3Dcjy
         gIIL0TMJ4EJk3r3cwzuSokmBR58FJWQ3P1cWDuXf2fxA6VI1umdsc+FENbHv0ggPF4
         DHuK95Tr+iKGNzY1Oz8O6uxg0ZwstMWTtzBsu/p1pgrnAFzvJ3p7eLosJro5CemMkF
         Wr3KjKtgY/nTQ==
Subject: [PATCHSET v1.0 00/38] xfs: realtime reverse-mapping support
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:16 -0800
Message-ID: <167243869558.715303.13347105677486333748.stgit@magnolia>
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

This is the latest revision of a patchset that adds to XFS kernel
support for reverse mapping for the realtime device.  This time around
I've fixed some of the bitrot that I've noticed over the past few
months, and most notably have converted rtrmapbt to use the metadata
inode directory feature instead of burning more space in the superblock.

At the beginning of the set are patches to implement storing B+tree
leaves in an inode root, since the realtime rmapbt is rooted in an
inode, unlike the regular rmapbt which is rooted in an AG block.
Prior to this, the only btree that could be rooted in the inode fork
was the block mapping btree; if all the extent records fit in the
inode, format would be switched from 'btree' to 'extents'.

The next few patches widen the reverse mapping routines to fit the
64-bit numbers required to store information about the realtime
device and establish a new b+tree type (rtrmapbt) for the realtime
variant of the rmapbt.  After that are a few patches to handle rooting
the rtrmapbt in a specific inode that's referenced by the superblock.

Finally, there are patches to implement GETFSMAP with the rtrmapbt and
scrub functionality for the rtrmapbt and rtbitmap; and then wire up the
online scrub functionality.  We also enhance EFIs to support tracking
freeing of realtime extents so that when rmap is turned on we can
maintain the same order of operations as the regular rmap code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
 fs/xfs/Makefile                  |    3 
 fs/xfs/libxfs/xfs_bmap.c         |   22 +
 fs/xfs/libxfs/xfs_btree.c        |  121 ++++
 fs/xfs/libxfs/xfs_btree.h        |    7 
 fs/xfs/libxfs/xfs_defer.c        |    1 
 fs/xfs/libxfs/xfs_defer.h        |    1 
 fs/xfs/libxfs/xfs_format.h       |   24 +
 fs/xfs/libxfs/xfs_fs.h           |    4 
 fs/xfs/libxfs/xfs_health.h       |    4 
 fs/xfs/libxfs/xfs_imeta.c        |    6 
 fs/xfs/libxfs/xfs_inode_buf.c    |    6 
 fs/xfs/libxfs/xfs_inode_fork.c   |   13 
 fs/xfs/libxfs/xfs_log_format.h   |    4 
 fs/xfs/libxfs/xfs_refcount.c     |    6 
 fs/xfs/libxfs/xfs_rmap.c         |  227 +++++++-
 fs/xfs/libxfs/xfs_rmap.h         |   22 +
 fs/xfs/libxfs/xfs_rtgroup.c      |   12 
 fs/xfs/libxfs/xfs_rtgroup.h      |   20 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 1036 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |  218 ++++++++
 fs/xfs/libxfs/xfs_sb.c           |    6 
 fs/xfs/libxfs/xfs_shared.h       |    2 
 fs/xfs/libxfs/xfs_swapext.c      |    4 
 fs/xfs/libxfs/xfs_trans_resv.c   |   12 
 fs/xfs/libxfs/xfs_trans_space.h  |   13 
 fs/xfs/libxfs/xfs_types.h        |    5 
 fs/xfs/scrub/alloc_repair.c      |   10 
 fs/xfs/scrub/bmap.c              |  128 ++++-
 fs/xfs/scrub/bmap_repair.c       |  131 +++++
 fs/xfs/scrub/common.c            |  153 +++++-
 fs/xfs/scrub/common.h            |   14 -
 fs/xfs/scrub/cow_repair.c        |    2 
 fs/xfs/scrub/health.c            |    1 
 fs/xfs/scrub/inode.c             |   10 
 fs/xfs/scrub/inode_repair.c      |   75 +++
 fs/xfs/scrub/reap.c              |    5 
 fs/xfs/scrub/reap.h              |    2 
 fs/xfs/scrub/repair.c            |  229 ++++++++
 fs/xfs/scrub/repair.h            |   34 +
 fs/xfs/scrub/rmap_repair.c       |   36 +
 fs/xfs/scrub/rtbitmap.c          |  104 ++++
 fs/xfs/scrub/rtbitmap_repair.c   |  692 +++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c            |  282 ++++++++++
 fs/xfs/scrub/rtrmap_repair.c     |  908 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtsummary_repair.c  |    3 
 fs/xfs/scrub/scrub.c             |   11 
 fs/xfs/scrub/scrub.h             |   14 +
 fs/xfs/scrub/tempfile.c          |   15 -
 fs/xfs/scrub/tempswap.h          |    2 
 fs/xfs/scrub/trace.c             |    1 
 fs/xfs/scrub/trace.h             |  249 +++++++++
 fs/xfs/scrub/xfbtree.c           |    3 
 fs/xfs/xfs_bmap_item.c           |    5 
 fs/xfs/xfs_buf_item_recover.c    |    4 
 fs/xfs/xfs_drain.c               |   41 ++
 fs/xfs/xfs_drain.h               |   19 +
 fs/xfs/xfs_extfree_item.c        |    2 
 fs/xfs/xfs_fsmap.c               |  579 ++++++++++++++-------
 fs/xfs/xfs_fsops.c               |   12 
 fs/xfs/xfs_health.c              |    4 
 fs/xfs/xfs_inode.c               |   19 +
 fs/xfs/xfs_inode_item.c          |    2 
 fs/xfs/xfs_inode_item_recover.c  |   33 +
 fs/xfs/xfs_mount.c               |    9 
 fs/xfs/xfs_mount.h               |   10 
 fs/xfs/xfs_ondisk.h              |    2 
 fs/xfs/xfs_qm.c                  |   20 +
 fs/xfs/xfs_qm_bhv.c              |    2 
 fs/xfs/xfs_quota.h               |    4 
 fs/xfs/xfs_rmap_item.c           |   27 +
 fs/xfs/xfs_rtalloc.c             |  283 ++++++++++
 fs/xfs/xfs_rtalloc.h             |    9 
 fs/xfs/xfs_super.c               |    6 
 fs/xfs/xfs_trace.c               |   18 +
 fs/xfs/xfs_trace.h               |  136 ++++-
 75 files changed, 5771 insertions(+), 388 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h
 create mode 100644 fs/xfs/scrub/rtrmap.c
 create mode 100644 fs/xfs/scrub/rtrmap_repair.c

