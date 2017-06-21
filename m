Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26281 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdFUQyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 12:54:22 -0400
Date: Wed, 21 Jun 2017 09:54:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/2 V4] Resubmit items failed during writeback
Message-ID: <20170621165416.GI4733@birch.djwong.org>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170619135120.GD25516@bfoster.bfoster>
 <20170619174203.GA4733@birch.djwong.org>
 <20170619185111.GA29903@bfoster.bfoster>
 <20170621004550.GF4733@birch.djwong.org>
 <20170621101526.GC28914@bfoster.bfoster>
 <20170621110349.xhucfxyratu4qmym@eorzea.usersys.redhat.com>
 <20170621115132.GE28914@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170621115132.GE28914@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

[Heh, concurrent replies.]

On Wed, Jun 21, 2017 at 07:51:32AM -0400, Brian Foster wrote:
> On Wed, Jun 21, 2017 at 01:03:49PM +0200, Carlos Maiolino wrote:
> > Hey fellows.
> > 
> > On Wed, Jun 21, 2017 at 06:15:26AM -0400, Brian Foster wrote:
> > > On Tue, Jun 20, 2017 at 05:45:50PM -0700, Darrick J. Wong wrote:
> > > > On Mon, Jun 19, 2017 at 02:51:11PM -0400, Brian Foster wrote:
> > > > > On Mon, Jun 19, 2017 at 10:42:03AM -0700, Darrick J. Wong wrote:
> > > > > > On Mon, Jun 19, 2017 at 09:51:22AM -0400, Brian Foster wrote:
> > > > > > > On Fri, Jun 16, 2017 at 12:54:43PM +0200, Carlos Maiolino wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > there goes a new version of this patchset based on previous reviews on V3.
> > > > > > > > 
> > > > > > > > Changelogs added separated to each patch.
> > > > > > > > 
> > > > > > > 
> > > > > > > Hi Carlos,
> > > > > > > 
> > > > > > > I pointed out the last things that I'm aware of that I think need to be
> > > > > > > fixed in this series (along with a few nits here and there). That said,
> > > > > > > it's already been pointed out that we probably want an xfstests test
> > > > > > > case to go along with this before it would be merged. Is that something
> > > > > > > you are still planning on?
> > > > > > > 
> > 
> > Well, I am sure planing a xfstests for this case, I just didn't stop to work on
> > it yet, and well, I wasn't expecting to have the test done before merging this
> > patchset, is this a requirement? If so, I'll work on that before finishing this
> > series, otherwise I'll just finish the series and then move to the xfstests.
> > 
> 
> I think it's reasonable to expect to at least have an xfstests test
> posted and available for review before this is merged, but I'll defer to
> Darrick on that. I don't think you necessarily have to stop working on
> these patches to get the xfstests done (i.e., maybe start putting
> something together after the next version goes out for review?), but
> that's just my .02. ;)

Yes, it's fine to have testcases out for review, even if we haven't
finalized all the debugging knobs necessary.

> > .
> > .
> > .
> > > > > > > something like a new DEBUG sysfs attribute in the error configuration
> > > > > > > (see log_badcrc_factor for a similar example).
> > > > > > 
> > > > > > I wonder if it would be more useful to have individual knobs for each
> > > > > > metadata object type so that you could have multiple xfstests, each of
> > > > > > which runs the same software scenario but with different failures
> > > > > > 
> > > > > 
> > > > > I suppose you could do some of that in the test just by making certain
> > .
> > .
> > .
> > 
> > > > XFS_RANDOM_ values (i.e. inverted frequency).  Now we're free of the
> > > > limitation of only being able to inject 10 error types across all
> > > > mounted fses, and we can individually disable injection too.
> > > > 
> > > 
> > > Nice, that sounds very interesting.. thanks!
> > > 
> > > Brian
> > > 
> > 
> > Regarding the error injection knobs (and the bad quoting of previous replies
> > above :), I like the idea, and I can surely work on such implementation, but, I
> > honestly disagree with having the error injection patches in this same patchset.
> > This will recreate a new discussion regarding the implementation, several new
> > reviews, comments, etc and postpone this fix even more. I'd highly appreciate if
> > we could do this in a different patchset, so we can have this fix merged sooner.
> > 
> > What you guys think?
> > 
> 
> I think we all agree that generic error injection (which Darrick has
> started playing with, but I haven't looked at yet) doesn't need to be
> bundled with this series (I hope we didn't scare you there ;). What I
> was asking for is a single patch that adds error injection in one spot
> with a configurable frequency. I'll refer to commit 609adfc2ed ("xfs:
> debug mode log record crc error injection") again because it is a simple
> example of a small DEBUG only hunk of code and boilerplate code to add a
> sysfs knob.
> 
> That said, I don't even think such a patch needs to be merged. I'm happy
> with appending a quick and dirty RFC to the series so long as it works
> to facilitate testing. I was merely suggesting it could be merged
> because you could also use it to construct an xfstests test if you so
> desired. If not, we could leave it as an rfc and perhaps add something
> later on top of the bits Darrick has started to play with.
> 
> The reason I'm asking for this is because testing is an important part
> of code review[1]. We have the ability to test for unrelated regressions
> already. Presumably, we will have a new regression test for this
> specific issue based on your current reproducer recipe as well. While I
> may think the code is ultimately correct, that's not quite enough for me
> to put a reviewed-by on this set because of the complexity of the area
> of code it's touching. I'd much prefer to be able to run something that
> truly stresses out this area of code.

Agree.  I'd love to live in a world where most of my review process is
examining the overall approach to make sure that it integrates well with
the design and letting the automated tests look for bugs in the
implementation details, though obviously we're not there.

--D

> Brian
> 
> [1] In reality, I'm going to do this myself if necessary. I'm just
> asking to save myself some time (and possibly encourage similar testing
> from others). ;)
> 
> > also, let me know if I should send the xfstest before moving on with this
> > patchset.
> > 
> > 
> > Cheers
> > 
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
