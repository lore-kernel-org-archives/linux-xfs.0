Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE130C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbiLaAzh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAzg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:55:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3A413F29
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B3D6B81E03
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE32AC433EF;
        Sat, 31 Dec 2022 00:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448132;
        bh=hjFjoR4ZdV58z4cVYEsJSwt+UFpW24LoPh5Tq3bikhw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lj5zMer42NE2SgwY5b4wKxIM/5gT93c0X8TI4IrPy9z3D0xUx5BzYZ2rSyLleTATW
         cUbbb00KiiQvSTt7SB4BotiuOIWue20UTJX1W2mF16eMXVdqx6gnBczFlSw8jCkT7c
         D6r3UHb1lP68GUiTZZnfI+UzVMjYlColJUCxikhMShau+CDsf0n1LyoG4DXiRGgEtJ
         3/wbugLK6Hy6EHcoEhDB9sABBxlrvu2XHDULZxox0l38PuBOJc3bNGCTYeZtJMKEe0
         VetqG7OLmi2uc35bjWMe4AvVDLApxWo7MzdacP3WnM+Qtix18ruJA3ild6S5GNNEbb
         ctnl22FkWxl4g==
Subject: [PATCHSET v1.0 00/14] xfs: refactor btrees to support records in
 inode root
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:31 -0800
Message-ID: <167243865089.708933.5645420573863731083.stgit@magnolia>
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

This series prepares the btree code to support realtime reverse mapping
btrees by refactoring xfs_ifork_realloc to be fed a per-btree ops
structure so that it can handle multiple types of inode-rooted btrees.
It moves on to refactoring the btree code to use the new realloc
routines and to support storing btree rcords in the inode root, because
the current bmbt code does not support this.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-ifork-records

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-ifork-records
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 -
 fs/xfs/libxfs/xfs_alloc_btree.h    |    3 
 fs/xfs/libxfs/xfs_attr_leaf.c      |    8 -
 fs/xfs/libxfs/xfs_bmap.c           |   59 ++----
 fs/xfs/libxfs/xfs_bmap_btree.c     |   93 ++++++++-
 fs/xfs/libxfs/xfs_bmap_btree.h     |  219 +++++++++++++++------
 fs/xfs/libxfs/xfs_btree.c          |  382 ++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_btree.h          |    4 
 fs/xfs/libxfs/xfs_btree_staging.c  |    4 
 fs/xfs/libxfs/xfs_ialloc.c         |    4 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    6 -
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 
 fs/xfs/libxfs/xfs_inode_fork.c     |  163 +++++++--------
 fs/xfs/libxfs/xfs_inode_fork.h     |   27 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 
 fs/xfs/libxfs/xfs_rmap_btree.c     |    9 -
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 
 fs/xfs/libxfs/xfs_sb.c             |   16 +-
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 
 fs/xfs/scrub/bmap_repair.c         |    2 
 fs/xfs/scrub/inode_repair.c        |    8 -
 fs/xfs/xfs_xchgrange.c             |    4 
 23 files changed, 705 insertions(+), 328 deletions(-)

