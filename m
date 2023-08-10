Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3CDC001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Aug 2023 15:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbjHJP3M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbjHJP3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2023 11:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB3B2690
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 08:29:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 984616601E
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 15:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F8DC433C7;
        Thu, 10 Aug 2023 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691681350;
        bh=RM7DYWB1X7RKD/SxhA75Hp8Xznz/ISjBbFFUBPYOsHQ=;
        h=Date:From:To:Cc:Subject:From;
        b=TIT9Ql4kSZ37zxs7mSdXdF6XigUnplHI55b5pKvwBE4KROGsBW7rPpspsd0RzGJqd
         +UzAL9DDaA6lThSyHFJ94Z/7ew9m+uI1PWDB/gZKqBKktfVUIfUECLIXwzCm4rNsFz
         WVpsfC5vYjPZMQzGyjP8Eo++FzwJb5XXUpfKi4ym3G78SXrUJyivtdlzwkbhkn2wHk
         K2AgcPK3iFDjcW4aDZQSaphbnD0o1ZphFLJIOdyE7hc+ztLHaX8u1Nk69fz+shfoJA
         A3lcMv8bj4yq6FQaQsdauRDSP3MHWgsmD8YfK+E+r1kGSc+l9zGSkkz24MLy14ys83
         v3oSgN0WCSiJQ==
Date:   Thu, 10 Aug 2023 08:29:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@oracle.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 5/9] xfs: online scrubbing of realtime summary files
Message-ID: <169168056897.1060601.15193128453632731882.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit d7a74cad8f45133935c59ed0adf949f85238624b:

xfs: track usage statistics of online fsck (2023-08-10 07:48:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-rtsummary-6.6_2023-08-10

for you to fetch changes up to 526aab5f5790e257cbdff1d1be89353257a3e451:

xfs: implement online scrubbing of rtsummary info (2023-08-10 07:48:09 -0700)

----------------------------------------------------------------
xfs: online scrubbing of realtime summary files [v26.1]

This patchset implements an online checker for the realtime summary
file.  The first few changes are some general cleanups -- scrub should
get its own references to all inodes, and we also wrap the inode lock
functions so that we can standardize unlocking and releasing inodes that
are the focus of a scrub.

With that out of the way, we move on to constructing a shadow copy of
the rtsummary information from the rtbitmap, and compare the new copy
against the ondisk copy.

This has been running on the djcloud for years with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: get our own reference to inodes that we want to scrub
xfs: wrap ilock/iunlock operations on sc->ip
xfs: move the realtime summary file scrubber to a separate source file
xfs: implement online scrubbing of rtsummary info

fs/xfs/Makefile          |   7 +-
fs/xfs/scrub/bmap.c      |   9 +-
fs/xfs/scrub/common.c    |  63 +++++++++--
fs/xfs/scrub/common.h    |  24 ++++-
fs/xfs/scrub/inode.c     |  11 +-
fs/xfs/scrub/parent.c    |   4 +-
fs/xfs/scrub/quota.c     |  15 +--
fs/xfs/scrub/rtbitmap.c  |  48 ++-------
fs/xfs/scrub/rtsummary.c | 264 +++++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/scrub.c     |  17 +--
fs/xfs/scrub/scrub.h     |   4 +
fs/xfs/scrub/trace.h     |  34 ++++++
fs/xfs/xfs_trace.h       |   3 +
13 files changed, 421 insertions(+), 82 deletions(-)
create mode 100644 fs/xfs/scrub/rtsummary.c
