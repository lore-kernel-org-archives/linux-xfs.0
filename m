Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A43C07E9D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C138E61004
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381570AbhGTAbt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381211AbhGTA3x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 188DF6115B;
        Tue, 20 Jul 2021 01:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743336;
        bh=Qv/Pkid2UJbFphFljIMGBbdCZj2JHF+82EKdXuRxBRU=;
        h=Subject:From:To:Cc:Date:From;
        b=CH7TuWZk3X97Jqh1/m819DKzwdsbIzVu4MxXI2K/pUYTt8EDHx5j6uK+mUxHsEcHH
         MWN0x8xcWHcQl1aYf2ST7g7cx0ba2C/tJS71wY+PnFRN4IrAa1y2ahzvd0xeGkIl0P
         BbV7UIDuoAB9YaH3q1D9gzKLPD+T/izAPB7hAT8KXMSkOrNKcG8uQKJXWB5GQuOzwp
         caB7eKcNkQhMgq2diDot3EzXHbaiUa30Y0RxahJB5US4hAmVU9hMIyNrMP1ksQ4T+D
         YkBXs/GGOn+4sgPtmckWZkUpLUsheF8UXCjdFyRAO7c1auuztl5GKrhJ115UuYP88B
         kvfAApJhiqYqQ==
Subject: [PATCHSET 0/1] fstests: regression tests for 5.14 fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:55 -0700
Message-ID: <162674333583.2650988.770205039530275517.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add a regression test for online shrink fixes that will appear in 5.14.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=shrink-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=shrink-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=shrink-fixes
---
 tests/xfs/778     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/778.out |    2 +
 2 files changed, 192 insertions(+)
 create mode 100755 tests/xfs/778
 create mode 100644 tests/xfs/778.out

