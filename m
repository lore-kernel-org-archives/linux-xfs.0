Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066A7C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Mar 2022 16:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241315AbiCTQKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 12:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbiCTQKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 12:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FF825599
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 09:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E10B80DC3
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD6CC340E9
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647792535;
        bh=s9jyR2eaHiWiMSWdXjvOMA3PaUlk4+5rA1XzRcvH8YY=;
        h=Date:From:To:Subject:From;
        b=KgerT8CxImKrFcr82FDTZCmYat600PJkKGjvfSYnO614c3MFI8a12Ns9cbDj4yEQl
         SJcIuqRrzjtYOq9Ngv5oWsXYDPFo5Jy9hOx/sThFWEisKDgWrcDrjzLGgVxSC7BjGP
         9eSPnlIYSGBtAsusRE6ltbT2b1TEQ+B0z9/32U8L04lfHdnrCfJ0+cKhX5JnG5r9fF
         8X0LJYvRnRJs3fdbO9ObM8fP+eRpP3IKRTdtHcE49JWnufasJ+lbaGF3VtF16cC+DT
         Qfj/XxppD5n33hWD6z/XsAwmaaIeFqxO6WscUyZDvSgPjySq+Lp3XzTrJE/nYBH1H7
         iE4UjDVGwy09w==
Date:   Sun, 20 Mar 2022 09:08:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 01728b44ef1b
Message-ID: <20220320160854.GH8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Just some more bug fixes; I would like to get the
alloc_set_aside bugfixes and cleanups into this release.

The new head of the for-next branch is commit:

01728b44ef1b xfs: xfs_is_shutdown vs xlog_is_shutdown cage fight

15 new commits:

Darrick J. Wong (7):
      [eba0549bc7d1] xfs: don't generate selinux audit messages for capability testing
      [e014f37db1a2] xfs: use setattr_copy to set vfs inode attributes
      [dd3b015dd806] xfs: refactor user/group quota chown in xfs_setattr_nonsize
      [871b9316e7a7] xfs: reserve quota for dir expansion when linking/unlinking files
      [41667260bc84] xfs: reserve quota for target dir expansion when renaming files
      [996b2329b20a] xfs: constify the name argument to various directory functions
      [744e6c8ada5d] xfs: constify xfs_name_dotdot

Dave Chinner (7):
      [a9a4bc8c76d7] xfs: log worker needs to start before intent/unlink recovery
      [dbd0f5299302] xfs: check buffer pin state after locking in delwri_submit
      [941fbdfd6dd0] xfs: xfs_ail_push_all_sync() stalls when racing with updates
      [70447e0ad978] xfs: async CIL flushes need pending pushes to be made stable
      [d86142dd7c4e] xfs: log items should have a xlog pointer, not a mount
      [8eda87211097] xfs: AIL should be log centric
      [01728b44ef1b] xfs: xfs_is_shutdown vs xlog_is_shutdown cage fight

Gao Xiang (1):
      [1a39ae415c1b] xfs: add missing cmap->br_state = XFS_EXT_NORM update

Code Diffstat:

 fs/xfs/libxfs/xfs_dir2.c      |  36 +++++++------
 fs/xfs/libxfs/xfs_dir2.h      |   8 +--
 fs/xfs/libxfs/xfs_dir2_priv.h |   5 +-
 fs/xfs/xfs_bmap_item.c        |   2 +-
 fs/xfs/xfs_buf.c              |  45 ++++++++++++----
 fs/xfs/xfs_buf_item.c         |   5 +-
 fs/xfs/xfs_extfree_item.c     |   2 +-
 fs/xfs/xfs_fsmap.c            |   4 +-
 fs/xfs/xfs_icache.c           |  10 +++-
 fs/xfs/xfs_inode.c            | 100 ++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h            |   2 +-
 fs/xfs/xfs_inode_item.c       |  12 +++++
 fs/xfs/xfs_ioctl.c            |   2 +-
 fs/xfs/xfs_iops.c             | 118 +++++++++---------------------------------
 fs/xfs/xfs_log.c              |   5 +-
 fs/xfs/xfs_log_cil.c          |  24 +++++++--
 fs/xfs/xfs_pnfs.c             |   3 +-
 fs/xfs/xfs_qm.c               |   8 +--
 fs/xfs/xfs_refcount_item.c    |   2 +-
 fs/xfs/xfs_reflink.c          |   5 +-
 fs/xfs/xfs_rmap_item.c        |   2 +-
 fs/xfs/xfs_trace.h            |   8 +--
 fs/xfs/xfs_trans.c            |  90 +++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.h            |   6 ++-
 fs/xfs/xfs_trans_ail.c        |  47 ++++++++++-------
 fs/xfs/xfs_trans_priv.h       |   3 +-
 kernel/capability.c           |   1 +
 27 files changed, 344 insertions(+), 211 deletions(-)
