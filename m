Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A628C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbiL3W1d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiL3W1b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:27:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4164A1C90C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:27:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D251E61C17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC15C433EF;
        Fri, 30 Dec 2022 22:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439249;
        bh=gKIn+JI/KPvXlfwNEgVDiEMBAwh9crkiSgSXA/d3wz4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mIPnoTzbt8HDVZe1GDfxTWJwOJQ4VHxcPki18O9dZWRFAT38WSFp521rwNvebZk2s
         4K9vorPEQtAWE4IFdLxw87phFWd4WOvW/BSsenZkt3+xpah2r4NuKSAYJoh1mA/jRW
         SXLbn+mpHVB7/YcTl/JjWZEKvqoD7b/zVVwxNIFlEbgIFUm+rtjf1MgWW/XKSyRbC0
         86TNaomlS0Bqzyw0QBX+Fexh/xhDF3EGyI9r134X2oOhXKrbq5uVf9QCw1ZcvqOz8b
         1sRRqxZdZnglMc0J825HeVw2GHS5zWlveCqjFvLWu1PfMxqFD2AJ+fb+C0XfZW90uM
         HUIAUHmgeKUcw==
Subject: [PATCHSET v24.0 0/6] xfs: detect mergeable and overlapping btree
 records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:42 -0800
Message-ID: <167243830218.686829.12866790282629472160.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
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
 fs/xfs/scrub/alloc.c    |   29 ++++++++++-
 fs/xfs/scrub/bmap.c     |   39 +++++++++++++--
 fs/xfs/scrub/refcount.c |   44 ++++++++++++++++
 fs/xfs/scrub/rmap.c     |  126 ++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 230 insertions(+), 8 deletions(-)

