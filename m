Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B556EE3F08
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbjILRjl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbjILRjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 13:39:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED71196
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 10:39:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC47C433C8;
        Tue, 12 Sep 2023 17:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694540376;
        bh=Q7bNXPA4Uv5g3GpKZYcBGKhjdoUXd8QM0dm2NyrXeeM=;
        h=Date:Subject:From:To:Cc:From;
        b=Qu36Vk+C81LveywuRAEIfs2n6Og7j2SsgyoTqlbB8apxJNG1LR2bPgzr1G5vTdfZB
         K7gLnkHg9lv/xsAPtrxsDuLCZdv77UuBkM4ZdGuAUS0pMVqjk2ZxZ2ynZ0nJMeSACY
         WUFpj2pPVQtKLi9TNbHgwHUncAWNnPE5vrE2rLFPWu1CqygBuEmndWhoiHCKJzySmT
         fHqtpL9V/zZTo2qrYXPvd+lofIZNnK6DVzZTyo359D4Z8LWxQja7ERwgDeEHgtEdSB
         LTj2EycwRhSyZlke33FM0cDQXc6xPPTJfz5R8v6rfqSq0pAswzJonB+objKbBABJ4p
         HtRnTdjiLhbwg==
Date:   Tue, 12 Sep 2023 10:39:35 -0700
Subject: [GIT PULL 3/8] xfs: fix ro mounting with unknown rocompat features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, sandeen@sandeen.net
Message-ID: <169454023347.3411463.3256623887249978768.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ef7d9593390a050c50eba5fc02d2cb65a1104434:

xfs: remove CPU hotplug infrastructure (2023-09-11 08:39:04 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-ro-mounts-6.6_2023-09-12

for you to fetch changes up to 74ad4693b6473950e971b3dc525b5ee7570e05d0:

xfs: fix log recovery when unknown rocompat bits are set (2023-09-12 10:31:07 -0700)

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
Darrick J. Wong (2):
xfs: allow inode inactivation during a ro mount log recovery
xfs: fix log recovery when unknown rocompat bits are set

fs/xfs/libxfs/xfs_sb.c |  3 ++-
fs/xfs/xfs_inode.c     | 14 ++++++++++----
fs/xfs/xfs_log.c       | 17 -----------------
3 files changed, 12 insertions(+), 22 deletions(-)

