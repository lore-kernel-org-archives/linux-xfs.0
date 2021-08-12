Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D7EC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929ED6108C
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhHLXbu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhHLXbt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0F396108C;
        Thu, 12 Aug 2021 23:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811083;
        bh=l141MLID2SXeAVsbcunVLbAmPmXsKY3XadVg7/6lnz4=;
        h=Subject:From:To:Cc:Date:From;
        b=KqzbM2pXgqKqHjODWsf37fFu+rwicOD3GFu4g1vMxGN860KQzsJlTUEQbvFWvFHRb
         3J9Kx2DUhGRvIFZRewAZh29cmHUTiMsUCNuN3fSk4HjbzF97kSBaVRc53H6jL2DSRr
         kxzPvsjxYAi3T5wBg9sOxWxQjUWDGxAYZO/HVxjAHuUeMOQy8ApobYwcTT19uj/IWS
         pvKek5EB0gP/8ShfEQvbAnCMpH9UvcQ26qQMxoxLQzPJYdc5Vagp6qqmp1Cr1u1hym
         HPE8ferW8UV2vxEtLgHEccCWPGphO4FbLi3oRlv4lC/ERbPrMy03SmifjC2mS2G8kQ
         rOgHUioB22PaQ==
Subject: [PATCHSET 00/10] xfs: constify btree operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:31:23 -0700
Message-ID: <162881108307.1695493.3416792932772498160.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

After finishing the bug fixes in the previous series, the thought
occurred to me that I really ought to check the main index query
functions around XFS and make sure that they weren't changing their
arguments either.  Since btrees are one of the major data structure
types in XFS, I decided to concentrate there.

Starting with the query_range and query_all functions, I started
constifying the btree record and key parameters to make sure that the
query functions don't modify the search parameters and that the callback
functions don't modify the record pointer that is passed from the range
query function.  That spiralled from there into a full blown audit of
all the btree predicates and extraction functions; many of them could be
constified too.

AFAICT there's almost no change in the generated code, which is what
you'd expect since there was only one query range caller in the entire
codebase that actually messed with caller memory.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=constify-btree-5.15
---
 fs/xfs/libxfs/xfs_alloc.c          |    6 +-
 fs/xfs/libxfs/xfs_alloc.h          |   10 ++--
 fs/xfs/libxfs/xfs_alloc_btree.c    |   94 ++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |   48 +++++++++---------
 fs/xfs/libxfs/xfs_bmap_btree.h     |    7 ++-
 fs/xfs/libxfs/xfs_btree.c          |   84 ++++++++++++++++----------------
 fs/xfs/libxfs/xfs_btree.h          |   56 +++++++++++----------
 fs/xfs/libxfs/xfs_btree_staging.c  |   14 +++--
 fs/xfs/libxfs/xfs_ialloc.c         |    4 +-
 fs/xfs/libxfs/xfs_ialloc.h         |    3 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   70 +++++++++++++--------------
 fs/xfs/libxfs/xfs_refcount.c       |    4 +-
 fs/xfs/libxfs/xfs_refcount.h       |    2 -
 fs/xfs/libxfs/xfs_refcount_btree.c |   48 +++++++++---------
 fs/xfs/libxfs/xfs_rmap.c           |   28 +++++------
 fs/xfs/libxfs/xfs_rmap.h           |   11 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     |   64 ++++++++++++-------------
 fs/xfs/scrub/agheader.c            |    2 -
 fs/xfs/scrub/agheader_repair.c     |    4 +-
 fs/xfs/scrub/alloc.c               |    2 -
 fs/xfs/scrub/bmap.c                |   29 ++++++-----
 fs/xfs/scrub/btree.h               |    4 +-
 fs/xfs/scrub/common.c              |    2 -
 fs/xfs/scrub/ialloc.c              |    2 -
 fs/xfs/scrub/refcount.c            |    4 +-
 fs/xfs/scrub/repair.c              |    2 -
 fs/xfs/scrub/rmap.c                |    2 -
 fs/xfs/scrub/rtbitmap.c            |    2 -
 fs/xfs/xfs_fsmap.c                 |   14 +++--
 fs/xfs/xfs_rtalloc.h               |    6 +-
 fs/xfs/xfs_trace.h                 |    4 +-
 31 files changed, 321 insertions(+), 311 deletions(-)

