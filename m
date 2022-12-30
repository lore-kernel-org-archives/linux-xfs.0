Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC58C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiLaA7N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiLaA7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:59:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21B0F03A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE0661D6D
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1270C433EF;
        Sat, 31 Dec 2022 00:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448350;
        bh=KSifPbI2TubakbpoOuz2AdtimWEwgpekPN42CDIxqFw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fUI381IjufYp9DKyPQmZXHA6OJ+D0QlvPU9PnjFQMj8+TM0IebUyGHrnwXexNt/sV
         gJrjIhebGlupD0nT9a/9ke5zl2/hH2jdSBRhbTleN/IBA/rFkXwhP2VM4X5Ze3IT1B
         Wt/UHfzv3/yT/nLgW8BA3hv4aoEVkQI82Xq5rFTnSHlRQ7MLQM9H0kSDdOfHdjpOTz
         cw6feMZYNVYleoLiFS3AAW9ywr2BUCVKGjVx9Dt+fzrkpKuWU5FnAMMITaKfM/0Vb6
         gOq9tJCexngwmsTCUwXpd4z2fGY+mlJB2u+pFzntbxpoJl/ZzTaCDZ43Q9Net+EL2E
         R72DqhLjDF10A==
Subject: [PATCHSET v1.0 0/9] xfs: reflink with large realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871792.718512.13170681692847163098.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've landed support for reflink on the realtime device for
cases where the rt extent size is the same as the fs block size, enhance
the reflink code further to support cases where the rt extent size is a
power-of-two multiple of the fs block size.  This enables us to do data
block sharing (for example) for much larger allocation units by dirtying
pagecache around shared extents and expanding writeback to write back
shared extents fully.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink-extsize

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-extsize
---
 fs/dax.c                      |    5 +
 fs/iomap/buffered-io.c        |   55 ++++++++++
 fs/remap_range.c              |   30 +++---
 fs/xfs/libxfs/xfs_bmap.c      |   22 ++++
 fs/xfs/libxfs/xfs_inode_buf.c |   20 +---
 fs/xfs/xfs_aops.c             |   40 +++++++
 fs/xfs/xfs_file.c             |  171 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h            |    9 ++
 fs/xfs/xfs_iops.c             |   15 +++
 fs/xfs/xfs_reflink.c          |  220 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_rtalloc.c          |    3 -
 fs/xfs/xfs_super.c            |   17 ++-
 fs/xfs/xfs_trace.h            |    4 +
 include/linux/fs.h            |    3 -
 include/linux/iomap.h         |    2 
 15 files changed, 574 insertions(+), 42 deletions(-)

