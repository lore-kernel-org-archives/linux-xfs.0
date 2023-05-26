Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1E3C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjEZAdZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjEZAdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:33:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E09194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7264D64B87
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60A0C433D2;
        Fri, 26 May 2023 00:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061201;
        bh=E9VVPx2jCwCKhx5mYp/e0rkX8ThAhHhm1gFQDGo3Mpc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=aTZTPqm/sMjC5MSbyTTxHqhrosIGyq7ZZr0Dfenb2ij3hP83PpH83qg1czrY83LDB
         3r7hXsrMsOfljZzFLRGVgPU1z+GBI5+0g/pjv8xU9yyA18HwYqGu95ek3MefUpkLQd
         V+WIVk7BRCjpq/JAevghOF/OEMMaRemrugEmm48bzrDiH+JIW44rabbVOLrkhfJEPO
         7MNzzNRRgINbtyRr4hYKQICN5CjNtb4AMnlsDKQNEtL7xdOGpVurTInPfSwPnaS6PH
         dizZQrQc9llGZfkGxQ5nRTymtbzpk0E+eJvUvH76hOH4Zz22YOxpxxRKJtqSaZPKhG
         /Pm9zbo9vcEfQ==
Date:   Thu, 25 May 2023 17:33:21 -0700
Subject: [PATCHSET v25.0 0/4] xfs: reduce refcount repair memory usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063115.3733778.10696213835208138453.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
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
 fs/xfs/Makefile                    |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 
 fs/xfs/libxfs/xfs_btree.c          |   24 --
 fs/xfs/libxfs/xfs_btree.h          |    4 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 
 fs/xfs/libxfs/xfs_types.h          |    6 -
 fs/xfs/scrub/rcbag.c               |  331 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag.h               |   28 +++
 fs/xfs/scrub/rcbag_btree.c         |  372 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag_btree.h         |   83 ++++++++
 fs/xfs/scrub/refcount.c            |   12 +
 fs/xfs/scrub/refcount_repair.c     |  155 +++++----------
 fs/xfs/scrub/repair.h              |    2 
 fs/xfs/scrub/trace.h               |    1 
 fs/xfs/xfs_super.c                 |   10 +
 fs/xfs/xfs_trace.h                 |    1 
 19 files changed, 911 insertions(+), 128 deletions(-)
 create mode 100644 fs/xfs/scrub/rcbag.c
 create mode 100644 fs/xfs/scrub/rcbag.h
 create mode 100644 fs/xfs/scrub/rcbag_btree.c
 create mode 100644 fs/xfs/scrub/rcbag_btree.h

