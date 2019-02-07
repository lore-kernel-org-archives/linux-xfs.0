Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfBGPwp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 10:52:45 -0500
Date: Thu, 7 Feb 2019 10:52:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190207155242.GE2880@bfoster>
References: <20190207050813.24271-1-david@fromorbit.com>
 <20190207052114.GA7991@magnolia>
 <20190207053941.GL14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207053941.GL14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 04:39:41PM +1100, Dave Chinner wrote:
> On Wed, Feb 06, 2019 at 09:21:14PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 07, 2019 at 04:08:10PM +1100, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I've just finished analysing an IO trace from a application
> > > generating an extreme filesystem fragmentation problem that started
> > > with extent size hints and ended with spurious ENOSPC reports due to
> > > massively fragmented files and free space. While the ENOSPC issue
> > > looks to have previously been solved, I still wanted to understand
> > > how the application had so comprehensively defeated extent size
> > > hints as a method of avoiding file fragmentation.
> > > 
> > > The key behaviour that I discovered was that specific "append write
> > > only" files that had extent size hints to prevent fragmentation
> > > weren't actually write only.  The application didn't do a lot of
> > > writes to the file, but it kept the file open and appended to the
> > > file (from the traces I have) in chunks of between ~3000 bytes and
> > > ~160000 bytes. This didn't explain the problem. I did notice that
> > > the files were opened O_SYNC, however.
> > > 
> > > I then found was another process that, once every second, opened the
> > > log file O_RDONLY, read 28 bytes from offset zero, then closed the
> > > file. Every second. IOWs, between every appending write that would
> > > allocate an extent size hint worth of space beyond EOF and then
> > > write a small chunk of it, there were numerous open/read/close
> > > cycles being done on the same file.
> > > 
> > > And what do we do on close()? We call xfs_release() and that can
> > > truncate away blocks beyond EOF. For some reason the close wasn't
> > > triggering the IDIRTY_RELEASE heuristic that preventd close from
> > > removing EOF blocks prematurely. Then I realised that O_SYNC writes
> > > don't leave delayed allocation blocks behind - they are always
> > > converted in the context of the write. That's why it wasn't
> > > triggering, and that meant that the open/read/close cycle was
> > > removing the extent size hint allocation beyond EOF prematurely.
> > > beyond EOF prematurely.
> > 
> > <urk>
> > 
> > > Then it occurred to me that extent size hints don't use delalloc
> > > either, so they behave the same was as O_SYNC writes in this
> > > situation.
> > > 
> > > Oh, and we remove EOF blocks on O_RDONLY file close, too. i.e. we
> > > modify the file without having write permissions.
> > 
> > Yikes!
> > 
> > > I suspect there's more cases like this when combined with repeated
> > > open/<do_something>/close operations on a file that is being
> > > written, but the patches address just these ones I just talked
> > > about. The test script to reproduce them is below. Fragmentation
> > > reduction results are in the commit descriptions. It's running
> > > through fstests for a couple of hours now, no issues have been
> > > noticed yet.
> > > 
> > > FWIW, I suspect we need to have a good hard think about whether we
> > > should be trimming EOF blocks on close by default, or whether we
> > > should only be doing it in very limited situations....
> > > 
> > > Comments, thoughts, flames welcome.
> > > 
> > > -Dave.
> > > 
> > > 
> > > #!/bin/bash
> > > #
> > > # Test 1
> > 
> > Can you please turn these into fstests to cause the maintainer maximal
> > immediate pain^W^W^Wmake everyone pay attention^W^W^W^Westablish a basis
> > for regression testing and finding whatever other problems we can find
> > from digging deeper? :)
> 
> I will, but not today - I only understood the cause well enough to
> write a prototype reproducer about 4 hours ago. The rest of the time
> since then has been fixing the issues and running smoke tests. My
> brain is about fried now....
> 
> FWIW, I think the scope of the problem is quite widespread -
> anything that does open/something/close repeatedly on a file that is
> being written to with O_DSYNC or O_DIRECT appending writes will kill
> the post-eof extent size hint allocated space. That's why I suspect
> we need to think about not trimming by default and trying to
> enumerating only the cases that need to trim eof blocks.
> 

To further this point.. I think the eofblocks scanning stuff came long
after the speculative preallocation code and associated release time
post-eof truncate. I think the background scanning was initially an
enhancement to deal with things like the dirty release optimization
leaving these blocks around longer and being able to free up this
accumulated space when we're at -ENOSPC conditions. Now that we have the
scanning mechanism in place (and a 5 minute default background scan,
which really isn't all that long), it might be reasonable to just drop
the release time truncate completely and only trim post-eof blocks via
the bg scan or reclaim paths.

Brian

> e.g. I closed the O_RDONLY case, but O_RDWR/read/close in a loop
> will still trigger removal of post EOF extent size hint
> preallocation and hence severe fragmentation.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
