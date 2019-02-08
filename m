Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:12442 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbfBHCrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 21:47:35 -0500
Date: Fri, 8 Feb 2019 13:47:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190208024730.GM14116@dastard>
References: <20190207050813.24271-1-david@fromorbit.com>
 <20190207052114.GA7991@magnolia>
 <20190207053941.GL14116@dastard>
 <20190207155242.GE2880@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207155242.GE2880@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 10:52:43AM -0500, Brian Foster wrote:
> On Thu, Feb 07, 2019 at 04:39:41PM +1100, Dave Chinner wrote:
> > On Wed, Feb 06, 2019 at 09:21:14PM -0800, Darrick J. Wong wrote:
> > > On Thu, Feb 07, 2019 at 04:08:10PM +1100, Dave Chinner wrote:
> > > > Hi folks,
> > > > 
> > > > I've just finished analysing an IO trace from a application
> > > > generating an extreme filesystem fragmentation problem that started
> > > > with extent size hints and ended with spurious ENOSPC reports due to
> > > > massively fragmented files and free space. While the ENOSPC issue
> > > > looks to have previously been solved, I still wanted to understand
> > > > how the application had so comprehensively defeated extent size
> > > > hints as a method of avoiding file fragmentation.
....
> > FWIW, I think the scope of the problem is quite widespread -
> > anything that does open/something/close repeatedly on a file that is
> > being written to with O_DSYNC or O_DIRECT appending writes will kill
> > the post-eof extent size hint allocated space. That's why I suspect
> > we need to think about not trimming by default and trying to
> > enumerating only the cases that need to trim eof blocks.
> > 
> 
> To further this point.. I think the eofblocks scanning stuff came long
> after the speculative preallocation code and associated release time
> post-eof truncate.

Yes, I cribed a bit of the history of the xfs_release() behaviour
on #xfs yesterday afternoon:

 <djwong>	dchinner: feel free to ignore this until tomorrow if you want, but /me wonders why we'd want to free the eofblocks at close time at all, instead of waiting for inactivation/enospc/background reaper to do it?
 <dchinner>	historic. People doing operations then complaining du didn't match ls
 <dchinner>	stuff like that
 <dchinner>	There used to be a open file cache in XFS - we'd know exactly when the last reference went away and trim it then
 <dchinner>	but that went away when NFS and the dcache got smarter about file handle conversion
 <dchinner>	(i.e. that's how we used to make nfs not suck)
 <dchinner>	that's when we started doing work in ->release
 <dchinner>	it was close enough to "last close" for most workloads it made no difference.
 <dchinner>	Except for concurrent NFS writes into the same directory
 <dchinner>	and now there's another pathological application that triggers problems
 <dchinner>	The NFS exception was prior to having thebackground reaper
 <dchinner>	as these things goes the background reaper is relatively recent functionality
 <dchinner>	so perhaps we should just leave it to "inode cache expiry or background reaping" and not do it on close at al

> I think the background scanning was initially an
> enhancement to deal with things like the dirty release optimization
> leaving these blocks around longer and being able to free up this
> accumulated space when we're at -ENOSPC conditions.

Yes, amongst other things like slow writes keeping the file open
forever.....

> Now that we have the
> scanning mechanism in place (and a 5 minute default background scan,
> which really isn't all that long), it might be reasonable to just drop
> the release time truncate completely and only trim post-eof blocks via
> the bg scan or reclaim paths.

Yeah, that's kinda the question I'm asking here. What's the likely
impact of not trimming EOF blocks at least on close apart from
people complaining about df/ls not matching du?

I don't really care about that anymore because, well, reflink/dedupe
completely break any remaining assumption that du reported space
consumption is related to the file size (if sparse files wasn't
enough of a hint arlready)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
