Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58218 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966382AbeBNCWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Feb 2018 21:22:41 -0500
Date: Wed, 14 Feb 2018 13:16:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_buf_lock vs aio
Message-ID: <20180214021627.GI6778@dastard>
References: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
 <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
 <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
 <20180213051850.GE6778@dastard>
 <20180213231458.GE5217@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180213231458.GE5217@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org

On Tue, Feb 13, 2018 at 03:14:58PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 13, 2018 at 04:18:51PM +1100, Dave Chinner wrote:
> > On Mon, Feb 12, 2018 at 11:33:44AM +0200, Avi Kivity wrote:
> > You're now trying to guess how we'd solve the busy extent blocking
> > problem. i.e. you now appear to be assuming we have a plan to fix
> > this problem and are going to do it immediately.  Nothing could be
> > further from the truth - I said:
> > 
> > > >this is now important, and so we now need to revisit the issues we
> > > >laid out some 8 years ago and work from there.
> > 
> > That does not mean "we're going to fix this now" - it means we need
> > to look at the problem again and determine if it's the best solution
> > to the problem being presented to us. There are other avenues we
> > still need to explore.
> 
> Upstream XFS is a general-purpose solution, which means that the code we
> add to it must be suitable for everyone -- that means it has to work for
> most everyone and be understandable by everyone who reads the code.
> I'd like to try to avoid adding weird hacks.

[....]

> In other words, more discussion needed:
> 
> > Indeed, does your application and/or users even care about
> > [acm]times on your files being absolutely accurate and crash
> > resilient? i.e. do you use fsync() or fdatasync() to guarantee the
> > data is on stable storage?

Because what I'm getting at here is this:

$ man 8 mount
.....
      lazytime

	      Only update times (atime, mtime, ctime) on the
	      in-memory version of the file inode.

	      This mount option significantly reduces writes to the
	      inode table for workloads that perform frequent random
	      writes to preallocated files.

              The on-disk timestamps are updated only when:

	      - the inode needs to be updated for some change
		unrelated to file timestamps

	      - the application employs fsync(2), syncfs(2), or
		sync(2)

	      - an undeleted inode is evicted from memory

	      - more than 24 hours have passed since the i-node was
		written to disk.

This has been implemented for ext4 and f2fs, but not for XFS.
Implementing this for XFS and then using it for your application
will basically get rid of the blocking that is occurring in
timestamp updates by removing the transaction/locking we are doing
around timestamp updates.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
