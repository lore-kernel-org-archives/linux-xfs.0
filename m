Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59006 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbeBGXX1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 18:23:27 -0500
Date: Wed, 7 Feb 2018 15:23:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: support a basic extent swap command
Message-ID: <20180207232319.GA5433@magnolia>
References: <20180206130247.61882-1-bfoster@redhat.com>
 <20180207013441.fwxtfm7nbtsjwidp@destitution>
 <20180207144711.GA9789@bfoster.bfoster>
 <20180207230217.GA20367@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180207230217.GA20367@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Feb 08, 2018 at 10:02:17AM +1100, Dave Chinner wrote:
> On Wed, Feb 07, 2018 at 09:47:12AM -0500, Brian Foster wrote:
> > On Wed, Feb 07, 2018 at 12:34:41PM +1100, Dave Chinner wrote:
> > > On Tue, Feb 06, 2018 at 08:02:47AM -0500, Brian Foster wrote:
> > > > Extent swap is a low level mechanism exported by XFS to facilitate
> > > > filesystem defragmentation. It is typically invoked by xfs_fsr under
> > > > conditions that will atomically adjust inode extent state without
> > > > loss of file data.
> > > > 
> > > > xfs_fsr does not provide the necessary controls for low-level
> > > > testing of the extent swap command, however. For example, xfs_fsr
> > > > implements policies that dictate when to perform an extent swap and
> > > > offers no control over the donor file characteristics.
> > > 
> > > Hmmmm. I'm confused - we already use xfs_fsr for low level testing
> > > of swapext functionality with carefully constructed donor file
> > > characteristics in xfs/227.
> > > 
> > > What am I missing here?
> > > 
> > 
> > AFAICT, xfs/227 does so by formatting the filesystem in a particular way
> > and running fsr over it, so it wasn't immediately clear to me what
> > you're referring to. Staring at it some more, it appears to be using the
> > -C debug option which looks like it forces an extent count..? If that's
> > the case, the test[1] that was posted to use this feature could probably
> > be modified to do a similar thing via xfs_fsr.
> > 
> > Giving it a quick test, it doesn't appear to do exactly what I want with
> > larger extent counts, however. It seems to work with a few extents or
> > so, then doesn't ever create more than 4 or 5 if that's what I ask for
> > with the donor file. Hmm, I wonder if prealloc or something is getting
> > in the way of whatever it's attempting to do. If I try a similar test
> > using falloc instead of pwrite, it doesn't do the swap at all. :/
> 
> Yeah, that's because of the way xfs_fsr preserves unwritten extents
> across defragmentation. i.e. it assumes unwritten extents are a
> result of application level preallocation and so it's there
> intentionally and be preserved.
> 
> When I wrote this yesterday, I hadn't see the test you'd posted to
> the fstests list so I didn't have that context. Now that I've seen
> it, and you've explained the problems, I can see why you wrote the
> simpler xfs_io test command....
> 
> [....]
> 
> > So unless there's any objections, I can try to reword the commit log for
> > this patch to make the advantages/differences more clear.
> 
> Yeah, I think that's all that is necessary - just expand on
> "xfs_fsr does not provide the necessary controls" a bit so I don't
> have to rely on my brain to remember this conversation. :P

<shrug> I had figured xfs_fsr == "polished user program not to be
cluttered up with weird xfstests warts" and xfs_io == "warty program we
use to make raw calls for testing" so except for tests that check the
behavior of xfs_fsr itself, there ought to be a raw interface via xfs_io
that regression tests use directly. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
