Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC38C43333
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9832961494
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbhCCDPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360761AbhCBW3R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B208D64F3A;
        Tue,  2 Mar 2021 22:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724116;
        bh=B1ft+ivrqd+8kgSg+2IiqZZx0wt3RNLtnJzuThePmRw=;
        h=Subject:From:To:Cc:Date:From;
        b=L8hDwiab4kbqUtS5jMb5GeJHTkSBAu5hdzCsf7Rr1yXQ5QNrtu4M3RgVRyjFUy3a+
         qfDiBthBGADWeWdJl+22vnByzrVyTY05RQFS6YzAH70BDB596Dk0WMVRiue/nszaMY
         t44vuObcM2c3b5NHJ4PRJ8YI+w9E3eVARA8XUp5Lo9/kepTblOF5rFFDLivR4Wn0Tl
         zYxui37RCmbjtwrYfYVRef8ITLeIkSF/k3tL98Y/W6GqgnCPqySxCyLs1Kv1iS/MjH
         Sh17UX/OcxP8ypx1HyDXqV8aEOg078Na4uHcpKoZKIk9KCfpp6EkjvqsxUJBHKeJjP
         n/ojCxqpXzR2Q==
Subject: [PATCHSET 0/7] xfs: small fixes and cleanups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 02 Mar 2021 14:28:36 -0800
Message-ID: <161472411627.3421582.2040330025988154363.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is an assortment of random patches that I'm submitting before I
send the deferred inactivation series.

The first six patches are small fixes and cleanups of the online fsck
code.

The last patch in the series switches the btree height validation code
to use the computed max heights instead of the static XFS_BTREE_MAXLEVEL
define.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.13
---
 fs/xfs/libxfs/xfs_alloc.c      |    8 ++++----
 fs/xfs/libxfs/xfs_ialloc.c     |    4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c |    2 +-
 fs/xfs/scrub/agheader.c        |   33 +++++++++------------------------
 fs/xfs/scrub/common.c          |   23 ++++++++++-------------
 fs/xfs/scrub/common.h          |    5 ++---
 fs/xfs/scrub/health.c          |    3 ++-
 fs/xfs/scrub/quota.c           |    6 ++++--
 fs/xfs/scrub/repair.c          |    6 +++++-
 fs/xfs/scrub/scrub.c           |    2 +-
 10 files changed, 40 insertions(+), 52 deletions(-)

