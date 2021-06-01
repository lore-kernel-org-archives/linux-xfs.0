Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C95CC47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 05:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D9D61378
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 05:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhFAFGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 01:06:04 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39245 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhFAFGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 01:06:04 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 78999105172;
        Tue,  1 Jun 2021 15:04:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lnwZg-007bHk-BQ; Tue, 01 Jun 2021 15:04:20 +1000
Date:   Tue, 1 Jun 2021 15:04:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: Use bulk page allocator for buffer cache
Message-ID: <20210601050420.GC664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=rPWz8ID9NoP23ybvzLcA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Please pull the reviewed series from the signed tag detailed below.
This has been updated with all the latested RVB tags and the couple
of typos/whitespace issues you noticed when reviewing it. The branch
is based on linux-xfs/master, and merges cleanly into the current
for-next branch.

I sent a pull-req rather than posting the series again just for rvb
updates as we already have enough noise on the list. Let me know if
you would prefer patches over pull requests, or whether you want
more information in the tags in future (e.g. series description for
the merge commit) or anything else like that.

Cheers,

Dave.

The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:

  Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-buf-bulk-alloc-tag

for you to fetch changes up to 8bb870dee3c14ac0eded777a5c2d6d07a6cdd10c:

  xfs: merge xfs_buf_allocate_memory (2021-06-01 13:40:37 +1000)

----------------------------------------------------------------
XFS buffer cache bulk page allocation

----------------------------------------------------------------
Christoph Hellwig (2):
      xfs: simplify the b_page_count calculation
      xfs: cleanup error handling in xfs_buf_get_map

Dave Chinner (8):
      xfs: split up xfs_buf_allocate_memory
      xfs: use xfs_buf_alloc_pages for uncached buffers
      xfs: use alloc_pages_bulk_array() for buffers
      xfs: merge _xfs_buf_get_pages()
      xfs: move page freeing into _xfs_buf_free_pages()
      xfs: remove ->b_offset handling for page backed buffers
      xfs: get rid of xb_to_gfp()
      xfs: merge xfs_buf_allocate_memory

 fs/xfs/libxfs/xfs_ag.c |   1 -
 fs/xfs/xfs_buf.c       | 305 +++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
 fs/xfs/xfs_buf.h       |   3 +-
 3 files changed, 120 insertions(+), 189 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
