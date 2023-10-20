Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5E8C001DF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 22:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjJTWRe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 18:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjJTWRd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 18:17:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB3ED5A
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 15:17:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D60DC433C9;
        Fri, 20 Oct 2023 22:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697840251;
        bh=o2+NFbQwgkn9V3qGMndaww0fXGqWnf/1pw5JXBLi+0w=;
        h=Date:From:To:Cc:Subject:From;
        b=mukgZi/fPytpWdh8kBN5mi7r1r1jNLXLUx+biYmeClJ4v8mwz1t37sh+/xnGllfUw
         BU1Czjxx1/L6oWm8DQv8exD2TtsxcbjiqtotvdAXevS7reAGaGAZ3FMhI4LOUuXbuZ
         rJeZFXSD3YacmZ3KX7WUkrQ2ey9dQDksJq/IOvTc/3jPTLkVXLgSWtlstrCh4PAqC+
         izwjZiJiug8N97dpBs56zqDdLVDmsJc+9EcfuUhVdKMItw/16cXM6YeX1tIqSIl9/P
         LQThUaG1lQxk01ghuvH6KoFQlmN25bpt1DEqyagi6OPFaJy4hil1uXwr8NIQsi+xTg
         UexYbBlLCOT3g==
Date:   Fri, 20 Oct 2023 15:17:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandanbabu@kernel.org, djwong@kernel.org
Cc:     hch@lst.de, linux-xfs@vger.kernel.org
Subject: [GIT PULL 2/6] xfs: clean up realtime type usage
Message-ID: <169781767994.780878.672267596860381813.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.7-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit c2988eb5cff75c02bc57e02c323154aa08f55b78:

xfs: rt stubs should return negative errnos when rt disabled (2023-10-17 16:22:40 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/clean-up-realtime-units-6.7_2023-10-19

for you to fetch changes up to 2d5f216b77e33f9b503bd42998271da35d4b7055:

xfs: convert rt extent numbers to xfs_rtxnum_t (2023-10-17 16:24:22 -0700)

----------------------------------------------------------------
xfs: clean up realtime type usage [v1.1]

The realtime code uses xfs_rtblock_t and xfs_fsblock_t in a lot of
places, and it's very confusing.  Clean up all the type usage so that an
xfs_rtblock_t is always a block within the realtime volume, an
xfs_fileoff_t is always a file offset within a realtime metadata file,
and an xfs_rtxnumber_t is always a rt extent within the realtime volume.

v1.1: various cleanups suggested by hch

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
xfs: fix units conversion error in xfs_bmap_del_extent_delay
xfs: make sure maxlen is still congruent with prod when rounding down
xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
xfs: convert xfs_extlen_t to xfs_rtxlen_t in the rt allocator
xfs: convert rt bitmap/summary block numbers to xfs_fileoff_t
xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
xfs: rename xfs_verify_rtext to xfs_verify_rtbext
xfs: convert rt extent numbers to xfs_rtxnum_t

fs/xfs/libxfs/xfs_bmap.c     |   8 +-
fs/xfs/libxfs/xfs_format.h   |   2 +-
fs/xfs/libxfs/xfs_rtbitmap.c | 121 ++++++++++-----------
fs/xfs/libxfs/xfs_rtbitmap.h |  79 ++++++++++++++
fs/xfs/libxfs/xfs_types.c    |   4 +-
fs/xfs/libxfs/xfs_types.h    |   8 +-
fs/xfs/scrub/bmap.c          |   2 +-
fs/xfs/scrub/fscounters.c    |   2 +-
fs/xfs/scrub/rtbitmap.c      |  12 +--
fs/xfs/scrub/rtsummary.c     |   4 +-
fs/xfs/scrub/trace.h         |   7 +-
fs/xfs/xfs_bmap_util.c       |  18 ++--
fs/xfs/xfs_fsmap.c           |   2 +-
fs/xfs/xfs_rtalloc.c         | 248 +++++++++++++++++++++++--------------------
fs/xfs/xfs_rtalloc.h         |  89 ++--------------
15 files changed, 319 insertions(+), 287 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h
