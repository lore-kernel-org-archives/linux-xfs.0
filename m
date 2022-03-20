Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2237AC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Mar 2022 16:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbiCTQoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 12:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiCTQox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 12:44:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405641EECD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 09:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0371FB80EDE
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA99C340E9;
        Sun, 20 Mar 2022 16:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647794607;
        bh=5/4yav/scMjXjE/0KwasTudzDsaf59cXMdXPoWGqrZU=;
        h=Subject:From:To:Cc:Date:From;
        b=Fa6SFNW3nO1uOBvq3SA/9F0meN2oC8x0nWbv1J3fx/kpkm5+JX5BiQ1YK61Bs4qK7
         3z0KVMHznIf3vLHFu+LjMuJvaFW0rwcws7pTB9EdgnS6UEGx69vChQOGLiUCRQBqKE
         j4/12dseH7HrEN1xkJuDZYULoc71gz9slbV4J52pzcFW685nnvXvfDb52O8VFaeWoZ
         yN1oTObV+NNSNCXUJPVcwrCWmEw4EzeSE3X7CAhMvVWwJerRF3G5YLKV8oyfoR5xm2
         0uso6WG1eKbl+wVRkQ4g59nM1rMbmpArnBgsmUjvOEgvXkOlwpVmhJqNBMNNoAXOJr
         seGck6mpMuMHg==
Subject: [PATCHSET v3 0/6] xfs: fix incorrect reserve pool calculations and
 reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 20 Mar 2022 09:43:27 -0700
Message-ID: <164779460699.550479.5112721232994728564.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Last week, I was running xfs/306 (which formats a single-AG 20MB
filesystem) with an fstests configuration that specifies a 1k blocksize
and a specially crafted log size that will consume 7/8 of the space
(17920 blocks, specifically) in that AG.  This resulted mount hanging on
the infinite loop in xfs_reserve_blocks because we overestimate the
number of blocks that xfs_mod_fdblocks will give us, and the code
retries forever.

v2: Initially, this was a single patch that fixed the calculation and
transformed the loop into a finite loop.  However, further discussion
revealed several more issues:

 * People had a hard time grokking that the "alloc_set_aside" is
   actually the amount of space we hide so that a bmbt split will always
   succeed;
 * The author didn't understand what XFS_ALLOC_AGFL_RESERVE actually
   mean or whether it was correctly calculated;
 * The "alloc_set_aside" underestimated the blocks needed to handle any
   bmap btree split;
 * Both statfs and XFS_IOC_FSCOUNTS forgot to exclude the amount of
   space used by the free space btrees on behalf of per-AG reservations,
   leading to overreporting of available space;
 * The loop control change really should have been separate.

Hence, this patchset has now grown to six patches to address each of
these issues separately.

v3: only add one helper for calculating the total fdblocks setaside and
tighten some documentation

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-block-fixes-5.18
---
 fs/xfs/libxfs/xfs_alloc.c |   30 +++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_alloc.h |    3 +--
 fs/xfs/libxfs/xfs_sb.c    |    2 --
 fs/xfs/xfs_fsops.c        |   18 +++++++++++++-----
 fs/xfs/xfs_log_recover.c  |    2 +-
 fs/xfs/xfs_mount.c        |    9 ++++++++-
 fs/xfs/xfs_mount.h        |   18 +++++++++++++++++-
 fs/xfs/xfs_super.c        |    3 ++-
 8 files changed, 65 insertions(+), 20 deletions(-)

