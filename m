Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57356C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 10:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiE3Kmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 06:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiE3Kmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 06:42:37 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FD5125E8A
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 03:42:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4FA5B5357F4
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 20:42:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nvcr2-000ZmX-RP
        for linux-xfs@vger.kernel.org; Mon, 30 May 2022 20:42:32 +1000
Date:   Mon, 30 May 2022 20:42:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next updated to 7146bda743e6
Message-ID: <20220530104232.GQ3923443@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62949f9b
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=DA-6PBKX6_1SoLvRsSQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just updated the for-next branch of the XFS tree. It can be
found here:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

This update contains the last round of changes and fixes for the
5.19 merge window. It has a log recovery memory leak fix, a bunch of
random bugs fixes and more LARP cleanups and bug fixes.

If no problems or urgent bug fixes show up in the next coupe of
days, this is the tree I will ask Linus to pull towrds the end of
the week.

-Dave.

The following changes since commit ab6a8d3f1a2a85dea5b300fd63b7033cb1040a95:

  Merge branch 'guilt/xfs-5.19-misc-3' into xfs-5.19-for-next (2022-05-23 08:55:09 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

for you to fetch changes up to 7146bda743e6f543af60584fad2cfbb6ce83d8ac:

  Merge branch 'guilt/xfs-5.19-larp-cleanups' into xfs-5.19-for-next (2022-05-30 10:58:59 +1000)

----------------------------------------------------------------
Head Commit:

	7146bda743e6 Merge branch 'guilt/xfs-5.19-larp-cleanups' into xfs-5.19-for-next

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix xfs_ifree() error handling to not leak perag ref

Darrick J. Wong (10):
      xfs: purge dquots after inode walk fails during quotacheck
      xfs: don't leak btree cursor when insrec fails after a split
      xfs: refactor buffer cancellation table allocation
      xfs: don't leak xfs_buf_cancel structures when recovery fails
      xfs: convert buf_cancel_table allocation to kmalloc_array
      xfs: don't log every time we clear the log incompat flags
      xfs: implement per-mount warnings for scrub and shrink usage
      xfs: warn about LARP once per mount
      xfs: move xfs_attr_use_log_assist out of xfs_log.c
      xfs: move xfs_attr_use_log_assist usage out of libxfs

Dave Chinner (5):
      xfs: avoid unnecessary runtime sibling pointer endian conversions
      xfs: don't assert fail on perag references on teardown
      xfs: assert in xfs_btree_del_cursor should take into account error
      Merge branch 'guilt/xfs-5.19-recovery-buf-cancel' into xfs-5.19-for-next
      Merge branch 'guilt/xfs-5.19-larp-cleanups' into xfs-5.19-for-next

 fs/xfs/libxfs/xfs_ag.c          |  3 +--
 fs/xfs/libxfs/xfs_attr.c        | 14 ++------------
 fs/xfs/libxfs/xfs_btree.c       | 63 +++++++++++++++++++++++++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_log_recover.h | 14 ++++++++------
 fs/xfs/scrub/scrub.c            | 17 ++---------------
 fs/xfs/xfs_acl.c                |  3 ++-
 fs/xfs/xfs_buf_item_recover.c   | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.c              |  7 +------
 fs/xfs/xfs_inode.c              |  2 +-
 fs/xfs/xfs_ioctl.c              |  3 ++-
 fs/xfs/xfs_iops.c               |  3 ++-
 fs/xfs/xfs_log.c                | 41 -----------------------------------------
 fs/xfs/xfs_log_priv.h           |  3 ---
 fs/xfs/xfs_log_recover.c        | 34 +++++++++++-----------------------
 fs/xfs/xfs_message.h            |  6 ++++++
 fs/xfs/xfs_mount.c              |  1 -
 fs/xfs/xfs_mount.h              | 18 +++++++++++++++++-
 fs/xfs/xfs_qm.c                 |  9 ++++++++-
 fs/xfs/xfs_super.c              |  1 +
 fs/xfs/xfs_super.h              |  1 -
 fs/xfs/xfs_xattr.c              | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_xattr.h              | 13 +++++++++++++
 22 files changed, 266 insertions(+), 135 deletions(-)
 create mode 100644 fs/xfs/xfs_xattr.h

-- 
Dave Chinner
david@fromorbit.com
