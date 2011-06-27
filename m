Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5R5nHbN050430 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 00:49:17 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0B403040E
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2011 22:49:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	b6BxONPtzGfklej4 for <xfs@oss.sgi.com>;
	Sun, 26 Jun 2011 22:49:16 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qb4gw-0004J1-W6
	for xfs@oss.sgi.com; Mon, 27 Jun 2011 15:49:03 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qb4gg-0000Kk-M8
	for xfs@oss.sgi.com; Mon, 27 Jun 2011 15:48:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 0/4] xfstests: fsx is fallocate
	challenged.
Date: Mon, 27 Jun 2011 15:48:38 +1000
Message-Id: <1309153722-1231-1-git-send-email-david@fromorbit.com>
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

The first three patches make fsx use fallocate/fpunch correctly.
Hole punching is not detected correctly, falloc/fpunch operations
can't actually be executed properly, and the logdump code will segv
on the first falloc operation it finds in the log.

The last patch widens the fsx coverage to mix direct IO reads/writes
with mmapped reads/writes as that was the test case that it was
executing (instead of using falloc/fpunch!) when it triggered the
error (a real bug) that lead to me finding this mess....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
