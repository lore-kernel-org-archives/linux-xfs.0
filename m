Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A6CC7CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 06:18:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1CBCAC001
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 04:18:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XU5VA7Sz9vDTdZpw for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 04:18:54 -0700 (PDT)
Date: Thu, 31 Mar 2016 22:18:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160331111850.GP11812@dastard>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331011813.GJ30721@dastard>
	<20160331075440.GA4209@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160331075440.GA4209@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-btrfs <linux-btrfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Mar 31, 2016 at 12:54:40AM -0700, Christoph Hellwig wrote:
> On Thu, Mar 31, 2016 at 12:18:13PM +1100, Dave Chinner wrote:
> > On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> > > Or is it ok that fallocate could block, potentially for a long time as
> > > we stream cows through the page cache (or however unshare works
> > > internally)?  Those same programs might not be expecting fallocate to
> > > take a long time.
> > 
> > Yes, it's perfectly fine for fallocate to block for long periods of
> > time. See what gfs2 does during preallocation of blocks - it ends up
> > calling sb_issue_zerout() because it doesn't have unwritten
> > extents, and hence can block for long periods of time....
> 
> gfs2 fallocate is an implementation that will cause all but the most
> trivial users real pain.  Even the initial XFS implementation just
> marking the transactions synchronous made it unusable for all kinds
> of applications, and this is much worse.  E.g. a NFS ALLOCATE operation
> to gfs2 will probab;ly hand your connection for extended periods of
> time.
> 
> If we need to support something like what gfs2 does we should have a
> separate flag for it.

Using fallocate() for preallocation was always intended to
be a faster, more efficient method allocating zeroed space
than having userspace write blocks of data. Faster, more efficient
does not mean instantaneous, and gfs2 using sb_issue_zerout() means
that if the hardware has zeroing offloads (deterministic trim, write
same, etc) it will use them, and that will be much faster than
writing zeros from userspace.

IMO, what gfs2 is definitely within the intended usage of
fallocate() for accelerating the preallocation of blocks.

Yes, it may not be optimal for things like NFS servers which haven't
considered that a fallocate based offload operation might take some
time to execute, but that's not a problem with fallocate. i.e.
that's a problem with the nfs server ALLOCATE implementation not
being prepared to return NFSERR_JUKEBOX to prevent client side hangs
and timeouts while the operation is run....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
