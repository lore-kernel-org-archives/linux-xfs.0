Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C659C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2043864E2A
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhBACEb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhBACE3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:04:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4AD164DDD;
        Mon,  1 Feb 2021 02:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145028;
        bh=69/xGe7TwEaORbbW5P1tlTMMaTKt83sJLtnSza9JMBM=;
        h=Subject:From:To:Cc:Date:From;
        b=Wvo6gAtQhlPxus/r24RIJ4LdkC4+aIE6MNzANRDed5kciuXTAr6ads+u7Xj+ebPO5
         66IZ5eYKAPlsk6ma5OQ8c7h3h+dmuHdvvkRyLg1fIfLWHJpbvrswMaaeaEtFfWU7yg
         JoYgDB8x5JOp6Ev4wNWlLQjPjWzpWNyPRDKpRhYi7byPgxBB1stvL70bkmRPwk1Lda
         OO+HIEcd9IOrhkzifuaBFQB21wbaSFyjJuShySjealt6hVAO39hgnbtbeWpzEVYBHc
         j33RKm+tLCTKy8v3woU4hkET2vt/LkcD4Hx0ph3GySpA01O+p2SSsthkgrjJGIXX70
         +XCf6yhWkT90w==
Subject: [PATCHSET v5 00/17] xfs: minor cleanups of the quota functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:03:48 -0800
Message-ID: <161214502818.139387.7678025647736002500.stgit@magnolia>
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
 fs/xfs/xfs_bmap_util.c   |   60 ++++---------------
 fs/xfs/xfs_inode.c       |   30 +++-------
 fs/xfs/xfs_ioctl.c       |   67 +++++++++------------
 fs/xfs/xfs_iomap.c       |   54 +++++------------
 fs/xfs/xfs_iops.c        |   26 +-------
 fs/xfs/xfs_qm.c          |  115 +++++++------------------------------
 fs/xfs/xfs_quota.h       |   59 ++++++++++++++-----
 fs/xfs/xfs_reflink.c     |   71 +++++++++--------------
 fs/xfs/xfs_symlink.c     |   15 +----
 fs/xfs/xfs_trans.c       |  144 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h       |   13 ++++
 fs/xfs/xfs_trans_dquot.c |  116 +++++++++++++++++++++++++++++++++----
 14 files changed, 436 insertions(+), 372 deletions(-)

