Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41724 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755376AbeFSGG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 02:06:57 -0400
Date: Mon, 18 Jun 2018 23:06:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: transactionless xfs_bunmapi shouldn't do format
 conversion
Message-ID: <20180619060652.GW8128@magnolia>
References: <20180619024128.22669-1-david@fromorbit.com>
 <20180619024128.22669-2-david@fromorbit.com>
 <20180619045405.GI8128@magnolia>
 <20180619052759.GH19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619052759.GH19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 03:27:59PM +1000, Dave Chinner wrote:
> On Mon, Jun 18, 2018 at 09:54:05PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 19, 2018 at 12:41:27PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > If we are punching out a delalloc extent, xfs_bunmapi() does not
> > > have a transaction context and should not ever need to convert the
> > > on-disk extent format. If such a thing is attempted (e.g. via a
> > > corrupt inode extent count in extent format) then we should abort
> > > with an EFSCORRUPTED error. Unfortunately, we don't do that and
> > > crash instead:
> > > 
> > >  XFS (loop0): page discard on page 0000000005fd24f3, inode 0x75e5, offset 0.
> > >  ==================================================================
> > >  BUG: KASAN: null-ptr-deref in xfs_alloc_get_freelist+0x115/0x350
> > >  Read of size 8 at addr 0000000000000028 by task a.out/1406
> > >  CPU: 0 PID: 1406 Comm: a.out Not tainted 4.17.0-rc4-kasan #2
> > >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> > >  Call Trace:
> > >   dump_stack+0x7b/0xb5
> > >   kasan_report+0x10c/0x390
> > >   __asan_load8+0x54/0x90
> > >   xfs_alloc_get_freelist+0x115/0x350
> > >   xfs_alloc_fix_freelist+0x35b/0x830
> > >   xfs_alloc_vextent+0x215/0x990
> > >   xfs_bmap_extents_to_btree+0x30d/0x940
> > > .....
> > > 
> > > By returning an error here, we avoid such crashes when punching out
> > > a delalloc page because we don't try to fix up an AG freelist
> > > without a transaction. Hence we get an error like so:
> > 
> > Um, isn't erroring out here leaving a dirty bomb in the in-core metadata?
> 
> Not that I can tell. We've already trashed the dirty page state by
> this point, so the page cache can safely reclaim the page and the
> delalloc range over it will never get written.  And the XFS inode
> cleanup code didn't have any issues with the way the error was
> handled, either, because the delalloc range was actually removed
> before the fork format error was triggered.
> 
> IOWs, there is no dirty, stale page state or delalloc extents
> hanging around if this error fires.

Hmmm, well I guess I'll pull this one in and look for problems.

I wonder, is there a <cough> testcase for this?  Or a fuzz-o-matic to
turn all these things into regression tests?

(Yeah, I know there won't be one for syzbot, I dug through its code and
had to reset my brain by reading mballoc.c. :P)

> > Like you say:
> > 
> > > XFS (loop0): page discard on page ffffea00040ae640, inode 0x75e5, offset 0.
> > > XFS (loop0): page discard unable to remove delalloc mapping.
> > 
> > We know the fs is corrupt, we might as well shut down now rather than
> > let this burp out later.
> 
> xfs_bunmapi() doesn't do shutdowns - the higher level code does a
> shutdown on error if it is necessary, otherwise it just propagates
> the error. In this case it has cleaned up correctly, propagates the
> error and it gets back to userspace on the next fsync, and we're
> fine to continue onwards as there was no unrecoverable error....

Fair enough.

> > I get that people don't want to touch well seasoned code, but
> > xfs_bunmapi is this big unwieldly function that's crying out for a
> > refactor.  It's 330 lines long and can be called from various contexts
> > (data/attr fork, punch delalloc, etc.)...
> >
> > ...it's also weird that xfs_bmap_punch_delalloc_range calls xfs_bunmapi
> > with no transaction and a xfs_defer that we dump on the ground.
> 
> Yes, and yes.
> 
> > So yes, I think the patch does fix the crash, but it's kinda gross.
> 
> Yes, it is.
> 
> But OTOH, I don't want to risk a bunch of filesystem corrupting
> regressions across the entire XFS userbase just to fix a trivially
> simple crash that requires an extremely unlikely co-ordinated
> corruption of an inode data fork and an AGFL, and to simultaneously
> have ENOSPC in every other AGF in the filesystem.
> 
> Put "refactor xfs_bunmapi()" on the list of "things to do when
> there's nothing else to do"...

So in 2066 after the polar ice caps melt after the XFS LOGHAMMER attack
has finally been put down?  Ok. :)

(But no, seriously, if anyone's looking for a little refactoring +
domain knowledge enhancement of the bmapi code...)

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
