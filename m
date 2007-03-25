Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 Mar 2007 21:18:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2P4I86p030386
	for <xfs@oss.sgi.com>; Sat, 24 Mar 2007 21:18:09 -0700
Date: Sun, 25 Mar 2007 15:17:55 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <20070325041755.GJ32602149@melbourne.sgi.com>
References: <17923.11463.459927.628762@notabene.brown> <20070323053043.GD32602149@melbourne.sgi.com> <17923.34462.210758.852042@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17923.34462.210758.852042@notabene.brown>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, hch@infradead.org

On Fri, Mar 23, 2007 at 06:49:50PM +1100, Neil Brown wrote:
> On Friday March 23, dgc@sgi.com wrote:
> > On Fri, Mar 23, 2007 at 12:26:31PM +1100, Neil Brown wrote:
> > > Secondly, if a barrier write fails due to EOPNOTSUPP, it should be
> > > retried without the barrier (after possibly waiting for dependant
> > > requests to complete).  This is what other filesystems do, but I
> > > cannot find the code in xfs which does this.
> > 
> > XFS doesn't handle this - I was unaware that the barrier status of the
> > underlying block device could change....
> > 
> > OOC, when did this behaviour get introduced?
> 
> Probably when md/raid1 started supported barriers....
> 
> The problem is that this interface is (as far as I can see) undocumented
> and not fully specified.

And not communicated very far, either.

> Barriers only make sense inside drive firmware.

I disagree. e.g. Barriers have to be handled by the block layer to
prevent reordering of I/O in the request queues as well. The
block layer is responsible for ensuring barrier I/Os, as
indicated by the filesystem, act as real barriers.

> Trying to emulate it
> in the md layer doesn't make any sense as the filesystem is in a much
> better position to do any emulation required.

You're saying that the emulation of block layer functionality is the
responsibility of layers above the block layer. Why is this not
considered a layering violation?

> > > This is particularly important for md/raid1 as it is quite possible
> > > that barriers will be supported at first, but after a failure and
> > > different device on a different controller could be swapped in that
> > > does not support barriers.
> > 
> > I/O errors are not the way this should be handled. What happens if
> > the opposite happens? A drive that needs barriers is used as a
> > replacement on a filesystem that has barriers disabled because they
> > weren't needed? Now a crash can result in filesystem corruption, but
> > the filesystem has not been able to warn the admin that this
> > situation occurred. 
> 
> There should never be a possibility of filesystem corruption.
> If the a barrier request fails, the filesystem should:
>   wait for any dependant request to complete
>   call blkdev_issue_flush
>   schedule the write of the 'barrier' block
>   call blkdev_issue_flush again.

IOWs, the filesystem has to use block device calls to emulate a block device
barrier I/O. Why can't the block layer, on reception of a barrier write
and detecting that barriers are no longer supported by the underlying
device (i.e. in MD), do:

	wait for all queued I/Os to complete
	call blkdev_issue_flush
	schedule the write of the 'barrier' block
	call blkdev_issue_flush again.

And not involve the filesystem at all? i.e. why should the filesystem
have to do this?

> My understand is that that sequence is as safe as a barrier, but maybe
> not as fast.

Yes, and my understanding is that the block device is perfectly capable
of implementing this just as safely as the filesystem.

> The patch looks at least believable.  As you can imagine it is awkward
> to test thoroughly.

As well as being pretty much impossible to test reliably with an
automated testing framework. Hence so ongoing test coverage will
approach zero.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
