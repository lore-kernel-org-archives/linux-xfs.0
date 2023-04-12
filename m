Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6941BC77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjDLDpW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDLDpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:45:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0AF30E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67EA76101C
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C316CC4339B;
        Wed, 12 Apr 2023 03:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271119;
        bh=zgq2GY3PFDK9wWxE5M8w4Ajvmbif3wuS8JM0owNeoIU=;
        h=Date:Subject:From:To:Cc:From;
        b=oI5cY9VCRtJaack3PjbEhhzghupHNLtLxmawEx4I6ZrmDAwsTNGKsdV6ts8FMNxu1
         JXRVuESRFv5XgJit/BikHy9tqLc367mV7C+gCkHaEnT8t+rSapDr7bLB9WDfC+raYo
         ssEhrm1cNwY3yNkVDxjhWXOeSQgXLWqadQr2pRNMYZvxKpGFvQfOVQog/ORkw2O7YX
         ddmgh567Yc6i84evydNJX5EqtTqlj0uKa6Lb+Ilsai6vx6kUxZI4bEXUswGvI7D05W
         55ABVURswarVHaymnLMdEDenXyNpAxhSCr5SeC4U04UVxKNruUyVNWwq4p98a5T6c/
         4j7XQ/8ZYta5w==
Date:   Tue, 11 Apr 2023 20:45:19 -0700
Subject: [GIT PULL 2/22] xfs: make intent items take a perag reference
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127093858.417736.1801856127309869556.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 03786f0afb2ed5705a0478e14fea50a7f1a44f7e:

xfs: document future directions of online fsck (2023-04-11 18:59:52 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/intents-perag-refs-6.4_2023-04-11

for you to fetch changes up to 00e7b3bac1dc8961bd5aa9d39e79131c6bd81181:

xfs: give xfs_refcount_intent its own perag reference (2023-04-11 18:59:55 -0700)

----------------------------------------------------------------
xfs: make intent items take a perag reference [v24.5]

Now that we've cleaned up some code warts in the deferred work item
processing code, let's make intent items take an active perag reference
from their creation until they are finally freed by the defer ops
machinery.  This change facilitates the scrub drain in the next patchset
and will make it easier for the future AG removal code to detect a busy
AG in need of quiescing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: give xfs_bmap_intent its own perag reference
xfs: pass per-ag references to xfs_free_extent
xfs: give xfs_extfree_intent its own perag reference
xfs: give xfs_rmap_intent its own perag reference
xfs: give xfs_refcount_intent its own perag reference

fs/xfs/libxfs/xfs_ag.c             |  6 ++---
fs/xfs/libxfs/xfs_alloc.c          | 22 +++++++---------
fs/xfs/libxfs/xfs_alloc.h          | 12 ++++++---
fs/xfs/libxfs/xfs_bmap.c           |  1 +
fs/xfs/libxfs/xfs_bmap.h           |  4 +++
fs/xfs/libxfs/xfs_ialloc_btree.c   |  7 +++--
fs/xfs/libxfs/xfs_refcount.c       | 33 ++++++++++-------------
fs/xfs/libxfs/xfs_refcount.h       |  4 +++
fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
fs/xfs/libxfs/xfs_rmap.c           | 29 ++++++++------------
fs/xfs/libxfs/xfs_rmap.h           |  4 +++
fs/xfs/scrub/repair.c              |  3 ++-
fs/xfs/xfs_bmap_item.c             | 29 +++++++++++++++++++-
fs/xfs/xfs_extfree_item.c          | 54 +++++++++++++++++++++++++++-----------
fs/xfs/xfs_refcount_item.c         | 36 ++++++++++++++++++++++---
fs/xfs/xfs_rmap_item.c             | 32 +++++++++++++++++++---
16 files changed, 196 insertions(+), 85 deletions(-)

