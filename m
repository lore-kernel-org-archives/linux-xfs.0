Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF10C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 275B660F9E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhG1AJj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhG1AJi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A82660F23;
        Wed, 28 Jul 2021 00:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627430978;
        bh=SWucPhOBtwPqivUNdKo1RnbXQEkE1ZEmRX9MtHeioKw=;
        h=Subject:From:To:Cc:Date:From;
        b=bjpngDsgUiYMnf4lu2qlnYNUNAEdLu/sc5W1TgveRPN62WAAfkSG7cd0WnPbSMEOn
         QNIFiKg7YytPWWl8bSyCtjBfqMAtmHn/4OWmzRV/HGnWhwZFruUtiaN1H6EJcV2juG
         jHmM9NZODiiP/4PuWWkb9jaqZ2fKf4be9IlGtlrSB1tfiUjgTfCc1BgrKybv1AM9BK
         Qb2WnMWO0hEmFB6Tz9ebAXqk1BNiCvlRDDBH6BP/GwZy941nqWoKHkDpAzEVU4ekLc
         PPQocxuBvr2jP2mnTqq2NMxcvIQMSb0Fz/ESe4b3MccXwkt8LkdKwghuukZJ5trDhe
         K9fHWTcAWNtVw==
Subject: [PATCHSET 0/4] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:09:37 -0700
Message-ID: <162743097757.3427426.8734776553736535870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are the usual weekly fixes for fstests.

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
 check             |    7 ++++++-
 tests/generic/570 |    2 +-
 tests/xfs/106     |    1 +
 tests/xfs/106.out |    5 +++++
 4 files changed, 13 insertions(+), 2 deletions(-)

