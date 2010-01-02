Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0236clD053722 for <xfs@oss.sgi.com>; Fri, 1 Jan 2010 21:06:39 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AC2A1502BEC
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2010 19:07:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	Y56q2By9Q7KObCJa for <xfs@oss.sgi.com>;
	Fri, 01 Jan 2010 19:07:26 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10940216-1927428
	for <xfs@oss.sgi.com>; Sat, 02 Jan 2010 13:37:24 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NQuKc-0007yk-Rj
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 14:07:10 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NQuHE-00057S-1w
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 14:03:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/3] Kill async inode writeback
Date: Sat,  2 Jan 2010 14:03:33 +1100
Message-Id: <1262401416-19546-1-git-send-email-david@fromorbit.com>
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
different places - xfssyncd, xfsbufd, the bdi writeback threads and when
pushing the AIL. The result is that inodes can be pushed at any time
and there is little to no locality to the IO patterns results from
such writeback. Indeed, we can have completing writebacks occurring
which only serves to slow down writeback.

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

Perf results on a debug XFS build (means allocation patterns are
variable, so runtimes are also a bit variable):

Untar 2.6.32 kernel tarball, sync, then remove:

		Untar+sync	rm -rf
xfs-dev:	  25.2s          13.0s
xfs-dev-delwri:	  22.5s           9.1s

4 processes each creating 100,000, five byte files in separate
directories concurrently, then 4 processes removing a directory each
concurrently.

		create		rm -rf
xfs-dev:         8m32s           4m10s
xfs-dev-delwri:	 4m55s           3m42s

There is still followup work to be done on the buffer sorting to
make it more efficient, but overall the concept appears to be solid
based on the improvements in sustained small file create rates.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
