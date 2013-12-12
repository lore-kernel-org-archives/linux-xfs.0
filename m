Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FF4F7F51
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:57:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C08530406A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:57:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EQmJ0y3aKCjSU7Wy for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:57:00 -0800 (PST)
Date: Fri, 13 Dec 2013 09:56:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131212225657.GK10988@dastard>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard>
	<20131212180130.GA19422@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212180130.GA19422@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Junho Ryu <jayr@google.com>, hughd@google.com, tytso@mit.edu, branto@redhat.com, xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 10:01:30AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2013 at 09:40:12AM +1100, Dave Chinner wrote:
> > IOWs, adding tmpfs changes the definition of a "generic" test.
> > 
> > i.e. instead of:
> > 
> > _supported_fs generic
> > 
> > these tests are now:
> > 
> > _supported_fs xfs ext2 ext3 ext4 ext4dev btrfs gfs2 nfs udf reiserfs
> > 
> > and by that definition should be in the tests/shared directory....
> > 
> > That's a bit of a pain, but I really don't like the idea of having
> > "generic" tests that aren't actually generic by having to define
> > exceptions for them...
> 
> We already have tons of these:

Yes, but that's not the same situation as tmpfs here.  A generic
filesystem fits a certain model but the given configuration/kernel
does not necessarily support the feature being tested. Those
features are easily testable by a _requires_* line.

This case with tmpfs is different - it doesn't support *being
unmounted* during a test because it is volatile. That's a
fundamental change to the assumptions xfstests makes about
filesystems being tested.  IOWs, we've got a "generic" filesystem
that is anything but generic.

Adding "_requires_non_volatile_fs" to all the generic tests that do
an unmount so that tmpfs can be considered "generic" is just as
painful as modifying the "_supported_fs generic" lines in all the
tests. It just leads us to a game of whack-a-mole.

I don't know what the solution here is - everything I think of is
either messy, ugly or unmaintainable. All I'm trying to do is find a
way to handle tmpfs filesystems in a way that is maintainable and
doesn't require every developer to be aware of the quirks of tmpfs
when writing and reviewing new generic tests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
