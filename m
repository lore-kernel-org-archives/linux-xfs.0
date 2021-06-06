Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8DEC4743E
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3412D6136D
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFFRz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 13:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhFFRz4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 13:55:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F95B6139A;
        Sun,  6 Jun 2021 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623002046;
        bh=5ioVQBBrNjW47QU46tYARNtq8cfobIwia3PeKrfOcdQ=;
        h=Subject:From:To:Cc:Date:From;
        b=djKrlryh/wB6Qz8tQomlA/VD2kEvd84n4mcIWgNCCd5M7mywElcGcgP0TXN/stCTO
         UOQqNmRLYQx4arg7BFAd7c/kMJRdmfKQPw9G5Tl9w9Xcy/YHrYG8j5rW8CiX9R3rSU
         O3rzKEBwNaUrM3wfjwGDn+pSAisUFZOgTeXtUP2+OPftFcqkyqsTUlbG3DbUH+p+5s
         CCToA5G86xAhHdJHb92i3pdLC3kzGxd5TwPBxcEVyJb3wPkFBTwnfK9DPSQN9L7JqE
         oHXWTARt+jVsaQdAxda18ZaZoncWjMQzXfa4GcDA4aW1ucekMdtIFaKv/PZwlfAYAd
         +U7uAqJQWVEzQ==
Subject: [PATCHSET v3 0/3] xfs: preserve inode health reports for longer
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, bfoster@redhat.com
Date:   Sun, 06 Jun 2021 10:54:04 -0700
Message-ID: <162300204472.1202529.17352653046483745148.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a quick series to make sure that inode sickness reports stick
around in memory for some amount of time.

v2: rebase to 5.13-rc4
v3: require explicit request to reclaim sick inodes, drop weird icache
    miss interaction with DONTCACHE

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-inode-health-reports-5.14
---
 fs/xfs/xfs_health.c |    9 +++++++++
 fs/xfs/xfs_icache.c |   50 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 50 insertions(+), 9 deletions(-)

