Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7574E7F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 17:01:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60799304032
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 15:00:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HuEqmF5jBlV052yt for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 15:00:56 -0700 (PDT)
Date: Wed, 23 Sep 2015 08:00:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: Implement inodes64 command
Message-ID: <20150922220054.GL19114@dastard>
References: <1442825768-5793-1-git-send-email-cmaiolino@redhat.com>
	<20150921220832.GB19114@dastard>
	<20150922075432.GC26699@redhat.com>
	<20150922122238.GA46026@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150922122238.GA46026@bfoster.bfoster>
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

On Tue, Sep 22, 2015 at 08:22:39AM -0400, Brian Foster wrote:
> On Tue, Sep 22, 2015 at 09:54:32AM +0200, Carlos Maiolino wrote:
> > On Tue, Sep 22, 2015 at 08:08:32AM +1000, Dave Chinner wrote:
> > > On Mon, Sep 21, 2015 at 10:56:08AM +0200, Carlos Maiolino wrote:
> ...
> > > > +
> > > > +	bulkreq.lastip = &last;
> > > > +	bulkreq.icount = 1;
> > > > +	bulkreq.ubuffer = &igroup;
> > > > +	bulkreq.ocount = &count;
> > > > +
> > > > +	if (!xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq)) {
> > > > +		if (count > 0) {
> > > > +			printf("Filesystem does have 64bit inodes\n");
> > > > +			return 0;
> > > > +		} else {
> > > > +			printf("Filesystem does not have 64bit inodes\n");
> > > > +			return 0;
> > > > +		}
> > > > +	}
> > > > +	perror("xfsctl(XFS_IOC_FSINUMBERS)");
> > > 
> > > I'd do this the other way around:
> > > 
> > > 	if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq)) {
> > > 		perror("XFS_IOC_FSINUMBERS");
> > > 		exitcode = 1;
> > > 		return 0;
> > > 	}
> > > 
> > > 	if (count > 0)
> > > 		printf("Filesystem does have 64bit inodes\n");
> > > 	else
> > > 		printf("Filesystem does not have 64bit inodes\n");
> > > 	return 0;
> > > 
> > > is sufficient, xfsctl is a one line wrapper around ioctl().
> > >
> > 
> > Ok, I'll change this, but, just a matter of curiosity, what are the technical
> > reasons to write the conditional this way, instead of the way I wrote first?
> > Just to avoid entering the conditional?
> > 
> 
> Not to speak for Dave, but I had the same thought just skimming through
> the patch. I don't think it's a technical reason so much as a style one.
> The further the function is grown, the easier it is to see that this
> kind of flow is not the most friendly thing. E.g.:
> 
> 	ret = do_stuff();
> 	if (!ret) {
> 		...
> 		ret = do_more_stuff();
> 		if (!ret) {
> 			...
> 		}
> 	}
> 
> In other words, the common execution path of the function starts to flow
> "inward" rather than the natural top-down flow of the function:
> 
> 	ret = do_stuff();
> 	if (ret)
> 		handle_err;
> 
> 	ret = do_more_stuff();
> 	if (ret)
> 		handle_err;
> 	...
> 
> The latter tends to be easier to follow, easier to review the error
> handling cases, probably avoids indentation problems down the road, etc.
> The function as it is right now is simple and so this probably isn't a
> big deal, but I suspect seeing the latter form so frequently in all of
> our other code is probably what causes something like the former to
> stand out (even in a simple/harmless example). Just my .02. :)

That's pretty much it from a code maintenance POV.

Also, though, consider how the compiler optimises code - the code
inside an if () condition usually involves resolving a branch
due to a jump statement to somewhere else. IOWs, your original code
might end up looking something like this:

	if (condition)
		goto L1
	<code>
ret:
	return
L1:
	if (condition)
		goto L2
	<code>
	goto ret;
L2:
	if (condition)
		goto L3
	<code>
	goto ret;
L3:
	.....

and so a series of nested conditions results in lots of branches
beign taken during the fast path execution. That leads to a 
larger CPU instruction cache footprint that the code generated from
the latter case, which looks like:

	if (!condition)
		goto L1
	if (!condition)
		goto L2
	if (!condition)
		goto L3
	<code>
ret:
	return
L1:
	<code>
	goto ret;
L2
	<code>
	goto ret;
L3:
	.....

See the difference in the fast path execution? It's compact and no
branches are taken anywhere and so has a smaller instruction cache
footprint. And less instruction cache misses mean faster code
execution.

Hence on top of the code is being easier to read, modify and
maintain, and it's also much easier for the compiler to optimise
into fast, efficient code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
