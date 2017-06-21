Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48263 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752592AbdFUAp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 20:45:56 -0400
Date: Tue, 20 Jun 2017 17:45:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/2 V4] Resubmit items failed during writeback
Message-ID: <20170621004550.GF4733@birch.djwong.org>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170619135120.GD25516@bfoster.bfoster>
 <20170619174203.GA4733@birch.djwong.org>
 <20170619185111.GA29903@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170619185111.GA29903@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jun 19, 2017 at 02:51:11PM -0400, Brian Foster wrote:
> On Mon, Jun 19, 2017 at 10:42:03AM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 19, 2017 at 09:51:22AM -0400, Brian Foster wrote:
> > > On Fri, Jun 16, 2017 at 12:54:43PM +0200, Carlos Maiolino wrote:
> > > > Hi,
> > > > 
> > > > there goes a new version of this patchset based on previous reviews on V3.
> > > > 
> > > > Changelogs added separated to each patch.
> > > > 
> > > 
> > > Hi Carlos,
> > > 
> > > I pointed out the last things that I'm aware of that I think need to be
> > > fixed in this series (along with a few nits here and there). That said,
> > > it's already been pointed out that we probably want an xfstests test
> > > case to go along with this before it would be merged. Is that something
> > > you are still planning on?
> > > 
> > > I'd actually like to take this a bit farther than a regression test and
> > > see if we can improve our ability to test the error handling code in
> > > general. What do you (or anybody else..) think about including a patch
> > > in this series that introduces the ability to inject metadata writeback
> > > errors on DEBUG kernels? For example, consider something that just sets
> > > b_error at the top of xfs_buf_iodone_callbacks() based on a random value
> > > and configurable error frequency. This could use XFS_TEST_ERROR() or
> > > something like a new DEBUG sysfs attribute in the error configuration
> > > (see log_badcrc_factor for a similar example).
> > 
> > Sounds reasonable.
> > 
> > I wonder if it would be more useful to have individual knobs for each
> > metadata object type so that you could have multiple xfstests, each of
> > which runs the same software scenario but with different failures
> > configured?  Then we could test what happens when, say, only inode
> > writes fail, or bmbt writes fail, etc. rather than one big hammer that's
> > harder to control?
> > 
> 
> I suppose you could do some of that in the test just by making certain
> modifications in isolation (e.g., test an inode modification, test a
> dquot, buffer, etc..). It might be harder to do that from a test script
> at the granularity of things like bmbt buffers, though that may also be
> the case for error injection. Did you have something in mind to filter
> the buffer types.. the blf type perhaps?
> 
> > For a moment I also wondered why not use the error injection mechanism
> > that we already have, rather than inventing more sysfs knobs?  But we
> > have limited space in xfs_error_injection (29/32 bits used) so we
> > probably should just switch everything to sysfs knobs.
> > 
> 
> Yeah, I think we discussed this before as well. IIRC, I had already
> implemented whatever the sysfs knob was and and corresponding test, and
> it just wasn't really important enough to reimplement the whole thing.

We probably did, back when the other error injection knobs (drop_writes,
log/log_badcrc_factor) got added.  Unfortunately now they're all over
sysfs, which makes for sort of a mess.

> I didn't really have a preference as to how this would be implemented.
> On a quick look though, it looks like a downside to the existing
> injection mechanism is that we can't control the error frequency..? If
> that's the case, I like the idea of stepping back, perhaps audit the
> granularity of the broader error injection framework and define a new
> sysfs interface that also allows controlling things like the error
> frequency dynamically.

Yes, I've heard you ask for this twice now.  I agree that being able to
control the frequency would be a useful feature to enable longer-running
tests so that you could, say, have the refcount_finish_one error trigger
once every 1,000,000 updates instead of immediately afterwards.

So with that in mind I coded up a quick RFC to create sysfs knobs in
/sys/fs/xfs/$device/errortag/$tagname ; the units are the same as the
XFS_RANDOM_ values (i.e. inverted frequency).  Now we're free of the
limitation of only being able to inject 10 error types across all
mounted fses, and we can individually disable injection too.

> (I would still like to get something targeted towards testing this
> series in the meantime.)

Same here.

--D

> Brian
> 
> > --D
> > 
> > > This would facilitate longer running tests where iodone callback errors
> > > occur randomly and transiently and we can thus actually exercise the
> > > error handling and recovery code. I'd love to run some fsstress testing,
> > > for example, as I'm hoping that would help wring out any further issues
> > > that could be lurking (particularly with the tricky xfs_iflush_done()
> > > logic and whatnot). If implemented generally enough, that could also be
> > > reused for a more simple xfstests regression test for the original
> > > problem (e.g., mount fs, set error frequency = 100%, modify an inode,
> > > set error frequency = 0, umount), albeit it would require debug mode.
> > > Thoughts?
> > > 
> > > Brian
> > > 
> > > > 
> > > > -- 
> > > > 2.9.4
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
