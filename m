Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF5FF7F37
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 18:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDF07304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:37:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KO2zcyFESuS2BdfG for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 16:37:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQQY1-0005z5-EF
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 09:37:09 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQQY1-0003W5-D5
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 09:37:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: candidate fixes for 3.12-rc4
Date: Mon, 30 Sep 2013 09:37:02 +1000
Message-Id: <1380497826-13474-1-git-send-email-david@fromorbit.com>
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

The first two patches are regressions and hence -rc4 candidates -
the first patch fixes a lockdep false positive as a result of adding
the third quota inode, and the second fixes a on-disk format
interpretation problem in the v4 superblock dtype-in-dirent feature.

The third patch fixes the AGF vs AGI lock inversion problem I
reported a short while ago, and the last reduces the overhead of
atomic version change accounting. These two aren't critical fixes,
but would be nice to have out there for 3.12.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
