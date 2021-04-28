Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AEBC43460
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F475613F4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhD1EJt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhD1EJm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D49D60720;
        Wed, 28 Apr 2021 04:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582935;
        bh=nHmM5T+jg3jU0QDrnPNd8CsDh1EpI6zE35r3Rxs1cxQ=;
        h=Subject:From:To:Cc:Date:From;
        b=cZ3ZJX4JkA3w+2xs1YJ9TD8uQqGXEpDzTHQ7Ay2t4Xn2VCiCOat990gGiQEVu+2Tl
         u3+O99qZuL2b7sBFvQ5wC6IZPDUfqoylYoioiszgdOEwLrcoOFIQy1DBXqlcUhNKlY
         bwa/YNdT7zkbhjagiWabgAF5vIcayLpqk6AYiluoEAYg2+2UrAcTB+VqmTpv+LPbQk
         Za3Bv38YQNpsGrS9jkecIXWd5Lq7aOp95MT0IZ9t1subQxL43wHqQem6XAVlXVbhn8
         384+ifC9W6nAmkuDE9aEcrQxa/aPHd7xkMmqscEHGXyt8h3rZf4QjpifSUTy0915AQ
         UBE0hrdpwlTOQ==
Subject: [PATCHSET 0/5] fstests: miscellaneous fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:08:54 -0700
Message-ID: <161958293466.3452351.14394620932744162301.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Various small fixes to the fstests suite.

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
 common/rc         |    3 ++-
 tests/generic/094 |    2 +-
 tests/generic/225 |    2 +-
 tests/generic/449 |    5 +++++
 tests/xfs/004     |    4 ++++
 tests/xfs/276     |    2 +-
 tests/xfs/491     |    5 +++++
 tests/xfs/492     |    5 +++++
 8 files changed, 24 insertions(+), 4 deletions(-)

