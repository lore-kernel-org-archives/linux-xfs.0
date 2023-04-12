Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98789C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDLDr6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDLDr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:47:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C771D40CA
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:47:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64BDE629DF
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB646C433D2;
        Wed, 12 Apr 2023 03:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271275;
        bh=V0/bDNx5Xw75DenmDTdK4NZSRhSGUoPyXsyRq7XgEX8=;
        h=Date:Subject:From:To:Cc:From;
        b=WRIH0wQ1jVh5jVeF2FQn+uTdG3JoSwk4MekQhkzn33k6/qdqYRcK58tGXfMiCnxbi
         hxbYwuCw8LqqqdZRB5/67oHweC/v8DJKs9nuOo/DXxRuwiXx/EkDWlBmW3rURt3lQB
         nmE+Qg+ope4x7qeTgU4XuwSW2oBqhB7NhiwksQGyK1oL0ZDNHK8hxHVPjm9J1OcOTX
         V33L+6RBkxRKXYhoAOshC1+h46vpX4qb7IrvogEouPBm9/2fPkWM74zGVe/QhTzlgs
         dSqCIbhQ7eAXc6XQEoymYHKAkxE8fKOi40cN8ZIXLkk3N6DuUXf2L0atc6docCeuUV
         QIIVt/dQsTiTw==
Date:   Tue, 11 Apr 2023 20:47:55 -0700
Subject: [GIT PULL 12/22] xfs: detect incorrect gaps in rmap btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094858.417736.10571726062895792086.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit efc0845f5d3e253f7f46a60b66a94c3164d76ee3:

xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results (2023-04-11 19:00:15 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-detect-rmapbt-gaps-6.4_2023-04-11

for you to fetch changes up to 30f8ee5e7e0ccce396dff209c6cbce49d0d7e167:

xfs: ensure that single-owner file blocks are not owned by others (2023-04-11 19:00:16 -0700)

----------------------------------------------------------------
xfs: detect incorrect gaps in rmap btree [v24.5]

Following in the theme of the last two patchsets, this one strengthens
the rmap btree record checking so that scrub can count the number of
space records that map to a given owner and that do not map to a given
owner.  This enables us to determine exclusive ownership of space that
can't be shared.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: teach scrub to check for sole ownership of metadata objects
xfs: ensure that single-owner file blocks are not owned by others

fs/xfs/libxfs/xfs_rmap.c | 198 ++++++++++++++++++++++++++++++++---------------
fs/xfs/libxfs/xfs_rmap.h |  18 ++++-
fs/xfs/scrub/agheader.c  |  10 +--
fs/xfs/scrub/bmap.c      |  14 +++-
fs/xfs/scrub/btree.c     |   2 +-
fs/xfs/scrub/ialloc.c    |   4 +-
fs/xfs/scrub/inode.c     |   2 +-
fs/xfs/scrub/rmap.c      |  45 ++++++-----
fs/xfs/scrub/scrub.h     |   2 +-
9 files changed, 198 insertions(+), 97 deletions(-)

