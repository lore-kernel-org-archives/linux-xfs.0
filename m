Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7FCC77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344335AbjD0WtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344332AbjD0WtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:49:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D5E2129
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74CA56403A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D079EC433EF;
        Thu, 27 Apr 2023 22:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635760;
        bh=VGOJirW+0lzY+Sw9Gtdg0TEL9ev4DqMtblHIzB54ZZo=;
        h=Subject:From:To:Cc:Date:From;
        b=k5SEkdjWh0VCErZQbOXym0AeRpIZ9NxfXE0LJziL8uZ9Y8jyghsHC2H/JUwn+a0AC
         Pr77iy4KvGyFYS54kh2qcr6FyE5vFqhDGGGEmhpDhuNJxHbKWneyMX8a51wT6Ph70s
         KBwgfEdAtRA+h87yGkBbG0tFTMGfuv/0yscEGQx7tWOnFsuBvPlODyuxZP5Uag2xhS
         8vhPCrxXi8jhEapFmb7EQmEDBGP7Oc3+QjuR2zhZc1yX/whwVRt5yDxC8bBUY9BkUE
         8dh6Sn86oCgA9ZfC3FFG0wLfEknbq4gyGll5Uwg6beRf6iQN7Bt2yR14BSAR8WRFsz
         b5uny7PQ5ojyA==
Subject: [PATCHSET 0/4] xfs: inodegc fixes for 6.4-rc1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Apr 2023 15:49:20 -0700
Message-ID: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes some assorted bugs in the inodegc code that have been
lurking for a while.

The first is that inodes that are ready to be inactivated are put on
per-cpu lockless lists and a per-cpu worker is scheduled to clear that
list eventually.  Unfortunately, WORK_CPU_UNBOUND doesn't guarantee that
a worker will actually be scheduled on that CPU, so we need to force
this by specifying the CPU explicitly.

The second problem is that that xfs_inodegc_stop races with other
threads that are trying to add inodes to the percpu list and schedule
the inodegc workers.  The solution here is to drain the inodegc lists
by scheduling workers immediately, flushing the workqueue, and
scheduling if any new inodes have appeared.

We also disable the broken fscounters usage of inodegc_stop by neutering
the whole scrubber for now because the proper fixes for it are in the
next batch of online repair patches for 6.5, and the code is still
marked experimental.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inodegc-fixes-6.4
---
 fs/xfs/scrub/common.c     |   26 --------------------------
 fs/xfs/scrub/common.h     |    2 --
 fs/xfs/scrub/fscounters.c |   10 +++-------
 fs/xfs/scrub/scrub.c      |    2 --
 fs/xfs/scrub/scrub.h      |    1 -
 fs/xfs/scrub/trace.h      |    1 -
 fs/xfs/xfs_icache.c       |   38 +++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_mount.h        |    3 +++
 fs/xfs/xfs_super.c        |    3 +++
 9 files changed, 40 insertions(+), 46 deletions(-)

