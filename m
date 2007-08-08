Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 06:26:17 -0700 (PDT)
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l78DQ5bm013309
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 06:26:08 -0700
From: Andi Kleen <ak@suse.de>
Subject: Re: XFS thread inflation in 2.6.23rc
Date: Wed, 8 Aug 2007 15:26:06 +0200
References: <200708081240.21548.ak@suse.de> <200708081422.10373.ak@suse.de> <20070808131404.GQ52011508@sgi.com>
In-Reply-To: <20070808131404.GQ52011508@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081526.06860.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Wednesday 08 August 2007 15:14:04 David Chinner wrote:

> Memory allocation failure + dirty transaction == filesystem shutdown.

You mean if the workqueue creation would fail? 

Surely not having the MRU cache is not a catastrophe and would
allow the transaction to commit anyways? 

The other alternative would be to start it when a directory with 
the flag is first seen. That should be before any transactions.

The other thing is that it would be nasty to switch do_fork
to use GFP_NOFS, but I doubt that's really needed.
 
> > > Besides, what's the point of having nice constructs like dedicated
> > > workqueues
> > 
> > It's a resource that shouldn't be overused.
> 
> A workqueue + thread uses, what, 10-15k of memory? That's the cost of about
> 10 cached inodes. It is insignificant...

A little bloat here and a little bloat there and soon we're talking
about serious memory. 

e.g. on a dual core box in a standard configuration we're going towards
~50 kernel threads out of the box now and that's just too much IMNSHO.
Given there are other really bad wastes of memory (don't get me
started on some of the hash tables), but it's not totally insignificant.

Threads also have some CPU costs even when sleeping, e.g. there is still code
which walks all threads to do various things.

> Hmmm. I guess you are really not going to like the patch I
> have that moves the AIL pushing to a new thread to solve
> some of scalability issues in the transaction subsystem......

Per CPU or single? If the later definitely the workqueues would need to be 
fixed first.

-Andi
 
