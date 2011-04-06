Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p366Gnbl019800 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 01:16:49 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D556E3A7E94
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2011 23:19:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HtyHVE7rVoEbQMHp for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2011 23:19:39 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7M5G-00040Q-NY
	for xfs@oss.sgi.com; Wed, 06 Apr 2011 16:19:18 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7M5I-0004WC-EQ
	for xfs@oss.sgi.com; Wed, 06 Apr 2011 16:19:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] xfs: candidate fixes for 2.6.39
Date: Wed,  6 Apr 2011 16:19:09 +1000
Message-Id: <1302070758-17312-1-git-send-email-david@fromorbit.com>
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

The following series contains a few things:

	1. an extent buffer allocation size fix
	2. a corrupt extent freeing fix
	3. converting the log tail checking to a warning
	4. workqueue series for fixing OOM problems

#1 and #4 have been posted before, these are updated versions.
#2 was recetnly reported by Redhat QA, and #3 was reported as a
problem for the Power arch via IBM.

I can separate them out into separate patch series if wanted, I'm
just being lazy sending them all as one series. Alex, I'll push them
to a git branch if theya re all acceptible and send you a pull req.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
