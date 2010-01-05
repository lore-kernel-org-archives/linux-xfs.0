Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0507SgH158242 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 18:07:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E20E41C2A907
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 16:08:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	EAtpHtj4QU8RWVJS for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2010 16:08:18 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11041845-1927428
	for <xfs@oss.sgi.com>; Tue, 05 Jan 2010 10:38:17 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NRwy7-00069S-Fp
	for xfs@oss.sgi.com; Tue, 05 Jan 2010 11:08:15 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NRwuP-0007R5-Tp
	for xfs@oss.sgi.com; Tue, 05 Jan 2010 11:04:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] Kill async inode writeback V2
Date: Tue,  5 Jan 2010 11:04:18 +1100
Message-Id: <1262649861-28530-1-git-send-email-david@fromorbit.com>
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

Currently we do background inode writeback on demand from many
different places - xfssyncd, xfsbufd, xfsaild and the bdi writeback
threads.  The result is that inodes can be pushed at any time and
there is little to no locality to the IO patterns results from such
writeback. Indeed, we can have completing writebacks occurring which
only serves to slow down writeback.

The idea behind this series is to make metadata buffers get
written from xfsbufd via the delayed write queue rather than than from
all these other places. All the other places do is make the buffers
delayed write so that the xfsbufd can issue them.

This means that inode flushes can no longer happen asynchronously,
but we still need a method for ensuring timely dispatch of buffers
that we may be waiting for IO completion on. To do this, we allow
delayed write buffers to be "promoted" in the delayed write queue.
This effectively short-cuts the aging of the buffers, and combined
with a demand flush of the xfsbufd we push all aged and promoted
buffers out at the same time.

Combine this with sorting the delayed write buffers to be written
into disk offset order before dispatch, and we vastly improve the
IO patterns for metadata writeback. IO is issued from one place and
in a disk/elevator friendly order.

Version 2:
- use generic list sort function
- when unmounting, push the delwri buffers first, then do sync inode
  reclaim so that reclaim doesn't block for 15 seconds waiting for
  delwri inode buffers to be aged and written before the inodes can
  be reclaimed.

Perf results (average of 3 runs) on a debug XFS build (means allocation
patterns are randomly varied, so runtimes are also a bit variable):

Untar 2.6.32 kernel tarball, sync, then remove:

                  Untar+sync     rm -rf
xfs-dev:           25.2s          13.0s
xfs-dev-delwri-1:  22.5s           9.1s
xfs-dev-delwri-2:  21.9s           8.4s

4 processes each creating 100,000, five byte files in separate
directories concurrently, then 4 processes removing a directory each
concurrently.

                  create          rm -rf
xfs-dev:           8m32s           4m10s
xfs-dev-delwri-1:  4m55s           3m42s
xfs-dev-delwri-2:  4m56s           3m33s

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
