Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40994 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbeKNHlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 02:41:10 -0500
Date: Wed, 14 Nov 2018 08:41:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/2] splice: increase pipe size in
 splice_direct_to_actor()
Message-ID: <20181113214100.GS19305@dastard>
References: <20181108221909.27602-1-david@fromorbit.com>
 <20181109005410.GG19305@dastard>
 <20181113162237.GF4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113162237.GF4235@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Nov 13, 2018 at 08:22:37AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 09, 2018 at 11:54:10AM +1100, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When copy_file_range() is called on files that have been opened with
> > O_DIRECT, do_splice_direct() does a manual copy of the range one
> > pipe buffer at a time. The default is 16 pages, which means on
> > x86_64 it is limited to 64kB IO. This is extremely slow - 64k
> > synchrnous read/write will run at maybe 5-10MB/s on a spinning disk
> > and be seek bound. It will be faster on SSDs, but still very
> > inefficient.
> > 
> > Increase the pipe size to the maximum allowed user size so that we
> > can get decent throughput for this highly sub-optimal copy loop. Add
> > a new function to the pipe code that lets us set the pipe size to
> > the maximum allowed without root permissions to keep things really
> > simple. We also don't care if changing the pipe size fails - that
> > will just result in a slower copy.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/pipe.c                 | 10 ++++++++++
> >  fs/splice.c               |  7 +++++++
> >  include/linux/pipe_fs_i.h |  1 +
> >  3 files changed, 18 insertions(+)
> > 
> > diff --git a/fs/pipe.c b/fs/pipe.c
> > index bdc5d3c0977d..436bc0464569 100644
> > --- a/fs/pipe.c
> > +++ b/fs/pipe.c
> > @@ -1109,6 +1109,16 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
> >  	return ret;
> >  }
> >  
> > +/*
> > + * Set the pipe to the maximum allowable user size. Advisory only, will
> > + * swallow any errors and return the resultant pipe size.
> > + */
> > +long pipe_set_max_safe_size(struct pipe_inode_info *pipe)
> > +{
> > +	pipe_set_size(pipe, pipe_max_size);
> > +	return pipe->buffers * PAGE_SIZE;
> > +}
> > +
> >  /*
> >   * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
> >   * location, so checking ->i_pipe is not enough to verify that this is a
> > diff --git a/fs/splice.c b/fs/splice.c
> > index 3553f1956508..9749139da731 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -931,6 +931,13 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
> >  		current->splice_pipe = pipe;
> >  	}
> >  
> > +	/*
> > +	 * Try to increase the data holding capacity of the pipe so we can do
> > +	 * larger IOs. This may not increase the size at all because maximum
> > +	 * user pipe size is administrator controlled, but we still should try.
> > +	 */
> > +	pipe_set_max_safe_size(pipe);
> 
> I get where you're going with this, but I have two questions:
> 
> - Is it safe to be enlarging the pipe buffer size unconditionally?

Don't see why it would be unsafe.

> - Especially if we didn't just create the splice pipe?  Suppose someone
>   comes along later trying to splice things and doesn't realize the pipe
>   is now 1MB...

The splice code is supposed to handle arbitrary pipe sizes
correctly. if something breaks because it has assumptions about how
much data a pipe can hold, it's already broken.

> Then I started wondering about the splice_pipe lifetime and couldn't
> figure out if it ever gets detached from current prior to do_exit.
> I don't think it does, which means that we're stuck with the 1MB
> kernel memory allocation until the process dies.

If you are using do_splice_direct(), you either have a short term
process (i.e. a cp type utility) or you are moving bulk data around,
in which case 1MB of extra memory isn't a big deal.

And given that the default pipe size is dependent on PAGE_SIZE (i.e.
the default is 16 pages, not 64kB) then on 64k page architectures we
are already using pipes of 1MB capacity by default.

I could make this contingent on O_DIRECT, but then we have the
problem that 64k pipes aren't big enough for efficient buffered IO
with 64k block size filesystems, either. IOWs, the pipe size in
do_splice_direct needs to be increased whichever way we look at it.

This all said, I really think we need to imlpement our own
->copy_file_range() code that uses iomap to iterate data-only
extents (i.e. hole-preserving) copying and does well formed IO.
IOWs, only fall back to do_splice_direct() when doing copies to/from
non-XFS filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
