Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B63C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345140AbiATAXQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240495AbiATAXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0C0C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:23:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC45FB81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB12C004E1;
        Thu, 20 Jan 2022 00:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638192;
        bh=lJTBiwIuSo2E0XJ8zeOUVBXXCsIlqd4QWQkmJKGSkZ8=;
        h=Subject:From:To:Cc:Date:From;
        b=pGn6MN42SJZRSwYi59MzXHfLDvjU8wabFdyICH8ep21Aqi1kS3AV0dIrv63j1B1TK
         NXuW0nGskmvL69yCYBUfA2JXdeeQxNloejx2BktqXkUK4IBcuRo7DsSSfjcD9t1qMy
         SbrpDQfwPpXQVww5jSaKDHXFo/sZXFRPYqRVbz+UW6VnJZsYhOAO3TvyHYQwN0xhQU
         NdWSHZCbhFIos0eHOLgV4BO9kNVR+jU1vnFySl+oEfGQeYD1YsQ96w0wlmxBcqp7aJ
         4TJDH0xxE7gnhDMaAKl5lasaJZiEDdLMHGRT3MsJEJoX+FCcwMvKjB6B9XKBNv9HxV
         5Afh0tnnDCSXw==
Subject: [PATCHSET 00/48] xfsprogs: sync libxfs with 5.16
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Zeal Robot <zealci@zte.com.cn>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:23:12 -0800
Message-ID: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Backport libxfs changes for 5.16.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.16-sync
---
 copy/xfs_copy.c             |    2 
 copy/xfs_copy.h             |    2 
 db/bmap.c                   |    4 -
 db/bmroot.c                 |   18 +-
 db/btheight.c               |   99 +++++++++++--
 db/check.c                  |   32 ++--
 db/dquot.c                  |    8 +
 db/field.c                  |    6 -
 db/frag.c                   |   18 +-
 db/inode.c                  |   46 +++---
 db/metadump.c               |   45 ++++--
 estimate/xfs_estimate.c     |    2 
 include/kmem.h              |   30 ++--
 include/platform_defs.h.in  |    3 
 include/xfs_mount.h         |    3 
 include/xfs_trans.h         |    3 
 libxfs/defer_item.c         |   32 ++--
 libxfs/init.c               |  103 ++++++++-----
 libxfs/kmem.c               |   77 +++++++---
 libxfs/libxfs_api_defs.h    |    6 +
 libxfs/libxfs_priv.h        |   14 +-
 libxfs/logitem.c            |    8 +
 libxfs/rdwr.c               |   20 +--
 libxfs/trans.c              |   14 +-
 libxfs/util.c               |    2 
 libxfs/xfs_ag.c             |    2 
 libxfs/xfs_ag.h             |   36 +++--
 libxfs/xfs_ag_resv.c        |    3 
 libxfs/xfs_alloc.c          |  120 +++++++++++++--
 libxfs/xfs_alloc.h          |   38 +++++
 libxfs/xfs_alloc_btree.c    |   63 +++++++-
 libxfs/xfs_alloc_btree.h    |    5 +
 libxfs/xfs_attr.c           |   27 ++-
 libxfs/xfs_attr_leaf.c      |    2 
 libxfs/xfs_bmap.c           |  101 ++++---------
 libxfs/xfs_bmap.h           |   35 +----
 libxfs/xfs_bmap_btree.c     |   62 +++++++-
 libxfs/xfs_bmap_btree.h     |    5 +
 libxfs/xfs_btree.c          |  333 ++++++++++++++++++++++++++-----------------
 libxfs/xfs_btree.h          |   99 +++++++++----
 libxfs/xfs_btree_staging.c  |    8 +
 libxfs/xfs_da_btree.c       |   11 +
 libxfs/xfs_da_btree.h       |    3 
 libxfs/xfs_defer.c          |  241 ++++++++++++++++++++++++-------
 libxfs/xfs_defer.h          |   41 ++++-
 libxfs/xfs_dquot_buf.c      |    4 -
 libxfs/xfs_format.h         |   12 +-
 libxfs/xfs_fs.h             |    2 
 libxfs/xfs_ialloc.c         |    5 -
 libxfs/xfs_ialloc_btree.c   |   90 ++++++++++--
 libxfs/xfs_ialloc_btree.h   |    5 +
 libxfs/xfs_inode_buf.c      |    6 -
 libxfs/xfs_inode_fork.c     |   24 ++-
 libxfs/xfs_inode_fork.h     |    2 
 libxfs/xfs_refcount.c       |   46 ++++--
 libxfs/xfs_refcount.h       |    7 +
 libxfs/xfs_refcount_btree.c |   73 ++++++++-
 libxfs/xfs_refcount_btree.h |    5 +
 libxfs/xfs_rmap.c           |   21 +++
 libxfs/xfs_rmap.h           |    7 +
 libxfs/xfs_rmap_btree.c     |  116 +++++++++++----
 libxfs/xfs_rmap_btree.h     |    5 +
 libxfs/xfs_sb.c             |    4 -
 libxfs/xfs_shared.h         |   20 ---
 libxfs/xfs_trans_resv.c     |   18 ++
 libxfs/xfs_trans_space.h    |    9 +
 logprint/log_print_all.c    |    2 
 logprint/logprint.c         |    2 
 man/man8/xfs_db.8           |    8 +
 mdrestore/xfs_mdrestore.c   |    6 -
 repair/attr_repair.c        |    6 -
 repair/attr_repair.h        |    2 
 repair/da_util.h            |    2 
 repair/dino_chunks.c        |    4 -
 repair/dinode.c             |   50 +++---
 repair/dinode.h             |    6 -
 repair/dir2.c               |   14 +-
 repair/dir2.h               |    2 
 repair/incore.h             |    2 
 repair/prefetch.c           |    6 -
 repair/rt.c                 |    4 -
 repair/rt.h                 |    2 
 repair/sb.c                 |    6 -
 repair/scan.c               |   33 ++++
 84 files changed, 1666 insertions(+), 804 deletions(-)

