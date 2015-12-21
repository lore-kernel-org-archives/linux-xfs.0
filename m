Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F217E29DF5
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 15:37:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FDEDAC002
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:37:31 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OOXccu4dxM27zz6L for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 13:37:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aB88m-0000ho-B5
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aB88m-0002l1-A4
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] xfsprogs: big, broken filesystems cause pain
Date: Tue, 22 Dec 2015 08:37:00 +1100
Message-Id: <1450733829-9319-1-git-send-email-david@fromorbit.com>
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

This is a work-in-progress patchset that I"ve been spending the last
week on trying to get xfs_repair to run cleanly through a busted
30TB filesystem image. The first 2 patches were needed just to get
metadump to create the filesystem image, the third is helpful in
tellingme exactly how much of the 38GB of metadata has been
restored.

The next two patches parallelise parts of the repair process;
uncertain inode processing in phase 3 was taking more than 20
minutes, and phase 7 was taking almost 2 hours. Both are trivially
parallelisable - the phase 3 is now down under 5 minutes, but I
haven't fully tested the phase 7 code because I haven't managed to
get a full repair of the original image past phase 6 since I wrote
this patch. I have run it through xfstests many times, but that's
not the same as having it process and correct the link counts on
several million inodes....

Patch 6 was the first crash problem I fixed - this is 17 year old
bug in the directory code, and will also need to be fixed in the
kernel.

Patch 7-9 fix the major problem that was causing issues - the
cache's handling of buffers that were dirty but still corrupt.
xfs_repair doesn't fix all the problems in a buffer in a single pass
- it may make modifications in early phases and then use those
modifications to trigger specific repairs in later phases. However,
when you have 38GB of metadata to check and correct, the buffer
cache is not going to hold all these buffers, and so the reclaim
algorithms are going to have an impact.

That impact was pretty bad - the partially correct buffers were
being tossed away because their write verifiers were failing and
hence never making it to disk.  Hence when the later phase re-read
the buffer, it pull the original uncorrected, corrupt blocks back in
from disk, and so phases 5, 6 and 7 were tripping over corruptions
that were assumed to be fixed and that was causing random memory
corruptions, use after free, etc.

These three patches are a pretty nasty hack to keep the dirty
buffers around until they are fully repaired. The whole userspace
libxfs buffer cache is really showing it's limitations here; it
doesn't scale effectively, it doesn't isolate operations between
independent threads (i.e. per-ag threads), it doesn't handle dirty
objects or writeback failures sanely and it has an overly
complex cache abstraction that has only one user. Ultimately, we need
to rewrite it from scratch, but in the mean time we need to make
repair actually complete properly and hence these patches to hack
the necessary fixes into it.

With these, repair is getting deep into phase 6 on the original
image, before failing moving an inode to lost+found because the
inode has a mismatch between the bmbt size and the number of records
supposedly in the bmbt. That's a new failure I haven't seen before,
so there's still more fixes to come....

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
