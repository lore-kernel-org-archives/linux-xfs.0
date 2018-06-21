Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58368 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933415AbeFUQmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 12:42:09 -0400
Date: Thu, 21 Jun 2018 09:42:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: transactionless xfs_bunmapi shouldn't do format
 conversion
Message-ID: <20180621164205.GD4838@magnolia>
References: <20180619024128.22669-1-david@fromorbit.com>
 <20180619024128.22669-2-david@fromorbit.com>
 <20180619045405.GI8128@magnolia>
 <20180619052759.GH19934@dastard>
 <20180619060652.GW8128@magnolia>
 <20180619233317.GL19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619233317.GL19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 20, 2018 at 09:33:17AM +1000, Dave Chinner wrote:
> On Mon, Jun 18, 2018 at 11:06:52PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 19, 2018 at 03:27:59PM +1000, Dave Chinner wrote:
> > > On Mon, Jun 18, 2018 at 09:54:05PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jun 19, 2018 at 12:41:27PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > If we are punching out a delalloc extent, xfs_bunmapi() does not
> > > > > have a transaction context and should not ever need to convert the
> > > > > on-disk extent format. If such a thing is attempted (e.g. via a
> > > > > corrupt inode extent count in extent format) then we should abort
> > > > > with an EFSCORRUPTED error. Unfortunately, we don't do that and
> > > > > crash instead:
> > > > > 
> > > > >  XFS (loop0): page discard on page 0000000005fd24f3, inode 0x75e5, offset 0.
> > > > >  ==================================================================
> > > > >  BUG: KASAN: null-ptr-deref in xfs_alloc_get_freelist+0x115/0x350
> > > > >  Read of size 8 at addr 0000000000000028 by task a.out/1406
> > > > >  CPU: 0 PID: 1406 Comm: a.out Not tainted 4.17.0-rc4-kasan #2
> > > > >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> > > > >  Call Trace:
> > > > >   dump_stack+0x7b/0xb5
> > > > >   kasan_report+0x10c/0x390
> > > > >   __asan_load8+0x54/0x90
> > > > >   xfs_alloc_get_freelist+0x115/0x350
> > > > >   xfs_alloc_fix_freelist+0x35b/0x830
> > > > >   xfs_alloc_vextent+0x215/0x990
> > > > >   xfs_bmap_extents_to_btree+0x30d/0x940
> > > > > .....
> > > > > 
> > > > > By returning an error here, we avoid such crashes when punching out
> > > > > a delalloc page because we don't try to fix up an AG freelist
> > > > > without a transaction. Hence we get an error like so:
> > > > 
> > > > Um, isn't erroring out here leaving a dirty bomb in the in-core metadata?
> > > 
> > > Not that I can tell. We've already trashed the dirty page state by
> > > this point, so the page cache can safely reclaim the page and the
> > > delalloc range over it will never get written.  And the XFS inode
> > > cleanup code didn't have any issues with the way the error was
> > > handled, either, because the delalloc range was actually removed
> > > before the fork format error was triggered.
> > > 
> > > IOWs, there is no dirty, stale page state or delalloc extents
> > > hanging around if this error fires.
> > 
> > Hmmm, well I guess I'll pull this one in and look for problems.
> > 
> > I wonder, is there a <cough> testcase for this?  Or a fuzz-o-matic to
> > turn all these things into regression tests?
> 
> No test case. Should be able to create one easily enough with
> xfs_db, though I haven't tried. Do the inode fuzzer tests screw with
> the extent count?

The existing set of fuzz tests won't catch this because they go straight
into repair attempts to see if scrub/repair will deal with bad nextents.
They don't try to modify the corrupted fs.

They also do it slowly because fuzzing nextents is simply a part of
fuzzing every field in a extents-format file inode, and I suspect that
we don't really want to make fuzz testing a regular part of xfstests
because that immediately triples the auto group runtime. :)

So, targeted test please? :)

I will also work on a fuzz series that skips scrub/repair and goes
straight to writing to the corrupted fs to see what happens.

> > > But OTOH, I don't want to risk a bunch of filesystem corrupting
> > > regressions across the entire XFS userbase just to fix a trivially
> > > simple crash that requires an extremely unlikely co-ordinated
> > > corruption of an inode data fork and an AGFL, and to simultaneously
> > > have ENOSPC in every other AGF in the filesystem.
> > > 
> > > Put "refactor xfs_bunmapi()" on the list of "things to do when
> > > there's nothing else to do"...
> > 
> > So in 2066 after the polar ice caps melt after the XFS LOGHAMMER attack
> > has finally been put down?  Ok. :)
> 
> I'm sure someone will have reason to factor it before then :P

I ... forgot that hch already did. :/

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
