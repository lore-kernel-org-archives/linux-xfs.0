Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBL08FLA199485 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 18:08:16 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZVot0xboBwx2FJma for <xfs@oss.sgi.com>;
	Tue, 20 Dec 2011 16:08:14 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Rd9ij-0000QO-U5
	for xfs@oss.sgi.com; Wed, 21 Dec 2011 11:07:45 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Rd9ij-0005bW-Mc
	for xfs@oss.sgi.com; Wed, 21 Dec 2011 11:07:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2]: xfs - fixes found with sparse checking
Date: Wed, 21 Dec 2011 11:07:40 +1100
Message-Id: <1324426062-21505-1-git-send-email-david@fromorbit.com>
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

There are a few minor issues. The first patch are all really just
cleanups that don't change functionality. The second patch fixes a
real bug that we need to consider backporting to stable releases.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
