Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 20:58:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2Q3wA6p015106
	for <xfs@oss.sgi.com>; Sun, 25 Mar 2007 20:58:12 -0700
Date: Mon, 26 Mar 2007 14:58:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <20070326035803.GH32597093@melbourne.sgi.com>
References: <17923.11463.459927.628762@notabene.brown> <1755676AA526FF7790546385@timothy-shimmins-power-mac-g5.local> <17923.35118.139991.252734@notabene.brown> <20070325031927.GG32602149@melbourne.sgi.com> <17927.3389.655835.610940@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17927.3389.655835.610940@notabene.brown>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Mon, Mar 26, 2007 at 10:01:01AM +1000, Neil Brown wrote:
> On Sunday March 25, dgc@sgi.com wrote:
> > On Fri, Mar 23, 2007 at 07:00:46PM +1100, Neil Brown wrote:
> > > 
> > > Why no barriers on an external log device??? Not important, just
> > > curious.
> > 
> > because we need to synchronize across 2 devices, not one, so issuing
> > barriers on an external log device does nothing to order the metadata
> > written to the other device...
> 
> Right, of course.  Just like over a raid0.
> 
> So you must have code to wait for all writes to the main device before
> writing the commit block on the journal.

Forget about what you know about journalling from ext3, XFS is
vastly different and much more complex..... ;)

We wait for space in the log to become available during transaction
reservation; we don't wait for specific I/Os to complete because we
just push a bunch out. Once we have a reservation, we know we have
space in the log for our transaction commit and so we don't have to
wait for any I/O to complete when we do our transaction commit.
Hence we don't wait for the I/Os we may have issued to make space
available; another thread's push may have made enough space for our
reservation. IOWs, we've got *no idea* what the dependent I/Os are
when writing the transaction commit to disk because we have no clue
as to what we are overwriting in the journal.

This journalling method assumes that we either have no drive level
caching, non-volatile caching, or barrier-based log I/Os to prevent
corruption on drive power loss.  Hence with external logs on XFS
you have the option of no caching or non-volatile caching....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
