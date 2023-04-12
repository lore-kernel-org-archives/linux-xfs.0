Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A32AC77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDLDqZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLDqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:46:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D26830E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED83262D90
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5006FC433D2;
        Wed, 12 Apr 2023 03:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271182;
        bh=pxK0DeFHR5lAfAIy65l7dDNU/8USpiP5ERz1sRzEL6c=;
        h=Date:Subject:From:To:Cc:From;
        b=B+pvLjG/5TQxxyLOb7/eeTjoNMeCCehd3/poSFt6WvmkJzbTOn9/ir9ioQWN1bmSW
         PWrF4lGD91tppp1zZ3v0WgOOwlcSvyVmsJYoOpBD8cpXym5Zxbeb+g6WtHkO8LYHKy
         1bZ7zoqDeqBPxXFGnc8JMROx/SF/m6jMvmLmazHbnTMEVZgi2Y1iqX9kYk78y07h7N
         l2KOCx22i7jVuvecbuzx84dGwhBqVXUFRro4pz6gJFSiwxPCOMXjyWPDa7FQ8EgH/+
         lr5e2IhB7+ohylc0rd/148V2P/P/5RkbzREnjTXLwFtKyyCQNEZVNeHcFrCe+WLoo3
         t7+mgN6yrFYmA==
Date:   Tue, 11 Apr 2023 20:46:21 -0700
Subject: [GIT PULL 6/22] xfs: standardize btree record checking code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094258.417736.16899254677069613479.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 88accf17226733088923635b580779a3c86b6f23:

xfs: scrub should use ECHRNG to signal that the drain is needed (2023-04-11 19:00:00 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/btree-complain-bad-records-6.4_2023-04-11

for you to fetch changes up to 6a3bd8fcf9afb47c703cb268f30f60aa2e7af86a:

xfs: complain about bad file mapping records in the ondisk bmbt (2023-04-11 19:00:05 -0700)

----------------------------------------------------------------
xfs: standardize btree record checking code [v24.5]

While I was cleaning things up for 6.1, I noticed that the btree
_query_range and _query_all functions don't perform the same checking
that the _get_rec functions perform.  In fact, they don't perform /any/
sanity checking, which means that callers aren't warned about impossible
records.

Therefore, hoist the record validation and complaint logging code into
separate functions, and call them from any place where we convert an
ondisk record into an incore record.  For online scrub, we can replace
checking code with a call to the record checking functions in libxfs,
thereby reducing the size of the codebase.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
xfs: standardize ondisk to incore conversion for free space btrees
xfs: standardize ondisk to incore conversion for inode btrees
xfs: standardize ondisk to incore conversion for refcount btrees
xfs: return a failure address from xfs_rmap_irec_offset_unpack
xfs: standardize ondisk to incore conversion for rmap btrees
xfs: standardize ondisk to incore conversion for bmap btrees
xfs: complain about bad records in query_range helpers
xfs: complain about bad file mapping records in the ondisk bmbt

fs/xfs/libxfs/xfs_alloc.c        | 82 ++++++++++++++++++++++++----------
fs/xfs/libxfs/xfs_alloc.h        |  6 +++
fs/xfs/libxfs/xfs_bmap.c         | 31 ++++++++++++-
fs/xfs/libxfs/xfs_bmap.h         |  2 +
fs/xfs/libxfs/xfs_ialloc.c       | 77 +++++++++++++++++++++-----------
fs/xfs/libxfs/xfs_ialloc.h       |  2 +
fs/xfs/libxfs/xfs_ialloc_btree.c |  2 +-
fs/xfs/libxfs/xfs_ialloc_btree.h |  2 +-
fs/xfs/libxfs/xfs_inode_fork.c   |  3 +-
fs/xfs/libxfs/xfs_refcount.c     | 73 +++++++++++++++++++-----------
fs/xfs/libxfs/xfs_refcount.h     |  2 +
fs/xfs/libxfs/xfs_rmap.c         | 95 +++++++++++++++++++++++++---------------
fs/xfs/libxfs/xfs_rmap.h         | 12 +++--
fs/xfs/scrub/alloc.c             | 24 +++++-----
fs/xfs/scrub/bmap.c              |  6 +++
fs/xfs/scrub/ialloc.c            | 24 ++--------
fs/xfs/scrub/refcount.c          | 14 ++----
fs/xfs/scrub/rmap.c              | 44 ++-----------------
18 files changed, 303 insertions(+), 198 deletions(-)

