Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E7AC7619A
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 00:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjDMAxW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 20:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDMAxV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 20:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B7B2D66
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 17:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D9B262C28
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB6FC433EF;
        Thu, 13 Apr 2023 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681347199;
        bh=1qdmVDFjFDJO6uUGLpjHi5WuLF0vOFO1yNGmpIt8xlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qZszoqL1+J9aYEEB034goWu71Em5RTUyGs6qRvriEKQWuU+4ymHS8AZJ0zzlDurAH
         hthYZqFNPfyEtHXdWI3K2ztc1BT2tN8t17arDMCjBoqGDy4/Dah6QmVQEecfSmka8R
         1iUjk2k3QmO4jAaTK4NOuFgJQHSjJmdbFUvK4XoVW/6IHVjggz9i8praL81JqDelZZ
         x81RjZtAKbLtiYpVwKLAgl2AKZRN1x2YWH2wtC0RlJODucqlNjgPcspq8MQCWlc0n6
         JiHlKo2wM2HgGjEKsem2b8xZz35jCLd1TBsbfHFJR6H6x4Rywwbwm2f4b8SFksEFT5
         KRFisgGk2qBtA==
Date:   Wed, 12 Apr 2023 17:53:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL v2 15/22] xfs: fix iget/irele usage in online fsck
Message-ID: <20230413005319.GU360889@frogsfrogsfrogs>
References: <168127095149.417736.13949355066335699103.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168127095149.417736.13949355066335699103.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0916056eba4fd816f8042a3960597c316ea10256:

xfs: fix parent pointer scrub racing with subdirectory reparenting (2023-04-11 19:00:20 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-iget-fixes-6.4_2023-04-12

for you to fetch changes up to 1fc7a0597d237c17b6501f8c33b76d3eaaae9079:

xfs: don't take the MMAPLOCK when scrubbing file metadata (2023-04-11 19:00:22 -0700)

----------------------------------------------------------------
xfs: fix iget/irele usage in online fsck [v24.5]

This patchset fixes a handful of problems relating to how we get and
release incore inodes in the online scrub code.  The first patch fixes
how we handle DONTCACHE -- our reasons for setting (or clearing it)
depend entirely on the runtime environment at irele time.  Hence we can
refactor iget and irele to use our own wrappers that set that context
appropriately.

The second patch fixes a race between the iget call in the inode core
scrubber and other writer threads that are allocating or freeing inodes
in the same AG by changing the behavior of xchk_iget (and the inode core
scrub setup function) to return either an incore inode or the AGI buffer
so that we can be sure that the inode cannot disappear on us.

The final patch elides MMAPLOCK from scrub paths when possible.  It did
not fit anywhere else.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: manage inode DONTCACHE status at irele time
xfs: fix an inode lookup race in xchk_get_inode
xfs: rename xchk_get_inode -> xchk_iget_for_scrubbing
xfs: retain the AGI when we can't iget an inode to scrub the core
xfs: don't take the MMAPLOCK when scrubbing file metadata

fs/xfs/scrub/bmap.c   |   9 +-
fs/xfs/scrub/common.c | 306 +++++++++++++++++++++++++++++++++++++++++---------
fs/xfs/scrub/common.h |  10 +-
fs/xfs/scrub/dir.c    |  14 +--
fs/xfs/scrub/inode.c  | 191 ++++++++++++++++++++++++++-----
fs/xfs/scrub/parent.c |  13 +--
fs/xfs/scrub/scrub.c  |   2 +-
fs/xfs/xfs_icache.c   |   3 +-
fs/xfs/xfs_icache.h   |  11 +-
9 files changed, 448 insertions(+), 111 deletions(-)

