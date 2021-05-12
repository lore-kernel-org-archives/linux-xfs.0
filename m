Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9E4C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE94610EA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhELCCu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 22:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhELCCt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 22:02:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 533C861166;
        Wed, 12 May 2021 02:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784902;
        bh=wpxECN8aDSbzzd9G6H5sHQPHv8hxFgJmjP3q1sinyAs=;
        h=Subject:From:To:Cc:Date:From;
        b=t8VWlhyXZEdW7/0sZsGX0UUH8VGs6MENxOoQ0oVoho1slPnTHOdgrKaLF25SZwVfn
         ha7v7RqYX0xwrvCfGX+M/gaqc7mN/+QqjQDhVvgUVKCTanGD4Uayf/XZmNHGxqrAgL
         0OY4W0a1543RAAFo7PSqvuDbDF6X0FZ7ZvKWhkRyD4b43KtV+/ZDz/89pJR0GZMcie
         gcdI5C4xIXusFr2aM38mq7vl114kJvUk5wxvXTEwGm5sLwbGzNhvzt9qPXDSLQlkeP
         ElLHV1v4zGJO3VvPMqaEmOUWk095aZBcy3X1qybdo1aYC4kvXZWjhTGRd4adzJxJLc
         A7Z6/wSU3BuEA==
Subject: [PATCHSET 0/8] fstests: miscellaneous fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 May 2021 19:01:39 -0700
Message-ID: <162078489963.3302755.9219127595550889655.stgit@magnolia>
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
 common/populate   |    2 +-
 common/rc         |    2 +-
 common/xfs        |   27 ++++++++++++++++++++++++++-
 ltp/fsstress.c    |   24 ++++++++++++------------
 ltp/fsx.c         |   24 ++++++++++++------------
 src/global.h      |   13 +++++++++++++
 tests/generic/223 |    3 ++-
 tests/generic/449 |    2 +-
 tests/xfs/004     |    2 +-
 tests/xfs/083     |    8 ++++----
 tests/xfs/085     |    2 +-
 tests/xfs/086     |    4 ++--
 tests/xfs/087     |    2 +-
 tests/xfs/088     |    5 +++--
 tests/xfs/089     |    5 +++--
 tests/xfs/091     |    5 +++--
 tests/xfs/093     |    2 +-
 tests/xfs/097     |    2 +-
 tests/xfs/099     |    4 ++--
 tests/xfs/100     |    4 ++--
 tests/xfs/101     |    4 ++--
 tests/xfs/102     |    4 ++--
 tests/xfs/105     |    4 ++--
 tests/xfs/112     |    4 ++--
 tests/xfs/113     |    4 ++--
 tests/xfs/117     |   49 ++++++++++++++++++++++++++++++-------------------
 tests/xfs/120     |    3 ++-
 tests/xfs/122.out |    1 +
 tests/xfs/123     |    2 +-
 tests/xfs/124     |    4 ++--
 tests/xfs/125     |    4 ++--
 tests/xfs/126     |    4 ++--
 tests/xfs/130     |    3 ++-
 tests/xfs/146     |    2 +-
 tests/xfs/147     |    2 +-
 tests/xfs/178     |    4 ++--
 tests/xfs/235     |    3 ++-
 tests/xfs/272     |    2 +-
 tests/xfs/318     |    2 +-
 tests/xfs/431     |    4 ++--
 tests/xfs/521     |    2 +-
 tests/xfs/528     |    2 +-
 tests/xfs/532     |    2 +-
 tests/xfs/533     |    2 +-
 tests/xfs/538     |    2 +-
 45 files changed, 159 insertions(+), 102 deletions(-)

