Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FE9C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DA8864E53
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhBJC5r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233686AbhBJC5q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CD0A64E5A;
        Wed, 10 Feb 2021 02:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925815;
        bh=r4zXr6F+6DrIHr61QynQV4M0MZwg4T+IOnZGUZNxQCM=;
        h=Subject:From:To:Cc:Date:From;
        b=cFw3l+2o0Xgh5cydIuFJoHVxDKTPj4OitdA4iIv3I0xPm47dAclUuA2roGQxn/AYA
         T8Kq0p1w/IzrNVYJdjGpABH07cVbMSK//gvliMnhoCL6CBZCq7gRdqugWCD2Cju6d9
         2fMosH3khk3MeZ+lFP3pAt0qKHJXz9S1vAWNaWAqTm3vqljPOcuKexkklYdXv0szut
         eikJj1R7/waQn0/MefHXRHLiMUp2cPo/jQNK9NEAm/fsrLbI4Qh/b9+ihjlFiR4JUO
         kQ6IeE8ZRASJ9Jh8dVfBjorpXSuuKIVXIlxkio0rk7bX28Cy7Cg7GKW0ANa0BNz2wq
         MVrc7L+/F6b0Q==
Subject: [PATCHSET 0/2] fstests: remove _require_no_rtinherit from xfs tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:56:55 -0800
Message-ID: <161292581498.3504701.4053663562108530233.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The _require_no_rtinherit helper is rather bogus -- it disables a test
if the fs was formatted with -drtinherit=1 to avoid failure reports.
The failure reports themselves are usually due to the test requiring
some feature of the data device (e.g. filestreams, AGFL fiddling), and
have nothing to do with realtime at all.  Since we /also/ have a means
for working around rtinherit=1, we should do that instead of skipping
the test.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=remove-no-rtinherit
---
 common/filestreams |    5 +++++
 common/rc          |   10 ----------
 tests/xfs/170      |    1 -
 tests/xfs/171      |    1 -
 tests/xfs/172      |    1 -
 tests/xfs/173      |    1 -
 tests/xfs/174      |    1 -
 tests/xfs/205      |    5 ++++-
 tests/xfs/306      |    5 ++++-
 tests/xfs/318      |    5 ++++-
 tests/xfs/444      |    6 +++++-
 tests/xfs/445      |    5 +++++
 12 files changed, 27 insertions(+), 19 deletions(-)

