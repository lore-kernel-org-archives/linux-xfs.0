Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61942 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387748AbfAOXHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 18:07:48 -0500
Date: Wed, 16 Jan 2019 10:07:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] iomap: get/put the page in iomap_page_create/release()
Message-ID: <20190115230744.GM4205@dastard>
References: <20190115211028.15742-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115211028.15742-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Piotr Jaroszynski <pjaroszynski@nvidia.com>

On Tue, Jan 15, 2019 at 10:10:28PM +0100, Christoph Hellwig wrote:
> migrate_page_move_mapping() expects pages with private data set to have
> a page_count elevated by 1.  This is what used to happen for xfs through
> the buffer_heads code before the switch to iomap in commit 82cb14175e7d
> ("xfs: add support for sub-pagesize writeback without buffer_heads").
> Not having the count elevated causes move_pages() to fail on memory
> mapped files coming from xfs.
> 
> Make iomap compatible with the migrate_page_move_mapping() assumption by
> elevating the page count as part of iomap_page_create() and lowering it
> in iomap_page_release().
> 
> It causes the move_pages() syscall to misbehave on memory mapped files
> from xfs.  It does not not move any pages, which I suppose is "just" a
> perf issue, but it also ends up returning a positive number which is out
> of spec for the syscall.  Talking to Michal Hocko, it sounds like
> returning positive numbers might be a necessary update to move_pages()
> anyway though.
> 
> Based on an earlier patch and changelog from Piotr Jaroszynski, except
> that this version actually puts/gets the page aswell when migrating
> pages using a copy, and thus actually survives xfstests.
> 
> Fixes: 82cb14175e7d ("xfs: add support for sub-pagesize writeback without buffer_heads")
> Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>

Missing a SOB.

But apart from that, I've been running an identical patch in my test
tree, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
