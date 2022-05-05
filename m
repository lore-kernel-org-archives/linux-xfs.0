Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E565C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381740AbiEEQMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381831AbiEEQMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:12:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BF45C678
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91949B82DF5
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A1CC385A8;
        Thu,  5 May 2022 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766899;
        bh=OeQXt5VYRoU5aDBIj6hGg4laB2u0+fBagmUp0QTlku8=;
        h=Subject:From:To:Cc:Date:From;
        b=dFuxmSrbn7zVNgZhapBUQhVbDu+0wYdSElazLh4Ga2kKWabrh7vswXkjgTMJb75ev
         IXBRupZqa0AXzgRDSHI4prnvRbih9a+2XSKh7W+bsr515rzqekhduEE6LZgoU6TMOV
         ZNM6u/TErWYf9rPkJS/u0v6rsMxbVn84vznos04GNcd7pjHlqylTL+mQJynlcoO3Mb
         TIH35NdhjSkg1eYBsdO26IL+aUIPneB4FzMiIQf2wx48tnMB0/8bL9iRCLvTUnLpEu
         kCfSj43oZcyl/R393vZXuqkaPpejSJ+9BWAuEfjfzVkVhJFCxx3BoOflzP4WlqON58
         EkQAxlq0kU0tg==
Subject: [PATCHSET 0/4] xfs_scrub: improve balancing of threads for inode scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:08:18 -0700
Message-ID: <165176689880.252326.13947902143386455815.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Dave Chinner introduced a patch to the userspace workqueues that allows
for controlling the maximum queue depth as part of phase6 cleanups for
xfs_repair.  This enables us to fix a problem in xfs_scrub wherein we
fail to parallelize inode scans to the maximum extent possible if a
filesystem's inode usage isn't evenly balanced across AGs.

Resolve this problem by using two workqueues for the inode scan -- one
that calls INUMBERS to find all the inobt records for the filesystem and
creates separate work items for each record; and a second workqueue to
turn the inobt records into BULKSTAT calls to do the actual scanning.
We use the queue depth control to avoid excessive queuing of inode
chunks.  This creates more threads to manage, but it means that we avoid
the problem of one AG's inode scan continuing on long after the other
threads ran out of work.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-iscan-rebalance
---
 scrub/inodes.c |  343 ++++++++++++++++++++++++++++++++++++++++++--------------
 scrub/phase3.c |   44 ++++++-
 scrub/phase4.c |    6 -
 scrub/repair.c |    2 
 scrub/repair.h |    4 -
 5 files changed, 300 insertions(+), 99 deletions(-)

