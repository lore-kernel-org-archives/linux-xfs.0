Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDDBC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4AD961409
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhDUAWy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbhDUAWw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4993C6141C;
        Wed, 21 Apr 2021 00:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964540;
        bh=q8GjgDF2TGrD5cMEFFJ88BiRhZF1Hot24gXX8FoK3Rg=;
        h=Subject:From:To:Cc:Date:From;
        b=Th6SVBoJjuSNVVz8vZ7iNNsQSitmNmextPFrUF3pqIyi4jQITOz4RRzMjGhuoVJR7
         Vp84QhbKyvitg7zV/OzhmFLHB/g0G3HQa+iBANytCBJSn5Sg+iJc4Wlf1u/bFPoPJJ
         //EmeQmn6v9FTLt8czPvPxlQOjSbuWZy9ezWibLLm4shsO0dY1qv0zcLPolOrt3qtm
         x4WCTX3fDD0JZZpjRMk+PN2AJC7kqn1UKBrhCaNrnN2rVwOS7fwhe8InoqsBBCh3xx
         mqjQxEXup4G75CmfvCoyzdHqTgzSrmxC4aZ6cXxlU95u/pXN/4jXKElH4JHjN9Wp2u
         5h4H+f+jAvT+w==
Subject: [PATCHSET 0/2] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:22:19 -0700
Message-ID: <161896453944.776190.2831340458112794975.stgit@magnolia>
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
unusual configurations (e.g. external logs, and realtime devices).

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
 tests/generic/223 |    5 +++++
 tests/generic/347 |    2 +-
 tests/generic/500 |    2 +-
 4 files changed, 15 insertions(+), 3 deletions(-)

