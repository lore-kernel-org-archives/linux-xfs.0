Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F61C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3F4064EDA
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhBBCEA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 21:04:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhBBCD7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:03:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BC064ED6;
        Tue,  2 Feb 2021 02:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231398;
        bh=GP2cjaDwsf8qWC60tXPXrnnIp2oSzfEU4s3GS0Gujm8=;
        h=Subject:From:To:Cc:Date:From;
        b=Hz+IV5pcqRsuyIywhj0btX3dOrjATg8RsGEyutx2ahtDS1qhDeVtS76a7BGRPEDHW
         QTR7GFh1GdcopTPbDr2RmGe9zhda5FSYPuNUNL55mmc+YvRV4rXUVAB8umSArUgm4i
         Yqo+Zg41TNStPveaP6S+oJyGT97Qb1gX4S3GcfGEDoNzWdgsXA9lSa+GT/Rbk0x6Gx
         99yC/X8Ul9DkpCM1X4BdQ4mhB9a7Lmziy7jJMSDGPr6RfnJSmOEDRPhqN2y2f3oV24
         IDupaSCtHw3BK4tsaJYtg4Yb+qkrRuXz0xeFdIvek3vCQkLoh0n65vYZBaIYs5/jnv
         uoC4j/3Vi91aw==
Subject: [PATCHSET v6 00/16] xfs: minor cleanups of the quota functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:03:18 -0800
Message-ID: <161223139756.491593.10895138838199018804.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series reworks some of the internal quota APIs and cleans up some
of the function calls so that we have a clean(er) place to start the
space reclamation patchset.  The first five patches clean up the
existing quota transaction helpers.  The next five patches create a
common helper to allocate space, quota, and transaction to handle a file
modification.  The final three patches of the series create common
helpers to do more or less the same thing for file creation and chown
operations.  The goal of these changes is to reduce open-coded idioms,
which makes the job of the space reclamation patchset easier since we
can now (mostly) hide the retry loops within single functions.

v2: rework the xfs_quota_reserve_blkres calling conventions per hch
v3: create new xfs_trans_alloc* helpers that will take care of free
    space and quota reservation all at once for block allocations, inode
    creation, and chown operations, to simplify the subsequent patches.
v4: fix some jump labels, improve commit messages, call out a quota
    accounting fix on dax files, fix some locking conventions with
    reflink
v5: refactor the chown transaction allocation into a helper function,
    fix a longstanding quota bug where incore delalloc reservations were
    lost if fssetxattr failed, other cleanups
v6: streamline the chown quota reservation code by moving it to
    xfs_trans_alloc_ichange.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=quota-function-cleanups-5.12
---
 fs/xfs/libxfs/xfs_attr.c |   15 ----
 fs/xfs/libxfs/xfs_bmap.c |   23 ++-----
 fs/xfs/xfs_bmap_util.c   |   60 ++++--------------
 fs/xfs/xfs_inode.c       |   30 +++------
 fs/xfs/xfs_ioctl.c       |   67 ++++++++------------
 fs/xfs/xfs_iomap.c       |   54 +++++-----------
 fs/xfs/xfs_iops.c        |   26 +-------
 fs/xfs/xfs_qm.c          |  115 ++++++----------------------------
 fs/xfs/xfs_quota.h       |   49 ++++++++++----
 fs/xfs/xfs_reflink.c     |   71 ++++++++-------------
 fs/xfs/xfs_symlink.c     |   15 +---
 fs/xfs/xfs_trans.c       |  157 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h       |   13 ++++
 fs/xfs/xfs_trans_dquot.c |   73 ++++++++++++++++-----
 14 files changed, 392 insertions(+), 376 deletions(-)

