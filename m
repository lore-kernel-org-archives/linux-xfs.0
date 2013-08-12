Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5627B7F6D
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C5658F8054
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AxGCKPAXGAxHghzI for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xf-Mj
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007LU-LX
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 00/17] xfs: inode management
	development direction
Date: Mon, 12 Aug 2013 23:19:50 +1000
Message-Id: <1376313607-28133-1-git-send-email-david@fromorbit.com>
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

Call this a 'request for discussion' or a 'request for developers',
however you want to look at it. I know there are people asking me
for bits of work that can be done, so I spent a little bit of spare
time I had sitting around in waiting rooms documenting the inode
development direction I'm planning to take for inode allocation and
freeing over the next few months.

There are a bunch of things that have lead to this:

	- allocation speed when free inodes are sparse
	- free space fragmentation preventing inode allocation
	- inability to cluster large numbers of inodes close
	  together
	- inode allocation transaction reservations being larger
	  than then need to be for 98% of allocations
	- unlinked list processing having a high cost when we have
	  lots of unlinked inodes waiting for reclaim
	- inode freeing being tied to VFS inode cache eviction
	- inability to recycle free inodes directly from the
	  unlinked list
	- support for O_TMPFILE

Basically, this started from me looking at what O_TMPFILE needed
to be supported, and grew from there. O_TMPFILE needs separation of
the inode allocation from the namespace operations, and link_at()
needs to be able to remove an inode from the unlinked list and link
it to the namespace.

That leads to inode allocation having very distinct operations that
are currently commingled by the transaction subsystem and the need
to guarantee enough log space for inode allocation and namespace
modification to happen atomically. Breaking this all up leads to a
bunch of optimisations that center around either avoiding
unnecessary work or being able to do it in batches asynchronously to
the foreground context that is running.

There's a lot of work here, some is dependent on other bits, and
some is completely separate. If anyone wants to pick up one (or
more) of the pieces and work on it, then I'm happy to help people
work through the changes and test them. I'll be slowly peeling off
pieces of this myself even if nobody else does.

Note that a good deal of these changes are only ever going to work
effectively on v5 filesystems e.g. atomic multi-chunk inode
allocation and incore inode unlinked lists and logging. Hence I've
only really focussed on optimisations and modifications that make
sense from a v5 filesystem POV. 

Comments, flames and volunteers welcome.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
