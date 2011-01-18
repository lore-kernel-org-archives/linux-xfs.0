Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0IM1LAT161585 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 16:01:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0954614883B7
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 14:03:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	3CndWdwlLLYM9fdk for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 14:03:38 -0800 (PST)
Date: Wed, 19 Jan 2011 09:03:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110118220335.GY28803@dastard>
References: <20110114002900.GF16267@dastard> <20110114164016.GB30134@sgi.com>
	<20110114225907.GH16267@dastard> <20110115041629.GC11968@sgi.com>
	<20110117051827.GL16267@dastard> <20110117143708.GE11968@sgi.com>
	<20110118002437.GS28803@dastard> <20110118143000.GB8803@sgi.com>
	<20110118204008.GA28791@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118204008.GA28791@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 18, 2011 at 03:40:09PM -0500, Christoph Hellwig wrote:
> On Tue, Jan 18, 2011 at 08:30:00AM -0600, Geoffrey Wehrman wrote:
> > Glad you were able to understand what I meant.  Something I didn't think
> > of earlier though:  What happens when I try to use an 8 GB on a system
> > with only 4 GB of memory?  I'm not really worried about this pathological
> > case, but I do wonder what the effects will be of allocating what could
> > be significant quantities of memory in .aio_write.
> 
> I think for large regions we'd be much better off to only zero the
> blocks on disk, not in-memory - for example like the code in
> xfs_zero_remaining_bytes does.

That doesn't help us, because the .writepage allocation code will
still allocate extsize aligned extents and expose the problem that
we have blocks on disk with no data in the page cache covering
them. The point of zeroing at .aio_write is that it avoids the
problem of .writepage allocating blocks we don't have dirty pages
for.

My preferred optimisation for this problem is that once we get above
a certain extsize threshold we simply preallocate extsized and
aligned chunks that cover the entire range for the write instead of
writing zeros. That preserves the extsize allocation alignment, and
unaligned writes and future IO see the space as unwritten and hence
get zeroed correctly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
