Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3737C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D804761C91
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhGGAXj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhGGAXj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAFA661CAC;
        Wed,  7 Jul 2021 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617259;
        bh=DbqlLV9LkeZgIPwA1SbdLZ29oocXQwu4p+lYjWQYbJ8=;
        h=Subject:From:To:Cc:Date:From;
        b=H1/QmuZ2UfrnAtZvqnV6j8JKMjN+lc2KjXreMthtjj2DxunOkWG+HBHtlVVUo4VhX
         UPrb5tQCJ9HxdqyvTfq36N86ej054GEeoFVC+EFr4cmNUYI+h9japzEkF/cHy2V3ca
         fsce7yBZGxKyqZAeQZelBJxiCJvgUWkzFsuZdlBY+bzdKTks6YrOhjKyw1igNbnrZR
         Zi9MGz2fU/BLQhEaghXPsifL1ATpmInxWL8SRUoJjmdQwLwhKduM7Cd/BMiZRe2RO5
         9U/oKz9rV8va3DP62rIkrxcgz2dtQKCoTn2Mmck2c5Cv+w79PEb33fbRvtDEN2GW4/
         Y4aFxGGBSNwVw==
Subject: [PATCHSET 0/1] fstests: fixes for test control code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:20:59 -0700
Message-ID: <162561725931.543346.16210906692072836195.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here is one more fix for problems in fstests itself, which teaches ./new
to take a new test number when creating a test.  Most people will want
it to pick one, but for those who want to create a large number of tests
now that are numbered high enough to avoid conflicts with future
rebases, this feature is for you!

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fstests-fixes
---
 new |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

