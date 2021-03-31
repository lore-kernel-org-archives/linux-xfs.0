Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE54C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D7961953
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhCaBIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhCaBIH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 229786190A;
        Wed, 31 Mar 2021 01:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152887;
        bh=/tj7jadVOxiXM2BOKWbZBMSIxiAFkJQBsNudoolIhkE=;
        h=Subject:From:To:Cc:Date:From;
        b=jog7Giz8Y/e43w6dVWcRfhmL7MuE9T2gFJ1Xsa4Vh8yjbQjT4lUre/EjwwFAmKzG6
         JGhdVFdq8k8xHWJxX6JHJoQb1H33u+AISL8UzWhO6Mb5sovrFsYVZcVt+Mj7vp1KDq
         w2umMLIH5Dfjp+vnDdpCgpJYni77GlAxQhuY/uumK+QQ3uEVpgN1cqigtqgrHy2l4V
         u8i1IdDw4cXXTskovIHH1PAIvsn7mfuL0DUIvCz4dOHn6svlL6/LF0rD5X9g86SeEz
         XYfMAgJE5VGsZoJoSnkXBImHAXpEWirlWYoieuyzf5cR30cNU0SWzaO0TljiLjxrk3
         6zp7/XWLc6ZbA==
Subject: [PATCHSET v3 0/3] fstests: make sure NEEDSREPAIR feature stops mounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:04 -0700
Message-ID: <161715288469.2703773.13448230101596914371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Quick test to make sure that having the new incompat "needs repair" feature
flag actally prevents mounting, and that xfs_repair can clean up whatever
happened.

v2: fix bash variable error, fix a problem found when using xfs_admin
    with external log devices
v3: Fix a stupid naming bug in v2.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=needsrepair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=needsrepair

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=needsrepair
---
 common/xfs        |   35 ++++++++++++++++++
 tests/xfs/768     |   82 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/768.out |    4 ++
 tests/xfs/770     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/770.out |    2 +
 tests/xfs/group   |    2 +
 6 files changed, 225 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/768
 create mode 100644 tests/xfs/768.out
 create mode 100755 tests/xfs/770
 create mode 100644 tests/xfs/770.out

