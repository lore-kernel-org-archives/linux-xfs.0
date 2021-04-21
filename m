Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D7AC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED996141F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhDUAXI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234501AbhDUAXI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:23:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BADA961409;
        Wed, 21 Apr 2021 00:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964555;
        bh=0GsVir9xQ9xF+bgI9nHoJicJKrrFmzWl6zwU82fam9M=;
        h=Subject:From:To:Cc:Date:From;
        b=VOR+kUVx+GwveePaW+mHcOU7jTn5wNVc8YAWi5tHCpSajwx+xFq6Q+Cq+rDIGYtwO
         AOrG6+JK9MbfT4a1d1DPnA0CGaV2b3dGkOm3Zc0R+UtKNZb3jZ+we6Q0X+swSgQ8qp
         VZsn9GQVgrBCbwR8mhy3mhsTILk1v2BA36HqzOnZ2yVCQDdodllCZa8HQFHkkYWF1n
         0A/G9junwJ7bzNyNK6GUirEOq1eFqnUcs+3p4y9SQxJAHFgIHg6KisA5PATyRDHm+2
         Dw5N2nsjaOHAUMyEH9kFuPZuT2ODIBtzJ31iWR1F8drlorkJBX+VAdlUT9yYjMAThs
         tt5kGJklpR1Vw==
Subject: [PATCHSET v5 0/1] fstests: make sure NEEDSREPAIR feature stops mounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:22:35 -0700
Message-ID: <161896455503.776294.3492113564046201298.stgit@magnolia>
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
v4: Fix other review comments.
v5: Fix maintainer comments.

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
 common/xfs        |   28 ++++++++++++++++++
 tests/xfs/768     |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/768.out |    4 +++
 tests/xfs/770     |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/770.out |    2 +
 tests/xfs/group   |    2 +
 6 files changed, 199 insertions(+)
 create mode 100755 tests/xfs/768
 create mode 100644 tests/xfs/768.out
 create mode 100755 tests/xfs/770
 create mode 100644 tests/xfs/770.out

