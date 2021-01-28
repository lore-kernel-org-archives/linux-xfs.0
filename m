Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B41C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039D264DE0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhA1GBv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhA1GBs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:01:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E719F64DD1;
        Thu, 28 Jan 2021 06:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813668;
        bh=x0poJILAwhQvjEhkCRFY6gH6qPJysPawmhMXXVcO4UY=;
        h=Subject:From:To:Cc:Date:From;
        b=WEcMWMgO5OeKCb/sVDlIoENs4WDQlFkUlExGHi2BvI1QmJ0z/TC39fp+8UofbsXZQ
         jI9iExOlW//cHfevudIFWNIhFjSr13ujd8RH1VEqwztuCvLBnwSLhCw4S/2h1x17yO
         BlGBcE4msWZj9UvdtYvYvUtMi5NtrZSV1rsXI1kd679v3z3Rm3aLnDs0rbQLY5wJDL
         xvAvpvKtguITDN8Ga0QkmjWjbQZMcpOkc1EadGDCFVrguf8ZK8/ek8OMPCxll+Jmhi
         6/HDcRpJgpUKCBKrQnEIVcuj9OBU+U/vURdFM3Fa1oq0z/22EcoY61i6FAHsMxvVZW
         u9vvDOBZGjbuQ==
Subject: [PATCHSET v3 00/13] xfs: minor cleanups of the quota functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:01:04 -0800
Message-ID: <161181366379.1523592.9213241916555622577.stgit@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=quota-function-cleanups-5.12
---
 fs/xfs/libxfs/xfs_attr.c |   15 -----
 fs/xfs/libxfs/xfs_bmap.c |   23 ++-----
 fs/xfs/xfs_bmap_util.c   |   58 ++++--------------
 fs/xfs/xfs_inode.c       |   30 +++------
 fs/xfs/xfs_ioctl.c       |    4 +
 fs/xfs/xfs_iomap.c       |   51 +++++-----------
 fs/xfs/xfs_iops.c        |    5 +-
 fs/xfs/xfs_qm.c          |   93 -----------------------------
 fs/xfs/xfs_quota.h       |   59 ++++++++++++++----
 fs/xfs/xfs_reflink.c     |   87 ++++++++++++++-------------
 fs/xfs/xfs_symlink.c     |   15 +----
 fs/xfs/xfs_trans.c       |   83 ++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h       |   10 +++
 fs/xfs/xfs_trans_dquot.c |  149 +++++++++++++++++++++++++++++++++++++++++++---
 14 files changed, 373 insertions(+), 309 deletions(-)

