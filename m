Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f179.google.com ([209.85.160.179]:45614 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfAOOfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 09:35:44 -0500
Message-ID: <1547562941.20294.196.camel@intricatesoftware.com>
Subject: Re: Block device flush ordering
From: Kurt Miller <kurt@intricatesoftware.com>
Date: Tue, 15 Jan 2019 09:35:41 -0500
In-Reply-To: <20190114164549.GA26523@infradead.org>
References: <1547130601.20294.152.camel@intricatesoftware.com>
         <20190113224244.GC4205@dastard> <20190114164549.GA26523@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-block@vger.kernel.org

On Mon, 2019-01-14 at 08:45 -0800, Christoph Hellwig wrote:
> On Mon, Jan 14, 2019 at 09:42:44AM +1100, Dave Chinner wrote:
> > 
> > On Thu, Jan 10, 2019 at 09:30:01AM -0500, Kurt Miller wrote:
> > > 
> > > For a well behaved block device that has a writeback cache,
> > > what is the proper behavior of flush when there are more
> > > then one outstanding flush operations? Is it;
> > > 
> > > Flush all writes seen since the last flush.
> > > or
> > > Flush all writes received prior to the flush including
> > > those before any prior flush.
> The requirement is that all write operations that have been completed
> before the flush was seen are on stable storage.  How that is
> implemented in detail is up to the device.  The typical implementation
> is simply to writeback the whole cache everytime a flush operation
> is received.
> 
> > 
> > > 
> > > 
> > > For example take the following order of requests presented
> > > to the block device:
> > > 
> > > 	writes 1-5
> > > 	flush 1
> > > 	write 6
> > > 	flush 2
> > > 
> > > Can flush 2 finish with success as soon as write 6 is flushed
> > > (which may be before flush 1 success)? Or must it wait for
> > > all prior write operations to flush (writes 1-6)?
> No.  For all the usual protocols as well as the linux kernel semantics
> there is no overall command ordering, especially as there is no way
> to even enforce that in a multi-queue environment.
> 
> > 
> > 
> >  * C1. At any given time, only one flush shall be in progress.  This makes
> >  *     double buffering sufficient.
> Very specific implementation detail inside the request layer.
> 
> > 
> > Then flush 1 does not guarantee any of the writes are on stable
> > storage. They *may* be on stable storage if the timing is right, but
> > it is not guaranteed by the OS code. Likewise, flush 2 only
> > guarantees writes 1, 3 and 5 are on stable storage becase they are
> > the only writes that have been signalled as complete when flush 2
> > was submitted.
> Exactly.

Thank you both for the detailed answers. They have been very helpful.
Also after spending an afternoon reading kernel code (xlog_sync though
blk_flush_complete_seq) I understand it better. The multiple concurrent
flush requests comment I made in another reply was a logging issue in
our nbd implementation where we were logging completions after replying
to the kernel. As a result our log messages were out of order and
misleading. With that corrected in our code we see only one flush at a
time.

Best,
-Kurt
