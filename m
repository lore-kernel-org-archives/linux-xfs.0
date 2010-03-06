Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26BtrVr084285 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 05:55:53 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A202021FD46
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 03:57:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	QgOFBD82kiZQmmPe for <xfs@oss.sgi.com>;
	Sat, 06 Mar 2010 03:57:21 -0800 (PST)
Date: Sat, 6 Mar 2010 22:57:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: split out iclog writing from xfs_trans_commit()
Message-ID: <20100306115718.GC28189@discord.disaster>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<1267840284-4652-6-git-send-email-david@fromorbit.com>
	<20100306110833.GF30376@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100306110833.GF30376@infradead.org>
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

On Sat, Mar 06, 2010 at 06:08:33AM -0500, Christoph Hellwig wrote:
> On Sat, Mar 06, 2010 at 12:51:20PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Split the the part of xfs_trans_commit() that deals with writing the
> > transaction into the iclog into a separate function. This isolates the
> > physical commit process from the logical commit operation and makes
> > it easier to insert different transaction commit paths without affecting
> > the existing algorithm adversely.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good, but some comments below:
> 
> > +        if (nvec > XFS_TRANS_LOGVEC_COUNT)
> > +                kmem_free(log_vector);
> 
> These two lines are indented with whitespaces instead of tabs.

Oops. Looks like I need to update my whitespace damage highlighting
rule...

> > +shut_us_down:
> > +	shutdown = XFS_FORCED_SHUTDOWN(mp) ? EIO : 0;
> > +	if (!(tp->t_flags & XFS_TRANS_DIRTY) || shutdown) {
> > +		xfs_trans_unreserve_and_mod_sb(tp);
> > +		/*
> 
> This whole area in _xfs_trans_commit is still a complete mess.

Yes, it is I didn't touch that part of the function, even though the
diff moves the whole thing about. Actually, the diff makes the
change look for more complex than it really is because it doesn't
keep it as three separate chunks of code that got moved....

> What about throwing the patch below in once you're rewriting it anyway?

I'll add it to the series and see how it goes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
