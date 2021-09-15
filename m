Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E05C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4F260F25
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhIOXna (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhIOXn3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:43:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 718FD60F25;
        Wed, 15 Sep 2021 23:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749329;
        bh=6lVmCYHgBI+Hirs2FY3g1JbQJFPc0cvn9QJFFJ7KnDI=;
        h=Subject:From:To:Cc:Date:From;
        b=RfItxXVFsVekymrHsLAD4KErMJtWi8Jzyqx7GUMra/MVAy19d5LWM/QWjrDVZi0zI
         q3DhERyo/bxcjOOJTPbyILWGKCI7YtsnN8FpDmexG63Y8FF4/z/knFlwgR6t3yOpnZ
         p2evtdEGmaaj7pnXc8wY2q6EUDrBhiqoDT3iL75wturMisUgAldVWLOCXBS8ysY6AU
         RGnsTboUD/HGyzo1yEtartoPnoBDWtUzYETiH0AfuVvAv+riaGQdTRJQBwInFec7Xh
         VO0ZDGIUO3dWIDGdAHxC+YeooQs+vLp7pUZHpROHS3X/dOHtU7G/DvgvlV1TzMKXvd
         em0ZbbXR7bpyQ==
Subject: [PATCHSET v2 0/3] fstests: regression tests for 5.13/5.14 rt fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:09 -0700
Message-ID: <163174932920.380708.6760780625209949972.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add regression tests to trigger some bugs in the realtime allocator that
were fixed in kernel 5.13 and 5.14.

v2: fix missing _supported_fs, fix a few random nits, and ensure all the
    regression tests refer to the fix commit id.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-fixes
---
 tests/xfs/774     |   81 +++++++++++++++++++++++++++
 tests/xfs/774.out |    5 ++
 tests/xfs/775     |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/775.out |    3 +
 tests/xfs/776     |   59 ++++++++++++++++++++
 tests/xfs/776.out |    5 ++
 tests/xfs/779     |  114 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/779.out |    2 +
 8 files changed, 428 insertions(+)
 create mode 100755 tests/xfs/774
 create mode 100644 tests/xfs/774.out
 create mode 100755 tests/xfs/775
 create mode 100644 tests/xfs/775.out
 create mode 100755 tests/xfs/776
 create mode 100644 tests/xfs/776.out
 create mode 100755 tests/xfs/779
 create mode 100644 tests/xfs/779.out

