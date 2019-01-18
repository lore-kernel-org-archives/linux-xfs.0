Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38062 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfARLr4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 06:47:56 -0500
Date: Fri, 18 Jan 2019 03:47:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/5] xfs: eof trim writeback mapping as soon as it is
 cached
Message-ID: <20190118114756.GA7807@infradead.org>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117192004.49346-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 02:20:00PM -0500, Brian Foster wrote:
> The cached writeback mapping is EOF trimmed to try and avoid races
> between post-eof block management and writeback that result in
> sending cached data to a stale location. The cached mapping is
> currently trimmed on the validation check, which leaves a race
> window between the time the mapping is cached and when it is trimmed
> against the current inode size.
> 
> For example, if a new mapping is cached by delalloc conversion on a
> blocksize == page size fs, we could cycle various locks, perform
> memory allocations, etc.  in the writeback codepath before the
> associated mapping is eventually trimmed to i_size. This leaves
> enough time for a post-eof truncate and file append before the
> cached mapping is trimmed. The former event essentially invalidates
> a range of the cached mapping and the latter bumps the inode size
> such the trim on the next writepage event won't trim all of the
> invalid blocks. fstest generic/464 reproduces this scenario
> occasionally and causes a lost writeback and stale delalloc blocks
> warning on inode inactivation.
> 
> To work around this problem, trim the cached writeback mapping as
> soon as it is cached in addition to on subsequent validation checks.
> This is a minor tweak to tighten the race window as much as possible
> until a proper invalidation mechanism is available.
> 
> Fixes: 40214d128e07 ("xfs: trim writepage mapping to within eof")

I don't think it fixes that commit, but rather fixes more aspects of
the issue that commit tried to fix.

Otherwise this looks fine as a band-aid fix:

Reviewed-by: Christoph Hellwig <hch@lst.de>
