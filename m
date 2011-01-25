Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P3wvdO176082 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 21:58:58 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFCE98A549E
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 20:01:18 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4BHTgXyqm086ZYZQ for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 20:01:18 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Pha5j-0003To-5I
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 15:01:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pha3Y-0005Na-MS
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 14:59:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfstests: new tests and fixes
Date: Tue, 25 Jan 2011 14:58:53 +1100
Message-Id: <1295927937-20634-1-git-send-email-david@fromorbit.com>
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

Pushing out my current stack:

	- Fix test 016 to work with delaylog.
	- Speed up 042 by using preallocation instead of writing
	  data and files.
	- Add test to exercise bmap btree corruption caused by
	  multilevel split.
	- Add simple test to exercise splice writes to catch locking
	  issues.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
