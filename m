Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24M1jkr200471 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 16:01:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5CA9216B8A
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 14:03:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	y2t7udb708JITTkm for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 14:03:12 -0800 (PST)
Date: Fri, 5 Mar 2010 09:03:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: truncate delalloc extents when IO fails in
	writeback
Message-ID: <20100304220309.GI14317@discord.disaster>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-3-git-send-email-david@fromorbit.com>
	<20100304142851.GA19157@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100304142851.GA19157@infradead.org>
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

On Thu, Mar 04, 2010 at 09:28:51AM -0500, Christoph Hellwig wrote:
> On Thu, Mar 04, 2010 at 12:46:24PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently use block_invalidatepage() to clean up pages where I/O
> > fails in ->writepage(). Unfortunately, if the page has delalloc
> > regions on it, we fail to remove the delalloc regions when we
> > invalidate the page.  This can result in tripping a BUG() in
> > xfs_get_blocks() later on if a direct IO read is done on that same
> > region - the delalloc extent is returned when none is supposed to be
> > there.
> > 
> > Fix this by truncating away the delalloc regions on the page before
> > invalidating it. Because they are delalloc, we can do this without
> > needing a transaction. Indeed - if we get ENOSPC errors, we have to
> > be able to do this truncation without a transaction as there is
> > no space left for block reservation (typically why we see a ENOSPC
> > in writeback).
> 
> The code looks good to me, but it could use a bit more documentation
> from the page description above inside the code.  

Good point. I'll add some comments to it...

> > +static void
> > +xfs_aops_discard_page(
> 
> This seems like a prime candidate for STATIC to make sure the
> over-eager compiler doesn't inline it into xfs_page_state_convert.

Will do.

> > -		cur->bc_private.b.firstblock = *firstblock;
> > +		cur->bc_private.b.firstblock = firstblock ?
> > +						*firstblock : NULLFSBLOCK;
> >  		cur->bc_private.b.flist = flist;
> >  		cur->bc_private.b.flags = 0;
> >  	} else
> > @@ -5503,7 +5504,8 @@ error0:
> >  		xfs_trans_log_inode(tp, ip, logflags);
> >  	if (cur) {
> >  		if (!error) {
> > -			*firstblock = cur->bc_private.b.firstblock;
> > +			if (firstblock)
> > +				*firstblock = cur->bc_private.b.firstblock;
> 
> I don't think it's a good idea to throw this change in as part of
> this patch.  I'd rather throw in the xfs_bmap_init and two
> useless arguments for now and clean up the calling conventions later.
> For which is more than enough opportunity, e.g. there's a totally
> unused delta argument in xfs_bunmapi.

I was undecided about which method to use. In the end I went with
the above because it was easier to check that correct behaviour was
occurring. i.e. if firstblock get used, then I'd see a panic. I'll
switch it to the variable method, and try to find the right
combination of ASSERT() calls to make sure it hasn't been used.

Thanks Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
