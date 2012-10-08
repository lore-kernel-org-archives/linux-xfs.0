Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q980WPuE239188 for <xfs@oss.sgi.com>; Sun, 7 Oct 2012 19:32:25 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lH5yG1PrfQZ52n2g for <xfs@oss.sgi.com>;
	Sun, 07 Oct 2012 17:33:52 -0700 (PDT)
Date: Mon, 8 Oct 2012 11:33:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch v4 00/13] xfs: remove the xfssyncd mess
Message-ID: <20121008003345.GH23644@dastard>
References: <20121005171853.985930109@sgi.com> <20121006013122.GF23644@dastard>
	<20121006173745.GP13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121006173745.GP13214@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Oct 06, 2012 at 12:37:45PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Sat, Oct 06, 2012 at 11:31:22AM +1000, Dave Chinner wrote:
> > On Fri, Oct 05, 2012 at 12:18:53PM -0500, Ben Myers wrote:
> > > Hi Dave,
> > > 
> > > Here I am reposting your xfssyncd series.  I want to make sure that
> > > we're all on the same page.  In particular, are we all happy with patch
> > > 6, 'xfs: xfs_sync_data is redundant'?
> > > 
> > > Version 4:
> > > - updated 'xfs: xfs_sync_data is redundant' with cleanups to the 
> > >   xfs_flush_inodes interface as per Christoph's request,
> > > - updated 'xfs: xfs_sync_data is redundant', folding in changes from 
> > >   http://oss.sgi.com/archives/xfs/2012-10/msg00036.html 
> > > - fixed a minor typo in xfs: 'syncd workqueue is no more', renaming the 
> > >   log worker from 'xfs-reclaim' to 'xfs-log'.
> > > 
> > > I was going to rush this in for the 3.7 merge window.  However in the
> > > light of the issues with patch 6 and Linus's comment here:
> > > http://lkml.org/lkml/2012/9/30/152 and Stephen's comment here:
> > > https://lkml.org/lkml/2012/9/23/144, I think it wiser to behave.  3.7
> > > is stable without this series, so I will merge it for 3.8.
> > > 
> > > Once we have an agreement that patch 6 is ready I will pull this in to the
> > > master branch first thing after the 3.7-rc1 merge from upstream.
> > 
> > <sigh>
> > 
> > Seriously?
> 
> Take it as good news. 

Not really.

> Brian found the regression and put the brakes on before
> I pulled it in.

Right, and I posted an initial fix for it 4 hours after Brian
reported it. That was 10am Tuesday, my time. Brian reported the
warning overnight, and the version of the patch that fixed that I
posted at 6:50am Wednesday morning. You asked about folding it at 10am
Thursday morning, and that's the last I heard until Saturday morning
after you reposted the entire series....

Indeed, the reason you wanted to fold it was this:

"I'd prefer to apply this to patch 6 itself rather than check in the
regression followed by the fix."

Which really isn't something that should be a concern. regressions
get checked in all the time, and fixes for them get checked in later
all the time. Indeed, I think that having commits that explain
regressions and how they were found and fixed is far more important
to have in the revision history than to try to avoid them
altogether. People learn more from mistakes and documenting (so that
others can learn from them, too) than trying pretending they never
occurred.

> My regret in this is that SGI didn't find it first.  We have a
> very stable 3.7 release, one less regression, and a full release cycle to test
> this series in the master branch.  That is a pretty good outcome for XFS users.

Actually, it's not.

It now will be 5-6 months before the change gets to release and
users will actually start testing it, rather than using the 2
months after the -rc1 merge to send small fixes to Linus to fix
minor regressions. In 6 months time, I expect that the code base is
going to be fully CRC enabled, and finding and fixing problems with
stuff we committed now is going to be the least of our problem.

Upstream is supposed to be agile, fast and respond quickly to
changes and challenges. If you want something that is "very stable",
then that's what the long-term stable releases (like 3.0.x) and
downstream kernel consumers like enterprise distros are for. Indeed,
in software terms "very stable" is the equivalent of "did not
change", and that is a fitting description of the 3.7 merge:

Release			diffstat
v3.6..xfs-oss/master	7 files changed, 447 insertions(+), 80 deletions(-)
v3.5..v3.6		51 files changed, 2607 insertions(+), 2455 deletions(-)
v3.4..v3.5		81 files changed, 2633 insertions(+), 3004 deletions(-)
v3.3..v3.4		61 files changed, 1692 insertions(+), 2356 deletions(-)
v3.2..v3.3		45 files changed, 954 insertions(+), 2182 deletions(-)
v3.1..v3.2		54 files changed, 2414 insertions(+), 2625 deletions(-)
v3.0..v3.1		111 files changed, 3237 insertions(+), 5169 deletions(-)

An order of magnitude lower changes than the average over the past 6
releases. IOWs, "did not change" is a good description for this release.

> > Why am I only finding out that there needs to be more
> > rework to patches in this series after someone else reposted them?
> 
> You aren't.  There are currently two pending suggestions for the series, and
> apparently one has been around for awhile:
> 
> 1) 'xfs: sync work is now only periodic log work'
> HCH: "I still think queueing the work item here if we return a failure is
> the wrong thing to do."

Sure, but it also has:

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

on it. Which meant when I last went through the series, I saw this
tag and didn't look any further. I figured that I'd already
addressed the review comments. That's my mistake, but one you, as a
maintainer, need to point out and ask me to address.

> 2) 'xfs: xfs_sync_data is redundant.'
> HCH: (on xfs_flush_inodes) "It's more than a trivial wrapper now, so I'd
> suggest to move out of line to e.g.  xfs_super.c"
> 
> This one is my fault.  I might have considered moving xfs_flush_inodes out of
> xfs_mount.h when I folded your other patch in.

And this is precisely what I'm concerned about. The moment there's a
"do I need to?" type of concern about folding two patches, then it
should be punted straight back to the patch series owner with a
relevant direction/question.

>From my perspective, I'd addressed the regression and everything was
good to go, but in this case silence for 3 days obviously doesn't
mean that.


> I hope you don't mind fixing that up.

Of course I'll fix it. There's never been a question about that. My
problem is that being told I need to fix it came too late....

> > And that this is the cause of it missing the merge window?
> 
> The regression is the only reason this missed the merge window.  I was ready to
> push the series to -next when Brian pulled the cord.

There's 2-3 months after the merge window to fix minor regressions
like this. More below on this.

> According Linus and Stephens comments we should have content in -next by -rc7.
> Clearly there is some flex in that system but I have no desire to find its
> limit, and I think that this experience proves their point.  Lesson learned!  I
> will be more conservative regarding the merge window in the future.

But that's not the issue I raised - the missing of the release
window is a result of a more fundamental problem - the high
communication latency that prolongs the review process.

And I think being *more conservative* is exactly the wrong way to
fix the problem.

> I'm giving this series some soak time with the new fix.  I can't pull it in
> with the new fix for the regression until we have some testing.  Once we have
> some confidence in it I will push it up to oss.  

You are treating a development tree like it is a precious child that
must be protected from the evil developers that might do something
nasty to it. The development tree is there to benefit the
developers, not the users. We can break the dev tree however we like
as long as it is fixed before the code gets to users (i.e. final
kernel release).  There is nothing wrong with having the master
branch of the xfs development tree having regressions in it.  IOWs,
keeping changes out of the dev tree because "they need soak time" is
exactly the wrong thing to do. Changes should be "soaking" *in the
dev tree*, not in some private black hole that nobody but people at
SGI know about. 

Indeed, the faster the changes get into the dev tree, the more
widespread the testing of the changes is going to be. All my
development use the dev tree as it's base, so unless I merge every
patchset in the list into my current dev tree, I'm not testing
those changes during development. I think the same goes for most
other developers as well. The dev-tree is the tree we use and expect
to find regressions in - that's exactly what a dev tree is for.

Further, holding the changes out of tree can be actively harmful for
co-ordination of work between developers. e.g Brian's prealloc
reclaim work is dependent on this patch set, and while it is held
out of the tree for "soak" he has to privately manage the patches in
his tree, and whenever he posts updates to his work has to reference
the version of the patch set he has based his work on. If it was in
the dev tree, he wouldn't have had to do this.

Hence, IMO, taking a "we can't commit a change until it has passed
some [unknown test] criteria" approach to managing the dev tree is,
at best, misguided and at worst is completely wrong. The dev tree
should move as fast as possible, and regressions be fixed with
commits just as quickly.

This doesn't change how quickly changes get published from the
dev-tree to for-next or for-linus branches - that will still happen
after soak testing occurs.

e.g. A typical release cycle might look like:

Merge window opens:
	- move for-next -> for_linus, pull request
	- move -dev -> for-next

At -rc4 (or earlier and repeatedly if for->next needs fixing):
	- move -dev -> for-next
	- freeze for-next
	- start soak tests for next release
	- merge regressions fixes from for-next -> for-linus, pull
	  request

At -rc6/7 (final -rc):
	- merge regression fixes from -dev -> for-next
	- run final release tests, ready for merge window.

I don't know what your current plan is. It seems, from the outside,
to be completely ad hoc and driven by the realisation that the merge
window is approaching rather than being planned and consistent.
Combine this will long communication latencies, and we have a recipe
for work that was posted a couple of weeks before the merge window
opened missing it because a minor regression wasn't sorted out fast
enough.

If you were committing code the moment it had a reviewed-by tag on
each patch in the series, then committing small patches to fix
regressions and other late review changes, then problems with
latency in commication are minimised. A regression fix with a
"tested-by" tag on it can be committed immediately to the dev tree,
and we move on.  We find the problems faster, we fix them
faster, and we don't miss merge windows going around in circles
trying to work out who is or isn't doing something.

> My understanding is that work for 3.8 should not be added to -next during the
> merge window for 3.7-rc1, so you have plenty of time to address
> Mark&Christoph's concern.

Case in point: you are comingling the release rules for the for-next
branch with the commit rules for the development branch (master). We
control the master branch completely, and it can move independently
of the for-next branch. IOWs, There is no reason why you can't
commit stuff to the master branch during a merge window because that
branch is *completely independent* of the for-next/for-linus
branches and release cycles.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
