Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752901AbdGCIhJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Jul 2017 04:37:09 -0400
Date: Mon, 3 Jul 2017 10:37:03 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/2 V4] Resubmit items failed during writeback
Message-ID: <20170703083703.xd37nqumrj7uiszh@eorzea.usersys.redhat.com>
References: <20170621101526.GC28914@bfoster.bfoster>
 <20170621110349.xhucfxyratu4qmym@eorzea.usersys.redhat.com>
 <20170621115132.GE28914@bfoster.bfoster>
 <20170621165416.GI4733@birch.djwong.org>
 <20170622120528.ala3ofmjvrdxx7ye@eorzea.usersys.redhat.com>
 <20170622124047.GA34265@bfoster.bfoster>
 <20170630110913.g43b6ro5tvf3wqho@eorzea.usersys.redhat.com>
 <20170630113342.GA13410@bfoster.bfoster>
 <20170630122247.77yiuystpd3jke3k@eorzea.usersys.redhat.com>
 <20170630170132.GN5874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630170132.GN5874@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Jun 30, 2017 at 10:01:32AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 30, 2017 at 02:22:47PM +0200, Carlos Maiolino wrote:
> > On Fri, Jun 30, 2017 at 07:33:42AM -0400, Brian Foster wrote:
> > > On Fri, Jun 30, 2017 at 01:09:13PM +0200, Carlos Maiolino wrote:
> > > > Hey,
> > > > 
> > > > > Taking a quick look at something I have laying around that you sent
> > > > > previously (I assume the test hasn't changed much), I see we basically
> > > > > create an overprovisioned dm-thin vol, mount it and dio write to it
> > > > > until we start to see async write failures. So is the purpose of the
> > > > > wait that we need the AIL to push and ultimately fail the associated
> > > > > buffers before we attempt an unmount? If so, I'm wondering if you could
> > > > > xfs_freeze the fs rather than wait (it looks like freeze sync pushes the
> > > > > AIL)..?
> > > > > 
> > > > 
> > > > As we discussed off-list, yes, I'd done some testing, and I believe we can use
> > > > freezing to test it.
> > > > 
> > > > > > > > 
> > > > > > > > I think we all agree that generic error injection (which Darrick has
> > > > > > > > started playing with, but I haven't looked at yet) doesn't need to be
> > > > > > > > bundled with this series (I hope we didn't scare you there ;). What I
> > > > > > > > was asking for is a single patch that adds error injection in one spot
> > > > > > > > with a configurable frequency. I'll refer to commit 609adfc2ed ("xfs:
> > > > > > > > debug mode log record crc error injection") again because it is a simple
> > > > > > > > example of a small DEBUG only hunk of code and boilerplate code to add a
> > > > > > > > sysfs knob.
> > > > > > > > 
> > > > > > 
> > > > > > I'll keep this in mind, and try to work on something like that :)
> > > > > > 
> > > > > 
> > > > > I think error injection would make this test more straightforward
> > > > > because you can explicitly control when I/Os fail and there's no need to
> > > > > play around with dm-thin. That of course doesn't mean there isn't value
> > > > > in having a test for fs' in dm-thin out of space conditions in general.
> > > > > :)
> 
> I like the idea of having two tests -- one where we use error injection
> to stuff in an ENOSPC so that we can test how XFS reacts to ENOSPC, and
> a second one that runs a dm-thin out of space to gauge XFS' reaction to
> that condition.  The first test can be thought of as a unit test for our
> internal nospace handling, whereas the second test is an integration
> test of nospace handling between dm-thin and XFS.  Some day in the
> future dm-thin could grow a different means to signal ENOSPC to XFS,

I don't doubt :)

>in
> which case we'll still need to test what happens when raw storage sends
> us ENOSPC.  Furthermore, dm-thin might not be available on any given
> tester's machine; a dm-thin test could be generic whereas error

makes sense, I can work on both tests, I'll prioritize the dm-thin though, which
well, is the one giving me headaches at this specific time :)

cheers

> injection is an xfs-specific test; etc.
> 
> > > > 
> > > > Well, this is doable, although it has a caveat.
> > > > 
> > > > To do this, we'd need to inject the error in the buffer during IO completion,
> > > > for example in xfs_buf_ioend(). The problem though, is that we start to have IOs
> > > > before the 'mp->m_errotag' is actually initialized, so, xfs_buf_ioend() would
> > > > need to check for m_errortag initialization before calling XFS_TEST_ERROR().
> > > > 
> > > > Something like this:
> > > > 
> > > > 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> > > >  
> > > > +	if (bp->b_target->bt_mount->m_errortag) {
> > > > +		if (XFS_TEST_ERROR(false, bp->b_target->bt_mount,
> > > > +				   XFS_ERRTAG_BUF_WB)) {
> > > > +			bp->b_io_error = -ENOSPC;
> > > > +		}
> > > > +	}
> > > > 
> > > > This check could also be done in xfs_errortag_test(), although I'm not sure if
> > > > it's worth, giving that there are very few places where error injection can be
> > > > useful and m_errortag can be uninitialized.
> > > > 
> > > > 
> > > > Thoughts?
> > > > 
> > > 
> > > This strikes me as a bug in the error injection bits. Are you observing
> > > a crash due to the injection point above? We should be able to add
> > > injection points anywhere without such issues.
> > > 
> > Yup, when calling XFS_TEST_ERROR() from xfs_buf_ioend(), this will cause a NULL
> > pointer dereference right when the filesystem is mounted. I didn't really got
> > deeper into it to know from where exactly it comes from, but, I'd guess it comes
> > from the very beginning, in xfs_fs_fill_super(), reading blocks from disk, will
> > end up triggering xfs_buf_ioend().
> > 
> > > IOW, I think your suggestion to check ->m_errortag in xfs_test_error()
> > > is probably the appropriate fix. Darrick may want to chime in.. but in
> > > the meantime I'd suggest to throw up a patch to fix that. ;)
> > >
> > 
> > Sounds, reasonable, I'll write the patch and send in the next minutes.
> 
> Yes, that was a bug, thanks for the patch. :)
> 
> --D
> 
> >  
> > > BTW, you may want to consider using somewhere like
> > > xfs_buf_iodone_callbacks() as an independent injection point from
> > > xfs_buf_ioend(). It seems the latter may potentially cause other I/O
> > > errors that interfere with testing AIL writeback error processing. I
> > > could be wrong though so it doesn't hurt to try (and we could certainly
> > > add two separate injection points). Just something to think about..
> > > 
> > 
> > Thanks, I'll think about it.
> > 
> > Cheers
> > -- 
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
