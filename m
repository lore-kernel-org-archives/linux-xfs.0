Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752655AbdFULDy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 07:03:54 -0400
Date: Wed, 21 Jun 2017 13:03:49 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/2 V4] Resubmit items failed during writeback
Message-ID: <20170621110349.xhucfxyratu4qmym@eorzea.usersys.redhat.com>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170619135120.GD25516@bfoster.bfoster>
 <20170619174203.GA4733@birch.djwong.org>
 <20170619185111.GA29903@bfoster.bfoster>
 <20170621004550.GF4733@birch.djwong.org>
 <20170621101526.GC28914@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170621101526.GC28914@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Hey fellows.

On Wed, Jun 21, 2017 at 06:15:26AM -0400, Brian Foster wrote:
> On Tue, Jun 20, 2017 at 05:45:50PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 19, 2017 at 02:51:11PM -0400, Brian Foster wrote:
> > > On Mon, Jun 19, 2017 at 10:42:03AM -0700, Darrick J. Wong wrote:
> > > > On Mon, Jun 19, 2017 at 09:51:22AM -0400, Brian Foster wrote:
> > > > > On Fri, Jun 16, 2017 at 12:54:43PM +0200, Carlos Maiolino wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > there goes a new version of this patchset based on previous reviews on V3.
> > > > > > 
> > > > > > Changelogs added separated to each patch.
> > > > > > 
> > > > > 
> > > > > Hi Carlos,
> > > > > 
> > > > > I pointed out the last things that I'm aware of that I think need to be
> > > > > fixed in this series (along with a few nits here and there). That said,
> > > > > it's already been pointed out that we probably want an xfstests test
> > > > > case to go along with this before it would be merged. Is that something
> > > > > you are still planning on?
> > > > > 

Well, I am sure planing a xfstests for this case, I just didn't stop to work on
it yet, and well, I wasn't expecting to have the test done before merging this
patchset, is this a requirement? If so, I'll work on that before finishing this
series, otherwise I'll just finish the series and then move to the xfstests.

.
.
.
> > > > > something like a new DEBUG sysfs attribute in the error configuration
> > > > > (see log_badcrc_factor for a similar example).
> > > > 
> > > > I wonder if it would be more useful to have individual knobs for each
> > > > metadata object type so that you could have multiple xfstests, each of
> > > > which runs the same software scenario but with different failures
> > > > 
> > > 
> > > I suppose you could do some of that in the test just by making certain
.
.
.

> > XFS_RANDOM_ values (i.e. inverted frequency).  Now we're free of the
> > limitation of only being able to inject 10 error types across all
> > mounted fses, and we can individually disable injection too.
> > 
> 
> Nice, that sounds very interesting.. thanks!
> 
> Brian
> 

Regarding the error injection knobs (and the bad quoting of previous replies
above :), I like the idea, and I can surely work on such implementation, but, I
honestly disagree with having the error injection patches in this same patchset.
This will recreate a new discussion regarding the implementation, several new
reviews, comments, etc and postpone this fix even more. I'd highly appreciate if
we could do this in a different patchset, so we can have this fix merged sooner.

What you guys think?

also, let me know if I should send the xfstest before moving on with this
patchset.


Cheers

-- 
Carlos
