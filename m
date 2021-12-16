Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B0BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 01:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhLPBJS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:09:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48070 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLPBJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 20:09:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E669B8226B
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 01:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33C2C36AE0;
        Thu, 16 Dec 2021 01:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616955;
        bh=85Saj+b2ZbkKARb0ZgDjnaDVxTjE1Roy8YWRmjVPVJs=;
        h=Subject:From:To:Cc:Date:From;
        b=ZGeXnXvWVlGwK4EPdeF/f0Eug/xVxf3TT7yfUubPpVvjWi4BUXV+nTV7zwAdTj3tU
         9mcku96oo7ngjEBVuPHCg1FHHldi44rVBp/VaTWUBcXUMJYUD9AVSuH0LvXihMtKv+
         /bZNHPRej4mjl3AvRRAh9PUjKGEXh4m4i/aOyyGz6JjEF3Hx8Buo0W+H92heEBI4eu
         /bV6kDyGZ21UHt7FYDpjswlYqVeO05yVi6BRIGQdH+YGNIl+eWm+3/dkS6udlJk02t
         1V3Vig+8fwPXAqRbHqwBcWfTNIQ5uyLhmWw7VroSyc90SBAS64dqUoHROoWkY4N7SR
         /GyQj0dINjaMQ==
Subject: [PATCHSET 0/7] xfs: random fixes for 5.17
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Ian Kent <raven@themaw.net>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Dec 2021 17:09:15 -0800
Message-ID: <163961695502.3129691.3496134437073533141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Well, we've reached the end of the year and the only thing that's ready
to go is this pile of bug fixes that I found while I've been quietly
QAing the online fsck code.  There's no particular order to any of
these.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.17
---
 fs/xfs/scrub/dir.c        |   15 +++++++++++----
 fs/xfs/scrub/quota.c      |    4 ++--
 fs/xfs/scrub/repair.c     |    3 +++
 fs/xfs/scrub/scrub.c      |    4 ----
 fs/xfs/scrub/scrub.h      |    1 -
 fs/xfs/xfs_buf_item.c     |    2 +-
 fs/xfs/xfs_dir2_readdir.c |   28 +++++++++++++++++-----------
 fs/xfs/xfs_iops.c         |   34 +---------------------------------
 fs/xfs/xfs_log.h          |    1 +
 fs/xfs/xfs_log_cil.c      |   25 ++++++++++++++++++++++---
 fs/xfs/xfs_log_recover.c  |   24 +++++++++++++++++++++++-
 fs/xfs/xfs_mount.c        |   10 ----------
 fs/xfs/xfs_qm_syscalls.c  |   11 +----------
 fs/xfs/xfs_reflink.c      |    5 ++++-
 fs/xfs/xfs_super.c        |    9 ---------
 fs/xfs/xfs_symlink.c      |   19 ++++++++++++++-----
 fs/xfs/xfs_trans.c        |   11 ++++++++++-
 17 files changed, 110 insertions(+), 96 deletions(-)

