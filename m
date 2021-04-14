Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90659C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F190613C3
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbhDNBEx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345256AbhDNBEv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:04:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D19E6613BD;
        Wed, 14 Apr 2021 01:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362271;
        bh=OdvbzXqiiTdUlRO4Ql4+VZX9uELHd1OXZnbY5kFIcL4=;
        h=Subject:From:To:Cc:Date:From;
        b=P4QWubWY8KEfKcXfa0qnmXGIGzq0hezJ5exqlojz+0OD1cG90DSytclWprh+MN8PD
         X9JhA2W6x38pCFJKY7hH6/hECooXML1ywR0C0h69kV8U4V87mD6K2WUneoqWVetn/X
         57g4HvKHKur8Y20I7Kr8ETymUTCBiro6EhoYANavgqJHRLBdUUp1RncsCR4rHgOLW3
         yZmtRwx98GrKPn0Oht78yL8Z7ppdwA+GoljWLUWxeaJcZtQZ5E+Vn0Pj9dYNpuoLQY
         xTAjsScq0Cv0UAvqZZJxY2zLi0b0KWNa60bSpdxBCkBiKJIlauxnC63rdTw+3T8Bcq
         G95qwIi4BC8zA==
Subject: [PATCHSET 0/9] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:04:30 -0700
Message-ID: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This branch contains fixes to various tests to fix miscellaneous test
bugs and unnecessary regressions when XFS is configured with somewhat
unusual configurations (e.g. always-cow mode, external logs, and/or
realtime devices).

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
 common/dmthin     |    9 ++++++++-
 common/dump       |    1 +
 common/rc         |   13 ++++++++++++-
 common/repair     |    2 +-
 tests/generic/094 |    5 +++++
 tests/generic/223 |    3 +++
 tests/generic/225 |    5 +++++
 tests/generic/347 |    2 +-
 tests/generic/500 |    2 +-
 tests/generic/563 |    7 ++++++-
 tests/generic/620 |    2 +-
 tests/xfs/030     |    2 +-
 tests/xfs/083     |    2 +-
 tests/xfs/305     |    2 +-
 tests/xfs/506     |    1 +
 tests/xfs/521     |    2 +-
 tests/xfs/530     |    2 +-
 17 files changed, 50 insertions(+), 12 deletions(-)

