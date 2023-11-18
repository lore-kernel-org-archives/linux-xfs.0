Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C7AC2BB3F
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Nov 2023 08:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjKRIWv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Nov 2023 03:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjKRIWv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Nov 2023 03:22:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6BAD6A
        for <linux-xfs@vger.kernel.org>; Sat, 18 Nov 2023 00:22:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43996C433C7;
        Sat, 18 Nov 2023 08:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700295765;
        bh=TZPMn/MAA1ndauppHbEL1Zh6Gr/+Tvjm2NLYGYsMOcc=;
        h=From:To:Cc:Subject:Date:From;
        b=IQO4XFahKU/LZS6DKdGxC7jiNEJTjl4sM7w+UiQB4YEGs5iuwTUt+ErStom6ffsMc
         ZE1Nh/oZT6mzqlPo+iPnaFd1tIlvRpbbWEKfCzxD08K9UOTdLem81YIT4sYWD95Lf/
         jcdw5WnMF9Jsx/wHkufXabYIxYtJGeB0S5RB3u4d55LvgFI5ei86w/AWQaxPmBH06d
         hLmRSfAvLfLE9Ybnh8LAG6fe2yGCsrN05qyrEtesASIv5Xi43LaPEJwWkDZUMZCuES
         lsWBOMP0wgUoTJBeVdZ4X+JxV/YROYGNb9svXGXDnBVGMZO3y4u2AhoAHC+Rwd/dp8
         H6TPEKK7Gmijg==
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     ailiop@suse.com, chandanbabu@kernel.org, dchinner@redhat.com,
        djwong@kernel.org, hch@lst.de, holger@applied-asynchrony.com,
        leah.rumancik@gmail.com, leo.lilong@huawei.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        osandov@fb.com, willy@infradead.org
Subject: [GIT PULL] xfs: bug fixes for 6.7
Date:   Sat, 18 Nov 2023 13:46:27 +0530
Message-ID: <87zfzb31yl.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with changes for xfs for 6.7-rc2. The changes are
limited to only bug fixes whose summary is provided below.

I did a test-merge with the main upstream branch as of a few minutes ago and
didn't see any conflicts.  Please let me know if you encounter any problems.

The following changes since commit b85ea95d086471afb4ad062012a4d73cd328fa86:

  Linux 6.7-rc1 (2023-11-12 16:19:07 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.7-fixes-1

for you to fetch changes up to 7930d9e103700cde15833638855b750715c12091:

  xfs: recovery should not clear di_flushiter unconditionally (2023-11-13 09:11:41 +0530)

----------------------------------------------------------------
Bug fixes for 6.7-rc2:

 * Fix deadlock arising due to intent items in AIL not being cleared when log
   recovery fails.
 * Fix stale data exposure bug when remapping COW fork extents to data fork.
 * Fix deadlock when data device flush fails.
 * Fix AGFL minimum size calculation.
 * Select DEBUG_FS instead of XFS_DEBUG when XFS_ONLINE_SCRUB_STATS is
   selected.
 * Fix corruption of log inode's extent count field when NREXT64 feature is
 enabled.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

----------------------------------------------------------------
Anthony Iliopoulos (1):
      xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS

Christoph Hellwig (1):
      xfs: only remap the written blocks in xfs_reflink_end_cow_extent

Dave Chinner (2):
      xfs: inode recovery does not validate the recovered inode
      xfs: recovery should not clear di_flushiter unconditionally

Leah Rumancik (1):
      xfs: up(ic_sema) if flushing data device fails

Long Li (2):
      xfs: factor out xfs_defer_pending_abort
      xfs: abort intent items when recovery intents fail

Matthew Wilcox (Oracle) (1):
      XFS: Update MAINTAINERS to catch all XFS documentation

Omar Sandoval (1):
      xfs: fix internal error from AGFL exhaustion

 MAINTAINERS                     |  3 +--
 fs/xfs/Kconfig                  |  2 +-
 fs/xfs/libxfs/xfs_alloc.c       | 27 +++++++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.c       | 28 ++++++++++++++++---------
 fs/xfs/libxfs/xfs_defer.h       |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
 fs/xfs/xfs_inode_item_recover.c | 46 +++++++++++++++++++++++++++--------------
 fs/xfs/xfs_log.c                | 23 +++++++++++----------
 fs/xfs/xfs_log_recover.c        |  2 +-
 fs/xfs/xfs_reflink.c            |  1 +
 10 files changed, 92 insertions(+), 45 deletions(-)
