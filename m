Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A10C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjKNPTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjKNPTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2023 10:19:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7637111D
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2023 07:19:15 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C274C433C8;
        Tue, 14 Nov 2023 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699975155;
        bh=kRFvVYyQo9h3UdVSK8tFC8FgB4YBcfgkeYjzV9XXjZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=Tx71B04jtt9pLSKi0ZF7CcXShvUoFgliUCSrGttSL9fNsJG2G2HqTk/D/15o3F8wB
         fOLeFA3UxD4oX7NxkHb/LD4KHfzHgnCspZfyu1w0WNwufOHH5Wz1rD2I2xpSEiWmCD
         0ad7GcHrFMqKKmPK5Mi/01WNeu6ykPsVmxeTrEGi8T0iqF9Rq27jlYOA7p5aonHi53
         4Ilq+AhAQn5lHXy3OYHq5PvoTUcxHkEPu0kSvYbH3srPYCw2BTA0rGnJM0Pwevtu3s
         J4nYszk3aitrEzBuqSPXiJVmsBimWORwqRHqrfi+ugZxsess/pK5znwuq/r2Ol5txg
         vWvvWEXCCEe2A==
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     chandanbabu@kernel.org
Cc:     ailiop@suse.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de, holger@applied-asynchrony.com, leah.rumancik@gmail.com,
        leo.lilong@huawei.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com, willy@infradead.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 7930d9e10370
Date:   Tue, 14 Nov 2023 20:44:03 +0530
Message-ID: <878r70icr4.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

7930d9e10370 xfs: recovery should not clear di_flushiter unconditionally

9 new commits:

Anthony Iliopoulos (1):
      [a2e4388adfa4] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS

Christoph Hellwig (1):
      [55f669f34184] xfs: only remap the written blocks in xfs_reflink_end_cow_extent

Dave Chinner (2):
      [038ca189c0d2] xfs: inode recovery does not validate the recovered inode
      [7930d9e10370] xfs: recovery should not clear di_flushiter unconditionally

Leah Rumancik (1):
      [471de20303dd] xfs: up(ic_sema) if flushing data device fails

Long Li (2):
      [2a5db859c682] xfs: factor out xfs_defer_pending_abort
      [f8f9d952e42d] xfs: abort intent items when recovery intents fail

Matthew Wilcox (Oracle) (1):
      [00080503612f] XFS: Update MAINTAINERS to catch all XFS documentation

Omar Sandoval (1):
      [f63a5b3769ad] xfs: fix internal error from AGFL exhaustion

Code Diffstat:

 MAINTAINERS                     |  3 +--
 fs/xfs/Kconfig                  |  2 +-
 fs/xfs/libxfs/xfs_alloc.c       | 27 ++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.c       | 28 ++++++++++++++++++----------
 fs/xfs/libxfs/xfs_defer.h       |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
 fs/xfs/xfs_inode_item_recover.c | 46 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_log.c                | 23 ++++++++++++-----------
 fs/xfs/xfs_log_recover.c        |  2 +-
 fs/xfs/xfs_reflink.c            |  1 +
 10 files changed, 92 insertions(+), 45 deletions(-)
