Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88EE47CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 13:08:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B3518F804C
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 11:08:25 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id oXTzvwHkf4UjyZcj for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 11:08:22 -0700 (PDT)
Date: Thu, 31 Mar 2016 14:08:21 -0400
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160331180821.GD22462@fieldses.org>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331011813.GJ30721@dastard>
	<20160331075440.GA4209@infradead.org>
	<20160331111850.GP11812@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160331111850.GP11812@dastard>
From: bfields@fieldses.org (J. Bruce Fields)
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
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Thu, Mar 31, 2016 at 10:18:50PM +1100, Dave Chinner wrote:
> On Thu, Mar 31, 2016 at 12:54:40AM -0700, Christoph Hellwig wrote:
> > On Thu, Mar 31, 2016 at 12:18:13PM +1100, Dave Chinner wrote:
> > > On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> > > > Or is it ok that fallocate could block, potentially for a long time as
> > > > we stream cows through the page cache (or however unshare works
> > > > internally)?  Those same programs might not be expecting fallocate to
> > > > take a long time.
> > > 
> > > Yes, it's perfectly fine for fallocate to block for long periods of
> > > time. See what gfs2 does during preallocation of blocks - it ends up
> > > calling sb_issue_zerout() because it doesn't have unwritten
> > > extents, and hence can block for long periods of time....
> > 
> > gfs2 fallocate is an implementation that will cause all but the most
> > trivial users real pain.  Even the initial XFS implementation just
> > marking the transactions synchronous made it unusable for all kinds
> > of applications, and this is much worse.  E.g. a NFS ALLOCATE operation
> > to gfs2 will probab;ly hand your connection for extended periods of
> > time.
> > 
> > If we need to support something like what gfs2 does we should have a
> > separate flag for it.
> 
> Using fallocate() for preallocation was always intended to
> be a faster, more efficient method allocating zeroed space
> than having userspace write blocks of data. Faster, more efficient
> does not mean instantaneous, and gfs2 using sb_issue_zerout() means
> that if the hardware has zeroing offloads (deterministic trim, write
> same, etc) it will use them, and that will be much faster than
> writing zeros from userspace.
> 
> IMO, what gfs2 is definitely within the intended usage of
> fallocate() for accelerating the preallocation of blocks.
> 
> Yes, it may not be optimal for things like NFS servers which haven't
> considered that a fallocate based offload operation might take some
> time to execute, but that's not a problem with fallocate. i.e.
> that's a problem with the nfs server ALLOCATE implementation not
> being prepared to return NFSERR_JUKEBOX to prevent client side hangs
> and timeouts while the operation is run....

That's an interesting idea, but I don't think it's really legal.  I take
JUKEBOX to mean "sorry, I'm failing this operation for now, try again
later and it might succeed", not "OK, I'm working on it, try again and
you may find out I've done it".

So if the client gets a JUKEBOX error but the server goes ahead and does
the operation anyway, that'd be unexpected.

I suppose it's comparable to the case where a slow fallocate is
interrupted--would it be legal to return EINTR in that case and leave
the application to sort out whether some part of the allocation had
already happened?  Would it be legal to continue the fallocate under the
covers even after returning EINTR?

But anyway my first inclination is to say that the NFS FALLOCATE
protocol just wasn't designed to handle long-running fallocates, and if
we really need that then we need to give it a way to either report
partial results or to report results asynchronously.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
