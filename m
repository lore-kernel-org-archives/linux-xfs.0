Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D4BCE79A8
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Sep 2023 16:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjISQBw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 12:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbjISQBw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2023 12:01:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D259D
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2023 09:01:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CD1C433C7;
        Tue, 19 Sep 2023 16:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695139303;
        bh=lJ8vzFedu7xxilnWh2tDQas8ooJ3CKgzvunZq35RQYE=;
        h=Date:From:To:Cc:Subject:From;
        b=ZkWwkYod5El/OeqS/vgMuGwPcxoZeAkLxjcgrgvevZlsDCag5HzaUXsEiww8QloG7
         KtU4CXCFsSh5TV4ct/nN3qzHF5rRHwfKzi+k6KQciIdNp8PKtY6ZZ7RZcfhFUPl+AL
         IH+7ow/Yze1bVkkONJPz2IHEmAbUfWXJQFpDYZsn4JnlHQJl6cHLbND9+5b6LJp7+R
         XCWvXrZ2eoP3LxwbSEO+dx1zntB3zhyy84KCuH+SgzP8gUBIXSey+cH8lN911WjCv7
         96qXXyGaNExaeGhQvm7/JxTVhGT7kSxFb6AbdzZsvrf3MWCjCHeJAM4KujiK4De+6b
         Wvk7NsncF/e/w==
Date:   Tue, 19 Sep 2023 09:01:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, peterz@infradead.org,
        ritesh.list@gmail.com, sandeen@sandeen.net, tglx@linutronix.de
Subject: [GIT PULL] xfs: fix ro mounting with unknown rocompat features
Message-ID: <169513911841.1384408.4221257193552110896.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.6-rc2.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0bb80ecc33a8fb5a682236443c1e740d5c917d1d:

Linux 6.6-rc1 (2023-09-10 16:28:41 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-ro-mounts-6.6_2023-09-19

for you to fetch changes up to b848f5934d43fee6ed185853784d7dc0f13b7324:

xfs: fix log recovery when unknown rocompat bits are set (2023-09-12 10:31:07 -0700)

Yep, re-doing the pull request because I didn't fill out the form
correctly, my homebrew checkpatch script didn't catch this one quirk,
and the community checkpatch script is so noisy I don't use it, which
I'm sure is inviting flames from all the armchair xfs maintainers out
there.
----------------------------------------------------------------
xfs: fix ro mounting with unknown rocompat features [v2]

Dave pointed out some failures in xfs/270 when he upgraded Debian
unstable and util-linux started using the new mount apis.  Upon further
inquiry I noticed that XFS is quite a hot mess when it encounters a
filesystem with unrecognized rocompat bits set in the superblock.

Whereas we used to allow readonly mounts under these conditions, a
change to the sb write verifier several years ago resulted in the
filesystem going down immediately because the post-mount log cleaning
writes the superblock, which trips the sb write verifier on the
unrecognized rocompat bit.  I made the observation that the ROCOMPAT
features RMAPBT and REFLINK both protect new log intent item types,
which means that we actually cannot support recovering the log if we
don't recognize all the rocompat bits.

Therefore -- fix inode inactivation to work when we're recovering the
log, disallow recovery when there's unrecognized rocompat bits, and
don't clean the log if doing so would trip the rocompat checks.

v2: change direction of series to allow log recovery on ro mounts

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
xfs: fix an agbno overflow in __xfs_getfsmap_datadev
xfs: fix per-cpu CIL structure aggregation racing with dying cpus
xfs: use per-mount cpumask to track nonempty percpu inodegc lists
xfs: remove the all-mounts list
xfs: remove CPU hotplug infrastructure
xfs: allow inode inactivation during a ro mount log recovery
xfs: fix log recovery when unknown rocompat bits are set

fs/xfs/libxfs/xfs_sb.c     |  3 +-
fs/xfs/xfs_fsmap.c         | 25 ++++++++++----
fs/xfs/xfs_icache.c        | 78 +++++++++++++++--------------------------
fs/xfs/xfs_icache.h        |  1 -
fs/xfs/xfs_inode.c         | 14 +++++---
fs/xfs/xfs_log.c           | 17 ---------
fs/xfs/xfs_log_cil.c       | 52 +++++++++-------------------
fs/xfs/xfs_log_priv.h      | 14 ++++----
fs/xfs/xfs_mount.h         |  7 ++--
fs/xfs/xfs_super.c         | 86 ++--------------------------------------------
include/linux/cpuhotplug.h |  1 -
11 files changed, 86 insertions(+), 212 deletions(-)
