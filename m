Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1A1C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Mar 2022 16:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbiC0Q76 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Mar 2022 12:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiC0Q75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Mar 2022 12:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1BBDF4C
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 09:58:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCDC860FB7
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 16:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294A1C340EC;
        Sun, 27 Mar 2022 16:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648400297;
        bh=sfUrq19713eaz7MM5DTlhacgEA2UmvoHF12T1qRRi10=;
        h=Subject:From:To:Cc:Date:From;
        b=ko5rmV1E9bWzSsvcHXoa3csIurMCz3xqU7ui5u6+VM3Sv3CD3wJWm8uunbEeTzoJP
         xFAu08eTPADASM8vSj63A/5C497FbHx7T1nht54/z5HjSl7F3vuPa5FFqdsPA90QpZ
         DE74RKUZrImq+6hRNd8FGJDxD1YlrmpD+Aa9eFlkwGeIo8UbpJukzAF3571IRWyjNZ
         CQMggolqqKP7U49gXLdMHaidoKgItdJ+LQd8VTILoQ4A+nYMr4PlM9S+35zeQTIroj
         OS1Pzt1cUy8bPVAq4+rm4bqa8udxQ4GAf8hOqQwccJxfssB73IyhvgQlfuFwxThYEK
         UqK3fNKGHdbng==
Subject: [PATCHSET v4 0/6] xfs: fix incorrect reserve pool calculations and
 reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 27 Mar 2022 09:58:16 -0700
Message-ID: <164840029642.54920.17464512987764939427.stgit@magnolia>
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

v4: It turns out I was wrong about the purpose of alloc_set_aside, so
fix the new comments in the first patch, delete the last patch, and
leave the "btree split calculations" for another patchset.  Eliminate
the looping behavior in xfs_reserve_blocks, and fix a case where we
could race to set the pool size and thereby overfill it.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-block-fixes-5.18
---
 fs/xfs/libxfs/xfs_alloc.c |   28 +++++++++++++++++++----
 fs/xfs/libxfs/xfs_alloc.h |    1 -
 fs/xfs/xfs_fsops.c        |   54 ++++++++++++++++++---------------------------
 fs/xfs/xfs_mount.c        |    2 +-
 fs/xfs/xfs_mount.h        |   15 +++++++++++++
 fs/xfs/xfs_super.c        |    3 ++-
 6 files changed, 63 insertions(+), 40 deletions(-)

