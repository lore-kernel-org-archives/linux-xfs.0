Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AEC6C7F37
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 00:44:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49CEBAC002
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 22:44:15 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	C7aPgJ7Tc3Jii4PN for <xfs@oss.sgi.com>;
	Mon, 07 Dec 2015 22:44:12 -0800 (PST)
Date: Tue, 8 Dec 2015 17:44:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFSTESTS 5/6] Add richacl tests
Message-ID: <20151208064410.GD19802@dastard>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-6-git-send-email-agruenba@redhat.com>
	<20151123230847.GH26718@dastard>
	<CAHc6FU4BDRqTM6dMONtyb98YqHSVp5M=GYnJ+k7EQRVNPvrQNA@mail.gmail.com>
	<20151207211156.GD26718@dastard>
	<CAHc6FU4X+7rPtR8LE9W4HZv2UGsZ-+1zHSq5X5sFgVQmL5mCqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU4X+7rPtR8LE9W4HZv2UGsZ-+1zHSq5X5sFgVQmL5mCqQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: XFS Developers <xfs@oss.sgi.com>

On Tue, Dec 08, 2015 at 12:45:05AM +0100, Andreas Gruenbacher wrote:
> On Mon, Dec 7, 2015 at 10:11 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Dec 06, 2015 at 06:31:20PM +0100, Andreas Gruenbacher wrote:
> >> Dave,
> >>
> >> On Tue, Nov 24, 2015 at 12:08 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Wed, Nov 18, 2015 at 03:17:48PM +0100, Andreas Gruenbacher wrote:
> >> >> Add the Rich Access Control List tests from the richacl package.  The
> >> >> new tests require TEST_DEV and TEST_DIR to be set.
> >> >>
> >> >> When the check script is run, it first makes sure that the test
> >> >> filesystem has richacls enabled or disabled as appropriate: with the
> >> >> -richacl option, richacls must be enabled; without the -richacl option,
> >> >> richacls must be disabled.  If TEST_DEV has incorrect richacl support,
> >> >> the TEST_DEV filesystem is recreated.
> >> >
> >> > No, we don't recreate the testdev like this with the test harness.
> >> > The test device is intended to remain unchanged from run to run, so
> >> > give us long term aging of the test filesystem over months of
> >> > regression test running.
> >> >
> >> > If you want to test the testdev with richacls enabled, then you need
> >> > to manually create the testdev with richacls.  Any test that
> >> > specifically needs to enable richacls should use the scratch device
> >> > and use a _requires_scratch_richacls() test to check that the
> >> > scratch device can be created with richacl support.
> >>
> >> well, let's leave it to users to create their TEST_DEV with richacl
> >> support if they want the richacl tests to be run then. Those tests
> >> will already be skipped on unsuitable filesystems anyway.
> >
> > No, that's not the way xfstests works, or how developers really
> > expect it to run. If you have new functionality that requires
> > specific on-disk format requirements that are different to the
> > defaults that the developers userspace progs are using then you
> > should be using the scratch device for those tests after probing that
> 
> That should be possible. Those tests would then only be using
> SCRATCH_DEV / SCRATCH_MNT and not TEST_DEV / TEST_DIR at all. Any
> ideas how xfstests could be made to not always require TEST_DEV /
> TEST_DIR to be set?

That's not something I've ever considered - the test harness has
always assumed that you must have a valid test device to run
xfstests. Only recently did we add _require_test() to all the tests
that need the test device to move the mounting of the test device
from the harness to the tests themselves, but the harness itself
still has lots of code in it that assumes a test device must
exist....

Really, though, I fail to understand why this is a problem. It
takes 30s to configure test and scratch devices on loopback, and
then this is a total non-problem....

> > That you are using C code to detect whether an on-disk feature is
> > supported or not. This is done through running the userspace tools
> > to check they support the on-disk feature, then creating a
> > filesystem with those tools and mounting it to determine whether the
> > kernel supports the feature correctly as well.
> 
> Someone might run "check -g richacl" on a filesystem that doesn't
> support richacls. In that case, I want the richacl test cases to be
> skipped, with an explanation why; I don't want the test cases to just
> explode. That's the same as what the POSIX ACL related test cases do
> in common/attr:_require_acls().

Really? have you not noticed the copious use of _notrun() in all the
_require functions. here's a small selection for you:

generic/038      [not run] This test requires at least 10GB free on /mnt/scratch to run
generic/288 2s ... [not run] FITRIM not supported on /mnt/scratch
shared/002 0s ... [not run] This test requires a sane block device flush
xfs/016 9s ... [not run] Cannot mkfs for this test using MKFS_OPTIONS specified
xfs/035  [not run] No dump tape specified
xfs/095  [not run] not suitable for this OS: Linux
xfs/127  [not run] Reflink not supported by scratch filesystem type: xfs
xfs/131  [not run] External volumes not in use, skipped this test
xfs/186 2s ... [not run] attr v1 not supported on /dev/ram1
xfs/191  [not run] no mkfs support for NFS v4 ACLs
xfs/197  [not run] This test is only valid on 32 bit machines

And so on.

(Did you notice the xfs/191? You know, the old richacl test
execution wrapper. It's got all the mkfs/kernel/tool tests in it
that these days we wrap up into a _requires() function...)

> _require_acls() uses the chacl utility for probing for POSIX ACL
> support.

Yes, because posix acls don't have filesystem feature bits that can
be probed, nor do they have need for mkfs or fsck support. Welcome
to the new world - it's different to the old world.

> The require-richacls program serves the same purpose. I could
> probe using getfattr instead, but getfattr isn't necessarily
> installed, and I won't want to create an unnecessary dependency.

So you have to mkfs the filesytem, then mount it, then you can run
getfattr to check if richacls are supported. Yet mkfs can fail, the
mount can fail, and neither of them are going to give you nice
"richacls not supported" errors. See xfs/191, again.

> > There is no point in maintaining two test suites - you'll change
> > stuff in your richacl package test suite, and the xfstests stuff
> > will be ignored, because *you won't be using xfstests*.
> > The whole point of getting this stuff into xfstests is so that
> > there's one place to both run and maintain the tests.
> 
> I don't want to maintain two test suites, I want the same tests to
> work in both contexts.

Sure, xfstests becomes the master copy, because that's the one the
rest of the filesystem developer community needs you to maintain.

> >> What's the benefit? The tests don't need anything from common/, I want
> >> to keep them well separated so that updating them will remain easy.
> >
> > What's the benefit? That the tests all follow the same patterns, and
> > that means any xfstests user can modify and update the tests without
> > having to learn some new, weird frankenstein test infrastructure.
> 
> From the point of view of the xfstests infrastructure,

But from a maintenance perspective, as well as fs developers who
needs to understand the tests quickly, the tests need use the test
harness in the same way as all the other tests in xfstests. The same
logging, the same log files, the same expected results file, the
same method of determining pass or failure, etc.

Embed another test harness within the xfstests harness that does
it's own golden output matching, diffing, results aggregation and
reporting is just adding a whole load of code duplication
abstraction and bloat. It's unnecessary - the xfstests harness
provides all the functionality the richacl tests needs. It's just a
trivial mechanical conversion to change it all over. This isn't
difficult - you're making a mountain out of a molehill here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
