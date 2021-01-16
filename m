Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C923C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D22C229F0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbhAPB0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:26:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbhAPB0A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:26:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43BF523A56;
        Sat, 16 Jan 2021 01:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760313;
        bh=+jNwFi6yoGBWYoxpnfBuBrWpofNs2jTghzdIPVv5QMM=;
        h=Subject:From:To:Cc:Date:From;
        b=FNR0V++Pq83v0kBNuRyK/834qSExiu1FPJSqIKbYseoELikO6/FR9PMnbysLjekWZ
         31nzxgo7ae2rpbVRXLNLs4TMbfE1rFz5/n8SPvEVmqMN9crHs0ZLWmiDjfUeNDKz94
         H2T9Wj9Xqfd3487LyfsCcy7g3DmXzNZEISZjVPiH0+kmK49IeUWXKnO4EeTpDzk0o8
         UQteFuVAzUfWc9jmhKps+hiDXOqlucSy4whXrJAkQ7fcSDA3kX//kdN6fEQlKkyJek
         wZovSpnLFfq3Yjirhzyk6xHVqQ1RWeeksgrRpwMrnbKo2kTGP0ps0S1s96YpuNjoeN
         AwRxaFk4Ti8Fw==
Subject: [PATCHSET v2 0/4] various: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:25:12 -0800
Message-ID: <161076031261.3386689.3320804567045193864.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are some random fixes to the utilities: the first shuts up valgrind
warnings about uninitialized userspace memory being passed into kernel
ioctls; the second fixes warnings about libicu not being released at the
end of scrub; and the third fixes false collision reports during scrub
phase 5 if someone is replacing directory items while the scanner is
running.

v2: respond to reviewer comments

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
 libhandle/handle.c |   10 ++++++----
 scrub/inodes.c     |   18 +++++++++++++++++-
 scrub/spacemap.c   |    3 +--
 scrub/unicrash.c   |   33 ++++++++++++++++++++++++++++++++-
 scrub/unicrash.h   |    4 ++++
 scrub/xfs_scrub.c  |    6 ++++++
 6 files changed, 66 insertions(+), 8 deletions(-)

