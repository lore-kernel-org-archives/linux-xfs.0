Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84F7A7F50
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:04:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7277F304039
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 15:04:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GlzdfgzBHqoKzYdp for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 15:04:39 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: kill lockdep false positives from readdir
Date: Wed, 12 Aug 2015 08:04:06 +1000
Message-Id: <1439330648-1057-1-git-send-email-david@fromorbit.com>
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
Cc: jack@suse.cz, oleg@redhat.com

Hi Folks,

These two patches change the XFS directory locking to shut up
lockdep. Ever since we changed the locking to serialise readdir via
the ILOCK for CXFS, lockdep has been producing false positive
warnings because filldir can trigger page faults and lockdep can't
be easily told that you can't take page faults on directory inodes
so it warns about all sorts of stuff that just can't deadlock.

To fix this, we need to change the directory locking (again!)
to use a different structure that separates the page fault path out
from underneath the ILOCK. TO do this, we have to treat the
directory data the same way we treat file data: The IOLOCK
serialises access to the data sections of the inode, the ILOCK
serialises access to the metadata sections of the inode.

This means that we need to take the IOLOCK in operations that modify
the directory data, which means we need nested PARENT lockdep
annotations because we need to lock two inodes at a time, so the
inode subclass lockdep annotations need a complete rework to support
this. This annotation rework is the first patch in the series.

THe second patch in the series is the directory locking rework. It's
all relatively straight forward - on modification the IOLOCK is
taken EXCL before we start transactions, the transaction join is modified
to understand the IOLOCK is also held, and the transaction commit
releases the IOLOCK. On readdir, we hold the IOLOCK in SHARED mode
across the readdir operation, and only hold the ILOCK when doing
operations that walk the extent tree and map directory buffers.

Oleg and Jan, this patchset should fix the lockdep issues that have
been seen with the freeze rework. Oleg, can you you try it with your
current patchset and testing and let me know if there are any issues
that you see?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
