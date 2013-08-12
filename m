Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6AF597F59
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A8EE304039
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gEl8OnCAly9i3H2p for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phW-0004XT-Ls
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phW-00060O-KA
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM *****  [PATCH 00/50] xfs: patches for 3.12
Date: Mon, 12 Aug 2013 20:49:21 +1000
Message-Id: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

This is a rebase of the reviewed series of kernel patches I recently
posted here:

http://oss.sgi.com/pipermail/xfs/2013-July/028207.html

It addresses all the review comments except for one from Christoph
about the IOP_SIZE removal - I'll send a followup patch in a couple
of days to remove all the rest of IOP_ macros...

The log space problems from the optimisations have been fixed - the
fix went into patch 44 of this series, and cascaded through 45 and
46 as well. Those patches will need reviewing. The problematic
workload has been running for 16 hours here without failure on a
small (10MB) log, so AFAICT the problem is fixed.

There is one new patch - the fix to the use-after-free of clean
buffer items when a transaction is cancelled - and that is at the
end of the series.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
