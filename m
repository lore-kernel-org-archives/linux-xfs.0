Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p680s4Kl204468 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 19:54:05 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE736E8E8BA
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 17:54:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gNEeCLUkzH384nm3 for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 17:54:02 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QezKI-0003R6-4r
	for xfs@oss.sgi.com; Fri, 08 Jul 2011 10:53:50 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QezKH-0007yL-3T
	for xfs@oss.sgi.com; Fri, 08 Jul 2011 10:53:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4, V2] xfstests: fsx is fallocate challenged
Date: Fri,  8 Jul 2011 10:53:42 +1000
Message-Id: <1310086426-30605-1-git-send-email-david@fromorbit.com>
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

This is a repost of the fsx fallocate/fpunch operation handling
fixes along with additional tests added to 091 to cover the failing
test cases that exposed the fallocate/fpunch operation handling
problems.

Version 2 fixes the review coments of the first version. The main
change is to re-number all the operations and use those directly to
generate the operations to execute.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
