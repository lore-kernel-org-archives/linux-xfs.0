Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD67C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51C561260
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhJSSyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhJSSyF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 14:54:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B79611AD;
        Tue, 19 Oct 2021 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634669512;
        bh=Ak/Yd4DEg46yQmijO3KLJs0ouDOuqm24LHZohOPiLKk=;
        h=Subject:From:To:Cc:Date:From;
        b=kmo3eXgZMgWzkst5Hdyxy4fM6X78X9hQEGY79WIOYvLtRahynJ9+FPooEeFZ7WGIO
         V2vpKev1WNCKeLMwgGCgGdMsZXEJXQ28ExQPRAviLuLHx7O4JxhJT1vdV7hxKgbirt
         orffVHT0Sy6rz5ohRb8mGf1I2zbtOJlmSyNTdPojZvowakiIbo3+A/b3R0Gd9250ri
         vJ4RpGtWxJ31sbo8LBU9tL8A9a7g54sS2POfXdIe/6eGVUJPTpuVDplfMWHxwalLLx
         YKLgcXuXKBvNQRQWLE2Hh4Au3XnSYjsdK+BqbjSJMG7P6MY9Bkrmhi0qDS3lWQ9uJY
         IqRThGLoJrhYw==
Subject: [PATCHSET v2 0/2] xfs: clean up zone terminology
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Oct 2021 11:51:52 -0700
Message-ID: <163466951226.2234337.10978241003370731405.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Dave requested[1] that we stop using the old Irix "zone" terminology to
describe Linux slab caches.  Since we're using an ugly typedef to wrap
the new in the old, get rid of the typedef, and change the wording to
reflect the way Linux has been for a good 20+ years.  This enables
cleaning up of the bigger zone/cache mess in userspace.

[1] https://lore.kernel.org/linux-xfs/20210926004343.GC1756565@dread.disaster.area/

v2: rebase atop the final btree cursor series

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=slab-cache-cleanups-5.16
---
 fs/xfs/kmem.h                      |    4 -
 fs/xfs/libxfs/xfs_alloc.c          |    6 -
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 
 fs/xfs/libxfs/xfs_attr_leaf.c      |    2 
 fs/xfs/libxfs/xfs_bmap.c           |    6 -
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 
 fs/xfs/libxfs/xfs_btree.h          |    4 -
 fs/xfs/libxfs/xfs_da_btree.c       |    6 -
 fs/xfs/libxfs/xfs_da_btree.h       |    3 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
 fs/xfs/libxfs/xfs_inode_fork.c     |    8 +
 fs/xfs/libxfs/xfs_inode_fork.h     |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 
 fs/xfs/xfs_attr_inactive.c         |    2 
 fs/xfs/xfs_bmap_item.c             |   12 +-
 fs/xfs/xfs_bmap_item.h             |    6 -
 fs/xfs/xfs_buf.c                   |   14 +-
 fs/xfs/xfs_buf_item.c              |    8 +
 fs/xfs/xfs_buf_item.h              |    2 
 fs/xfs/xfs_dquot.c                 |   26 ++--
 fs/xfs/xfs_extfree_item.c          |   18 +--
 fs/xfs/xfs_extfree_item.h          |    6 -
 fs/xfs/xfs_icache.c                |   10 +-
 fs/xfs/xfs_icreate_item.c          |    6 -
 fs/xfs/xfs_icreate_item.h          |    2 
 fs/xfs/xfs_inode.c                 |    2 
 fs/xfs/xfs_inode.h                 |    2 
 fs/xfs/xfs_inode_item.c            |    6 -
 fs/xfs/xfs_inode_item.h            |    2 
 fs/xfs/xfs_log.c                   |    6 -
 fs/xfs/xfs_log_priv.h              |    2 
 fs/xfs/xfs_mru_cache.c             |    2 
 fs/xfs/xfs_qm.h                    |    2 
 fs/xfs/xfs_refcount_item.c         |   12 +-
 fs/xfs/xfs_refcount_item.h         |    6 -
 fs/xfs/xfs_rmap_item.c             |   12 +-
 fs/xfs/xfs_rmap_item.h             |    6 -
 fs/xfs/xfs_super.c                 |  218 ++++++++++++++++++------------------
 fs/xfs/xfs_trans.c                 |    8 +
 fs/xfs/xfs_trans.h                 |    2 
 fs/xfs/xfs_trans_dquot.c           |    4 -
 43 files changed, 226 insertions(+), 231 deletions(-)

