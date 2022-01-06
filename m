Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25ECBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 18:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbiAFSyW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jan 2022 13:54:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42904 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242979AbiAFSyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jan 2022 13:54:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6382BB8234D
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 18:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10724C36AEB
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641495260;
        bh=gQoM8aOXVDquEr/uvMUVSn6yw6uqVyJ+gEIgWnBP8/k=;
        h=Date:From:To:Subject:From;
        b=oLaR6F/00aWp+yHv3V8AchIMjF+W4SdqB6+ldPLgponWEHtJvVYryg8kuSWAzeZOn
         oUJKFxijTnIm+o8Vatkx917Io+XrljwqeMPL8ep508QFiLsX0Hzi0bETL5wVOKLlR4
         TFoXu9P+yzGbiir5qxq9YNIcETcsdWUBvDHPtORZzCGmqxKphIbr6BbTuGtN6EczhE
         Rr41O+VUO+OBk0o6POjQR68tVcu4KQRH3ADOpQE27EUVqFBTYSBi2xCuBt0FK5uj0l
         q12oDLTHNd/lRUO2SmjEIvvPk+qb4GEHjz07A8qkpi/bs1zt9d5sVY+T9BgUX/atMy
         SSZ8m4EDnrdTw==
Date:   Thu, 6 Jan 2022 10:54:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 7e937bb3cbe1
Message-ID: <20220106185419.GP656707@magnolia>
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
the next update.  There's still a few more bug fixes trickling in, so
this is not the last update for the 5.17 merge.

The new head of the for-next branch is commit:

7e937bb3cbe1 xfs: warn about inodes with project id of -1

New Commits:

Dan Carpenter (1):
      [6ed6356b0771] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Darrick J. Wong (8):
      [47a6df7cd317] xfs: shut down filesystem if we xfs_trans_cancel with deferred work items
      [59d7fab2dff9] xfs: fix quotaoff mutex usage now that we don't support disabling it
      [7b7820b83f23] xfs: don't expose internal symlink metadata buffers to the vfs
      [7993f1a431bc] xfs: only run COW extent recovery when there are no live extents
      [e5d1802c70f5] xfs: fix a bug in the online fsck directory leaf1 bestcount check
      [f8d92a66e810] xfs: prevent UAF in xfs_log_item_in_current_chkpt
      [eae44cb341ec] xfs: hold quota inode ILOCK_EXCL until the end of dqalloc
      [7e937bb3cbe1] xfs: warn about inodes with project id of -1

Dave Chinner (2):
      [09654ed8a18c] xfs: check sb_meta_uuid for dabuf buffer recovery
      [8dc9384b7d75] xfs: reduce kvmalloc overhead for CIL shadow buffers

Greg Kroah-Hartman (1):
      [219aac5d469f] xfs: sysfs: use default_groups in kobj_type

Jiapeng Chong (1):
      [f4901a182d33] xfs: Remove redundant assignment of mp

Yang Xu (1):
      [132c460e4964] xfs: Fix comments mentioning xfs_ialloc


Code Diffstat:

 fs/xfs/scrub/dir.c            | 15 +++++---
 fs/xfs/scrub/inode.c          | 14 ++++++++
 fs/xfs/scrub/quota.c          |  4 +--
 fs/xfs/scrub/repair.c         |  3 ++
 fs/xfs/scrub/scrub.c          |  4 ---
 fs/xfs/scrub/scrub.h          |  1 -
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_dquot.c            | 79 +++++++++++++++----------------------------
 fs/xfs/xfs_error.c            |  3 +-
 fs/xfs/xfs_icache.c           |  3 +-
 fs/xfs/xfs_ioctl.c            |  2 +-
 fs/xfs/xfs_ioctl.h            |  5 +--
 fs/xfs/xfs_iops.c             | 40 +++-------------------
 fs/xfs/xfs_log_cil.c          | 52 ++++++++++++++++++++--------
 fs/xfs/xfs_log_recover.c      | 26 ++++++++++++--
 fs/xfs/xfs_mount.c            | 10 ------
 fs/xfs/xfs_qm_syscalls.c      | 11 +-----
 fs/xfs/xfs_reflink.c          |  5 ++-
 fs/xfs/xfs_super.c            |  9 -----
 fs/xfs/xfs_symlink.c          | 27 ++++++++++-----
 fs/xfs/xfs_sysfs.c            | 16 +++++----
 fs/xfs/xfs_trans.c            | 11 +++++-
 22 files changed, 175 insertions(+), 167 deletions(-)
