Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B295C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 11:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbjFIL4D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 07:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbjFIL4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jun 2023 07:56:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEAB3C15
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 04:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 068D960B85
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 11:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA646C433EF
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 11:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686311671;
        bh=iAkgEk7QTcK2TwJOkuHj9NRlMGN5XZOFJAEG9/aZj68=;
        h=Date:From:To:Subject:From;
        b=haoYvNDFxlhkJnsAbUA5S3JYgoghCdnpZrTWfeVB8sYq2hRcb1USA8Skx6zXPDVWS
         ZKuE1h9HJWGjS/quxSTMeRUPap0lUbwTgZdVQrI1k/1WF2TE2YE/wSWFk2tMo4QKCJ
         eTAn456teeQrzF0+Ut9HQvINsJp7oXQjeHGdOgKB7rjPza3OASMUTpByJHYnkuoJf6
         dtzKjviockhElGXAfsV9ELH13REFGxLx+vfCz716tT+vJ5zz15eWEVSMr357q3oIK1
         FGtjOuSocW1bEiRhkX2z6c4t8n6TPY/mjur6WQU8VukOHZwfeTtzve2wvsADkHp3Ee
         WWChxPIywQObA==
Date:   Fri, 9 Jun 2023 13:54:27 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 7901c8c1a
Message-ID: <20230609115427.kj7ifiglf6lf5u6z@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

This update is focused only on a libxfs-sync for 6-4.


The new head of the for-next branch is commit:

7901c8c1a501de87c42bb1ed83456f99462538c6

33 new commits:

Carlos Maiolino (1):
      [361001978] libxfs: Finish renaming xfs_extent_item variables

Darrick J. Wong (30):
      [32debad7c] xfs: give xfs_bmap_intent its own perag reference
      [42c1e5c18] xfs: pass per-ag references to xfs_free_extent
      [7fef0c111] xfs: give xfs_extfree_intent its own perag reference
      [818f0c29d] xfs: give xfs_rmap_intent its own perag reference
      [b2c5c83de] xfs: give xfs_refcount_intent its own perag reference
      [11e716f40] xfs: create traced helper to get extra perag references
      [7cb26322f] xfs: allow queued AG intents to drain before scrubbing
      [c7005aef1] xfs: standardize ondisk to incore conversion for free space btrees
      [349aa6876] xfs: standardize ondisk to incore conversion for inode btrees
      [03d1a8719] xfs: standardize ondisk to incore conversion for refcount btrees
      [8d444a7a7] xfs: return a failure address from xfs_rmap_irec_offset_unpack
      [fd1d74cd6] xfs: standardize ondisk to incore conversion for rmap btrees
      [e70bf9ba9] xfs: complain about bad records in query_range helpers
      [7e7856cee] xfs: hoist rmap record flag checks from scrub
      [830c99b18] xfs: complain about bad file mapping records in the ondisk bmbt
      [b3c8146ec] xfs: hoist rmap record flag checks from scrub
      [71ba9fcca] xfs: hoist inode record alignment checks from scrub
      [c2d269677] xfs: fix rm_offset flag handling in rmap keys
      [98226d914] xfs: refactor converting btree irec to btree key
      [e3b15d883] xfs: refactor ->diff_two_keys callsites
      [9ba4dc828] xfs: replace xfs_btree_has_record with a general keyspace scanner
      [d99b89009] xfs: implement masked btree key comparisons for _has_records scans
      [725589ab4] xfs: remove pointless shadow variable from xfs_difree_inobt
      [54644f251] xfs: teach scrub to check for sole ownership of metadata objects
      [fc78c405d] xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results
      [898c05518] xfs: accumulate iextent records when checking bmap
      [bd970a739] xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation
      [0bf7f8c31] xfs: _{attr,data}_map_shared should take ILOCK_EXCL until iread_extents is completely done
      [2897a1c2f] xfs: don't unconditionally null args->pag in xfs_bmap_btalloc_at_eof
      [7901c8c1a] xfs: set bnobt/cntbt numrecs correctly when formatting new AGs

Dave Chinner (2):
      [44b2e0dea] xfs: don't consider future format versions valid
      [87ab47e1f] xfs: fix livelock in delayed allocation at ENOSPC

Code Diffstat:

 include/atomic.h            | 100 +++++++++++++
 include/platform_defs.h.in  |  20 +++
 include/xfs_mount.h         |  11 ++
 include/xfs_trace.h         |   4 +
 libxfs/defer_item.c         | 161 ++++++++++++++++----
 libxfs/libxfs_priv.h        |  23 ---
 libxfs/xfs_ag.c             |  42 ++++--
 libxfs/xfs_ag.h             |   9 ++
 libxfs/xfs_alloc.c          | 115 +++++++++-----
 libxfs/xfs_alloc.h          |  22 ++-
 libxfs/xfs_alloc_btree.c    |  32 +++-
 libxfs/xfs_bmap.c           |  44 +++++-
 libxfs/xfs_bmap.h           |   8 +-
 libxfs/xfs_bmap_btree.c     |  19 ++-
 libxfs/xfs_btree.c          | 204 ++++++++++++++++++-------
 libxfs/xfs_btree.h          | 141 ++++++++++++++++-
 libxfs/xfs_defer.c          |   6 +-
 libxfs/xfs_dir2.c           |   5 +-
 libxfs/xfs_dir2.h           |  31 ++++
 libxfs/xfs_ialloc.c         | 165 ++++++++++++--------
 libxfs/xfs_ialloc.h         |   7 +-
 libxfs/xfs_ialloc_btree.c   |  35 ++++-
 libxfs/xfs_ialloc_btree.h   |   2 +-
 libxfs/xfs_inode_fork.c     |  19 ++-
 libxfs/xfs_inode_fork.h     |   6 +-
 libxfs/xfs_refcount.c       | 117 +++++++++------
 libxfs/xfs_refcount.h       |  10 +-
 libxfs/xfs_refcount_btree.c |  31 +++-
 libxfs/xfs_rmap.c           | 358 ++++++++++++++++++++++++++++++--------------
 libxfs/xfs_rmap.h           |  38 +++--
 libxfs/xfs_rmap_btree.c     | 102 +++++++++----
 libxfs/xfs_sb.c             |  11 +-
 libxfs/xfs_types.h          |  12 ++
 repair/phase5.c             |  10 +-
 34 files changed, 1443 insertions(+), 477 deletions(-)

-- 
Carlos
