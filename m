Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745A5EE3F08
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbjILRk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbjILRk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 13:40:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C066210C9
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 10:40:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6354BC433C7;
        Tue, 12 Sep 2023 17:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694540423;
        bh=jwNxtdBu3A5CRWBtcVR6NnaTR0rFOh5PwW3f5WQBYxs=;
        h=Date:Subject:From:To:Cc:From;
        b=YqQ3OZXzkVaN4ThgoCRMPkvTyQtrViAUALGdQ5Kqa7xo88DvEzF1SiJUT2rbmEvaO
         PbpKEn9M6q1CHhOJyyZxtV5Y7byl/+/AwEP9Bhg93WKNF6Ylnexkjw3B/q+5fHJbOG
         zus4RZ3iwGp3dRYrrP2cVhV41LpPLl5waS4zle3EFQj35LR+hCgn2R9jzzn7Hl/eok
         xtDgIyMuNOgsjhAh9jXPM9LpUBXZ1A+VTmgdYXvzN8xUMuRd+mwSlQOdfWgWVK2O9d
         wBk+RmwiPUrAodMvvaDPD9A36e5Ift/UWVCnwmGl4hS4Qo5EUYzsUtR4VROcuXlvsP
         thp0LFk/MJn/Q==
Date:   Tue, 12 Sep 2023 10:40:22 -0700
Subject: [GIT PULL 6/8] xfs: reload entire iunlink lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Message-ID: <169454023631.3411463.9021734328148221588.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 68b957f64fca1930164bfc6d6d379acdccd547d7:

xfs: load uncached unlinked inodes into memory on demand (2023-09-12 10:31:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-iunlink-list-6.6_2023-09-12

for you to fetch changes up to 49813a21ed57895b73ec4ed3b99d4beec931496f:

xfs: make inode unlinked bucket recovery work with quotacheck (2023-09-12 10:31:07 -0700)

----------------------------------------------------------------
xfs: reload entire iunlink lists
This is the second part of correcting XFS to reload the incore unlinked
inode list from the ondisk contents.  Whereas part one tackled failures
from regular filesystem calls, this part takes on the problem of needing
to reload the entire incore unlinked inode list on account of somebody
loading an inode that's in the /middle/ of an unlinked list.  This
happens during quotacheck, bulkstat, or even opening a file by handle.

In this case we don't know the length of the list that we're reloading,
so we don't want to create a new unbounded memory load while holding
resources locked.  Instead, we'll target UNTRUSTED iget calls to reload
the entire bucket.

Note that this changes the definition of the incore unlinked inode list
slightly -- i_prev_unlinked == 0 now means "not on the incore list".

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list
xfs: reload entire unlinked bucket lists
xfs: make inode unlinked bucket recovery work with quotacheck

fs/xfs/xfs_attr_inactive.c |   1 -
fs/xfs/xfs_export.c        |   6 +++
fs/xfs/xfs_icache.c        |   2 +-
fs/xfs/xfs_inode.c         | 115 +++++++++++++++++++++++++++++++++++++++++++--
fs/xfs/xfs_inode.h         |  34 +++++++++++++-
fs/xfs/xfs_itable.c        |   9 ++++
fs/xfs/xfs_mount.h         |  10 +++-
fs/xfs/xfs_qm.c            |   7 +++
fs/xfs/xfs_trace.h         |  20 ++++++++
9 files changed, 195 insertions(+), 9 deletions(-)

