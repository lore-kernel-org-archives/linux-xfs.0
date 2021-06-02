Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16DBC47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 19:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBEE1613EB
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 19:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhFBTSG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 15:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhFBTSE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 15:18:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9395C613EA;
        Wed,  2 Jun 2021 19:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622661380;
        bh=JbyRE0s+g7xdmCh6nCKPUOgvArzh28nw0TpaYZPi6Is=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gaUw43KY2iLO5bULyB6gyggBrZ6i58uCN/z4knlx038m6Do2BToXERooVD50wZkU0
         rEiHWdIpHmquh4o2OGY64yrnadD16HnE22owl3Hgz7FFmYqu0WOr4SQXaDG9pUFWrx
         57oMhg7UpFmn4ftl0Hnv0MVuFth9Cncsr2gDfL9B/+jCpTmSO65Qu0cS1nghWp1hlX
         Zdop5OcwRAO2dtMB8absU0USgfHrDDy5V11f5jnhkRyI+gC2Pm3qDkDdHAJliCrkcs
         0OG+0wQGdqhCYt4++ZoMP5VUHnSDC0rr+B/FJdQJaIK003LYWaZwBdhZaOFnsFfqy+
         n1dwCRV5zqrMg==
Date:   Wed, 2 Jun 2021 12:16:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: Use bulk page allocator for buffer cache
Message-ID: <20210602191620.GK26380@locust>
References: <20210601050420.GC664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601050420.GC664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 03:04:20PM +1000, Dave Chinner wrote:
> Hi Darrick,
> 
> Please pull the reviewed series from the signed tag detailed below.
> This has been updated with all the latested RVB tags and the couple
> of typos/whitespace issues you noticed when reviewing it. The branch
> is based on linux-xfs/master, and merges cleanly into the current
> for-next branch.
> 
> I sent a pull-req rather than posting the series again just for rvb
> updates as we already have enough noise on the list. Let me know if
> you would prefer patches over pull requests, or whether you want
> more information in the tags in future (e.g. series description for
> the merge commit) or anything else like that.
> 
> Cheers,
> 
> Dave.
> 
> The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:
> 
>   Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-buf-bulk-alloc-tag
> 
> for you to fetch changes up to 8bb870dee3c14ac0eded777a5c2d6d07a6cdd10c:
> 
>   xfs: merge xfs_buf_allocate_memory (2021-06-01 13:40:37 +1000)
> 
> ----------------------------------------------------------------
> XFS buffer cache bulk page allocation
> 

Would you mind pushing a new tag containing the cover letter for the
series so that we can capture that in the git history?

--D

> ----------------------------------------------------------------
> Christoph Hellwig (2):
>       xfs: simplify the b_page_count calculation
>       xfs: cleanup error handling in xfs_buf_get_map
> 
> Dave Chinner (8):
>       xfs: split up xfs_buf_allocate_memory
>       xfs: use xfs_buf_alloc_pages for uncached buffers
>       xfs: use alloc_pages_bulk_array() for buffers
>       xfs: merge _xfs_buf_get_pages()
>       xfs: move page freeing into _xfs_buf_free_pages()
>       xfs: remove ->b_offset handling for page backed buffers
>       xfs: get rid of xb_to_gfp()
>       xfs: merge xfs_buf_allocate_memory
> 
>  fs/xfs/libxfs/xfs_ag.c |   1 -
>  fs/xfs/xfs_buf.c       | 305 +++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
>  fs/xfs/xfs_buf.h       |   3 +-
>  3 files changed, 120 insertions(+), 189 deletions(-)
> 
> -- 
> Dave Chinner
> david@fromorbit.com
