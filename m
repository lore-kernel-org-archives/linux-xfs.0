Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8E0C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 18:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8734664E87
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 18:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhCNS2g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Mar 2021 14:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhCNS2G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 14 Mar 2021 14:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BACF64E99
        for <linux-xfs@vger.kernel.org>; Sun, 14 Mar 2021 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615746486;
        bh=vawQ9vzZfM25o2J2EPLolKkkbN5RYk3Uc0yenZNDh1I=;
        h=Date:From:To:Subject:From;
        b=uIwNcxzZo/L/k5JkiRTUA2NSuEKIl3VAQO5GcjDvm8xMs0JYuv3rr6Izp9dsL9AdG
         YoSoCdZMl2P74qR45d3jeMsVTNix5z86xapvhsFRYiwxgp1brpoRt19MErkGoIJ4AC
         Wiej4/feRVlNsQwrqyXQQYVpTRzWfeIG2jzWwk1olLsJlZoDzOwBh+OdWzFM+u6y3S
         O0xspWZva5LYALHNWI2yKyOAC7qzmAYmqEQzBhFvnjz3xJP+AKsOqr4Y4sT37boq3W
         8azWYndJNt1G8GMe1wlCJA3KZHLWVce+GRJXAF1fzuLX3qHAFkBTELEcr2FDrol8Nk
         Xda0Kd6W3NNQA==
Date:   Sun, 14 Mar 2021 11:28:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to b9daa0ea3bf7
Message-ID: <20210314182805.GB22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

b9daa0ea3bf7 xfs: also reject BULKSTAT_SINGLE in a mount user namespace

New Commits:

Bhaskar Chowdhury (1):
      [96fd0303027c] docs: ABI: Fix the spelling oustanding to outstanding in the file sysfs-fs-xfs

Christoph Hellwig (1):
      [b9daa0ea3bf7] xfs: also reject BULKSTAT_SINGLE in a mount user namespace

Darrick J. Wong (3):
      [b5a08423da9d] xfs: fix quota accounting when a mount is idmapped
      [45b5d1dba70e] xfs: avoid buffer deadlocks when walking fs inodes
      [e8efa3a8244e] xfs: force log and push AIL to clear pinned inodes when aborting mount


Code Diffstat:

 Documentation/ABI/testing/sysfs-fs-xfs |  2 +-
 fs/xfs/xfs_inode.c                     | 14 +++---
 fs/xfs/xfs_itable.c                    | 48 ++++++++++++++++--
 fs/xfs/xfs_iwalk.c                     | 32 ++++++++++--
 fs/xfs/xfs_mount.c                     | 90 +++++++++++++++++-----------------
 fs/xfs/xfs_symlink.c                   |  3 +-
 6 files changed, 125 insertions(+), 64 deletions(-)
