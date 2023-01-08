Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3ECFC53210
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 18:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjAHSAt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 13:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjAHSAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 13:00:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9196165
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 10:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12076B80B36
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 18:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1B0C433EF;
        Sun,  8 Jan 2023 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673200843;
        bh=KjGLDcbhgHb1qfY5P/rfnFgt4YO2xoV96ADvcIkPSLQ=;
        h=Date:From:To:Cc:Subject:From;
        b=utHBZ26i9OUwBS4/TJn7xRgDJWEkpjKmi5QgjJEaf9Kzu+1oKEgpPcPFvMaptv5Av
         3bKVBTVHbTfdX1Lt5p0Neb+quLSTA+VZl6I1gtT13dSW/ZPZbf0Bf/NE73lxLbH5v0
         OKKrAjYz+a2tVdrFwa8TvEddumRJsqU3B+W6sDw/vBq/c4uze3JnW0Auc4m8TANooi
         xSMpCVnqBhHnFrhcBRnAnY5iCMap21pqkMBGKV3W5+Rkeuc1Ztnbo+ATXLqF2KgpB/
         sCAbLeMxFaknkeMWxLF16ChsD38L718MtZqM612VfmcFZ5C+SYW9i4qu6YlDmhlP+L
         P7A7zZV8qNKww==
Date:   Sun, 8 Jan 2023 10:00:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, shiina.hironori@fujitsu.com,
        wen.gang.wang@oracle.com, wuguanghao3@huawei.com,
        zeming@nfschina.com
Subject: [GIT PULL] xfs: bug fixes for 6.2
Message-ID: <167320037778.1795566.14815059333113369420.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with a pile of various bug fixes.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

Speaking of problems: I'm in the process of updating my gpg key so that
I can do ed25519 signatures, but I still suck at using gpg(1) so wish me
luck.  The -fixes-2 tag should be signed by the same old rsa4096 key
that I've been using.  I /think/ the -fixes-1 tag got signed with the
new subkey, but (afaict) the new subkey hasn't yet landed in
pgpkeys.git, so I went back to the old key so we can get the bugfixes
landed without blocking on maintainer stupidity.  Or at least more
stupidity than usual.

--D

The following changes since commit 1b929c02afd37871d5afb9d498426f83432e71c2:

Linux 6.2-rc1 (2022-12-25 13:41:39 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.2-fixes-2

for you to fetch changes up to 601a27ea09a317d0fe2895df7d875381fb393041:

xfs: fix extent busy updating (2023-01-05 07:34:21 -0800)

----------------------------------------------------------------
Fixes for 6.2-rc1:

- Remove some incorrect assertions.
- Fix compiler warnings about variables that could be static.
- Fix an off by one error when computing the maximum btree height that
can cause repair failures.
- Fix the bulkstat-single ioctl not returning the root inode when asked
to do that.
- Convey NOFS state to inodegc workers to avoid recursion in reclaim.
- Fix unnecessary variable initializations.
- Fix a bug that could result in corruption of the busy extent tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: don't assert if cmap covers imap after cycling lock
xfs: make xfs_iomap_page_ops static
xfs: fix off-by-one error in xfs_btree_space_to_height

Hironori Shiina (1):
xfs: get root inode correctly at bulkstat

Li zeming (1):
xfs: xfs_qm: remove unnecessary ‘0’ values from error

Wengang Wang (1):
xfs: fix extent busy updating

Wu Guanghao (1):
xfs: Fix deadlock on xfs_inodegc_worker

fs/xfs/libxfs/xfs_btree.c |  7 ++++++-
fs/xfs/xfs_extent_busy.c  |  1 +
fs/xfs/xfs_icache.c       | 10 ++++++++++
fs/xfs/xfs_ioctl.c        |  4 ++--
fs/xfs/xfs_iomap.c        |  2 +-
fs/xfs/xfs_qm.c           |  2 +-
fs/xfs/xfs_reflink.c      |  2 --
7 files changed, 21 insertions(+), 7 deletions(-)
