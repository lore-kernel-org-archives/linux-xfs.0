Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33825C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B5C561131
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhIOXns (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232836AbhIOXns (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:43:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D9B60F8F;
        Wed, 15 Sep 2021 23:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749349;
        bh=JCW28d2dZWHlcBLFo7Bl5FG6/c5WqlFGfCpwH4tPDBg=;
        h=Subject:From:To:Cc:Date:From;
        b=lI7ztDvVY3mDNHlwrc8Vl7n56SOfevGN3w+M5bpqpZkvqwr9CpAQyrPaI8LP32fEg
         qnDkoj3Q6L0AxI8b6+AHWWrxtuL7uZb3pIOVnA4O5ivicVCMA1utaYVkqfgGUsHPsK
         FDa55pujWebLVnKKH7fxfIH6+9MQokuqlyR1MJnuW2MYB8VV5O0mevHJoycpam6q+T
         xp6GrHRVtEnnkMn1p8CccA/U12+Leb4UEeBsh2erycux4b8GHcs41/nkMcOHkJ8Em2
         q/ZQ5o9NLrDqN95b3nDaxsBYH7O1QIGzF+QAGctjix9yiKVcIHyrgcJVY8vWkWa8fT
         bdfgnLYal0mWg==
Subject: [PATCHSET v3 0/1] fstests: exercise code refactored in 5.14
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:28 -0700
Message-ID: <163174934876.380813.7279783755501552575.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add new tests to exercise code that got refactored in 5.14.  The
nested shutdown test simulates the process of recovering after a VM host
filesystem goes down and the guests have to recover.

v2: fix some bugs pointed out by the maintainer, add cpu offlining stress test
v3: run against the test fs, and limit the io thread count

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-for-5.14
---
 tests/generic/726     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/726.out |    2 +
 2 files changed, 76 insertions(+)
 create mode 100755 tests/generic/726
 create mode 100644 tests/generic/726.out

