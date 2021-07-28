Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939FCC43214
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B2A4601FC
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhG1AKj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232853AbhG1AKi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:10:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB65F601FC;
        Wed, 28 Jul 2021 00:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627431037;
        bh=uWF7nIdD2Oo99RmCZZvzBziyzR3p7MFnu8FYlrpUqTs=;
        h=Subject:From:To:Cc:Date:From;
        b=iQ3LvWwDE9pxhZ5NBpJ6vipC3KH3TG6bZa8Txw/Py/4ID/VVjeo/siHV+e9mkpqdL
         4EJHpdhwb6LgH7SvMPEiTh7Sg6j1RSj/1RYJtdPihBL47TItV8jkgItxCqzoCyC83/
         heatvIEPMoRtsaKGZ7X4RVes+QtJnofuMFN55ZHcQQTDVMsjDZdmvy5rCvkVOMaYy7
         FKSh5KIt94SEHy6op0Zd/9c6dir9vHYfYqgumqnFy4tFo2AKUGmQUIji0A8fSOW9v+
         qOmbPX2aUI+wPckjh2zM8aYpksl8/8BhcCyIIP3C5a55VaH2L7Hk2bp4HblfXofA1E
         3yTpVKkYrcoDg==
Subject: [PATCHSET 0/1] fstests: tag recovery loop tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:10:37 -0700
Message-ID: <162743103739.3429001.16912087881683869606.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The single test in this series tags all the tests that perform looping
filesystem crash recovery tests with the same 'recoveryloop' tag so that
maintainers can run them over and over again.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=recovery-loop-tagging
---
 tests/btrfs/190   |    2 +-
 tests/generic/019 |    2 +-
 tests/generic/388 |    2 +-
 tests/generic/455 |    2 +-
 tests/generic/457 |    2 +-
 tests/generic/475 |    2 +-
 tests/generic/482 |    2 +-
 tests/generic/725 |    2 +-
 tests/xfs/057     |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

