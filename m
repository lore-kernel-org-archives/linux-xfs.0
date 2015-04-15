Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8ADC47F62
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 23:52:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 701BE8F8078
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 21:52:04 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jMz9mKSCz1chQ3pc for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 21:51:56 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YiFIo-00032R-5S
	for xfs@oss.sgi.com; Wed, 15 Apr 2015 14:51:54 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YiFIo-0005EA-4Y
	for xfs@oss.sgi.com; Wed, 15 Apr 2015 14:51:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8 v3] xfs: fix direct IO completion issues
Date: Wed, 15 Apr 2015 14:51:43 +1000
Message-Id: <1429073512-20035-1-git-send-email-david@fromorbit.com>
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

Versions 3 of the DIO write completion fixes, v2 was here:

http://oss.sgi.com/archives/xfs/2015-04/msg00129.html

This version fixes the spelling mistakes Brian noticed, re-adds a
couple of comments that were incorrectly removed, re-adds an assert
in the !ioend path inside xfs_end_io_direct_write() and cleans up
the setting of the buffer_defer_completion flag so that it's set
when we allocate the ioend for defered completion.

Comments, thoughts and testing all wlecome.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
