Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78001C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42EDA611EE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbhIQAkZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234517AbhIQAkY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B7AD611C8;
        Fri, 17 Sep 2021 00:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839143;
        bh=EFr7vqbd1heIcu13hC9/I8+TFylchHBQ38uWuIWKcUU=;
        h=Subject:From:To:Cc:Date:From;
        b=BgYKwGiNYJjvnPqR87z2ywkv5oBMj7Zc3+LJPaBWAk0RzooIxkHoF2aYVohD8zbVo
         w9g0vjrqYKO7JHpClLQpR44HukL0Lf4/lrWSB6tEMWtEbq7mtZo/hqng+sfSBx2cMX
         mwptxwKZvyi5P8Jgjlwi8K5CcCxxBiHKh44V9gF/CJ8dj83KpEk6zE3zoyGI9uDCx+
         +FXpksi0yKkj6MFAxQ2TYMJX9mP/0QrYBZsylQe8xJRctj6vtjErhIW5HbB5nGh6jE
         VcE/F5gQi44NtSLNKIvok/dqeZ96kh9hKX9tYgok44MWRaGhWZsULXmCwMVT6Qbviw
         eoNvYBvQs6zhQ==
Subject: [PATCHSET v4 0/8] fstests: document all test groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:02 -0700
Message-ID: <163183914290.952957.11558799225344566504.stgit@magnolia>
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
v2.1: move the group name documentation checks into the preamble code so
      we don't have to have a second script
v3: cleanup cleanups to mkgroupfile and don't allow new 'other' group
    tests
v4: split the ./new script cleanups into a separate series; add review
    tags; no other changes

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
 new                 |   24 ++++-----
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
 19 files changed, 215 insertions(+), 37 deletions(-)
 create mode 100644 doc/group-names.txt

