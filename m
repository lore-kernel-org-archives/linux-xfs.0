Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2C4C4320E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC626102A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242467AbhIAAMV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242516AbhIAAMV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3898161008;
        Wed,  1 Sep 2021 00:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455085;
        bh=9rmTOebBJBSUwqnbz9CkkTk9AUlv9HIKGPcLxA0BDHk=;
        h=Subject:From:To:Cc:Date:From;
        b=iZjCA8dtaJAGCOT1uDQI0JiaWKoADQMD348yrX64zwz7YRf2jWDUTNvx/pNsF65Eq
         uThFHlOHVQKnSv6F+FntLDfQqlQ1UWntH4Gme1PVsBn9LF3RABwUXtqNaBd7uw6kN4
         dozd4T7VogoWsmenvl/HXj9s7N/wFD9xSwJeiIbt2iK3UUVCLBQiNPTfGfPGD4Rl/x
         a3tq1cKLnm7lmJHn7HaL9mAogop/4HytiP+0PnkAkjcQgk9OXL0Dj2rkjoKMa7jk3P
         V8G8rSu3zcIY4bB/gZmGTQfBcRIV5Q5Guw021YMTL/qtYE6VlQK0SCSMqEvdaRnrub
         5eeMt44TBbXxA==
Subject: [PATCHSET 0/3] fstests: regression tests for 5.13/5.14 rt fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:11:24 -0700
Message-ID: <163045508495.769915.4859353445119566326.stgit@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-fixes
---
 tests/xfs/774     |   80 ++++++++++++++++++++++++++
 tests/xfs/774.out |    5 ++
 tests/xfs/775     |  165 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/775.out |    3 +
 tests/xfs/776     |   57 ++++++++++++++++++
 tests/xfs/776.out |    5 ++
 tests/xfs/779     |  112 ++++++++++++++++++++++++++++++++++++
 tests/xfs/779.out |    2 +
 8 files changed, 429 insertions(+)
 create mode 100755 tests/xfs/774
 create mode 100644 tests/xfs/774.out
 create mode 100755 tests/xfs/775
 create mode 100644 tests/xfs/775.out
 create mode 100755 tests/xfs/776
 create mode 100644 tests/xfs/776.out
 create mode 100755 tests/xfs/779
 create mode 100644 tests/xfs/779.out

