Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF53C388F9
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 17:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D60822224E
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 17:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="M56Ryfzx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgKURRL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 12:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgKURRL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Nov 2020 12:17:11 -0500
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E98E22206;
        Sat, 21 Nov 2020 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605979030;
        bh=nJQAYWui4XxNjj48jn4oURSWoTp/y2PTXbv5fs2HUY4=;
        h=Date:From:To:Cc:Subject:From;
        b=M56RyfzxhCeTzSQ8Fw9F1s7/qqQqsjRUlIDRV42qofueRbApeFHj/hvIvHFJEVLFR
         eu6IQPeUhYP1NCKrgXKMnUfUVEEWR+thyqXVxV2UZLm/j15RXDEttXmUpSIB6kdyCm
         6c0FXJpmIK3Ni9bcU5UxXT/CuWnFmC6nAwfvG9pw=
Date:   Sat, 21 Nov 2020 09:17:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Subject: [GIT PULL] xfs: fixes for 5.10-rc5
Message-ID: <20201121171710.GA7179@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch containing the last of the bug fixes for 5.10.
The critical fixes are for a crash that someone reported in the xattr
code on 32-bit arm last week; and a revert of the rmap key comparison
change from last week as it was totally wrong.  I need a vacation. :(

The branch merges cleanly with upstream as of a few minutes ago, so
please let me know if anything strange happens.

--D

The following changes since commit 2bd3fa793aaa7e98b74e3653fdcc72fa753913b5:

  xfs: fix a missing unlock on error in xfs_fs_map_blocks (2020-11-11 08:07:37 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.10-fixes-7

for you to fetch changes up to eb8409071a1d47e3593cfe077107ac46853182ab:

  xfs: revert "xfs: fix rmap key and record comparison functions" (2020-11-19 15:17:50 -0800)

----------------------------------------------------------------
Fixes for 5.10-rc5:
- Fix various deficiencies in online fsck's metadata checking code.
- Fix an integer casting bug in the xattr code on 32-bit systems.
- Fix a hang in an inode walk when the inode index is corrupt.
- Fix error codes being dropped when initializing per-AG structures
- Fix nowait directio writes that partially succeed but return EAGAIN.
- Revert last week's rmap comparison patch because it was wrong.

----------------------------------------------------------------
Darrick J. Wong (5):
      xfs: fix the minrecs logic when dealing with inode root child blocks
      xfs: strengthen rmap record flags checking
      xfs: directory scrub should check the null bestfree entries too
      xfs: ensure inobt record walks always make forward progress
      xfs: revert "xfs: fix rmap key and record comparison functions"

Dave Chinner (1):
      xfs: don't allow NOWAIT DIO across extent boundaries

Gao Xiang (1):
      xfs: fix forkoff miscalculation related to XFS_LITINO(mp)

Yu Kuai (1):
      xfs: return corresponding errcode if xfs_initialize_perag() fail

 fs/xfs/libxfs/xfs_attr_leaf.c  |  8 +++++++-
 fs/xfs/libxfs/xfs_rmap_btree.c | 16 +++++++--------
 fs/xfs/scrub/bmap.c            |  8 ++++----
 fs/xfs/scrub/btree.c           | 45 +++++++++++++++++++++++++-----------------
 fs/xfs/scrub/dir.c             | 27 ++++++++++++++++++-------
 fs/xfs/xfs_iomap.c             | 29 +++++++++++++++++++++++++++
 fs/xfs/xfs_iwalk.c             | 27 ++++++++++++++++++++++---
 fs/xfs/xfs_mount.c             | 11 ++++++++---
 8 files changed, 127 insertions(+), 44 deletions(-)
