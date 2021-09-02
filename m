Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9805C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE28661041
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbhIBXxX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhIBXxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Sep 2021 19:53:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EC086101A;
        Thu,  2 Sep 2021 23:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630626743;
        bh=6ffbOa+qvJzFF7MijLH1JAEHsPNdrgDiD9WAcyJ6hLU=;
        h=Subject:From:To:Cc:Date:From;
        b=uqYNr6mvKzc7vuQxs94mbh3UCFc+aQQaKhzisOGEjp1fxkP6RgTsRzzA8pfST2Nc2
         f0D319M0Sk2xGJZ6xPtJ4bKcubOE0E9wOHBSRxJztMcKNlq3r7aQP/d0AA/KRmN/KN
         A7zcXeCKpbrAsGAY+WJFPSkGqQ6KQRJZSPk8TE6r5jIHqw+xss7tdHJ6eGwrAb7GXG
         ZXwBXzIaQ8kOfMZrZY349zFXMxGRpT8NtHbUCrwQlH6u3QHGssXRa0eXx1VbWRJ9dR
         ZTqpUC0AY4t2l6zKQCOxd0U6Mu6gfB4NfOONHz55awyj0W2gjkG+k2zYWJbNmOHUMb
         kzehCN5VxA7nQ==
Subject: [PATCHSET v2 0/8] fstests: document all test groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 02 Sep 2021 16:52:23 -0700
Message-ID: <163062674313.1579659.11141504872576317846.stgit@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=document-test-groups
---
 doc/group-names.txt    |  135 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/buildgrouplist |    1 
 new                    |   24 ++++-----
 tests/btrfs/233        |    2 -
 tests/btrfs/245        |    2 -
 tests/ceph/001         |    2 -
 tests/ceph/002         |    2 -
 tests/ceph/003         |    2 -
 tests/generic/631      |    2 -
 tests/xfs/491          |    2 -
 tests/xfs/492          |    2 -
 tests/xfs/493          |    2 -
 tests/xfs/519          |    2 -
 tests/xfs/520          |    2 -
 tests/xfs/535          |    2 -
 tests/xfs/536          |    2 -
 tools/check-groups     |   35 ++++++++++++
 tools/mkgroupfile      |    4 +
 tools/mvtest           |    5 +-
 tools/nextid           |    4 +
 20 files changed, 205 insertions(+), 29 deletions(-)
 create mode 100644 doc/group-names.txt
 create mode 100755 tools/check-groups

