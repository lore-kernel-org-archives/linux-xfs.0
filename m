Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753983AbeBGOrN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Feb 2018 09:47:13 -0500
Date: Wed, 7 Feb 2018 09:47:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_io: support a basic extent swap command
Message-ID: <20180207144711.GA9789@bfoster.bfoster>
References: <20180206130247.61882-1-bfoster@redhat.com>
 <20180207013441.fwxtfm7nbtsjwidp@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180207013441.fwxtfm7nbtsjwidp@destitution>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 07, 2018 at 12:34:41PM +1100, Dave Chinner wrote:
> On Tue, Feb 06, 2018 at 08:02:47AM -0500, Brian Foster wrote:
> > Extent swap is a low level mechanism exported by XFS to facilitate
> > filesystem defragmentation. It is typically invoked by xfs_fsr under
> > conditions that will atomically adjust inode extent state without
> > loss of file data.
> > 
> > xfs_fsr does not provide the necessary controls for low-level
> > testing of the extent swap command, however. For example, xfs_fsr
> > implements policies that dictate when to perform an extent swap and
> > offers no control over the donor file characteristics.
> 
> Hmmmm. I'm confused - we already use xfs_fsr for low level testing
> of swapext functionality with carefully constructed donor file
> characteristics in xfs/227.
> 
> What am I missing here?
> 

AFAICT, xfs/227 does so by formatting the filesystem in a particular way
and running fsr over it, so it wasn't immediately clear to me what
you're referring to. Staring at it some more, it appears to be using the
-C debug option which looks like it forces an extent count..? If that's
the case, the test[1] that was posted to use this feature could probably
be modified to do a similar thing via xfs_fsr.

Giving it a quick test, it doesn't appear to do exactly what I want with
larger extent counts, however. It seems to work with a few extents or
so, then doesn't ever create more than 4 or 5 if that's what I ask for
with the donor file. Hmm, I wonder if prealloc or something is getting
in the way of whatever it's attempting to do. If I try a similar test
using falloc instead of pwrite, it doesn't do the swap at all. :/

Note that xfs/227 uses counts 5-15, so that also makes me wonder whether
that test is actually doing what is expected, but that's a separate
question (and I haven't dug into any of this deeply enough). I could
just be misunderstanding the option.

> I don't see any problem with adding a specific command to run
> more controlled swapext tests, i just want to make sure I understand
> what xfs_fsr is not providing you with.
> 

I wasn't aware of 'xfs_fsr -C', thanks for pointing it out. I just
looked at the fsr help/manpage to see if there was any "input file"
capability and missed it. Having given it a quick test, I still prefer
the existing test because it is explicit and doesn't have to copy data
or anything like that. IOW, the -C thing to me seems like an fsr unit
test whereas what I really want is a swapext unit test.

FWIW, I do already have a variant of the test that reproduces the
problem in question using xfs_fsr (without -C). The donor file extent
count thing isn't actually a hard requirement to reproduce, just an
advantage I was trying to document in the commit log for this patch.
With respect to the test, the predictable extent count thing is more for
efficiency purposes because it allows the test to run having only done a
one-time set up of two files (the rest is hole punching and extent
swaps). So I had already abandoned using xfs_fsr in favor of the current
test for similar reasons: it was significantly slower due to the
additional work required to set up the fs, unnecessary file data copying
involved, etc.

So unless there's any objections, I can try to reword the commit log for
this patch to make the advantages/differences more clear.

Brian

[1] https://marc.info/?l=fstests&m=151792263511472&w=2

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
