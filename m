Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04HIFlf160109 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 11:18:16 -0600
Received: from mail.hq.newdream.net (mail.hq.newdream.net [66.33.206.127]) by
	cuda.sgi.com with ESMTP id 7nRyhQ2tC3imKTal for
	<xfs@oss.sgi.com>; Wed, 04 Jan 2012 09:18:14 -0800 (PST)
Message-ID: <1325697491.3346.18.camel@doink>
Subject: Re: [LSF/MM TOPIC] [ATTEND] xfstests: what do we need to do to make
	it better?
From: Alex Elder <elder@dreamhost.com>
Date: Wed, 04 Jan 2012 11:18:11 -0600
In-Reply-To: <20120103234455.GU23662@dastard>
References: <20120103234455.GU23662@dastard>
Mime-Version: 1.0
Reply-To: elder@dreamhost.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, xfs@oss.sgi.com

On Wed, 2012-01-04 at 10:44 +1100, Dave Chinner wrote:
> Given that more people are using xfstests and developing tests, we
> need to consider how to make it friendlier to hack on. The current
> structure of the tree is difficult to work with, the way tests are
> organised and numbered make it difficult to co-ordinate new tests
> and results in patch conflicts, etc.

Coordination of numbers is not a big deal, the test names/numbers
can be easily fixed up at commit time.  I also thought that the
numbers--though meaningless on their own--also avoided having to
decide where a particular test belongs.  I.e., a test that exercises
several categories of things (maybe preallocation, quota, and ENOSPC)
won't be hidden in any sort of "enospc" test directory.

I do think the growing number of tests is making it a bit unwieldy
though, so I think some sort of reorganization is a good plan.

> We also see problems arising from people not really understanding how
> the xfstests harness is designed and how it really is supposed to
> work, so an overview of the underlying principles of operation would
> probably be helpful to a lot of people. It will also save
> review and rework time if we can avoid having people make the same
> mistakes the first time they submit tests....

This is very important.  And the gist of it ought to be
captured somewhere if it is not already.

> I'd also like to discuss some potential infrastructure changes to
> make it easier to add new tests without conflicts with others
> developing new tests. Some of the ideas Christoph and I have
> previously tossed around include:
> 
> 	- break tests up into groups in their own subdirectories.
> 	  e.g. generic tests, xfs/ext4/btrfs specific tests, stress
> 	  tests, performance tests, large FS tests, etc
> 	- change the way we define groups of tests so we don't have
> 	  a single registry of tests and their groups
> 	- allow different naming of tests, such as desciptive text
> 	  names rather than just plain numbers
> 	- allow duplicate test names in different groups

Despite what I said above, I don't disagree with any of this.
Perhaps the tests can be buried in one or more subdirectories,
but each FSTYP defines its own groups file to drive testing.

> I'm sure that other users of xfstests will have some ideas on how to
> improve it for the way they run it, so I'd like to gather and
> incorporate these ideas into any structural change we make to
> xfstests.

Should be a good discussion.  It might be useful to have a
proposal or two to work with as a starting point, or maybe
an outline of the types of changes (naming, directory
structure, etc.), to help keep things focused.

					-Alex

> Cheers,
> 
> Dave.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
