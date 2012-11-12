Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACB7xmB214610 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:07:59 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HtpuQ65GMLfY8cTb for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:10:00 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXrtk-0004ya-Rm
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:09:48 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXrtk-0000wD-Mw
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:09:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: fixes for 3.7-rc6
Date: Mon, 12 Nov 2012 22:09:43 +1100
Message-Id: <1352718586-3538-1-git-send-email-david@fromorbit.com>
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

These are the remaining fixes I have in my tree for the 3.7 cycle.
One is a corruption fix, the other two are problems I'm seeing
during shutdown and recovery testing. That testing lasts 400-500
cycles (3-4 hours) now before it fails with another, as yet unknown
buffer/perag reference assert failure. Without these fixes, it lasts
3-4 cycles before assert failing or triggering a BUG.

I'd like these fixes to be in the 3.7 cycle if at all possible, with
both patch 1 and 2 being stable kernel candidates.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
