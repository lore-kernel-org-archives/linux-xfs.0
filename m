Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084FDC0032E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 22:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjJTWRm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 18:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjJTWRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 18:17:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CC9D6E
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 15:17:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C490CC433C7;
        Fri, 20 Oct 2023 22:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697840259;
        bh=wChBoyi90w6UQJM3L/nJ1hFIceJiqpyaMk3nsaUKLLY=;
        h=Date:From:To:Cc:Subject:From;
        b=kNLB1AaqCU1r4F938O1GxbAb3LtL4WRCrw/tWXULBYhfSAEiLdbLoXtLit/6wRvlN
         +tAUuH7kweshnU5cMqIJRtrl4ZZQMAB5yxJTtTYL8FqrG9jhuL82iBnN/LrEZoS3C9
         zyKMOBtQ3zNUDON/01bPIXwEz6cwcKLBshVI6xcvTMYo4N5sLWOIvoLEqUXpowQcXe
         t7xlU+3ZsO86QUdwLKu//akA3ARNElwTUeAkCOvyRLc9w7qIlNyg0AP3FyCWKA15N1
         oecJCbXP6UBSN++yz58jhdzIT1XndQNk/qJe3T81dDOPqkmJJG9Q+CEF1LMHgW8XQx
         okSHom5TUxF8Q==
Date:   Fri, 20 Oct 2023 15:17:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandanbabu@kernel.org, djwong@kernel.org
Cc:     hch@lst.de, linux-xfs@vger.kernel.org
Subject: [GIT PULL 3/6] xfs: refactor rt extent unit conversions
Message-ID: <169781768088.780878.15308741850284605102.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 2d5f216b77e33f9b503bd42998271da35d4b7055:

xfs: convert rt extent numbers to xfs_rtxnum_t (2023-10-17 16:24:22 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/refactor-rt-unit-conversions-6.7_2023-10-19

for you to fetch changes up to ef5a83b7e597038d1c734ddb4bc00638082c2bf1:

xfs: use shifting and masking when converting rt extents, if possible (2023-10-17 16:26:25 -0700)

----------------------------------------------------------------
xfs: refactor rt extent unit conversions [v1.1]

This series replaces all the open-coded integer division and
multiplication conversions between rt blocks and rt extents with calls
to static inline helpers.  Having cleaned all that up, the helpers are
augmented to skip the expensive operations in favor of bit shifts and
masking if the rt extent size is a power of two.

v1.1: various cleanups suggested by hch

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
xfs: create a helper to convert rtextents to rtblocks
xfs: create a helper to compute leftovers of realtime extents
xfs: create a helper to convert extlen to rtextlen
xfs: create helpers to convert rt block numbers to rt extent numbers
xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
xfs: create rt extent rounding helpers for realtime extent blocks
xfs: use shifting and masking when converting rt extents, if possible

fs/xfs/libxfs/xfs_bmap.c       |  20 +++----
fs/xfs/libxfs/xfs_rtbitmap.c   |   4 +-
fs/xfs/libxfs/xfs_rtbitmap.h   | 125 +++++++++++++++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_sb.c         |   2 +
fs/xfs/libxfs/xfs_trans_resv.c |   3 +-
fs/xfs/scrub/inode.c           |   3 +-
fs/xfs/scrub/rtbitmap.c        |  18 +++---
fs/xfs/scrub/rtsummary.c       |   4 +-
fs/xfs/xfs_bmap_util.c         |  38 ++++++-------
fs/xfs/xfs_fsmap.c             |  13 ++---
fs/xfs/xfs_inode_item.c        |   3 +-
fs/xfs/xfs_ioctl.c             |   5 +-
fs/xfs/xfs_linux.h             |  12 ++++
fs/xfs/xfs_mount.h             |   2 +
fs/xfs/xfs_rtalloc.c           |   4 +-
fs/xfs/xfs_super.c             |   3 +-
fs/xfs/xfs_trans.c             |   7 ++-
17 files changed, 200 insertions(+), 66 deletions(-)
