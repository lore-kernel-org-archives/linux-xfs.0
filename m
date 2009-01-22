Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MNhvXM123116 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 17:43:57 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0121AAED3B
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 15:43:07 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	vfCNRTDGBz95p2G6 for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2009 15:43:07 -0800 (PST)
Date: Fri, 23 Jan 2009 10:37:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122233717.GB32390@disturbed>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice>
	<20090121035703.GH10158@disturbed>
	<200901211503.07308.nickpiggin@yahoo.com.au>
	<20090122043747.GU10158@disturbed>
	<20090122061158.GA31104@infradead.org>
	<20090122100648.GA16660@alice>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122100648.GA16660@alice>
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
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Pavel Machek <pavel@suse.cz>, npiggin@yahoo.com.au, Chris Mason <chris.mason@oracle.com>

On Thu, Jan 22, 2009 at 11:06:48AM +0100, Eric Sesterhenn wrote:
> * Christoph Hellwig (hch@infradead.org) wrote:
> > On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> > >  xfs_buf_t *
> > >  xlog_get_bp(
> > >  	xlog_t		*log,
> > > -	int		num_bblks)
> > > +	int		nbblks)
> > 
> > Any reason for reanming this variable?  That causes quite a bit of
> > churn.
> > 
> > >  {
> > > -	ASSERT(num_bblks > 0);
> > > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> > 
> > And doesn't prevent this line from needing a linebreak to stay under 80
> > characters :)
> > 
> > Except for these nitpicks it looks fine to me.
> 
> Using the image at http://www.cccmz.de/~snakebyte/xfs.254.img.bz2
> I was able to produce a pretty similar error with the patch applied

Different problem, obviously. ;)

I'll have a look at this later today....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
