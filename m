Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT0J5cX069749 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 18:19:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 322441C78F0F
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:20:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	vC2jrMIx36RKJEKC for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:20:46 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48410834-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 10:50:44 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMrU3-0000VV-Lv
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:20:43 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMrTo-00049b-FZ
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:20:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: fixes for 2.6.37-rcX
Date: Mon, 29 Nov 2010 11:20:19 +1100
Message-Id: <1290990024-15898-1-git-send-email-david@fromorbit.com>
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

Alex,

This is my curent set of fixes needed for 2.6.37-rcX. I've already posted the
truncation fix and the stale buffer fixes, as well as the xfs_error_test
optimisation. The other two fixes I have extracted from my current scalability
patch set. They correct the invalid assumption that that ther eare no delayed
allocation blocks left on a file after writeback and prevent stale inodes from
being re-inserted into the AIL after the stale buffer behind them has been torn
down.

Let me know how you want me to post the final versions for you to pull into the
XFS tree. (i.e. do you want them in a git tree branch?)

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
