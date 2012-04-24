Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3O6XnNU031543 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 01:33:49 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ApeCOhZc9fPQsTEq for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 23:33:47 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMZJo-0004NK-3v
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMZJn-0005t3-SB
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/10] xfs: discontiguous buffer support a.k.a. die xfs_dabuf
	die
Date: Tue, 24 Apr 2012 16:33:30 +1000
Message-Id: <1335249220-22274-1-git-send-email-david@fromorbit.com>
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

This patch series builds on top the current patch queue I posted
yesterday. This series replaces the struct xfs-dabuf with an xfs_buf
that can serve the same purpose.

Directory buffers may be made up of multiple extents, but are
currently formed by creating individual buffers and then copying the
data out of them into a linear memory region in a dabuf structure.
All dabuf operations then require walking all the underlying buffers
to change the state of the underlying buffers, and once a dabuf is
modified the contents need to be copied back to the underlying
buffers before they are logged.

All of these operations can be done on a normal xfs_buf, but the
normal xfs_buf does not support multiple disk block ranges or doing
multiple disjoint I/Os to read or write a buffer. Supporting
multiple disk block ranges is not difficult - we simply need to
attach an iovec-like array to the buffer rather than just using a
single block number and length.

Splitting the buffer up into multiple IOs for read and write is not
difficult, either. We already track the number of IO remaining to
complete an IO, so this can be used to wait for the multiple IO
dispatched to complete (for both read and write).

The only interesting twist to this is logging the changes. We can
treat the discontiguous buffer as a single buffer for most purposes
except for formatting the changes into the log. When formatting, we
need to split the changes into a format item per underlying region
so that recovery does not need to know about compound buffers and
can recover each segment of a directory block indivdually as it does
now. The fact that recovery will replay all or none of the
transaction ensures this process is still atomic from a change
recovery point of view.

Further, even though log recovery doesn't use discontiguous buffers,
there will be no confusion between a short buffer written by
recovery and a discontiguous buffer read by the directory code after
mount because the lengths of the buffer will be different. hence we
need no changes to mount or log recovery processing as we already
ensure that all log recovery changes hve been written to disk before
we finish the mount process.

The reason for making this changes is that we can now use a buffer
cache callback to do all the metadata CRC calculations and
verifications across both contiguous and discontiguous directory
blocks. It greatly simplifies the implementation of this code and
makes it consistent with all other metadata buffers. It should also
provide a performance improvement because it avoids double copying
and reduces the number of cached buffers.

I've tested this on 4k/4k (FSB/DB sizes), 512b/64k, and 4k/64k
combinations with xfstests and some dbench, fsmark and compilebench
stress loads. More testing is welcome....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
