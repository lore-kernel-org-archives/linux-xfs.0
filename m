Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6B4C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jan 2022 17:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241435AbiAQRfE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jan 2022 12:35:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43608 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238108AbiAQRfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jan 2022 12:35:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5E8FB81055
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jan 2022 17:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526F4C36AE7
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jan 2022 17:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440900;
        bh=hKFO/x3g6uyrdcn/nPcsBUszTtF+t8YqJT7gBsnfHc0=;
        h=Date:From:To:Subject:From;
        b=npScnD0X/TpYFW8Jj+VKaaSlOYa7Uuv+d+dwbNDTxDIzqQQCqyrIJOJ89mNFvq8NL
         Jjd4uJQiqrteWA7yXj8cHuaUVhSLQepqXJ4qEfNEAiOzLK+5whDXxmVci67lp5pUgC
         DG8bPfFtkMTyedBvajPRWBnuHD640gGOVuDvgUmtgq1K6OfdqzfLsMGz3Xx8OYdb42
         JkLq1uGl/9hlhu6YplTuCxNU2JYIHdOPb6Y8IWy9gNlLZzkMN1d70G3V2BixgiUrBI
         mJDnO0JBe+6X28nima1vSRsg12t14sAKWl31U88x6hTi3Jj4VwmGAIq9nsrzShpeuW
         0RFqdGCqz3X6w==
Date:   Mon, 17 Jan 2022 09:34:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to b3bb9413e717
Message-ID: <20220117173459.GA13540@magnolia>
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

This last update for the merge window removes a bunch of ioctl
definitions for defunct and broken functionality.  I originally planned
to fast-forward this branch to avoid merge conflicts between the ALLOCSP
CVE fix and 4d1b97f9ce7c, but upstream head fails fstests spectacularly
so I gave up on that plan.

The new head of the for-next branch is commit:

b3bb9413e717 xfs: remove the XFS_IOC_{ALLOC,FREE}SP* definitions

New Commits:

Darrick J. Wong (3):
      [9dec0368b964] xfs: remove the XFS_IOC_FSSETDM definitions
      [4d1b97f9ce7c] xfs: kill the XFS_IOC_{ALLOC,FREE}SP* ioctls
      [b3bb9413e717] xfs: remove the XFS_IOC_{ALLOC,FREE}SP* definitions


Code Diffstat:

 fs/xfs/libxfs/xfs_fs.h |  37 ++++--------------
 fs/xfs/xfs_bmap_util.c |   7 ++--
 fs/xfs/xfs_bmap_util.h |   2 +-
 fs/xfs/xfs_file.c      |   3 +-
 fs/xfs/xfs_ioctl.c     | 101 +++++++------------------------------------------
 fs/xfs/xfs_ioctl.h     |   6 ---
 fs/xfs/xfs_ioctl32.c   |  27 -------------
 fs/xfs/xfs_ioctl32.h   |   4 --
 8 files changed, 27 insertions(+), 160 deletions(-)
