Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE31C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E913922E03
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733193AbhARWNF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732848AbhARWMz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:12:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 728B722E02;
        Mon, 18 Jan 2021 22:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007918;
        bh=GuLXwWYoCQpA63SFtFGSTw78z2pw02olhHJrsLG7tOM=;
        h=Subject:From:To:Cc:Date:From;
        b=CBT/UJwMUwwPpiZT/kMZxWs+rZ5A7sHLNnzJKofDnsStlIb0gVbDn23PmhSz8+Szh
         JxEC2ecYssDpsS6k1GN5CPN8zhrWnHN+7nMbE1T1T97ciKjhdlPWiHTuIq/AzIoR9/
         6xU53ICN4qM6QMxPLeXc0U2Fih0428B9WEjF80erBN8p0cm3NsuvqxxAESEFpGVqGC
         Icq4YlacrcCAUguv/eB6n6c30lI3gSoRmqq3tQJu+UTmFdfc+NNGsAXo0k+GKkLtFb
         bOFyApGy+2ddnyLSt+0PX+iuuERYCULac2k7AcEF0mng5DDmqZ0p6aPK2XLsfpK0H1
         Ub0pBgoHxKaDA==
Subject: [PATCHSET v3 00/11] xfs: try harder to reclaim space when we run out
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:11:58 -0800
Message-ID: <161100791789.88816.10902093186807310995.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Historically, when users ran out of space or quota when trying to write
to the filesystem, XFS didn't try very hard to reclaim space that it
might have speculatively allocated for the purpose of speeding up
front-end filesystem operations (appending writes, cow staging).  The
upcoming deferred inactivation series will greatly increase the amount
of allocated space that isn't actively being used to store user data.

Therefore, try to reduce the circumstances where we return EDQUOT or
ENOSPC to userspace by teaching the write paths to try to clear space
and retry the operation one time before giving up.

v2: clean up and rebase against 5.11.
v3: restructure the retry loops per dchinner suggestion

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reclaim-space-harder-5.12
---
 fs/xfs/libxfs/xfs_attr.c |   10 ++
 fs/xfs/libxfs/xfs_bmap.c |   10 ++
 fs/xfs/xfs_bmap_util.c   |   22 +++--
 fs/xfs/xfs_file.c        |   26 ++++--
 fs/xfs/xfs_icache.c      |  189 +++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_icache.h      |    9 ++
 fs/xfs/xfs_inode.c       |   22 ++++-
 fs/xfs/xfs_ioctl.c       |   18 +++-
 fs/xfs/xfs_iomap.c       |   24 ++++--
 fs/xfs/xfs_iops.c        |   20 +++--
 fs/xfs/xfs_qm.c          |   36 +++++++--
 fs/xfs/xfs_quota.h       |   36 +++++----
 fs/xfs/xfs_reflink.c     |   31 +++++---
 fs/xfs/xfs_symlink.c     |   12 ++-
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |   40 ++++++++++
 fs/xfs/xfs_trans.c       |   20 +++++
 fs/xfs/xfs_trans_dquot.c |  108 +++++++++++++++++++++++---
 18 files changed, 466 insertions(+), 168 deletions(-)

