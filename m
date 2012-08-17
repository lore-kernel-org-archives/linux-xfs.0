Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HMtUE8107542 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 17:55:30 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EZKaU6mAEMqrlYTM for <xfs@oss.sgi.com>;
	Fri, 17 Aug 2012 15:55:28 -0700 (PDT)
Date: Sat, 18 Aug 2012 08:55:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Message-ID: <20120817225524.GA19235@dastard>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
	<20120817060110.GA28786@localhost>
	<20120817131558.GA11439@thunk.org>
	<20120817174841.GA4519@infradead.org>
	<20120817203438.GA573@thunk.org>
	<20120817210527.GA22716@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120817210527.GA22716@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 hackers <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

On Fri, Aug 17, 2012 at 05:05:27PM -0400, Christoph Hellwig wrote:
> On Fri, Aug 17, 2012 at 04:34:38PM -0400, Theodore Ts'o wrote:
> > On Fri, Aug 17, 2012 at 01:48:41PM -0400, Christoph Hellwig wrote:
> > > 
> > > Can you submit this for xfstests?
> > > 
> > 
> > This is actually something I wanted to ask you guys about.  There are
> > a series of ext4-specific tests that I could potentially add, but I
> > wasn't sure how welcome they would be in xfstests.  Assuming that
> > ext4-specific tests would be welcome, is there a number range for
> > these ext4-specific tests that I should use?
> 
> Dave actually has an outstanding series to move tests from the toplevel
> directory to directories for categories.

And a whole lot more stuff, like a separate results directory, being
able to run just a directory of tests rather than a group (e.g. just
run ext4 specific tests), being able to use names rather than
numbers for tests (not quite there yet), being able to exclude
different tests (e.g. for older distro testing with wont-fix bugs),
etc.

Basically, all those things I talked about at the LSF/MM conference
about making xfstests easier to use, develop and deploy for the wider
filesystem community are started in the patchsets here:

http://oss.sgi.com/archives/xfs/2012-07/msg00361.html
http://oss.sgi.com/archives/xfs/2012-07/msg00373.html

"This moves all the tests into a ./tests subdirectory, and sorts them into
classes of related tests. Those are:

        tests/generic:  valid for all filesystems
        tests/shared:   valid for a limited number of filesystems
        tests/xfs:      xfs specific tests
        tests/btrfs     btrfs specific tests
        tests/ext4      ext4 specific tests
        tests/udf       udf specific tests

Each directory has it's own group file to determine what groups the
tests are associated with. Tests are run in exactly the same was as
before, but when trying to run individual tests you need to specify
the class as well. e.g. the old way:

# ./check 001

The new way:

# ./check generic/001

...."

> We already have a lot of
> btrfs-specific tests that have a separate directory, as well as xfs
> specific ones, ext4 would just follow this model.  For this specific
> test it actually seems fairly generic except for the commit interval,
> so I'd love to run it for all filesystems, just setting the interval for
> ext4.

Yeah, anything that is not deeply fileystem specific should be
written as a generic test so that it can run on all filesystems. If
it's mostly generic, with a small fs specific extension, that
extension is easy to do under a 'if [ $FSTYP = "ext4" ]; then'
branch....

> > BTW, we have an extension to xfstests that we've been using inside
> > Google where Google-internal tests have a "g" prefix (i.e., g001,
> > g002, etc.).  That way we didn't need to worry about conflicts between
> > newly added upstream xfstests, and ones which were added internally.
> > Would it make sense to start using some kind of prefix such as "e001"
> > for ext2/3/4 specific tests?

No.  The whole point of moving to multiple directories is to allow
easy extension for domain specific tests without having to hack up
the check script or play other games with test naming. Duplicate
names in different test subdirectories are most certainly allowed.

> Can you take a look at Dave's series if that helps you?  I haven't
> really reviewed it much myself yet, but I'll try to get to it ASAP.

Well, I'd apprepciate it if somebody looked at it. It's been almost
a month since I posted it and all I've heard is crickets so far...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
