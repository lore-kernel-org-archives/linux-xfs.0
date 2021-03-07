Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25456C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 20:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E413665165
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 20:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhCGU0F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 15:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232859AbhCGUZl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Mar 2021 15:25:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF1E565165;
        Sun,  7 Mar 2021 20:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615148741;
        bh=umQvuiTX1khcHU9EsyeVadb3ERM7TROL6fYMVW+B8/c=;
        h=Subject:From:To:Cc:Date:From;
        b=YhinxmFjS7GT5zIx5CEc+ErF8t/O6XaNePo50W5MzePHfhGEAt1BrIzwJJaZfikI/
         c1zEVZS9BCUUu/VtOMLceFl6bpkYRn5icc7GfksaKW1e7b0GswBK3aciqTlZhPZeqo
         wZwWcLnAwsvvn8NHD8GDH8AnNPtyBMet7zc/RUGXS/LZw0JvVD5b5n4qkqI3giDclK
         X9En+YI7qs6JPHRozNPGlgXPjSQat+/KZsb0G5iWFfnaiw0H1ZJ8sufpb9vwkGDKx8
         uKLaVRoJWBLj5tJT5Ku7U7VaiKQx+Bvg/WtHtgfX8pqhzUr/KBkskccawAEP06sQ6G
         UnKPL/1encDkg==
Subject: [PATCHSET v2 0/4] xfs: small fixes for 5.12
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Date:   Sun, 07 Mar 2021 12:25:40 -0800
Message-ID: <161514874040.698643.2749449122589431232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a handful of bug fixes for 5.12.  The first one fixes a bug in
quota accounting on idmapped mounts; the second avoids a buffer deadlock
in bulkstat/inumbers if the inobt is corrupt; and the third fixes a
mount hang if mount fails after creating (or otherwise dirtying) the
quota inodes.

v2: remove unnecessary freeze protection from fsmap, refactor shared
    parts of unmount code, tweaks to the itable deadlock detection

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.12
---
 fs/xfs/xfs_fsmap.c   |   14 +++----
 fs/xfs/xfs_inode.c   |   14 ++++---
 fs/xfs/xfs_itable.c  |   40 ++++++++++++++++++--
 fs/xfs/xfs_iwalk.c   |   32 ++++++++++++++--
 fs/xfs/xfs_mount.c   |  100 +++++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_symlink.c |    3 +-
 6 files changed, 132 insertions(+), 71 deletions(-)

