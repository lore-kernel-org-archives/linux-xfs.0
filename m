Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TCOIrk092043 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 07:24:18 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YEgWPtdc2sryBL9u for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 05:24:16 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SDEOj-0003fD-Gu
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:24:13 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SDEOT-0003NQ-IJ
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:23:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfs: clean up unit usage in xfs_buf V2
Date: Thu, 29 Mar 2012 23:23:47 +1100
Message-Id: <1333023835-12856-1-git-send-email-david@fromorbit.com>
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

This series cleans up the buffer cache API to use daddr formats for
block numbers and basic blocks for lengths when trying to get or
read a buffer and from there cleans up the internal usage of the
same thing. Essentially we end up with tracking buffers by their
daddr blkno, and BB based length, including the length of the IO
needed to do out of the buffer. The b_offset field is still in
bytes, as that is mostly used as a byte offset into the allocated
memory that the buffer holds, rather than a disk based offset.

Version 2:
- new patch 1, fixes hang in log reading code when trying to find
  the head and IO dispatch returns EIO. Generic fix for the same
  problem for all IO dispatched via xfsbdstrat() and then waited on
  via xfs_buf_iowait().
- new patch 2, fixes EIO during IO dispatch reading uncached buffers
  when page size unaligned, subpage-sized multi-block buffers are
  incorrectly required to need multiple pages due to invalid
  b_offset. This was triggered by log recovery when finding the head
  of the log, and caused the hang fixed in patch 1. Problem was
  reliably triggered by patch 5, though there is no obvious reason
  that I can find for any of those changes to have tripped over this
  landmine.
- new patch 3, clean, noticed when trying to work out why b_offset
  wasn't zero find the problem fixed in patch 2.
- patch 4-7, updated according to Christoph's comments
- new patch 8, kills the xfs_buf_btoc (and related) macros as
  suggested by Christoph.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
