Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11847 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752456AbdLFV5O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 16:57:14 -0500
Date: Thu, 7 Dec 2017 08:57:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7] generic: initial fiemap range query test
Message-ID: <20171206215711.GG5858@dastard>
References: <1512057927-15022-1-git-send-email-nborisov@suse.com>
 <20171206174506.GI19219@magnolia>
 <0d1b5c25-9187-1405-17a2-1e44b65c53a8@suse.com>
 <20171206210659.GE6896@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206210659.GE6896@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net

On Wed, Dec 06, 2017 at 01:06:59PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 06, 2017 at 10:51:39PM +0200, Nikolay Borisov wrote:
> > On  6.12.2017 19:45, Darrick J. Wong wrote:
> > > On Thu, Nov 30, 2017 at 06:05:27PM +0200, Nikolay Borisov wrote:
> > >> new file mode 100644
> > >> index 0000000..3df6a3a
> > >> --- /dev/null
> > >> +++ b/tests/generic/900.out
> > >> @@ -0,0 +1,196 @@
> > >> +QA output created by 900
> > >> +Basic data extent
> > >> +0: [128..255]: data
> > >> +Data + Hole
> > >> +0: [128..255]: data
> > >> +1: [256..287]: hole
> > >> +Hole + Data
> > >> +0: [0..127]: hole
> > >> +1: [128..255]: data
> > > 
> > > This fails on XFS:
> > > 
> > > $ xfs_io -c "fiemap -v 0 65k" file
> > > moo:
> > >  EXT: FILE-OFFSET      BLOCK-RANGE        TOTAL FLAGS
> > >    0: [0..127]:        hole                 128
> > >    1: [128..135]:      74391184..74391191     8   0x0
> > > 
> > > (Note the records are trimmed to sector 135, or 65k)
> > > 
> > > Compare to ext4:
> > > 
> > > $ xfs_io -c "fiemap -v 0k 65k" file
> > > moo:
> > >  EXT: FILE-OFFSET      BLOCK-RANGE            TOTAL FLAGS
> > >    0: [0..127]:        hole                     128
> > >    1: [128..255]:      2510790784..2510790911   128   0x0
> > > 
> > > (ext4 doesn't bother trimming)
> > > 
> > > Documentation/filesystems/fiemap.txt says "...the logical offset of the
> > > 1st returned extent may start before fm_start, and the range covered by
> > > the last returned extent may end after fm_length", so both behaviors are
> > > allowed.
> > 
> > So how do you propose the test to deal with the fact that XFS is the
> > only file system (of the mainstream ones at least) that trims the extents?
> 
> Put:
> 
> test "$FSTYP" = "xfs" && _notrun "This is tested by xfs/XXX"
> 
> in this test and then duplicate it as some xfs/ test with whatever the
> correct output is on xfs.  Also add some checks for fiemap -a since we
> actually have attribute block maps on xfs.

No, please don't do stupid things like this to work around
unpredictable output from a *newly implemented command*.

There's a *simple answer* to this problem: fix the new command's
output.

That is: the user asked for a specific range, so the command itself
should trim the map returned by the kernel to only display the exact
range the user asked for.  Then it doesn't matter if the underlying
filesystem trims the extents or not, because the we're going to do
that anyway in userspace.

> (let's see if hch/dchinner come in and NAK the whole thing on the
> grounds that FIEMAP is a debugging interface anyway...)

I've stayed out of it as much as I can, but when I see spiralling
stupidity^Wcomplexity like this I'm going to open my big mouth and
put my foot as far into it as I can. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
