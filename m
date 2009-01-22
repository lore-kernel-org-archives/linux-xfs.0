Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MNbCGi122705 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 17:37:13 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 646581852868
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 15:36:26 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	3vs3cwtCglGZMUbi for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2009 15:36:26 -0800 (PST)
Date: Fri, 23 Jan 2009 10:35:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122233542.GA32390@disturbed>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice>
	<20090121035703.GH10158@disturbed>
	<200901211503.07308.nickpiggin@yahoo.com.au>
	<20090122043747.GU10158@disturbed>
	<20090122061158.GA31104@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122061158.GA31104@infradead.org>
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
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Pavel Machek <pavel@suse.cz>, npiggin@yahoo.com.au, Chris Mason <chris.mason@oracle.com>

On Thu, Jan 22, 2009 at 01:11:58AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> >  xfs_buf_t *
> >  xlog_get_bp(
> >  	xlog_t		*log,
> > -	int		num_bblks)
> > +	int		nbblks)
> 
> Any reason for reanming this variable?  That causes quite a bit of
> churn.

Just so it was the same variable name as the other I/O functions
around it. It's kind of strange to have one function use num_bblks
and another 4 or so related functions use nbblks....

> >  {
> > -	ASSERT(num_bblks > 0);
> > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> 
> And doesn't prevent this line from needing a linebreak to stay under 80
> characters :)

I'll respin it to fix this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
