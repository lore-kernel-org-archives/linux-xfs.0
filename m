Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89D7C27C40
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjKVXHs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbjKVXHr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F87C1A8
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D84C433C8;
        Wed, 22 Nov 2023 23:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694463;
        bh=GC3YC0tyjIG724pBgGqhjYxfIhc3kRU3QkNk41K4QDo=;
        h=Subject:From:To:Cc:Date:From;
        b=tSltunhRyDtJjFTl7zutV0eY94BLlzUGw9sla+lrIqOI3U6kG0ZTW1G14r+BCnkmv
         a/LUl8XpciYkX1aWu7Hh6vr3794qgk7YpDfDLkVocxZSUj1wGd3ppT5PNsnM/Pxgdc
         4AENxtlNCL7zaGSjnDZ24AUtIls9/NPakyurw8kXvtnLYZkncCrlCANQmOpZkrRjap
         MdcxgZXijmEQkdqJTQpkxqXUHA0Xj8VyXPn3CCjqbMQw93qyeX86MCV4znNFyXh1RN
         TXWqwJ/UaNcovpPkMa88mQn5qBoXHUxoEvxqlCpB8wKSb6ZBEMxHDs4mYBmOAgIl9L
         d0T9KE8pCrcyg==
Subject: [PATCHSET v27.0 0/4] xfsprogs: force rebuilding of metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:43 -0800
Message-ID: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-force-rebuild
---
 io/scrub.c        |   24 ++++++++++++++-------
 man/man8/xfs_io.8 |    3 +++
 scrub/phase1.c    |   28 ++++++++++++++++++++++++
 scrub/scrub.c     |   61 ++++++++++++++++++++++++++++-------------------------
 scrub/scrub.h     |    1 +
 scrub/vfs.c       |    2 +-
 scrub/xfs_scrub.c |    3 +++
 scrub/xfs_scrub.h |    1 +
 8 files changed, 85 insertions(+), 38 deletions(-)

