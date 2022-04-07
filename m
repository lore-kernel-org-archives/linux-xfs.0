Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26420C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 20:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiDGUw6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 16:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiDGUwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 16:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F10F29
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 13:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5346A61F53
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 20:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E2AC385A8;
        Thu,  7 Apr 2022 20:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649364411;
        bh=6M5foRp3TkTPBtFztpOxEkDH2D8yuBrbXEdXsnXBQ2k=;
        h=Subject:From:To:Cc:Date:From;
        b=QlFY8qgeoTgoKlo/iWdTYLGXFO0t2ztCO63fgLqTckQcfguuYQ7oThdW+ozAMtjBB
         B0/CiWHRpIDmcQtl57AiynEXiKZKWgK0EVKID8zgT8Jbo7a/r85eRg+Nu3sJ1XHKa+
         S0EMEOX5NtH/CjUWHDCyHPYU8bsNEfqDFP230MOAsEeZ7bXBsh+Rbph9h0Vtn9Pvdo
         FMyornDmLaFXgaf3qpPSpR8S4Yel83qIp501CZMxT3vHYncJVV6HNx0R465+pWVxFd
         7nF6lYw9noMFL6/IZfNRR1yQDZ3omj1s5LnC/AmzRaPFbzoE9Gi6wVN9sT4cMOquZN
         X2B7dwyznYYjA==
Subject: [PATCHSET 0/2] xfs: fix corruption of free rt extent count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 07 Apr 2022 13:46:51 -0700
Message-ID: <164936441107.457511.6646449842358518774.stgit@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=frextents-fixes-5.18
---
 fs/xfs/xfs_fsops.c   |    5 +---
 fs/xfs/xfs_icache.c  |    9 ++++---
 fs/xfs/xfs_mount.c   |   38 +++++++++++++++++++++-------
 fs/xfs/xfs_mount.h   |    2 +
 fs/xfs/xfs_rtalloc.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_super.c   |   14 +++++++++-
 fs/xfs/xfs_trans.c   |   37 ++++++++++++++++++++++-----
 7 files changed, 146 insertions(+), 28 deletions(-)

