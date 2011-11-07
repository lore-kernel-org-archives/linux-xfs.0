Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7KxeOT076016 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:59:40 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BEA0304048
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 12:59:40 -0800 (PST)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 48E0A70016E1
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 14:59:40 -0600 (CST)
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 0/8] xfsdump: enable support for multiple streams
Date: Mon,  7 Nov 2011 14:58:23 -0600
Message-Id: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Version 2 of this series changes only patch #3. POSIX semaphores
are now used instead of rolling our own, as suggested by Christoph.
We lose the ability to count the number of waiting threads, which
was used in some asserts. There was adequate coverage in related
asserts, so this was deemed acceptable.


This series resurrects the IRIX multi-stream support for splitting a
backup among several output files/tapes. This offers some nice
performance improvements, particularly in xfsrestore where a single
stream often cannot keep the filesystem/disks busy. I've observed
a 1.7x improvement on a backup and a 5x improvement on restore.

I have a couple of xfstests for this, and will submit those once
a few outstanding xfsdump test patches have been reviewed.

There's a bit more work to do:

  - Now that xfsdump has threads once again, the tape I/O ring
    buffer support can be enabled. This series leaves it disabled
    so that more testing can be done in that area.

  - Currently the stream split points are determined by doing an
    extra inode scan. This is unchanged from how it was done on
    IRIX. I'd like to change this so that enough info is kept from
    the initial inode scan to determine appropriate split points
    without an additional scan.

  - You may notice in the last patch of this series that a lot
    of "miniroot" references also look at whether or not the dump
    is to a pipe. Now that the "miniroot" checks are gone, it's
    possible to clean up the pipe-related code too. I've got a
    separate patch series for that which I'll submit later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
