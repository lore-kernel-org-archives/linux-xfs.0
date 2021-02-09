Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B9EC4332B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45BF864EC8
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBIERp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:17:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhBIEON (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:14:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FA6964DF0;
        Tue,  9 Feb 2021 04:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843876;
        bh=DLB889KwWSMMDh1V7dPp2XqQ5UmPQt2+kdMktKE4CiM=;
        h=Subject:From:To:Cc:Date:From;
        b=axFiLFMrLxE++6t1KAj5Q4+Yq9vhupSYj/qUGPUIxIGi7rNgkvfJuvQVEDL1a5gop
         u8HHhy2dX3erRLdpc2nKsz/p9CeEqmDGtlDltzskotgXzaCGmNHKgJM+akMB0QWFsA
         q7MSrV8LHqUBy/55BqHwOfiGX2Q4Dfi1Hni9ILn3ajqeomEUS1rYt0Pd1IQzmITdsl
         sB6xt2szAl48ZXlTv4V3dG8G5TYJxuE6U2YwFK8fhruOZ2osu5gFWeekVy2AuyX5ok
         WdZ/0Diqa2g5szp/1w6meLWn/nTlsNRvbfQIp86HBWU62wmFe39NmOOZX8kKXZXVc9
         4VOM7s2vCDxQQ==
Subject: [PATCHSET v4 0/6] various: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        Chaitanya.Kulkarni@wdc.com
Date:   Mon, 08 Feb 2021 20:11:16 -0800
Message-ID: <161284387610.3058224.6236053293202575597.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are some random fixes to the utilities: the first shuts up valgrind
warnings about uninitialized userspace memory being passed into kernel
ioctls; the second fixes warnings about libicu not being released at the
end of scrub; and the third fixes false collision reports during scrub
phase 5 if someone is replacing directory items while the scanner is
running.

v2: respond to reviewer comments
v3: make repair check dquot types and ids
v4: add a minor code cleanup in xfs_scrub

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 libhandle/handle.c  |   10 +++++----
 repair/quotacheck.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++---
 scrub/inodes.c      |   18 +++++++++++++++-
 scrub/phase5.c      |   10 +++++----
 scrub/spacemap.c    |    3 +--
 scrub/unicrash.c    |   33 ++++++++++++++++++++++++++++-
 scrub/unicrash.h    |    4 ++++
 scrub/xfs_scrub.c   |    7 ++++++
 8 files changed, 128 insertions(+), 15 deletions(-)

