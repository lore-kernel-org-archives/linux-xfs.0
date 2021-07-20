Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3FEC07E9D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2DD611EF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhGTAaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241385AbhGTA1m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:27:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E044F600D1;
        Tue, 20 Jul 2021 01:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743297;
        bh=FXM/cNgE7V02WgTxCHG+NYpjxYPbjNGO7QGJIvlW9lE=;
        h=Subject:From:To:Cc:Date:From;
        b=C6aqe102uUPxBH3d6XwFY5em6tcYwhFnnRqi86fGBSXmX5V4aXUWW0Cg4iWJE5exZ
         QC/zdvAXO2p3LZqTaNmvw1HbGZ609hGVJMEH9JoSM5E3073Lp4w1jK1ql9OZgcQ+t0
         V2ipQJrw9P4bbo/hBah2JqGWjRBsJpmWKKr8JObobwepJVhGMUoiFBs+qn3n4C0HNx
         khmZWKH2ACmk4ZscUOh/p2acaHQatPHggwnDJd2X33lucJ0lwotT1djAMrN7E6B4oi
         o48SoEO0+DqxvhhqjQbiJsqGjOgnj60qKTWXMu3BMKhf5lmjGK3aAtKUEmKtnZeyYI
         FJIZDZP2XzqRQ==
Subject: [PATCHSET v2 0/1] fstests: fixes for test control code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:16 -0700
Message-ID: <162674329655.2650678.3298345419686024312.stgit@magnolia>
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

v2: update usage info

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fstests-fixes
---
 new |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

