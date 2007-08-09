Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Aug 2007 04:03:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l79B3Zbm023074
	for <xfs@oss.sgi.com>; Thu, 9 Aug 2007 04:03:38 -0700
Date: Thu, 9 Aug 2007 21:03:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS thread inflation in 2.6.23rc
Message-ID: <20070809110322.GA12413810@sgi.com>
References: <200708081240.21548.ak@suse.de> <200708081422.10373.ak@suse.de> <20070808131404.GQ52011508@sgi.com> <200708081526.06860.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708081526.06860.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Aug 08, 2007 at 03:26:06PM +0200, Andi Kleen wrote:
> On Wednesday 08 August 2007 15:14:04 David Chinner wrote:
> 
> > Memory allocation failure + dirty transaction == filesystem shutdown.
> 
> You mean if the workqueue creation would fail? 

Yeah.

> Surely not having the MRU cache is not a catastrophe and would
> allow the transaction to commit anyways? 

Right now the only errors that come from filestream association
are fatal errors. i.e. they should force a shutdown if the transaction
is dirty. One of these errors is already an ENOMEM.

Now we'd have a case where we'd had a "error that is not an error"
and handle that in some way. It gets complex and that's something
I try to avoid if at all possible.

> The other alternative would be to start it when a directory with 
> the flag is first seen. That should be before any transactions.

On lookup? No thanks.

On first create? Possible, but it's still painful and it introduces
overhead into every single create operation.

> > > > Besides, what's the point of having nice constructs like dedicated
> > > > workqueues
> > > It's a resource that shouldn't be overused.
> > A workqueue + thread uses, what, 10-15k of memory? That's the cost of about
> > 10 cached inodes. It is insignificant...
> 
> A little bloat here and a little bloat there and soon we're talking
> about serious memory. 
>
> e.g. on a dual core box in a standard configuration we're going towards
> ~50 kernel threads out of the box now and that's just too much IMNSHO.

My idle desktop machine has 180 processes running on it, 60 of them
kernel threads. It doesn't concern me one bit.

Andi, you are complaining to the wrong person about thread counts. I
live in the world of excessive parallelism and multithreaded I/O. I
regularly see 4-8p boxes running hundreds to thousands of I/O
threads on a single filesystem. These are the workloads XFS is
designed for and we optimise for. A single extra thread is noise....

> > Hmmm. I guess you are really not going to like the patch I
> > have that moves the AIL pushing to a new thread to solve
> > some of scalability issues in the transaction subsystem......
> 
> Per CPU or single?

Single.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
