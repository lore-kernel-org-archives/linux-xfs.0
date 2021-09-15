Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12274C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF40B60F8F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhIOXn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232836AbhIOXn5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCCD160F25;
        Wed, 15 Sep 2021 23:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749357;
        bh=5+JVWlx/krBscoJVplsfrM30K/DxdF5/+FHS5D6a27E=;
        h=Subject:From:To:Cc:Date:From;
        b=M0ISd3dqIxhckZ7p4QkGdPKf/Tto+9ESA/9FSiQzfSpxXjfMBPu9TmIRG7A6j22hn
         c+a7cYnHoZXtJy1Fz8hLmWda8cl+36/QlbdTZL4X90QKtt9PZp44AgFrM5fGCkn8il
         SkE0Hb1PLuklYLyfYS+wqKq3Lv62MRZFvISfXliWZnNpOv5rv+UH2HKMROZ1oqN4Q5
         g7Tmb5c/R0jLyBKyWDr2XVb/4Ev1+C0O0TVF42yaFO7Tisi88MhN6+xGeoTJGfUgCL
         /5tKdGre1OY15xuq+GK2SA9O746JKT60+n3mvi54Ad+j7CLrHG9O3W2EBPNjGmh/d5
         9deFJ4OTDCIKA==
Subject: [PATCHSET v3 0/9] fstests: document all test groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:37 -0700
Message-ID: <163174935747.380880.7635671692624086987.stgit@magnolia>
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

v2: fix the 'subvolume' group tests, tweak some of the wordings of the
    group description file, add missing license declarations, remove the
    one-off overlay group
v2.1: move the group name documentation checks into the preamble code so we
      don't have to have a second script
v3: cleanup cleanups to mkgroupfile and don't allow new 'other' group tests

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=document-test-groups
---
 common/preamble     |   21 ++++++++
 doc/group-names.txt |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
 new                 |   31 ++++++------
 tests/btrfs/233     |    2 -
 tests/btrfs/245     |    2 -
 tests/ceph/001      |    2 -
 tests/ceph/002      |    2 -
 tests/ceph/003      |    2 -
 tests/generic/631   |    2 -
 tests/xfs/491       |    2 -
 tests/xfs/492       |    2 -
 tests/xfs/493       |    2 -
 tests/xfs/519       |    2 -
 tests/xfs/520       |    2 -
 tests/xfs/535       |    2 -
 tests/xfs/536       |    2 -
 tools/mkgroupfile   |   37 +++++++++++---
 tools/mvtest        |    5 ++
 tools/nextid        |    4 +-
 19 files changed, 220 insertions(+), 39 deletions(-)
 create mode 100644 doc/group-names.txt

