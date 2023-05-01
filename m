Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C9AC77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 18:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjEAS1W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 14:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjEAS1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 14:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C209312F
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 11:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BD6E61E7B
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 18:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C56C433D2;
        Mon,  1 May 2023 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682965639;
        bh=av1nxLLjDt0z5gPSvqkukFs3vLgqPiMYcTrcfoaa8LI=;
        h=Subject:From:To:Cc:Date:From;
        b=e22z6cPKX7HnM1NYR+3LK+STrijqTREyjPU+lk7hvmX9Q011jOGzxT9rj2aVEDCKl
         grIgBRkUvwjsbz+BhoGk1zXJkx/YuU7ej37WKJsQ0qI/uoyDeAJ/RZVmP+skn8ewFW
         7Joi+/BYKtNjesmad04D8bjQB8HhY4lLJyMAvJFD6w/vUfDyVxbObmH+OUdvbsB4sw
         4M1hflYXFOwzuBkN0JJPVJYspgEZ/lMJNTsB5mVrYlqkB5PT2KjCJs8LImAkFCarbc
         W9tgcpEkXygOg4oQTSM5/lcH5j3OqcrtJVROVX5lSnB+HkKPhy8Aq0PYlrBaJcl40C
         V+JsTjlAi250g==
Subject: [PATCHSET v2 0/4] xfs: inodegc fixes for 6.4-rc1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 01 May 2023 11:27:19 -0700
Message-ID: <168296563922.290156.2222659364666118889.stgit@frogsfrogsfrogs>
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

v2: document the new locking requirements of xfs_inodegc_{start,stop}
    and why we cannot use drain_workqueue

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
 fs/xfs/scrub/fscounters.c |   13 ++++++-------
 fs/xfs/scrub/scrub.c      |    2 --
 fs/xfs/scrub/scrub.h      |    1 -
 fs/xfs/scrub/trace.h      |    1 -
 fs/xfs/xfs_icache.c       |   40 +++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_mount.h        |    3 +++
 fs/xfs/xfs_super.c        |    3 +++
 9 files changed, 45 insertions(+), 46 deletions(-)

