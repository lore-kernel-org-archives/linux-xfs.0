Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04Ka7vo167204 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 14:36:07 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zUzA9z0hIy4k9UJG for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 12:36:05 -0800 (PST)
Date: Thu, 5 Jan 2012 07:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] [ATTEND] xfstests: what do we need to do to make
	it better?
Message-ID: <20120104203556.GD17026@dastard>
References: <20120103234455.GU23662@dastard> <1325697491.3346.18.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1325697491.3346.18.camel@doink>
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
To: Alex Elder <elder@dreamhost.com>
Cc: linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, xfs@oss.sgi.com

On Wed, Jan 04, 2012 at 11:18:11AM -0600, Alex Elder wrote:
> On Wed, 2012-01-04 at 10:44 +1100, Dave Chinner wrote:
> > Given that more people are using xfstests and developing tests, we
> > need to consider how to make it friendlier to hack on. The current
> > structure of the tree is difficult to work with, the way tests are
> > organised and numbered make it difficult to co-ordinate new tests
> > and results in patch conflicts, etc.
> 
> Coordination of numbers is not a big deal, the test names/numbers
> can be easily fixed up at commit time.  I also thought that the
> numbers--though meaningless on their own--also avoided having to
> decide where a particular test belongs.

Instead, we decide that via the global group file and via
definitions within the test itself. Yes, the global group file
allows tests to exist in multiple logical test groups, but that's
something that canbe maintained even with a broken up deirectory
heirarchy.

> I.e., a test that exercises
> several categories of things (maybe preallocation, quota, and ENOSPC)
> won't be hidden in any sort of "enospc" test directory.

No, but it will be a generic of filesystem specific test, so woul
dbe located in such a subdirectory.

Basically, I'm thinking of something more fine grained like this:

	generic/group
	       /001
	       /005
	       ....
	xfs/group
	   /002
	   /003
	   ....

So that we're not treading on each other's toes as much. Maintaining
the group files still allows logical grouping of tests (like auto,
quota, etc) so I don't see any change in functionality there. Maybe
someone will have a good idea to improve the logical grouping
implementation, but right now I'm not planning on killing that
functionality at all...

> > make it easier to add new tests without conflicts with others
> > developing new tests. Some of the ideas Christoph and I have
> > previously tossed around include:
> > 
> > 	- break tests up into groups in their own subdirectories.
> > 	  e.g. generic tests, xfs/ext4/btrfs specific tests, stress
> > 	  tests, performance tests, large FS tests, etc
> > 	- change the way we define groups of tests so we don't have
> > 	  a single registry of tests and their groups
> > 	- allow different naming of tests, such as desciptive text
> > 	  names rather than just plain numbers
> > 	- allow duplicate test names in different groups
> 
> Despite what I said above, I don't disagree with any of this.
> Perhaps the tests can be buried in one or more subdirectories,
> but each FSTYP defines its own groups file to drive testing.

I think allowing duplicate tests is a bad thing - keeping the
logical grouping effectively allows us to only keep one copy of a
test no matter where it ends up.

> > I'm sure that other users of xfstests will have some ideas on how to
> > improve it for the way they run it, so I'd like to gather and
> > incorporate these ideas into any structural change we make to
> > xfstests.
> 
> Should be a good discussion.  It might be useful to have a
> proposal or two to work with as a starting point, or maybe
> an outline of the types of changes (naming, directory
> structure, etc.), to help keep things focused.

Sure, though I don't want to done so much that it's all set in stone
before I found out what other people consider pain points that need
to be fixed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
