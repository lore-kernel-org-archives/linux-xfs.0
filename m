Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597A5C43214
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3781A6102A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243225AbhIAAN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243221AbhIAANZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 189A361008;
        Wed,  1 Sep 2021 00:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455150;
        bh=vx7hNoAu33jMPpHhwdyfLz3T+7GRM5xPXBN1Vj35EwE=;
        h=Subject:From:To:Cc:Date:From;
        b=ju6fdPB2YeYWb52t+SqRqpJ/6Hcz9CL6lfHP3bUwrkFNEq6/ye7OWtQPBzbawg0Am
         F/iWrFl/ij15+A878xfKsciYHIvZEkFrLW7Kj9Gz6atkrjHYw2nRH7t3TnioDdD5sv
         3UETBtCjddYV5HQd0TVGyHoSz2h0Pg6EWpN4vaNp2YnLRpoEBqU3rM4/cYI9EoTfHF
         e17RKcFhGMxhyNT4IguBlOHiUZDRmL2ZWqA9BYZXamjUHBS87sRuNbnN9FYFaxiyjy
         1AO3RyIP7KfLfKoDYfPO60hGtHg1l1JFEpEZKXZrHOBDbox/7akfqMsK36B9+OXg2M
         P8RTmGuYiM/dQ==
Subject: [PATCHSET 0/5] fstests: document all test groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:29 -0700
Message-ID: <163045514980.771564.6282165259140399788.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've noticed that fstests doesn't document what the test groups mean.  I
attempted to document what each group seems to symbolize, to reduce the
amount of confusion for new contributors.  While doing so, I noticed
that there were a handful of tests that aren't in the right group.  The
first three patches dix that problem.  The next test adds a build-time
check to ensure that all groups are listed in the documentation file so
that we don't lose track of things.  The last patch updates ./new to use
the documentation file instead of having to build group.list files.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=document-test-groups
---
 doc/group-names.txt    |  136 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/buildgrouplist |    1 
 new                    |   24 ++++----
 tests/ceph/001         |    2 -
 tests/ceph/002         |    2 -
 tests/ceph/003         |    2 -
 tests/xfs/491          |    2 -
 tests/xfs/492          |    2 -
 tests/xfs/493          |    2 -
 tests/xfs/519          |    2 -
 tests/xfs/520          |    2 -
 tests/xfs/535          |    2 -
 tests/xfs/536          |    2 -
 tools/check-groups     |   33 ++++++++++++
 14 files changed, 191 insertions(+), 23 deletions(-)
 create mode 100644 doc/group-names.txt
 create mode 100755 tools/check-groups

