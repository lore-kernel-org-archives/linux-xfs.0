Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAHMvO6l064316 for <xfs@oss.sgi.com>; Sat, 17 Nov 2012 16:57:24 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HRwE42p42WdJ33rB for <xfs@oss.sgi.com>;
	Sat, 17 Nov 2012 14:59:30 -0800 (PST)
Date: Sun, 18 Nov 2012 09:59:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfsprogs: Introduce a new subcommand agstate to
	xfs_fio
Message-ID: <20121117225927.GQ14281@dastard>
References: <50A5E258.3000509@oracle.com> <20121117020231.GP14281@dastard>
	<50A71386.80100@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A71386.80100@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Sat, Nov 17, 2012 at 12:33:10PM +0800, Jeff Liu wrote:
> On 11/17/2012 10:02 AM, Dave Chinner wrote:
> > On Fri, Nov 16, 2012 at 02:51:04PM +0800, Jeff Liu wrote:
> >> Introduce a new xfs_io command: agstate.
> >>
> >> This command is used to get/set state for a given allocation group.
> > 
> > xfs_io is not the place for this command.
> I was also wonder why we place the agflags command on there since xfs_io is aimed
> at examining the regular file I/O paths, but I can not found out a better place
> while implementing it.

Right. That's exactly why I'm adding the xfs_spaceman command :)

> > A couple of weeks ago I started writing an xfs_spaceman module
> > and an ioctl interface for exactly this purpose, I just hadn't
> > got around to completing it and the kernel patch to test it so I
> > hadn't posted it.  Once the userspace release is out of the way,
> > I'll post the patches to get xfs_spaceman into xfs_progs, and we
> > can use that for this AG control from the start.
> > 
> > The reason for this is that the AG state in future is going to
> > be a lot more complex than just enabling/disabling allocation,
> > and the ioctl interface I prototyped supports a lot of that
> > future functionality.
> Definitely, so that we can have fine-granted AG controls, that's
> why I didn't chose to re-base/post the previous agflags patch but
> proposed the agstate command because the naming would sounds more
> reasonable.

*nod*

> > 
> > The patch is below so you can see what sort of AG control/state
> > functionality I think we'll be needing sooner rather than later,
> > and the interface I think we should be using...
> Ok, I'll waiting for this feature. :)
> 
> BTW, Does it sounds make sense if we implement parent pointer
> support at first?
> http://www.xfs.org/index.php/Unfinished_work#Parent_Pointers.2FCreate.2BEA
> I propose this because it would reduce many efforts for
> implementing xfs_shrinkfs command, and reduce the overhead for
> iterating overall file systems to find out files which are located
> at offline AGs.

That does need to be completed, though it's more of an optimisation
for the shrink process than absolutely necessary functionality.
Similarly for the rmap allocation btree (tracks used space and it's
owner) that I'm also working on. Being able to walk the used space
in an AG directly and immediately resolve the owner without a
directory tree walk or inode scan will make things ever faster....

Hence I think just having shrink dumb and slow as a first step is
just fine and speed can wait until we have all the necessary
infrastructure in place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
