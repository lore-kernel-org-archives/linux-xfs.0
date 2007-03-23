Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Mar 2007 00:50:26 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2N7oK6p010545
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 00:50:22 -0700
From: Neil Brown <neilb@suse.de>
Date: Fri, 23 Mar 2007 18:49:50 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17923.34462.210758.852042@notabene.brown>
Subject: Re: XFS and write barriers.
In-Reply-To: message from David Chinner on Friday March 23
References: <17923.11463.459927.628762@notabene.brown>
	<20070323053043.GD32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, hch@infradead.org

On Friday March 23, dgc@sgi.com wrote:
> On Fri, Mar 23, 2007 at 12:26:31PM +1100, Neil Brown wrote:
> > Secondly, if a barrier write fails due to EOPNOTSUPP, it should be
> > retried without the barrier (after possibly waiting for dependant
> > requests to complete).  This is what other filesystems do, but I
> > cannot find the code in xfs which does this.
> 
> XFS doesn't handle this - I was unaware that the barrier status of the
> underlying block device could change....
> 
> OOC, when did this behaviour get introduced?

Probably when md/raid1 started supported barriers....

The problem is that this interface is (as far as I can see) undocumented
and not fully specified.

Barriers only make sense inside drive firmware.  Trying to emulate it
in the md layer doesn't make any sense as the filesystem is in a much
better position to do any emulation required.
So as the devices can change underneath md/raid1, it must be able to
fail a barrier request at any point.

The first file systems to use barriers (ext3, reiserfs) submit a
barrier request and if that fails they decide that barriers don't work
any more and use the fall-back mechanism.

The seemed to mesh perfectly with what I needed for md, so I assumed
it was an intended feature of the interface and made md/raid1 depend
on it.


> > This is particularly important for md/raid1 as it is quite possible
> > that barriers will be supported at first, but after a failure and
> > different device on a different controller could be swapped in that
> > does not support barriers.
> 
> I/O errors are not the way this should be handled. What happens if
> the opposite happens? A drive that needs barriers is used as a
> replacement on a filesystem that has barriers disabled because they
> weren't needed? Now a crash can result in filesystem corruption, but
> the filesystem has not been able to warn the admin that this
> situation occurred. 

There should never be a possibility of filesystem corruption.
If the a barrier request fails, the filesystem should:
  wait for any dependant request to complete
  call blkdev_issue_flush
  schedule the write of the 'barrier' block
  call blkdev_issue_flush again.

My understand is that that sequence is as safe as a barrier, but maybe
not as fast.

The patch looks at least believable.  As you can imagine it is awkward
to test thoroughly.

Thanks,
NeilBrown
