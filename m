Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C599C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Oct 2022 21:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiJJVie (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 17:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJJVid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 17:38:33 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D848F7D792
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 14:38:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E754D8ADC13;
        Tue, 11 Oct 2022 08:38:28 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oi0Tj-000SBs-JX; Tue, 11 Oct 2022 08:38:27 +1100
Date:   Tue, 11 Oct 2022 08:38:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: updates for 6.1
Message-ID: <20221010213827.GD2703033@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=634490d5
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=G3V0bMtvOhZ3vtI0_UgA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Can you please pull the latest XFS updates from the tag below? There
are relatively few updates this cycle; half the cycle was eaten by a
grue, the other half was eaten by a tricky data corruption issue
that I still haven't entirely solved. Hence there's no major changes
in this cycle and it's largely just minor cleanups and small bug
fixes.

The branch merges cleanly with your tree as of a few minutes ago.
Please let me know if you see something different!

-Dave.

The following changes since commit 521a547ced6477c54b4b0cc206000406c221b4d6:

  Linux 6.0-rc6 (2022-09-18 13:44:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.1-for-linus

for you to fetch changes up to e033f40be262c4d227f8fbde52856e1d8646872b:

  xfs: on memory failure, only shut down fs after scanning all mappings (2022-10-04 16:40:01 +1100)

----------------------------------------------------------------
xfs: changes for 6.1-rc1

This update contains:
- fixes for filesystem shutdown procedure during a DAX memory
  failure notification
- bug fixes
- logic cleanups
- log message cleanups
- updates to use vfs{g,u}id_t helpers where appropriate

Signed-off-by: Dave Chinner <david@fromorbit.com>

----------------------------------------------------------------
Christian Brauner (1):
      xfs: port to vfs{g,u}id_t and associated helpers

Darrick J. Wong (1):
      xfs: on memory failure, only shut down fs after scanning all mappings

Gaosheng Cui (1):
      xfs: remove xfs_setattr_time() declaration

Shida Zhang (2):
      xfs: trim the mapp array accordingly in xfs_da_grow_inode_int
      xfs: rearrange the logic and remove the broken comment for xfs_dir2_isxx

Zeng Heng (7):
      xfs: remove the redundant word in comment
      xfs: remove redundant else for clean code
      xfs: clean up "%Ld/%Lu" which doesn't meet C standard
      xfs: replace unnecessary seq_printf with seq_puts
      xfs: simplify if-else condition in xfs_validate_new_dalign
      xfs: simplify if-else condition in xfs_reflink_trim_around_shared
      xfs: missing space in xfs trace log

Zhiqiang Liu (1):
      xfs: do not need to check return value of xlog_kvmalloc()

ye xingchen (1):
      xfs: Remove the unneeded result variable

 fs/xfs/libxfs/xfs_bmap.c        |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_dir2.c        | 50 ++++++++++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_dir2.h        |  4 ++--
 fs/xfs/libxfs/xfs_dir2_sf.c     |  4 +---
 fs/xfs/libxfs/xfs_inode_fork.c  |  4 ++--
 fs/xfs/scrub/dir.c              |  2 +-
 fs/xfs/xfs_attr_item.c          |  6 ------
 fs/xfs/xfs_dir2_readdir.c       |  2 +-
 fs/xfs/xfs_inode.c              | 13 ++++++-------
 fs/xfs/xfs_inode_item.c         |  2 +-
 fs/xfs/xfs_inode_item_recover.c |  4 ++--
 fs/xfs/xfs_iops.c               |  6 ++++--
 fs/xfs/xfs_iops.h               |  1 -
 fs/xfs/xfs_itable.c             |  8 ++++++--
 fs/xfs/xfs_log.c                | 10 +++++-----
 fs/xfs/xfs_mount.c              | 38 ++++++++++++++++++++------------------
 fs/xfs/xfs_notify_failure.c     | 26 +++++++++++++++++---------
 fs/xfs/xfs_reflink.c            | 22 ++++++++++++----------
 fs/xfs/xfs_stats.c              |  4 ++--
 fs/xfs/xfs_trace.h              |  4 ++--
 21 files changed, 116 insertions(+), 98 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
