Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6C1C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJBSYu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJBSYs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED29B85F
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF11160EFD
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EFEC433D6;
        Sun,  2 Oct 2022 18:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735086;
        bh=PjRCFSSuoxJf7Icc2KdXlq3X6fUuWbLfhpTnyoarjPM=;
        h=Subject:From:To:Cc:Date:From;
        b=puqMgxFBEcoFkSF9e8QnwNNAdCpUi4ZttJDdaqimT8L4DtKe6UXrT02a3/Lb72XY0
         M4wHNamtrJWCp8ZO2VzjoBVHy2e+pLtIE7QQ4cSc+kRWSVUAXf+sjgg+ivesnLmg9l
         /ieG0M1p4KG95FxEn0EXMapNykMkCap+UIntj0/87srZL2i3gmQspxN5ZeLqjxV5PE
         8gmUJZMEN5mKxVM3j2jixBhoOsjHuvfHVZiHeUDk4qixN6mTbbiqYoUu9OJPSfLZwG
         SQq/DzEqdWNcdCmsFU6/QxMHaf9YAH7DwL/IwvbNn/q5ZiJR47gn2BlMAbLnUVhAcp
         ye/siuAkpSkhQ==
Subject: [PATCHSET v23.1 0/6] xfs: detect mergeable and overlapping btree
 records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:36 -0700
Message-ID: <166473483595.1084923.1946295148534639238.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While I was doing differential fuzz analysis between xfs_scrub and
xfs_repair, I noticed that xfs_repair was only partially effective at
detecting btree records that can be merged, and xfs_scrub totally didn't
notice at all.

For every interval btree type except for the bmbt, there should never
exist two adjacent records with adjacent keyspaces because the
blockcount field is always large enough to span the entire keyspace of
the domain.  This is because the free space, rmap, and refcount btrees
have a blockcount field large enough to store the maximum AG length, and
there can never be an allocation larger than an AG.

The bmbt is a different story due to its ondisk encoding where the
blockcount is only 21 bits wide.  Because AGs can span up to 2^31 blocks
and the RT volume can span up to 2^52 blocks, a preallocation of 2^22
blocks will be expressed as two records of 2^21 length.  We don't
opportunistically combine records when doing bmbt operations, which is
why the fsck tools have never complained about this scenario.

Offline repair is partially effective at detecting mergeable records
because I taught it to do that for the rmap and refcount btrees.  This
series enhances the free space, rmap, and refcount scrubbers to detect
mergeable records.  For the bmbt, it will flag the file as being
eligible for an optimization to shrink the size of the data structure.

The last patch in this set also enhances the rmap scrubber to detect
records that overlap incorrectly.  This check is done automatically for
non-overlapping btree types, but we have to do it separately for the
rmapbt because there are constraints on which allocation types are
allowed to overlap.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-detect-mergeable-records
---
 fs/xfs/scrub/alloc.c    |   31 +++++++++++-
 fs/xfs/scrub/bmap.c     |   39 +++++++++++++--
 fs/xfs/scrub/refcount.c |   50 +++++++++++++++++++
 fs/xfs/scrub/rmap.c     |  126 ++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 238 insertions(+), 8 deletions(-)

