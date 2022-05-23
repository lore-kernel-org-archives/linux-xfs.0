Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DCAC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 07:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiEWHiq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 03:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiEWHio (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 03:38:44 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F60C1572C
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 00:38:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BC4085345E2
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 17:38:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nt2eF-00FLvR-SQ
        for linux-xfs@vger.kernel.org; Mon, 23 May 2022 17:38:39 +1000
Date:   Mon, 23 May 2022 17:38:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next tree updated to ab6a8d3f1a2a
Message-ID: <20220523073839.GC2306852@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=628b3a02
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=5UEedtDfxa9jqUwDksYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just updated the for-next branch of the XFS tree. I can be
found here:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

This update contains fixes and cleanups for the Logged Attribute
Replay feature from Darrick, along with some minor code cleanups
from various contributors.

Barring unforeseen issues, this is the tree I will be asking Linus
to pull later this week. THere are still some pending LARP cleanups
from Darrick - I expect to do a second, smaller pull request late in
the second week of the merge window to push them and any other
issues that are discovered between now and then.

My current testing shows that default configs, rmap enabled and 1kB
block size are all 100% clean auto group passes. There are some
failures in quota enabled tests, 64kB directory block size and V4
format configurations, but these all appear to be pre-existing test
failures and not regressions introduced by changes in this for-next
tree. recoveryloop testing has not discovered any new issues so far,
nor am I seeing a noticable change in failure rates from those
tests.

Despite this, I expect that wider testing is going to uncover some
issues as there is a lot of changes in this tree now. I would
appreaciate it greatly if people could test this tree sooner rather
than later.

Cheers,

Dave.

----------------------------------------------------------------
Head Commit:

ab6a8d3f1a2a Merge branch 'guilt/xfs-5.19-misc-3' into xfs-5.19-for-next

----------------------------------------------------------------
Darrick J. Wong (15):
      xfs: don't leak da state when freeing the attr intent item
      xfs: don't leak the retained da state when doing a leaf to node conversion
      xfs: reject unknown xattri log item operation flags during recovery
      xfs: reject unknown xattri log item filter flags during recovery
      xfs: validate xattr name earlier in recovery
      xfs: free xfs_attrd_log_items correctly
      xfs: clean up xfs_attr_node_hasname
      xfs: put the xattr intent item op flags in their own namespace
      xfs: use a separate slab cache for deferred xattr work state
      xfs: remove struct xfs_attr_item.xattri_flags
      xfs: put attr[id] log item cache init with the others
      xfs: clean up state variable usage in xfs_attr_node_remove_attr
      xfs: rename struct xfs_attr_item to xfs_attr_intent
      xfs: do not use logged xattr updates on V4 filesystems
      xfs: share xattr name and value buffers when logging xattr updates

Dave Chinner (1):
      Merge branch 'guilt/xfs-5.19-misc-3' into xfs-5.19-for-next

Jiapeng Chong (2):
      xfs: Remove dead code
      xfs: Remove duplicate include

Julia Lawall (1):
      xfs: fix typo in comment

Kaixu Xia (1):
      xfs: reduce IOCB_NOWAIT judgment for retry exclusive unaligned DIO

 fs/xfs/libxfs/xfs_attr.c           | 190 +++++++++++++++++++++++-------------------------
 fs/xfs/libxfs/xfs_attr.h           |  63 ++++++++--------
 fs/xfs/libxfs/xfs_attr_remote.c    |   6 +-
 fs/xfs/libxfs/xfs_attr_remote.h    |   6 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  11 +++
 fs/xfs/libxfs/xfs_da_btree.h       |   1 +
 fs/xfs/libxfs/xfs_defer.c          |  67 ++++++++++++-----
 fs/xfs/libxfs/xfs_log_format.h     |  18 +++--
 fs/xfs/libxfs/xfs_symlink_remote.c |   2 +-
 fs/xfs/xfs_attr_item.c             | 364 +++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------
 fs/xfs/xfs_attr_item.h             |  22 ++++--
 fs/xfs/xfs_file.c                  |   2 +-
 fs/xfs/xfs_log.h                   |   7 ++
 fs/xfs/xfs_log_recover.c           |  59 ---------------
 fs/xfs/xfs_super.c                 |  19 +++++
 15 files changed, 456 insertions(+), 381 deletions(-)
 
-- 
Dave Chinner
david@fromorbit.com
