Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E95C6FD19
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Mar 2023 16:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjCLQoO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Mar 2023 12:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjCLQoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Mar 2023 12:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413A31CAD2
        for <linux-xfs@vger.kernel.org>; Sun, 12 Mar 2023 09:44:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C873B60F58
        for <linux-xfs@vger.kernel.org>; Sun, 12 Mar 2023 16:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349B1C433EF;
        Sun, 12 Mar 2023 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678639451;
        bh=E5FAMT0emE/ma57+eJ3vsszpPhI5+1Ocbe6SJE3KX7Q=;
        h=Date:From:To:Cc:Subject:From;
        b=X/EeTBwMBvnQ7HWj7CW1EHWaUSrObocflml0cm8oAjmRqHQ7RCLLt4Fvr4KBAOvAU
         jREVZDZq8jCOzFCByRyXX5GHEvI0ldmt/SzBtsBGvxpH3nO6O0vwsu8/wkYrcg6fPa
         kxtP1nQMFAJZZRZ52O1Ybxc0zl+TWQD/U8dFPGndq9A1Wt/jOcnsm6EHN8fEypnfs3
         PmhYx9TxYbtBvakOtGZOs4echKMAm7TvbQGHDmpl3/rmpxWQiZzX5w2CW6xAQepWJt
         k/LgSUARMlkQ9VqS1cb2b7OJx9Pj/4OG7Lrf94GPI9IumIysdyq/zUaRw/EJ3GKMMS
         P2mXGulHjk/SQ==
Date:   Sun, 12 Mar 2023 09:44:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, pengfei.xu@intel.com
Subject: [GIT PULL] xfs: bug fixes for 6.3
Message-ID: <167863926526.335292.4073445070513678525.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with a couple of bug fixes.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4cc6:

Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-1

for you to fetch changes up to 8ac5b996bf5199f15b7687ceae989f8b2a410dda:

xfs: fix off-by-one-block in xfs_discard_folio() (2023-03-05 15:13:23 -0800)

----------------------------------------------------------------
Fixes for 6.3-rc1:

* Fix a crash if mount time quotacheck fails when there are inodes
queued for garbage collection.
* Fix an off by one error when discarding folios after writeback
failure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Dave Chinner (2):
xfs: quotacheck failure can race with background inode inactivation
xfs: fix off-by-one-block in xfs_discard_folio()

fs/xfs/xfs_aops.c | 21 ++++++++++++++-------
fs/xfs/xfs_qm.c   | 40 ++++++++++++++++++++++++++--------------
2 files changed, 40 insertions(+), 21 deletions(-)
