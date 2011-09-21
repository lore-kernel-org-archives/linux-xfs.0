Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LBSxer137666 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:28:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CD291609193
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 04:34:20 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KFQpg8xFZuiaIzkK for <xfs@oss.sgi.com>;
	Wed, 21 Sep 2011 04:34:20 -0700 (PDT)
Date: Wed, 21 Sep 2011 07:28:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
Message-ID: <20110921112856.GB30934@infradead.org>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
	<1314341497-23910-2-git-send-email-david@fromorbit.com>
	<20110826081132.GA3551@infradead.org>
	<20110921064443.GO15688@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110921064443.GO15688@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 21, 2011 at 04:44:43PM +1000, Dave Chinner wrote:
> 
> > And once you touch _xfs_buf_initialize
> > after the core of this patch, please merge it with xfs_buf_allocate into
> > a new xfs_buf_alloc that does the full allocation + initialization and
> > can also replace xfs_buf_get_empty.
> 
> Not right now. That restructing can be done separately, probably in
> the same patch set that fixes the API types problems...

That's what I meant - the conversion changes should be part of a larger
patch (-series) to also fix up the API, and this bit.

> > >  	if (bp == new_bp) {
> > >  		error = xfs_buf_allocate_memory(bp, flags);
> > >  		if (error)
> > >  			goto no_buffer;
> > > +	} else
> > >  		xfs_buf_deallocate(new_bp);
> > 
> > I'd recommend moving the call to xfs_buf_allocate_memory into
> > _xfs_buf_find so that it returns a fully allocated buffer.  In fact I'd
> > also move the xfs_buf_deallocate(new_bp) into the found side of
> > _xfs_buf_find, avoiding any conditionals in xfs_buf_get.
> 
> <sigh>
> 
> This code s pretty much as you requested it after the first time I
> posted it.
> 
> http://oss.sgi.com/archives/xfs/2011-08/msg00146.html
> 
> I'll go rewrite this again, but IMO all you are asking for is for me
> to put a different colour on the bike shed....

We can leave it as-is for now. My suggestion in the previous mail just
went half-way to where it makes most sense after looking at it for a
while.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
