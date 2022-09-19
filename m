Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FE1C32771
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Sep 2022 02:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiISCBo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Sep 2022 22:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiISCBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Sep 2022 22:01:43 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6845186D5
        for <linux-xfs@vger.kernel.org>; Sun, 18 Sep 2022 19:01:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-149-49.pa.vic.optusnet.com.au [49.186.149.49])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 93E648A945F
        for <linux-xfs@vger.kernel.org>; Mon, 19 Sep 2022 12:01:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oa66M-009R3J-1P
        for linux-xfs@vger.kernel.org; Mon, 19 Sep 2022 12:01:38 +1000
Date:   Mon, 19 Sep 2022 12:01:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next branch has been updated to dc256418235a
Message-ID: <20220919020138.GI3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6327cd84
        a=XTRC1Ovx3SkpaCW1YxGVGA==:117 a=XTRC1Ovx3SkpaCW1YxGVGA==:17
        a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=7-415B0cAAAA:8
        a=sgXpOid4SbHEnJau09cA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just updated the mast branch to v6.0-rc6 and the for-next
branch with some of the outstanding changes posted and reviewed in
the last few weeks. This is a relatively small update - I've been
largely out of action for the past 3 weeks so this update is just
trying to catch up on the small stuff that has been happening
recently.

It's likely I've missed stuff, so don't be afraid to resend anything
you think I should have picke dup but didn't. Note  I haven't even
considered any of major patchsets anyone (including myself) have
proposed so far this cycle. It's unlikely at this point that
anything other than small changes will make this cycle as a result. 

-Dave.

----------------------------------------------------------------

Current head commit: dc256418235a8355fbdf83b90048d8704b8d1654:

  xfs: do not need to check return value of xlog_kvmalloc() (2022-09-19 06:55:14 +1000)

----------------------------------------------------------------
Christian Brauner (1):
      xfs: port to vfs{g,u}id_t and associated helpers

Gaosheng Cui (1):
      xfs: remove xfs_setattr_time() declaration

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
 fs/xfs/libxfs/xfs_dir2_sf.c     |  4 +---
 fs/xfs/libxfs/xfs_inode_fork.c  |  4 ++--
 fs/xfs/xfs_attr_item.c          |  6 ------
 fs/xfs/xfs_inode.c              | 13 ++++++-------
 fs/xfs/xfs_inode_item.c         |  2 +-
 fs/xfs/xfs_inode_item_recover.c |  4 ++--
 fs/xfs/xfs_iops.c               |  6 ++++--
 fs/xfs/xfs_iops.h               |  1 -
 fs/xfs/xfs_itable.c             |  8 ++++++--
 fs/xfs/xfs_log.c                | 10 +++++-----
 fs/xfs/xfs_mount.c              | 38 ++++++++++++++++++++------------------
 fs/xfs/xfs_reflink.c            | 22 ++++++++++++----------
 fs/xfs/xfs_stats.c              |  4 ++--
 fs/xfs/xfs_trace.h              |  4 ++--
 15 files changed, 64 insertions(+), 64 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
