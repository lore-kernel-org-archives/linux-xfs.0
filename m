Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C46C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 06:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241825AbiELGDK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 02:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350110AbiELGDJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 02:03:09 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFC5073551
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 23:03:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 51CFE10E73C4
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 16:03:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1np1ug-00AytJ-NQ
        for linux-xfs@vger.kernel.org; Thu, 12 May 2022 16:03:02 +1000
Date:   Thu, 12 May 2022 16:03:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next tree updated to
 efd409a4329f6927795be5ae080cd3ec8c014f49
Message-ID: <20220512060302.GI2306852@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627ca319
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Pj-rv1vzUh6meEShBOYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just pushed out a new for-next branch for XFS. You can find it
here:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

This update contains the new Logged Attribute Replay functionality
that Allison has been toiling over for a very long time. She has
completely restructured how the attribute code works to lay the
ground work for functionality that require attributes to be
manipulated as part of complex atomic operations. This update
includes that functionality as a new experimental feature which can
be turned on via sysfs knob.

Great work, Allison, and thank you for all your hard work and help
during this merge window so we could get to this point!

The other functionality in the merge is the removal of all the quota
warning infrastructure. The has never been used on Linux and really
has no way of being used, so these changes clean up and remove the
remaining pieces we never will use.

At this point in the cycle (almost at -rc7) I'm not going to merge
any more new functionality. I'm planning to spend the next week:

- more thoroughly testing a wider range of configurations
- recoveryloop soak testing
- fixing up all the tests that now fail due to changes merged during
  the cycle
- addressing any regressions and failures that I find
- preparing for an early pull request during the merge window

I know of one failure that still needs to be analysed when LARP is
enabled - the new recovery test fails on 1kB block size filesystems
here. Otherwise, I did not see any unexpected failures during
overnight testing on default configs, rmapbt=1, all quotas enabled,
1kB block size or V4 only testing.

I would appreciate it if everyone could spend some cycles over the
next week running tests against this for-next branch. we've merged a
*lot* of new code this cycle so any extra test coverage we can get
at this time will help ensure we find regressions sooner rather than
later.

If I've missed anything that I should have picked up for this cycle,
please let me know ASAP so we can determine an appropriate merge
plan for it.

Cheers,

Dave.


The following changes since commit 86810a9ebd9e69498524c57a83f1271ade56ded8:

  Merge branch 'guilt/xfs-5.19-fuzz-fixes' into xfs-5.19-for-next (2022-05-04 12:38:02 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

for you to fetch changes up to efd409a4329f6927795be5ae080cd3ec8c014f49:

----------------------------------------------------------------
Head Commit:

efd409a4329f Merge branch 'xfs-5.19-quota-warn-remove' into xfs-5.19-for-next

----------------------------------------------------------------
Allison Henderson (14):
      xfs: Fix double unlock in defer capture code
      xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
      xfs: Set up infrastructure for log attribute replay
      xfs: Implement attr logging and replay
      xfs: Skip flip flags for delayed attrs
      xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
      xfs: Remove unused xfs_attr_*_args
      xfs: Add log attribute error tag
      xfs: Add larp debug option
      xfs: Merge xfs_delattr_context into xfs_attr_item
      xfs: Add helper function xfs_attr_leaf_addname
      xfs: Add helper function xfs_init_attr_trans
      xfs: add leaf split error tag
      xfs: add leaf to node error tag

Catherine Hoang (3):
      xfs: remove quota warning limit from struct xfs_quota_limits
      xfs: remove warning counters from struct xfs_dquot_res
      xfs: don't set quota warning values

Dave Chinner (20):
      xfs: avoid empty xattr transaction when attrs are inline
      xfs: initialise attrd item to zero
      xfs: make xattri_leaf_bp more useful
      xfs: rework deferred attribute operation setup
      xfs: separate out initial attr_set states
      xfs: kill XFS_DAC_LEAF_ADDNAME_INIT
      xfs: consolidate leaf/node states in xfs_attr_set_iter
      xfs: split remote attr setting out from replace path
      xfs: XFS_DAS_LEAF_REPLACE state only needed if !LARP
      xfs: remote xattr removal in xfs_attr_set_iter() is conditional
      xfs: clean up final attr removal in xfs_attr_set_iter
      xfs: xfs_attr_set_iter() does not need to return EAGAIN
      xfs: introduce attr remove initial states into xfs_attr_set_iter
      xfs: switch attr remove to xfs_attri_set_iter
      xfs: remove xfs_attri_remove_iter
      xfs: use XFS_DA_OP flags in deferred attr ops
      xfs: ATTR_REPLACE algorithm with LARP enabled needs rework
      xfs: detect empty attr leaf blocks in xfs_attr3_leaf_verify
      xfs: can't use kmem_zalloc() for attribute buffers
      Merge branch 'xfs-5.19-quota-warn-remove' into xfs-5.19-for-next

 fs/xfs/Makefile                 |    1 +
 fs/xfs/libxfs/xfs_attr.c        | 1641 ++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 fs/xfs/libxfs/xfs_attr.h        |  198 ++++++++++--
 fs/xfs/libxfs/xfs_attr_leaf.c   |   64 +++-
 fs/xfs/libxfs/xfs_attr_remote.c |   37 +--
 fs/xfs/libxfs/xfs_attr_remote.h |    6 +-
 fs/xfs/libxfs/xfs_da_btree.c    |    4 +
 fs/xfs/libxfs/xfs_da_btree.h    |   10 +-
 fs/xfs/libxfs/xfs_defer.c       |   24 +-
 fs/xfs/libxfs/xfs_defer.h       |    3 +
 fs/xfs/libxfs/xfs_errortag.h    |    8 +-
 fs/xfs/libxfs/xfs_format.h      |    9 +-
 fs/xfs/libxfs/xfs_log_format.h  |   45 ++-
 fs/xfs/libxfs/xfs_log_recover.h |    2 +
 fs/xfs/libxfs/xfs_quota_defs.h  |    1 -
 fs/xfs/scrub/common.c           |    2 +
 fs/xfs/xfs_acl.c                |    4 +-
 fs/xfs/xfs_attr_item.c          |  824 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |   46 +++
 fs/xfs/xfs_attr_list.c          |    1 +
 fs/xfs/xfs_dquot.c              |   15 +-
 fs/xfs/xfs_dquot.h              |    8 -
 fs/xfs/xfs_error.c              |    9 +
 fs/xfs/xfs_globals.c            |    1 +
 fs/xfs/xfs_ioctl.c              |    4 +-
 fs/xfs/xfs_ioctl32.c            |    2 +
 fs/xfs/xfs_iops.c               |    2 +
 fs/xfs/xfs_log.c                |   41 +++
 fs/xfs/xfs_log.h                |    1 +
 fs/xfs/xfs_log_cil.c            |   35 +-
 fs/xfs/xfs_log_priv.h           |   34 ++
 fs/xfs/xfs_log_recover.c        |    2 +
 fs/xfs/xfs_ondisk.h             |    2 +
 fs/xfs/xfs_qm.c                 |    9 -
 fs/xfs/xfs_qm.h                 |    5 -
 fs/xfs/xfs_qm_syscalls.c        |   26 +-
 fs/xfs/xfs_quotaops.c           |    8 +-
 fs/xfs/xfs_sysctl.h             |    1 +
 fs/xfs/xfs_sysfs.c              |   24 ++
 fs/xfs/xfs_trace.h              |   32 +-
 fs/xfs/xfs_trans_dquot.c        |    3 +-
 fs/xfs/xfs_xattr.c              |    2 +-
 42 files changed, 2180 insertions(+), 1016 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
Dave Chinner
david@fromorbit.com
