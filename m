Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86A5C00144
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbiGZTtQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239829AbiGZTtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:49:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750AB357C7;
        Tue, 26 Jul 2022 12:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1140361590;
        Tue, 26 Jul 2022 19:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0B7C433D6;
        Tue, 26 Jul 2022 19:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864949;
        bh=wZd+XroQdTKwv3GdiXeBticqFN/6jAV836GCx5MeEu8=;
        h=Subject:From:To:Cc:Date:From;
        b=UyHeLMeeuaYDHyUDS42jEu6BOrVYy8Gjlvf6+BLf1QTVHmX5jzek+PmryKgWhoai1
         cAw9cV38+Tge+XBrDurYm4b+72h8KRjofeaB5VoB0tvpWNT85vnKAAVetoBvczMzRJ
         ggrKjA9WxTu88J6ISph+36wIfEMM6KoBgAc4kSoKi0ITel8wLlvdDQOxPDt5FbEqan
         Vrd4pPW57sG1CkAcS4ngsaOuKTi99k+8wKCsP9kLTzCuasLzqb6S12D/oca5OkmzqK
         64TXjaWslTgzuUxM2slBmfQ/zRnowDDVFRB1O/LEYIHOo/LH6/tGayEoFd/eS+U7kO
         c+gGibresxWhQ==
Subject: [PATCHSET 0/3] fstests: fix some hangs in crash recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 26 Jul 2022 12:49:09 -0700
Message-ID: <165886494905.1585306.15343417924888857310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are several tests in fstests (generic/019, generic/388,
generic/475, xfs/057, etc.) that test filesystem crash recovery by
starting a loop that kicks off a filesystem exerciser, waits a few
seconds, and offlines the filesystem somehow.  Some of them use the
block layer's error injector, some use dm-error, and some use the
shutdown ioctl.

The crash tests that employ error injection have the unfortunate trait
of causing occasional livelocks when tested against XFS because XFS
allows administrators to configure the filesystem to retry some failed
writes indefinitely.  If the offlining races with a full log trying to
update the filesystem, the fs will hang forever.  Fix this by allowing
XFS to go offline immediately.

While we're at it, fix the dmesg scrapers so they don't trip over XFS
reporting these IO errors as internal errors.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-shutdown-test-hangs
---
 check                    |    1 +
 common/dmerror           |    4 ++++
 common/fail_make_request |    1 +
 common/rc                |   50 +++++++++++++++++++++++++++++++++++++++++-----
 common/xfs               |   38 ++++++++++++++++++++++++++++++++++-
 tests/xfs/006.out        |    6 +++---
 tests/xfs/264.out        |   12 ++++++-----
 7 files changed, 97 insertions(+), 15 deletions(-)

