Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4599C001DF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 22:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjJTWRT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 18:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjJTWRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 18:17:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8D81A3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 15:17:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F086DC433C8;
        Fri, 20 Oct 2023 22:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697840237;
        bh=JKl+P5Qi4IdWVojejnBlMaol0q5x2e8wLBSYvdupL3U=;
        h=Date:From:To:Cc:Subject:From;
        b=UuQPDjvI7lktSy3VC1uCKqpw2dQQJ3fTmfgo4bsH4u3G5GMFPm5c58IOrnDYhLMGy
         dV3EJIzFxqNVH2V+2VXe2jd8mTQispqR3b55KLvjhzBBbEYd4j4tPkozMG7u226+E4
         ssIL6N/MGzd9aF0JxFaEavQ7D6GQjSf99yJR6pBdwIE7gX33P3HFwdAhAaBxj9ARM8
         GTzk+rT9QphPKhHXdiBNHMJ318kzeFRViq9oYU9e9bd8+sLytL8sTnTPVkpxGY2TLS
         Kk74lokhTGCCXAJXwmpXLgTfZ60Rw772wAVHXCyOGmUn5+CLd5g+eLZi9yA0l2lJ/g
         Hv8FJz312+IiA==
Date:   Fri, 20 Oct 2023 15:17:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandanbabu@kernel.org, djwong@kernel.org
Cc:     hch@lst.de, linux-xfs@vger.kernel.org
Subject: [GIT PULL 1/6] xfs: minor bugfixes for rt stuff
Message-ID: <169781767899.780878.4787533489808115469.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 58720809f52779dc0f08e53e54b014209d13eebb:

Linux 6.6-rc6 (2023-10-15 13:34:39 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/realtime-fixes-6.7_2023-10-19

for you to fetch changes up to c2988eb5cff75c02bc57e02c323154aa08f55b78:

xfs: rt stubs should return negative errnos when rt disabled (2023-10-17 16:22:40 -0700)

----------------------------------------------------------------
xfs: minor bugfixes for rt stuff [v1.1]

This is a preparatory patchset that fixes a few miscellaneous bugs
before we start in on larger cleanups of realtime units usage.

v1.1: various cleanups suggested by hch

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: bump max fsgeom struct version
xfs: hoist freeing of rt data fork extent mappings
xfs: prevent rt growfs when quota is enabled
xfs: rt stubs should return negative errnos when rt disabled

fs/xfs/libxfs/xfs_bmap.c     | 19 +++----------------
fs/xfs/libxfs/xfs_rtbitmap.c | 33 +++++++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_sb.h       |  2 +-
fs/xfs/xfs_rtalloc.c         |  2 +-
fs/xfs/xfs_rtalloc.h         | 27 ++++++++++++++++-----------
5 files changed, 54 insertions(+), 29 deletions(-)
