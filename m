Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7C4C00140
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiGZT5h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiGZT5f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:57:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123EF33E2E
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jul 2022 12:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6BDBB81A16
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jul 2022 19:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F955C433C1;
        Tue, 26 Jul 2022 19:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658865452;
        bh=nn+jFhFknc9YM3VM2M3tE9mxfZT8sp4FRaYgPJiFz0A=;
        h=Subject:From:To:Cc:Date:From;
        b=lz6nb9H/yg4e/bOv38vJvkL66mIS9g7DiU3pMqOPDiXHx71AE0LUJNRSIxuPR2A+R
         uUAMPuDxEwiwfvf73wBb+nCZiO1DksmBvY7lAv7KM24uoOiyrDqvLTwP9poeTf7JmB
         fELt2dsiiQy1ucmzJvtW3Hz//5C0/0qbyhjT+h4YzKxrmYOF+MfGXc+BkLECyhJ9CW
         XZIbdpxrtoO08L4T4mn4WbmoXHLsM/e6qoPk/qthrdn+cBMZC/BfAp2NDCZmdBbVPn
         p5GTHvk+T99xZdfwCna9FucP0rfRML/dUlVoc5tj/cRQeTHWVMSoqFWibUmfIDQg0o
         nTma/dXVGeUbw==
Subject: [PATCHSET v4 0/2] mkfs: stop allowing tiny filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Jul 2022 12:57:32 -0700
Message-ID: <165886545204.1604534.17138015950772754915.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The maintainers have been besieged by a /lot/ of complaints recently
from people who format tiny filesystems and growfs them into huge ones,
and others who format small filesystems.  We don't really want people to
have filesystems with no backup superblocks, and there are myriad
performance problems on modern-day filesystems when the log gets too
small.

Empirical evidence shows that increasing the minimum log size to 64MB
eliminates most of the stalling problems and other unwanted behaviors,
so this series makes that change and then disables creation of small
filesystems, which are defined as single-AGs fses, fses with a log size
smaller than 64MB, and fses smaller than 300MB.

v2: rebase to 5.19
v3: disable automatic detection of raid stripes when the device is less
    than 1G to avoid formatting failures
v4: add review tags, update manpages to reflect new minimum sizes

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-forbid-tiny-fs
---
 man/man8/mkfs.xfs.8.in |   19 ++++++----
 mkfs/xfs_mkfs.c        |   96 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 8 deletions(-)

