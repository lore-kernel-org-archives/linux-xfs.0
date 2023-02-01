Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FFFC636CC
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 00:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjBAAvh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjBAAvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2023 19:51:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7717530F9;
        Tue, 31 Jan 2023 16:51:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C6DBB81FDA;
        Wed,  1 Feb 2023 00:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4EBC433D2;
        Wed,  1 Feb 2023 00:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675212690;
        bh=Pnl6Yv5kzVgRaaej5mR6pT0R6QnX8G8BHj8HMuVuxIs=;
        h=Subject:From:To:Cc:Date:From;
        b=pXUVWDuBjrzE+8cmhLXy4yVk1O5AMtz1kwuIk7sOIfrLleoRJYeZUAStVQYolpRpJ
         lilGuo4pkZ9fSvLsqHOfJQuTbUNWQ7b3bttDL0L/lXOVb9j0pPOMmaMivchmxVA/Zo
         Ri9MNH4euRvPUVJdGyy0AQR3ukfaMk7zLox2yMz9XeHCqIN6Zq3P6Bpa/oe/VXQ7Uq
         ihgXCqP0vSRb6ahweVfkj3Qj0kMnemC1d0R82rrT5R2ae7gHWo59IF4g7l+FYFYIoV
         pW9RUluICuTRVDEFgFbrcLz/LE1j5J2z1xYZ0Ug3ZGE+cf1pNLlN9t1Zt+bXyhsq2R
         bGikn6s9uP1dQ==
Subject: [PATCHSET 0/2] fstests: random fixes for v2023.01.22
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Jan 2023 16:51:29 -0800
Message-ID: <167521268927.2382722.13701066927653225895.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 common/dmthin     |    7 ++++-
 common/rc         |   80 +++++++++++++++++++++++++++--------------------------
 tests/generic/038 |    6 ++++
 tests/generic/500 |    3 +-
 4 files changed, 54 insertions(+), 42 deletions(-)

