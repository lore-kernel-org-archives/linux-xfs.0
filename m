Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DC2EE3F0A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbjILRj4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbjILRj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 13:39:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800F910D3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 10:39:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EA5C433CB;
        Tue, 12 Sep 2023 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694540392;
        bh=Gw1H5Zgp7y36Ew8Agq1DGWE87jEI7xTAxjv+aInnhBA=;
        h=Date:Subject:From:To:Cc:From;
        b=B/C2eamw0BXiRqN3Hyis0nBit5piHnArMnc+3+CcL8SHQsq3culTCkyWy9NyKx/nj
         uYqGfmKjrPXzAx2WloYkLgRwKz2i/zWX82vixb+mEmK70qi2YwGjm1382Xz9RnxrvD
         nWwyanfKgnG6fv5v9YgZ78iU1ynxEWZGuj9edC8RZALptvRP3TlU9C3HDz9/aLtlvQ
         cErUIXkLSYq6DHbmKJk8+EYt4hkRWhxPZQBjz5oqQ1vERZ7nMZVuqjqY/U3s2mcI9P
         iOX0qOJXN2mDdE9bBeWrIOq9ifT2V2ppwYHlcnqHYBV5jN5+ZtXmNSQQa9iGjRK2CA
         RdL/h8GSGJxKg==
Date:   Tue, 12 Sep 2023 10:39:51 -0700
Subject: [GIT PULL 4/8] xfs: fix EFI recovery livelocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, srikanth.c.s@oracle.com,
        wen.gang.wang@oracle.com
Message-ID: <169454023440.3411463.13931736328799093212.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 74ad4693b6473950e971b3dc525b5ee7570e05d0:

xfs: fix log recovery when unknown rocompat bits are set (2023-09-12 10:31:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-efi-recovery-6.6_2023-09-12

for you to fetch changes up to 3c919b0910906cc69d76dea214776f0eac73358b:

xfs: reserve less log space when recovering log intent items (2023-09-12 10:31:07 -0700)

----------------------------------------------------------------
xfs: fix EFI recovery livelocks
This series fixes a customer-reported transaction reservation bug
introduced ten years ago that could result in livelocks during log
recovery.  Log intent item recovery single-steps each step of a deferred
op chain, which means that each step only needs to allocate one
transaction's worth of space in the log, not an entire chain all at
once.  This single-stepping is critical to unpinning the log tail since
there's nobody else to do it for us.

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: reserve less log space when recovering log intent items

fs/xfs/libxfs/xfs_log_recover.h | 22 ++++++++++++++++++++++
fs/xfs/xfs_attr_item.c          |  7 ++++---
fs/xfs/xfs_bmap_item.c          |  4 +++-
fs/xfs/xfs_extfree_item.c       |  4 +++-
fs/xfs/xfs_refcount_item.c      |  6 ++++--
fs/xfs/xfs_rmap_item.c          |  6 ++++--
6 files changed, 40 insertions(+), 9 deletions(-)

