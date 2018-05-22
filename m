Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47131 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750733AbeEVITl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 04:19:41 -0400
Date: Tue, 22 May 2018 10:24:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/34] iomap: add initial support for writes without
        buffer heads
Message-ID: <20180522082454.GB9801@lst.de>
References: <20180518164830.1552-1-hch@lst.de> <20180518164830.1552-17-hch@lst.de> <20180521232700.GB14384@magnolia> <20180522000745.GU23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522000745.GU23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Tue, May 22, 2018 at 10:07:45AM +1000, Dave Chinner wrote:
> > Something doesn't smell right here.  The only pages we need to read in
> > are the first and last pages in the write_begin range, and only if they
> > aren't page aligned and the underlying extent is IOMAP_MAPPED, right?
> 
> And not beyond EOF, too.
> 
> The bufferhead code handles this via the buffer_new() flag - it
> triggers the skipping of read IO and the states in which it is
> set are clearly indicated in iomap_to_bh(). That same logic needs to
> apply here.

The buffer_new logic itself isn't really something to copy directly
as it has all kinds of warts..

> > I also noticed that speculative preallocation kicks in by the second 80M
> > write() call and writeback for the second call can successfully allocate
> > the entire preallocation, which means that the third (or nth) write call
> > can have a real extent already mapped in, and then we end up reading it.
> 
> Yeah, that's because there's no check against EOF here. These writes
> are all beyond EOF, so there shouldn't be any read at all...

The EOF case is already handled in iomap_block_needs_zeroing.  We just
need to skip the read for ranges entirely covered by the write.
