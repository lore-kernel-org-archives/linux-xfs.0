Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564B1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiL3XLr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:11:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FB9DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:11:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0E8FB81D91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E566C433EF;
        Fri, 30 Dec 2022 23:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441901;
        bh=Yrs2y9XOYuuUjG2NqXne2gfvnr5WAlTuTV0PnelKaKQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t2O582WvQeqhxEBEv0aTYDFqgaMLgn9ApoP49KtpMF7bW1Ikfd3NH6JWgqcXpEmKx
         BcvVWig7AGxAW5ap1B3Yrq7kxikcN6Q5CwNvRsqlGe5y41sc3+A9myIQrdRzE2QZyD
         zTqgsUI0ZioWILjR0sOqyyvtrKdqENqtRQQ019kTHNLTqmGJ6w1/1BpNcd24uhaifK
         cMXAPADnmYIccOakS1K9L4LnDUOXdcBHauUdDm3fuqgOKa+Gw62mMCtPeVdoTpF+RT
         rZXPdV1+wP52kxKXobeKgtW8hiHjyUt1R5nuUgdCn71fjweiwyhfuEoqOVUy5P6h47
         YZVNgJ8HNf7Gw==
Subject: [PATCHSET v24.0 0/5] xfs_repair: reduce refcount repair memory usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:52 -0800
Message-ID: <167243867247.712955.4006304832992035940.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The refcountbt repair code has serious memory usage problems when the
block sharing factor of the filesystem is very high.  This can happen if
a deduplication tool has been run against the filesystem, or if the fs
stores reflinked VM images that have been aging for a long time.

Recall that the original reference counting algorithm walks the reverse
mapping records of the filesystem to generate reference counts.  For any
given block in the AG, the rmap bag structure contains the all rmap
records that cover that block; the refcount is the size of that bag.

For online repair, the bag doesn't need the owner, offset, or state flag
information, so it discards those.  This halves the record size, but the
bag structure still stores one excerpted record for each reverse
mapping.  If the sharing count is high, this will use a LOT of memory
storing redundant records.  In the extreme case, 100k mappings to the
same piece of space will consume 100k*16 bytes = 1.6M of memory.

For offline repair, the bag stores the owner values so that we know
which inodes need to be marked as being reflink inodes.  If a
deduplication tool has been run and there are many blocks within a file
pointing to the same physical space, this will stll use a lot of memory
to store redundant records.

The solution to this problem is to deduplicate the bag records when
possible by adding a reference count to the bag record, and changing the
bag add function to detect an existing record to bump the refcount.  In
the above example, the 100k mappings will now use 24 bytes of memory.
These lookups can be done efficiently with a btree, so we create a new
refcount bag btree type (inside of online repair).  This is why we
refactored the btree code in the previous patchset.

The btree conversion also dramatically reduces the runtime of the
refcount generation algorithm, because the code to delete all bag
records that end at a given agblock now only has to delete one record
instead of (using the example above) 100k records.  As an added benefit,
record deletion now gives back the unused xfile space, which it did not
do previously.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-refcount-scalability

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-refcount-scalability
---
 libxfs/libxfs_api_defs.h |    8 +
 libxfs/xfs_btree.c       |    3 
 libxfs/xfs_btree.h       |    1 
 libxfs/xfs_shared.h      |    1 
 libxfs/xfs_types.h       |    6 -
 repair/Makefile          |    4 
 repair/rcbag.c           |  404 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rcbag.h           |   33 ++++
 repair/rcbag_btree.c     |  394 +++++++++++++++++++++++++++++++++++++++++++++
 repair/rcbag_btree.h     |   78 +++++++++
 repair/rmap.c            |  159 +++++-------------
 repair/slab.c            |  130 ---------------
 repair/slab.h            |   19 --
 repair/xfs_repair.c      |    6 +
 14 files changed, 982 insertions(+), 264 deletions(-)
 create mode 100644 repair/rcbag.c
 create mode 100644 repair/rcbag.h
 create mode 100644 repair/rcbag_btree.c
 create mode 100644 repair/rcbag_btree.h

