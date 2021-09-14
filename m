Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD28C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6307C610D1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhINClR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhINClQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:41:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43C81610CC;
        Tue, 14 Sep 2021 02:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587200;
        bh=wWNdi+GhyyNvs4ZmGxwJhXjOBezFHrbo2M1BBt1nFHs=;
        h=Subject:From:To:Cc:Date:From;
        b=NEOj+MX4uRQe6bAHUCgD8bju20gwDgEXctn6h3Uul3lJJtCF/ThA5NILSNaxOzttR
         4KbWvLTCFGno4G7W06pnw2MbDyjHwEfuhqF81I4xNbfa4v6VxcIe5wNv7eOt/eEf9J
         xiwblFhTrGRJr1BVttbAYg7YUwwZGbWOvh/mWG0KL+50yEd+9NvzRGVUHblSFeul4l
         j8qYTQKyglF0sP2smofdoG/o7LeewjGoyQzdGda8Fn6kvzvCzuweYVaCMCLaH6jP1p
         MCSovUJItXzBxt31NUFZk4i++ymu1SSDy6TAQ83jTOce9/TDoDpcvAJ8jMoxHq5EMo
         tbaRSJto3610w==
Subject: [PATCHSET 00/43] xfs: sync libxfs with 5.15
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:39:59 -0700
Message-ID: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Backport libxfs changes for 5.15.  The xfs_buf changes and the reworking
of the function predicates made things kind of messy, so I'm sending my
version of this to the list for evaluation so that Eric doesn't have to
stumble around wondering what I was smoking... ;)

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.15-sync
---
 copy/xfs_copy.c             |   34 +++---
 db/attrset.c                |    4 -
 db/btblock.c                |    2 
 db/btdump.c                 |    4 -
 db/check.c                  |   20 ++-
 db/crc.c                    |    2 
 db/frag.c                   |    2 
 db/fsmap.c                  |   10 +-
 db/fuzz.c                   |    4 -
 db/info.c                   |    2 
 db/init.c                   |    6 -
 db/inode.c                  |    6 -
 db/io.c                     |    4 -
 db/logformat.c              |    4 -
 db/metadump.c               |   24 ++--
 db/namei.c                  |    2 
 db/sb.c                     |   82 +++++++------
 db/timelimit.c              |    2 
 db/write.c                  |    4 -
 include/kmem.h              |    3 
 include/libxfs.h            |   56 +++++++++
 include/xfs_arch.h          |   10 +-
 include/xfs_mount.h         |  138 ++++++++++++++++++++++-
 include/xfs_trace.h         |    6 +
 libxfs/init.c               |   49 ++++----
 libxfs/kmem.c               |    6 +
 libxfs/libxfs_api_defs.h    |    1 
 libxfs/libxfs_io.h          |   19 +++
 libxfs/libxfs_priv.h        |   23 +---
 libxfs/logitem.c            |    4 -
 libxfs/rdwr.c               |   26 ++--
 libxfs/util.c               |   14 +-
 libxfs/xfs_ag.c             |   25 ++--
 libxfs/xfs_alloc.c          |   56 +++++----
 libxfs/xfs_alloc.h          |   12 +-
 libxfs/xfs_alloc_btree.c    |  100 ++++++++--------
 libxfs/xfs_alloc_btree.h    |    2 
 libxfs/xfs_attr.c           |   56 +++++++--
 libxfs/xfs_attr.h           |    1 
 libxfs/xfs_attr_leaf.c      |   55 +++++----
 libxfs/xfs_attr_remote.c    |   21 ++-
 libxfs/xfs_attr_remote.h    |    2 
 libxfs/xfs_bmap.c           |   38 +++---
 libxfs/xfs_bmap_btree.c     |   56 +++++----
 libxfs/xfs_bmap_btree.h     |    9 +
 libxfs/xfs_btree.c          |  141 ++++++++++++-----------
 libxfs/xfs_btree.h          |   56 +++++----
 libxfs/xfs_btree_staging.c  |   14 +-
 libxfs/xfs_da_btree.c       |   18 +--
 libxfs/xfs_da_format.h      |    2 
 libxfs/xfs_dir2.c           |    6 -
 libxfs/xfs_dir2_block.c     |   14 +-
 libxfs/xfs_dir2_data.c      |   20 ++-
 libxfs/xfs_dir2_leaf.c      |   14 +-
 libxfs/xfs_dir2_node.c      |   20 ++-
 libxfs/xfs_dir2_priv.h      |    2 
 libxfs/xfs_dir2_sf.c        |   12 +-
 libxfs/xfs_dquot_buf.c      |    8 +
 libxfs/xfs_format.h         |  224 +++----------------------------------
 libxfs/xfs_ialloc.c         |   67 +++++------
 libxfs/xfs_ialloc.h         |    3 
 libxfs/xfs_ialloc_btree.c   |   88 +++++++-------
 libxfs/xfs_ialloc_btree.h   |    2 
 libxfs/xfs_inode_buf.c      |   22 ++--
 libxfs/xfs_inode_buf.h      |   11 ++
 libxfs/xfs_log_format.h     |    6 -
 libxfs/xfs_log_rlimit.c     |    2 
 libxfs/xfs_quota_defs.h     |   30 +----
 libxfs/xfs_refcount.c       |   12 +-
 libxfs/xfs_refcount.h       |    2 
 libxfs/xfs_refcount_btree.c |   54 ++++-----
 libxfs/xfs_rmap.c           |   34 +++---
 libxfs/xfs_rmap.h           |   11 +-
 libxfs/xfs_rmap_btree.c     |   72 ++++++------
 libxfs/xfs_rtbitmap.c       |   14 +-
 libxfs/xfs_sb.c             |  263 +++++++++++++++++++++++++++++++------------
 libxfs/xfs_sb.h             |    4 -
 libxfs/xfs_symlink_remote.c |   14 +-
 libxfs/xfs_trans_inode.c    |    2 
 libxfs/xfs_trans_resv.c     |   48 +-------
 libxfs/xfs_trans_resv.h     |    2 
 libxfs/xfs_trans_space.h    |    6 -
 libxfs/xfs_types.c          |    2 
 libxfs/xfs_types.h          |    5 +
 libxlog/util.c              |    6 -
 libxlog/xfs_log_recover.c   |   17 +--
 logprint/logprint.c         |    3 
 mkfs/xfs_mkfs.c             |    8 +
 repair/agbtree.c            |   10 +-
 repair/agheader.c           |    6 -
 repair/attr_repair.c        |   10 +-
 repair/dino_chunks.c        |    6 -
 repair/dinode.c             |   26 ++--
 repair/incore.h             |    4 -
 repair/incore_ino.c         |    2 
 repair/phase2.c             |   21 ++-
 repair/phase4.c             |    2 
 repair/phase5.c             |   30 ++---
 repair/phase6.c             |   22 ++--
 repair/prefetch.c           |   22 ++--
 repair/quotacheck.c         |    4 -
 repair/rmap.c               |   16 +--
 repair/scan.c               |   32 +++--
 repair/versions.c           |   87 +++++++-------
 repair/versions.h           |    4 -
 repair/xfs_repair.c         |   14 +-
 106 files changed, 1406 insertions(+), 1279 deletions(-)

