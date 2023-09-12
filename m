Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52D0EE3F09
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjILRjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjILRjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 13:39:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542B1B7
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 10:39:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D83C433C7;
        Tue, 12 Sep 2023 17:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694540345;
        bh=DUNFrJVRPzuuY3hSpg61VBwvN6w9LeyzVteAnkjpJRI=;
        h=Date:Subject:From:To:Cc:From;
        b=Zx+tus4QnGPyA19xtJoW7XyVLlZRIbBwz+zsVdquDSPmk04VgKr2fyq6zpI2dIsI7
         v6jJDpkRx8sHCl2wa1WmXaTCtKQewJcH1q9e2ccJHBqZZPcay1UIgetVm8Pd72tQbz
         m0NuJlIC/dJAKqmtYF5hgG+k51WFlPxhlJJvx/gEu2Q+wtXqKGVsvwdleM+3J5ib3G
         ROKX7wPxmfvJV3gXEpZtpcgt/EBu9sO3fZ4KfejZnuyZEkztklm2nVuAwFb3vOqlvA
         INNbMx7WR7/cfAYsPhn3RjnovJOFznMtsE3WyrpUbuh9DG+7uc5tTi/XmpMa468kxl
         kKBYJw+7wJh9A==
Date:   Tue, 12 Sep 2023 10:39:04 -0700
Subject: [GIT PULL 1/8] xfs: fix fsmap cursor handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <169454023162.3411463.108211223548743239.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 0bb80ecc33a8fb5a682236443c1e740d5c917d1d:

Linux 6.6-rc1 (2023-09-10 16:28:41 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-fsmap-6.6_2023-09-12

for you to fetch changes up to cfa2df68b7ceb49ac9eb2d295ab0c5974dbf17e7:

xfs: fix an agbno overflow in __xfs_getfsmap_datadev (2023-09-11 08:39:02 -0700)

----------------------------------------------------------------
xfs: fix fsmap cursor handling [v2]

This patchset addresses an integer overflow bug that Dave Chinner found
in how fsmap handles figuring out where in the record set we left off
when userspace calls back after the first call filled up all the
designated record space.

v2: add RVB tags

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: fix an agbno overflow in __xfs_getfsmap_datadev

fs/xfs/xfs_fsmap.c | 25 ++++++++++++++++++-------
1 file changed, 18 insertions(+), 7 deletions(-)

