Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2S5JklS243732 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 00:19:46 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Dt7Jf3xfMBCmW4Vb for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 22:19:44 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SClIG-0000CY-Ou
	for xfs@oss.sgi.com; Wed, 28 Mar 2012 16:19:36 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SClI1-0001U4-Eb
	for xfs@oss.sgi.com; Wed, 28 Mar 2012 16:19:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: clean up unit usage in xfs_buf
Date: Wed, 28 Mar 2012 16:19:14 +1100
Message-Id: <1332911958-5613-1-git-send-email-david@fromorbit.com>
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

This is an update an repost of the start of a series I posted back
in December. It has been rebased on top of Christoph's ilock hold
reduction and xfsbufd removal patch series, as well as all the
outstanding patches I've sent out recently, so I guarantee it won't
apply to a dev tree cleanly.

Basically this series cleans up the buffer cache API to use daddr
formats for block numbers and basic blocks for lengths when trying
to get or read a buffer and from there cleans up the internal usage
of the same thing. Essentially we end up with tracking buffers by
their daddr blkno, and BB based length, including the length of the
IO needed to do out of the buffer. The b_offset field is still in
bytes, as that is mostly used as a byte offset into the allocated
memory that the buffer holds, rather than a disk based offset.

Ther's nothing controversial here (at least, not from the raction to
the first posting). It lays the groundwork for introducing
compound buffers, and those are needed to be able to remove the
intermediate xfs_dabuf that the directory code uses for
discontiguous large directory blocks. This will then allow all
metadata types to use the the buffer cache to trigger CRC
calculations on immediately after read (validation) and prior
to write (calculation).

The compound buffer patches will follow soon - i'm trying to break
this up into bite-sized chunks so that reviewers have a chance to
keep up with the rate can test them and I post them...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
