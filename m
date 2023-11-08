Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4B7C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 21:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjKHV30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKHV30 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 16:29:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104AD2586
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 13:29:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC436C433C9;
        Wed,  8 Nov 2023 21:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699478963;
        bh=lqdUq1BT0SiiIXlHKNFMwHYoDoCphfCt83UQy6yVFdA=;
        h=Subject:From:To:Cc:Date:From;
        b=TAQN0cED5xfGFg1JYqt20cN382cmK5NjPtF4XSfdL6/oaU/SHGIOHhCFO+uQwqqQZ
         hVKREs+/IGmRtdDVFBhnYXXk8OXpKLEsIpyNqE3roRxwZQR4wwVJPnRgEdayIMNyq/
         zBLeauWuBQ+v5Qyai6lzSgeG6lvdEj988c7FdvwgQSogUHkOabJZ34nfxp28maOarW
         xfLyFSrq++CpADNP+mwPSnEyJNWN9OQowQu8RcbIcYk5hbeZ4KLi3AoyjO9f09t6XO
         ByDOTBbrhWUfSiB2bnNbmW9VtckpgkeeVn6k4569qlulKhQH7sUGVMr4VVeXCDgYWT
         xMKCrHFRlyOiQ==
Subject: [PATCHSET 0/1] fstests: updates for Linux 6.7
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Catherine Hoang <catherine.hoang@oracle.com>, guan@eryu.me,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date:   Wed, 08 Nov 2023 13:29:23 -0800
Message-ID: <169947896328.203781.17647180888752123384.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is pending fixes for things that are going to get merged in 6.7.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-merge-6.7

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-merge-6.7
---
 configure.ac              |    1 
 include/builddefs.in      |    1 
 m4/package_libcdev.m4     |   12 ++
 src/Makefile              |    4 +
 src/t_reflink_read_race.c |  339 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1953        |   74 ++++++++++
 tests/generic/1953.out    |    6 +
 7 files changed, 437 insertions(+)
 create mode 100644 src/t_reflink_read_race.c
 create mode 100755 tests/generic/1953
 create mode 100644 tests/generic/1953.out

