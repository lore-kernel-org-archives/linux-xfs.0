Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110F2C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Apr 2022 18:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbiDJSXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 14:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiDJSXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 14:23:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07A622531
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 11:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FFD5B80E51
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E4FC385A4;
        Sun, 10 Apr 2022 18:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649614855;
        bh=8BxyWQf816ppuoR9JOcyLNAtcpzChRCT+Kd1O6fE7S0=;
        h=Subject:From:To:Cc:Date:From;
        b=PhSu6VWDCFJNp6jFHBQwkABW7gvc2GWg0Mnfvvvvdn5XDGDlUKn3eOowTaG2WwVIU
         tv1Fizk7dFQkyImFV4TTiOn9PhUO3GinGGNromP0EXx+wzhR4LRaSE+/t6K4evZ4vR
         iR4ee/FCGsZG/s5JWapZ1P35QI7iEAJ4q/kXY0vU7TKIFsH4p16Ep7OMzowwEfIAkU
         vwVIgXk3tPovaQd/YMb/yakO0blirOTFTlAxjkbQH7C7j83s6MTCSvlrp5bf8jqN0M
         xD52OJ5ctPhS3nrDxhZgUkFdwnnHCPY2SsLkFGzy5mdhpO2s9mhhhCd5cxUCxd/pC0
         WZ1DRpjP/ZgUQ==
Subject: [PATCHSET v2 0/3] xfs: fix corruption of free rt extent count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 10 Apr 2022 11:20:54 -0700
Message-ID: <164961485474.70555.18228016043917319266.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've been noticing sporadic failures with djwong-dev with xfs/141, which
is a looping log recovery test.  The primary symptoms have been that
online fsck reports incorrect free extent counts after some number of
recovery loops.  The root cause seems to be the use of sb_frextents in
the xfs_mount for incore reservations to transactions -- if someone
calls xfs_log_sb while there's a transaction with an rtx reservation
running, the artificially low value will then get logged to disk!
If that's the /last/ time anyone logs the superblock before the log
goes down, then recovery will replay the incorrect value into the live
superblock.  Effectively, we leak the rt extents.

So, the first thing to do is to fix log recovery to recompute frextents
from the rt bitmap so that we can catch and correct ondisk metadata; and
the second fix is to create a percpu counter to track both ondisk and
incore rtextent counts, similar to how m_fdblocks relates to
sb_fdblocks.

The next thing to do after this is to fix xfs_repair to check frextents
and the rt bitmap/summary files, since it doesn't check the ondisk
values against its own observations.

v2: better comments, move the frextents recalc to the summary counter
    recalc function, dont require empty transactions to check rtbitmap

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=frextents-fixes-5.18
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++--
 fs/xfs/libxfs/xfs_sb.c       |    5 ++
 fs/xfs/scrub/rtbitmap.c      |    9 ++--
 fs/xfs/xfs_fsmap.c           |    6 +--
 fs/xfs/xfs_fsops.c           |    5 --
 fs/xfs/xfs_icache.c          |    9 +++-
 fs/xfs/xfs_mount.c           |   91 ++++++++++++++++++++++++------------------
 fs/xfs/xfs_mount.h           |   19 +++++++--
 fs/xfs/xfs_rtalloc.c         |   38 ++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |    9 +++-
 fs/xfs/xfs_super.c           |   14 ++++++
 fs/xfs/xfs_trans.c           |   43 +++++++++++++++++---
 12 files changed, 187 insertions(+), 70 deletions(-)

