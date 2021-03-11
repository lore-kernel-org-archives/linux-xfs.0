Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038DBC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 18:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B734B64FFF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 18:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCKSAx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhCKSAj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Mar 2021 13:00:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5163964FD4
        for <linux-xfs@vger.kernel.org>; Thu, 11 Mar 2021 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615485639;
        bh=cOOIE/YKodwq10sewmtTtA0+cTMp7g7A6WPSJqqZIrc=;
        h=Date:From:To:Subject:From;
        b=XlEbM53hRTUJ/ZjgOOf1KgzKkYnzxvWjaS6YbMXMFXIQkKJl+/OQQLGCDCEtNcV1o
         5R8FJiPo9f1qc2x1uGjX73A+IRFrTdR8qG5D5Djk71dWT+aEAK9t/aqcctikA8K80K
         eT/um3QYh/4mUSsYljqS/oVeF8MB8s4I3/c+UcBsWZg8T4PSVa9h19aLs0FDHoAEWX
         xqdwwuEjGx+HrExGxDI/jNBOC7/LEtswXEY2/O4Noy/Rix+qde3lMyijBZ3TSgsUxf
         V0ZRp6cMLdMshRDtHx+hMoTa9djlumI0nv5LT72QengcH7bu1bOK8zNNtJQjAsAiET
         7kvputXwdKy6g==
Date:   Thu, 11 Mar 2021 10:00:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 96fd0303027c
Message-ID: <20210311180038.GB8425@magnolia>
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

96fd0303027c docs: ABI: Fix the spelling oustanding to outstanding in the file sysfs-fs-xfs

New Commits:

Bhaskar Chowdhury (1):
      [96fd0303027c] docs: ABI: Fix the spelling oustanding to outstanding in the file sysfs-fs-xfs

Darrick J. Wong (3):
      [b5a08423da9d] xfs: fix quota accounting when a mount is idmapped
      [45b5d1dba70e] xfs: avoid buffer deadlocks when walking fs inodes
      [e8efa3a8244e] xfs: force log and push AIL to clear pinned inodes when aborting mount


Code Diffstat:

 Documentation/ABI/testing/sysfs-fs-xfs |  2 +-
 fs/xfs/xfs_inode.c                     | 14 +++---
 fs/xfs/xfs_itable.c                    | 42 ++++++++++++++--
 fs/xfs/xfs_iwalk.c                     | 32 ++++++++++--
 fs/xfs/xfs_mount.c                     | 90 +++++++++++++++++-----------------
 fs/xfs/xfs_symlink.c                   |  3 +-
 6 files changed, 119 insertions(+), 64 deletions(-)
