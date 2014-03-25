Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99E157F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 13:08:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76FB6304070
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 11:08:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bqUcIOfkT5WFk1qn for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 11:08:23 -0700 (PDT)
Date: Wed, 26 Mar 2014 05:08:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix buffer use after free on IO error
Message-ID: <20140325180814.GF18572@destitution>
References: <532CFA12.4040104@redhat.com>
	<20140325125754.GA18691@bfoster.bfoster>
	<20140325131705.GB25392@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140325131705.GB25392@infradead.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 25, 2014 at 06:17:05AM -0700, Christoph Hellwig wrote:
> > On Fri, Mar 21, 2014 at 09:48:50PM -0500, Eric Sandeen wrote:
> > > +	/*
> > > +	 * If _xfs_buf_ioapply failed, we'll get back here with
> > > +	 * only the reference we took above.  _xfs_buf_ioend will
> > > +	 * drop it to zero, so we'd better not queue it for later,
> > > +	 * or we'll free it before it's done.
> > > +	 */
> > > +	_xfs_buf_ioend(bp, bp->b_error ? 0 : 1);
> > >  
> > 
> > Out of curiosity, is there any major reason we don't use 0 here
> > unconditionally? Are we worried about I/O completing before we have a
> > chance to decrement the reference?
> 
> I think this should unconditionally avoid the schedule, and while we're
> at it we should kill _xfs_buf_ioend and opencode it here and at the
> other callsite.

I thought we schduled here because we can issue IO from IO
completion and so we need to requeue the IO completion rather than
run it inline in the current IO completion that hasn't fully
completed it's processing yet..

> Also atomic_dec_and_test really just returns true/false - there should
> ne no need for the explicit == 1 in the conditional.

Right, there's several other cleanups around this code that can be
done as Eric has mentioned...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
