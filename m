Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC43A7F47
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 15:18:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AAA9B8F8065
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 13:18:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kJgCAB1g6AbDgosx for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 13:18:17 -0700 (PDT)
Date: Wed, 15 Apr 2015 06:18:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: DIO writes within EOF don't need an ioend
Message-ID: <20150414201815.GV15810@dastard>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
	<1428996411-1507-6-git-send-email-david@fromorbit.com>
	<20150414143519.GF36198@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150414143519.GF36198@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 14, 2015 at 10:35:19AM -0400, Brian Foster wrote:
> On Tue, Apr 14, 2015 at 05:26:48PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > DIO writes that lie entirely within EOF have nothing to do in IO
> > completion. In this case, we don't need no steekin' ioend, and so we
> > can avoid allocating an ioend until we have a mapping that spans
> > EOF.
> > 
> > This means that IO completion has two contexts - deferred completion
> > to the dio workqueue that uses an ioend, and interrupt completion
> > that does nothing because there is nothing that can be done in this
> > context.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c  | 62 ++++++++++++++++++++++++++++++------------------------
> >  fs/xfs/xfs_trace.h |  1 +
> >  2 files changed, 36 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index e3968a3..55356f6 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -1234,15 +1234,19 @@ xfs_vm_releasepage(
> >  }
> >  
> >  /*
> > - * When we map a DIO buffer, we need to attach an ioend that describes the type
> > + * When we map a DIO buffer, we may need to attach an ioend that describes the type
> >   * of write IO we are doing. This passes to the completion function the
> > - * operations it needs to perform.
> > + * operations it needs to perform. If the mapping is for an overwrite wholly
> > + * within the EOF then we don't need an ioend and so we don't allocate one. This
> > + * avoids the unnecessary overhead of allocating and freeing ioends for
> > + * workloads that don't require transactions on IO completion.
> >   *
> >   * If we get multiple mappings to in a single IO, we might be mapping dfferent
> >   * types. But because the direct IO can only have a single private pointer, we
> >   * need to ensure that:
> >   *
> > - * a) the ioend spans the entire region of the IO; and
> > + * a) i) the ioend spans the entire region of unwritten mappings; or
> > + *    ii) the ioend spans all the mappings that cross or are beyond EOF; and
> >   * b) if it contains unwritten extents, it is *permanently* marked as such
> >   *
> >   * We could do this by chaining ioends like buffered IO does, but we only
> > @@ -1283,7 +1287,8 @@ xfs_map_direct(
> >  		trace_xfs_gbmap_direct_update(XFS_I(inode), ioend->io_offset,
> >  					      ioend->io_size, ioend->io_type,
> >  					      imap);
> > -	} else {
> > +	} else if (type == XFS_IO_UNWRITTEN ||
> > +		   offset + size > i_size_read(inode)) {
> >  		ioend = xfs_alloc_ioend(inode, type);
> >  		ioend->io_offset = offset;
> >  		ioend->io_size = size;
> > @@ -1291,10 +1296,13 @@ xfs_map_direct(
> >  
> >  		trace_xfs_gbmap_direct_new(XFS_I(inode), offset, size, type,
> >  					   imap);
> > +	} else {
> > +		trace_xfs_gbmap_direct_none(XFS_I(inode), offset, size, type,
> > +					    imap);
> 
> Do we really need a tracepoint to indicate none of the other tracepoints
> were hit? It stands out to me only because we already have the
> unconditional trace_xfs_gbmap_direct() above. I'd say kill one or the
> other, but I think we really want the function entry one because it
> disambiguates individual get_block instances from the aggregate mapping.

I found this incredibly useful in debugging this code, because it
told me exactly what each mapping call was doing, and from that I
could see if it was doing the right thing. Yes, i could infer it
from the entry trace point, but grepping on the entry tracepoint
gets *all* the mapping calls, not just the overwrites wholly within
EOF...

> > +		return;
> >  	}
> >  
> > -	if (ioend->io_type == XFS_IO_UNWRITTEN || xfs_ioend_is_append(ioend))
> > -		set_buffer_defer_completion(bh_result);
> > +	set_buffer_defer_completion(bh_result);
> 
> I'd move this up into the block where we allocate an ioend. That's the
> only place we need it and doing so eliminates the need for the 'else {
> return; }' thing entirely.

Yeah, that would work, too.

> >  STATIC void
> >  xfs_end_io_direct_write(
> > @@ -1531,7 +1541,10 @@ xfs_end_io_direct_write(
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_ioend	*ioend = private;
> >  
> > -	trace_xfs_gbmap_direct_endio(ip, offset, size, ioend->io_type, NULL);
> > +	trace_xfs_gbmap_direct_endio(ip, offset, size,
> > +				     ioend ? ioend->io_type : 0, NULL);
> > +	if (!ioend)
> > +		return;
> 
> Can we keep the i_size assert we've lost below?
> 
> ASSERT(offset + size <= i_size_read(inode));

Sure, I can add it for that case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
