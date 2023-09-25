Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D079E6FE30
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjIYVnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbjIYVnQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:43:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C63EA2;
        Mon, 25 Sep 2023 14:43:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF7FC433C7;
        Mon, 25 Sep 2023 21:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695678189;
        bh=ELtCmMlsLkQTGdWDzIZjQwwCPi0csEz3rFDwT3jJiPY=;
        h=Subject:From:To:Cc:Date:From;
        b=M6isFOHzBeqW55MzHkDSsTwk2+nhl9uB0+Lxr1g4xC7GK+9aQH3NvZnSo/DPFGMs9
         g76Px2k5QkoCdShdCiIQYbhSHYIFgbrdm0wSiflnZC232H8VzHhVtWwuB99J8fbFMj
         wq06ews0aoCaCEm9ef/6hBOAX1UVvC7XV7Z5xtRi6vKe7/+g71FbAzVBi+HCVrCJtR
         sSxifHTfnDU9fRumXpCzzRkcUBjnKFDP6wN+BU93e5jKR5a5lS/lYu4cmiChIlGAGr
         paORWHytaTXd8oVMJSE4yUeXtCzLaV7bJ6z7s9I9gcBS4CHoN/MrpOpP+qpSFz/yrs
         XOISk7r3QL0PA==
Subject: [PATCHSET v2 0/1] fstests: fix unshare data corruption bug
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        ritesh.list@gmail.com, willy@infradead.org
Date:   Mon, 25 Sep 2023 14:43:08 -0700
Message-ID: <169567818883.2270025.5159423425609776304.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I rebased djwong-dev atop 6.6-rc1, and discovered that the iomap unshare
code writes garbage into the unshared file if the unshared range covers
at least one base page's worth of file range and there weren't any
folios in the pagecache for that region.

The root cause is an optimization applied to __iomap_write_begin for 6.6
that caused it to ignore !uptodate folios.  This is fine for the
write/zeroing cases since they're going to write to the folio anyway,
but unshare merely marks the folio dirty and lets writeback handle the
unsharing.

While I was rooting around in there, I also noticed that the unshare
operation wasn't ported to use large folios.  This leads to suboptimal
performance if userspace funshares a file and continues using the page
cache, since the cache is now using base pages.

v2: reduce redundant variable access

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=iomap-fix-unshare

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=iomap-fix-unshare
---
 tests/xfs/1936     |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1936.out |    4 ++
 2 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/1936
 create mode 100644 tests/xfs/1936.out

