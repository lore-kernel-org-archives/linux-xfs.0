Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5FA37F5E
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 01:05:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7801304059
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 23:05:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	LTkiKRGEhX6jFvpB for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 23:05:07 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Z01nQ-0001D6-GV
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Z01nQ-0002ue-FX
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 00/20] xfs: reverse mapping btree support
Date: Wed,  3 Jun 2015 16:04:37 +1000
Message-Id: <1433311497-10245-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Folks,

This is the first pass at kernel support for reverse block mapping
btree support in XFS. It is a single [block, owner] tree, so does
not support multiple mappings of a single block. That's left as an
exercise for Darrick to solve with the reflink btree code he is
working on. :P

The patch set is based on the current for-next branch (i.e. on top
of the sparse inode branch). I've also got my DAX branch and all the
current pending fixes applied ahead of this series too, so if you
have problems applying it, those will go away in the next couple of
days as those patchsets are pushed into the for-next branch.

The first 4 patches are not rmap btree patches - they do an initial
cleanup on xfs_alloc_fix_freelist() to be easier to read and also to
clean up some of the macros we need to add rmap support to. These 4
patches stand alone and can be reviewed and committed sepearately to
the rest of the rmap btree code.

In general, the approach I;ve taken is to add a piece at a time in
each patch. I've added stubs to show how owner information is will
be passed around, as well as how the rmap btree will be modified
long before the the rmap implementation is added. I did this to
clearly separate the rmap btree implementation details from
surrounding code that drives it. hence it should be easier to review
as the changes are as simply as possible.

It's not 100% complete - there is still things like XFS_IOC_SWAPEXT
that needs to be handled, but like the original CRC implementation
swapping the owners of extents is not straight forward, and so that
will be done once the core implementation has settled down.

As for testing, this really is only lightly smoke tested right now;
sufficient to post it as an RFC, but that's really it because the
userspace side is not yet complete. e.g. xfs_repair will typically
SEGV in phase 5 because there's no code to rebuild the rmap btree
yet. xfs_repair -n, however, does work, and it does validate the
consistency of the rmap btree against the free space btrees and the
used space indexed by the filesystem in phases 3 and 4. That said,
it has passed the entire "quick" group in xfstests, except for the
tests dependent on swapext or repair working correctly, so it's not
entirely broken. ;)

The current userspace code is still based on the older
single-patch code that I started with a couple of days ago before
splitting the kernel kernel code into this series. It's just a
single patch right now based on top of the libxfs-4.1-update branch
in the kernel.org tree. Get it from the following repo branch:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git rmap-btree

I've been testing with:

# mkfs.xfs -f -m crc=1,finobt=1,rmapbt=1 <dev>

Over the next couple of days, I'll rebase the libxfs-4.1-update
branch to the current master branch and push Brian's sparse inode
support patchset into it as well. Then I'll start cleaning up the
userspace patchset and implementing some of the missing pieces.

Comments, flames, insanity pleas, testing and discussion all
welcome.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
