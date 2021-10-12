Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81376C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6907460E53
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbhJLXeg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235541AbhJLXeg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1603160EBB;
        Tue, 12 Oct 2021 23:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081554;
        bh=FSlTtdgOJH664EgEf4aLJtetr6P2fOJIEdqzi0mkG/Q=;
        h=Subject:From:To:Cc:Date:From;
        b=LgqnwqP/X90UCsDZ27HM37mNuuplLGIc0WcwZMId36HSNzB//T7LFOtd5ga/JWr/L
         BcHv/IGGrHkbGf5gWg1xpj+896zl9sb4Nk25kJxNheoKH1Us4QMwhhbQkzWxL/i6Fa
         2D/Gqzcw+FSmni2QFZpgQKhdNMzgPgYS58tHzhGRQJMwyWWsg7g2k6zjPcPnCJf29E
         U/TXHkJi3yyRg35k3Qa+5mo4t3c/MuOqSnIb6/i2MNX4fM+CwNGzCSVSroE8eTOGDC
         VNWAKcVom1gV8wEuybtPw5UyqU7fpk1FboOL63ZF+hRBSZf3MmcISmlieZc4TP0LXA
         CGrQf5RgU2M+w==
Subject: [PATCHSET v3 00/15] xfs: support dynamic btree cursor height
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:32:33 -0700
Message-ID: <163408155346.4151249.8364703447365270670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In what's left of this series, we rearrange the incore btree cursor so
that we can support btrees of any height.  This will become necessary
for realtime rmap and reflink since we'd like to handle tall trees
without bloating the AG btree cursors.

Chandan Babu pointed out that his large extent counters series depends
on the ability to have btree cursors of arbitrary heights, so I've
ported this to 5.15-rc4 so his patchsets won't have to depend on
djwong-dev for submission.

Following the review discussions about the dynamic btree cursor height
patches, I've throw together another series to reduce the size of the
btree cursor, compute the absolute maximum possible btree heights for
each btree type, and now each btree cursor has its own slab cache:

$ grep xfs.*cur /proc/slabinfo
xfs_refcbt_cur 0 0 200 20 1 : tunables 0 0 0 : slabdata 4 4 0
xfs_rmapbt_cur 0 0 248 16 1 : tunables 0 0 0 : slabdata 4 4 0
xfs_bmbt_cur   0 0 248 16 1 : tunables 0 0 0 : slabdata 4 4 0
xfs_inobt_cur  0 0 216 18 1 : tunables 0 0 0 : slabdata 4 4 0
xfs_bnobt_cur  0 0 216 18 1 : tunables 0 0 0 : slabdata 4 4 0

I've also rigged up the debugger to make it easier to extract the actual
height information:

$ xfs_db /dev/sda -c 'btheight -w absmax all'
bnobt: 7
cntbt: 7
inobt: 7
finobt: 7
bmapbt: 9
refcountbt: 6
rmapbt: 9

As you can see from the slabinfo output, this no longer means that we're
allocating 224-byte cursors for all five btree types.  Even with the
extra overhead of supporting dynamic cursor sizes and per-btree caches,
we still come out ahead in terms of cursor size for three of the five
btree types.

This series now also includes a couple of patches to reduce holes and
unnecessary fields in the btree cursor.

v2: reduce scrub btree checker memory footprint even more, put the one
    fixpatch first, use struct_size, fix 80col problems, move all the
    btree cache work to a separate series
v3: rebase to 5.15-rc4, fold in the per-btree cursor cache patches,
    remove all the references to "zones" since they're called "caches"
    in Linux

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-dynamic-depth-5.16
---
 fs/xfs/libxfs/xfs_ag_resv.c        |   18 ++
 fs/xfs/libxfs/xfs_alloc.c          |    7 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   39 ++++-
 fs/xfs/libxfs/xfs_alloc_btree.h    |    5 +
 fs/xfs/libxfs/xfs_bmap.c           |   13 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   41 +++++
 fs/xfs/libxfs/xfs_bmap_btree.h     |    5 +
 fs/xfs/libxfs/xfs_btree.c          |  270 +++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_btree.h          |   79 ++++++++---
 fs/xfs/libxfs/xfs_btree_staging.c  |   10 +
 fs/xfs/libxfs/xfs_fs.h             |    2 
 fs/xfs/libxfs/xfs_ialloc.c         |    1 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   46 +++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    5 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   46 +++++-
 fs/xfs/libxfs/xfs_refcount_btree.h |    5 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |  108 +++++++++++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |    5 +
 fs/xfs/libxfs/xfs_trans_resv.c     |   13 ++
 fs/xfs/libxfs/xfs_trans_space.h    |    7 +
 fs/xfs/scrub/bitmap.c              |   22 +--
 fs/xfs/scrub/bmap.c                |    2 
 fs/xfs/scrub/btree.c               |   77 +++++-----
 fs/xfs/scrub/btree.h               |   13 +-
 fs/xfs/scrub/trace.c               |    7 +
 fs/xfs/scrub/trace.h               |   10 +
 fs/xfs/xfs_super.c                 |   53 ++++++-
 fs/xfs/xfs_trace.h                 |    2 
 28 files changed, 660 insertions(+), 251 deletions(-)

