Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9HKJMiO100536 for <xfs@oss.sgi.com>; Wed, 17 Oct 2012 15:19:24 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uVY3bwqTHtBL0YGw for <xfs@oss.sgi.com>;
	Wed, 17 Oct 2012 13:21:00 -0700 (PDT)
Message-ID: <507F132B.30000@sandeen.net>
Date: Wed, 17 Oct 2012 15:20:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: master branch fast-forwarded to v3.7-rc1, and corp-speak mumble
References: <20121016155640.GA1377@sgi.com>
In-Reply-To: <20121016155640.GA1377@sgi.com>
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

On 10/16/12 10:56 AM, Ben Myers wrote:
> Hi XFS Folks,
> 
> Linux v3.7-rc1 is out.  The XFS master branch
> (git://oss.sgi.com/xfs/xfs.git) has been fast-forwarded to v3.7-rc1.
> 
> We'd like to take a moment and let you all know that we at SGI are going
> to make an effort to communicate more from our end.  Your contribution
> is appreciated whether it be features, testing, reviews, docs,
> refactoring, cheerleading, or otherwise.  We want you here, and we want
> your help!  We'll continue to try to be as responsive as possible.
> 
> Please bear in mind that the master branch is a shared resource.  We XFS
> developers need a stable and bug free environment to work in and test
> our changes.  We simply cannot pull in work with known regressions
> because that can stop _all_ development until the problems are resolved.
> 
> Much more importantly, our end users have every reason to expect release
> quality software when they choose to run tagged releases from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git.
> People entrust XFS with their data, so the stakes are high.  Developers
> and testers who run upstream kernels between releases also have every
> reason to expect quality.  XFS must not bottleneck their development
> efforts through regression.  We must all be committed to a consistently
> high level of quality, and this comes before our own convenience as
> developers.
> 
> When submitting work to the xfs@oss.sgi.com mailing list, please
> remember to follow the rules described in your kernel sources under
> Documentation/SubmittingPatches, and those in the intro of the
> MAINTAINERS file.  In the MAINTAINERS file there is specific emphasis in
> #1 on testing patches.  Please take this to heart.  SGI is committed to
> testing patches before pulling them in.  And as developers, we each need
> to thoroughly test our patches before posting.  Also, please don't get
> discouraged if colleagues find bugs in your code by inspection or
> through testing.  It happens sometimes.  We shouldn't rake each other
> over the coals for it.

It sounds like SGI perceives a problem in the development cycle, based
on all the nice, vague words about testing and collaboration and quality.

Can we lose the management-speak and state clearly what's perceived as
the problem to be solved here?  I'm reading between the lines as best
I can.

Dave had concerns that a regression, which, although quickly fixed, was
cited as the reason for missing a merge window.

This concerns me too, because it's not just SGI's timetables that matter
here; others are also depending on this work getting upstream within certain
deadlines as well.

Reading back through the list, I'm alarmed that SGI wants some unspecified
"soak time," but not upstream, for new work.  There's no better place than
an -rc1 to get soak & exposure for tested patches.  Bugs get found and fixed.
I don't think the XFS developer community needs a lecture on patch submission
processes and quality expectations.

If maintainers get too conservative all it's going to do is slow development,
and slow the discovery & fixes for bugs which will inevitably occur in the
course of active development.

The master branch is a shared *development* resource.  If SGI is treating it
as something which must never be broken under any circumstances, then I humbly
submit that you're doing it wrong.  It may date me, but I'll point out that
it's meant to be a bazaar, not a cathedral, and that release early, release
often is not a new idea.

If you need something solid and slow-moving, that's what forks and branches
and -stable trees are for.


-Eric


> Again, thanks to each of you for your participation.  Please continue to
> treat each other with respect in your reviews and try to remember that
> everyone is doing their best with a complicated project.  Lets try to
> keep a friendly and collegial atmosphere on the mailing list.  We should
> all be able to have some fun while working on XFS!
> 
> Happy hacking!
> 
> -The XFS Team @ SGI
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
