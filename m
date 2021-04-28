Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED0BC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37121613F4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhD1EJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233960AbhD1EJW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:09:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B803613ED;
        Wed, 28 Apr 2021 04:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582918;
        bh=D23WfLOJXHVvDyvhuJbf3lvDPegqljz6r6DhiKbQfwo=;
        h=Subject:From:To:Cc:Date:From;
        b=k185yUdWAfVtri2Jkf1oibY2wPo6249IC/eKwtwoo8HCIk8CfYCzBT0xmdGVqdPbI
         MeWFPs34+7vMahInNnf/+6+SQlHgz8SQjf+Dpgz9kdl/kRlKYWKQ7Bxo07m9et7h4T
         kPwzmN3IpNU5HoS36C0oKCuJoGBsUHj8d/9Ghq6pAZNGL8BmENEEfHjSU7v5zNhC2D
         WCnFIRz/LZPbwHwFTDzofgZJcbcsLTRBva1SRBbfb+S3HUuz2bq591WoZ5hBg53J7g
         oHX4YGAwLDxWtmG82WS5uVemD16hEmOcNW37hFgPYI30tQTv9AsJU0s5r5jFd1T32z
         PyvsEf2oU44qw==
Subject: [PATCHSET 0/2] fstests: test xfsprogs regression fixed in 5.12
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:08:37 -0700
Message-ID: <161958291787.3452247.15296911612919535588.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are new regression tests to exercise code that has been fixed as of
the upstream xfsprogs 5.12 release.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfsprogs-regressions
---
 tests/xfs/010     |    1 +
 tests/xfs/757     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/757.out |    7 ++++++
 tests/xfs/group   |    1 +
 4 files changed, 72 insertions(+)
 create mode 100755 tests/xfs/757
 create mode 100644 tests/xfs/757.out

