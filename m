Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N1ZWAM141081 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 20:35:32 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F14917514BB
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 18:35:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZwpRE0mLdt5sdmai for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 18:35:30 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QZYpM-0003zW-Vc
	for xfs@oss.sgi.com; Thu, 23 Jun 2011 11:35:29 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QZYoy-0005xo-JU
	for xfs@oss.sgi.com; Thu, 23 Jun 2011 11:35:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: fixes for 3.0-rc4
Date: Thu, 23 Jun 2011 11:34:58 +1000
Message-Id: <1308792901-22880-1-git-send-email-david@fromorbit.com>
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

The following three patches are fixes ensuring inodes state is
correctly reset when they are recycled, ensuring specualtive
preallocation is correctly reaped after a truncate down, and the
untrusted attribute removal assert fix that xfstests triggers on
selinux enabled systems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
