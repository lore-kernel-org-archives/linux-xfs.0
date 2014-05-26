Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2624B7F54
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 17:27:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 151B0304032
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 15:27:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	V0YcU2WGxYD3QNVx for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 15:27:14 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wp3MA-0001PR-BE
	for xfs@oss.sgi.com; Tue, 27 May 2014 08:26:58 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wp3MA-0002V7-AG
	for xfs@oss.sgi.com; Tue, 27 May 2014 08:26:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: regression fixes
Date: Tue, 27 May 2014 08:26:52 +1000
Message-Id: <1401143214-9181-1-git-send-email-david@fromorbit.com>
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

These are a couple of fixes that have come to light in the past few
days. The first prevents bad things happening in memory reclaim
when kswapd delegates block allocation to a workqueue, and the
second ensures XFS doesn't incorrectly try to check the sector size
on non-xfs devices when mount is probing.

Both are regressions, but given how late in the 3.15 cycle we are,
I'll probably just push these through the 3.16 merge to give them a
bit more testing and let them be handled by stable kernel backports.
Anyone have any particular concerns over that plan?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
