Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1KSaFd232389 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 14:28:36 -0600
Subject: xfstests 065 failures
From: Alex Elder <aelder@sgi.com>
Date: Wed, 01 Dec 2010 14:29:39 -0600
Message-ID: <1291235379.2556.28.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: dchinner@redhat.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

Dave, you were asking on IRC about test 065 failures.
I asked Bill Kendall about it and he bisected to find
that the commit below seems to be where the problems
started.  I believe the problem is that one of the
times is not updated properly when renaming the file
"addedfile4".  Here are the commands that might affect
that file in test 065:

	mv addeddir4/addedfile5 addeddir4/addedfile4
	mv addeddir4 addeddir6

I glanced at the commit and saw nothing obviously
wrong, but at the moment I can't really dig into
it any deeper so I thought I'd report what Bill
found so others could look.

					-Alex

>From dcd79a1423f64ee0184629874805c3ac40f3a2c5 Mon Sep 17 00:00:00 2001
From: Dave Chinner <dchinner@redhat.com>
Date: Tue, 28 Sep 2010 12:27:25 +1000
Subject: [PATCH] xfs: don't use vfs writeback for pure metadata
modifications

Under heavy multi-way parallel create workloads, the VFS struggles
to write back all the inodes that have been changed in age order.
The bdi flusher thread becomes CPU bound, spending 85% of it's time
in the VFS code, mostly traversing the superblock dirty inode list
to separate dirty inodes old enough to flush.

We already keep an index of all metadata changes in age order - in
the AIL - and continued log pressure will do age ordered writeback
without any extra overhead at all. If there is no pressure on the
log, the xfssyncd will periodically write back metadata in ascending
disk address offset order so will be very efficient.

Hence we can stop marking VFS inodes dirty during transaction commit
or when changing timestamps during transactions. This will keep the
inodes in the superblock dirty list to those containing data or
unlogged metadata changes.

However, the timstamp changes are slightly more complex than this -
there are a couple of places that do unlogged updates of the
timestamps, and the VFS need to be informed of these. Hence add a
new function xfs_trans_ichgtime() for transactional changes,
and leave xfs_ichgtime() for the non-transactional changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
