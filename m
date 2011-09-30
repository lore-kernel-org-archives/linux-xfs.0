Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8U4jCRJ236299 for <xfs@oss.sgi.com>; Thu, 29 Sep 2011 23:45:13 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F797152A919
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2011 21:51:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Y4s1SyhxXPsyFMnX for <xfs@oss.sgi.com>;
	Thu, 29 Sep 2011 21:51:21 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1R9UyA-0005CP-IG
	for xfs@oss.sgi.com; Fri, 30 Sep 2011 14:45:06 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1R9UyA-00071V-9D
	for xfs@oss.sgi.com; Fri, 30 Sep 2011 14:45:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: patches for 3.2
Date: Fri, 30 Sep 2011 14:45:01 +1000
Message-Id: <1317357903-26947-1-git-send-email-david@fromorbit.com>
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

These are the two patches I have outstanding for 3.2. I've dropped
the xfsbufd changes from the series as Christoph and I have been
discussing ways to change metadata writeback that make the xfsbufd
redundant. Hence there's no need to change it now...

I've dropped all the interface changes from the xfs buf allocation
code change, simplifying it lots, and fixed the problems reported
with it. I've also fixed a bug in the AIL log force reduction patch
that caused the AIL to get stuck when pinned buffers caused the
stuck processing to loop.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
