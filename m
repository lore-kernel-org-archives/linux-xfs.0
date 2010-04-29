Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T0EemP020668 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:14:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70C781AF2711
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 17:16:44 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	dsXMxQyFRtGleb98 for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 17:16:44 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	22474275-1927428
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 09:46:43 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O7HQh-0007Pm-T1
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:16:35 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O7HQY-0007ew-6O
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:16:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfstests: miscellaneous patches
Date: Thu, 29 Apr 2010 10:16:23 +1000
Message-Id: <1272500186-29393-1-git-send-email-david@fromorbit.com>
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


I've been carrying the following patches in my workarea for some time now. I
figure I'm always applying them, so I might as well push them upstream.
The first makes 030 pass again by filtering out the additional verbose messages
that the latest repair has. The second adds more debug to test 222 so that if
it fails theres a better chance of working out what went wrong. The last
patch enables debian platforms to configure and compile dbtest and hence run
test 10.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
