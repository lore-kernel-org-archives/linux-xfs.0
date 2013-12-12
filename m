Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F6C37F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 18:53:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79D1730406A
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 16:53:50 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pUbCV1c62KmzH46N for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 16:53:48 -0800 (PST)
Date: Thu, 12 Dec 2013 11:53:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131212005343.GV10988@dastard>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard> <20131212001655.GA31768@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212001655.GA31768@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Junho Ryu <jayr@google.com>, hughd@google.com, branto@redhat.com, xfs@oss.sgi.com

On Wed, Dec 11, 2013 at 07:16:55PM -0500, Theodore Ts'o wrote:
> On Thu, Dec 12, 2013 at 09:40:12AM +1100, Dave Chinner wrote:
> > > 
> > > All these tests don't make sense if you never unmount the filesystem.
> > > Istead they should exit with _notrun for tmpfs.
> > 
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
> 
> At a higher level, I wonder how useful having the distinction between
> "generic" and "shared" really is.  Suppose in the future we add some
> tests for networked file systems or cluster file systems --- do we end
> up migrating even more tests from "generic" to "shared" when we find
> tests that don't work for some new file system?

That's not the problem I'm pointing out. The physical location ofthe
test at this point is irrelevant.

The fundamental problem is that "generic" is a wildcard that we use
to match all filesystems, and so adding a new filesystem changes
the definition and suddenly tests that were generic now no longer
run on all filesystems.

> And to the extent that we have things like 
> 
> _require_<feature>
> 
> which skips certain tests, it's not even true that all generic tests
> are run for all file systems.

_supported_fs is just a _requires_<foo> statement on steriods.
"generic" simply documents tests that are expected to run on every
single filesystem we can throw at it.

The thing is, tmpfs is a very special snowflake - it's a volatile
filesystem. xfstests was never designed to handle filesystems that
destroy their contents on unmount, and so adding a filesystem that
*doesn't support unmount/remount* breaks fundamental assumptions the
test harness makes about how filesystems behave.

Hence adding tmpfs support means that a generic test can no longer
unmount and mount filesystems. That's a major change in test
architecture right there, and I'm not sure we start turning stuff
upside down to support wacky quirks like volatile filesystems we
can't unmount...

That's the bigger issue here - tmpfs fundamentally violates the
assumption that xfstests is based on - that filesystems are
non-volatile and persist across unmount and hence can be rigorously
validated after an unmount...

The result of this is it changes cwthe definition of what a
"generic" filesystem is, and then everything flows downhill from
there.

> Perhaps it would make more sense to move all of the generic test to
> shared, and eliminating the distinction?  That way it also becomes
> easier becase we don't need to remember whether a test is generic/NNN
> vs shared/NNN.  :-)

Again, that does not solve the problem of tmpfs changing the
definition of a "generic" filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
