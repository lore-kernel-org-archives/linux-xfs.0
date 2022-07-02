Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358ACC433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Jul 2022 00:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGBAfA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGBAfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Jul 2022 20:35:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD5E42A03
        for <linux-xfs@vger.kernel.org>; Fri,  1 Jul 2022 17:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4949AB80DEB
        for <linux-xfs@vger.kernel.org>; Sat,  2 Jul 2022 00:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB01C3411E
        for <linux-xfs@vger.kernel.org>; Sat,  2 Jul 2022 00:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656722097;
        bh=q7BJTb92QHY1LvMLoHCtA7r0hWChX8qRDR6qPuXtxDY=;
        h=Date:From:To:Subject:From;
        b=q3vtSW1jqFLmWIiV2U0wJPhlW4RiROpqVLTuKozf0aGAJS46+nala7zr4EbxdmOZM
         X5yWCrZxffo/Kc+pSR4i66BTdxGJ9hhi2YOw4vL4fVDvm1jxSSgwu5hBXdEXYTDfkA
         RuYYKWu34hXHO+vY1u+kLKmDmqfOU53GHGXBLdGYUQoccE2OSmn56ZQPyzNTMOGNOk
         wtk0sHbwkjiSo4QPELjFIeyj7O6pxnTIwFapuevZCPf+Avuzdk1HSIfEu6QWYipcwc
         ENhiJAjavO17umAe7kbMf+M2UswYmhBvX1vqH3JepSqbo65TG8PrhGvDM5JKSWOhQS
         KuosvgJAuPU/A==
Date:   Fri, 1 Jul 2022 17:34:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 7561cea5dbb9
Message-ID: <Yr+SsEX/gIK9K3R3@magnolia>
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

Just one last little push to include the fix for log recovery racing
with unmount, and we're (I hope) done with 5.19.  On to 5.20/6.0!

The new head of the for-next branch is commit:

7561cea5dbb9 xfs: prevent a UAF when log IO errors race with unmount

10 new commits:

Darrick J. Wong (6):
      [b822ea17fd15] xfs: always free xattri_leaf_bp when cancelling a deferred op
      [f94e08b602d4] xfs: clean up the end of xfs_attri_item_recover
      [7be3bd8856fb] xfs: empty xattr leaf header blocks are not corruption
      [e53bcffad032] xfs: don't hold xattr leaf buffers across transaction rolls
      [8944c6fb8add] xfs: dont treat rt extents beyond EOF as eofblocks to be cleared
      [7561cea5dbb9] xfs: prevent a UAF when log IO errors race with unmount

Dave Chinner (2):
      [7cf2b0f9611b] xfs: bound maximum wait time for inodegc work
      [5e672cd69f0a] xfs: introduce xfs_inodegc_push()

Kaixu Xia (2):
      [ca76a761ea24] xfs: factor out the common lock flags assert
      [82af88063961] xfs: use invalidate_lock to check the state of mmap_lock

Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c      | 38 ++++++-------------------
 fs/xfs/libxfs/xfs_attr.h      |  5 ----
 fs/xfs/libxfs/xfs_attr_leaf.c | 35 ++++++++++++-----------
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 +-
 fs/xfs/xfs_attr_item.c        | 27 ++++++++++--------
 fs/xfs/xfs_bmap_util.c        |  2 ++
 fs/xfs/xfs_icache.c           | 56 ++++++++++++++++++++++++-------------
 fs/xfs/xfs_icache.h           |  1 +
 fs/xfs/xfs_inode.c            | 64 +++++++++++++++++--------------------------
 fs/xfs/xfs_log.c              |  9 ++++--
 fs/xfs/xfs_mount.h            |  2 +-
 fs/xfs/xfs_qm_syscalls.c      |  9 ++++--
 fs/xfs/xfs_super.c            |  9 ++++--
 fs/xfs/xfs_trace.h            |  1 +
 14 files changed, 130 insertions(+), 131 deletions(-)
