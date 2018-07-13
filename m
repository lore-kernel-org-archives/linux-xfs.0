Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33182 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbeGMQ7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 12:59:50 -0400
Date: Fri, 13 Jul 2018 09:44:20 -0700
From: "Luis R. Chamberlain" <mcgrof@kernel.org>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Message-ID: <20180713164420.GA3620@garbanzo.do-not-panic.com>
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Jeff Mahoney <jeffm@suse.com>
Cc: "Luis R. Chamberlain" <mcgrof@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>

On Fri, Jul 13, 2018 at 11:39:55AM +0300, Amir Goldstein wrote:
> On Fri, Jul 13, 2018 at 5:43 AM, Luis R. Chamberlain <mcgrof@kernel.org> wrote:
> > I had volunteered at the last LSF/MM to help with the stable work for
> > XFS. To help with this, as part of this year's SUSE Hackweek, I've
> > first generalized my own set of scripts to help track a baseline of
> > results from fstests [0], and extended it to be able to easily ramp up
> > with fstests on different distributions, and I've also created a
> > respective baseline of results against these distributions as a
> > further example of how these scripts and wrapper framework can be used
> 
> Hi Luis!
> 
> Thanks a lot for doing this work!
> 
> Will take me some time to try it out, but see some questions below...
> 
> > [1]. The distributions currently supported are:
> >
> >   * Debian testing
> >   * OpenSUSE Leap 15.0
> >   * Fedora 28
> >
> > The stable work starts with creating a baseline for v4.17.3. The
> > results are visible as a result of expunge files which categorize the
> > failures for the different sections tested.
> 
> So the only "bad" indication is a test failure?

That is correct to a certain degree, ie, if xfsprogs / the kernel
config could run it we can assume it passed.

> How about indication about a test that started to pass since baseline?

Indeed, that is desirable.

We have a few options. One is share the entire results directory for
a release / section, however this is rather big. For instance for a
full v4.17.3 run this is about 292 MiB alone. I don't think this
scales. IMHO lgogs should only be supplied onto bug reports, not this
framework.

The other option is to use -R xunit to generate the report in the
specified unit. I have not yet run this, or tried it, however IIRC
it does record success runs? Does it also keep logs? Hopefully not.  I'm
assuming it does not as of yet. I should note if one hits CTRL-C in the
middle one does not get the results. An alternative was being worked on
by Jeff which would sprinkle IIRC .ok files for tests which succeed,
then you could just scrape the results directory to determine which
tests did pass -- but you run into the same size problem as above.

Since we are establishing a full baseline, and using expunge files
to skip failures, we *should* be able to complete a full run now
though, and be able to capture the results into this xunit format.
I'll try that out and see how big the file is.

I think having that *and* the expunge list would work well.

We'd have to then process that file to scrape out which tests were
passed, if a user wanted that. Do we have scripts for processing
xunit files?

Having the expunge files separately helps as we can annotate bug URLs to
them optionally. Ie, we should be able to process both expunge lists
and xunit file to construct a nice db schema to process results
in a more easily viewable manner in the future.

So to establish a baseline, one first manually contstructs the expunge
files needed to run a full test. In the future hopefully we can have
a set of scripts to do all this for us.

Once the baseline is in place, a full run with all sections is done,
to generate the -R xunit file. This annotates again failures but also
success.

Thoughts?

> Tested that started to notrun since baseline?

Its unclear if xunit captures this. Otherwise we have some work to do.

> Are we interested in those?

Sure, if we can capture this. Does xunit gather this?

I'd much prefer we tune our kernel to be able to run most tests,
likewise also ensure the dependenciecs for fstests are met, through
the oscheck helpers.sh which handles --install-deps properly.

A side question is -- do we want to keep track of results separately
per filesystem tools version used? Right now fstests does not annotate
this on the results directory, but perhaps it should.

At least for XFS, the configuration file stuff should enable in
the future deployment of the latest xfsprogs on older releases.
Before this, it was rather hard to do this due to the differing
defaults, so another option may be to just only rely on assuming
one is using the latest userspace tool.

Right now I'm using the latest tool on each respective latest distro.
The stable tests are using Debian testing, so whatever xfsprogs
is in debian testing, right now that is 4.15.1-1.

> > Other than careful manual
> > inspection of each stable candidate patch, one of the goals will also
> > be to ensure such stable patches do not regress the baseline. Work is
> > currently underway to review the first set of stable candidate patches
> > for v4.17.3, if they both pass review and do not regress the
> > established baseline, I'll proceed to post the patches for further
> > evaluation from the community.
> >
> > Note that while I used this for XFS, it should be easy to add support
> > for other filesystems, should folks wish to do something similar for
> > their filesystems. The current XFS sections being tested are as
> > follows, please let me know if we should consider extending this
> > further:
> >
> > # Matches what we expect to be default on the latests xfsprogs
> > [xfs]
> > MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0'
> > USE_EXTERNAL=no
> > FSTYP=xfs
> 
> Please add a LOGWRITES_DEV to all "internal log" configs.
> This is needed to utilize the (relatively) new crash consistency tests
> (a.k.a. generic/replay) which caught a few nasty bugs.

Will do!

> Fun fact: the fix for stable 4.4 almost got missed, because your system
> was not around ;-)
> https://marc.info/?l=linux-xfs&m=152852844615666&w=2
> 
> I've used a 10GB LOGWRITES_DEV, which seems to be enough
> for the current tests.

Will use that, thanks. Better yet, any chance you can send me a patch?

> I don't think that the dmlogwrite tests play well with external logdev,

I don't think its the only test which requires review for external logs.
There are quite a bit of failures when using xfs_logdev and
xfs_realtimedev and I'm suspecting this has to do with the output
differing, and the output for the tests not considering an external
log was used.

The top of expunges/debian/testing/xfs/unassigned/xfs_logdev.txt has:

# Based on a quick glance on the errors, one possibility is that                
# perhaps generic tests do not have the semantics necessary to                  
# determine if an external log is used in a generic form and adjust             
# the test for this. But that does not seem to be the case for all              
# tests. A common error for at least two tests seems to be size                 
# related, and that may be a limitation on the log size, and the                
# inability to generically detect the filesyste log size max allowed            
# to then invalidate the test. But note that we even have XFS specific          
# tests which fail, so if its a matter of semantics this is all just            
# crap and are missing a lot of work for improvement. 

> so we could probably reuse the same device for LOGWRITES_DEV
> for configs that don't use SCRATCH_LOGDEV.

True, the recommended setup on oscheck actually is to create
12 x 20 GiB disks, gendisks.sh does this for you on loopback
devices. In practice you end up only needing about 60 GiB
as it stands today though for XFS, but indeed we can actually
use any of the spare disks for LOGWRITES_DEV then.

I do wonder how much more data the extra LOGWRITES_DEV will
push the upper limit per required guest, we'll see!

  Luis
