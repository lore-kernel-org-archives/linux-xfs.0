Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8CF087CA6
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 01:06:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CE03304039
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2016 23:06:37 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zq7nHpEmVmR6Fxpx for <xfs@oss.sgi.com>;
	Mon, 04 Apr 2016 23:06:35 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1anK7T-000150-QL
	for xfs@oss.sgi.com; Tue, 05 Apr 2016 16:05:43 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1anK6z-0003aT-EU
	for xfs@oss.sgi.com; Tue, 05 Apr 2016 16:05:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: various fixes
Date: Tue,  5 Apr 2016 16:05:06 +1000
Message-Id: <1459836310-12619-1-git-send-email-david@fromorbit.com>
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

The following series of patches are all standalone fixes for various
issues that have been reported by users. The first AGFL fix is a
recent regression, which the other three address long standing
issues.

The second patch addresses the issue of memory allocation occurring
under the CIL lock and memory reclaim requiring the CIL lock to be
taken, resulting in deadlocks in extreme low memory conditions. This
version has minor changes around the way the shadow buffer is
allocated and initialised, but is otherwise mostly unchanged from
previous RFC postings.

The third patch addresses the excessive CPU overhead of bitmap based
dirty buffer range tracking on large block sizes. It keeps a small
number of ranges per buffer, and extends and merges them as
appropriate. This completely removes the bitmap overhead from the
buffer item formatting path. This main change in this patch from
previous RFC postings is that it uses multiple ranges for tracking
rather than a single range. I decided on 4 discrete ranges as the
best tradeoff between efficiency and log space requirements.

THe last patch addresses a buffer hold-off when there is lots of
dirty metadata beign written back from the AIL. If a buffer at the
tail of the log is at a very high offset in the filesytem (e.g. AGF
header in the last AG), it could be locked for a long time while we
wait for IO to lower offsets to be dispatched. IO dispatch gets
blocked by device congestion, so in the worst case lock hold-offs
measured in seconds have been recorded. This change sorts the buffer
list into offset order before we lock any buffers, and then
dispatches IO as each buffer is successfully locked. This limits
lock holds to the length of time a buffer sits on the plug plus the
IO time, which is usually very short. This means frequently used
buffers can be locked and relogged while we wait for IO dispatch
rather than blocking attempts to access the buffer.

Comments, thoughts, etc all welcome.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
