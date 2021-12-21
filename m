Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0815FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Dec 2021 18:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhLUS3s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Dec 2021 13:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhLUS3s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Dec 2021 13:29:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02536C061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Dec 2021 10:29:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9420D61723
        for <linux-xfs@vger.kernel.org>; Tue, 21 Dec 2021 18:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E367FC36AE8
        for <linux-xfs@vger.kernel.org>; Tue, 21 Dec 2021 18:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640111387;
        bh=Mfls5OGrXyxrtLSF8hlCeDOeJ+4c1EgZkegJrNMHyao=;
        h=Date:From:To:Subject:From;
        b=hm4yukvdtONbkYRrsTAY+rXDF24Y/i9dW3hNjL5Jc4sgIVA1AF0z+QN9Vf5Bd9sn8
         vv271s8jPo9nHG2XjGT0SIvUT6FaxDNtb6Wb/8IrAYkMxTeK3N4coj5sPQ9jWwD1IE
         qMg3J7locYtd29bwGwIsdC8XIr47ajjCovf5Yb2f7WVHBUnN4X2zuJV+n0C8HN9lVE
         wvMxeeaHiPjQu/5/uqNem6b8zvvasQxcvhO7/85EORFFlYicHAr2oJTB1dgoToTZOD
         6G3cYQyRARjYCI4sCEvU3tD8vOWZLx5gO2Lk+sabrZGo8YaofZOilGRHEE7tW4nXBE
         wOBZ+cLvtmrWQ==
Date:   Tue, 21 Dec 2021 10:29:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6ed6356b0771
Message-ID: <20211221182946.GX27664@magnolia>
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
the next update.

This is nominally the 5.17 merge branch, though so far I only have lower
severity bug fixes and a backlog of patch review (nrext64 and
investigating transaction overruns in Dave's log scalability fixes,
iirc) that probably isn't going to make it given the 2.8 days I have
left before winter break.

The new head of the for-next branch is commit:

6ed6356b0771 xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

New Commits:

Dan Carpenter (1):
      [6ed6356b0771] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Darrick J. Wong (5):
      [47a6df7cd317] xfs: shut down filesystem if we xfs_trans_cancel with deferred work items
      [59d7fab2dff9] xfs: fix quotaoff mutex usage now that we don't support disabling it
      [7b7820b83f23] xfs: don't expose internal symlink metadata buffers to the vfs
      [7993f1a431bc] xfs: only run COW extent recovery when there are no live extents
      [e5d1802c70f5] xfs: fix a bug in the online fsck directory leaf1 bestcount check

Dave Chinner (1):
      [09654ed8a18c] xfs: check sb_meta_uuid for dabuf buffer recovery

Yang Xu (1):
      [132c460e4964] xfs: Fix comments mentioning xfs_ialloc


Code Diffstat:

 fs/xfs/scrub/dir.c            | 15 +++++++++++----
 fs/xfs/scrub/quota.c          |  4 ++--
 fs/xfs/scrub/repair.c         |  3 +++
 fs/xfs/scrub/scrub.c          |  4 ----
 fs/xfs/scrub/scrub.h          |  1 -
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_icache.c           |  3 ++-
 fs/xfs/xfs_ioctl.c            |  2 +-
 fs/xfs/xfs_ioctl.h            |  5 +++--
 fs/xfs/xfs_iops.c             | 40 ++++------------------------------------
 fs/xfs/xfs_log_recover.c      | 24 +++++++++++++++++++++++-
 fs/xfs/xfs_mount.c            | 10 ----------
 fs/xfs/xfs_qm_syscalls.c      | 11 +----------
 fs/xfs/xfs_reflink.c          |  5 ++++-
 fs/xfs/xfs_super.c            |  9 ---------
 fs/xfs/xfs_symlink.c          | 27 ++++++++++++++++++---------
 fs/xfs/xfs_trans.c            | 11 ++++++++++-
 17 files changed, 83 insertions(+), 93 deletions(-)
