Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E10C48BCD
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 20:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0892F6054E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 20:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhFIUsm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 16:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhFIUsk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Jun 2021 16:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8FE6128A;
        Wed,  9 Jun 2021 20:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623271605;
        bh=ej5C8rw5almvi/ELSboK9eMKMAJd9BJaAVT5I5/7uHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U497mfnJouXyHWJcqJsONc6Zen5vu3v9/wol9Txm8osXXQHY3rA0jC6Yp6HQW9aIx
         POcVy6sMw9fkEq/zrqO2Ft1Als5zz7Jyp0E85duf+ZORQcZts86dm8T1Gkj2AL3RxS
         YYEyBqrPKnixe04EZGWgrSS+chg6VFBOgTDYrgZYdIdBNG4iZcQrc8eF7JgyD6Sa5/
         kybcJccjYalcGrV7Ny3D1zaplU0ysJcrwQ6l3s28QGWamd454aqeD83jVWi2PF4cUq
         8eYVudL8AmOS96sKzhJOIp+EhVHKCoIxtT3zPkZRMrdtPxQvrrTKSvV20kE0Lfw7Ya
         OWDJKkJZbEr6A==
Date:   Wed, 9 Jun 2021 13:46:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL v2] xfs: buffer cache bulk page allocation
Message-ID: <20210609204645.GY2945738@locust>
References: <20210608035616.GJ664593@dread.disaster.area>
 <20210608041437.GA2419729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608041437.GA2419729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 02:14:37PM +1000, Dave Chinner wrote:
> Hi Darrick,
> 
> As we talked about on IRC, I have (force) updated the branch and tag
> containing the buffer cache bulk page allocation series to correct
> the errors in the commit metadata. This version correctly attributes
> all of Christoph's patches, fixes a couple of minor typos and adds a
> missing committer SoB to another of Christoph's patches. There are
> no code changes in this update.
> 
> When you next update the for-next branch, can you please pull the
> updates from the tag below?

Pulled, thanks.

--D

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
> for you to fetch changes up to 8bcac7448a942fa4662441a310c97d47cec24310:
> 
>   xfs: merge xfs_buf_allocate_memory (2021-06-07 11:50:48 +1000)
> 
> ----------------------------------------------------------------
> xfs: buffer cache bulk page allocation
> 
> This patchset makes use of the new bulk page allocation interface to
> reduce the overhead of allocating large numbers of pages in a
> loop.
> 
> The first two patches are refactoring buffer memory allocation and
> converting the uncached buffer path to use the same page allocation
> path, followed by converting the page allocation path to use bulk
> allocation.
> 
> The rest of the patches are then consolidation of the page
> allocation and freeing code to simplify the code and remove a chunk
> of unnecessary abstraction. This is largely based on a series of
> changes made by Christoph Hellwig.
> 
> ----------------------------------------------------------------
> Christoph Hellwig (3):
>       xfs: remove ->b_offset handling for page backed buffers
>       xfs: simplify the b_page_count calculation
>       xfs: cleanup error handling in xfs_buf_get_map
> 
> Dave Chinner (7):
>       xfs: split up xfs_buf_allocate_memory
>       xfs: use xfs_buf_alloc_pages for uncached buffers
>       xfs: use alloc_pages_bulk_array() for buffers
>       xfs: merge _xfs_buf_get_pages()
>       xfs: move page freeing into _xfs_buf_free_pages()
>       xfs: get rid of xb_to_gfp()
>       xfs: merge xfs_buf_allocate_memory
> 
>  fs/xfs/libxfs/xfs_ag.c |   1 -
>  fs/xfs/xfs_buf.c       | 305 ++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
>  fs/xfs/xfs_buf.h       |   3 +-
>  3 files changed, 120 insertions(+), 189 deletions(-)
> 
> -- 
> Dave Chinner
> david@fromorbit.com
