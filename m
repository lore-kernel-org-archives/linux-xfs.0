Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D8957F6C
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 07:46:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E044304048
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 05:46:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eBWPPjUoZVOVq1CS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 05:46:46 -0700 (PDT)
Date: Thu, 25 Jun 2015 08:46:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remote attribute headers contain an invalid LSN
Message-ID: <20150625124643.GA36162@bfoster.bfoster>
References: <1434948369-13931-1-git-send-email-david@fromorbit.com>
	<20150624131228.GC1888@bfoster.bfoster>
	<20150624212643.GJ22807@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150624212643.GJ22807@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 25, 2015 at 07:26:43AM +1000, Dave Chinner wrote:
> On Wed, Jun 24, 2015 at 09:12:28AM -0400, Brian Foster wrote:
> > On Mon, Jun 22, 2015 at 02:46:09PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> 
...
> > The rest of the code
> > all looks fine to me, but a question to help me grok the bigger picture:
> >
> > We allocate these attr blocks in xfs_attr_rmtval_set(). If the writes
> > are synchronous, shouldn't those allocation transactions be synchronous
> > as well? IOW, what prevents our synchronous writes going to freed blocks
> > or blocks allocated to something else (if a block were freed,
> > reallocated as an attr block and sync. written without making it to the
> > ail) due to a crash immediately following the sync. write?
> 
> Well, the historical reason this is safe is that we don't reallocate
> freed blocks until the the transaction that frees them is committed.
> That's what the extent busy list prevents, and things like the calls
> to xfs_extent_busy_trim() in extent allocation do to avoid
> reallocating freed-but-not-committed extents.
> 

I figured that if this were handled, the extent busy list would have
something to do with it. I couldn't really see how given that it
supports reuse of busy blocks, however.

I do now see that we only attempt to reuse busy blocks from the
allocator when free space is low, so I take it that in most cases the
busy blocks should be simply trimmed out of the allocation. Therefore,
if this were broken in any way, it would probably be rare to actually
reproduce a problem.

> That said, i think there may be a problem here with the sync write -
> we can reallocate metadata blocks while they are busy because we log
> the new contents rather than write them in place.  The problem here
> is the remote attr block is allocated as a metadata block and so
> can use busy extents but we don't log th new contents.
> 

Ok, I also now see that in the event that we do need to reuse busy
blocks, a userdata allocation will actually force the log to complete
the busy cycle on those blocks, as opposed to simply fixing up the busy
list (e.g., as for a metadata alloc.).

> Hence I think that we probably also need to remove the
> XFS_BMAPI_METADATA flag from xfs_attr_rmtval_set() so that it
> doesn't allocate busy blocks. i.e. treat the remote attribute blocks
> like user datai blocks, as that already handles the case of being
> written to before we commit the allocation transaction....
> 

So as noted above, were this treated as a typical metadata block, the
corresponding buffer would be logged and thus everything would be
ordered appropriately with respect to the log. It is not a logged buffer
in this case, so we drop XFS_BMAPI_METADATA flag from the allocation
which would cause any previous frees of this block to be flushed to the
ail.

I don't see anything explicit that "handles" the case of being written
before the allocation transaction is committed. By "handles," do you
simply mean the aforementioned log force? In other words, we're
implicitly saying it's fine that the block is written out of order from
the allocation, so long as the block is marked free on-disk.

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
