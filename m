Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p786pSwm020218 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 01:51:28 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FBA716906F5
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 23:52:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vxmI2za0FTcBPLOg for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 23:52:42 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QqJgA-00028X-7U
	for xfs@oss.sgi.com; Mon, 08 Aug 2011 16:51:14 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QqJg9-0002qB-Vg
	for xfs@oss.sgi.com; Mon, 08 Aug 2011 16:51:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: small metadata performance optimisations
Date: Mon,  8 Aug 2011 16:51:09 +1000
Message-Id: <1312786271-10871-1-git-send-email-david@fromorbit.com>
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

These are a couple of small optimisations that I made after noticing
just how rare buffer cache misses are and where log forces are being
triggered from most commonly during highly concurrent metadata
workloads.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
