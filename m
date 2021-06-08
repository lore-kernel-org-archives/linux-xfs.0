Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B042C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 04:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD4761139
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 04:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhFHEQt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 00:16:49 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44049 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhFHEQs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jun 2021 00:16:48 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 591DE8626A9;
        Tue,  8 Jun 2021 14:14:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lqT8P-00AFtX-IC; Tue, 08 Jun 2021 14:14:37 +1000
Date:   Tue, 8 Jun 2021 14:14:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL v2] xfs: buffer cache bulk page allocation
Message-ID: <20210608041437.GA2419729@dread.disaster.area>
References: <20210608035616.GJ664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608035616.GJ664593@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=2hQDhVGAMBsfvw_dvxAA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

As we talked about on IRC, I have (force) updated the branch and tag
containing the buffer cache bulk page allocation series to correct
the errors in the commit metadata. This version correctly attributes
all of Christoph's patches, fixes a couple of minor typos and adds a
missing committer SoB to another of Christoph's patches. There are
no code changes in this update.

When you next update the for-next branch, can you please pull the
updates from the tag below?

Cheers,

Dave.

The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:

  Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-buf-bulk-alloc-tag

for you to fetch changes up to 8bcac7448a942fa4662441a310c97d47cec24310:

  xfs: merge xfs_buf_allocate_memory (2021-06-07 11:50:48 +1000)

----------------------------------------------------------------
xfs: buffer cache bulk page allocation

This patchset makes use of the new bulk page allocation interface to
reduce the overhead of allocating large numbers of pages in a
loop.

The first two patches are refactoring buffer memory allocation and
converting the uncached buffer path to use the same page allocation
path, followed by converting the page allocation path to use bulk
allocation.

The rest of the patches are then consolidation of the page
allocation and freeing code to simplify the code and remove a chunk
of unnecessary abstraction. This is largely based on a series of
changes made by Christoph Hellwig.

----------------------------------------------------------------
Christoph Hellwig (3):
      xfs: remove ->b_offset handling for page backed buffers
      xfs: simplify the b_page_count calculation
      xfs: cleanup error handling in xfs_buf_get_map

Dave Chinner (7):
      xfs: split up xfs_buf_allocate_memory
      xfs: use xfs_buf_alloc_pages for uncached buffers
      xfs: use alloc_pages_bulk_array() for buffers
      xfs: merge _xfs_buf_get_pages()
      xfs: move page freeing into _xfs_buf_free_pages()
      xfs: get rid of xb_to_gfp()
      xfs: merge xfs_buf_allocate_memory

 fs/xfs/libxfs/xfs_ag.c |   1 -
 fs/xfs/xfs_buf.c       | 305 ++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
 fs/xfs/xfs_buf.h       |   3 +-
 3 files changed, 120 insertions(+), 189 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
