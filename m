Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A28C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2245C61100
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243745AbhIXB1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240863AbhIXB1o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6143F60D42;
        Fri, 24 Sep 2021 01:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446772;
        bh=ucPuDGgemcrgKX909C2sZgKdaIICOFbP3bx9xsD02dM=;
        h=Subject:From:To:Cc:Date:From;
        b=rOmKBW/eE9I0l6IeJpCoy/u27dRgLVYdoBVR9PklgwkZUhDfp0HBufKn84aCk5mRw
         LrygvhKQveN7SMVAfOVgoYmX5/2yhTOU+isOacGi/WSPxi2yiBVOTx9/pZKiVAZqeP
         s+XizFvOFVIQSmWeS603JM7CM9NMKGcsjxDpqoZA/1H51la8IGVj1GYP65HWStbT/8
         f0dZEokHa6HGA+SBNdcGPCo9UZ2zP7ybuFzS7l2AoFKW+8d3iXDDDnGGWi5Bfxfa8o
         wIoumjs1Ac3QpFt5NNVI6AXoYZA8nJw8z1K2tcJyIQldPP0Zg0fEyxuoHKtHalS4r7
         I4fw8haWnOL3Q==
Subject: [PATCHSET RFC v2 chandan 00/15] xfs: support dynamic btree cursor
 height
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:26:12 -0700
Message-ID: <163244677169.2701302.12882919857957905332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, we rearrange the incore btree cursor so that we can
support btrees of any height.  This will become necessary for realtime
rmap and reflink since we'd like to handle tall trees without bloating
the AG btree cursors.

Chandan Babu pointed out that his large extent counters series depends
on the ability to have btree cursors of arbitrary heights, so I've
ported this to 5.15-rc1 so his patchsets won't have to depend on
djwong-dev for submission.

v2: reduce scrub btree checker memory footprint even more, put the one
    fixpatch first, use struct_size, fix 80col problems, move all the
    btree zone work to a separate series

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-dynamic-depth-5.16
---
 fs/xfs/libxfs/xfs_ag_resv.c        |    4 -
 fs/xfs/libxfs/xfs_alloc.c          |   18 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |    7 -
 fs/xfs/libxfs/xfs_bmap.c           |   24 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    7 -
 fs/xfs/libxfs/xfs_btree.c          |  282 +++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_btree.h          |   54 +++++--
 fs/xfs/libxfs/xfs_btree_staging.c  |    8 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 -
 fs/xfs/libxfs/xfs_refcount_btree.c |    6 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |   46 +++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |    2 
 fs/xfs/libxfs/xfs_trans_resv.c     |   12 ++
 fs/xfs/libxfs/xfs_trans_space.h    |    7 +
 fs/xfs/scrub/agheader.c            |   13 +-
 fs/xfs/scrub/agheader_repair.c     |    8 +
 fs/xfs/scrub/bitmap.c              |   22 +--
 fs/xfs/scrub/bmap.c                |    2 
 fs/xfs/scrub/btree.c               |  121 ++++++++-------
 fs/xfs/scrub/btree.h               |   13 +-
 fs/xfs/scrub/dabtree.c             |   62 ++++----
 fs/xfs/scrub/repair.h              |    3 
 fs/xfs/scrub/scrub.c               |   64 ++++----
 fs/xfs/scrub/trace.c               |    7 +
 fs/xfs/scrub/trace.h               |   10 +
 fs/xfs/xfs_mount.c                 |    2 
 fs/xfs/xfs_super.c                 |    4 -
 fs/xfs/xfs_trace.h                 |    2 
 28 files changed, 492 insertions(+), 325 deletions(-)

