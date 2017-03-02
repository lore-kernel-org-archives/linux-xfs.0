Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35952 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752171AbdCBLQU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Mar 2017 06:16:20 -0500
Date: Thu, 2 Mar 2017 11:38:45 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
Message-ID: <20170302103845.GB31792@quack2.suse.cz>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-4-rgoldwyn@suse.de>
 <20170301034606.GK16328@bombadil.infradead.org>
 <20170301153857.GC30631@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170301153857.GC30631@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed 01-03-17 07:38:57, Christoph Hellwig wrote:
> On Tue, Feb 28, 2017 at 07:46:06PM -0800, Matthew Wilcox wrote:
> > Ugh, this is pretty inefficient.  If that's all you want to know, then
> > using the radix tree directly will be far more efficient than spinning
> > up all the pagevec machinery only to discard the pages found.
> > 
> > But what's going to kick these pages out of cache?  Shouldn't we rather
> > find the pages, kick them out if clean, start writeback if not, and *then*
> > return -EAGAIN?
> > 
> > So maybe we want to spin up the pagevec machinery after all so we can
> > do that extra work?
> 
> As pointed out in the last round of these patches I think we really
> need to pass a flags argument to filemap_write_and_wait_range to
> communicate the non-blocking nature and only return -EAGAIN if we'd
> block.  As a bonus that can indeed start to kick the pages out.

Aren't flags to filemap_write_and_wait_range() unnecessary complication?
Realistically, most users wanting performance from AIO DIO so badly that
they bother with this API won't have any pages to write / evict. If they do
by some bad accident, they can fall back to standard "blocking" AIO DIO.
So I don't see much value in teaching filemap_write_and_wait_range() about
a non-blocking mode...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
