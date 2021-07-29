Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2420CC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 16:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0176960EFD
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 16:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhG2QnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 12:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhG2QnG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 12:43:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A97A160EBD
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jul 2021 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627576982;
        bh=qWwAl8M2qZ3C7tQARk7aeE48i2xAFgr8S9FSsggHq+w=;
        h=Date:From:To:Subject:From;
        b=FkHKA2xGN0iO40UsUjzvhRR5aKiualko3XX9ZTdem2KkiTfh5lLZidBkoI2fXVd4o
         F7Xi6sKHclW7dKTUp7ppz4GDsOHcjjUZO8tHNq8FGpqG0lNPl+UGzz7UoeyQNEfU4L
         EQ5mMok3hn/rzUT7Gc55Rub+/cdJx2zjCR5f7HzhD7cNFC2vAsHFi64PLFtFeOz9dG
         SoKF8t7IMkEuXMagmUe0dGJxc8prQR9QvhZEzhX3gOwRhAgIZtI36dVbMXhIqNFKD+
         g0tL762bO0eosO5HvR4ImbOpJxGtrmsM2L5ikajse1LHJs13bHvx5fcd4z0oXGUEGs
         VrXl5lIQ3ylJA==
Date:   Thu, 29 Jul 2021 09:43:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 81a448d7b066
Message-ID: <20210729164302.GL3601443@magnolia>
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
the next update.  These are the second batch of bug fixes for 5.14; they
should clear up most of the log recovery problems that have been
reported lately.

The new head of the for-next branch is commit:

81a448d7b066 xfs: prevent spoofing of rtbitmap blocks when recovering buffers

New Commits:

Darrick J. Wong (1):
      [81a448d7b066] xfs: prevent spoofing of rtbitmap blocks when recovering buffers

Dave Chinner (11):
      [b1e27239b916] xfs: flush data dev on external log write
      [b5d721eaae47] xfs: external logs need to flush data device
      [9d3920644081] xfs: fold __xlog_state_release_iclog into xlog_state_release_iclog
      [0dc8f7f139f0] xfs: fix ordering violation between cache flushes and tail updates
      [45eddb414047] xfs: factor out forced iclog flushes
      [2bf1ec0ff067] xfs: log forces imply data device cache flushes
      [8191d8222c51] xfs: avoid unnecessary waits in xfs_log_force_lsn()
      [32baa63d82ee] xfs: logging the on disk inode LSN can make it go backwards
      [d8f4c2d0398f] xfs: Enforce attr3 buffer recovery order
      [b2ae3a9ef911] xfs: need to see iclog flags in tracing
      [9d110014205c] xfs: limit iclog tail updates


Code Diffstat:

 fs/xfs/libxfs/xfs_log_format.h  |  11 +-
 fs/xfs/xfs_buf_item_recover.c   |  15 ++-
 fs/xfs/xfs_inode_item_recover.c |  39 +++++--
 fs/xfs/xfs_log.c                | 251 ++++++++++++++++++++++++++--------------
 fs/xfs/xfs_log_cil.c            |  13 ++-
 fs/xfs/xfs_log_priv.h           |  16 ++-
 fs/xfs/xfs_trace.h              |   5 +-
 7 files changed, 244 insertions(+), 106 deletions(-)
