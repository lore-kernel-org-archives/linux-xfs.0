Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2774C07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E5B6108B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380381AbhGTAbJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236860AbhGTA1w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0951C60FF3;
        Tue, 20 Jul 2021 01:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743311;
        bh=bJ+U5i5+0YzYg8DRxzkDBzavZEfcsykyJRVR5uOy9PQ=;
        h=Subject:From:To:Cc:Date:From;
        b=qd9u9bRhLFh+jqQ4tEHBYJbPJlC0r6zJfvrceKXyxh9yYIoMPgBPLrqTkgEXU6gHY
         fhfuilu8itzYqpoPGIk4gO0mQeL+7S2QxozQf1p4dvKyf2WLc5CexnlqKW/YipT9I3
         TmoXxtxgn3iR37GiBwio7YPfyQnaAxxEy9hId5qyRIFzwoPNXh0oFrJRcbHwuJBtYR
         3F6GzBloI/GQnRpUgf5e8+8E+xlV0tqBAAL4Plx0j6XqPQbr2JYJ+fbuRlgUpfsyAa
         JS41pU/qYBlcnKlNL38ZBlC1nRqO3OoFdY2tAZziHjxQZpEFTQoKDu78LxDewXCaht
         jVak9QUHiIKWQ==
Subject: [PATCHSET 0/2] fstests: regression tests for 5.13 fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:30 -0700
Message-ID: <162674331075.2650812.11935724515971931345.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add regression tests to trigger some bugs in the realtime allocator that
were fixed in kernel 5.13.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-fixes
---
 tests/xfs/774     |   78 +++++++++++++++++++++++++
 tests/xfs/774.out |    5 ++
 tests/xfs/775     |  165 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/775.out |    3 +
 tests/xfs/776     |   57 ++++++++++++++++++
 tests/xfs/776.out |    5 ++
 6 files changed, 313 insertions(+)
 create mode 100755 tests/xfs/774
 create mode 100644 tests/xfs/774.out
 create mode 100755 tests/xfs/775
 create mode 100644 tests/xfs/775.out
 create mode 100755 tests/xfs/776
 create mode 100644 tests/xfs/776.out

