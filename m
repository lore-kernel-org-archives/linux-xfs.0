Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AA6DPw081012 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 05:06:13 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EkqifRANqHVi4ziA for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 03:06:12 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SHXxi-0002XT-Gd
	for xfs@oss.sgi.com; Tue, 10 Apr 2012 20:06:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SHXvD-000701-Dd
	for xfs@oss.sgi.com; Tue, 10 Apr 2012 20:03:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: More xfs_buf cleanups
Date: Tue, 10 Apr 2012 20:03:30 +1000
Message-Id: <1334052213-26870-1-git-send-email-david@fromorbit.com>
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

These 3 patches sit on top of my recent series titled:

[PATCH 0/8] xfs: clean up unit usage in xfs_buf V2

These patches remove bits of the API that are effectively the
default behaviour used by everything or are redundant. This just
makes API usage simpler and gives it a smaller footprint to modify
in future.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
