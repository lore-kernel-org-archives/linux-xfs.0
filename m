Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3C3C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D31A64EA6
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhBMFeA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhBMFd7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:33:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F68E601FC;
        Sat, 13 Feb 2021 05:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194399;
        bh=yIoXXGVv2nSE9DXKyj3BGaHRMj4hN6sdaTADiPavH2Y=;
        h=Subject:From:To:Cc:Date:From;
        b=KxaYq1AlbPp4Nb6Mu5zVfYCvCwDGSyqOr0DqEgO8EUx1zG2/namwgMAThzbMpCFbX
         5CaM5/v8lAL+Kap13yLDcp0mZTW+e4uNwD294uJvnnQJaiKj37/zRdp+Ds3rWHsahD
         /sRKyxynq60DfVKCMWeeqWRsd9e0ys9qeoXvXIyl20rZUhliMrcutZ52eq9XhmcNuN
         VY4NEZsBz88Q3CySPR6zDDPcTvIJy8/vjGocjpi+nJ/Exnd0WFmAhZJcaA8RIr1v6P
         dZC9ad1kBovRNQBRTeJJPZh4t4nM7uorrO68sPNJBOQ+Bpnwp+AJd/Sqi7gOAkaxJl
         ztHark2jeLg0g==
Subject: [PATCHSET RFC 0/2] fstests: make sure NEEDSREPAIR feature stops
 mounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:18 -0800
Message-ID: <161319439859.403424.12347303262615931894.stgit@magnolia>
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
 common/xfs        |    8 ++++
 tests/xfs/768     |   84 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/768.out |    2 +
 tests/xfs/770     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/770.out |    2 +
 tests/xfs/group   |    2 +
 6 files changed, 198 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/768
 create mode 100644 tests/xfs/768.out
 create mode 100755 tests/xfs/770
 create mode 100644 tests/xfs/770.out

