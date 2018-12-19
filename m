Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48801 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbeLSTch (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Dec 2018 14:32:37 -0500
Date: Wed, 19 Dec 2018 20:32:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/11] xfs: rework the truncate race handling in the
 writeback path
Message-ID: <20181219193236.GC28624@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181203222503.30649-5-hch@lst.de> <20181218230345.GR27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218230345.GR27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 03:03:45PM -0800, Darrick J. Wong wrote:
> > +eof:
> > +	/*
> > +	 * If we raced with truncate there might be no data left at this offset.
> > +	 * In that case we need to return a hole so that the writeback code
> > +	 * skips writeback for the rest of the file.
> > +	 */
> > +	wpc->imap.br_startoff = offset_fsb;
> > +	wpc->imap.br_blockcount = end_fsb - offset_fsb;
> > +	wpc->imap.br_startblock = HOLESTARTBLOCK;
> > +	wpc->imap.br_state = XFS_EXT_NORM;
> > +	return 0;
> 
> This function has become rather spaghetti-like.  Any way we can clean
> this up reasonably?

What is spaghetti about a small number of gotos that we jump to at
the end of the function?  Compared to the previous mess we had this
actually is a significant cleanup.

> > -		nimaps = 0;
> > -		while (nimaps == 0) {
> 
> This removal of the nimaps == 0 loop bothers me: why is doing so safe?
> 
> I see that we can return from xfs_bmapi_write with nimaps == 0 if
> something is trying to punch or truncate the range that we're writing
> back, but it also seems to me that bmapi_write can return zero mappings
> because xfs_bmapi_allocate() didn't find any blocks.  I /think/ that's
> impossible because we're converting delalloc reservations and so we
> should never run out of space, right?
> 
> Anyway, when _write_allocate gets zero mappings, it'll return -EAGAIN to
> xfs_map_blocks, which will retry once to cover the case of racing with
> cow -> data fork remapping but otherwise it won't bother?  And that's
> why it's fine that only to loop once?
> 
> Am I reasoning this correctly?

Yes, exactly.  The only thing the loop did was to make sure we hit
the truncate race handling code another time on a failure return
from xfs_bmapi_write.
