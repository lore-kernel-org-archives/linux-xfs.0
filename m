Return-Path: <SRS0=FK3z=6C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE65C3A5A9
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 15:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BFC3221F7
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587225424;
	bh=qnaUVc2zsWkVcp1KLOefI6hj6+RgCOt+niTNOLuKms4=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=LN541cXOOQsprcxAc0ln/DSLL5M2osP0sQyqFT6VrhjtyToeN/oeWEatANDfAOax1
	 92TrXy+32qYW/ibbWr7/ef8x+z2Xugc5/4QoW/nEGNtrsb/XkHFiB3y8Kw3C2+J1ut
	 akGcv+TGKCkwVs9Ytog1a5grsQG0rugj9nT2xTi0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgDRP5E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Apr 2020 11:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgDRP5D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 18 Apr 2020 11:57:03 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54A9721D93;
        Sat, 18 Apr 2020 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587225423;
        bh=qnaUVc2zsWkVcp1KLOefI6hj6+RgCOt+niTNOLuKms4=;
        h=Date:From:To:Cc:Subject:From;
        b=A4drJTgdp0oQMDN/su+zWGOFfavn9RmwiacCu1+2pfPUyrLit353tGM1Q5iKQd8/Z
         xR4ogBaqUPQdgZLqz3N+ng3YLui2AoxAAMRi2SRbAN9f3RgLlpc6jbwukGadw/iYBP
         8mGUuOA34rV+dRSJf6AgDwu/bS+H2h/BnwAc+mM0=
Date:   Sat, 18 Apr 2020 08:57:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Subject: [GIT PULL] xfs: bug fixes for 5.7-rc1
Message-ID: <20200418155702.GV6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this handful of fixes for 5.7.  The three commits here fix
some livelocks and other clashes with fsfreeze, a potential corruption
problem, and a minor race between processes freeing and allocating space
when the filesystem is near ENOSPC.

This branch merges cleanly with master as of a few minutes ago, so
please let me know if anything strange happens.

--D

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.7-fixes-3

for you to fetch changes up to f0f7a674d4df1510d8ca050a669e1420cf7d7fab:

  xfs: move inode flush to the sync workqueue (2020-04-16 09:07:42 -0700)

----------------------------------------------------------------
Fixes for 5.7:
- Fix a partially uninitialized variable.
- Teach the background gc threads to apply for fsfreeze protection.
- Fix some scaling problems when multiple threads try to flush the
  filesystem when we're about to hit ENOSPC.

----------------------------------------------------------------
Brian Foster (1):
      xfs: acquire superblock freeze protection on eofblocks scans

Darrick J. Wong (2):
      xfs: fix partially uninitialized structure in xfs_reflink_remap_extent
      xfs: move inode flush to the sync workqueue

 fs/xfs/xfs_icache.c  | 10 ++++++++++
 fs/xfs/xfs_ioctl.c   |  5 ++++-
 fs/xfs/xfs_mount.h   |  6 +++++-
 fs/xfs/xfs_reflink.c |  1 +
 fs/xfs/xfs_super.c   | 40 ++++++++++++++++++++++------------------
 5 files changed, 42 insertions(+), 20 deletions(-)
