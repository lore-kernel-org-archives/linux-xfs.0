Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E874C07E9B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BCA661C91
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhGGAXq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhGGAXq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447B661CAC;
        Wed,  7 Jul 2021 00:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617267;
        bh=FCDGl+/QNVVqS1mLAlMw/AWAlo+4z1L1pN+wyQ+dUQ8=;
        h=Subject:From:To:Cc:Date:From;
        b=YDUQ31mpmhHgwL1uv3ny8OnGiva4DWcVFq+5Rep29z4knlXsmtfuXeZHOciuXw3sI
         ueuPnMapTeaoWH2yWapjrD6GQJ/RCVW8ZVQ3KEp3oh4/lBcDCGojKMUjzbOEGwgHj2
         Ndfh5182ODjbIqEARjEoDkfWnmzIwm+HkmSLpXqTgiUnrceFftYYIi48EHV5TCH+gO
         T3Sat03VyQw5qgkavKwf9IqhzH0IgypcCSKfBPJ4yxGwKU1tQ9/p2szSjZcodoLUc3
         jOtA5yZWEiJzSM+wbtJ4w8zWPSkGUjvxK6DK6cpHvgj4Zbi07PA+Kd4Fh2+LPqNI0f
         oireS78HXEu/A==
Subject: [PATCHSET 0/8] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:07 -0700
Message-ID: <162561726690.543423.15033740972304281407.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes a bunch of small problems in the test suite that were
causing intermittent test failures.

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
 check             |   24 +++++++++++++++++-------
 common/dmthin     |    8 ++++++--
 tests/generic/019 |    3 +++
 tests/generic/371 |    8 ++++++++
 tests/generic/561 |    9 +++++++--
 tests/shared/298  |    2 +-
 tests/xfs/084     |    8 ++++++--
 tests/xfs/172     |   30 +++++++++++++++++++++++++++++-
 8 files changed, 77 insertions(+), 15 deletions(-)

