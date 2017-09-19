Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751353AbdISRkE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 13:40:04 -0400
Date: Tue, 19 Sep 2017 13:39:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: io_submit() blocks for writes for substantial amount of time
Message-ID: <20170919173955.GB8139@dhcp-41-131.bos.redhat.com>
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <20170919145827.GA21523@infradead.org>
 <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tomasz Grabiec <tgrabiec@scylladb.com>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 07:31:04PM +0300, Avi Kivity wrote:
> 
> 
> On 09/19/2017 05:58 PM, Christoph Hellwig wrote:
> > On Tue, Sep 19, 2017 at 08:27:05AM -0400, Brian Foster wrote:
> > > > Please advise, is this a known bug? When can it happen? Is there a way
> > > > to work it around to avoid blocking?
> > > > 
> > > I'm not sure how either could be considered a bug based on the stack
> > > trace information alone. Allocations may require reading metadata and
> > > reads are synchronous. This all seems like pretty basic filesystem
> > > behavior.
> > > 
> > > I suppose performance may be a separate question. For the latter issue,
> > > I'd be curious whether leaving more free space available in the
> > > filesystem would help avoid running into busy extents. Perhaps having
> > > more memory and thus a larger buffer cache for btree blocks could help
> > > mitigate the former issue..? The deterministic workaround for both is to
> > > preallocate the associated file. If the file would be too large, another
> > > option may be to set an extent size hint to allocate the file in larger
> > > chunks and amortize the cost of the allocations over multiple writes.
> > Note that Linux 4.13 and later support a RWF_NOWAIT flag, that will
> > return -EAGAIN from io_submit for these conditions so they can be
> > handled by a thread pool.
> > 
> > Note that until a few years ago we performed all allocations from
> > a workqueue, this was changed by:
> > 
> > commit cf11da9c5d374962913ca5ba0ce0886b58286224
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Tue Jul 15 07:08:24 2014 +1000
> > 
> >      xfs: refine the allocation stack switch
> > 
> > to only defer btree splits to a workqueue.  With that previous scheme
> > there might have been an option to defer AIO allocations to a workqueue,
> > but the main issue with that is that the worker thread which is then
> > going to do the actual data transfer would have to "borrow" the
> > mm_struct from the submitter.  That's the primary reason why something
> > like that was never implemented in mainline Linux.
> 
> For DIO, does it really need the mm_struct? It can just pin the pages and
> pass them to the workqueue function.
> 

I'm not sure what difference it makes regardless. We still have to wait
for an allocation to complete before we can issue an I/O. IIRC, the old
defer allocs to a wq thing was more about saving stack space than
providing async behavior.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
