Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A28FC0032E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 22:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjJTWR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 18:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjJTWR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 18:17:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005D81A3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 15:17:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6BDC433C9;
        Fri, 20 Oct 2023 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697840274;
        bh=Q5w8ROYx9TvESCXwv5cYHEAjXZ4l1UsWg4wlW/yhHdk=;
        h=Date:From:To:Cc:Subject:From;
        b=uTsNNZjfva9c8qHPMTHoJ4UdXE+lfVzgFcCDTunm5pc4F5im7Z2dOzZTr1xi4qqiD
         q4hLUNJprRwuNgif1730l+WSao0uXzrfl4S+EjFCWC4HfQ911HKkGEe66aP1griZoD
         C9tdw7DrBJwfCc1gYzt1BFQFs2b36ZllwsmqU7CA2r9I2z1EUz4Z3pyC3i67LeTRVB
         3e1CT11lqsNjfN41ko2DIDRJ9fFpfyv9LNb3cOcMiSdi/tNuyMN1JpcvVKi06oaWQK
         +gWFfqR7Zfr/n7lt7f6e53qGTPdaLHf+LTGPco58/k0Ps8sJYLWMfIq2T74H3t1Dus
         axxKCoPD6im5Q==
Date:   Fri, 20 Oct 2023 15:17:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandanbabu@kernel.org, djwong@kernel.org
Cc:     dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
        osandov@fb.com, osandov@osandov.com
Subject: [GIT PULL 6/6] xfs: CPU usage optimizations for realtime allocator
Message-ID: <169781768373.780878.12341753475995545092.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 663b8db7b0256b81152b2f786e45ecf12bdf265f:

xfs: use accessor functions for summary info words (2023-10-18 16:53:00 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/rtalloc-speedups-6.7_2023-10-19

for you to fetch changes up to e0f7422f54b092df7996f21da69824aea496490a:

xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near() (2023-10-19 08:34:33 -0700)

----------------------------------------------------------------
xfs: CPU usage optimizations for realtime allocator [v2.3]

This is version 2 of [Omar's] XFS realtime allocator opimization patch
series.

Changes since v1 [1]:

- Fixed potential overflow in patch 4.
- Changed deprecated typedefs to normal struct names
- Fixed broken indentation
- Used xfs_fileoff_t instead of xfs_fsblock_t where appropriate.
- Added calls to xfs_rtbuf_cache_relse anywhere that the cache is used
instead of relying on the buffers being dirtied and thus attached to
the transaction.
- Clarified comments and commit messages in a few places.
- Added Darrick's Reviewed-bys.

Cover letter from v1:

Our distributed storage system uses XFS's realtime device support as a
way to split an XFS filesystem between an SSD and an HDD -- we configure
the HDD as the realtime device so that metadata goes on the SSD and data
goes on the HDD.

We've been running this in production for a few years now, so we have
some fairly fragmented filesystems. This has exposed various CPU
inefficiencies in the realtime allocator. These became even worse when
we experimented with using XFS_XFLAG_EXTSIZE to force files to be
allocated contiguously.

This series adds several optimizations that don't change the realtime
allocator's decisions, but make them happen more efficiently, mainly by
avoiding redundant work. We've tested these in production and measured
~10%% lower CPU utilization. Furthermore, it made it possible to use
XFS_XFLAG_EXTSIZE to force contiguous allocations -- without these
patches, our most fragmented systems would become unresponsive due to
high CPU usage in the realtime allocator, but with them, CPU utilization
is actually ~4-6%% lower than before, and disk I/O utilization is 15-20%%
lower.

Patches 2 and 3 are preparations for later optimizations; the remaining
patches are the optimizations themselves.

1: https://lore.kernel.org/linux-xfs/cover.1687296675.git.osandov@osandov.com/

v2.1: djwong rebased everything atop his own cleanups, added dave's rtalloc_args
v2.2: rebase with new apis and clean them up too
v2.3: move struct definition around for lolz

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: simplify xfs_rtbuf_get calling conventions
xfs: simplify rt bitmap/summary block accessor functions

Dave Chinner (1):
xfs: consolidate realtime allocation arguments

Omar Sandoval (6):
xfs: cache last bitmap block in realtime allocator
xfs: invert the realtime summary cache
xfs: return maximum free size from xfs_rtany_summary()
xfs: limit maxlen based on available space in xfs_rtallocate_extent_near()
xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()

fs/xfs/libxfs/xfs_rtbitmap.c | 525 +++++++++++++++++++++----------------------
fs/xfs/libxfs/xfs_rtbitmap.h |  97 +++++---
fs/xfs/scrub/rtsummary.c     |  13 +-
fs/xfs/xfs_mount.h           |   6 +-
fs/xfs/xfs_rtalloc.c         | 471 ++++++++++++++++++--------------------
5 files changed, 554 insertions(+), 558 deletions(-)
