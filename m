Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 16:41:56 -0700 (PDT)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JNfXDW018737
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 16:41:35 -0700
From: Neil Brown <neilb@suse.de>
Date: Wed, 19 Jul 2006 09:41:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17597.29099.110370.121220@cse.unsw.edu.au>
Subject: Re: XFS and write barrier
In-Reply-To: message from David Chinner on Wednesday July 19
References: <200607151248.56603.Martin@lichtvoll.de>
	<20060716173238.GD3417@free.net.ph>
	<20060718173122.B1914501@wobbly.melbourne.sgi.com>
	<17596.41680.124148.595601@cse.unsw.edu.au>
	<20060718170406.GT15160733@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nathan Scott <nathans@sgi.com>, xfs@oss.sgi.com, linux-raid@vger.kernel.org

On Wednesday July 19, dgc@sgi.com wrote:
> On Tue, Jul 18, 2006 at 06:58:56PM +1000, Neil Brown wrote:
> > On Tuesday July 18, nathans@sgi.com wrote:
> > > On Mon, Jul 17, 2006 at 01:32:38AM +0800, Federico Sevilla III wrote:
> > > > On Sat, Jul 15, 2006 at 12:48:56PM +0200, Martin Steigerwald wrote:
> > > > > I am currently gathering information to write an article about journal
> > > > > filesystems with emphasis on write barrier functionality, how it
> > > > > works, why journalling filesystems need write barrier and the current
> > > > > implementation of write barrier support for different filesystems.
> > 
> > "Journalling filesystems need write barrier" isn't really accurate.
> > They can make good use of write barrier if it is supported, and where
> > it isn't supported, they should use blkdev_issue_flush in combination
> > with regular submit/wait.
> 
> blkdev_issue_flush() causes a write cache flush - just like a
> barrier typically causes a write cache flush up to the I/O with the
> barrier in it.  Both of these mechanisms provide the same thing - an
> I/O barrier that enforces ordering of I/Os to disk.
> 
> Given that filesystems already indicate to the block layer when they
> want a barrier, wouldn't it be better to get the block layer to issue
> this cache flush if the underlying device doesn't support barriers
> and it receives a barrier request?

A barrier means a lot more than just a flush.
It means
  wait for all proceeding requests to commit
  flush
  write this request
  flush

Any block device that uses the io scheduler could probably manage
this.  Other block devices might not find it so easy.

> 
> Any particular reason for not supporting barriers on the other types
> of RAID?
> 

Imagine trying to implement barriers for raid0 (or any level with
striping).  You would need to
  block new requests
  wait for all requests to all devices to complete
  issue a flush to all devices
  issue the barrier request to the target device
  issue a flush to the target device
  permit new requests.

This means raid0 would need to keep track of all pending requests,
which it doesn't do.  As the filesystem does, it is just as efficient
to let the filesystem to the work.

I guess raid0 could
  - block new requests
  - submit a no-op barrier to all devices
  - wait for the no-op to complete
  - submit the write/barrier request
  - permit new requests.

This would avoid needing to keep track of all requests.  However I
don't think the Linux block layer supports a no-op barrer, and I don't
think this would actually be better than not supporting barriers.

The real value of barriers (as far as I can see) is that the target
device can understand them so you don't need to stall the queue of
requests flying over the buss to the device.  If you need to stall the
flow of requests and wait at the OS level, then the value of barriers
disappears and you may as well wait in the filesystem code.

At least, that is my understanding.  I am happy to be educated.

NeilBrown
