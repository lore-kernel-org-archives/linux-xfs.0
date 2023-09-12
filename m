Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B95EE3F06
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjILRjZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbjILRjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 13:39:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB4DBB
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 10:39:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C789C433C7;
        Tue, 12 Sep 2023 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694540360;
        bh=HLzt2iQiWfvqrlJgMRABZdIX30rZnfL6kgorAmCBdf0=;
        h=Date:Subject:From:To:Cc:From;
        b=IZM/VE/6asicuqdJqP4PgixFjsB/y86iJaP74/msnJEwl+B6CqH9rdh+Rxkc73dX4
         uyB0o4tJ4JwwLjJozWj2jgAgpticWbVCUbKOI/Xy/nPusHar275QXrGyn7O6CUGrrm
         Wb8y3XW7Pvihk4NJiRrj12gD4Kkg/k99asNjHF56ZhVO7fBN6eSnwTTrr+rwoDLgKD
         4y7FtZbTKR2+K/4C5884TdOaYGy8Iz4AbiPGuiFtmrlk1+jsDdtItKe0lCMyIx2nAi
         wi3P5m4nC9NRymeGwiHWYKCG6zY9fzMbMn5H0ReT9xZT0OR5QpARRNBSQcahclJUgY
         AR3iZwkluwHzg==
Date:   Tue, 12 Sep 2023 10:39:20 -0700
Subject: [GIT PULL 2/8] xfs: fix cpu hotplug mess
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, peterz@infradead.org,
        ritesh.list@gmail.com, sandeen@sandeen.net, tglx@linutronix.de
Message-ID: <169454023254.3411463.11051130775444770690.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit cfa2df68b7ceb49ac9eb2d295ab0c5974dbf17e7:

xfs: fix an agbno overflow in __xfs_getfsmap_datadev (2023-09-11 08:39:02 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-percpu-lists-6.6_2023-09-12

for you to fetch changes up to ef7d9593390a050c50eba5fc02d2cb65a1104434:

xfs: remove CPU hotplug infrastructure (2023-09-11 08:39:04 -0700)

----------------------------------------------------------------
xfs: fix cpu hotplug mess [v2]

Ritesh and Eric separately reported crashes in XFS's hook function for
CPU hot remove if the remove event races with a filesystem being
mounted.  I also noticed via generic/650 that once in a while the log
will shut down over an apparent overrun of a transaction reservation;
this turned out to be due to CIL percpu list aggregation failing to pick
up the percpu list items from a dying CPU.

Either way, the solution here is to eliminate the need for a CPU dying
hook by using a private cpumask to track which CPUs have added to their
percpu lists directly, and iterating with that mask.  This fixes the log
problems and (I think) solves a theoretical UAF bug in the inodegc code
too.

v2: fix a few put_cpu uses, add necessary memory barriers, and use
atomic cpumask operations

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: fix per-cpu CIL structure aggregation racing with dying cpus
xfs: use per-mount cpumask to track nonempty percpu inodegc lists
xfs: remove the all-mounts list
xfs: remove CPU hotplug infrastructure

fs/xfs/xfs_icache.c        | 78 +++++++++++++++--------------------------
fs/xfs/xfs_icache.h        |  1 -
fs/xfs/xfs_log_cil.c       | 52 +++++++++-------------------
fs/xfs/xfs_log_priv.h      | 14 ++++----
fs/xfs/xfs_mount.h         |  7 ++--
fs/xfs/xfs_super.c         | 86 ++--------------------------------------------
include/linux/cpuhotplug.h |  1 -
7 files changed, 56 insertions(+), 183 deletions(-)

