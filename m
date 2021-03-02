Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7337CC4160E
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43A4761477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344137AbhCCDQO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361108AbhCBXXO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 18:23:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 718CA64F32;
        Tue,  2 Mar 2021 23:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614727354;
        bh=OpY2QF4qIvS810nU0YRIYfUf/Nay16u27jqFS8QMYfE=;
        h=Subject:From:To:Cc:Date:From;
        b=iK02zWVSDrTEhLE4O8Y8umtJq6y2Uo5/j0e41Om89yRWMC2/fG2KceEqq6WH/T3ZL
         jvg/ndG6Nd/CbwVca+qLpy8BS2nYN2Yc1fft8jgbEB9h6m8igGyelB5lwd55+OKfy3
         +9ygi/PM20XFU+XeFG/XDbmtGJKpfVKwAfWK1qNCOSmXwv4KD2WoZKv9jSabweCrXU
         yTQudEu5fgz1cjWe75GIGm2X0dY1mObTeT48GrB/iovZ/P2jJVOFnvxQvRTBP07rdo
         SaqlmHRBizV0DwlzI9PnfzfMCEmvkeBxxWH3jUnHk1r9zs8eDPDmPfYO1UZb1Fu0sL
         AQpjO8Ph/EYOw==
Subject: [PATCHSET 0/4] fstests: various fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Mar 2021 15:22:34 -0800
Message-ID: <161472735404.3478298.8179031068431918520.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a few fixes for some false negatives on reflink filesystems, and
fixes to make sure the dax tests work properly even when the filesystem
is formatted with the dax iflag set everywhere.

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
 common/rc         |    3 ++-
 tests/generic/607 |    4 ++++
 tests/generic/608 |    3 +++
 tests/generic/623 |    1 +
 tests/xfs/271     |   12 +++++++++++-
 5 files changed, 21 insertions(+), 2 deletions(-)

