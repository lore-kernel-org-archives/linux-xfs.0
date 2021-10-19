Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68E4C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B83F760F9F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhJSSyV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhJSSyU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 14:54:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CDB360EFE;
        Tue, 19 Oct 2021 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634669527;
        bh=aGfip/neZwiLTifmkZuw7HkmyKYGkNILha0TdyiO/ks=;
        h=Subject:From:To:Cc:Date:From;
        b=kHqq8PX07X6SFeQ5ZD4FeZojiyPHGt+D9NMVzGt5FiNivRpiFwVF7UF0gfzDeNwgG
         ZjyfSzKEruvFqYREKsVvyR57QOdywql7NGvA9fG4ghDkXYJCjHEnSZxOlVmxwMCwAA
         IBXuqJplxWqNNDCeaXbpZUgO/t+qnkycVFmaeQ35Tq+tB4xV1Roj/DPOY+cgdtMFkH
         mrpGJ+J2acSpIa/uCmpQNfbLQU96gmHhibqXFhlQOYh6AQrg6V4dQfdbncvqistwUO
         Vzk3pMEgzR1z/Pyv889ZQ7StAv0P0UISReWy5ulN59sZ4/ulP9RdJRgrC4JOk6sj1N
         ZoMQBZCcRl1ZA==
Subject: [PATCHSET 0/5] xfs: use slab caches for deferred log items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Oct 2021 11:52:07 -0700
Message-ID: <163466952709.2235671.6966476326124447013.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Since the adding of reflink and reverse mapping to the filesystem,
deferred log items are used quite a lot more frequently than they used
to be.  This means that we're cycling a lot of small objects through the
slab caches, just like we do with btree cursors.  Pack deferred item
contexts into memory pages more densely by creating separate slab caches
for each type, and shrink the intent items to use less memory.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-item-caches-5.16
---
 fs/xfs/libxfs/xfs_ag.c         |    2 -
 fs/xfs/libxfs/xfs_alloc.c      |   82 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_alloc.h      |   36 ++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.c       |   76 ++++++++++---------------------------
 fs/xfs/libxfs/xfs_bmap.h       |   35 +++--------------
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 -
 fs/xfs/libxfs/xfs_defer.c      |   67 +++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h      |    3 +
 fs/xfs/libxfs/xfs_ialloc.c     |    4 +-
 fs/xfs/libxfs/xfs_refcount.c   |   46 +++++++++++++++-------
 fs/xfs/libxfs/xfs_refcount.h   |    7 +++
 fs/xfs/libxfs/xfs_rmap.c       |   21 ++++++++++
 fs/xfs/libxfs/xfs_rmap.h       |    7 +++
 fs/xfs/xfs_bmap_item.c         |    4 +-
 fs/xfs/xfs_extfree_item.c      |   19 ++++++---
 fs/xfs/xfs_refcount_item.c     |    4 +-
 fs/xfs/xfs_reflink.c           |    2 -
 fs/xfs/xfs_rmap_item.c         |    4 +-
 fs/xfs/xfs_super.c             |   21 +++++-----
 19 files changed, 302 insertions(+), 140 deletions(-)

