Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA69C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiL3W0Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiL3W0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:26:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8378D2672
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:26:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EEE70CE193B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9D4C433D2;
        Fri, 30 Dec 2022 22:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439171;
        bh=5bUgCLEanfwvv6Npbn4lV8Kxdsh3qp6zTOtKakaA070=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MBslw9Q9kOQNA5AysDPG6nEkdpcqg6NZee0P0yyKy3dAHdmTJynv3W4Az2OzWGLfk
         1mijvpC/edWMU0VgtA86H8wh4MNeDXIDoYp7g0k7Cdo4GH5PjEfEBCVrIjx61o3taZ
         XzZ71z6eC5EzOrMhsj4M7qYmmjdSMg6pc2MRTnOpWmMY5py3XBHPEGNZ1vC7Mqpw6X
         Ro0q5PwLQQEnQqHG7RkYNiTUsgHkf7Me3c60dQ20q5PIVGbawva0G/9BzsK0INJDxk
         gmo/SPXj/hxRef5biZmIkj7g6/GJ4ybJ+EfIOMDIdiyvm2I+K63r/lYrVmn57oCgH5
         poERHNr7WhG5g==
Subject: [PATCHSET v24.0 0/6] xfs: detect incorrect gaps in refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:25 -0800
Message-ID: <167243828503.684405.18151259725784634316.stgit@magnolia>
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

The next few patchsets address a deficiency in scrub that I found while
QAing the refcount btree scrubber.  If there's a gap between refcount
records, we need to cross-reference that gap with the reverse mappings
to ensure that there are no overlapping records in the rmap btree.  If
we find any, then the refcount btree is not consistent.  This is not a
property that is specific to the refcount btree; they all need to have
this sort of keyspace scanning logic to detect inconsistencies.

To do this accurately, we need to be able to scan the keyspace of a
btree (which we already do) to be able to tell the caller if the
keyspace is empty, sparse, or fully covered by records.  The first few
patches add the keyspace scanner to the generic btree code, along with
the ability to mask off parts of btree keys because when we scan the
rmapbt, we only care about space usage, not the owners.

The final patch closes the scanning gap in the refcountbt scanner.

v23.1: create helpers for the key extraction and comparison functions,
       improve documentation, and eliminate the ->mask_key indirect
       calls

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-detect-refcount-gaps

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-refcount-gaps
---
 fs/xfs/libxfs/xfs_alloc.c          |   11 +-
 fs/xfs/libxfs/xfs_alloc.h          |    4 -
 fs/xfs/libxfs/xfs_alloc_btree.c    |   28 ++++-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   19 +++
 fs/xfs/libxfs/xfs_btree.c          |  208 ++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_btree.h          |  141 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   22 +++-
 fs/xfs/libxfs/xfs_refcount.c       |   11 +-
 fs/xfs/libxfs/xfs_refcount.h       |    4 -
 fs/xfs/libxfs/xfs_refcount_btree.c |   21 +++-
 fs/xfs/libxfs/xfs_rmap.c           |   15 ++-
 fs/xfs/libxfs/xfs_rmap.h           |    4 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |   61 ++++++++---
 fs/xfs/libxfs/xfs_types.h          |   12 ++
 fs/xfs/scrub/agheader.c            |    5 +
 fs/xfs/scrub/alloc.c               |    7 +
 fs/xfs/scrub/bmap.c                |   11 +-
 fs/xfs/scrub/btree.c               |   24 ++--
 fs/xfs/scrub/ialloc.c              |    2 
 fs/xfs/scrub/inode.c               |    1 
 fs/xfs/scrub/refcount.c            |  124 ++++++++++++++++++++-
 fs/xfs/scrub/rmap.c                |    6 +
 fs/xfs/scrub/scrub.h               |    2 
 23 files changed, 612 insertions(+), 131 deletions(-)

