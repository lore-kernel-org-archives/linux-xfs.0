Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD597C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B53F64E5B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhBJC5A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBJC5A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1216064E2F;
        Wed, 10 Feb 2021 02:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925780;
        bh=dpzrKe1LOASB16SWwAxtxColS1QhFd7XIwb8WyiQvd8=;
        h=Subject:From:To:Cc:Date:From;
        b=LJ1t6htzxBQP10rpHL1flFjbC6BNpQyAKhPqeBGmzgn1qzMNsgcYD467VbtVh+/aj
         BvOTB5XBAIAGmcLPkSTkF7oyFAAzJLoYDBKaiBiybBpgM7okcl748N6GcIqdJfyicx
         PGTzFQaxrDN/GBphl81bnSbQsgFtaY00A1mA2Tb5TinzXoJWtJRDAxTWLV8jBOUonP
         vAtoY6+CChz80a4ehyDyzMc9l4VSUQvjQ9BhumfDnUGzgPhMFofCvO82v0xm9SgZSf
         p+Z39t8qwvp24MvJbxDVZ3fYXtZJdrw7TW6gr86y9ylv0HqEEfv9n7wHHyAozSvTLL
         Y7B57QDbMnERA==
Subject: [PATCHSET 0/6] fstests: various improvements to the test framework
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:56:19 -0800
Message-ID: <161292577956.3504537.3260962158197387248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset contains assorted changes to the test suite that I use to
make it easier to reproduce regressions reported in nightly test runs.
The first two make it so that we capture metadumps of corrupt xfs
filesystems, and the rest introduce various options to ./check so that I
can exclude tests and run exact sequences of tests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=testsuite-improvements
---
 README        |    2 ++
 check         |   44 +++++++++++++++++++++++++++++++++++---------
 common/config |    1 +
 common/fuzzy  |    3 +++
 common/rc     |    2 +-
 common/xfs    |   26 ++++++++++++++++++++++++++
 6 files changed, 68 insertions(+), 10 deletions(-)

