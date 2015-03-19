Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5A6567F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 18:38:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 452BF8F8054
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 16:38:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QxdJv9f7bROxQ1fw for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 16:38:44 -0700 (PDT)
Date: Fri, 20 Mar 2015 10:37:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: don't write uninitialized heap contents into new
	directory blocks
Message-ID: <20150319233752.GF28621@dastard>
References: <20150318232159.GA24608@birch.djwong.org>
	<20150319182834.GI11669@laptop.bfoster>
	<20150319210250.GF24608@birch.djwong.org>
	<20150319225917.GJ10105@dastard>
	<20150319232530.GA13727@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150319232530.GA13727@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Mar 19, 2015 at 04:25:30PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 20, 2015 at 09:59:17AM +1100, Dave Chinner wrote:
> > On Thu, Mar 19, 2015 at 02:02:50PM -0700, Darrick J. Wong wrote:
> > > This seems possible if we read in the block, detach it from
> > > whatever points to it, and then we want to allocate it to a
> > > directory.  The buffer's still in memory and it's still the
> > > right size, so we don't free b_addr; the init function doesn't
> > > overwrite the whole buffer, and now we've just leaked old disk
> > > contents.  Adding a memset to getbuf would fix this, but again
> > > at a cost of unnecessary zeroing.
> > 
> > Leaked the contents to whom?
> > 
> > In the kernel we don't care about stale contents in metadata
> > buffers as the contents cannot be directly read from userspace.
> > i.e. there is no vector for information leakage (other than
> > through the root user reading the bdev directly), so we don't
> > need to zero buffers to prevent information leakage either in
> > userspace or the kernel...
> 
> Ok.  It was a mostly theoretical worry -- a corrupt FS thinks a
> data block contains metadata; repair frees the block but then
> reallocates it to a dir or something, and then a second file gets
> pointed to the dir block.  Now the second file can read the old
> file's contents, even after we supposedly reallocated it to
> something else.

We don't rebuild directories until we've already resolved all the
used/free block references in the filesystem (phase 3/4) and then
rebuilt the free space trees (phase 5). Hence by the end of phase 5
we do not have any doubly referenced blocks, nor do we have any
dangling references in inodes to free space, and we have a fully
correct free space index written to disk.

We then rebuild directories (phase 6) using the corrected free space
btrees if we need to allocate new blocks and hence we can't get
doubly linked blocks in the manner you suggest unless we've broken
repair rather badly...

> OTOH it's probably hard to make that happen.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
