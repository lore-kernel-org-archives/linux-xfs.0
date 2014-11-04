Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C1BE7F7C
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 06:53:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A552304039
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 04:53:31 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TovFZjOkAasVhCgB for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 04:53:29 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Xldbv-0008Pg-QN
	for xfs@oss.sgi.com; Tue, 04 Nov 2014 23:53:23 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Xldbv-0001jA-PA
	for xfs@oss.sgi.com; Tue, 04 Nov 2014 23:53:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: fix the bulkstat mess
Date: Tue,  4 Nov 2014 23:53:15 +1100
Message-Id: <1415105601-6455-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This series of patches applies on top of the xfs-fixes-for-3.18-rc3
branch in the upstream repository. The bulkstat refactoring in 3.17
broke bulkstat in a couple of subtle ways and exposed an API wart
that was undocumented and completely non-obvious and these lead to
xfsdump failing badly on some filesystems. The first 5 patches in
this series are necessary to fix the regressions, the 6th patch
cleans up a remaining loose end.

Essentially, the old bulkstat code was pretty much unchanged in
algorithm since 1995 when a commit was made to fix a deadlock. See
the commit in the XFS archive tree 314ccac26af ("Fix a locking bug
in bulkstat by rewriting it"). Unfortunately, this commit introduced
the unexpected behviour that the inode pointed to by the lastino
cookie is not included in the bulkstat output.

THe result of this is some tricky code in xfsdump - again
undocumented - where a specific bulkstat scan during the dump
process does not use the bulkstat lastino cookie, but uses it's own
internal inode map to determine where to start the next bulkstat
call. In this case, the bulkstat cookie has a magic "target - 1"
calculation. In all other bulkstat cases, the cookie from the
previous call is passed into the next call. This magic code in
cfsdump was introduced in 2006 as an optimisation to avoid making
too many bulkstat calls.

Essentially, the xfsdump code is working around the undocumented
lastino cookie behaviour. Seeing as userspace has already coded for
this bug, we can't change that behaviour now, and that's exactly
what the refactoring in 3.17 did - it rejected "lastino - 1" in
certain circumstances with EINVAL instead of doing the right thing
and returning the correct inodes.

But, this was the last problem I found, because the EINVAL was
dropped on the floor and ignored, because bulkstat only returned
errors from the formatting function of inodes it did find. Hence the
fact it didn't scan an inode it should have was silently lost.

I found this problem after I realised that errors from the
formatting function are only returned if no other inodes were
successfully formatted at all. Which means, in reality, errors
encountered during bulkstat are universally ignored and the result
is "successful" scans that are silently missing inodes. Which means
xfsdump succeeds, but xfsrestore tells us that it was a corrupted
dump.

Of course, in getting to this point, I first had to add the missing
checks in the btree walk termination detection, fix the user buffer
space tracking, the inode tracking, the slightly broken chunk
formattting loop conditions, remove a bunch of unused variables,
and so on. There was a *lot* that didn't work correctly and I'm
still slightly stunned at the fact it worked well enough to pass
all the xfsdump/restore QA in xfstests.

As such, the first 5 patches are -stable kernel material, and the
last patch should go with them into the 3.18 tree to complete the
cleanup of code. This needs eyeballs and testing - create some
metadumps of your production filesystems and use them to test
xfsdump on a kernel with these changes......

Comments, thoughts, testing all welcome as this needs to go upstream
sooner rather than later....

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
