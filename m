Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A6A829DF5
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 08:15:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E59588F8040
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 06:15:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8rj1YzbPZRRBsWQj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2015 06:15:12 -0800 (PST)
Date: Mon, 2 Nov 2015 09:15:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151102141509.GA29346@bfoster.bfoster>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-4-git-send-email-david@fromorbit.com>
	<20151029142950.GE11663@bfoster.bfoster>
	<20151029233756.GS19199@dastard>
	<20151030123657.GC54905@bfoster.bfoster>
	<20151102011433.GW19199@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151102011433.GW19199@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Nov 02, 2015 at 12:14:33PM +1100, Dave Chinner wrote:
> On Fri, Oct 30, 2015 at 08:36:57AM -0400, Brian Foster wrote:
> > On Fri, Oct 30, 2015 at 10:37:56AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 29, 2015 at 10:29:50AM -0400, Brian Foster wrote:
> > > > On Mon, Oct 19, 2015 at 02:27:15PM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > ...
> > > > > +	/*
> > > > > +	 * For DAX, we do not allocate unwritten extents, but instead we zero
> > > > > +	 * the block before we commit the transaction.  Ideally we'd like to do
> > > > > +	 * this outside the transaction context, but if we commit and then crash
> > > > > +	 * we may not have zeroed the blocks and this will be exposed on
> > > > > +	 * recovery of the allocation. Hence we must zero before commit.
> > > > > +	 * Further, if we are mapping unwritten extents here, we need to zero
> > > > > +	 * and convert them to written so that we don't need an unwritten extent
> > > > > +	 * callback for DAX. This also means that we need to be able to dip into
> > > > > +	 * the reserve block pool if there is no space left but we need to do
> > > > > +	 * unwritten extent conversion.
> > > > > +	 */
> > > > > +	if (IS_DAX(VFS_I(ip))) {
> > > > > +		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
> > > > > +		tp->t_flags |= XFS_TRANS_RESERVE;
> > > > > +	}
> > > > 
> > > > Am I following the commit log description correctly in that block
> > > > zeroing is only required for DAX faults? Do we zero blocks for DAX DIO
> > > > as well to be consistent, or is that also required (because it looks
> > > > like we still have end_io completion for dio writes anyways)?
> > > 
> > > DAX DIO will do the zeroing rather than using unwritten extents,
> > > too. But we still have DIO IO completion as that needs to do file
> > > size updates.
> > > 
> > 
> > Right, my question is: is the DAX DIO zeroing required to avoid the
> > races described as the purpose for this patch, or is this just here as a
> > simplification? In other words, why not do block zeroing only for DAX
> > faults and not DAX/DIO?
> 
> Because the only reason the DIO code does 'allocate unwritten;
> convert unwritten on IO completion' is so that if we have:
> 
> 	allocate
> 	trans_commit
> 	....				log force
> 					journal IO submit
> 	....				journal IO completion
> 	submit data io
> 	crash
> 
> We don't expose allocated blocks containing stale data to userspace
> via recovery. The allcoation uses unwritten extents to ensure that
> if the allocation is recovered without the correspending completion,
> it reads as zeros rather whatever was previously on disk in taht
> location.
> 
> For DAX, we can zero the blocks inside the allocation transaction
> for direct IO, and hence even if we have the above happen, we'll
> only ever expose zeros. Hence we don't need unwritten extents in the
> DIO path to avoid stale data exposure, and so we can simply avoid
> all that extra overhead of unwritten extent conversion on
> completion...
> 

Yeah, I get that bit. In fact, I was hoping to get to doing something
similar for delalloc extents to deal with the similar issue there if the
extent conversion makes it to the log and we crash before I/O (as I
believe we've discussed in the past). That is for something unrelated,
however...

> > I ask because my understanding is the purpose of this patch is a special
> > atomic zeroed allocation requirement just for mmap.
> 
> The requirement is set by DAX+mmap; the implementation is a generic
> "allocate zeroed blocks" mechanism that can be applied to any
> allocation that uses unwritten extents to allocate zeroed blocks if
> zeroing is more efficient than using unwritten extents....
> 

Ok, I take that to mean that there is no race or corruption vector so
long as DAX/mmap uses the atomic zero allocation. The implementation
mostly looks pretty good to me, but I suspect I'm not being clear with
my question, which is...

> > Unless there is some
> > special mixed dio/mmap case I'm missing, doing so for DAX/DIO basically
> > causes a clear_pmem() over every page sized chunk of the target I/O
> > range for which we already have the data.
> 
> I don't follow - this only zeros blocks when we do allocation of new
> blocks or overwrite unwritten extents, not on blocks which we
> already have written data extents allocated for...
> 

Why are we assuming that block zeroing is more efficient than unwritten
extents for DAX/dio? I haven't played with pmem enough to know for sure
one way or another (or if hw support is imminent), but I'd expect the
latter to be more efficient in general without any kind of hardware
support.

Just as an example, here's an 8GB pwrite test, large buffer size, to XFS
on a ramdisk mounted with '-o dax:'

- Before this series:

# xfs_io -fc "truncate 0" -c "pwrite -b 10m 0 8g" /mnt/file
wrote 8589934592/8589934592 bytes at offset 0
8.000 GiB, 820 ops; 0:00:04.00 (1.909 GiB/sec and 195.6591 ops/sec)

- After this series:

# xfs_io -fc "truncate 0" -c "pwrite -b 10m 0 8g" /mnt/file
wrote 8589934592/8589934592 bytes at offset 0
8.000 GiB, 820 ops; 0:00:12.00 (659.790 MiB/sec and 66.0435 ops/sec)

The impact is less with a smaller buffer size so the above is just meant
to illustrate the point. FWIW, I'm also fine with getting this in as a
matter of "correctness before performance" since this stuff is clearly
still under development, but as far as I can see so far we should
probably ultimately prefer unwritten extents for DAX/DIO (or at least
plan to run some similar tests on real pmem hw). Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
