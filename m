Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9515dca247236 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 20:05:39 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qxmhcLC4Yna5ExpE for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 18:07:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TJwNa-0000bE-CM
	for xfs@oss.sgi.com; Fri, 05 Oct 2012 11:07:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TJwNa-0003P2-89
	for xfs@oss.sgi.com; Fri, 05 Oct 2012 11:07:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix AGF/alloc workqueue deadlock.
Date: Fri,  5 Oct 2012 11:06:57 +1000
Message-Id: <1349399219-13024-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This is a followup from the last conversation with Mark about this
deadlock. I haven't heard anything in the last coupl eof days, so I
figured I'd just write the patches that did what I thought is
needed.

Basically, the stack switch is only needed for userdata in the
delayed allocation path, and nowhere else at this point in time. To
make it so we switch stacks only at this point in time, I introduced
a flag to pass to xfs_bmapi_write(). This means we don't switch
stacks during direct IO, unwritten extent conversion or
preallocation via fallocate/XFS_IOC_RESVSP.

I then moved the stack switch to xfs_bmapi_allocate(), which is
where allocation happens. All the allocation calls within a single
userdata extent allocation occur in this function (both data extent
and bmap btree blocks), so switching stacks here will ensure that
only mapping calls that require allocation will have the stack
switched.

Comments welcome...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
