Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD6FC3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 18:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiG1SRO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiG1SRN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 14:17:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9287858B6B;
        Thu, 28 Jul 2022 11:17:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33ABCB824DA;
        Thu, 28 Jul 2022 18:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E698BC433C1;
        Thu, 28 Jul 2022 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659032230;
        bh=uH5q3o7tRg6WNQcKOAJthl4GRlGIm7wtLOTQk2BOWuA=;
        h=Subject:From:To:Cc:Date:From;
        b=oHWtfVd34H4/aNRvjj0fg++iSdgFgsgf/rfPAQEnas5gDZujssxnuJLKv3rFqhPfy
         Q/jrZQDa4SvfTcP5rNfzasTOrPUjfg9+o/2pcvYvO8AR/MfmJo+6k5Pt1sj2v9Qkn8
         V6SzfWXhMGdYcqft5lKJFVhwzYw/F1xzqB6OeFjW4Gl4qsGppDd5X6rMj3TXwMVX/9
         fOVlA/29Rv11m8rf2rgk0HIvWk1tU5MbzeMHNRiODKnVw9wN1ixqBrAUoWHKZQUYgq
         EUdgisZenQGVkeUMfxjXrpf5mBPjxd7O5/m1P9OIpqCuNsSQOnLM2YhVi5pnfmXUgo
         Zpn3EJkedPXHA==
Subject: [PATCHSET v2 0/3] fstests: random fixes for v2022.07.24
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     liuyd.fnst@fujitsu.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 28 Jul 2022 11:17:09 -0700
Message-ID: <165903222941.2338516.818684834175743726.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual batch of odd fixes for fstests.

v2: rework xfs/432 changes per reviewer comments, bring xfs/291 in line
    with that, and fix allocation unit size detection for the seek
    sanity test

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
 src/seek_sanity_test.c |   36 +++++++++++++++++++++++++++---------
 tests/xfs/291          |    6 +-----
 tests/xfs/432          |    3 ++-
 3 files changed, 30 insertions(+), 15 deletions(-)

