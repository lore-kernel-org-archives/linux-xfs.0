Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CC2C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F72A600CC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhESX6D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhESX6C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57292610A1;
        Wed, 19 May 2021 23:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621468601;
        bh=RiURJsBAUZ1MtiwjuIBnzH4emyJ+xy1f6hJPrfXAEdk=;
        h=Subject:From:To:Cc:Date:From;
        b=pyn7lUmCQdir4wiuYc8tLrUuJgM0j+tqnei54YH8ZoiT9uiTpD0sZVmFC+bmsU8FX
         csoM/OSVWI0mqg+l7/c/b2mQOIexDEZeVqlv3dGmrGJ7X0DBCYJVx0BofL36aiXeYs
         czNwor+J2GaYvliVh8G0lSeRUor0oQu4SHnQNUZGi6CI2htHtZ3tObzyh0wlAmPHhw
         g9m7yZhbnz1ta4Bo7wxX1FtH/HJ+dTS7hk2/dkqTDyAjgX0MwVfgj7augJrmLo1V4X
         mE34PIoriS6qmVRy7MvkNQlYNyli0PZu1Ng5Eotv5Sk2CeDUbR2/NMUfMCP4IiYM2Z
         cSvqGz57uNoEw==
Subject: [PATCHSET 0/6] fstests: miscellaneous fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 19 May 2021 16:56:40 -0700
Message-ID: <162146860057.2500122.8732083536936062491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Various small fixes to the fstests suite, and some refactoring of common
idioms needed for testing realtime devices.

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
 common/populate                                    |    2 -
 common/xfs                                         |   25 +++++++++++
 ltp/fsstress.c                                     |   24 +++++-----
 ltp/fsx.c                                          |   22 +++++----
 .../aio-dio-append-write-fallocate-race.c          |    2 -
 src/global.h                                       |   13 ++++++
 tests/generic/223                                  |    3 +
 tests/generic/449                                  |    2 -
 tests/xfs/004                                      |    2 -
 tests/xfs/088                                      |    1 
 tests/xfs/089                                      |    1 
 tests/xfs/091                                      |    1 
 tests/xfs/117                                      |   47 ++++++++++++--------
 tests/xfs/120                                      |    1 
 tests/xfs/130                                      |    1 
 tests/xfs/139                                      |    2 +
 tests/xfs/146                                      |    2 -
 tests/xfs/147                                      |    2 -
 tests/xfs/178                                      |    4 +-
 tests/xfs/207                                      |    1 
 tests/xfs/229                                      |    1 
 tests/xfs/235                                      |    1 
 tests/xfs/272                                      |    2 -
 tests/xfs/318                                      |    2 -
 tests/xfs/431                                      |    4 +-
 tests/xfs/521                                      |    2 -
 tests/xfs/528                                      |    2 -
 tests/xfs/532                                      |    2 -
 tests/xfs/533                                      |    2 -
 tests/xfs/538                                      |    2 -
 30 files changed, 119 insertions(+), 59 deletions(-)

